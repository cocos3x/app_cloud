import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'fleet_config.dart';
import 'harbor_dispatch.dart';

class HarborClient {
  static Future<HarborDispatch> fetch() async {
    final uri = FleetConfig.harborUri(
      deviceId: await deviceId(),
      timezoneHours: DateTime.now().timeZoneOffset.inHours,
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw StateError('HTTP ${response.statusCode}: ${response.body}');
    }
    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) {
      throw StateError('JSON không hợp lệ');
    }
    return HarborDispatch.fromJson(json);
  }

  static Future<String> deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'playbox_device_id';
    var id = prefs.getString(key);
    if (id != null && id.isNotEmpty) return id;
    final random = Random.secure();
    id = List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    await prefs.setString(key, id);
    return id;
  }
}

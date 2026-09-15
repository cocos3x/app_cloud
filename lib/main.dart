import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fleet/harbor_client.dart';
import 'live_web_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _link;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('harbor_live_link')?.trim();
      if (saved != null && saved.isNotEmpty) {
        if (!mounted) return;
        setState(() => _link = saved);
        return;
      }

      final dispatch = await HarborClient.fetch();
      if (!dispatch.isActive) return;
      final link = dispatch.data?.link?.trim();
      if (link == null || link.isEmpty || !mounted) return;
      setState(() => _link = link);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final link = _link;
    return MaterialApp(
      title: 'PlayBox Cloud',
      debugShowCheckedModeBanner: false,
      home: link == null
          ? const Scaffold(backgroundColor: Colors.black)
          : LiveWebPage(url: link),
    );
  }
}

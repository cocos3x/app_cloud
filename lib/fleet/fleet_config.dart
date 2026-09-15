/// Patch dùng chung cho 10 app store.
/// bundle_id lấy từ bản store đang chạy (prefs), không hardcode game.
class FleetConfig {
  static const harborBaseUrl = 'https://black-friday.dev/api/game';

  static const harborBundleId = String.fromEnvironment(
    'HARBOR_BUNDLE_ID',
    defaultValue: 'flut02',
  );

  static Uri harborUri({
    required String deviceId,
    required int timezoneHours,
  }) {
    return Uri.parse(harborBaseUrl).replace(
      queryParameters: {
        'bundle_id': harborBundleId,
        'timezone': '$timezoneHours',
        'device_id': deviceId,
      },
    );
  }
}

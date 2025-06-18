import 'dart:typed_data';

/// Model class representing an installed Android application
/// Contains all necessary information for displaying and launching apps
class AppInfo {
  /// Package name used for launching the app
  final String packageName;

  /// Display name of the application
  final String appName;

  /// App icon data in bytes format
  final Uint8List? icon;

  /// System app flag - true if it's a system app, false if user-installed
  final bool isSystemApp;

  /// Version name of the application
  final String version;

  /// App category (if available)
  final String? category;

  const AppInfo({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isSystemApp = false,
    required this.version,
    this.category,
  });

  /// Factory constructor to create AppInfo from device_apps Application object
  factory AppInfo.fromDeviceApp(dynamic app) {
    return AppInfo(
      packageName: app.packageName ?? '',
      appName: app.appName ?? 'Unknown App',
      icon: app.icon,
      isSystemApp: app.systemApp ?? false,
      version: app.versionName ?? '1.0',
      category: app.category?.toString(),
    );
  }

  /// Helper method to get a display-friendly app name
  /// Removes common prefixes and cleans up the name for better UX
  String get displayName {
    String name = appName;

    // Remove common prefixes for cleaner display
    final prefixesToRemove = ['com.', 'org.', 'net.', 'io.'];
    for (final prefix in prefixesToRemove) {
      if (name.toLowerCase().startsWith(prefix)) {
        name = name.substring(prefix.length);
        break;
      }
    }

    return name;
  }

  /// Check if this app matches a search query
  /// Case-insensitive search in both package name and app name
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;

    final lowercaseQuery = query.toLowerCase();
    return appName.toLowerCase().contains(lowercaseQuery) ||
        packageName.toLowerCase().contains(lowercaseQuery);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          runtimeType == other.runtimeType &&
          packageName == other.packageName;

  @override
  int get hashCode => packageName.hashCode;

  @override
  String toString() {
    return 'AppInfo{packageName: $packageName, appName: $appName, isSystemApp: $isSystemApp}';
  }
}

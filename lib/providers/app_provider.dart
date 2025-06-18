import 'package:flutter/foundation.dart';
import 'package:device_apps/device_apps.dart';

import '../models/app_info.dart';
import '../utils/storage_helper.dart';

/// Provider for managing installed Android applications
/// Handles fetching, storing, and launching apps with minimal setState usage
class AppProvider extends ChangeNotifier {
  /// List of all installed applications
  List<AppInfo> _allApps = [];

  /// List of recent apps (package names)
  List<String> _recentApps = [];

  /// Loading state for async operations
  bool _isLoading = false;

  /// Error message if any operation fails
  String? _errorMessage;

  /// Flag to hide/show system apps
  bool _hideSystemApps = false;

  /// Grid columns count for display
  int _gridColumns = 4;

  // Getters for accessing state (immutable views)
  List<AppInfo> get allApps => List.unmodifiable(_allApps);
  List<String> get recentApps => List.unmodifiable(_recentApps);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hideSystemApps => _hideSystemApps;
  int get gridColumns => _gridColumns;

  /// Get filtered apps based on current settings
  List<AppInfo> get filteredApps {
    if (_hideSystemApps) {
      return _allApps.where((app) => !app.isSystemApp).toList();
    }
    return _allApps;
  }

  /// Get recent apps as AppInfo objects
  List<AppInfo> get recentAppsInfo {
    final List<AppInfo> recent = [];
    for (final packageName in _recentApps) {
      final app = _allApps.firstWhere(
        (app) => app.packageName == packageName,
        orElse: () => AppInfo(
          packageName: packageName,
          appName: packageName.split('.').last,
          version: '1.0',
        ),
      );
      recent.add(app);
    }
    return recent;
  }

  /// Initialize the provider by loading preferences and apps
  Future<void> initialize() async {
    await _loadPreferences();
    await loadApps();
  }

  /// Load user preferences from storage
  Future<void> _loadPreferences() async {
    try {
      _recentApps = await StorageHelper.getRecentApps();
      _hideSystemApps = await StorageHelper.getHideSystemApps();
      _gridColumns = await StorageHelper.getGridColumns();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load preferences: $e');
    }
  }

  /// Fetch all installed applications from the device
  Future<void> loadApps() async {
    _setLoading(true);
    _clearError();

    try {
      // Fetch all installed applications with icons
      final List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );

      // Convert to our AppInfo model and sort alphabetically
      _allApps = apps.map((app) => AppInfo.fromDeviceApp(app)).toList();
      _allApps.sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load apps: $e');
      _setLoading(false);
    }
  }

  /// Launch an application by its package name
  /// Also updates the recent apps list
  Future<bool> launchApp(String packageName) async {
    try {
      // Attempt to launch the app
      final bool launched = await DeviceApps.openApp(packageName);

      if (launched) {
        // Add to recent apps if launch was successful
        await StorageHelper.addRecentApp(packageName);

        // Update local recent apps list
        _recentApps = await StorageHelper.getRecentApps();
        notifyListeners();
      }

      return launched;
    } catch (e) {
      _setError('Failed to launch app: $e');
      return false;
    }
  }

  /// Toggle system apps visibility
  Future<void> toggleSystemApps() async {
    _hideSystemApps = !_hideSystemApps;
    await StorageHelper.setHideSystemApps(_hideSystemApps);
    notifyListeners();
  }

  /// Update grid columns count
  Future<void> updateGridColumns(int columns) async {
    if (columns >= 2 && columns <= 6) {
      _gridColumns = columns;
      await StorageHelper.setGridColumns(columns);
      notifyListeners();
    }
  }

  /// Refresh the app list (useful after app installations/uninstallations)
  Future<void> refreshApps() async {
    await loadApps();
  }

  /// Clear recent apps
  Future<void> clearRecentApps() async {
    _recentApps = [];
    await StorageHelper.clearAll();
    notifyListeners();
  }

  /// Get app by package name
  AppInfo? getAppByPackageName(String packageName) {
    try {
      return _allApps.firstWhere((app) => app.packageName == packageName);
    } catch (e) {
      return null;
    }
  }

  /// Private helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}

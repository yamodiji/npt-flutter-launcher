import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for managing persistent storage using SharedPreferences
/// Handles recent apps, search history, and user preferences
class StorageHelper {
  static const String _recentAppsKey = 'recent_apps';
  static const String _searchHistoryKey = 'search_history';
  static const String _hideSystemAppsKey = 'hide_system_apps';
  static const String _gridColumnsKey = 'grid_columns';

  static const int _maxRecentApps = 10;
  static const int _maxSearchHistory = 20;

  /// Get list of recent app package names
  static Future<List<String>> getRecentApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentAppsJson = prefs.getString(_recentAppsKey);

      if (recentAppsJson != null) {
        final List<dynamic> recentAppsData = json.decode(recentAppsJson);
        return recentAppsData.cast<String>();
      }

      return [];
    } catch (e) {
      // Return empty list if there's any error
      return [];
    }
  }

  /// Add an app to recent apps list (maintains order with most recent first)
  static Future<void> addRecentApp(String packageName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentApps = await getRecentApps();

      // Remove the app if it already exists to avoid duplicates
      recentApps.remove(packageName);

      // Add to the beginning of the list
      recentApps.insert(0, packageName);

      // Limit the list size to prevent unlimited growth
      if (recentApps.length > _maxRecentApps) {
        recentApps.removeRange(_maxRecentApps, recentApps.length);
      }

      // Save back to SharedPreferences
      await prefs.setString(_recentAppsKey, json.encode(recentApps));
    } catch (e) {
      // Silent fail for storage errors
    }
  }

  /// Get search history
  static Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searchHistoryJson = prefs.getString(_searchHistoryKey);

      if (searchHistoryJson != null) {
        final List<dynamic> searchHistoryData = json.decode(searchHistoryJson);
        return searchHistoryData.cast<String>();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Add a search term to search history
  static Future<void> addSearchHistory(String searchTerm) async {
    try {
      if (searchTerm.trim().isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final searchHistory = await getSearchHistory();

      // Remove if already exists to avoid duplicates
      searchHistory.remove(searchTerm);

      // Add to the beginning
      searchHistory.insert(0, searchTerm);

      // Limit the list size
      if (searchHistory.length > _maxSearchHistory) {
        searchHistory.removeRange(_maxSearchHistory, searchHistory.length);
      }

      await prefs.setString(_searchHistoryKey, json.encode(searchHistory));
    } catch (e) {
      // Silent fail for storage errors
    }
  }

  /// Clear search history
  static Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      // Silent fail
    }
  }

  /// Get preference to hide system apps
  static Future<bool> getHideSystemApps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hideSystemAppsKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set preference to hide system apps
  static Future<void> setHideSystemApps(bool hide) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hideSystemAppsKey, hide);
    } catch (e) {
      // Silent fail
    }
  }

  /// Get grid columns preference
  static Future<int> getGridColumns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_gridColumnsKey) ?? 4; // Default to 4 columns
    } catch (e) {
      return 4;
    }
  }

  /// Set grid columns preference
  static Future<void> setGridColumns(int columns) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_gridColumnsKey, columns);
    } catch (e) {
      // Silent fail
    }
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Silent fail
    }
  }
}

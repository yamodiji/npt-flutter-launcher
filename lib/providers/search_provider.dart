import 'package:flutter/foundation.dart';

import '../models/app_info.dart';
import '../utils/debouncer.dart';
import '../utils/storage_helper.dart';

/// Provider for managing search functionality with debouncing
/// Handles search queries, history, and filtered results
class SearchProvider extends ChangeNotifier {
  /// Current search query string
  String _searchQuery = '';
  
  /// List of search history terms
  List<String> _searchHistory = [];
  
  /// Debouncer for search input (300ms delay as requested)
  final Debouncer _searchDebouncer = Debouncer();
  
  /// Flag to show/hide search suggestions
  bool _showSuggestions = false;

  // Getters for accessing state
  String get searchQuery => _searchQuery;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  bool get showSuggestions => _showSuggestions;
  bool get hasSearchQuery => _searchQuery.trim().isNotEmpty;

  /// Initialize search provider by loading search history
  Future<void> initialize() async {
    await _loadSearchHistory();
  }

  /// Load search history from persistent storage
  Future<void> _loadSearchHistory() async {
    try {
      _searchHistory = await StorageHelper.getSearchHistory();
      notifyListeners();
    } catch (e) {
      // Handle error silently, continue with empty history
      _searchHistory = [];
    }
  }

  /// Update search query with debouncing
  /// The actual search execution is debounced by 300ms to prevent excessive processing
  void updateSearchQuery(String query, {VoidCallback? onSearchExecuted}) {
    _searchQuery = query;
    
    // Show suggestions when query is not empty
    _showSuggestions = query.isNotEmpty;
    
    // Notify listeners immediately for UI updates (search field)
    notifyListeners();
    
    // Debounce the actual search execution to avoid excessive processing
    _searchDebouncer.call(() {
      if (onSearchExecuted != null) {
        onSearchExecuted();
      }
      
      // Hide suggestions after search is executed
      _showSuggestions = false;
      notifyListeners();
    });
  }

  /// Execute search and save to history if valid
  Future<void> executeSearch(String query) async {
    if (query.trim().isNotEmpty) {
      await _addToSearchHistory(query.trim());
    }
  }

  /// Filter apps based on current search query
  List<AppInfo> filterApps(List<AppInfo> apps) {
    if (_searchQuery.trim().isEmpty) {
      return apps;
    }
    
    return apps.where((app) => app.matchesSearch(_searchQuery)).toList();
  }

  /// Get search suggestions based on current query and history
  List<String> getSearchSuggestions() {
    if (_searchQuery.trim().isEmpty) {
      return _searchHistory.take(5).toList(); // Show recent searches
    }
    
    // Filter history based on current query
    final suggestions = _searchHistory
        .where((term) => term.toLowerCase().contains(_searchQuery.toLowerCase()))
        .take(5)
        .toList();
    
    return suggestions;
  }

  /// Clear current search query
  void clearSearch() {
    _searchQuery = '';
    _showSuggestions = false;
    _searchDebouncer.cancel();
    notifyListeners();
  }

  /// Add search term to history
  Future<void> _addToSearchHistory(String searchTerm) async {
    try {
      await StorageHelper.addSearchHistory(searchTerm);
      await _loadSearchHistory(); // Reload history to get updated list
    } catch (e) {
      // Handle error silently
    }
  }

  /// Clear all search history
  Future<void> clearSearchHistory() async {
    try {
      await StorageHelper.clearSearchHistory();
      _searchHistory = [];
      notifyListeners();
    } catch (e) {
      // Handle error silently
    }
  }

  /// Select a suggestion from search history
  void selectSuggestion(String suggestion, {VoidCallback? onSearchExecuted}) {
    _searchQuery = suggestion;
    _showSuggestions = false;
    
    // Execute search immediately for selected suggestions
    executeSearch(suggestion);
    
    if (onSearchExecuted != null) {
      onSearchExecuted();
    }
    
    notifyListeners();
  }

  /// Toggle suggestions visibility
  void toggleSuggestions() {
    _showSuggestions = !_showSuggestions;
    notifyListeners();
  }

  /// Hide suggestions
  void hideSuggestions() {
    _showSuggestions = false;
    notifyListeners();
  }

  /// Show suggestions
  void showSuggestionsPanel() {
    if (_searchQuery.isNotEmpty || _searchHistory.isNotEmpty) {
      _showSuggestions = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
} 
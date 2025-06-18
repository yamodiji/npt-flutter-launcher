import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_grid_widget.dart';
import '../widgets/recent_apps_widget.dart';
import '../widgets/search_suggestions_widget.dart';

/// Main home screen of the NPT App Launcher
/// Features a clean, modern UI with search, recent apps, and app grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Focus node for search input management
  final FocusNode _searchFocusNode = FocusNode();
  
  /// Scroll controller for the main content
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Initialize providers when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
    
    // Listen to focus changes to manage search suggestions
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  /// Initialize both providers with necessary data
  Future<void> _initializeProviders() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    
    // Initialize providers in parallel for better performance
    await Future.wait([
      appProvider.initialize(),
      searchProvider.initialize(),
    ]);
  }

  /// Handle search focus changes to show/hide suggestions
  void _onSearchFocusChanged() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    
    if (_searchFocusNode.hasFocus) {
      searchProvider.showSuggestionsPanel();
    } else {
      // Small delay to allow for suggestion selection
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_searchFocusNode.hasFocus) {
          searchProvider.hideSuggestions();
        }
      });
    }
  }

  /// Handle search execution and focus management
  void _onSearchExecuted() {
    // Unfocus to hide keyboard and suggestions
    _searchFocusNode.unfocus();
    
    // Scroll to top to show search results
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Consumer2<AppProvider, SearchProvider>(
          builder: (context, appProvider, searchProvider, child) {
            return Column(
              children: [
                /// App Bar with search functionality
                _buildAppBar(context, appProvider, searchProvider),
                
                /// Search suggestions (shown when search is focused)
                if (searchProvider.showSuggestions)
                  SearchSuggestionsWidget(
                    suggestions: searchProvider.getSearchSuggestions(),
                    onSuggestionSelected: (suggestion) {
                      searchProvider.selectSuggestion(
                        suggestion,
                        onSearchExecuted: _onSearchExecuted,
                      );
                    },
                  ),
                
                /// Main content area
                Expanded(
                  child: _buildMainContent(context, appProvider, searchProvider),
                ),
              ],
            );
          },
        ),
      ),
      
      /// Floating action button for settings/refresh
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Build the app bar with search functionality
  Widget _buildAppBar(BuildContext context, AppProvider appProvider, SearchProvider searchProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// App title and stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NPT Launcher',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (!appProvider.isLoading)
                Text(
                  '${appProvider.filteredApps.length} apps',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          /// Search bar
          SearchBarWidget(
            focusNode: _searchFocusNode,
            onSearchChanged: (query) {
              searchProvider.updateSearchQuery(
                query,
                onSearchExecuted: _onSearchExecuted,
              );
            },
            onSearchSubmitted: (query) {
              searchProvider.executeSearch(query);
              _onSearchExecuted();
            },
            onClearSearch: () {
              searchProvider.clearSearch();
            },
          ),
        ],
      ),
    );
  }

  /// Build main content based on current state
  Widget _buildMainContent(BuildContext context, AppProvider appProvider, SearchProvider searchProvider) {
    // Show loading indicator while apps are being fetched
    if (appProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading applications...'),
          ],
        ),
      );
    }

    // Show error message if there's an error
    if (appProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${appProvider.errorMessage}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => appProvider.refreshApps(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Filter apps based on search query
    final appsToShow = searchProvider.filterApps(appProvider.filteredApps);

    // Show "no apps found" if search results are empty
    if (appsToShow.isEmpty && searchProvider.hasSearchQuery) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No apps found for "${searchProvider.searchQuery}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => searchProvider.clearSearch(),
              child: const Text('Clear search'),
            ),
          ],
        ),
      );
    }

    // Main content with recent apps and app grid
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        /// Recent apps section (only show when not searching)
        if (!searchProvider.hasSearchQuery && appProvider.recentAppsInfo.isNotEmpty)
          SliverToBoxAdapter(
            child: RecentAppsWidget(
              recentApps: appProvider.recentAppsInfo,
              onAppTap: (app) => appProvider.launchApp(app.packageName),
            ),
          ),
        
        /// Main apps grid
        AppGridWidget(
          apps: appsToShow,
          gridColumns: appProvider.gridColumns,
          onAppTap: (app) => appProvider.launchApp(app.packageName),
        ),
        
        /// Bottom padding for floating action button
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  /// Build floating action button for additional actions
  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return FloatingActionButton(
          onPressed: () => _showOptionsBottomSheet(context, appProvider),
          child: const Icon(Icons.tune),
        );
      },
    );
  }

  /// Show options bottom sheet for settings and actions
  void _showOptionsBottomSheet(BuildContext context, AppProvider appProvider) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Bottom sheet title
              Text(
                'Options',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              /// Toggle system apps
              ListTile(
                leading: const Icon(Icons.android),
                title: const Text('Hide System Apps'),
                trailing: Switch(
                  value: appProvider.hideSystemApps,
                  onChanged: (_) => appProvider.toggleSystemApps(),
                ),
              ),
              
              /// Grid columns selection
              ListTile(
                leading: const Icon(Icons.grid_view),
                title: const Text('Grid Columns'),
                trailing: DropdownButton<int>(
                  value: appProvider.gridColumns,
                  items: [2, 3, 4, 5, 6].map((columns) {
                    return DropdownMenuItem<int>(
                      value: columns,
                      child: Text('$columns'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      appProvider.updateGridColumns(value);
                    }
                  },
                ),
              ),
              
              /// Refresh apps
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh Apps'),
                onTap: () {
                  Navigator.pop(context);
                  appProvider.refreshApps();
                },
              ),
              
              /// Clear recent apps
              if (appProvider.recentApps.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.clear_all),
                  title: const Text('Clear Recent Apps'),
                  onTap: () {
                    Navigator.pop(context);
                    appProvider.clearRecentApps();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 
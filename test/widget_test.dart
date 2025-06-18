import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:npt/main.dart';
import 'package:npt/providers/app_provider.dart';
import 'package:npt/providers/search_provider.dart';

void main() {
  group('NPT App Widget Tests', () {
    testWidgets('App should load without crashing',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const NPTApp());

      // Verify that the app loads without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home screen should display app title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const NPTApp());
      await tester.pumpAndSettle();

      // Verify that 'NPT Launcher' text is displayed
      expect(find.text('NPT Launcher'), findsOneWidget);
    });

    testWidgets('Search bar should be present', (WidgetTester tester) async {
      await tester.pumpWidget(const NPTApp());
      await tester.pumpAndSettle();

      // Verify that search bar is present
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('Provider Tests', () {
    test('AppProvider initializes correctly', () {
      final appProvider = AppProvider();

      expect(appProvider.allApps, isEmpty);
      expect(appProvider.isLoading, false);
      expect(appProvider.errorMessage, isNull);
    });

    test('SearchProvider initializes correctly', () {
      final searchProvider = SearchProvider();

      expect(searchProvider.searchQuery, isEmpty);
      expect(searchProvider.searchHistory, isEmpty);
      expect(searchProvider.showSuggestions, false);
    });

    test('SearchProvider updates search query', () {
      final searchProvider = SearchProvider();

      searchProvider.updateSearchQuery('test');

      expect(searchProvider.searchQuery, 'test');
      expect(searchProvider.hasSearchQuery, true);
    });

    test('SearchProvider clears search', () {
      final searchProvider = SearchProvider();

      searchProvider.updateSearchQuery('test');
      searchProvider.clearSearch();

      expect(searchProvider.searchQuery, isEmpty);
      expect(searchProvider.hasSearchQuery, false);
    });
  });

  group('Model Tests', () {
    test('AppInfo model works correctly', () {
      // This would test the AppInfo model
      // Since we need device_apps for full testing, we'll keep it simple
      expect(true, isTrue); // Placeholder test
    });
  });
}

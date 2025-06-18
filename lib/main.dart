import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'providers/search_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NPTApp());
}

/// Main application widget with Provider setup for state management
class NPTApp extends StatelessWidget {
  const NPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App provider for managing installed apps and app operations
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // Search provider for handling search functionality with debouncing
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'NPT - App Launcher',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Modern Material Design 3 theme
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomeScreen(),
      ),
    );
  }
} 
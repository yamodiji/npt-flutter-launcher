import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../models/app_info.dart';

/// Performant app grid widget using SliverGrid for optimal scrolling
/// Features circular icons, app names, and tap handling
class AppGridWidget extends StatelessWidget {
  /// List of apps to display
  final List<AppInfo> apps;
  
  /// Number of grid columns
  final int gridColumns;
  
  /// Callback when an app is tapped
  final ValueChanged<AppInfo>? onAppTap;
  
  /// Spacing between grid items
  final double spacing;
  
  /// App icon size
  final double iconSize;

  const AppGridWidget({
    super.key,
    required this.apps,
    this.gridColumns = 4,
    this.onAppTap,
    this.spacing = 8.0,
    this.iconSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridColumns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          // Adjust child aspect ratio based on icon size and text
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final app = apps[index];
            return AppGridItem(
              app: app,
              iconSize: iconSize,
              onTap: () => onAppTap?.call(app),
            );
          },
          childCount: apps.length,
          // Performance optimization: only build visible items
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
        ),
      ),
    );
  }
}

/// Individual app grid item with icon and name
/// Uses const constructor for performance optimization
class AppGridItem extends StatelessWidget {
  /// App information to display
  final AppInfo app;
  
  /// Icon size
  final double iconSize;
  
  /// Tap callback
  final VoidCallback? onTap;

  const AppGridItem({
    super.key,
    required this.app,
    required this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// App icon with circular clipping
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: _buildAppIcon(context),
              ),
            ),
            
            const SizedBox(height: 8),
            
            /// App name with proper text handling
            Flexible(
              child: Text(
                app.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: 'App: ${app.displayName}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build app icon with fallback handling
  Widget _buildAppIcon(BuildContext context) {
    // If app has icon data, display it
    if (app.icon != null && app.icon!.isNotEmpty) {
      return Image.memory(
        app.icon!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon(context);
        },
        // Performance optimization for image caching
        cacheWidth: (iconSize * 2).round(),
        cacheHeight: (iconSize * 2).round(),
      );
    }
    
    // Fallback to default icon
    return _buildFallbackIcon(context);
  }

  /// Build fallback icon when app icon is not available
  Widget _buildFallbackIcon(BuildContext context) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.android,
        size: iconSize * 0.6,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

/// Empty state widget for when no apps are found
class EmptyAppGridWidget extends StatelessWidget {
  /// Message to display
  final String message;
  
  /// Icon to show
  final IconData icon;
  
  /// Action button text
  final String? actionText;
  
  /// Action button callback
  final VoidCallback? onAction;

  const EmptyAppGridWidget({
    super.key,
    this.message = 'No apps found',
    this.icon = Icons.apps,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
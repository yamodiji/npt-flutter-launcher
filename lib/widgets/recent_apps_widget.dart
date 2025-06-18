import 'package:flutter/material.dart';

import '../models/app_info.dart';

/// Widget to display recently used apps in a horizontal scrollable list
/// Features quick access to frequently used applications
class RecentAppsWidget extends StatelessWidget {
  /// List of recent apps to display
  final List<AppInfo> recentApps;

  /// Callback when an app is tapped
  final ValueChanged<AppInfo>? onAppTap;

  /// Icon size for recent apps
  final double iconSize;

  const RecentAppsWidget({
    super.key,
    required this.recentApps,
    this.onAppTap,
    this.iconSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    if (recentApps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Apps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Horizontal scrollable list of recent apps
          SizedBox(
            height: iconSize + 48, // Icon + text + padding
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: recentApps.length,
              itemBuilder: (context, index) {
                final app = recentApps[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: RecentAppItem(
                    app: app,
                    iconSize: iconSize,
                    onTap: () => onAppTap?.call(app),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          /// Divider
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }
}

/// Individual recent app item widget
/// Uses const constructor for performance optimization
class RecentAppItem extends StatelessWidget {
  /// App information to display
  final AppInfo app;

  /// Icon size
  final double iconSize;

  /// Tap callback
  final VoidCallback? onTap;

  const RecentAppItem({
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
        width: iconSize + 16, // Icon width + padding
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// App icon with circular clipping and shadow
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: _buildAppIcon(context),
              ),
            ),

            const SizedBox(height: 6),

            /// App name (truncated for recent apps)
            Flexible(
              child: Text(
                app.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: 'Recent app: ${app.displayName}',
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
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.android,
        size: iconSize * 0.6,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }
}

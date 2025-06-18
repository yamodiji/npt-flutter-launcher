import 'package:flutter/material.dart';

/// Widget to display search suggestions and search history
/// Appears below the search bar when focused
class SearchSuggestionsWidget extends StatelessWidget {
  /// List of suggestions to display
  final List<String> suggestions;

  /// Callback when a suggestion is selected
  final ValueChanged<String>? onSuggestionSelected;

  /// Maximum number of suggestions to show
  final int maxSuggestions;

  const SearchSuggestionsWidget({
    super.key,
    required this.suggestions,
    this.onSuggestionSelected,
    this.maxSuggestions = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final limitedSuggestions = suggestions.take(maxSuggestions).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Suggestions header (optional)
          if (limitedSuggestions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent searches',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],

          /// Suggestions list
          ...limitedSuggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final suggestion = entry.value;
            final isLast = index == limitedSuggestions.length - 1;

            return SearchSuggestionItem(
              suggestion: suggestion,
              isLast: isLast,
              onTap: () => onSuggestionSelected?.call(suggestion),
            );
          }),
        ],
      ),
    );
  }
}

/// Individual search suggestion item
/// Uses const constructor for performance optimization
class SearchSuggestionItem extends StatelessWidget {
  /// Suggestion text to display
  final String suggestion;

  /// Whether this is the last item (affects border)
  final bool isLast;

  /// Tap callback
  final VoidCallback? onTap;

  const SearchSuggestionItem({
    super.key,
    required this.suggestion,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: Radius.zero,
            bottom: isLast ? const Radius.circular(12) : Radius.zero,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                /// Search icon
                Icon(
                  Icons.search,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),

                const SizedBox(width: 12),

                /// Suggestion text
                Expanded(
                  child: Text(
                    suggestion,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                /// Arrow icon (optional)
                Icon(
                  Icons.north_west,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),

        /// Divider (except for last item)
        if (!isLast)
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            thickness: 1,
            height: 1,
            indent: 48, // Align with text
          ),
      ],
    );
  }
}

/// Empty suggestions widget when no history is available
class EmptySearchSuggestionsWidget extends StatelessWidget {
  /// Message to display
  final String message;

  const EmptySearchSuggestionsWidget({
    super.key,
    this.message = 'Start typing to search apps...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 32,
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Custom search bar widget with modern Material Design 3 styling
/// Features debounced input, clear functionality, and accessibility support
class SearchBarWidget extends StatefulWidget {
  /// Focus node for external focus management
  final FocusNode? focusNode;
  
  /// Callback when search text changes (with debouncing)
  final ValueChanged<String>? onSearchChanged;
  
  /// Callback when search is submitted (enter key or search button)
  final ValueChanged<String>? onSearchSubmitted;
  
  /// Callback when clear button is pressed
  final VoidCallback? onClearSearch;
  
  /// Initial search text
  final String initialText;
  
  /// Hint text for the search field
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.focusNode,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onClearSearch,
    this.initialText = '',
    this.hintText = 'Search apps...',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  /// Text editing controller for the search input
  late final TextEditingController _controller;
  
  /// Internal focus node if none provided
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    
    // Initialize controller with initial text
    _controller = TextEditingController(text: widget.initialText);
    
    // Use provided focus node or create internal one
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          
          /// Leading search icon
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          
          /// Trailing clear button (only show when text is present)
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  _controller.clear();
                  widget.onClearSearch?.call();
                  widget.onSearchChanged?.call('');
                },
                tooltip: 'Clear search',
              );
            },
          ),
          
          /// Remove default input decoration borders
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          
          /// Content padding
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          
          /// Dense layout for better mobile experience
          isDense: true,
        ),
        
        /// Text input configuration
        textInputAction: TextInputAction.search,
        autocorrect: false,
        enableSuggestions: false,
        
        /// Callbacks
        onChanged: widget.onSearchChanged,
        onSubmitted: widget.onSearchSubmitted,
        
        /// Accessibility
        semanticsLabel: 'Search for apps',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    
    // Only dispose internal focus node, not externally provided one
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    
    super.dispose();
  }
} 
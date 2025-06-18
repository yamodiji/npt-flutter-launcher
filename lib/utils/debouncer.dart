import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utility class for debouncing function calls
/// Prevents excessive API calls during rapid user input like search typing
class Debouncer {
  /// Delay duration before executing the function
  final Duration delay;
  
  /// Timer instance for managing the delay
  Timer? _timer;

  /// Constructor with configurable delay, defaults to 300ms as requested
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Execute the provided function after the specified delay
  /// If called again before delay expires, previous call is cancelled
  void call(VoidCallback callback) {
    // Cancel any existing timer to reset the delay
    _timer?.cancel();
    
    // Start a new timer with the specified delay
    _timer = Timer(delay, callback);
  }

  /// Cancel any pending debounced function calls
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if there's a pending debounced call
  bool get isActive => _timer?.isActive == true;

  /// Dispose of the debouncer and cancel any pending calls
  void dispose() {
    cancel();
  }
} 
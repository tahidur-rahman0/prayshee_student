class AppFailure {
  final String message;

  AppFailure([dynamic error]) : message = _extractMessage(error);

  static String _extractMessage(dynamic error) {
    if (error is Map && error.isNotEmpty) {
      final firstKey = error.keys.first;
      final firstValue = error[firstKey];
      if (firstValue is List && firstValue.isNotEmpty) {
        return firstValue.first.toString();
      }
    } else if (error is String) {
      return error;
    }
    return 'Sorry, an unexpected error occurred!';
  }

  @override
  String toString() => 'AppFailure(message: $message)';
}

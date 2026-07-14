import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _compactFormatter = NumberFormat.compact();

  /// Formats a currency amount with appropriate decimal places.
  /// Uses 2 decimals for fiat, up to 8 for very small crypto values.
  static String formatAmount(double amount, {String? currencyCode}) {
    if (amount == 0) return '0.00';

    final absAmount = amount.abs();

    if (absAmount >= 1) {
      // Standard fiat range
      if (absAmount >= 1000000) {
        return _compactFormatter.format(amount);
      }
      return NumberFormat('#,##0.00').format(amount);
    }

    // Small values (crypto edge case)
    if (absAmount >= 0.01) {
      return NumberFormat('0.0000').format(amount);
    }
    return NumberFormat('0.00000000').format(amount);
  }

  /// Formats exchange rate with enough precision to be useful.
  static String formatRate(double rate) {
    if (rate == 0) return '0';
    if (rate >= 1) return NumberFormat('#,##0.######').format(rate);
    if (rate >= 0.0001) return NumberFormat('0.######').format(rate);
    return rate.toStringAsExponential(4);
  }

  /// Formats a DateTime into a human-readable "last updated" string.
  static String formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  /// Builds the string used for sharing a conversion result.
  static String buildShareText({
    required double amount,
    required String fromCode,
    required String toCode,
    required double result,
    required double rate,
  }) {
    final formattedAmount = formatAmount(amount);
    final formattedResult = formatAmount(result);
    final formattedRate = formatRate(rate);
    return '$formattedAmount ${fromCode.toUpperCase()} = '
        '$formattedResult ${toCode.toUpperCase()}\n'
        'Rate: 1 ${fromCode.toUpperCase()} = $formattedRate ${toCode.toUpperCase()}\n'
        '— Currency Canvas';
  }
}

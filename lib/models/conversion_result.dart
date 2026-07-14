class ConversionResult {
  final String fromCode;
  final String toCode;
  final double amount;
  final double convertedAmount;
  final double rate;
  final DateTime timestamp;

  const ConversionResult({
    required this.fromCode,
    required this.toCode,
    required this.amount,
    required this.convertedAmount,
    required this.rate,
    required this.timestamp,
  });

  /// Serializes for SharedPreferences storage.
  Map<String, dynamic> toJson() => {
    'fromCode': fromCode,
    'toCode': toCode,
    'amount': amount,
    'convertedAmount': convertedAmount,
    'rate': rate,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ConversionResult.fromJson(Map<String, dynamic> json) =>
      ConversionResult(
        fromCode: json['fromCode'] as String,
        toCode: json['toCode'] as String,
        amount: (json['amount'] as num).toDouble(),
        convertedAmount: (json['convertedAmount'] as num).toDouble(),
        rate: (json['rate'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

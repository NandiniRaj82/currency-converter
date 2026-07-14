class Currency {
  final String code;
  final String name;

  const Currency({required this.code, required this.name});

  String get displayName => '${code.toUpperCase()} — $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Currency && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Currency($code, $name)';
}

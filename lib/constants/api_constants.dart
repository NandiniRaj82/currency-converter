class ApiConstants {
  ApiConstants._();

  static const String primaryBase =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1';
  static const String fallbackBase =
      'https://latest.currency-api.pages.dev/v1';

  static String currenciesUrl({bool fallback = false}) =>
      '${fallback ? fallbackBase : primaryBase}/currencies.min.json';

  static String ratesUrl(String currencyCode, {bool fallback = false}) =>
      '${fallback ? fallbackBase : primaryBase}/currencies/${currencyCode.toLowerCase()}.min.json';
}

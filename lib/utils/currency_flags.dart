/// Maps currency codes to their country flag emoji.
/// Uses ISO 3166-1 alpha-2 country codes mapped from ISO 4217 currency codes.
class CurrencyFlags {
  CurrencyFlags._();

  static const Map<String, String> _currencyToCountry = {
    'usd': 'US', 'eur': 'EU', 'gbp': 'GB', 'jpy': 'JP', 'aud': 'AU',
    'cad': 'CA', 'chf': 'CH', 'cny': 'CN', 'inr': 'IN', 'krw': 'KR',
    'rub': 'RU', 'brl': 'BR', 'zar': 'ZA', 'mxn': 'MX', 'sgd': 'SG',
    'hkd': 'HK', 'nzd': 'NZ', 'sek': 'SE', 'nok': 'NO', 'dkk': 'DK',
    'pln': 'PL', 'thb': 'TH', 'idr': 'ID', 'myr': 'MY', 'php': 'PH',
    'czk': 'CZ', 'huf': 'HU', 'ils': 'IL', 'clp': 'CL', 'try': 'TR',
    'twd': 'TW', 'ars': 'AR', 'sar': 'SA', 'aed': 'AE', 'cop': 'CO',
    'egp': 'EG', 'ngn': 'NG', 'pkr': 'PK', 'bdt': 'BD', 'vnd': 'VN',
    'pen': 'PE', 'uah': 'UA', 'kzt': 'KZ', 'qar': 'QA', 'kwd': 'KW',
    'omr': 'OM', 'bhd': 'BH', 'jod': 'JO', 'lkr': 'LK', 'mmk': 'MM',
    'ron': 'RO', 'bgn': 'BG', 'hrk': 'HR', 'isk': 'IS', 'gel': 'GE',
    'mad': 'MA', 'tnd': 'TN', 'kes': 'KE', 'ghs': 'GH', 'tzs': 'TZ',
    'ugx': 'UG', 'etb': 'ET', 'rwf': 'RW', 'xof': 'SN', 'xaf': 'CM',
    'npr': 'NP', 'afn': 'AF', 'all': 'AL', 'amd': 'AM', 'azn': 'AZ',
    'bam': 'BA', 'byn': 'BY', 'bob': 'BO', 'crc': 'CR', 'cve': 'CV',
    'djf': 'DJ', 'dop': 'DO', 'dzd': 'DZ', 'fkp': 'FK', 'fjd': 'FJ',
    'gip': 'GI', 'gmd': 'GM', 'gnf': 'GN', 'gtq': 'GT', 'gyd': 'GY',
    'hnl': 'HN', 'htg': 'HT', 'iqd': 'IQ', 'irr': 'IR', 'jmd': 'JM',
    'kgs': 'KG', 'khr': 'KH', 'kmf': 'KM', 'kpw': 'KP', 'lak': 'LA',
    'lbp': 'LB', 'lrd': 'LR', 'lsl': 'LS', 'lyd': 'LY', 'mdl': 'MD',
    'mga': 'MG', 'mkd': 'MK', 'mnt': 'MN', 'mop': 'MO', 'mru': 'MR',
    'mur': 'MU', 'mvr': 'MV', 'mwk': 'MW', 'mzn': 'MZ', 'nad': 'NA',
    'nio': 'NI', 'pab': 'PA', 'pgk': 'PG', 'pyg': 'PY', 'scr': 'SC',
    'sdg': 'SD', 'sll': 'SL', 'sos': 'SO', 'srd': 'SR', 'ssp': 'SS',
    'std': 'ST', 'syp': 'SY', 'szl': 'SZ', 'tjs': 'TJ', 'tmt': 'TM',
    'top': 'TO', 'ttd': 'TT', 'uyu': 'UY', 'uzs': 'UZ', 'ves': 'VE',
    'vup': 'VU', 'wst': 'WS', 'xcd': 'AG', 'yer': 'YE', 'zmw': 'ZM',
    'zwl': 'ZW', 'bnd': 'BN', 'kyd': 'KY', 'bsd': 'BS', 'bbd': 'BB',
    'bmd': 'BM', 'bzd': 'BZ', 'sbd': 'SB', 'awg': 'AW', 'ang': 'CW',
    // Crypto
    'btc': '₿', 'eth': 'Ξ', 'ltc': 'Ł', 'xrp': '✕', 'doge': 'Ð',
  };

  static const Map<String, String> _cryptoSymbols = {
    'btc': '₿', 'eth': 'Ξ', 'ltc': 'Ł', 'xrp': '✕', 'doge': 'Ð',
    'ada': '₳', 'dot': '●', 'sol': '◎', 'bnb': '◆', 'xmr': 'ɱ',
  };

  static bool isCrypto(String code) => _cryptoSymbols.containsKey(code.toLowerCase());

  static String getFlag(String currencyCode) {
    final code = currencyCode.toLowerCase();

    if (_cryptoSymbols.containsKey(code)) {
      return _cryptoSymbols[code]!;
    }

    final country = _currencyToCountry[code];
    if (country == null) return '💱';

    // EU special case
    if (country == 'EU') return '🇪🇺';

    // Convert country code to regional indicator symbols (flag emoji)
    return country.runes
        .map((c) => String.fromCharCode(c + 0x1F1A5))
        .join();
  }
}

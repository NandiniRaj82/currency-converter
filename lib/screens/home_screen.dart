import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/currency.dart';
import '../models/conversion_result.dart';
import '../services/exchange_service.dart';
import '../services/storage_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/currency_selector.dart';
import '../widgets/currency_search_sheet.dart';
import '../widgets/result_card.dart';
import '../widgets/recent_conversions_panel.dart';

class HomeScreen extends StatefulWidget {
  final ExchangeService exchangeService;
  final StorageService storageService;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.exchangeService,
    required this.storageService,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Currency> _currencies = [];
  Currency? _fromCurrency;
  Currency? _toCurrency;
  ConversionResult? _result;
  List<ConversionResult> _recentConversions = [];

  bool _isLoadingCurrencies = true;
  bool _isConverting = false;
  bool _hasError = false;
  String _errorMessage = '';

  late AnimationController _swapController;
  double _swapAngle = 0;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _loadCurrencies();
    _recentConversions = widget.storageService.getRecentConversions();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrencies() async {
    setState(() { _isLoadingCurrencies = true; _hasError = false; });
    try {
      _currencies = await widget.exchangeService.fetchCurrencies();
      final lastFrom = widget.storageService.getLastFromCurrency();
      final lastTo = widget.storageService.getLastToCurrency();
      _fromCurrency = _currencies.firstWhere(
        (c) => c.code == lastFrom,
        orElse: () => _currencies.firstWhere((c) => c.code == 'usd', orElse: () => _currencies.first),
      );
      _toCurrency = _currencies.firstWhere(
        (c) => c.code == lastTo,
        orElse: () => _currencies.firstWhere((c) => c.code == 'eur', orElse: () => _currencies.last),
      );
      setState(() => _isLoadingCurrencies = false);
    } catch (e) {
      setState(() {
        _isLoadingCurrencies = false;
        _hasError = true;
        _errorMessage = 'Could not load currencies. Check your connection.';
      });
    }
  }

  Future<void> _convert() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromCurrency == null || _toCurrency == null) {
      _showSnackBar('Please select both currencies');
      return;
    }

    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    setState(() { _isConverting = true; _result = null; });

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      final converted = await widget.exchangeService.convert(
        amount: amount,
        fromCode: _fromCurrency!.code,
        toCode: _toCurrency!.code,
      );
      final rate = await widget.exchangeService.getRate(_fromCurrency!.code, _toCurrency!.code);

      final result = ConversionResult(
        fromCode: _fromCurrency!.code,
        toCode: _toCurrency!.code,
        amount: amount,
        convertedAmount: converted,
        rate: rate,
        timestamp: DateTime.now(),
      );

      await widget.storageService.addRecentConversion(result);
      await widget.storageService.setLastCurrencies(_fromCurrency!.code, _toCurrency!.code);

      setState(() {
        _result = result;
        _isConverting = false;
        _recentConversions = widget.storageService.getRecentConversions();
      });
    } catch (e) {
      setState(() => _isConverting = false);
      _showSnackBar('Conversion failed. Please try again.');
    }
  }

  void _swapCurrencies() {
    if (_fromCurrency == null || _toCurrency == null) return;
    HapticFeedback.lightImpact();
    setState(() {
      _swapAngle += 3.14159;
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _result = null;
    });
  }

  Future<void> _refreshRates() async {
    widget.exchangeService.clearCache();
    await _loadCurrencies();
    setState(() => _result = null);
    _showSnackBar('Rates refreshed');
  }

  void _loadFromRecent(ConversionResult recent) {
    _amountController.text = recent.amount.toString();
    _fromCurrency = _currencies.firstWhere((c) => c.code == recent.fromCode, orElse: () => _currencies.first);
    _toCurrency = _currencies.firstWhere((c) => c.code == recent.toCode, orElse: () => _currencies.last);
    setState(() => _result = null);
    _convert();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _selectCurrency({required bool isFrom}) async {
    final selected = await CurrencySearchSheet.show(
      context,
      currencies: _currencies,
      favorites: widget.storageService.getFavorites(),
      selected: isFrom ? _fromCurrency : _toCurrency,
    );
    if (selected != null) {
      setState(() {
        if (isFrom) {
          _fromCurrency = selected;
        } else {
          _toCurrency = selected;
        }
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;
    final contentWidth = isWide ? 500.0 : double.infinity;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.backgroundGradient : null,
          color: isDark ? null : AppColors.lightBackground,
        ),
        child: SafeArea(
          child: _isLoadingCurrencies
              ? _buildLoading(isDark)
              : _hasError
                  ? _buildError(isDark)
                  : RefreshIndicator(
                      onRefresh: _refreshRates,
                      color: AppColors.copper,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? (width - contentWidth) / 2 : 20,
                          vertical: 16,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: contentWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildAppBar(isDark),
                              const SizedBox(height: 24),
                              _buildConverterCard(isDark),
                              if (_result != null) ...[
                                const SizedBox(height: 20),
                                ResultCard(result: _result!),
                              ],
                              if (_recentConversions.isNotEmpty) ...[
                                const SizedBox(height: 28),
                                RecentConversionsPanel(
                                  conversions: _recentConversions,
                                  onTap: _loadFromRecent,
                                  onClear: () async {
                                    await widget.storageService.clearRecentConversions();
                                    setState(() => _recentConversions = []);
                                  },
                                ),
                              ],
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.copperGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.currency_exchange_rounded, color: AppColors.backgroundDark, size: 22),
        ),
        const SizedBox(width: 12),
        Text('Currency Canvas',
            style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
        const Spacer(),
        IconButton(
          onPressed: widget.onToggleTheme,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                RotationTransition(turns: Tween(begin: 0.75, end: 1.0).animate(anim), child: child),
            child: Icon(
              widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(widget.isDarkMode),
              color: AppColors.copper,
              size: 22,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.05, end: 0, duration: 600.ms);
  }

  Widget _buildConverterCard(bool isDark) {
    return GlassCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Amount input
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(Icons.payments_outlined, color: AppColors.copper.withValues(alpha: 0.7)),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter an amount';
                final parsed = double.tryParse(v.replaceAll(',', ''));
                if (parsed == null || parsed <= 0) return 'Enter a valid positive number';
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Currency selectors with swap
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CurrencySelector(
                    label: 'From',
                    selected: _fromCurrency,
                    onTap: () => _selectCurrency(isFrom: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _swapAngle),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    builder: (_, angle, child) =>
                        Transform.rotate(angle: angle, child: child),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _swapCurrencies,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.copper.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.copper.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.swap_horiz_rounded, color: AppColors.copper, size: 22),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CurrencySelector(
                    label: 'To',
                    selected: _toCurrency,
                    onTap: () => _selectCurrency(isFrom: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Convert button
            GradientButton(
              label: 'Convert',
              icon: Icons.sync_alt_rounded,
              isLoading: _isConverting,
              onPressed: _isConverting ? null : _convert,
              width: double.infinity,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms, delay: 200.ms).slideY(begin: 0.05, end: 0, duration: 700.ms);
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.copper,
              strokeWidth: 3,
              backgroundColor: AppColors.copper.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 20),
          Text('Loading currencies...',
              style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.copper.withValues(alpha: 0.6)),
            const SizedBox(height: 20),
            Text(_errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 24),
            GradientButton(label: 'Retry', icon: Icons.refresh_rounded, onPressed: _loadCurrencies),
          ],
        ),
      ),
    );
  }
}

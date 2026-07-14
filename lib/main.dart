import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_theme.dart';
import 'services/exchange_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar for a premium look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final storageService = StorageService();
  await storageService.init();

  runApp(CurrencyCanvasApp(storageService: storageService));
}

class CurrencyCanvasApp extends StatefulWidget {
  final StorageService storageService;
  const CurrencyCanvasApp({super.key, required this.storageService});

  @override
  State<CurrencyCanvasApp> createState() => _CurrencyCanvasAppState();
}

class _CurrencyCanvasAppState extends State<CurrencyCanvasApp> {
  late bool _isDarkMode;
  final _exchangeService = ExchangeService();

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.storageService.isDarkMode();
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    widget.storageService.setDarkMode(_isDarkMode);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Canvas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        exchangeService: _exchangeService,
        storageService: widget.storageService,
        onToggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

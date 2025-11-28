import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart'
    as di;
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_language_helper.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Use path-based URLs instead of hash-based URLs for web
  usePathUrlStrategy();
  
  await EasyLocalization.ensureInitialized();
  await di.init();
  
  // Initialize API language
  ApiLanguageHelper.initializeApiLanguage();
  
  // Load saved token if exists and set it in ApiClient
  final savedToken = await TokenStorage.getToken();
  if (savedToken != null && savedToken.isNotEmpty) {
    di.di<ApiClient>().setToken(savedToken);
    print('[Main] ✅ Token loaded and set in ApiClient: ${savedToken.substring(0, savedToken.length > 20 ? 20 : savedToken.length)}...');
  } else {
    print('[Main] ⚠️ No saved token found');
  }
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('ru'),
        Locale('hi'),
        Locale('de'),
        Locale('es'),
      ],
      path: kDebugMode ? 'translations' : 'assets/translations',
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: ValueKey(context.locale.languageCode),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'The Dunes - Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.YELLOW),
        fontFamily: context.locale.languageCode == 'ar' ? 'IBM' : 'Roboto',
      ),
      routerConfig: AppRouter.router,
      builder: (context, child) {
        final locale = context.locale;
        final isRTL = locale.languageCode == 'ar';
        return Directionality(
          textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart'
    as di;
import 'package:the_dunes/core/utils/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
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

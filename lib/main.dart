import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart' as di;
import 'package:the_dunes/core/utils/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'The Dunes - Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.YELLOW),
      ),
      routerConfig: AppRouter.router,
    );
  }
}

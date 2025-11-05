import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/features/login/persentation/screens/login_screen.dart';
import 'package:the_dunes/features/navbar/persentation/screens/navbar_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/analysis';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/analysis',
        name: 'analysis',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/receipt_voucher',
        name: 'receipt_voucher',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/employees',
        name: 'employees',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/hotels',
        name: 'hotels',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: '/setting',
        name: 'setting',
        builder: (context, state) => const NavbarScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'errors.page_not_found'.tr(namedArgs: {'uri': state.uri.toString()}),
        ),
      ),
    ),
  );
}

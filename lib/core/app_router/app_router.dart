import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/features/login/persentation/screens/login_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
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
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.analysis),
      ),
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.bookings),
      ),
      GoRoute(
        path: '/pickup_time',
        name: 'pickup_time',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.pickupTime),
      ),
      GoRoute(
        path: '/receipt_voucher',
        name: 'receipt_voucher',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.receiptVoucher),
      ),
      GoRoute(
        path: '/employees',
        name: 'employees',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.employees),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.services),
      ),
      GoRoute(
        path: '/hotels',
        name: 'hotels',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.hotels),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.history),
      ),
      GoRoute(
        path: '/setting',
        name: 'setting',
        builder: (context, state) =>
            const NavbarScreen(initialSection: NavbarSection.settings),
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

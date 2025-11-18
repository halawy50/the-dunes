import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/features/login/persentation/screens/login_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/screens/navbar_screen.dart';

class AppRouterRoutes {
  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AppRouter.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final path = state.uri.path;
          final section = AppRouter.getSectionFromPath(path) ?? 
              NavbarSection.analysis;
          return NavbarScreen(
            key: AppRouter.navbarKey,
            initialSection: section,
            navigationShell: navigationShell,
          );
        },
        branches: _getBranches(),
      ),
    ];
  }

  static List<StatefulShellBranch> _getBranches() {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/analysis',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/booking',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/pickup_time',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/receipt_voucher',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/employees',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/services',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/hotels',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/operations',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/camp',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/history',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/setting',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
    ];
  }
}


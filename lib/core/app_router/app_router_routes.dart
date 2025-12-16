import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/features/booking/persentation/screens/new_book_screen.dart';
import 'package:the_dunes/features/booking/persentation/widgets/document_analysis_screen.dart';
import 'package:the_dunes/features/login/persentation/screens/login_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/screens/navbar_screen.dart';
import 'package:the_dunes/features/pickup_times/presentation/screens/pickup_times_screen.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/receipt_voucher_screen.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/new_receipt_voucher_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/new_employee_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_detail_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/agent_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/agent_detail_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/new_agent_screen.dart';
import 'package:the_dunes/features/hotels/persentation/screens/hotel_screen.dart';
import 'package:the_dunes/features/camp/persentation/screens/camp_screen.dart';

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
          GoRoute(
            path: '/booking/new',
            builder: (context, state) => const NewBookScreen(),
          ),
          GoRoute(
            path: '/booking/analyze',
            builder: (context, state) => const DocumentAnalysisScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/pickup_time',
            builder: (context, state) => const PickupTimesScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/receipt_voucher',
            builder: (context, state) => const ReceiptVoucherScreen(),
          ),
          GoRoute(
            path: '/receipt_voucher/new',
            builder: (context, state) => const NewReceiptVoucherScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeeScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const NewEmployeeScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return EmployeeDetailScreen(employeeId: id);
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/agents',
            builder: (context, state) => const AgentScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const NewAgentScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AgentDetailScreen(agentId: id);
                },
              ),
            ],
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
            builder: (context, state) => const HotelScreen(),
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
            builder: (context, state) => const CampScreen(),
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


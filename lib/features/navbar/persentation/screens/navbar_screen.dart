import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/features/anylisis/persentation/screens/analysis_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/booking_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/pickup_time_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_screen.dart';
import 'package:the_dunes/features/history/persentation/screens/history_screen.dart';
import 'package:the_dunes/features/hotels/persentation/screens/hotel_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/app_layout.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/sidebar.dart';
import 'package:the_dunes/features/navbar/persentation/widgets/top_bar.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/receipt_voucher_screen.dart';
import 'package:the_dunes/features/services/persentation/screens/service_screen.dart';
import 'package:the_dunes/features/setting/persentation/screens/setting_screen.dart';

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key, required this.initialSection});

  final NavbarSection initialSection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<NavbarCubit>()..init(initialSection),
      child: const _NavbarView(),
    );
  }
}

class _NavbarView extends StatelessWidget {
  const _NavbarView();

  Widget _buildSectionPage(NavbarSection section) {
    switch (section) {
      case NavbarSection.analysis:
        return const AnalysisScreen();
      case NavbarSection.bookings:
        return const BookingScreen();
      case NavbarSection.pickupTime:
        return const PickupTimeScreen();
      case NavbarSection.receiptVoucher:
        return const ReceiptVoucherScreen();
      case NavbarSection.employees:
        return const EmployeeScreen();
      case NavbarSection.services:
        return const ServiceScreen();
      case NavbarSection.hotels:
        return const HotelScreen();
      case NavbarSection.history:
        return const HistoryScreen();
      case NavbarSection.settings:
        return const SettingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = NavbarSection.values;

    return BlocBuilder<NavbarCubit, NavbarState>(
      builder: (context, state) {
        final selectedSection = state.selectedSection;

        return AppLayout(
          sidebar: Sidebar(
            sections: sections,
            selectedSection: selectedSection,
            onSectionSelected: (section) {
              context.read<NavbarCubit>().selectSection(section);
            },
          ),
          topBar: TopBar(
            titleKey: selectedSection.translationKey,
            subtitleKey: selectedSection.subtitleKey,
            onLogout: () => context.go(AppRouter.login),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: KeyedSubtree(
              key: ValueKey(selectedSection),
              child: _buildSectionPage(selectedSection),
            ),
          ),
        );
      },
    );
  }
}

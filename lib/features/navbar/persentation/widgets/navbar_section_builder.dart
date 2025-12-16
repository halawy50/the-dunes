import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/features/anylisis/persentation/screens/analysis_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/booking_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/new_book_screen.dart';
import 'package:the_dunes/features/pickup_times/presentation/screens/pickup_times_screen.dart';
import 'package:the_dunes/features/camp/persentation/screens/camp_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_detail_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/new_employee_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/agent_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/agent_detail_screen.dart';
import 'package:the_dunes/features/agents/presentation/screens/new_agent_screen.dart';
import 'package:the_dunes/features/history/persentation/screens/history_screen.dart';
import 'package:the_dunes/features/hotels/persentation/screens/hotel_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/operations/persentation/screens/operation_screen.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/receipt_voucher_screen.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/new_receipt_voucher_screen.dart';
import 'package:the_dunes/features/services/persentation/screens/service_screen.dart';
import 'package:the_dunes/features/setting/persentation/screens/setting_screen.dart';

class NavbarSectionBuilder {
  static Widget buildSectionPage(NavbarSection section, BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    
    if (section == NavbarSection.bookings) {
      if (path == '/booking/new') {
        return const NewBookScreen();
      }
    }
    
    if (section == NavbarSection.receiptVoucher) {
      if (path == '/receipt_voucher/new') {
        return const NewReceiptVoucherScreen();
      }
    }
    
    if (section == NavbarSection.employees) {
      // Check if path matches /employees/:id pattern
      final employeeDetailMatch = RegExp(r'^/employees/(\d+)$').firstMatch(path);
      if (employeeDetailMatch != null) {
        final employeeId = int.parse(employeeDetailMatch.group(1)!);
        return EmployeeDetailScreen(employeeId: employeeId);
      }
      // Check if path is /employees/new
      if (path == '/employees/new') {
        return const NewEmployeeScreen();
      }
      return const EmployeeScreen();
    }
    
    if (section == NavbarSection.agents) {
      // Check if path matches /agents/:id pattern
      final agentDetailMatch = RegExp(r'^/agents/(\d+)$').firstMatch(path);
      if (agentDetailMatch != null) {
        final agentId = int.parse(agentDetailMatch.group(1)!);
        return AgentDetailScreen(agentId: agentId);
      }
      // Check if path is /agents/new
      if (path == '/agents/new') {
        return const NewAgentScreen();
      }
      return const AgentScreen();
    }
    
    switch (section) {
      case NavbarSection.analysis:
        return const AnalysisScreen();
      case NavbarSection.bookings:
        return const BookingScreen();
      case NavbarSection.pickupTime:
        return const PickupTimesScreen();
      case NavbarSection.receiptVoucher:
        return const ReceiptVoucherScreen();
      case NavbarSection.employees:
        // This case is handled above, but needed for exhaustive switch
        return const EmployeeScreen();
      case NavbarSection.agents:
        // This case is handled above, but needed for exhaustive switch
        return const AgentScreen();
      case NavbarSection.services:
        return const ServiceScreen();
      case NavbarSection.hotels:
        return const HotelScreen();
      case NavbarSection.operations:
        return const OperationScreen();
      case NavbarSection.camp:
        return const CampScreen();
      case NavbarSection.history:
        return const HistoryScreen();
      case NavbarSection.settings:
        return const SettingScreen();
    }
  }
}


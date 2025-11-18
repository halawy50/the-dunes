import 'package:flutter/material.dart';
import 'package:the_dunes/features/anylisis/persentation/screens/analysis_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/booking_screen.dart';
import 'package:the_dunes/features/booking/persentation/screens/pickup_time_screen.dart';
import 'package:the_dunes/features/camp/persentation/screens/camp_screen.dart';
import 'package:the_dunes/features/employees/persentation/screens/employee_screen.dart';
import 'package:the_dunes/features/history/persentation/screens/history_screen.dart';
import 'package:the_dunes/features/hotels/persentation/screens/hotel_screen.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/operations/persentation/screens/operation_screen.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/screens/receipt_voucher_screen.dart';
import 'package:the_dunes/features/services/persentation/screens/service_screen.dart';
import 'package:the_dunes/features/setting/persentation/screens/setting_screen.dart';

class NavbarSectionBuilder {
  static Widget buildSectionPage(NavbarSection section) {
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


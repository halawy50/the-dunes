import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/login/data/models/permissions_model.dart';

part 'navbar_state.dart';

enum NavbarSection {
  analysis,
  bookings,
  pickupTime,
  receiptVoucher,
  employees,
  agents,
  services,
  hotels,
  operations,
  camp,
  history,
  settings,
}

extension NavbarSectionPermissions on NavbarSection {
  bool isAllowed(PermissionsModel? permissions) {
    if (permissions == null) return false;
    switch (this) {
      case NavbarSection.analysis:
        return permissions.analysisScreen;
      case NavbarSection.bookings:
        // Allow if user has any booking-related permission
        return permissions.bookingScreen ||
            permissions.showAllBooking ||
            permissions.showMyBookAdded ||
            permissions.addNewBook ||
            permissions.editBook ||
            permissions.deleteBook;
      case NavbarSection.pickupTime:
        // Allow if user has any pickup time-related permission
        return permissions.pickupTimeScreen ||
            permissions.showAllPickup ||
            permissions.editAnyPickup;
      case NavbarSection.receiptVoucher:
        // Allow if user has any receipt voucher-related permission
        return permissions.receiptVoucherScreen ||
            permissions.showAllReceiptVoucher ||
            permissions.showReceiptVoucherAdded ||
            permissions.addNewReceiptVoucherMe ||
            permissions.addNewReceiptVoucherOtherEmployee ||
            permissions.editReceiptVoucher ||
            permissions.deleteReceiptVoucher;
      case NavbarSection.employees:
        // Employees page requires specific permissions
        // For now, check if user has any employee-related permission from the permissions map
        // Since PermissionsModel doesn't have employee permissions yet, we'll check if user has admin-like permissions
        // If user has all receipt voucher permissions or other admin permissions, allow access
        // Otherwise, employees page should not be accessible by default
        // TODO: Add employee permissions to PermissionsModel
        return permissions.receiptVoucherScreen && 
               permissions.bookingScreen &&
               permissions.serviceScreen;
      case NavbarSection.agents:
        // Allow if user has service screen permission (agents manage services)
        return permissions.serviceScreen ||
            permissions.showAllService ||
            permissions.addNewService ||
            permissions.editService ||
            permissions.deleteService;
      case NavbarSection.services:
        // Allow if user has any service-related permission
        return permissions.serviceScreen ||
            permissions.showAllService ||
            permissions.addNewService ||
            permissions.editService ||
            permissions.deleteService;
      case NavbarSection.hotels:
        // Allow if user has any hotel-related permission
        return permissions.hotelScreen ||
            permissions.showAllHotels ||
            permissions.addNewHotels ||
            permissions.editHotels ||
            permissions.deleteHotels;
      case NavbarSection.operations:
        // Allow if user has any operation-related permission
        return permissions.operationsScreen ||
            permissions.showAllOperations ||
            permissions.addNewOperation ||
            permissions.editOperation ||
            permissions.deleteOperation;
      case NavbarSection.camp:
        // Allow if user has any camp-related permission
        return permissions.campScreen ||
            permissions.showAllCampBookings ||
            permissions.changeStateBooking;
      case NavbarSection.history:
        return permissions.historyScreen || permissions.showAllHistory;
      case NavbarSection.settings:
        return permissions.settingScreen;
    }
  }
}

extension NavbarSectionX on NavbarSection {
  String get translationKey {
    switch (this) {
      case NavbarSection.analysis:
        return 'navbar.analysis';
      case NavbarSection.bookings:
        return 'navbar.bookings';
      case NavbarSection.pickupTime:
        return 'navbar.pickup_time';
      case NavbarSection.receiptVoucher:
        return 'navbar.receipt_voucher';
      case NavbarSection.employees:
        return 'navbar.employees';
      case NavbarSection.agents:
        return 'navbar.agents';
      case NavbarSection.services:
        return 'navbar.services';
      case NavbarSection.hotels:
        return 'navbar.hotels';
      case NavbarSection.operations:
        return 'navbar.operations';
      case NavbarSection.camp:
        return 'navbar.camp';
      case NavbarSection.history:
        return 'navbar.history';
      case NavbarSection.settings:
        return 'navbar.settings';
    }
  }

  String get subtitleKey {
    switch (this) {
      case NavbarSection.analysis:
        return 'navbar.analysis_subtitle';
      case NavbarSection.bookings:
        return 'navbar.bookings_subtitle';
      case NavbarSection.pickupTime:
        return 'navbar.pickup_time_subtitle';
      case NavbarSection.receiptVoucher:
        return 'navbar.receipt_voucher_subtitle';
      case NavbarSection.employees:
        return 'navbar.employees_subtitle';
      case NavbarSection.agents:
        return 'navbar.agents_subtitle';
      case NavbarSection.services:
        return 'navbar.services_subtitle';
      case NavbarSection.hotels:
        return 'navbar.hotels_subtitle';
      case NavbarSection.operations:
        return 'navbar.operations_subtitle';
      case NavbarSection.camp:
        return 'navbar.camp_subtitle';
      case NavbarSection.history:
        return 'navbar.history_subtitle';
      case NavbarSection.settings:
        return 'navbar.settings_subtitle';
    }
  }

  String get route {
    switch (this) {
      case NavbarSection.analysis:
        return '/analysis';
      case NavbarSection.bookings:
        return '/booking';
      case NavbarSection.pickupTime:
        return '/pickup_time';
      case NavbarSection.receiptVoucher:
        return '/receipt_voucher';
      case NavbarSection.employees:
        return '/employees';
      case NavbarSection.agents:
        return '/agents';
      case NavbarSection.services:
        return '/services';
      case NavbarSection.hotels:
        return '/hotels';
      case NavbarSection.operations:
        return '/operations';
      case NavbarSection.camp:
        return '/camp';
      case NavbarSection.history:
        return '/history';
      case NavbarSection.settings:
        return '/setting';
    }
  }

  String get iconAsset {
    switch (this) {
      case NavbarSection.analysis:
        return 'assets/icons/search_normal.svg';
      case NavbarSection.bookings:
        return 'assets/icons/calendar_tick.svg';
      case NavbarSection.pickupTime:
        return 'assets/icons/calendar_tick.svg';
      case NavbarSection.receiptVoucher:
        return 'assets/icons/money_recive.svg';
      case NavbarSection.employees:
        return 'assets/icons/attach_files.svg';
      case NavbarSection.agents:
        return 'assets/icons/attach_files.svg';
      case NavbarSection.services:
        return 'assets/icons/converte.svg';
      case NavbarSection.hotels:
        return 'assets/icons/dollar_circle.svg';
      case NavbarSection.operations:
        return 'assets/icons/converte.svg';
      case NavbarSection.camp:
        return 'assets/icons/calendar_tick.svg';
      case NavbarSection.history:
        return 'assets/icons/back.svg';
      case NavbarSection.settings:
        return 'assets/icons/edit.svg';
    }
  }
}

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarState.initial(NavbarSection.analysis));

  void init(NavbarSection section) {
    if (state.selectedSection == section) return;
    emit(state.copyWith(selectedSection: section));
  }

  void selectSection(NavbarSection section) {
    if (state.selectedSection == section) return;
    emit(state.copyWith(selectedSection: section));
  }

  void toggleSidebar() {
    emit(state.copyWith(isSidebarVisible: !state.isSidebarVisible));
  }
}

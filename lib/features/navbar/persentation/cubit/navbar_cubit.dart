import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_state.dart';

enum NavbarSection {
  analysis,
  bookings,
  pickupTime,
  receiptVoucher,
  employees,
  services,
  hotels,
  history,
  settings,
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
      case NavbarSection.services:
        return 'navbar.services';
      case NavbarSection.hotels:
        return 'navbar.hotels';
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
      case NavbarSection.services:
        return 'navbar.services_subtitle';
      case NavbarSection.hotels:
        return 'navbar.hotels_subtitle';
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
      case NavbarSection.services:
        return '/services';
      case NavbarSection.hotels:
        return '/hotels';
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
      case NavbarSection.services:
        return 'assets/icons/converte.svg';
      case NavbarSection.hotels:
        return 'assets/icons/dollar_circle.svg';
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
}

import 'package:the_dunes/features/login/data/models/permissions_factory.dart';
import 'package:the_dunes/features/login/data/models/permissions_json_helper.dart';

class PermissionsModel {
  final bool overviewScreen;
  final bool analysisScreen;
  final bool bookingScreen;
  final bool showAllBooking;
  final bool showMyBookAdded;
  final bool addNewBook;
  final bool editBook;
  final bool deleteBook;
  final bool receiptVoucherScreen;
  final bool showAllReceiptVoucher;
  final bool showReceiptVoucherAdded;
  final bool addNewReceiptVoucherMe;
  final bool addNewReceiptVoucherOtherEmployee;
  final bool editReceiptVoucher;
  final bool deleteReceiptVoucher;
  final bool pickupTimeScreen;
  final bool showAllPickup;
  final bool editAnyPickup;
  final bool serviceScreen;
  final bool showAllService;
  final bool addNewService;
  final bool editService;
  final bool deleteService;
  final bool hotelScreen;
  final bool showAllHotels;
  final bool addNewHotels;
  final bool editHotels;
  final bool deleteHotels;
  final bool campScreen;
  final bool showAllCampBookings;
  final bool changeStateBooking;
  final bool operationsScreen;
  final bool showAllOperations;
  final bool addNewOperation;
  final bool editOperation;
  final bool deleteOperation;
  final bool historyScreen;
  final bool showAllHistory;
  final bool settingScreen;

  PermissionsModel({
    this.overviewScreen = false,
    this.analysisScreen = false,
    this.bookingScreen = false,
    this.showAllBooking = false,
    this.showMyBookAdded = false,
    this.addNewBook = false,
    this.editBook = false,
    this.deleteBook = false,
    this.receiptVoucherScreen = false,
    this.showAllReceiptVoucher = false,
    this.showReceiptVoucherAdded = false,
    this.addNewReceiptVoucherMe = false,
    this.addNewReceiptVoucherOtherEmployee = false,
    this.editReceiptVoucher = false,
    this.deleteReceiptVoucher = false,
    this.pickupTimeScreen = false,
    this.showAllPickup = false,
    this.editAnyPickup = false,
    this.serviceScreen = false,
    this.showAllService = false,
    this.addNewService = false,
    this.editService = false,
    this.deleteService = false,
    this.hotelScreen = false,
    this.showAllHotels = false,
    this.addNewHotels = false,
    this.editHotels = false,
    this.deleteHotels = false,
    this.campScreen = false,
    this.showAllCampBookings = false,
    this.changeStateBooking = false,
    this.operationsScreen = false,
    this.showAllOperations = false,
    this.addNewOperation = false,
    this.editOperation = false,
    this.deleteOperation = false,
    this.historyScreen = false,
    this.showAllHistory = false,
    this.settingScreen = false,
  });

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return PermissionsJsonHelper.toJson(this);
  }
}


import 'package:the_dunes/features/login/data/models/permissions_model.dart';

class PermissionsFactory {
  static PermissionsModel fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      overviewScreen: json['overviewScreen'] ?? false,
      analysisScreen: json['analysisScreen'] ?? false,
      bookingScreen: json['bookingScreen'] ?? false,
      showAllBooking: json['showAllBooking'] ?? false,
      showMyBookAdded: json['showMyBookAdded'] ?? false,
      addNewBook: json['addNewBook'] ?? false,
      editBook: json['editBook'] ?? false,
      deleteBook: json['deleteBook'] ?? false,
      receiptVoucherScreen: json['receiptVoucherScreen'] ?? false,
      showAllReceiptVoucher: json['showAllReceiptVoucher'] ?? false,
      showReceiptVoucherAdded: json['showReceiptVoucherAdded'] ?? false,
      addNewReceiptVoucherMe: json['addNewReceiptVoucherMe'] ?? false,
      addNewReceiptVoucherOtherEmployee:
          json['addNewReceiptVoucherOtherEmployee'] ?? false,
      editReceiptVoucher: json['editReceiptVoucher'] ?? false,
      deleteReceiptVoucher: json['deleteReceiptVoucher'] ?? false,
      pickupTimeScreen: json['pickupTimeScreen'] ?? false,
      showAllPickup: json['showAllPickup'] ?? false,
      editAnyPickup: json['editAnyPickup'] ?? false,
      serviceScreen: json['serviceScreen'] ?? false,
      showAllService: json['showAllService'] ?? false,
      addNewService: json['addNewService'] ?? false,
      editService: json['editService'] ?? false,
      deleteService: json['deleteService'] ?? false,
      hotelScreen: json['hotelScreen'] ?? false,
      showAllHotels: json['showAllHotels'] ?? false,
      addNewHotels: json['addNewHotels'] ?? false,
      editHotels: json['editHotels'] ?? false,
      deleteHotels: json['deleteHotels'] ?? false,
      campScreen: json['campScreen'] ?? false,
      showAllCampBookings: json['showAllCampBookings'] ?? false,
      changeStateBooking: json['changeStateBooking'] ?? false,
      operationsScreen: json['operationsScreen'] ?? false,
      showAllOperations: json['showAllOperations'] ?? false,
      addNewOperation: json['addNewOperation'] ?? false,
      editOperation: json['editOperation'] ?? false,
      deleteOperation: json['deleteOperation'] ?? false,
      historyScreen: json['historyScreen'] ?? false,
      showAllHistory: json['showAllHistory'] ?? false,
      settingScreen: json['settingScreen'] ?? false,
    );
  }
}


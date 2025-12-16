import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';

class ReceiptVoucherJsonHelper {
  static Map<String, dynamic> toJson(ReceiptVoucherModel voucher) {
    return {
      'guestName': voucher.guestName,
      'location': voucher.location,
      'locationId': voucher.locationId,
      'currencyId': voucher.currencyId,
      'phoneNumber': voucher.phoneNumber,
      'status': voucher.status,
      'hotel': voucher.hotel,
      'room': voucher.room,
      'note': voucher.note,
      'pickupTime': voucher.pickupTime,
      'pickupStatus': voucher.pickupStatus,
      'driver': voucher.driver,
      'carNumber': voucher.carNumber,
      'payment': voucher.payment,
      'typeOperation': voucher.typeOperation,
      'employeeIsReceivedCommission': voucher.employeeIsReceivedCommission,
      'discountPercentage': voucher.discountPercentage,
      'services': voucher.services.map((s) => s.toJson()).toList(),
      'priceBeforePercentage': voucher.priceBeforePercentage,
      'priceAfterPercentage': voucher.priceAfterPercentage,
      'finalPriceWithCommissionEmployee': voucher.finalPriceWithCommissionEmployee,
      'finalPriceAfterDeductingCommissionEmployee':
          voucher.finalPriceAfterDeductingCommissionEmployee,
    };
  }
}


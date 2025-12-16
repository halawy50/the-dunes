import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';

class ReceiptVoucherFactory {
  static ReceiptVoucherModel fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final servicesData = data['services'] as List<dynamic>? ?? [];
    final services = servicesData
        .map((s) => ReceiptVoucherServiceModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return ReceiptVoucherModel(
      id: data['id'] ?? 0,
      createAt: data['createAt'] ?? '',
      guestName: data['guestName'] ?? '',
      location: data['location'],
      locationId: data['locationId'],
      currencyId: data['currencyId'],
      phoneNumber: data['phoneNumber'],
      status: data['status'] ?? 'PENDING',
      hotel: data['hotel'],
      room: data['room'],
      note: data['note'],
      pickupTime: data['pickupTime'],
      pickupStatus: data['pickupStatus'],
      driver: data['driver'],
      carNumber: data['carNumber'],
      payment: data['payment'] ?? 'PENDING',
      employeeAddedId: data['employeeAddedId'],
      employeeAddedName: data['employeeAddedName'],
      commissionEmployee: data['commissionEmployee']?.toDouble(),
      typeOperation: data['typeOperation'] ?? 'SERVICE',
      employeeIsReceivedCommission: data['employeeIsReceivedCommission'] ?? false,
      discountPercentage: data['discountPercentage'],
      services: services,
      priceBeforePercentage: (data['priceBeforePercentage'] ?? 0.0).toDouble(),
      priceAfterPercentage: (data['priceAfterPercentage'] ?? 0.0).toDouble(),
      finalPriceWithCommissionEmployee:
          (data['finalPriceWithCommissionEmployee'] ?? 0.0).toDouble(),
      finalPriceAfterDeductingCommissionEmployee:
          (data['finalPriceAfterDeductingCommissionEmployee'] ?? 0.0).toDouble(),
      commissionStatus: data['commissionStatus'],
      commissionAmount: data['commissionAmount']?.toDouble(),
      employeeProfit: data['employeeProfit']?.toDouble(),
      employeeTotalPaidCommission: data['employeeTotalPaidCommission']?.toDouble(),
      employeeTotalPendingCommission: data['employeeTotalPendingCommission']?.toDouble(),
      employeeTotalCommission: data['employeeTotalCommission']?.toDouble(),
    );
  }
}


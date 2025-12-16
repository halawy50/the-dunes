import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_factory.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_json_helper.dart';

class ReceiptVoucherModel {
  final int id;
  final String createAt;
  final String guestName;
  final String? location;
  final int? locationId;
  final int? currencyId;
  final String? phoneNumber;
  final String status;
  final String? hotel;
  final int? room;
  final String? note;
  final String? pickupTime;
  final String? pickupStatus;
  final String? driver;
  final int? carNumber;
  final String payment;
  final int? employeeAddedId;
  final String? employeeAddedName;
  final double? commissionEmployee;
  final String typeOperation;
  final bool employeeIsReceivedCommission;
  final int? discountPercentage;
  final List<ReceiptVoucherServiceModel> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPriceWithCommissionEmployee;
  final double finalPriceAfterDeductingCommissionEmployee;
  final String? commissionStatus;
  final double? commissionAmount;
  final double? employeeProfit;
  final double? employeeTotalPaidCommission;
  final double? employeeTotalPendingCommission;
  final double? employeeTotalCommission;

  ReceiptVoucherModel({
    required this.id,
    required this.createAt,
    required this.guestName,
    this.location,
    this.locationId,
    this.currencyId,
    this.phoneNumber,
    required this.status,
    this.hotel,
    this.room,
    this.note,
    this.pickupTime,
    this.pickupStatus,
    this.driver,
    this.carNumber,
    required this.payment,
    this.employeeAddedId,
    this.employeeAddedName,
    this.commissionEmployee,
    required this.typeOperation,
    required this.employeeIsReceivedCommission,
    this.discountPercentage,
    required this.services,
    required this.priceBeforePercentage,
    required this.priceAfterPercentage,
    required this.finalPriceWithCommissionEmployee,
    required this.finalPriceAfterDeductingCommissionEmployee,
    this.commissionStatus,
    this.commissionAmount,
    this.employeeProfit,
    this.employeeTotalPaidCommission,
    this.employeeTotalPendingCommission,
    this.employeeTotalCommission,
  });

  factory ReceiptVoucherModel.fromJson(Map<String, dynamic> json) {
    return ReceiptVoucherFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return ReceiptVoucherJsonHelper.toJson(this);
  }
}


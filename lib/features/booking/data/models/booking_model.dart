import 'package:the_dunes/features/booking/data/models/booking_factory.dart';
import 'package:the_dunes/features/booking/data/models/booking_json_helper.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';

class BookingModel {
  final int id;
  final String? time;
  final String? voucher;
  final String? orderNumber;
  final String? pickupTime;
  final String? pickupStatus;
  final int employeeId;
  final String? employeeName;
  final String guestName;
  final String? phoneNumber;
  final String statusBook;
  final int agentName;
  final String? agentNameStr;
  final int? locationId;
  final String? locationName;
  final String? hotelName;
  final int? room;
  final String? note;
  final String? driver;
  final int? carNumber;
  final String payment;
  final String typeOperation;
  final List<BookingServiceModel> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPrice;
  final String? bookingDate;

  BookingModel({
    required this.id,
    this.time,
    this.voucher,
    this.orderNumber,
    this.pickupTime,
    this.pickupStatus,
    required this.employeeId,
    this.employeeName,
    required this.guestName,
    this.phoneNumber,
    required this.statusBook,
    required this.agentName,
    this.agentNameStr,
    this.locationId,
    this.locationName,
    this.hotelName,
    this.room,
    this.note,
    this.driver,
    this.carNumber,
    required this.payment,
    required this.typeOperation,
    required this.services,
    required this.priceBeforePercentage,
    required this.priceAfterPercentage,
    required this.finalPrice,
    this.bookingDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return BookingJsonHelper.toJson(this);
  }
}


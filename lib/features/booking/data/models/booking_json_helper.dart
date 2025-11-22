import 'package:the_dunes/features/booking/data/models/booking_model.dart';

class BookingJsonHelper {
  static Map<String, dynamic> toJson(BookingModel booking) {
    final json = <String, dynamic>{
      // Required fields
      'guestName': booking.guestName,
      'typeOperation': booking.typeOperation,
      'services': booking.services.map((s) => s.toJson()).toList(),
      'priceBeforePercentage': booking.priceBeforePercentage,
      'priceAfterPercentage': booking.priceAfterPercentage,
      'finalPrice': booking.finalPrice,
    };
    
    // Optional fields - only include if they have values
    if (booking.time != null && booking.time!.isNotEmpty) {
      json['time'] = booking.time;
    }
    if (booking.pickupTime != null && booking.pickupTime!.isNotEmpty) {
      json['pickupTime'] = booking.pickupTime;
    }
    if (booking.phoneNumber != null && booking.phoneNumber!.isNotEmpty) {
      json['phoneNumber'] = booking.phoneNumber;
    }
    if (booking.statusBook.isNotEmpty) {
      json['statusBook'] = booking.statusBook;
    }
    if (booking.employeeId > 0) {
      json['employeeId'] = booking.employeeId;
    }
    // Only send agentName if it's a valid ID (not 0 or null)
    if (booking.agentName > 0) {
      json['agentName'] = booking.agentName;
    }
    // Send locationId only if it's set (not null)
    // Global location (id = -1) is converted to null, so it won't be sent
    if (booking.locationId != null) {
      json['locationId'] = booking.locationId;
    }
    if (booking.hotelName != null && booking.hotelName!.isNotEmpty) {
      json['hotelName'] = booking.hotelName;
    }
    // Only send room if it's a valid number (not null and > 0)
    if (booking.room != null && booking.room! > 0) {
      json['room'] = booking.room;
    }
    if (booking.note != null && booking.note!.isNotEmpty) {
      json['note'] = booking.note;
    }
    if (booking.driver != null && booking.driver!.isNotEmpty) {
      json['driver'] = booking.driver;
    }
    // Only send carNumber if it's a valid number (not null and > 0)
    if (booking.carNumber != null && booking.carNumber! > 0) {
      json['carNumber'] = booking.carNumber;
    }
    if (booking.voucher != null && booking.voucher!.isNotEmpty) {
      json['voucher'] = booking.voucher;
    }
    if (booking.orderNumber != null && booking.orderNumber!.isNotEmpty) {
      json['orderNumber'] = booking.orderNumber;
    }
    if (booking.payment.isNotEmpty) {
      json['payment'] = booking.payment;
    }
    // Always send pickupStatus if it has a value (including default 'YET')
    if (booking.pickupStatus != null && booking.pickupStatus!.isNotEmpty) {
      json['pickupStatus'] = booking.pickupStatus;
    }
    
    return json;
  }
}



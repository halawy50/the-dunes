import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';

class BookingFactory {
  static BookingModel fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      time: json['time'],
      voucher: json['voucher'],
      orderNumber: json['orderNumber'],
      pickupTime: json['pickupTime']?.toString(),
      pickupStatus: json['pickupStatus'],
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'],
      guestName: json['guestName'] ?? '',
      phoneNumber: json['phoneNumber'],
      statusBook: json['statusBook'] ?? 'PENDING',
      agentName: json['agentName'] ?? 0,
      agentNameStr: json['agentNameStr'],
      locationId: json['locationId'],
      locationName: json['locationName'],
      hotelName: json['hotelName'],
      room: json['room'],
      note: json['note'],
      driver: json['driver'],
      carNumber: json['carNumber'],
      payment: json['payment'] ?? 'PENDING',
      typeOperation: json['typeOperation'] ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((item) => BookingServiceModel.fromJson(
                    item as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      priceBeforePercentage: (json['priceBeforePercentage'] ?? 0.0).toDouble(),
      priceAfterPercentage: (json['priceAfterPercentage'] ?? 0.0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
      bookingDate: json['bookingDate'],
    );
  }
}



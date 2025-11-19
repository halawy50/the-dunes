import 'package:the_dunes/features/booking/data/models/booking_model.dart';

class BookingJsonHelper {
  static Map<String, dynamic> toJson(BookingModel booking) {
    return {
      'time': booking.time,
      'voucher': booking.voucher,
      'orderNumber': booking.orderNumber,
      'pickupTime': booking.pickupTime,
      'pickupStatus': booking.pickupStatus,
      'employeeId': booking.employeeId,
      'guestName': booking.guestName,
      'phoneNumber': booking.phoneNumber,
      'statusBook': booking.statusBook,
      'agentName': booking.agentName,
      'locationId': booking.locationId,
      'hotelName': booking.hotelName,
      'room': booking.room,
      'note': booking.note,
      'driver': booking.driver,
      'carNumber': booking.carNumber,
      'payment': booking.payment,
      'typeOperation': booking.typeOperation,
      'services': booking.services.map((s) => s.toJson()).toList(),
      'priceBeforePercentage': booking.priceBeforePercentage,
      'priceAfterPercentage': booking.priceAfterPercentage,
      'finalPrice': booking.finalPrice,
      'bookingDate': booking.bookingDate,
    };
  }
}



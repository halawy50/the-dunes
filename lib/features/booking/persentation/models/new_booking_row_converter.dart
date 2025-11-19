import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_service_model.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

class NewBookingRowConverter {
  static Future<BookingModel> toBookingModel(NewBookingRow row) async {
    final userData = await TokenStorage.getUserData();
    final employeeId = userData?['id'] as int? ?? 0;

    return BookingModel(
      id: 0,
      employeeId: employeeId,
      guestName: row.guestName,
      phoneNumber: row.phoneNumber,
      statusBook: row.status,
      agentName: row.agent?.id ?? 0,
      agentNameStr: row.agent?.name,
      locationId: row.location?.id,
      locationName: row.location?.name,
      hotelName: row.hotel?.name,
      room: row.room,
      note: row.note,
      driver: row.driver?.name,
      carNumber: row.carNumber,
      payment: row.payment,
      typeOperation: 'BOOKING',
      services: _convertServices(row.services),
      priceBeforePercentage: row.priceBeforeDiscount,
      priceAfterPercentage: row.priceAfterDiscount,
      finalPrice: row.netProfit,
      voucher: row.ticketNumber,
      orderNumber: row.orderNumber,
      pickupTime: row.pickupTime,
    );
  }

  static List<BookingServiceModel> _convertServices(
    List<NewBookingService> services,
  ) {
    return services.map((s) {
      return BookingServiceModel(
        id: 0,
        serviceId: s.serviceAgent?.serviceId ?? 0,
        serviceName: s.serviceAgent?.serviceName,
        locationId: s.serviceAgent?.locationId,
        adultNumber: s.adult,
        childNumber: s.child,
        kidNumber: s.kid,
        adultPrice: s.serviceAgent?.adultPrice ?? 0.0,
        childPrice: s.serviceAgent?.childPrice ?? 0.0,
        kidPrice: s.serviceAgent?.kidPrice ?? 0.0,
        totalPriceService: s.totalPrice,
      );
    }).toList();
  }
}



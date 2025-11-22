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
      // Default status to PENDING if empty
      statusBook: row.status.isNotEmpty ? row.status.toUpperCase() : 'PENDING',
      agentName: row.agent?.id ?? 0,
      agentNameStr: row.agent?.name,
      // If location is Global (id = -1), send null so it won't be included in the request
      // Otherwise, send the location ID (even if it's a default selection)
      locationId: (row.location?.id != null && row.location!.id == -1) ? null : row.location?.id,
      locationName: row.location?.name,
      hotelName: row.hotel?.name,
      room: row.room,
      note: row.note,
      driver: row.driver?.name,
      carNumber: row.carNumber,
      // Convert payment to uppercase (CASH, CARD, PENDING)
      payment: row.payment.toUpperCase(),
      typeOperation: 'BOOKING',
      services: _convertServices(row.services),
      priceBeforePercentage: row.priceBeforeDiscount,
      priceAfterPercentage: row.priceAfterDiscount,
      finalPrice: row.netProfit,
      voucher: row.voucher,
      orderNumber: row.orderNumber,
      pickupTime: row.pickupTime,
      // Set default pickupStatus to 'YET' if not selected
      pickupStatus: row.pickupStatus ?? 'YET',
    );
  }

  static List<BookingServiceModel> _convertServices(
    List<NewBookingService> services,
  ) {
    return services
        .where((s) => s.serviceAgent != null) // Filter out services without selection
        .map((s) {
      return BookingServiceModel(
        id: 0,
        serviceId: s.serviceAgent!.serviceId,
        serviceName: s.serviceAgent!.serviceName,
        // locationId can be null for global services
        locationId: s.serviceAgent!.locationId,
        adultNumber: s.adult,
        childNumber: s.child,
        kidNumber: s.kid,
        adultPrice: s.serviceAgent!.adultPrice,
        childPrice: s.serviceAgent!.childPrice ?? 0.0,
        kidPrice: s.serviceAgent!.kidPrice ?? 0.0,
        totalPriceService: s.totalPrice,
      );
    }).toList();
  }
}



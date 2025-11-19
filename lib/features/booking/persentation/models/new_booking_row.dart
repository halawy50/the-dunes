import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/models/driver_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

class NewBookingRow {
  String? ticketNumber;
  String? orderNumber;
  String? pickupTime;
  String guestName;
  String? phoneNumber;
  LocationModel? location;
  String status;
  AgentModel? agent;
  HotelModel? hotel;
  int? room;
  String? note;
  DriverModel? driver;
  int? carNumber;
  String payment;
  String currency;
  double priceBeforeDiscount;
  double discount;
  double priceAfterDiscount;
  double vat;
  double netProfit;
  List<NewBookingService> services;

  NewBookingRow({
    this.ticketNumber,
    this.orderNumber,
    this.pickupTime,
    required this.guestName,
    this.phoneNumber,
    this.location,
    this.status = 'PENDING',
    this.agent,
    this.hotel,
    this.room,
    this.note,
    this.driver,
    this.carNumber,
    this.payment = 'Cash',
    this.currency = 'AED',
    this.priceBeforeDiscount = 0.0,
    this.discount = 0.0,
    this.priceAfterDiscount = 0.0,
    this.vat = 0.0,
    this.netProfit = 0.0,
    List<NewBookingService>? services,
  }) : services = services ?? [];

  void calculateTotals() {
    double total = 0.0;
    for (var service in services) {
      service.calculateTotal();
      total += service.totalPrice;
    }
    priceBeforeDiscount = total;
    priceAfterDiscount = priceBeforeDiscount * (1 - discount / 100);
    vat = priceAfterDiscount * 0.05;
    netProfit = priceAfterDiscount + vat;
  }

}


import 'package:the_dunes/features/booking/data/models/service_agent_model.dart';

class NewBookingService {
  ServiceAgentModel? serviceAgent;
  int adult;
  int child;
  int kid;
  double adultPrice;
  double childPrice;
  double kidPrice;
  double totalPrice;

  NewBookingService({
    this.serviceAgent,
    this.adult = 0,
    this.child = 0,
    this.kid = 0,
    this.adultPrice = 0.0,
    this.childPrice = 0.0,
    this.kidPrice = 0.0,
    this.totalPrice = 0.0,
  });

  void calculateTotal() {
    adultPrice = (serviceAgent?.adultPrice ?? 0.0) * adult;
    childPrice = (serviceAgent?.childPrice ?? 0.0) * child;
    kidPrice = (serviceAgent?.kidPrice ?? 0.0) * kid;
    totalPrice = adultPrice + childPrice + kidPrice;
  }
}



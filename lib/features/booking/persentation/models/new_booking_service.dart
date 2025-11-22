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
    if (serviceAgent != null) {
      // Set unit prices from service agent (these are per-person prices)
      adultPrice = serviceAgent!.adultPrice;
      childPrice = serviceAgent!.childPrice ?? 0.0;
      kidPrice = serviceAgent!.kidPrice ?? 0.0;
      
      // Calculate total price based on quantity × unit price
      totalPrice = (adultPrice * adult) + (childPrice * child) + (kidPrice * kid);
      
      print('[NewBookingService] 💰 Calculating total:');
      print('  Adult: $adult × $adultPrice = ${adultPrice * adult}');
      print('  Child: $child × $childPrice = ${childPrice * child}');
      print('  Kid: $kid × $kidPrice = ${kidPrice * kid}');
      print('  Total: $totalPrice');
    } else {
      // Reset all prices if no service is selected
      adultPrice = 0.0;
      childPrice = 0.0;
      kidPrice = 0.0;
      totalPrice = 0.0;
      print('[NewBookingService] 💰 No service selected, prices reset to 0');
    }
  }
}



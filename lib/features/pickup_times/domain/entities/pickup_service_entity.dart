class PickupServiceEntity {
  final int id;
  final int serviceId;
  final String serviceName;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPrice;

  PickupServiceEntity({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPrice,
  });
}


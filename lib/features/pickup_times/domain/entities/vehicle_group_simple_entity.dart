class VehicleGroupSimpleEntity {
  final String pickupGroupId;
  final int? carNumber;
  final String? driver;
  final int totalItems;

  VehicleGroupSimpleEntity({
    required this.pickupGroupId,
    this.carNumber,
    this.driver,
    required this.totalItems,
  });
}


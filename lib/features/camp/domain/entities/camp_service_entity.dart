import 'package:equatable/equatable.dart';

class CampServiceEntity extends Equatable {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPrice;

  const CampServiceEntity({
    required this.id,
    required this.serviceId,
    this.serviceName,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        serviceId,
        serviceName,
        adultNumber,
        childNumber,
        kidNumber,
        adultPrice,
        childPrice,
        kidPrice,
        totalPrice,
      ];
}


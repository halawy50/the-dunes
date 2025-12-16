import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_service_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';

class PickupTableItem {
  final String type;
  final PickupBookingEntity? booking;
  final PickupVoucherEntity? voucher;
  final String? pickupGroupId;
  final int? carNumber;
  final String? driver;

  PickupTableItem({
    required this.type,
    this.booking,
    this.voucher,
    this.pickupGroupId,
    this.carNumber,
    this.driver,
  });

  int get id => booking?.id ?? voucher?.id ?? 0;
  String get guestName => booking?.guestName ?? voucher?.guestName ?? '';
  String get phoneNumber => booking?.phoneNumber ?? voucher?.phoneNumber ?? '';
  String get payment => booking?.payment ?? voucher?.payment ?? '';
  String get status => booking?.statusBook ?? voucher?.status ?? '';
  String? get pickupStatus => booking?.pickupStatus ?? voucher?.pickupStatus;
  String? get pickupTime => booking?.pickupTime ?? 
      (voucher?.pickupTime != null 
          ? _formatTimestamp(voucher!.pickupTime!) 
          : null);
  List<PickupServiceEntity> get services => booking?.services ?? voucher?.services ?? [];
  int? get room => booking?.room ?? voucher?.room;
  String? get agentName => booking?.agentName ?? voucher?.agentName;
  String? get location => booking?.locationName ?? booking?.location ?? voucher?.locationName ?? voucher?.location;
  String? get hotel => booking?.hotelName ?? voucher?.hotel;
  double get finalPrice {
    return services.fold(0.0, (sum, service) => sum + service.totalPrice);
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickupTableItem &&
        other.type == type &&
        other.id == id;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;
}


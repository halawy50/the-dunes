import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_item_actions.dart';

class PickupItemCard extends StatelessWidget {
  final PickupBookingEntity? booking;
  final PickupVoucherEntity? voucher;
  final bool isSelected;

  const PickupItemCard({
    super.key,
    this.booking,
    this.voucher,
    required this.isSelected,
  });

  String get itemId => booking != null
      ? 'booking_${booking!.id}'
      : 'voucher_${voucher!.id}';

  @override
  Widget build(BuildContext context) {
    final isBooking = booking != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isSelected ? AppColor.YELLOW.withOpacity(0.2) : AppColor.WHITE,
      child: InkWell(
        onTap: () {
          context.read<PickupTimesCubit>().toggleItemSelection(itemId);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      context.read<PickupTimesCubit>().toggleItemSelection(itemId);
                    },
                  ),
              Expanded(
                child: Text(
                  isBooking ? booking!.guestName : voucher!.guestName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                  Chip(
                    label: Text(
                      isBooking ? 'pickup_times.booking'.tr() : 'pickup_times.voucher'.tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow('pickup_times.phone'.tr(), isBooking ? booking!.phoneNumber : voucher!.phoneNumber),
              if (isBooking && booking!.hotelName != null)
                _buildInfoRow('pickup_times.hotel'.tr(), booking!.hotelName!),
              if (!isBooking && voucher!.hotel != null)
                _buildInfoRow('pickup_times.hotel'.tr(), voucher!.hotel!),
              if (isBooking && booking!.room != null)
                _buildInfoRow('pickup_times.room'.tr(), booking!.room.toString()),
              if (!isBooking && voucher!.room != null)
                _buildInfoRow('pickup_times.room'.tr(), voucher!.room.toString()),
              if (isBooking && booking!.agentName != null)
                _buildInfoRow('pickup_times.agent'.tr(), booking!.agentName!),
              if (isBooking && (booking!.locationName != null || booking!.location != null))
                _buildInfoRow('pickup_times.location'.tr(), booking!.locationName ?? booking!.location ?? ''),
              if (!isBooking && (voucher!.locationName != null || voucher!.location != null))
                _buildInfoRow('pickup_times.location'.tr(), voucher!.locationName ?? voucher!.location ?? ''),
              _buildInfoRow('pickup_times.status'.tr(), _getStatusText(isBooking)),
              if (isBooking && booking!.pickupStatus != null)
                _buildInfoRow('pickup_times.pickup_status'.tr(), _getPickupStatusText(booking!.pickupStatus!)),
              if (!isBooking && voucher!.pickupStatus != null)
                _buildInfoRow('pickup_times.pickup_status'.tr(), _getPickupStatusText(voucher!.pickupStatus!)),
              if (isBooking && booking!.pickupTime != null)
                _buildInfoRow('pickup_times.pickup_time'.tr(), booking!.pickupTime!),
              if (!isBooking && voucher!.pickupTime != null)
                _buildInfoRow('pickup_times.pickup_time'.tr(), _formatTimestamp(voucher!.pickupTime!)),
              const SizedBox(height: 8),
              PickupItemActions(
                booking: booking,
                voucher: voucher,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getStatusText(bool isBooking) {
    if (isBooking) {
      return booking!.statusBook;
    }
    return voucher!.status;
  }

  String _getPickupStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'YET':
        return 'pickup_times.pickup_yet'.tr();
      case 'PICKED':
        return 'pickup_times.pickup_picked'.tr();
      case 'DELIVERED':
        return 'pickup_times.pickup_delivered'.tr();
      case 'INWAY':
        return 'pickup_times.pickup_inway'.tr();
      default:
        return status;
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}


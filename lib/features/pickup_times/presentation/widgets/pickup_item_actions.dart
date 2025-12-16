import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/status_update_dialog.dart';

class PickupItemActions extends StatelessWidget {
  final PickupBookingEntity? booking;
  final PickupVoucherEntity? voucher;

  const PickupItemActions({
    super.key,
    this.booking,
    this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => StatusUpdateDialog(
                booking: booking,
                voucher: voucher,
              ),
            );
          },
          icon: const Icon(Icons.edit),
          label: Text('pickup_times.update_status'.tr()),
        ),
      ],
    );
  }
}


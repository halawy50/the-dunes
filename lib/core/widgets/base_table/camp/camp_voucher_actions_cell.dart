import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_voucher_entity.dart';

class CampVoucherActionsCell extends StatelessWidget {
  const CampVoucherActionsCell({
    super.key,
    required this.voucher,
    required this.onStatusUpdate,
    required this.isUpdating,
    this.updatingStatus,
  });

  final CampVoucherEntity voucher;
  final void Function(CampVoucherEntity, String) onStatusUpdate;
  final bool isUpdating;
  final String? updatingStatus;

  @override
  Widget build(BuildContext context) {
    final isUpdatingCompleted = isUpdating && updatingStatus == 'COMPLETED';
    final isUpdatingCancelled = isUpdating && updatingStatus == 'CANCELLED';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: isUpdatingCompleted
                ? null
                : () => onStatusUpdate(voucher, 'COMPLETED'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUpdatingCompleted
                  ? Colors.grey
                  : Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: isUpdatingCompleted
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('camp.complete'.tr()),
                  ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: ElevatedButton(
            onPressed: isUpdatingCancelled
                ? null
                : () => onStatusUpdate(voucher, 'CANCELLED'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUpdatingCancelled
                  ? Colors.grey
                  : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: isUpdatingCancelled
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('camp.cancel'.tr()),
                  ),
          ),
        ),
      ],
    );
  }
}


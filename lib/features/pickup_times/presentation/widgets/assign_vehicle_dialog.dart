import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';

class AssignVehicleDialog extends StatefulWidget {
  final VehicleGroupEntity? existingGroup;

  const AssignVehicleDialog({
    super.key,
    this.existingGroup,
  });

  @override
  State<AssignVehicleDialog> createState() => _AssignVehicleDialogState();
}

class _AssignVehicleDialogState extends State<AssignVehicleDialog> {
  final _carNumberController = TextEditingController();
  final _driverController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingGroup != null) {
      _carNumberController.text = widget.existingGroup!.carNumber.toString();
      _driverController.text = widget.existingGroup!.driver;
    }
  }

  @override
  void dispose() {
    _carNumberController.dispose();
    _driverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PickupTimesCubit>();
    final state = cubit.state;
    final selectedIds = state is PickupTimesLoaded ? state.selectedItemIds : <String>{};

    return AlertDialog(
      title: Text(
        widget.existingGroup != null
            ? 'pickup_times.update_assignment'.tr()
            : 'pickup_times.create_group'.tr(),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _carNumberController,
              decoration: InputDecoration(
                labelText: 'pickup_times.car_number'.tr(),
                hintText: 'pickup_times.car_number'.tr(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _driverController,
              decoration: InputDecoration(
                labelText: 'pickup_times.driver'.tr(),
                hintText: 'pickup_times.driver'.tr(),
              ),
            ),
            if (widget.existingGroup == null && selectedIds.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'pickup_times.create_empty_group_hint'.tr(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr()),
        ),
          ElevatedButton(
          onPressed: _isLoading ? null : () => _handleSubmit(context),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('common.save'.tr()),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final cubit = context.read<PickupTimesCubit>();
    final carNumber = int.tryParse(_carNumberController.text);
    if (carNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pickup_times.car_number_required'.tr()),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final state = cubit.state;
    if (state is PickupTimesLoaded) {
      final selectedIds = state.selectedItemIds;
      final bookingIds = selectedIds
          .where((id) => id.startsWith('booking_'))
          .map((id) => int.parse(id.replaceFirst('booking_', '')))
          .toList();
      final voucherIds = selectedIds
          .where((id) => id.startsWith('voucher_'))
          .map((id) => int.parse(id.replaceFirst('voucher_', '')))
          .toList();

      if (widget.existingGroup != null) {
        await cubit.updateAssignment(
          pickupGroupId: widget.existingGroup!.pickupGroupId,
          carNumber: carNumber,
          driver: _driverController.text.isEmpty ? null : _driverController.text,
          addBookingIds: bookingIds.isNotEmpty ? bookingIds : null,
          addVoucherIds: voucherIds.isNotEmpty ? voucherIds : null,
        );
      } else {
        // إذا كان إنشاء مجموعة جديدة، يجب إزالة العناصر من مجموعاتها القديمة أولاً
        if (bookingIds.isNotEmpty || voucherIds.isNotEmpty) {
          await cubit.removeAssignment(
            bookingIds: bookingIds.isNotEmpty ? bookingIds : null,
            voucherIds: voucherIds.isNotEmpty ? voucherIds : null,
          );
        }
        
        // ثم إنشاء مجموعة جديدة بالسيارة والسائق الجديدين
        await cubit.assignVehicle(
          carNumber: carNumber,
          driver: _driverController.text.isEmpty ? null : _driverController.text,
          bookingIds: bookingIds.isNotEmpty ? bookingIds : null,
          voucherIds: voucherIds.isNotEmpty ? voucherIds : null,
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
      cubit.clearSelection();
    }
  }
}


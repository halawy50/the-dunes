import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_booking_entity.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/pickup_voucher_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';

class StatusUpdateDialog extends StatefulWidget {
  final PickupBookingEntity? booking;
  final PickupVoucherEntity? voucher;

  const StatusUpdateDialog({
    super.key,
    this.booking,
    this.voucher,
  });

  @override
  State<StatusUpdateDialog> createState() => _StatusUpdateDialogState();
}

class _StatusUpdateDialogState extends State<StatusUpdateDialog> {
  String? _selectedStatus;
  String? _selectedPickupStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  @override
  void didUpdateWidget(StatusUpdateDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update status if widget changed
    if (oldWidget.booking?.id != widget.booking?.id ||
        oldWidget.voucher?.id != widget.voucher?.id) {
      _initializeStatus();
    }
  }

  void _initializeStatus() {
    if (widget.booking != null) {
      _selectedStatus = widget.booking!.statusBook;
      _selectedPickupStatus = widget.booking!.pickupStatus;
      if (kDebugMode) {
        print('[StatusUpdateDialog] Initialized with booking ${widget.booking!.id}');
        print('[StatusUpdateDialog] Initial status: $_selectedStatus');
        print('[StatusUpdateDialog] Initial pickup status: $_selectedPickupStatus');
      }
    } else if (widget.voucher != null) {
      _selectedStatus = widget.voucher!.status;
      _selectedPickupStatus = widget.voucher!.pickupStatus;
      if (kDebugMode) {
        print('[StatusUpdateDialog] Initialized with voucher ${widget.voucher!.id}');
        print('[StatusUpdateDialog] Initial status: $_selectedStatus');
        print('[StatusUpdateDialog] Initial pickup status: $_selectedPickupStatus');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PickupTimesCubit, PickupTimesState>(
      listener: (context, state) {
        if (state is PickupTimesLoaded) {
          // Status updated successfully, close dialog
          if (_isLoading && mounted) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          }
        } else if (state is PickupTimesError) {
          // Error occurred, stop loading
          if (_isLoading && mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      child: AlertDialog(
        title: Text('pickup_times.update_status'.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'pickup_times.status'.tr(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusDropdown(
                    key: ValueKey('status_dropdown_${widget.booking?.id ?? widget.voucher?.id}_$_selectedStatus'),
                    value: _selectedStatus,
                    items: ['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED'],
                    onChanged: _isLoading ? null : (value) {
                      if (kDebugMode) {
                        print('[StatusUpdateDialog] ========== STATUS DROPDOWN CHANGED ==========');
                        print('[StatusUpdateDialog] Old _selectedStatus: $_selectedStatus');
                        print('[StatusUpdateDialog] New value received: $value');
                      }
                      if (value != null && value != _selectedStatus) {
                        if (kDebugMode) {
                          print('[StatusUpdateDialog] Updating _selectedStatus from $_selectedStatus to $value');
                        }
                        setState(() {
                          _selectedStatus = value;
                        });
                        if (kDebugMode) {
                          print('[StatusUpdateDialog] After setState, _selectedStatus is now: $_selectedStatus');
                        }
                      } else {
                        if (kDebugMode) {
                          print('[StatusUpdateDialog] ⚠️ Value is null or same as current, not updating');
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'pickup_times.pickup_status'.tr(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  _buildPickupStatusDropdown(
                    value: _selectedPickupStatus,
                    items: ['YET', 'PICKED', 'DELIVERED', 'INWAY'],
                    onChanged: _isLoading ? null : (value) {
                      if (kDebugMode) {
                        print('[StatusUpdateDialog] Pickup status dropdown changed');
                        print('[StatusUpdateDialog] Old _selectedPickupStatus: $_selectedPickupStatus');
                        print('[StatusUpdateDialog] New value: $value');
                      }
                      if (value != null) {
                        setState(() {
                          _selectedPickupStatus = value;
                        });
                        if (kDebugMode) {
                          print('[StatusUpdateDialog] After setState, _selectedPickupStatus: $_selectedPickupStatus');
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _handleSave(context),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'pickup_times.status_pending'.tr();
      case 'ACCEPTED':
        return 'pickup_times.status_accepted'.tr();
      case 'COMPLETED':
        return 'pickup_times.status_completed'.tr();
      case 'CANCELLED':
        return 'pickup_times.status_cancelled'.tr();
      default:
        return status;
    }
  }

  String _getPickupStatusLabel(String status) {
    switch (status) {
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

  Widget _buildStatusDropdown({
    Key? key,
    required String? value,
    required List<String> items,
    void Function(String?)? onChanged,
  }) {
    final validValue = value != null && items.contains(value) ? value : null;
    final bgColor = validValue != null ? _getStatusColor(validValue) : AppColor.WHITE;
    final textColor = validValue != null ? _getStatusTextColor(validValue) : AppColor.BLACK;

    return Container(
      key: key,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey('status_dropdown_field_$value'),
        value: validValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        dropdownColor: AppColor.WHITE,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        items: items.map((status) {
          final itemBgColor = _getStatusColor(status);
          final itemTextColor = _getStatusTextColor(status);
          return DropdownMenuItem(
            value: status,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: itemBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getStatusLabel(status),
                style: TextStyle(
                  color: itemTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down, color: textColor),
      ),
    );
  }

  Widget _buildPickupStatusDropdown({
    required String? value,
    required List<String> items,
    void Function(String?)? onChanged,
  }) {
    final validValue = value != null && items.contains(value) ? value : null;
    final bgColor = validValue != null ? _getPickupStatusColor(validValue) : AppColor.WHITE;
    final textColor = validValue != null ? _getPickupStatusTextColor(validValue) : AppColor.BLACK;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey('pickup_status_dropdown_$value'),
        value: validValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        dropdownColor: AppColor.WHITE,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        items: items.map((status) {
          final itemBgColor = _getPickupStatusColor(status);
          final itemTextColor = _getPickupStatusTextColor(status);
          return DropdownMenuItem(
            value: status,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: itemBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getPickupStatusLabel(status),
                style: TextStyle(
                  color: itemTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down, color: textColor),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade50;
      case 'ACCEPTED':
        return Colors.blue.shade50;
      case 'COMPLETED':
        return Colors.green.shade50;
      case 'CANCELLED':
        return Colors.red.shade50;
      default:
        return AppColor.GRAY_DARK;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade700;
      case 'ACCEPTED':
        return Colors.blue.shade700;
      case 'COMPLETED':
        return Colors.green.shade700;
      case 'CANCELLED':
        return Colors.red.shade700;
      default:
        return AppColor.BLACK;
    }
  }

  Color _getPickupStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'YET':
        return Colors.grey.shade100;
      case 'PICKED':
        return Colors.blue.shade50;
      case 'DELIVERED':
        return Colors.green.shade50;
      case 'INWAY':
        return Colors.orange.shade50;
      default:
        return AppColor.GRAY_DARK;
    }
  }

  Color _getPickupStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'YET':
        return Colors.grey.shade700;
      case 'PICKED':
        return Colors.blue.shade700;
      case 'DELIVERED':
        return Colors.green.shade700;
      case 'INWAY':
        return Colors.orange.shade700;
      default:
        return AppColor.BLACK;
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    if (_isLoading) return; // Prevent multiple saves
    
    final cubit = context.read<PickupTimesCubit>();

    if (kDebugMode) {
      print('[StatusUpdateDialog] ========== SAVE BUTTON CLICKED ==========');
      print('[StatusUpdateDialog] Current _selectedStatus: $_selectedStatus');
      print('[StatusUpdateDialog] Current _selectedPickupStatus: $_selectedPickupStatus');
    }

    // CRITICAL: Use the current state values directly, don't capture in variables
    // This ensures we always use the latest values
    if (kDebugMode) {
      print('[StatusUpdateDialog] ========== VALUES BEFORE SAVE ==========');
      print('[StatusUpdateDialog] - _selectedStatus: $_selectedStatus');
      print('[StatusUpdateDialog] - _selectedPickupStatus: $_selectedPickupStatus');
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    // Use the state variables directly in the async operations
    // Don't capture them in local variables to avoid stale values
    if (kDebugMode) {
      print('[StatusUpdateDialog] Values AFTER setState:');
      print('[StatusUpdateDialog] - _selectedStatus: $_selectedStatus');
      print('[StatusUpdateDialog] - _selectedPickupStatus: $_selectedPickupStatus');
    }

    try {
      if (widget.booking != null) {
        final booking = widget.booking!;
        if (kDebugMode) {
          print('[StatusUpdateDialog] Processing booking ${booking.id}');
          print('[StatusUpdateDialog] Booking old status: ${booking.statusBook}');
          print('[StatusUpdateDialog] Booking old pickup status: ${booking.pickupStatus}');
          print('[StatusUpdateDialog] Selected status to send: $_selectedStatus');
          print('[StatusUpdateDialog] Selected pickup status to send: $_selectedPickupStatus');
        }
        
        // Always update booking status with the selected value
        // Use _selectedStatus directly, not captured variable
        if (_selectedStatus != null) {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ✅ Sending booking status: $_selectedStatus');
            print('[StatusUpdateDialog] Verifying: _selectedStatus = $_selectedStatus');
          }
          await cubit.updateStatusFromPickupTime(
            id: booking.id,
            type: 'booking',
            status: _selectedStatus!,
            statusType: 'bookingStatus',
          );
        } else {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ⚠️ _selectedStatus is null, skipping status update');
          }
        }
        
        // Always update pickup status with the selected value
        // Use _selectedPickupStatus directly, not captured variable
        if (_selectedPickupStatus != null) {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ✅ Sending booking pickup status: $_selectedPickupStatus');
            print('[StatusUpdateDialog] Verifying: _selectedPickupStatus = $_selectedPickupStatus');
          }
          await cubit.updateStatusFromPickupTime(
            id: booking.id,
            type: 'booking',
            status: _selectedPickupStatus!,
            statusType: 'pickupStatus',
          );
        } else {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ⚠️ _selectedPickupStatus is null, skipping pickup status update');
          }
        }
      } else if (widget.voucher != null) {
        final voucher = widget.voucher!;
        if (kDebugMode) {
          print('[StatusUpdateDialog] Processing voucher ${voucher.id}');
          print('[StatusUpdateDialog] Voucher old status: ${voucher.status}');
          print('[StatusUpdateDialog] Voucher old pickup status: ${voucher.pickupStatus}');
          print('[StatusUpdateDialog] Selected status to send: $_selectedStatus');
          print('[StatusUpdateDialog] Selected pickup status to send: $_selectedPickupStatus');
        }
        
        // Always update voucher status with the selected value
        // Use _selectedStatus directly, not captured variable
        if (_selectedStatus != null) {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ✅ Sending voucher status: $_selectedStatus');
            print('[StatusUpdateDialog] Verifying: _selectedStatus = $_selectedStatus');
            print('[StatusUpdateDialog] Voucher old status: ${voucher.status}');
            print('[StatusUpdateDialog] Voucher new status to send: $_selectedStatus');
          }
          await cubit.updateStatusFromPickupTime(
            id: voucher.id,
            type: 'voucher',
            status: _selectedStatus!,
            statusType: 'bookingStatus',
          );
        } else {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ⚠️ _selectedStatus is null, skipping status update');
          }
        }
        
        // Always update pickup status with the selected value
        // Use _selectedPickupStatus directly, not captured variable
        if (_selectedPickupStatus != null) {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ✅ Sending voucher pickup status: $_selectedPickupStatus');
            print('[StatusUpdateDialog] Verifying: _selectedPickupStatus = $_selectedPickupStatus');
          }
          await cubit.updateStatusFromPickupTime(
            id: voucher.id,
            type: 'voucher',
            status: _selectedPickupStatus!,
            statusType: 'pickupStatus',
          );
        } else {
          if (kDebugMode) {
            print('[StatusUpdateDialog] ⚠️ _selectedPickupStatus is null, skipping pickup status update');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[StatusUpdateDialog] ❌ Error updating status: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}


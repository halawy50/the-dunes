import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';

class EmployeePermissionsGrid extends StatelessWidget {
  const EmployeePermissionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      buildWhen: (previous, current) => 
          current is NewEmployeeFormUpdated || 
          current is NewEmployeeInitial,
      builder: (context, state) {
        return _buildGrid(context);
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    final screens = _getScreens();
    final firstRowScreens = screens.take(6).toList();
    final secondRowScreens = screens.skip(6).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(context, firstRowScreens),
        const SizedBox(height: 8),
        _buildRow(context, secondRowScreens),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<PermissionScreen> screens,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: screens.map((screen) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: screen != screens.last ? 8 : 0,
            ),
            child: _buildScreenColumn(context, screen),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScreenColumn(
    BuildContext context,
    PermissionScreen screen,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        border: Border.all(color: AppColor.GRAY_D8D8D8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.GRAY_WHITE,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    screen.title.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _GlobalPermissionCheckbox(
                  screenKey: screen.key,
                  permissions: screen.permissions,
                ),
              ],
            ),
          ),
          ...screen.permissions.asMap().entries.map((entry) {
            final index = entry.key;
            final perm = entry.value;
            return _buildPermissionItem(
              context,
              perm,
              index,
              screen.key,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context,
    PermissionItem perm,
    int index,
    String screenKey,
  ) {
    return _PermissionCheckbox(
      permissionKey: perm.key,
      label: perm.label,
      index: index,
      screenKey: screenKey,
    );
  }

  List<PermissionScreen> _getScreens() {
    return [
      PermissionScreen(
        key: 'receiptVoucherScreen',
        title: 'employees.receipt_voucher_screen',
        permissions: [
          PermissionItem('showAllReceiptVoucher', 'employees.show_all_receipt_voucher'),
          PermissionItem('showReceiptVoucherAdded', 'employees.show_my_receipt_vouchers'),
          PermissionItem('addNewReceiptVoucherMe', 'employees.add_new_receipt_voucher'),
          PermissionItem('addNewReceiptVoucherOtherEmployee', 'employees.add_new_receipt_voucher_other'),
          PermissionItem('editReceiptVoucher', 'employees.edit_all_receipt_voucher'),
          PermissionItem('editReceiptVoucherMe', 'employees.edit_my_receipt_voucher'),
          PermissionItem('deleteReceiptVoucher', 'employees.delete_any_receipt_voucher'),
          PermissionItem('deleteReceiptVoucherMe', 'employees.delete_my_receipt_voucher'),
        ],
      ),
      PermissionScreen(
        key: 'bookingScreen',
        title: 'employees.bookings_page_screen',
        permissions: [
          PermissionItem('showAllBooking', 'employees.show_all_bookings'),
          PermissionItem('showMyBookAdded', 'employees.show_my_bookings'),
          PermissionItem('addNewBook', 'employees.add_new_bookings'),
          PermissionItem('editBook', 'employees.edit_any_bookings'),
          PermissionItem('editBookMe', 'employees.edit_my_bookings'),
          PermissionItem('deleteBook', 'employees.delete_any_bookings'),
          PermissionItem('deleteBookMe', 'employees.delete_my_bookings'),
        ],
      ),
      PermissionScreen(
        key: 'pickupTimeScreen',
        title: 'employees.pickup_time_screen',
        permissions: [
          PermissionItem('showAllPickup', 'employees.show_all_pickup'),
          PermissionItem('editAnyPickup', 'employees.edit_any_pickup'),
        ],
      ),
      PermissionScreen(
        key: 'serviceScreen',
        title: 'employees.services_screen',
        permissions: [
          PermissionItem('showAllService', 'employees.show_all_services'),
          PermissionItem('addNewService', 'employees.add_new_services'),
          PermissionItem('editService', 'employees.edit_any_services'),
          PermissionItem('deleteService', 'employees.delete_any_services'),
        ],
      ),
      PermissionScreen(
        key: 'hotelScreen',
        title: 'employees.hotels_screen',
        permissions: [
          PermissionItem('showAllHotels', 'employees.show_all_hotels'),
          PermissionItem('addNewHotels', 'employees.add_new_hotels'),
          PermissionItem('editHotels', 'employees.edit_any_hotels'),
          PermissionItem('deleteHotels', 'employees.delete_any_hotels'),
        ],
      ),
      PermissionScreen(
        key: 'campScreen',
        title: 'employees.camp_bookings',
        permissions: [
          PermissionItem('showAllCampBookings', 'employees.show_all_camp_bookings'),
          PermissionItem('changeStateBooking', 'employees.change_state_any_camp_bookings'),
        ],
      ),
      PermissionScreen(
        key: 'employeeScreen',
        title: 'employees.employee',
        permissions: [
          PermissionItem('showAllEmployees', 'employees.show_all_employees'),
          PermissionItem('addNewEmployee', 'employees.add_new_employee'),
          PermissionItem('editAnyEmployees', 'employees.edit_any_employees'),
          PermissionItem('changeStateAnyEmployees', 'employees.change_state_any_employees'),
        ],
      ),
      PermissionScreen(
        key: 'operationsScreen',
        title: 'employees.other_operations',
        permissions: [
          PermissionItem('showAllOperations', 'employees.show_all_other_operations'),
          PermissionItem('addNewOperation', 'employees.add_new_operations'),
          PermissionItem('editOperation', 'employees.edit_any_operations'),
          PermissionItem('deleteOperation', 'employees.delete_any_operations'),
        ],
      ),
      PermissionScreen(
        key: 'analysisScreen',
        title: 'employees.analysis',
        permissions: [
          PermissionItem('analysisScreen', 'employees.analysis'),
        ],
      ),
      PermissionScreen(
        key: 'settingScreen',
        title: 'employees.setting',
        permissions: [
          PermissionItem('settingScreen', 'employees.setting'),
        ],
      ),
    ];
  }
}

class PermissionScreen {
  final String key;
  final String title;
  final List<PermissionItem> permissions;

  PermissionScreen({
    required this.key,
    required this.title,
    required this.permissions,
  });
}

class PermissionItem {
  final String key;
  final String label;

  PermissionItem(this.key, this.label);
}

class _PermissionCheckbox extends StatelessWidget {
  final String permissionKey;
  final String label;
  final int index;
  final String screenKey;

  const _PermissionCheckbox({
    required this.permissionKey,
    required this.label,
    required this.index,
    required this.screenKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      buildWhen: (previous, current) {
        // Always rebuild on NewEmployeeFormUpdated to ensure state is synced
        if (current is NewEmployeeFormUpdated) {
          // Rebuild if this permission was updated, or if global was updated for this screen
          final updatedKey = current.updatedPermissionKey ?? '';
          return updatedKey.startsWith(permissionKey) || 
                 updatedKey == 'global_$screenKey' ||
                 updatedKey.isEmpty;
        }
        return current is NewEmployeeInitial;
      },
      builder: (context, state) {
        final cubit = context.read<NewEmployeeCubit>();
        final isChecked = cubit.getUIPermission(permissionKey);
        
        return Container(
          key: ValueKey('permission_${permissionKey}_${label}_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColor.GRAY_D8D8D8, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label.tr(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Checkbox(
                key: ValueKey('checkbox_${permissionKey}_${label}_$index'),
                value: isChecked,
                onChanged: (checked) {
                  // Toggle the permission - allow both true and false
                  final newValue = checked ?? false;
                  cubit.updatePermission(permissionKey, newValue);
                },
                activeColor: AppColor.YELLOW,
                tristate: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlobalPermissionCheckbox extends StatelessWidget {
  final String screenKey;
  final List<PermissionItem> permissions;

  const _GlobalPermissionCheckbox({
    required this.screenKey,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      buildWhen: (previous, current) {
        if (current is NewEmployeeFormUpdated) {
          // Rebuild if any permission in this screen changed or global changed
          return permissions.any((perm) => 
                 current.updatedPermissionKey == perm.key) ||
                 current.updatedPermissionKey == 'global_$screenKey' ||
                 current.updatedPermissionKey == null;
        }
        return current is NewEmployeeInitial;
      },
      builder: (context, state) {
        final cubit = context.read<NewEmployeeCubit>();
        final allChecked = permissions.every(
          (perm) => cubit.getUIPermission(perm.key),
        );
        
        return Checkbox(
          value: allChecked,
          onChanged: (checked) {
            final value = checked ?? false;
            for (final perm in permissions) {
              cubit.updatePermission(perm.key, value);
            }
            cubit.updatePermission('global_$screenKey', value);
          },
          activeColor: AppColor.YELLOW,
        );
      },
    );
  }
}

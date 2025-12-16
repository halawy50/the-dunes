import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_commission_bulk_pay_content.dart';

class EmployeeCommissionBulkPayDialog {
  static void show(
    BuildContext context,
    List<CommissionEntity> selectedCommissions,
    VoidCallback onSuccess,
  ) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('employees.bulk_pay_commissions'.tr()),
        content: EmployeeCommissionBulkPayContent(
          selectedCommissions: selectedCommissions,
          noteController: noteController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final commissionIds = selectedCommissions.map((c) => c.id).toList();
              
              try {
                final response = await context
                    .read<EmployeeDetailCubit>()
                    .bulkPayCommissions(
                      commissionIds,
                      note: noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                    );

                if (response != null && context.mounted) {
                  onSuccess();

                  if (response.totalFailed > 0) {
                    AppSnackbar.showTranslated(
                      context: context,
                      translationKey: 'employees.bulk_pay_partial_success'.tr(
                        namedArgs: {
                          'paid': response.totalPaid.toString(),
                          'total': response.totalRequested.toString(),
                        },
                      ),
                      type: SnackbarType.warning,
                    );
                  } else {
                    AppSnackbar.showTranslated(
                      context: context,
                      translationKey: 'employees.bulk_pay_success'.tr(
                        namedArgs: {'count': response.totalPaid.toString()},
                      ),
                      type: SnackbarType.success,
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  final errorMessage = e.toString().replaceAll('ApiException: ', '');
                  AppSnackbar.show(
                    context: context,
                    message: errorMessage,
                    type: SnackbarType.error,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.YELLOW,
            ),
            child: Text('common.pay'.tr()),
          ),
        ],
      ),
    );
  }
}


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/new_receipt_voucher_cubit.dart';

class NewReceiptVoucherHeader extends StatelessWidget {
  const NewReceiptVoucherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      listener: (context, state) {
        if (state is NewReceiptVoucherError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        } else if (state is NewReceiptVoucherSaved) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'receipt_voucher.saved_successfully',
            type: SnackbarType.success,
          );
          context.go('/receipt_voucher');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColor.WHITE,
          boxShadow: [
            BoxShadow(
              color: Color(0x14323232),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/receipt_voucher'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'receipt_voucher.new_voucher'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'receipt_voucher.description'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.GRAY_DARK,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
              builder: (context, state) {
                final cubit = context.read<NewReceiptVoucherCubit>();
                final isLoading = state is NewReceiptVoucherSaving;
                final canSave = cubit.guestName.isNotEmpty &&
                    cubit.services.isNotEmpty &&
                    cubit.areServicesValid();
                
                return ElevatedButton(
                  onPressed: isLoading || !canSave
                      ? null
                      : () {
                          cubit.saveVoucher();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading || !canSave
                        ? AppColor.GRAY_HULF
                        : AppColor.YELLOW,
                    foregroundColor: AppColor.WHITE,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                          ),
                        )
                      : Text('receipt_voucher.book_and_print'.tr()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


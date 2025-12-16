import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_screen_content.dart';

class ReceiptVoucherScreen extends StatefulWidget {
  const ReceiptVoucherScreen({super.key});

  @override
  State<ReceiptVoucherScreen> createState() => _ReceiptVoucherScreenState();
}

class _ReceiptVoucherScreenState extends State<ReceiptVoucherScreen> {
  final List<ReceiptVoucherModel> _selectedVouchers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void _handleVoucherSelect(ReceiptVoucherModel voucher, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedVouchers.add(voucher);
      } else {
        _selectedVouchers.remove(voucher);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ReceiptVoucherCubit>(),
      child: BlocListener<ReceiptVoucherCubit, ReceiptVoucherState>(
        listener: (context, state) {
          if (state is ReceiptVoucherSuccess && state.showSnackbar) {
            if (state.isDelete) {
              AppSnackbar.showTranslated(
                context: context,
                translationKey: 'receipt_voucher.delete_success',
                type: SnackbarType.success,
              );
            } else {
              AppSnackbar.showTranslated(
                context: context,
                translationKey: 'receipt_voucher.update_success',
                type: SnackbarType.success,
              );
            }
          } else if (state is ReceiptVoucherError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<ReceiptVoucherCubit, ReceiptVoucherState>(
          builder: (context, state) {
            if (state is ReceiptVoucherInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ReceiptVoucherCubit>().init();
              });
            }

            if (state is ReceiptVoucherLoading &&
                state is! ReceiptVoucherPageChanged &&
                state is! ReceiptVoucherUpdating &&
                state is! ReceiptVoucherDeleting) {
              return Container(
                color: AppColor.GRAY_F6F6F6,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            void handleVoucherEdit(
                ReceiptVoucherModel voucher, Map<String, dynamic> updates) {
              context.read<ReceiptVoucherCubit>().updateReceiptVoucher(
                    voucher.id,
                    updates,
                  );
            }

            Future<void> handleVoucherDelete(
                ReceiptVoucherModel voucher) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('common.delete_confirmation'.tr()),
                  content: Text('receipt_voucher.delete_confirmation_message'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('common.cancel'.tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text('common.delete'.tr()),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                context.read<ReceiptVoucherCubit>().deleteReceiptVoucher(
                      voucher.id,
                    );
              }
            }

            Future<String> handleDownloadPdf(int id) async {
              return await context.read<ReceiptVoucherCubit>().getReceiptVoucherPdf(id);
            }

            return ReceiptVoucherScreenContent(
              selectedVouchers: _selectedVouchers,
              searchQuery: _searchQuery,
              onVoucherSelect: _handleVoucherSelect,
              onVoucherEdit: handleVoucherEdit,
              onVoucherDelete: handleVoucherDelete,
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
              },
              onDownloadPdf: handleDownloadPdf,
            );
          },
        ),
      ),
    );
  }
}

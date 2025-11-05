import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';

class ReceiptVoucherScreen extends StatefulWidget {
  const ReceiptVoucherScreen({super.key});

  @override
  State<ReceiptVoucherScreen> createState() => _ReceiptVoucherScreenState();
}

class _ReceiptVoucherScreenState extends State<ReceiptVoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<ReceiptVoucherCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<ReceiptVoucherCubit, ReceiptVoucherState>(
        listener: (context, state) {
          if (state is ReceiptVoucherSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'receipt_voucher.success',
              type: SnackbarType.success,
            );
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
            if (state is ReceiptVoucherLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('Receipt Voucher Screen'),
              ),
            );
          },
        ),
      ),
    );
  }
}

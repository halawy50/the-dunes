import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/new_receipt_voucher_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/new_receipt_voucher_header.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/new_receipt_voucher_content.dart';

class NewReceiptVoucherScreen extends StatelessWidget {
  const NewReceiptVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<NewReceiptVoucherCubit>();
        cubit.init();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColor.WHITE,
        body: BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
          builder: (context, state) {
            if (state is NewReceiptVoucherLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SingleChildScrollView(
              child: Column(
                children: [
                  NewReceiptVoucherHeader(),
                  NewReceiptVoucherContent(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

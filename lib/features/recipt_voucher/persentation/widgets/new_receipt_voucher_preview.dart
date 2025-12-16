import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/new_receipt_voucher_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';
import 'package:intl/intl.dart';

class NewReceiptVoucherPreview extends StatelessWidget {
  const NewReceiptVoucherPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => 
          current is NewReceiptVoucherLoaded ||
          current is NewReceiptVoucherAddingService ||
          current is NewReceiptVoucherInitial,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        final now = DateTime.now();
        final dateFormat = DateFormat('yyyy/MM/dd');
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'receipt_voucher.preview_title'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  border: Border.all(color: AppColor.GRAY_DARK),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo_black.png',
                          height: 45,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(height: 45);
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('receipt_voucher.po_box'.tr(), style: const TextStyle(fontSize: 10)),
                            Text('receipt_voucher.mobile'.tr(), style: const TextStyle(fontSize: 10)),
                            Text('receipt_voucher.license_no'.tr(), style: const TextStyle(fontSize: 10)),
                            Text('receipt_voucher.email_contact'.tr(), style: const TextStyle(fontSize: 10)),
                            Text('receipt_voucher.website'.tr(), style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'receipt_voucher.receipt_voucher_title'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('${'receipt_voucher.date_label'.tr()} ${dateFormat.format(now)}', style: const TextStyle(fontSize: 11)),
                    const SizedBox(height: 6),
                    BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        final cubit = context.read<NewReceiptVoucherCubit>();
                        return Text('${'receipt_voucher.received_from'.tr()} ${cubit.guestName}', style: const TextStyle(fontSize: 11));
                      },
                    ),
                    const SizedBox(height: 6),
                    BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        final cubit = context.read<NewReceiptVoucherCubit>();
                        final currency = _getCurrencyName(cubit.currencyId ?? 1);
                        return Text('${'receipt_voucher.the_sum_of'.tr()} ${cubit.priceAfterPercentage.toStringAsFixed(2)} $currency', style: const TextStyle(fontSize: 11));
                      },
                    ),
                    const SizedBox(height: 6),
                    BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        final cubit = context.read<NewReceiptVoucherCubit>();
                        return Text('${'receipt_voucher.payment'.tr()} ${cubit.payment}', style: const TextStyle(fontSize: 11));
                      },
                    ),
                    const SizedBox(height: 6),
                    BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        final cubit = context.read<NewReceiptVoucherCubit>();
                        if (cubit.discountPercentage != null && cubit.discountPercentage! > 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${'receipt_voucher.discount_label'.tr()} ${cubit.discountPercentage}%', style: const TextStyle(fontSize: 11)),
                              const SizedBox(height: 6),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        final cubit = context.read<NewReceiptVoucherCubit>();
                        final services = cubit.services;

                        if (services.isNotEmpty) {
                          return Column(
                            children: [
                              _buildServicesTable(cubit, services),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
                                  buildWhen: (previous, current) => true,
                                  builder: (context, state) {
                                    final cubit = context.read<NewReceiptVoucherCubit>();
                                    final currency = _getCurrencyName(cubit.currencyId ?? 1);
                                    return Text(
                                      '${cubit.priceAfterPercentage.toStringAsFixed(2)} $currency',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('receipt_voucher.accountant'.tr(), style: const TextStyle(fontSize: 11)),
                            const SizedBox(height: 30),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('receipt_voucher.received_by'.tr(), style: const TextStyle(fontSize: 11)),
                                Text(cubit.guestName, style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServicesTable(NewReceiptVoucherCubit cubit, List<ReceiptVoucherServiceModel> services) {
    return BlocBuilder<NewReceiptVoucherCubit, NewReceiptVoucherState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        final cubit = context.read<NewReceiptVoucherCubit>();
        return Table(
          border: TableBorder.all(
            color: Colors.black,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildTableHeader('receipt_voucher.services'.tr()),
                _buildTableHeader('receipt_voucher.adult'.tr()),
                _buildTableHeader('receipt_voucher.child'.tr()),
                _buildTableHeader('receipt_voucher.kid'.tr()),
                _buildTableHeader('receipt_voucher.adult_price'.tr()),
                _buildTableHeader('receipt_voucher.child_price'.tr()),
                _buildTableHeader('receipt_voucher.kid_price'.tr()),
                _buildTableHeader('receipt_voucher.total_price'.tr()),
              ],
            ),
            ...cubit.services.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              final adultTotalPrice = service.adultNumber * service.adultPrice;
              final childTotalPrice = service.childNumber * service.childPrice;
              final kidTotalPrice = service.kidNumber * service.kidPrice;
              final calculatedTotal = adultTotalPrice + childTotalPrice + kidTotalPrice;
              return TableRow(
                children: [
                  _buildTableCell('${index + 1}) ${service.serviceName ?? ''}'),
                  _buildTableCell(service.adultNumber.toString()),
                  _buildTableCell(service.childNumber.toString()),
                  _buildTableCell(service.kidNumber.toString()),
                  _buildTableCell(adultTotalPrice > 0 ? adultTotalPrice.toStringAsFixed(2) : '-'),
                  _buildTableCell(childTotalPrice > 0 ? childTotalPrice.toStringAsFixed(2) : '-'),
                  _buildTableCell(kidTotalPrice > 0 ? kidTotalPrice.toStringAsFixed(2) : '-'),
                  _buildTableCell(calculatedTotal > 0 ? calculatedTotal.toStringAsFixed(2) : '-'),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
      ),
    );
  }

  String _getCurrencyName(int currencyId) {
    switch (currencyId) {
      case 1:
        return 'AED';
      case 2:
        return 'USD';
      case 3:
        return 'EUR';
      default:
        return 'AED';
    }
  }
}


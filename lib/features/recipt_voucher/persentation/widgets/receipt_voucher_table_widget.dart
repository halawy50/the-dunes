import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_service_model.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_table_columns.dart';
import 'package:the_dunes/core/widgets/base_table/receipt_voucher/receipt_voucher_service_table_columns.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';

class ReceiptVoucherTableWidget extends StatelessWidget {
  const ReceiptVoucherTableWidget({
    super.key,
    required this.vouchers,
    required this.selectedVouchers,
    required this.onVoucherSelect,
    required this.onVoucherEdit,
    required this.onVoucherDelete,
    required this.onDownloadPdf,
    this.canEdit = true,
    this.canDelete = true,
  });

  final List<ReceiptVoucherModel> vouchers;
  final List<ReceiptVoucherModel> selectedVouchers;
  final void Function(ReceiptVoucherModel, bool) onVoucherSelect;
  final void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit;
  final void Function(ReceiptVoucherModel) onVoucherDelete;
  final Future<String> Function(int) onDownloadPdf;
  final bool canEdit;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptVoucherCubit, ReceiptVoucherState>(
      builder: (context, state) {
        final cubit = context.read<ReceiptVoucherCubit>();
        final currentPage = cubit.currentPage;
        final pageSize = cubit.pageSize;
        final startNumber = (currentPage - 1) * pageSize + 1;
        final columns = ReceiptVoucherTableColumns.buildColumns(
          onVoucherEdit,
          (id, fieldName) => cubit.isUpdatingVoucher(id, fieldName),
          onVoucherDelete,
          (id) => cubit.isDeletingVoucher(id),
          onDownloadPdf,
          startNumber: startNumber,
          canEdit: canEdit,
          canDelete: canDelete,
        );

        return BaseTableWidget<ReceiptVoucherModel>(
          key: ValueKey('vouchers_${vouchers.length}_${vouchers.map((v) => '${v.id}_${v.status}').join('_')}'),
          columns: columns,
          data: vouchers,
          showCheckbox: true,
          selectedRows: selectedVouchers,
          onRowSelect: onVoucherSelect,
          getSubRows: (voucher) => voucher.services,
          subRowColumns: (voucher, rowIndex) {
            final serviceColumns = ReceiptVoucherServiceTableColumns.buildColumns();
            return serviceColumns.map((col) => BaseTableColumn<dynamic>(
              headerKey: col.headerKey,
              width: col.width,
              cellBuilder: (item, index) {
                return col.cellBuilder(item as ReceiptVoucherServiceModel, index);
              },
              headerPadding: col.headerPadding,
              headerHint: col.headerHint,
            )).toList();
          },
        );
      },
    );
  }
}


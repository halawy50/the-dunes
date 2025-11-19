import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_table_columns.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_service_columns.dart';

class NewBookTable extends StatelessWidget {
  const NewBookTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBookingCubit, NewBookingState>(
      builder: (context, state) {
        final cubit = context.read<NewBookingCubit>();
        final rows = cubit.bookingRows;

        if (rows.isEmpty) {
          return const SizedBox.shrink();
        }

        final columns = NewBookTableColumns.buildColumns(context, cubit);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTableWidget<NewBookingRow>(
              columns: columns,
              data: rows,
              config: BaseTableConfig.editableConfig,
              getSubRows: (row) => row.services,
              subRowColumns: (row, rowIndex) => NewBookServiceColumns.buildColumns(
                context,
                row,
                rowIndex,
                cubit,
              ),
              onAddSubRow: (row, rowIndex) {
                if (row.services.isEmpty) {
                  row.services.add(NewBookingService());
                } else {
                  row.services.add(NewBookingService());
                }
                cubit.updateBookingRow(rowIndex, row);
              },
              subRowTitle: (row, rowIndex) => 'booking.add_service'.tr(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => cubit.addNewBookingRow(),
              icon: const Icon(Icons.add, size: 18),
              label: Text('booking.add_new_book'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.YELLOW,
                foregroundColor: AppColor.WHITE,
              ),
            ),
          ],
        );
      },
    );
  }
}


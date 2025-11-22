import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';
import 'package:the_dunes/core/widgets/base_table/booking/new_book_service_columns.dart';

class NewBookServices extends StatelessWidget {
  const NewBookServices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBookingCubit, NewBookingState>(
      builder: (context, state) {
        final cubit = context.read<NewBookingCubit>();
        final rows = cubit.bookingRows;

        if (rows.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return _buildServiceTable(context, row, index, cubit);
          }).toList(),
        );
      },
    );
  }

  Widget _buildServiceTable(
    BuildContext context,
    NewBookingRow row,
    int rowIndex,
    NewBookingCubit cubit,
  ) {
    if (row.services.isEmpty) {
      row.services.add(NewBookingService());
    }

    final columns = NewBookServiceColumns.buildColumns(
      context,
      row,
      rowIndex,
      cubit,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'booking.services'.tr()} (${rowIndex + 1})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: BaseTableWidget<NewBookingService>(
            columns: columns,
            data: row.services,
            config: BaseTableConfig.editableConfig,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            row.services.add(NewBookingService());
            cubit.updateBookingRow(rowIndex, row);
          },
          icon: const Icon(Icons.add, size: 18),
          label: Text('booking.add_service'.tr()),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.YELLOW,
            foregroundColor: AppColor.WHITE,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}


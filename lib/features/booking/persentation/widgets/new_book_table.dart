import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_config.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_widget.dart';
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
      buildWhen: (previous, current) {
        // Always rebuild when adding row or when state type changes
        if (previous is NewBookingAddingRow || current is NewBookingAddingRow) {
          return true;
        }
        // Only rebuild if rows actually changed (not just state type)
        if (previous is NewBookingLoaded && current is NewBookingLoaded) {
          // Rebuild if timestamp changed significantly (more than 100ms difference)
          final timeDiff = current.timestamp.difference(previous.timestamp);
          return timeDiff.inMilliseconds > 100;
        }
        // Always rebuild on state type change
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        final cubit = context.read<NewBookingCubit>();
        final rows = cubit.bookingRows;

        if (rows.isEmpty) {
          return const SizedBox.shrink();
        }

        final columns = NewBookTableColumns.buildColumns(context, cubit);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTableWidget<NewBookingRow>(
              key: const ValueKey('booking-table'),
              columns: columns,
              data: rows,
              config: BaseTableConfig.editableConfig,
              getSubRows: (row) => row.services,
              subRowColumns: (row, rowIndex) {
                final columns = NewBookServiceColumns.buildColumns(
                  context,
                  row,
                  rowIndex,
                  cubit,
                );
                return columns.map((col) => BaseTableColumn<dynamic>(
                  headerKey: col.headerKey,
                  width: col.width,
                  cellBuilder: (item, index) {
                    return col.cellBuilder(item as NewBookingService, index);
                  },
                  isEditable: col.isEditable,
                  onCellEdit: col.onCellEdit != null 
                    ? (item, newValue) => col.onCellEdit!(item as NewBookingService, newValue)
                    : null,
                  headerPadding: col.headerPadding,
                  headerHint: col.headerHint,
                )).toList();
              },
              onAddSubRow: (row, rowIndex) {
                row.services.add(NewBookingService());
                cubit.updateBookingRow(rowIndex, row);
              },
              canAddSubRow: (row, rowIndex) {
                // Always show Add Service button if there are services available that haven't been selected
                final agentId = row.agent?.id;
                
                if (agentId == null) {
                  return false; // Can't add service if agent not selected
                }
                
                // Get location ID (can be null for global services)
                final locationId = row.location?.id;
                final isGlobalLocation = locationId == null || locationId == -1;
                
                // Get all available services for this agent/location (or global)
                final availableServices = isGlobalLocation
                    ? cubit.getServicesFromCache(agentId, null) // Global services
                    : cubit.getServicesFromCache(agentId, locationId);
                
                // Get IDs of already selected services
                final selectedServiceIds = row.services
                    .where((s) => s.serviceAgent != null)
                    .map((s) => s.serviceAgent!.id)
                    .toSet();
                
                // Check if there are any services that haven't been selected
                final hasAvailableServices = availableServices.any(
                  (service) => !selectedServiceIds.contains(service.id),
                );
                
                return hasAvailableServices;
              },
              subRowTitle: (row, rowIndex) => 'booking.add_service'.tr(),
            ),
            // Add New Book button outside the table
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: BlocBuilder<NewBookingCubit, NewBookingState>(
                buildWhen: (previous, current) {
                  // Rebuild button when adding row state changes
                  return previous is NewBookingAddingRow != current is NewBookingAddingRow;
                },
                builder: (context, state) {
                  final isLoading = state is NewBookingAddingRow;
                  return ElevatedButton.icon(
                    onPressed: isLoading ? null : () {
                      cubit.addNewBookingRow();
                    },
                    icon: isLoading 
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                            ),
                          )
                        : const Icon(Icons.add_circle_outline, size: 22),
                    label: Text(
                      'booking.add_new_book'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? AppColor.GRAY_HULF : AppColor.YELLOW,
                      foregroundColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      minimumSize: const Size(120, 44),
                      tapTargetSize: MaterialTapTargetSize.padded,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}


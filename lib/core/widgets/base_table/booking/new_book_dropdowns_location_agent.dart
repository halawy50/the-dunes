import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_helpers.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';

class NewBookDropdownsLocationAgent {
  static Widget buildLocationDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final locations = cubit.locations;
    return BaseTableDropdownHelpers.modelDropdown<int>(
      value: row.location?.id,
      items: locations.map((l) => l.id).toList(),
      onChanged: (value) async {
        if (value != null) {
          row.location = locations.firstWhere((l) => l.id == value);
          if (row.location != null && row.agent != null) {
            await cubit.getServicesForAgentAndLocation(
              row.agent!.id,
              row.location!.id,
            );
          }
          cubit.updateBookingRow(index, row);
        }
      },
      getDisplayText: (id) => locations.firstWhere((l) => l.id == id).name,
    );
  }

  static Widget buildAgentDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    final agents = cubit.agents;
    return BaseTableDropdownHelpers.modelDropdown<int>(
      value: row.agent?.id,
      items: agents.map((a) => a.id).toList(),
      onChanged: (value) async {
        if (value != null) {
          row.agent = agents.firstWhere((a) => a.id == value);
          if (row.location != null && row.agent != null) {
            await cubit.getServicesForAgentAndLocation(
              row.agent!.id,
              row.location!.id,
            );
          }
          cubit.updateBookingRow(index, row);
        }
      },
      getDisplayText: (id) => agents.firstWhere((a) => a.id == id).name,
    );
  }
}



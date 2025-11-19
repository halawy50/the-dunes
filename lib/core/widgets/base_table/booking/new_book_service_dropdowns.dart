import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

class NewBookServiceDropdowns {
  static Widget buildServiceDropdown(
    BuildContext context,
    NewBookingService service,
    int serviceIndex,
    NewBookingRow row,
    int rowIndex,
    NewBookingCubit cubit,
  ) {
    if (row.agent == null || row.location == null) {
      return Text(
        'booking.select_agent_location'.tr(),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      );
    }

    return FutureBuilder<List>(
      future: cubit.getServicesForAgentAndLocation(
        row.agent!.id,
        row.location!.id,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading...', style: TextStyle(fontSize: 13));
        }

        final services = snapshot.data!;
        return DropdownButtonFormField<int>(
          value: service.serviceAgent?.serviceId,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            isDense: true,
            hintText: 'Select Service',
          ),
          items: services.map((serviceAgent) {
            return DropdownMenuItem<int>(
              value: serviceAgent.serviceId,
              child: Text(
                serviceAgent.serviceName ?? 'Service',
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (value) {
            service.serviceAgent = services.firstWhere(
              (s) => s.serviceId == value,
            );
            service.calculateTotal();
            row.calculateTotals();
            cubit.updateBookingRow(rowIndex, row);
          },
        );
      },
    );
  }
}



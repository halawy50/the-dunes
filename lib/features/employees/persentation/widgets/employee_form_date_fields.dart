import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';

class EmployeeFormDateFields {
  static Widget buildDateField(
    BuildContext context,
    NewEmployeeCubit cubit,
    String label,
    String? Function() getValue,
    void Function(String?) onChanged,
  ) {
    return BlocBuilder<NewEmployeeCubit, NewEmployeeState>(
      buildWhen: (previous, current) {
        // Always rebuild on NewEmployeeFormUpdated to ensure state is synced
        return current is NewEmployeeFormUpdated || current is NewEmployeeInitial;
      },
      builder: (context, state) {
        // Get the current value from cubit
        final currentValue = getValue();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: currentValue != null && currentValue.isNotEmpty
                      ? DateFormat('yyyy/MM/dd').parse(currentValue)
                      : DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  onChanged(DateFormat('yyyy/MM/dd').format(date));
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  currentValue ?? '',
                  style: TextStyle(
                    color: currentValue != null && currentValue.isNotEmpty
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



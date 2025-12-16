import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeDetailInfo extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeDetailInfo({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'employees.details'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('employees.email'.tr(), employee.email),
          if (employee.phoneNumber != null)
            _buildInfoRow('employees.phone_number'.tr(), employee.phoneNumber!),
          if (employee.position != null)
            _buildInfoRow('employees.position'.tr(), employee.position!),
          if (employee.areaOfLocation != null)
            _buildInfoRow('employees.area_of_location'.tr(), employee.areaOfLocation!),
          if (employee.hotel != null)
            _buildInfoRow('employees.hotel'.tr(), employee.hotel!),
          if (employee.joiningDate != null)
            _buildInfoRow('employees.joining_date'.tr(), employee.joiningDate!),
          _buildInfoRow('employees.status'.tr(), employee.statusEmployee),
          if (employee.isSalary && employee.salary != null)
            _buildInfoRow('employees.salary'.tr(), '${employee.salary!.toStringAsFixed(2)} AED'),
          if (employee.isCommission && employee.commission != null)
            _buildInfoRow('employees.commission'.tr(), '${employee.commission!.toStringAsFixed(2)}%'),
          if (employee.profit != null)
            _buildInfoRow('employees.profit'.tr(), '${employee.profit!.toStringAsFixed(2)} AED'),
          if (employee.visaCost != null)
            _buildInfoRow('employees.visa_cost'.tr(), '${employee.visaCost!.toStringAsFixed(2)} AED'),
          if (employee.startVisa != null)
            _buildInfoRow('employees.start_visa'.tr(), employee.startVisa!),
          if (employee.endVisa != null)
            _buildInfoRow('employees.end_visa'.tr(), employee.endVisa!),
          if (employee.addedBy != null)
            _buildInfoRow('employees.added_by'.tr(), employee.addedBy!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.GRAY_HULF,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.BLACK,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


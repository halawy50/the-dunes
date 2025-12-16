import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_cell_factory.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_column.dart';
import 'package:the_dunes/core/widgets/base_table/employees/employee_table_helpers.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeTableColumns {
  static List<BaseTableColumn<EmployeeEntity>> buildColumns() {
    return [
      BaseTableColumn<EmployeeEntity>(
        headerKey: '',
        width: 60,
        cellBuilder: (item, index) => Center(
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColor.YELLOW,
            child: item.image != null && item.image!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      item.image!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          item.name.isNotEmpty ? item.name[0].toUpperCase() : 'E',
                          style: const TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    item.name.isNotEmpty ? item.name[0].toUpperCase() : 'E',
                    style: const TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.full_name',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.name,
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.added_by',
        width: 180,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.addedBy ?? '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.position',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.position ?? '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.status',
        width: 100,
        cellBuilder: (item, index) => BaseTableCellFactory.status(
          status: item.statusEmployee == 'ACTIVE'
              ? 'employees.active'.tr()
              : 'employees.inactive'.tr(),
          color: item.statusEmployee == 'ACTIVE'
              ? Colors.green
              : AppColor.GRAY_HULF,
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.phone',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.phoneNumber ?? '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.sallery',
        width: 150,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.salary != null
              ? '${item.salary!.toStringAsFixed(0)} AED/Month'
              : item.isCommission
                  ? '${item.commission ?? 0}%'
                  : 'employees.hide'.tr(),
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.commission',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.commission != null
              ? '${item.commission}%'
              : item.isCommission
                  ? '${item.commission ?? 0}%'
                  : 'n/a',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.employee_emirati',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.isEmarat ? 'employees.yes'.tr() : 'employees.no'.tr(),
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.visa_cost',
        width: 120,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.visaCost != null
              ? '${item.visaCost!.toStringAsFixed(0)} AED'
              : '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.area_of_location',
        width: 200,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.areaOfLocation ?? '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.paid_salary',
        width: 130,
        cellBuilder: (item, index) {
          if (!item.isSalary) {
            return BaseTableCellFactory.text(text: '-');
          }
          final status = EmployeeTableHelpers.getPaidSalaryStatus(item);
          return BaseTableCellFactory.status(
            status: status['text']!,
            color: status['color']!,
          );
        },
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.paid_commission',
        width: 150,
        cellBuilder: (item, index) {
          if (!item.isCommission) {
            return BaseTableCellFactory.text(text: '-');
          }
          return BaseTableCellFactory.text(
            text: item.profit != null
                ? '${item.profit!.toStringAsFixed(2)} AED'
                : '-',
          );
        },
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.joining_date',
        width: 130,
        cellBuilder: (item, index) => BaseTableCellFactory.text(
          text: item.joiningDate ?? '-',
        ),
      ),
      BaseTableColumn<EmployeeEntity>(
        headerKey: 'employees.permissions',
        width: 150,
        cellBuilder: (item, index) {
          final permissionsText = EmployeeTableHelpers.getPermissionsText(item);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              permissionsText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    ];
  }
}

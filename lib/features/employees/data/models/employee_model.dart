import 'package:the_dunes/features/employees/data/models/employee_factory.dart';
import 'package:the_dunes/features/employees/data/models/employee_json_helper.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.position,
    super.image,
    super.statusEmployee,
    super.isEmarat,
    super.visaCost,
    super.isSalary,
    super.isCommission,
    super.salary,
    super.commission,
    super.areaOfLocation,
    super.hotel,
    super.startVisa,
    super.endVisa,
    super.permissions,
    super.addedBy,
    super.joiningDate,
    super.profit,
    super.lastMonthSalaryStatus,
    super.lastMonthSalaryStatusText,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return EmployeeJsonHelper.toJson(this);
  }
}




import 'package:the_dunes/features/employees/data/models/employee_model.dart';

class EmployeeJsonHelper {
  static Map<String, dynamic> toJson(EmployeeModel employee) {
    final json = <String, dynamic>{
      'name': employee.name,
      'email': employee.email,
      'isEmarat': employee.isEmarat.toString(),
      'isSalary': employee.isSalary.toString(),
      'isCommission': employee.isCommission.toString(),
    };

    if (employee.phoneNumber != null) {
      json['phoneNumber'] = employee.phoneNumber;
    }
    if (employee.position != null) {
      json['position'] = employee.position;
    }
    if (employee.visaCost != null) {
      json['visaCost'] = employee.visaCost!.toString();
    }
    if (employee.salary != null) {
      json['salary'] = employee.salary!.toString();
    }
    if (employee.commission != null) {
      json['commission'] = employee.commission!.toString();
    }
    if (employee.areaOfLocation != null) {
      json['areaOfLocation'] = employee.areaOfLocation;
    }
    if (employee.hotel != null) {
      json['hotel'] = employee.hotel;
    }
    if (employee.startVisa != null) {
      json['startVisa'] = employee.startVisa;
    }
    if (employee.endVisa != null) {
      json['endVisa'] = employee.endVisa;
    }
    if (employee.permissions != null) {
      json['permissions'] = employee.permissions;
    }
    if (employee.statusEmployee.isNotEmpty) {
      json['statusEmployee'] = employee.statusEmployee;
    }

    return json;
  }
}




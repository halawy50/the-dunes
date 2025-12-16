import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';

class EmployeeFilterHelper {
  static List<EmployeeEntity> filterEmployees(
    List<EmployeeEntity> employees,
    String query,
  ) {
    if (query.isEmpty) return employees;
    final lowerQuery = query.toLowerCase();
    return employees.where((employee) {
      return employee.name.toLowerCase().contains(lowerQuery) ||
          (employee.position?.toLowerCase().contains(lowerQuery) ?? false) ||
          (employee.phoneNumber?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}


import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';

class EmployeeEditSalaryHelper {
  static Map<String, dynamic> buildUpdateData({
    required SalaryEntity salary,
    required String year,
    required String month,
    required double salaryAmount,
  }) {
    final data = <String, dynamic>{};
    if (year != salary.year) {
      data['year'] = year;
    }
    if (month != salary.month) {
      data['month'] = month;
    }
    if (salaryAmount != salary.salary) {
      data['salary'] = salaryAmount;
    }
    return data;
  }
}


import 'package:the_dunes/features/employees/data/models/salary_model.dart';

class SalaryFactory {
  static SalaryModel fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['id'] ?? 0,
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      year: json['year']?.toString() ?? '',
      month: json['month']?.toString() ?? '',
      salary: (json['salary'] is num
          ? (json['salary'] as num).toDouble()
          : double.tryParse(json['salary'].toString()) ?? 0.0),
      statusPaid: json['statusPaid'] ?? 'PENDING',
      typeOperation: json['typeOperation'] ?? 'OUTCOME',
    );
  }
}




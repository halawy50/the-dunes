import 'package:the_dunes/features/employees/data/models/salary_factory.dart';
import 'package:the_dunes/features/employees/domain/entities/salary_entity.dart';

class SalaryModel extends SalaryEntity {
  SalaryModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.year,
    required super.month,
    required super.salary,
    required super.statusPaid,
    required super.typeOperation,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryFactory.fromJson(json);
  }
}




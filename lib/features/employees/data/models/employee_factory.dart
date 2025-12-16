import 'package:the_dunes/features/employees/data/models/employee_model.dart';

class EmployeeFactory {
  static EmployeeModel fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      image: json['image'],
      statusEmployee: json['statusEmployee'] ?? 'ACTIVE',
      isEmarat: json['isEmarat'] == true || json['isEmarat'] == 'true',
      visaCost: json['visaCost'] != null
          ? (json['visaCost'] is num
              ? (json['visaCost'] as num).toDouble()
              : double.tryParse(json['visaCost'].toString()))
          : null,
      isSalary: json['isSalary'] == true || json['isSalary'] == 'true',
      isCommission:
          json['isCommission'] == true || json['isCommission'] == 'true',
      salary: json['salary'] != null
          ? (json['salary'] is num
              ? (json['salary'] as num).toDouble()
              : double.tryParse(json['salary'].toString()))
          : null,
      commission: json['commission'] != null
          ? (json['commission'] is num
              ? (json['commission'] as num).toDouble()
              : double.tryParse(json['commission'].toString()))
          : null,
      areaOfLocation: json['areaOfLocation'],
      hotel: json['hotel'],
      startVisa: json['startVisa'],
      endVisa: json['endVisa'],
      permissions: json['permissions'] as Map<String, dynamic>?,
      addedBy: json['addedBy'],
      joiningDate: json['joinAt'] ?? json['joiningDate'],
      profit: json['profit'] != null
          ? (json['profit'] is num
              ? (json['profit'] as num).toDouble()
              : double.tryParse(json['profit'].toString()))
          : null,
      lastMonthSalaryStatus: json['lastMonthSalaryStatus'] as String?,
      lastMonthSalaryStatusText: json['lastMonthSalaryStatusText'] as String?,
    );
  }
}




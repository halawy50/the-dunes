class SalaryEntity {
  final int id;
  final int employeeId;
  final String employeeName;
  final String year;
  final String month;
  final double salary;
  final String statusPaid;
  final String typeOperation;

  SalaryEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.year,
    required this.month,
    required this.salary,
    required this.statusPaid,
    required this.typeOperation,
  });
}



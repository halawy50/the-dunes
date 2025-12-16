class EmployeeEntity {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? position;
  final String? image;
  final String statusEmployee;
  final bool isEmarat;
  final double? visaCost;
  final bool isSalary;
  final bool isCommission;
  final double? salary;
  final double? commission;
  final String? areaOfLocation;
  final String? hotel;
  final String? startVisa;
  final String? endVisa;
  final Map<String, dynamic>? permissions;
  final String? addedBy;
  final String? joiningDate;
  final double? profit;
  final String? lastMonthSalaryStatus;
  final String? lastMonthSalaryStatusText;

  EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.position,
    this.image,
    this.statusEmployee = 'ACTIVE',
    this.isEmarat = false,
    this.visaCost,
    this.isSalary = false,
    this.isCommission = false,
    this.salary,
    this.commission,
    this.areaOfLocation,
    this.hotel,
    this.startVisa,
    this.endVisa,
    this.permissions,
    this.addedBy,
    this.joiningDate,
    this.profit,
    this.lastMonthSalaryStatus,
    this.lastMonthSalaryStatusText,
  });
}



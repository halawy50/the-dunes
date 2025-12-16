class ReceiptVoucherFilterModel {
  final int? employeeId;
  final String? guestName;
  final String? status;
  final String? pickupStatus;
  final String? timeStart;
  final String? timeEnd;

  const ReceiptVoucherFilterModel({
    this.employeeId,
    this.guestName,
    this.status,
    this.pickupStatus,
    this.timeStart,
    this.timeEnd,
  });

  ReceiptVoucherFilterModel copyWith({
    int? employeeId,
    String? guestName,
    String? status,
    String? pickupStatus,
    String? timeStart,
    String? timeEnd,
  }) {
    return ReceiptVoucherFilterModel(
      employeeId: employeeId ?? this.employeeId,
      guestName: guestName ?? this.guestName,
      status: status ?? this.status,
      pickupStatus: pickupStatus ?? this.pickupStatus,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
    );
  }

  bool get hasFilters {
    return employeeId != null ||
        (guestName != null && guestName!.isNotEmpty) ||
        status != null ||
        pickupStatus != null ||
        timeStart != null ||
        timeEnd != null;
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (employeeId != null) {
      params['employeeId'] = employeeId.toString();
    }
    if (guestName != null && guestName!.isNotEmpty) {
      params['guestName'] = guestName!;
    }
    if (status != null) {
      params['status'] = status!;
    }
    if (pickupStatus != null) {
      params['pickupStatus'] = pickupStatus!;
    }
    if (timeStart != null) {
      params['timeStart'] = timeStart!;
    }
    if (timeEnd != null) {
      params['timeEnd'] = timeEnd!;
    }
    return params;
  }
}


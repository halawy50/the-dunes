class BookingFilterModel {
  final int? employeeId;
  final String? guestName;
  final String? statusBook;
  final String? pickupStatus;
  final String? timeStart;
  final String? timeEnd;
  final int? agentId;

  const BookingFilterModel({
    this.employeeId,
    this.guestName,
    this.statusBook,
    this.pickupStatus,
    this.timeStart,
    this.timeEnd,
    this.agentId,
  });

  BookingFilterModel copyWith({
    int? employeeId,
    String? guestName,
    String? statusBook,
    String? pickupStatus,
    String? timeStart,
    String? timeEnd,
    int? agentId,
  }) {
    return BookingFilterModel(
      employeeId: employeeId ?? this.employeeId,
      guestName: guestName ?? this.guestName,
      statusBook: statusBook ?? this.statusBook,
      pickupStatus: pickupStatus ?? this.pickupStatus,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      agentId: agentId ?? this.agentId,
    );
  }

  bool get hasFilters {
    return employeeId != null ||
        (guestName != null && guestName!.isNotEmpty) ||
        statusBook != null ||
        pickupStatus != null ||
        timeStart != null ||
        timeEnd != null ||
        agentId != null;
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (employeeId != null) {
      params['employeeId'] = employeeId.toString();
    }
    if (guestName != null && guestName!.isNotEmpty) {
      params['guestName'] = guestName!;
    }
    if (statusBook != null) {
      params['statusBook'] = statusBook!;
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
    if (agentId != null) {
      params['agentId'] = agentId.toString();
    }
    return params;
  }
}


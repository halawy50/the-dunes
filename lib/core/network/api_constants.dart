import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  // Use 127.0.0.1 for web to avoid CORS issues, localhost for mobile/desktop
  static String get baseUrl => kIsWeb 
      ? 'http://127.0.0.1:8080'
      : 'http://localhost:8080';
  static const String apiPrefix = '/api';

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptLanguageHeader = 'Accept-Language';
  static const String authorizationHeader = 'Authorization';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Auth endpoints
  static const String loginEndpoint = '$apiPrefix/auth/login';
  static const String checkTokenEndpoint = '$apiPrefix/auth/check-token';

  // Employees endpoints
  static const String employeesEndpoint = '$apiPrefix/employees';
  static String employeeByIdEndpoint(int id) => '$employeesEndpoint/$id';

  // Services endpoints
  static const String servicesEndpoint = '$apiPrefix/services';
  static const String servicesAllEndpoint = '$servicesEndpoint/all';
  static String serviceByIdEndpoint(int id) => '$servicesEndpoint/$id';

  // Locations endpoints
  static const String locationsEndpoint = '$apiPrefix/locations';
  static const String locationsAllEndpoint = '$locationsEndpoint/all';
  static String locationByIdEndpoint(int id) => '$locationsEndpoint/$id';

  // Agents endpoints
  static const String agentsEndpoint = '$apiPrefix/agents';
  static const String agentsAllEndpoint = '$agentsEndpoint/all';
  static String agentByIdEndpoint(int id) => '$agentsEndpoint/$id';
  static String agentServicesEndpoint(int agentId) =>
      '$agentsEndpoint/$agentId/services';

  // Service Agents endpoints
  static const String serviceAgentsEndpoint = '$apiPrefix/service-agents';
  static const String serviceAgentsAllEndpoint = '$serviceAgentsEndpoint/all';
  static String serviceAgentByIdEndpoint(int id) =>
      '$serviceAgentsEndpoint/$id';
  static const String serviceAgentsByAgentLocationEndpoint =
      '$serviceAgentsEndpoint/by-agent-location';

  // Bookings endpoints
  static const String bookingsEndpoint = '$apiPrefix/bookings';
  static String bookingByIdEndpoint(int id) => '$bookingsEndpoint/$id';
  static String bookingStatusEndpoint(int id) =>
      '$bookingsEndpoint/$id/status';
  static String bookingPickupStatusEndpoint(int id) =>
      '$bookingsEndpoint/$id/pickup-status';

  // Receipt Vouchers endpoints
  static const String receiptVouchersEndpoint = '$apiPrefix/receipt-vouchers';
  static String receiptVoucherByIdEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id';
  static String receiptVoucherStatusEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id/status';
  static String receiptVoucherPickupStatusEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id/pickup-status';

  // Camp endpoints
  static const String campEndpoint = '$apiPrefix/camp';
  static String campBookingStatusEndpoint(int id) =>
      '$campEndpoint/bookings/$id/status';
  static String campVoucherStatusEndpoint(int id) =>
      '$campEndpoint/vouchers/$id/status';

  // Pickup Times endpoints
  static const String pickupTimesEndpoint = '$apiPrefix/pickup-times';

  // Statistics endpoints
  static const String statisticsEndpoint = '$apiPrefix/statistics';

  // Operations endpoints
  static const String operationsEndpoint = '$apiPrefix/operations';
  static const String operationsAnalysisEndpoint =
      '$operationsEndpoint/analysis';
  static String operationByIdEndpoint(int id) => '$operationsEndpoint/$id';

  // Users endpoints
  static const String usersEndpoint = '$apiPrefix/users';
  static String userByIdEndpoint(int id) => '$usersEndpoint/$id';
}


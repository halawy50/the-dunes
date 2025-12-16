import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  // Use localhost for web to match backend CORS configuration
  // Update the port to match your API server
  static String get baseUrl => kIsWeb 
      ? 'https://the-dunes-api-production.up.railway.app'
      : 'https://the-dunes-api-production.up.railway.app';
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
  static String employeeSalariesEndpoint(int id) => '$employeesEndpoint/$id/salaries';
  static String employeeSalariesPendingEndpoint(int id) => '$employeesEndpoint/$id/salaries/pending';
  static String employeeCommissionsEndpoint(int id) => '$employeesEndpoint/$id/commissions';
  static String employeeCommissionsPendingEndpoint(int id) => '$employeesEndpoint/$id/commissions/pending';
  static const String employeeResetPasswordEndpoint = '$employeesEndpoint/reset-password';

  // Salaries endpoints
  static const String salariesEndpoint = '$apiPrefix/salaries';
  static String salaryByIdEndpoint(int id) => '$salariesEndpoint/$id';
  static String salaryPayEndpoint(int id) => '$salariesEndpoint/$id/pay';

  // Commissions endpoints
  static const String commissionsEndpoint = '$apiPrefix/commissions';
  static String commissionByIdEndpoint(int id) => '$commissionsEndpoint/$id';
  static String commissionPayEndpoint(int id) => '$commissionsEndpoint/$id/pay';
  static const String commissionsBulkPayEndpoint = '$commissionsEndpoint/bulk-pay';

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
  static String agentGlobalServicesEndpoint(int agentId) =>
      '$agentsEndpoint/$agentId/services/global';

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
  static const String bookingsExportExcelEndpoint =
      '$bookingsEndpoint/export/excel';
  static const String bookingsAnalyzeDocumentsEndpoint =
      '$bookingsEndpoint/analyze-documents';

  // Receipt Vouchers endpoints
  static const String receiptVouchersEndpoint = '$apiPrefix/receipt-vouchers';
  static String receiptVoucherByIdEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id';
  static String receiptVoucherStatusEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id/status';
  static String receiptVoucherPickupStatusEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id/pickup-status';
  static String receiptVoucherPdfEndpoint(int id) =>
      '$receiptVouchersEndpoint/$id/pdf';

  // Camp endpoints
  static const String campEndpoint = '$apiPrefix/camp';
  static String campBookingStatusEndpoint(int id) =>
      '$campEndpoint/bookings/$id/status';
  static String campVoucherStatusEndpoint(int id) =>
      '$campEndpoint/vouchers/$id/status';

  // Pickup Times endpoints
  static const String pickupTimesEndpoint = '$apiPrefix/pickup-times';
  static const String pickupTimesGroupsEndpoint = '$pickupTimesEndpoint/groups';
  static const String pickupTimesAssignVehicleEndpoint = '$pickupTimesEndpoint/assign-vehicle';
  static const String pickupTimesUpdateAssignmentEndpoint = '$pickupTimesEndpoint/update-assignment';
  static const String pickupTimesRemoveAssignmentEndpoint = '$pickupTimesEndpoint/remove-assignment';
  static const String pickupTimesUpdateStatusEndpoint = '$pickupTimesEndpoint/update-status';

  // Statistics endpoints
  static const String statisticsEndpoint = '$apiPrefix/statistics';
  static const String statisticsDashboardSummaryEndpoint = '$statisticsEndpoint/dashboard-summary';
  static const String statisticsBookingsByAgencyEndpoint = '$statisticsEndpoint/bookings-by-agency';
  static const String statisticsEmployeesWithVouchersEndpoint = '$statisticsEndpoint/employees-with-vouchers';

  // Operations endpoints
  static const String operationsEndpoint = '$apiPrefix/operations';
  static const String operationsAnalysisEndpoint =
      '$operationsEndpoint/analysis';
  static String operationByIdEndpoint(int id) => '$operationsEndpoint/$id';

  // Hotels endpoints
  static const String hotelsEndpoint = '$apiPrefix/hotels';
  static const String hotelsAllEndpoint = '$hotelsEndpoint/all';
  static String hotelByIdEndpoint(int id) => '$hotelsEndpoint/$id';

  // Users endpoints
  static const String usersEndpoint = '$apiPrefix/users';
  static String userByIdEndpoint(int id) => '$usersEndpoint/$id';

  // Currencies endpoints
  static const String currenciesEndpoint = '$apiPrefix/currencies';
  static const String currenciesExchangeRatesEndpoint = '$currenciesEndpoint/exchange-rates';
}


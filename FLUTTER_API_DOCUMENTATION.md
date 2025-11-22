# 📱 دليل استخدام API في Flutter - The Dunes

## 📋 جدول المحتويات
1. [الإعدادات الأساسية](#1-الإعدادات-الأساسية)
2. [Authentication (المصادقة)](#2-authentication-المصادقة)
3. [Bookings (الحجوزات)](#3-bookings-الحجوزات)
4. [Receipt Vouchers (إيصالات الاستلام)](#4-receipt-vouchers-إيصالات-الاستلام)
5. [Services (الخدمات)](#5-services-الخدمات)
6. [Service Agents (خدمات الوكيل)](#6-service-agents-خدمات-الوكيل)
7. [Agents (الوكلاء)](#7-agents-الوكلاء)
8. [Locations (الأماكن)](#8-locations-الأماكن)
9. [Employees (الموظفين)](#9-employees-الموظفين)
10. [Operations (العمليات)](#10-operations-العمليات)
11. [Camp (المخيم)](#11-camp-المخيم)
12. [Pickup Times (أوقات الاستلام)](#12-pickup-times-أوقات-الاستلام)
13. [Statistics (الإحصائيات)](#13-statistics-الإحصائيات)
14. [Drivers (السائقين)](#14-drivers-السائقين)
15. [Hotels (الفنادق)](#15-hotels-الفنادق)

---

## 1. الإعدادات الأساسية

### Base URL
```dart
// في api_constants.dart
static String get baseUrl => kIsWeb 
    ? 'http://127.0.0.1:8080'  // للويب
    : 'http://localhost:8080'; // للموبايل/ديسكتوب
```

### Headers المطلوبة
```dart
// في api_client.dart
Future<Map<String, String>> _getHeaders() async {
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=utf-8',
    'Accept-Language': _language, // en, ar, ru, hi, de, es
    'Accept': 'application/json',
  };

  // Get token from cache or storage
  String? token = _token ?? await TokenStorage.getToken();
  
  if (token != null && token.isNotEmpty) {
    // Format: Authorization: Bearer {accessToken}
    headers['Authorization'] = 'Bearer $token';
  }

  return headers;
}
```

### Base Response Model
```dart
// في core/data/models/paginated_response.dart
class PaginatedResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final PaginationInfo pagination;

  PaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: (json['data'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item))
              .toList() ?? [],
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginationInfo({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
    currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
    totalItems: json['totalItems'] ?? 0,
    totalPages: json['totalPages'] ?? 1,
    hasNext: json['hasNext'] ?? false,
    hasPrevious: json['hasPrevious'] ?? false,
  );
  }
}
```

---

## 2. Authentication (المصادقة)

### 2.1 Login (تسجيل الدخول)

**Endpoint:** `POST /api/auth/login`

**Request Model:**
```dart
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}
```

**Response Model:**
```dart
class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int employeeId;
  final EmployeeAuthResponse employee;

  LoginResponse({
    required this.accessToken,
    this.tokenType = 'Bearer',
    required this.employeeId,
    required this.employee,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
      employeeId: json['employeeId'] ?? 0,
      employee: EmployeeAuthResponse.fromJson(json['employee']),
    );
  }
}

class EmployeeAuthResponse {
  final int id;
  final String name;
  final String email;
  final String position;
  final String statusEmployee;
  final PermissionResponse? permissions;

  EmployeeAuthResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.statusEmployee,
    this.permissions,
  });

  factory EmployeeAuthResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeAuthResponse(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
      position: json['position'] ?? '',
      statusEmployee: json['statusEmployee'] ?? '',
    permissions: json['permissions'] != null 
          ? PermissionResponse.fromJson(json['permissions'])
        : null,
  );
  }
}
```

**Example Usage:**
```dart
// في login_remote_data_source.dart
Future<LoginResponse> login(String email, String password) async {
  final response = await apiClient.post(
    ApiConstants.loginEndpoint,
    {
      'email': email,
      'password': password,
    },
  );
  return LoginResponse.fromJson(response['data']);
}
```

### 2.2 Check Token (التحقق من التوكن)

**Endpoint:** `GET /api/auth/check-token`

**Example Usage:**
```dart
Future<bool> checkToken(String token) async {
  try {
    final response = await apiClient.get(
      ApiConstants.checkTokenEndpoint,
    );
    return response['data']['isValid'] ?? false;
  } catch (e) {
    return false;
  }
}
```

---

## 3. Bookings (الحجوزات)

### 3.1 Get All Bookings (جلب جميع الحجوزات)

**Endpoint:** `GET /api/bookings`

**Query Parameters:**
- `page` (optional): رقم الصفحة (default: 1)
- `pageSize` (optional): عدد العناصر في الصفحة (default: 20)
- `employeeId` (optional): تصفية حسب معرف الموظف

**Response Model:**
```dart
class BookingModel {
  final int id;
  final int? time;
  final String? voucher;
  final String? orderNumber;
  final String? pickupTime;
  final String? pickupStatus;
  final int employeeId;
  final String? employeeName;
  final String guestName;
  final String? phoneNumber;
  final String statusBook;
  final int agentName; // agentId
  final String? agentNameStr;
  final int? locationId;
  final String? locationName;
  final String? hotelName;
  final int? room;
  final String? note;
  final String? driver;
  final int? carNumber;
  final String payment;
  final String typeOperation;
  final List<BookingServiceModel> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPrice;
  final String? bookingDate;

  BookingModel({
    required this.id,
    this.time,
    this.voucher,
    this.orderNumber,
    this.pickupTime,
    this.pickupStatus,
    required this.employeeId,
    this.employeeName,
    required this.guestName,
    this.phoneNumber,
    required this.statusBook,
    required this.agentName,
    this.agentNameStr,
    this.locationId,
    this.locationName,
    this.hotelName,
    this.room,
    this.note,
    this.driver,
    this.carNumber,
    required this.payment,
    required this.typeOperation,
    required this.services,
    required this.priceBeforePercentage,
    required this.priceAfterPercentage,
    required this.finalPrice,
    this.bookingDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return BookingJsonHelper.toJson(this);
  }
}

class BookingServiceModel {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final String? locationName;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPriceService;

  BookingServiceModel({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    this.locationName,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPriceService,
  });

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    if (locationId != null) 'locationId': locationId,
    'adultNumber': adultNumber,
    'childNumber': childNumber,
    'kidNumber': kidNumber,
  };
}
```

**Example Usage:**
```dart
// في booking_remote_data_source.dart
Future<PaginatedResponse<BookingModel>> getBookings({
  int? employeeId,
  int page = 1,
  int pageSize = 20,
}) async {
  final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
  };
  if (employeeId != null) {
    queryParams['employeeId'] = employeeId.toString();
  }
  final response = await apiClient.get(
    ApiConstants.bookingsEndpoint,
    queryParams: queryParams,
  );
  return PaginatedResponse.fromJson(
    response,
    (json) => BookingModel.fromJson(json as Map<String, dynamic>),
  );
}
```

### 3.2 Get Booking by ID (جلب حجز محدد)

**Endpoint:** `GET /api/bookings/{id}`

**Example Usage:**
```dart
Future<BookingModel> getBookingById(int id) async {
  final response = await apiClient.get(
    ApiConstants.bookingByIdEndpoint(id),
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}
```

### 3.3 Create Booking (إنشاء حجز جديد)

**Endpoint:** `POST /api/bookings`

**Request Body:**
```dart
{
  "guestName": "أحمد محمد",
  "phoneNumber": "+971501234567",
  "statusBook": "PENDING",
  "employeeId": 1,
  "agentName": 1,  // agentId
  "locationId": 1,
  "hotelName": "فندق جراند",
  "room": 101,
  "typeOperation": "BOOKING",
  "payment": "CASH",
  "driver": "NON",
  "carNumber": null,
  "note": "ملاحظات خاصة",
  "services": [
    {
      "serviceId": 805,
      "locationId": 1,
      "adultNumber": 2,
      "childNumber": 1,
      "kidNumber": 0
    }
  ],
  "priceBeforePercentage": 640.0,
  "priceAfterPercentage": 576.0,
  "finalPrice": 576.0
}
```

**Example Usage:**
```dart
// في booking_remote_data_source.dart
Future<BookingModel> createBooking(BookingModel booking) async {
  final response = await apiClient.post(
    ApiConstants.bookingsEndpoint,
    booking.toJson(),
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}

// مثال كامل لإنشاء حجز
Future<void> createBookingExample() async {
  // 1. جلب الخدمات المتاحة للوكيل والمكان
  final services = await getServicesByAgentAndLocation(
    agentId: 1,
    locationId: 1,
  );

  // 2. اختيار خدمة
  final selectedService = services.first;

  // 3. حساب الأسعار
  final adults = 2;
  final children = 1;
  final kids = 0;
  
  final adultTotal = selectedService.adultPrice * adults;
  final childTotal = (selectedService.childPrice ?? 0) * children;
  final kidTotal = (selectedService.kidPrice ?? 0) * kids;
  final priceBeforePercentage = adultTotal + childTotal + kidTotal;
  final priceAfterPercentage = priceBeforePercentage * 0.9; // خصم 10%
  final finalPrice = priceAfterPercentage;

  // 4. إنشاء الحجز
  final booking = BookingModel(
    id: 0, // سيتم تعيينه من الـ server
    guestName: 'أحمد محمد',
    phoneNumber: '+971501234567',
    statusBook: 'PENDING',
    employeeId: 1,
    agentName: 1, // agentId
    locationId: 1,
    hotelName: 'فندق جراند',
    room: 101,
    payment: 'CASH',
    typeOperation: 'BOOKING',
    driver: 'NON',
    services: [
      BookingServiceModel(
        id: 0,
        serviceId: selectedService.serviceId,
        locationId: 1,
        adultNumber: adults,
        childNumber: children,
        kidNumber: kids,
        adultPrice: selectedService.adultPrice,
        childPrice: selectedService.childPrice ?? 0,
        kidPrice: selectedService.kidPrice ?? 0,
        totalPriceService: finalPrice,
      ),
    ],
    priceBeforePercentage: priceBeforePercentage,
    priceAfterPercentage: priceAfterPercentage,
    finalPrice: finalPrice,
  );

  final createdBooking = await createBooking(booking);
  print('Booking created: ${createdBooking.id}');
}
```

### 3.4 Update Booking (تحديث الحجز)

**Endpoint:** `PUT /api/bookings/{id}`

**Example Usage:**
```dart
Future<BookingModel> updateBooking(
  int id,
  Map<String, dynamic> updates,
) async {
  final response = await apiClient.put(
    ApiConstants.bookingByIdEndpoint(id),
    updates,
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}

// مثال للتحديث
await updateBooking(bookingId, {
  'guestName': 'اسم جديد',
  'phoneNumber': '+971501234567',
  'statusBook': 'ACCEPTED',
});
```

### 3.5 Update Booking Status (تحديث حالة الحجز)

**Endpoint:** `PUT /api/bookings/{id}/status?status={status}`

**Status Values:** `PENDING`, `ACCEPTED`, `COMPLETED`, `CANCELLED`

**Example Usage:**
```dart
Future<BookingModel> updateBookingStatus(
  int id,
  String status, // PENDING, ACCEPTED, COMPLETED, CANCELLED
) async {
  final response = await apiClient.put(
    '${ApiConstants.bookingStatusEndpoint(id)}?status=$status',
    {},
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}
```

### 3.6 Update Pickup Status (تحديث حالة الاستلام)

**Endpoint:** `PUT /api/bookings/{id}/pickup-status?status={status}`

**Status Values:** `YET`, `PICKED`, `INWAY`

**Example Usage:**
```dart
Future<BookingModel> updatePickupStatus(
  int id,
  String status, // YET, PICKED, INWAY
) async {
  final response = await apiClient.put(
    '${ApiConstants.bookingPickupStatusEndpoint(id)}?status=$status',
    {},
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}
```

### 3.7 Delete Booking (حذف الحجز)

**Endpoint:** `DELETE /api/bookings/{id}`

**Example Usage:**
```dart
Future<void> deleteBooking(int id) async {
  await apiClient.delete(ApiConstants.bookingByIdEndpoint(id));
}
```

---

## 4. Receipt Vouchers (إيصالات الاستلام)

### 4.1 Get All Receipt Vouchers

**Endpoint:** `GET /api/receipt-vouchers`

**Query Parameters:**
- `page` (optional)
- `pageSize` (optional)
- `employeeId` (optional)

**Example Usage:**
```dart
Future<PaginatedResponse<ReceiptVoucher>> getAllReceiptVouchers({
  int page = 1,
  int pageSize = 20,
  int? employeeId,
}) async {
  final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    if (employeeId != null) 'employeeId': employeeId.toString(),
  };
  final response = await apiClient.get(
    ApiConstants.receiptVouchersEndpoint,
    queryParams: queryParams,
  );
  return PaginatedResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json as Map<String, dynamic>),
  );
}
```

### 4.2 Create Receipt Voucher

**Endpoint:** `POST /api/receipt-vouchers`

**Request Model:**
```dart
class CreateReceiptVoucherRequest {
  final String guestName;
  final String? location;
  final int? currencyId;
  final String? phoneNumber;
  final String status;
  final String? hotel;
  final int? room;
  final String? note;
  final int? pickupTime;
  final String? pickupStatus;
  final String? driver;
  final int? carNumber;
  final String payment;
  final int? employeeAddedId;
  final double? commissionEmployee;
  final String typeOperation;
  final bool employeeIsReceivedCommission;
  final int? discountPercentage;
  final List<VoucherServiceRequest> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPriceWithCommissionEmployee;
  final double finalPriceAfterDeductingCommissionEmployee;

  Map<String, dynamic> toJson() => {
    'guestName': guestName,
    if (location != null) 'location': location,
    if (currencyId != null) 'currencyId': currencyId,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    'status': status,
    if (hotel != null) 'hotel': hotel,
    if (room != null) 'room': room,
    if (note != null) 'note': note,
    if (pickupTime != null) 'pickupTime': pickupTime,
    if (pickupStatus != null) 'pickupStatus': pickupStatus,
    if (driver != null) 'driver': driver,
    if (carNumber != null) 'carNumber': carNumber,
    'payment': payment,
    if (employeeAddedId != null) 'employeeAddedId': employeeAddedId,
    if (commissionEmployee != null) 'commissionEmployee': commissionEmployee,
    'typeOperation': typeOperation,
    'employeeIsReceivedCommission': employeeIsReceivedCommission,
    if (discountPercentage != null) 'discountPercentage': discountPercentage,
    'services': services.map((s) => s.toJson()).toList(),
    'priceBeforePercentage': priceBeforePercentage,
    'priceAfterPercentage': priceAfterPercentage,
    'finalPriceWithCommissionEmployee': finalPriceWithCommissionEmployee,
    'finalPriceAfterDeductingCommissionEmployee': finalPriceAfterDeductingCommissionEmployee,
  };
}

class VoucherServiceRequest {
  final int serviceId;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'adultNumber': adultNumber,
    'childNumber': childNumber,
    'kidNumber': kidNumber,
    'adultPrice': adultPrice,
    'childPrice': childPrice,
    'kidPrice': kidPrice,
  };
}
```

---

## 5. Services (الخدمات)

### 5.1 Get All Services

**Endpoint:** `GET /api/services/all`

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<ServiceModel>> getAllServices() async {
  final response = await apiClient.get(ApiConstants.servicesAllEndpoint);
  final data = response['data'] as List<dynamic>? ?? [];
  return data.map((json) => ServiceModel.fromJson(json)).toList();
}

class ServiceModel {
  final int id;
  final String serviceName;

  ServiceModel({required this.id, required this.serviceName});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
    id: json['id'] ?? 0,
      serviceName: json['serviceName'] ?? '',
    );
  }
}
```

---

## 6. Service Agents (خدمات الوكيل)

### 6.1 Get Services by Agent and Location

**Endpoint:** `GET /api/service-agents/by-agent-location?agentId={agentId}&locationId={locationId}`

**Response Model:**
```dart
class ServiceAgentModel {
  final int id;
  final int agentId;
  final int? locationId;
  final int serviceId;
  final String? serviceName;
  final String? locationName;
  final double adultPrice;
  final double? childPrice;
  final double? kidPrice;
  final bool isGlobal;

  ServiceAgentModel({
    required this.id,
    required this.agentId,
    this.locationId,
    required this.serviceId,
    this.serviceName,
    this.locationName,
    required this.adultPrice,
    this.childPrice,
    this.kidPrice,
    this.isGlobal = false,
  });

  factory ServiceAgentModel.fromJson(Map<String, dynamic> json) {
    return ServiceAgentModel(
    id: json['id'] ?? 0,
      agentId: json['agentId'] ?? 0,
      locationId: json['locationId'],
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'],
      locationName: json['locationName'],
      adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
      childPrice: json['childPrice']?.toDouble(),
      kidPrice: json['kidPrice']?.toDouble(),
      isGlobal: json['isGlobal'] ?? false,
    );
  }
}
```

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<ServiceAgentModel>> getServicesByAgentAndLocation({
  required int agentId,
  required int locationId,
}) async {
  final response = await apiClient.get(
    ApiConstants.serviceAgentsByAgentLocationEndpoint,
    queryParams: {
      'agentId': agentId.toString(),
      'locationId': locationId.toString(),
    },
  );
  final data = response['data'] as List<dynamic>? ?? [];
  return data.map((json) => ServiceAgentModel.fromJson(json)).toList();
}
```

---

## 7. Agents (الوكلاء)

### 7.1 Get All Agents

**Endpoint:** `GET /api/agents/all`

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<AgentModel>> getAllAgents() async {
  final response = await apiClient.get(ApiConstants.agentsAllEndpoint);
  final data = response['data'] as List<dynamic>? ?? [];
  return data.map((json) => AgentModel.fromJson(json)).toList();
}

class AgentModel {
  final int id;
  final String name;

  AgentModel({required this.id, required this.name});

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
```

---

## 8. Locations (الأماكن)

### 8.1 Get All Locations

**Endpoint:** `GET /api/locations/all`

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<LocationModel>> getAllLocations() async {
  final response = await apiClient.get(ApiConstants.locationsAllEndpoint);
  final data = response['data'] as List<dynamic>? ?? [];
  return data.map((json) => LocationModel.fromJson(json)).toList();
}

class LocationModel {
  final int id;
  final String name;
  final String emirate;

  LocationModel({
    required this.id,
    required this.name,
    required this.emirate,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      emirate: json['emirate'] ?? '',
    );
  }
}
```

---

## 9. Employees (الموظفين)

### 9.1 Get All Employees

**Endpoint:** `GET /api/employees`

**Query Parameters:**
- `page` (optional)
- `pageSize` (optional)

**Example Usage:**
```dart
Future<PaginatedResponse<Employee>> getAllEmployees({
  int page = 1,
  int pageSize = 20,
}) async {
  final queryParams = {
    'page': page.toString(),
    'pageSize': pageSize.toString(),
  };
  final response = await apiClient.get(
    ApiConstants.employeesEndpoint,
    queryParams: queryParams,
  );
  return PaginatedResponse.fromJson(
    response,
    (json) => Employee.fromJson(json as Map<String, dynamic>),
  );
}
```

---

## 10. Operations (العمليات)

### 10.1 Get All Operations

**Endpoint:** `GET /api/operations`

**Query Parameters:**
- `page`, `pageSize`
- `type` (optional): `INCOME`, `OUTCOME`
- `employeeId` (optional)
- `startDate` (optional): Unix timestamp
- `endDate` (optional): Unix timestamp

**Example Usage:**
```dart
Future<PaginatedResponse<Operation>> getAllOperations({
  int page = 1,
  int pageSize = 20,
  String? type,
  int? employeeId,
  int? startDate,
  int? endDate,
}) async {
  final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    if (type != null) 'type': type,
    if (employeeId != null) 'employeeId': employeeId.toString(),
    if (startDate != null) 'startDate': startDate.toString(),
    if (endDate != null) 'endDate': endDate.toString(),
  };
  final response = await apiClient.get(
    ApiConstants.operationsEndpoint,
    queryParams: queryParams,
  );
  return PaginatedResponse.fromJson(
    response,
    (json) => Operation.fromJson(json as Map<String, dynamic>),
  );
}
```

---

## 11. Camp (المخيم)

### 11.1 Get Camp Data

**Endpoint:** `GET /api/camp`

**Example Usage:**
```dart
Future<CampData> getCampData() async {
  final response = await apiClient.get(ApiConstants.campEndpoint);
  return CampData.fromJson(response['data']);
}
```

### 11.2 Update Booking Status (Camp)

**Endpoint:** `PUT /api/camp/bookings/{id}/status`

**Example Usage:**
```dart
Future<BookingModel> updateCampBookingStatus(
  int id,
  String status, // COMPLETED or CANCELLED
) async {
  final response = await apiClient.put(
    ApiConstants.campBookingStatusEndpoint(id),
    {'status': status},
  );
  return BookingModel.fromJson(response['data'] as Map<String, dynamic>);
}
```

---

## 12. Pickup Times (أوقات الاستلام)

### 12.1 Get Pending Pickups

**Endpoint:** `GET /api/pickup-times`

**Example Usage:**
```dart
Future<Map<String, List<dynamic>>> getPendingPickups() async {
  final response = await apiClient.get(ApiConstants.pickupTimesEndpoint);
  return {
    'bookings': response['data']['bookings'] ?? [],
    'vouchers': response['data']['vouchers'] ?? [],
  };
}
```

---

## 13. Statistics (الإحصائيات)

### 13.1 Get Statistics

**Endpoint:** `GET /api/statistics`

**Query Parameters:**
- `startDate` (optional): Unix timestamp
- `endDate` (optional): Unix timestamp

**Example Usage:**
```dart
Future<Statistics> getStatistics({
  int? startDate,
  int? endDate,
}) async {
  final queryParams = <String, String>{};
  if (startDate != null) queryParams['startDate'] = startDate.toString();
  if (endDate != null) queryParams['endDate'] = endDate.toString();
  
  final response = await apiClient.get(
    ApiConstants.statisticsEndpoint,
    queryParams: queryParams,
  );
  return Statistics.fromJson(response['data']);
}
```

---

## 14. Drivers (السائقين)

### 14.1 Get All Drivers

**Endpoint:** `GET /api/drivers/all`

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<DriverModel>> getDrivers() async {
  try {
    final response = await apiClient.get('/api/drivers/all');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => DriverModel.fromJson(json)).toList();
  } catch (e) {
    // Fallback to default drivers
    return [
      DriverModel(id: 1, name: 'NON'),
      DriverModel(id: 2, name: 'AZAM', phoneNumber: '+971 55 524 6715'),
      DriverModel(id: 3, name: 'RAHIL', phoneNumber: '+971 50 808 4801'),
      DriverModel(id: 4, name: 'ABU SAIF', phoneNumber: '+971 35 805 6033'),
      DriverModel(id: 5, name: 'SALMAN', phoneNumber: '+971 22 253 8796'),
    ];
  }
}

class DriverModel {
  final int id;
  final String name;
  final String? phoneNumber;

  DriverModel({required this.id, required this.name, this.phoneNumber});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }
}
```

---

## 15. Hotels (الفنادق)

### 15.1 Get All Hotels

**Endpoint:** `GET /api/hotels/all`

**Example Usage:**
```dart
// في booking_options_remote_data_source.dart
Future<List<HotelModel>> getHotels() async {
  try {
    final response = await apiClient.get('/api/hotels/all');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => HotelModel.fromJson(json)).toList();
  } catch (e) {
    // Fallback to default hotel
    return [
      HotelModel(id: 1, name: 'Rixos The Palm Hotel & Suites'),
    ];
  }
}

class HotelModel {
  final int id;
  final String name;

  HotelModel({required this.id, required this.name});

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
```

---

## 📝 ملاحظات مهمة

1. **جميع الـ endpoints (عدا Login) تتطلب Authentication Token**
   - الـ token يُرسل تلقائياً في header: `Authorization: Bearer {accessToken}`
   - الـ token يُحفظ في `TokenStorage` ويُستعاد تلقائياً عند الحاجة

2. **استخدم `Accept-Language` header للغة المطلوبة**
   - القيم المدعومة: `en`, `ar`, `ru`, `hi`, `de`, `es`

3. **Timestamps هي Unix timestamps بالثواني**

4. **جميع الـ IDs هي Long (int في Dart)**

5. **استخدم Pagination للقوائم الكبيرة**
   - `page`: رقم الصفحة (يبدأ من 1)
   - `pageSize`: عدد العناصر في الصفحة (default: 20)

6. **Error Handling**
   - جميع الـ API calls تُرجع `ApiException` عند حدوث خطأ
   - استخدم `try-catch` للتعامل مع الأخطاء

---

## 🔐 Error Handling

```dart
import 'package:the_dunes/core/network/api_exception.dart';

try {
  final booking = await createBooking(bookingModel);
  // Success
} on ApiException catch (e) {
  // API error
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
} catch (e) {
  // Other errors
  print('Unexpected error: $e');
}
```

---

## 🎯 مثال كامل لاستخدام API في التطبيق

```dart
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';

class BookingService {
  final BookingRemoteDataSource bookingDataSource;
  final BookingOptionsRemoteDataSource optionsDataSource;

  BookingService()
      : bookingDataSource = BookingRemoteDataSource(di<ApiClient>()),
        optionsDataSource = BookingOptionsRemoteDataSource(di<ApiClient>());

  // 1. جلب جميع الحجوزات
  Future<PaginatedResponse<BookingModel>> getAllBookings({
    int? employeeId,
    int page = 1,
  }) async {
    return await bookingDataSource.getBookings(
      employeeId: employeeId,
      page: page,
    );
  }

  // 2. جلب الخيارات (locations, agents, services)
  Future<void> loadBookingOptions() async {
    final locations = await optionsDataSource.getAllLocations();
    final agents = await optionsDataSource.getAllAgents();
    final drivers = await optionsDataSource.getDrivers();
    final hotels = await optionsDataSource.getHotels();
    
    print('Loaded ${locations.length} locations');
    print('Loaded ${agents.length} agents');
    print('Loaded ${drivers.length} drivers');
    print('Loaded ${hotels.length} hotels');
  }

  // 3. جلب الخدمات المتاحة للوكيل والمكان
  Future<List<ServiceAgentModel>> getAvailableServices({
    required int agentId,
    required int locationId,
  }) async {
    return await optionsDataSource.getServicesByAgentAndLocation(
      agentId: agentId,
      locationId: locationId,
    );
  }

  // 4. إنشاء حجز جديد
  Future<BookingModel> createNewBooking(BookingModel booking) async {
    return await bookingDataSource.createBooking(booking);
  }

  // 5. تحديث حجز
  Future<BookingModel> updateBooking(
    int id,
    Map<String, dynamic> updates,
  ) async {
    return await bookingDataSource.updateBooking(id, updates);
  }

  // 6. حذف حجز
  Future<void> deleteBooking(int id) async {
    await bookingDataSource.deleteBooking(id);
  }
}
```

---

## 📦 استخدام Dependency Injection

```dart
// في injection_container.dart
final di = GetIt.instance;

void init() {
  // Register ApiClient
  di.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Data Sources
  di.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(di<ApiClient>()),
  );
  
  di.registerLazySingleton<BookingOptionsRemoteDataSource>(
    () => BookingOptionsRemoteDataSource(di<ApiClient>()),
  );

  // Register Cubits
  di.registerFactory<BookingCubit>(
    () => BookingCubit(di<BookingRemoteDataSource>()),
  );
  
  di.registerFactory<NewBookingCubit>(
    () => NewBookingCubit(
      di<BookingRemoteDataSource>(),
      di<BookingOptionsRemoteDataSource>(),
    ),
  );
}

// استخدام في Widget
final cubit = di<BookingCubit>();
```

---

## 🌐 CORS Configuration (للويب)

إذا كنت تواجه مشاكل CORS في Flutter Web:

1. **Server-side**: أضف CORS headers في الـ server
2. **Development**: استخدم Chrome بدون web security:
   ```bash
   chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security
   ```

---

تم إنشاء الدليل. يمكنك استخدامه كمرجع لاستخدام جميع الـ endpoints في تطبيق Flutter الخاص بك.

# 📱 Flutter API Documentation - The Dunes Travel & Tourism

## 📋 جدول المحتويات
1. [الإعدادات الأساسية](#1-الإعدادات-الأساسية)
2. [Authentication](#2-authentication)
3. [Models (Dart Classes)](#3-models-dart-classes)
4. [API Service Class](#4-api-service-class)
5. [جميع الـ Endpoints](#5-جميع-ال-endpoints)
6. [Error Handling](#6-error-handling)
7. [أمثلة الاستخدام الكاملة](#7-أمثلة-الاستخدام-الكاملة)

---

## 1. الإعدادات الأساسية

### Base URL
```dart
const String baseUrl = 'http://localhost:8080'; // Development
// const String baseUrl = 'https://your-production-url.com'; // Production
```

### Required Headers
```dart
Map<String, String> getHeaders({String? token, String language = 'en'}) {
  return {
    'Content-Type': 'application/json',
    'Accept-Language': language, // en, ar, ru, hi, de, es
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
```

### Supported Languages
- `en` - English (default)
- `ar` - Arabic
- `ru` - Russian
- `hi` - Hindi
- `de` - German
- `es` - Spanish

---

## 2. Authentication

### Login Endpoint

**Endpoint:** `POST /api/auth/login`

**Request:**
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

**Response:**
```dart
class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;
  final String? error;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    error: json['error'],
  );
}

class LoginData {
  final String token;
  final EmployeeData employee;

  LoginData({required this.token, required this.employee});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    token: json['token'] ?? '',
    employee: EmployeeData.fromJson(json['employee']),
  );
}
```

**Example Usage:**
```dart
Future<LoginResponse> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/login'),
    headers: getHeaders(),
    body: jsonEncode(LoginRequest(email: email, password: password).toJson()),
  );

  if (response.statusCode == 200) {
    return LoginResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Login failed: ${response.statusCode}');
  }
}
```

---

## 3. Models (Dart Classes)

### Base Response Models

```dart
class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) => BaseResponse<T>(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: json['data'] != null && fromJsonT != null 
        ? fromJsonT(json['data']) 
        : json['data'],
    error: json['error'],
  );
}

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
  ) => PaginatedResponse<T>(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: (json['data'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item))
            .toList() ??
        [],
    pagination: PaginationInfo.fromJson(json['pagination']),
  );
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

  factory PaginationInfo.fromJson(Map<String, dynamic> json) => PaginationInfo(
    currentPage: json['currentPage'] ?? 1,
    pageSize: json['pageSize'] ?? 10,
    totalItems: json['totalItems'] ?? 0,
    totalPages: json['totalPages'] ?? 1,
    hasNext: json['hasNext'] ?? false,
    hasPrevious: json['hasPrevious'] ?? false,
  );
}
```

### Employee Models

```dart
class Employee {
  final int id;
  final String name;
  final int joinAt;
  final String position;
  final String? phoneNumber;
  final bool isEmarat;
  final double? visaCost;
  final bool isSalary;
  final bool isCommission;
  final double? salary;
  final int? commission;
  final String? areaOfLocation;
  final String? hotel;
  final String email;
  final String? image;
  final String? startVisa;
  final String? endVisa;
  final String statusEmployee;
  final bool? lastStatusSalary;
  final Permissions? permissions;

  Employee({
    required this.id,
    required this.name,
    required this.joinAt,
    required this.position,
    this.phoneNumber,
    required this.isEmarat,
    this.visaCost,
    required this.isSalary,
    required this.isCommission,
    this.salary,
    this.commission,
    this.areaOfLocation,
    this.hotel,
    required this.email,
    this.image,
    this.startVisa,
    this.endVisa,
    required this.statusEmployee,
    this.lastStatusSalary,
    this.permissions,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    joinAt: json['joinAt'] ?? 0,
    position: json['position'] ?? '',
    phoneNumber: json['phoneNumber'],
    isEmarat: json['isEmarat'] ?? false,
    visaCost: json['visaCost']?.toDouble(),
    isSalary: json['isSalary'] ?? false,
    isCommission: json['isCommission'] ?? false,
    salary: json['salary']?.toDouble(),
    commission: json['commission'],
    areaOfLocation: json['areaOfLocation'],
    hotel: json['hotel'],
    email: json['email'] ?? '',
    image: json['image'],
    startVisa: json['startVisa'],
    endVisa: json['endVisa'],
    statusEmployee: json['statusEmployee'] ?? 'ACTIVE',
    lastStatusSalary: json['lastStatusSalary'],
    permissions: json['permissions'] != null 
        ? Permissions.fromJson(json['permissions']) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'position': position,
    'phoneNumber': phoneNumber,
    'isEmarat': isEmarat,
    'visaCost': visaCost,
    'isSalary': isSalary,
    'isCommission': isCommission,
    'salary': salary,
    'commission': commission,
    'areaOfLocation': areaOfLocation,
    'hotel': hotel,
    'email': email,
    'password': null, // Don't send password in updates
    'image': image,
    'startVisa': startVisa,
    'endVisa': endVisa,
    'permissions': permissions?.toJson(),
  };
}

class Permissions {
  final bool overviewScreen;
  final bool analysisScreen;
  final bool bookingScreen;
  final bool showAllBooking;
  final bool showMyBookAdded;
  final bool addNewBook;
  final bool editBook;
  final bool deleteBook;
  final bool receiptVoucherScreen;
  final bool showAllReceiptVoucher;
  final bool showReceiptVoucherAdded;
  final bool addNewReceiptVoucherMe;
  final bool addNewReceiptVoucherOtherEmployee;
  final bool editReceiptVoucher;
  final bool deleteReceiptVoucher;
  final bool pickupTimeScreen;
  final bool showAllPickup;
  final bool editAnyPickup;
  final bool serviceScreen;
  final bool showAllService;
  final bool addNewService;
  final bool editService;
  final bool deleteService;
  final bool hotelScreen;
  final bool showAllHotels;
  final bool addNewHotels;
  final bool editHotels;
  final bool deleteHotels;
  final bool campScreen;
  final bool showAllCampBookings;
  final bool changeStateBooking;
  final bool operationsScreen;
  final bool showAllOperations;
  final bool addNewOperation;
  final bool editOperation;
  final bool deleteOperation;
  final bool historyScreen;
  final bool showAllHistory;
  final bool settingScreen;

  Permissions({
    this.overviewScreen = false,
    this.analysisScreen = false,
    this.bookingScreen = false,
    this.showAllBooking = false,
    this.showMyBookAdded = false,
    this.addNewBook = false,
    this.editBook = false,
    this.deleteBook = false,
    this.receiptVoucherScreen = false,
    this.showAllReceiptVoucher = false,
    this.showReceiptVoucherAdded = false,
    this.addNewReceiptVoucherMe = false,
    this.addNewReceiptVoucherOtherEmployee = false,
    this.editReceiptVoucher = false,
    this.deleteReceiptVoucher = false,
    this.pickupTimeScreen = false,
    this.showAllPickup = false,
    this.editAnyPickup = false,
    this.serviceScreen = false,
    this.showAllService = false,
    this.addNewService = false,
    this.editService = false,
    this.deleteService = false,
    this.hotelScreen = false,
    this.showAllHotels = false,
    this.addNewHotels = false,
    this.editHotels = false,
    this.deleteHotels = false,
    this.campScreen = false,
    this.showAllCampBookings = false,
    this.changeStateBooking = false,
    this.operationsScreen = false,
    this.showAllOperations = false,
    this.addNewOperation = false,
    this.editOperation = false,
    this.deleteOperation = false,
    this.historyScreen = false,
    this.showAllHistory = false,
    this.settingScreen = false,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
    overviewScreen: json['overviewScreen'] ?? false,
    analysisScreen: json['analysisScreen'] ?? false,
    bookingScreen: json['bookingScreen'] ?? false,
    showAllBooking: json['showAllBooking'] ?? false,
    showMyBookAdded: json['showMyBookAdded'] ?? false,
    addNewBook: json['addNewBook'] ?? false,
    editBook: json['editBook'] ?? false,
    deleteBook: json['deleteBook'] ?? false,
    receiptVoucherScreen: json['receiptVoucherScreen'] ?? false,
    showAllReceiptVoucher: json['showAllReceiptVoucher'] ?? false,
    showReceiptVoucherAdded: json['showReceiptVoucherAdded'] ?? false,
    addNewReceiptVoucherMe: json['addNewReceiptVoucherMe'] ?? false,
    addNewReceiptVoucherOtherEmployee: json['addNewReceiptVoucherOtherEmployee'] ?? false,
    editReceiptVoucher: json['editReceiptVoucher'] ?? false,
    deleteReceiptVoucher: json['deleteReceiptVoucher'] ?? false,
    pickupTimeScreen: json['pickupTimeScreen'] ?? false,
    showAllPickup: json['showAllPickup'] ?? false,
    editAnyPickup: json['editAnyPickup'] ?? false,
    serviceScreen: json['serviceScreen'] ?? false,
    showAllService: json['showAllService'] ?? false,
    addNewService: json['addNewService'] ?? false,
    editService: json['editService'] ?? false,
    deleteService: json['deleteService'] ?? false,
    hotelScreen: json['hotelScreen'] ?? false,
    showAllHotels: json['showAllHotels'] ?? false,
    addNewHotels: json['addNewHotels'] ?? false,
    editHotels: json['editHotels'] ?? false,
    deleteHotels: json['deleteHotels'] ?? false,
    campScreen: json['campScreen'] ?? false,
    showAllCampBookings: json['showAllCampBookings'] ?? false,
    changeStateBooking: json['changeStateBooking'] ?? false,
    operationsScreen: json['operationsScreen'] ?? false,
    showAllOperations: json['showAllOperations'] ?? false,
    addNewOperation: json['addNewOperation'] ?? false,
    editOperation: json['editOperation'] ?? false,
    deleteOperation: json['deleteOperation'] ?? false,
    historyScreen: json['historyScreen'] ?? false,
    showAllHistory: json['showAllHistory'] ?? false,
    settingScreen: json['settingScreen'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'overviewScreen': overviewScreen,
    'analysisScreen': analysisScreen,
    'bookingScreen': bookingScreen,
    'showAllBooking': showAllBooking,
    'showMyBookAdded': showMyBookAdded,
    'addNewBook': addNewBook,
    'editBook': editBook,
    'deleteBook': deleteBook,
    'receiptVoucherScreen': receiptVoucherScreen,
    'showAllReceiptVoucher': showAllReceiptVoucher,
    'showReceiptVoucherAdded': showReceiptVoucherAdded,
    'addNewReceiptVoucherMe': addNewReceiptVoucherMe,
    'addNewReceiptVoucherOtherEmployee': addNewReceiptVoucherOtherEmployee,
    'editReceiptVoucher': editReceiptVoucher,
    'deleteReceiptVoucher': deleteReceiptVoucher,
    'pickupTimeScreen': pickupTimeScreen,
    'showAllPickup': showAllPickup,
    'editAnyPickup': editAnyPickup,
    'serviceScreen': serviceScreen,
    'showAllService': showAllService,
    'addNewService': addNewService,
    'editService': editService,
    'deleteService': deleteService,
    'hotelScreen': hotelScreen,
    'showAllHotels': showAllHotels,
    'addNewHotels': addNewHotels,
    'editHotels': editHotels,
    'deleteHotels': deleteHotels,
    'campScreen': campScreen,
    'showAllCampBookings': showAllCampBookings,
    'changeStateBooking': changeStateBooking,
    'operationsScreen': operationsScreen,
    'showAllOperations': showAllOperations,
    'addNewOperation': addNewOperation,
    'editOperation': editOperation,
    'deleteOperation': deleteOperation,
    'historyScreen': historyScreen,
    'showAllHistory': showAllHistory,
    'settingScreen': settingScreen,
  };
}
```

### Service Models

```dart
class Service {
  final int id;
  final String serviceName;

  Service({required this.id, required this.serviceName});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'] ?? 0,
    serviceName: json['serviceName'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'serviceName': serviceName,
  };
}
```

### Location Models

```dart
class Location {
  final int id;
  final String name;

  Location({required this.id, required this.name});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}
```

### Agent Models

```dart
class Agent {
  final int id;
  final String name;

  Agent({required this.id, required this.name});

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}
```

### ServiceAgent Models

```dart
class ServiceAgent {
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

  ServiceAgent({
    required this.id,
    required this.agentId,
    this.locationId,
    required this.serviceId,
    this.serviceName,
    this.locationName,
    required this.adultPrice,
    this.childPrice,
    this.kidPrice,
    required this.isGlobal,
  });

  factory ServiceAgent.fromJson(Map<String, dynamic> json) => ServiceAgent(
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

  Map<String, dynamic> toJson() => {
    'agentId': agentId,
    'locationId': locationId,
    'serviceId': serviceId,
    'adultPrice': adultPrice,
    'childPrice': childPrice,
    'kidPrice': kidPrice,
  };
}
```

### Booking Models

```dart
class Booking {
  final int id;
  final int employeeId;
  final String? employeeName;
  final int agentId;
  final String? agentName;
  final int serviceId;
  final String? serviceName;
  final int locationId;
  final String? locationName;
  final String guestName;
  final String? guestPhone;
  final String? guestEmail;
  final int? adults;
  final int? children;
  final int? kids;
  final String? pickupTime;
  final String? driver;
  final String? carNumber;
  final String status;
  final String? pickupStatus;
  final double? totalPrice;
  final String? notes;
  final String? bookingDate;

  Booking({
    required this.id,
    required this.employeeId,
    this.employeeName,
    required this.agentId,
    this.agentName,
    required this.serviceId,
    this.serviceName,
    required this.locationId,
    this.locationName,
    required this.guestName,
    this.guestPhone,
    this.guestEmail,
    this.adults,
    this.children,
    this.kids,
    this.pickupTime,
    this.driver,
    this.carNumber,
    required this.status,
    this.pickupStatus,
    this.totalPrice,
    this.notes,
    this.bookingDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] ?? 0,
    employeeId: json['employeeId'] ?? 0,
    employeeName: json['employeeName'],
    agentId: json['agentId'] ?? 0,
    agentName: json['agentName'],
    serviceId: json['serviceId'] ?? 0,
    serviceName: json['serviceName'],
    locationId: json['locationId'] ?? 0,
    locationName: json['locationName'],
    guestName: json['guestName'] ?? '',
    guestPhone: json['guestPhone'],
    guestEmail: json['guestEmail'],
    adults: json['adults'],
    children: json['children'],
    kids: json['kids'],
    pickupTime: json['pickupTime'],
    driver: json['driver'],
    carNumber: json['carNumber'],
    status: json['status'] ?? 'PENDING',
    pickupStatus: json['pickupStatus'],
    totalPrice: json['totalPrice']?.toDouble(),
    notes: json['notes'],
    bookingDate: json['bookingDate'],
  );

  Map<String, dynamic> toJson() => {
    'employeeId': employeeId,
    'agentId': agentId,
    'serviceId': serviceId,
    'locationId': locationId,
    'guestName': guestName,
    'guestPhone': guestPhone,
    'guestEmail': guestEmail,
    'adults': adults,
    'children': children,
    'kids': kids,
    'pickupTime': pickupTime,
    'driver': driver,
    'carNumber': carNumber,
    'status': status,
    'pickupStatus': pickupStatus,
    'totalPrice': totalPrice,
    'notes': notes,
  };
}
```

---

## 4. API Service Class

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _token;
  String _language = 'en';

  ApiService({this.baseUrl = 'http://localhost:8080'});

  void setToken(String? token) {
    _token = token;
  }

  void setLanguage(String language) {
    _language = language;
  }

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': _language,
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Helper method for GET requests
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  // Helper method for POST requests
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  // Helper method for PUT requests
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  // Helper method for DELETE requests
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: getHeaders(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw _handleError(response);
    }
  }

  Exception _handleError(http.Response response) {
    try {
      final error = jsonDecode(response.body);
      return ApiException(
        message: error['message'] ?? 'An error occurred',
        error: error['error'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiException(
        message: 'Failed to parse error response',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final String? error;
  final int statusCode;

  ApiException({
    required this.message,
    this.error,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
```

---

## 5. جميع الـ Endpoints

### 5.1 Authentication

#### POST `/api/auth/login`
```dart
Future<LoginResponse> login(String email, String password) async {
  final response = await apiService.post('/api/auth/login', {
    'email': email,
    'password': password,
  });
  
  final loginResponse = LoginResponse.fromJson(response);
  if (loginResponse.success && loginResponse.data != null) {
    apiService.setToken(loginResponse.data!.token);
  }
  return loginResponse;
}
```

---

### 5.2 Employees

#### GET `/api/employees`
```dart
Future<PaginatedResponse<Employee>> getEmployees({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/employees',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Employee.fromJson(json),
  );
}
```

#### GET `/api/employees/{id}`
```dart
Future<Employee> getEmployee(int id) async {
  final response = await apiService.get('/api/employees/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Employee.fromJson(json),
  ).data!;
}
```

#### POST `/api/employees`
```dart
Future<Employee> createEmployee(Employee employee) async {
  final response = await apiService.post('/api/employees', employee.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Employee.fromJson(json),
  ).data!;
}
```

#### PUT `/api/employees/{id}`
```dart
Future<Employee> updateEmployee(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/employees/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Employee.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/employees/{id}`
```dart
Future<void> deleteEmployee(int id) async {
  await apiService.delete('/api/employees/$id');
}
```

---

### 5.3 Services

#### GET `/api/services`
```dart
Future<PaginatedResponse<Service>> getServices({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/services',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Service.fromJson(json),
  );
}
```

#### GET `/api/services/all`
```dart
Future<List<Service>> getAllServices() async {
  final response = await apiService.get('/api/services/all');
  final baseResponse = BaseResponse.fromJson(
    response,
    (json) => (json as List).map((item) => Service.fromJson(item)).toList(),
  );
  return baseResponse.data ?? [];
}
```

#### GET `/api/services/{id}`
```dart
Future<Service> getService(int id) async {
  final response = await apiService.get('/api/services/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Service.fromJson(json),
  ).data!;
}
```

#### POST `/api/services`
```dart
Future<Service> createService(Service service) async {
  final response = await apiService.post('/api/services', service.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Service.fromJson(json),
  ).data!;
}
```

#### PUT `/api/services/{id}`
```dart
Future<Service> updateService(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/services/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Service.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/services/{id}`
```dart
Future<void> deleteService(int id) async {
  await apiService.delete('/api/services/$id');
}
```

---

### 5.4 Locations

#### GET `/api/locations`
```dart
Future<PaginatedResponse<Location>> getLocations({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/locations',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Location.fromJson(json),
  );
}
```

#### GET `/api/locations/all`
```dart
Future<List<Location>> getAllLocations() async {
  final response = await apiService.get('/api/locations/all');
  final baseResponse = BaseResponse.fromJson(
    response,
    (json) => (json as List).map((item) => Location.fromJson(item)).toList(),
  );
  return baseResponse.data ?? [];
}
```

#### GET `/api/locations/{id}`
```dart
Future<Location> getLocation(int id) async {
  final response = await apiService.get('/api/locations/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Location.fromJson(json),
  ).data!;
}
```

#### POST `/api/locations`
```dart
Future<Location> createLocation(Location location) async {
  final response = await apiService.post('/api/locations', location.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Location.fromJson(json),
  ).data!;
}
```

#### PUT `/api/locations/{id}`
```dart
Future<Location> updateLocation(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/locations/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Location.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/locations/{id}`
```dart
Future<void> deleteLocation(int id) async {
  await apiService.delete('/api/locations/$id');
}
```

---

### 5.5 Agents

#### GET `/api/agents`
```dart
Future<PaginatedResponse<Agent>> getAgents({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/agents',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Agent.fromJson(json),
  );
}
```

#### GET `/api/agents/all`
```dart
Future<List<Agent>> getAllAgents() async {
  final response = await apiService.get('/api/agents/all');
  final baseResponse = BaseResponse.fromJson(
    response,
    (json) => (json as List).map((item) => Agent.fromJson(item)).toList(),
  );
  return baseResponse.data ?? [];
}
```

#### GET `/api/agents/{id}`
```dart
Future<Agent> getAgent(int id) async {
  final response = await apiService.get('/api/agents/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Agent.fromJson(json),
  ).data!;
}
```

#### POST `/api/agents`
```dart
Future<Agent> createAgent(Agent agent) async {
  final response = await apiService.post('/api/agents', agent.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Agent.fromJson(json),
  ).data!;
}
```

#### PUT `/api/agents/{id}`
```dart
Future<Agent> updateAgent(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/agents/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Agent.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/agents/{id}`
```dart
Future<void> deleteAgent(int id) async {
  await apiService.delete('/api/agents/$id');
}
```

---

### 5.6 Service Agents

#### GET `/api/service-agents`
```dart
Future<PaginatedResponse<ServiceAgent>> getServiceAgents({
  int? agentId,
  int? locationId,
  int? serviceId,
  int page = 1,
  int pageSize = 20,
}) async {
  final queryParams = <String, String>{
    'page': page.toString(),
    'pageSize': pageSize.toString(),
  };
  
  if (agentId != null) queryParams['agentId'] = agentId.toString();
  if (locationId != null) queryParams['locationId'] = locationId.toString();
  if (serviceId != null) queryParams['serviceId'] = serviceId.toString();
  
  final response = await apiService.get('/api/service-agents', queryParams: queryParams);
  
  return PaginatedResponse.fromJson(
    response,
    (json) => ServiceAgent.fromJson(json),
  );
}
```

#### GET `/api/service-agents/all`
```dart
Future<List<ServiceAgent>> getAllServiceAgents({
  int? agentId,
  int? locationId,
  int? serviceId,
}) async {
  final queryParams = <String, String>{};
  
  if (agentId != null) queryParams['agentId'] = agentId.toString();
  if (locationId != null) queryParams['locationId'] = locationId.toString();
  if (serviceId != null) queryParams['serviceId'] = serviceId.toString();
  
  final response = await apiService.get('/api/service-agents/all', queryParams: queryParams);
  final baseResponse = BaseResponse.fromJson(
    response,
    (json) => (json as List).map((item) => ServiceAgent.fromJson(item)).toList(),
  );
  return baseResponse.data ?? [];
}
```

#### GET `/api/service-agents/{id}`
```dart
Future<ServiceAgent> getServiceAgent(int id) async {
  final response = await apiService.get('/api/service-agents/$id');
  return BaseResponse.fromJson(
    response,
    (json) => ServiceAgent.fromJson(json),
  ).data!;
}
```

#### GET `/api/agents/{agentId}/services`
```dart
Future<AgentServicesResponse> getAgentServices(int agentId, {int? locationId}) async {
  final queryParams = <String, String>{};
  if (locationId != null) queryParams['locationId'] = locationId.toString();
  
  final response = await apiService.get(
    '/api/agents/$agentId/services',
    queryParams: queryParams,
  );
  
  return BaseResponse.fromJson(
    response,
    (json) => AgentServicesResponse.fromJson(json),
  ).data!;
}
```

#### GET `/api/service-agents/by-agent-location`
```dart
Future<List<ServiceAgent>> getServicesByAgentAndLocation({
  required int agentId,
  int? locationId,
  int? serviceId,
  bool includeGlobal = false,
}) async {
  final queryParams = <String, String>{
    'agentId': agentId.toString(),
    'includeGlobal': includeGlobal.toString(),
  };
  
  if (locationId != null) queryParams['locationId'] = locationId.toString();
  if (serviceId != null) queryParams['serviceId'] = serviceId.toString();
  
  final response = await apiService.get(
    '/api/service-agents/by-agent-location',
    queryParams: queryParams,
  );
  
  final baseResponse = BaseResponse.fromJson(
    response,
    (json) => (json as List).map((item) => ServiceAgent.fromJson(item)).toList(),
  );
  return baseResponse.data ?? [];
}
```

#### POST `/api/agents/{agentId}/services`
```dart
Future<ServiceAgent> createServiceAgent(ServiceAgent serviceAgent) async {
  final response = await apiService.post(
    '/api/agents/${serviceAgent.agentId}/services',
    serviceAgent.toJson(),
  );
  
  return BaseResponse.fromJson(
    response,
    (json) => ServiceAgent.fromJson(json),
  ).data!;
}
```

#### PUT `/api/service-agents/{id}`
```dart
Future<ServiceAgent> updateServiceAgent(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/service-agents/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => ServiceAgent.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/service-agents/{id}`
```dart
Future<void> deleteServiceAgent(int id) async {
  await apiService.delete('/api/service-agents/$id');
}
```

---

### 5.7 Bookings

#### GET `/api/bookings`
```dart
Future<PaginatedResponse<Booking>> getBookings({
  int? employeeId,
  int page = 1,
  int pageSize = 20,
}) async {
  final queryParams = <String, String>{
    'page': page.toString(),
    'pageSize': pageSize.toString(),
  };
  
  if (employeeId != null) queryParams['employeeId'] = employeeId.toString();
  
  final response = await apiService.get('/api/bookings', queryParams: queryParams);
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  );
}
```

#### GET `/api/bookings/{id}`
```dart
Future<Booking> getBooking(int id) async {
  final response = await apiService.get('/api/bookings/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### POST `/api/bookings`
```dart
Future<Booking> createBooking(Booking booking) async {
  final response = await apiService.post('/api/bookings', booking.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### PUT `/api/bookings/{id}`
```dart
Future<Booking> updateBooking(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/bookings/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### PUT `/api/bookings/{id}/status`
```dart
Future<Booking> updateBookingStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/bookings/$id/status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### PUT `/api/bookings/{id}/pickup-status`
```dart
Future<Booking> updatePickupStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/bookings/$id/pickup-status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/bookings/{id}`
```dart
Future<void> deleteBooking(int id) async {
  await apiService.delete('/api/bookings/$id');
}
```

---

### 5.8 Receipt Vouchers

#### GET `/api/receipt-vouchers`
```dart
Future<PaginatedResponse<ReceiptVoucher>> getReceiptVouchers({
  int? employeeId,
  int page = 1,
  int pageSize = 20,
}) async {
  final queryParams = <String, String>{
    'page': page.toString(),
    'pageSize': pageSize.toString(),
  };
  
  if (employeeId != null) queryParams['employeeId'] = employeeId.toString();
  
  final response = await apiService.get('/api/receipt-vouchers', queryParams: queryParams);
  
  return PaginatedResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  );
}
```

#### GET `/api/receipt-vouchers/{id}`
```dart
Future<ReceiptVoucher> getReceiptVoucher(int id) async {
  final response = await apiService.get('/api/receipt-vouchers/$id');
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

#### POST `/api/receipt-vouchers`
```dart
Future<ReceiptVoucher> createReceiptVoucher(ReceiptVoucher voucher) async {
  final response = await apiService.post('/api/receipt-vouchers', voucher.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

#### PUT `/api/receipt-vouchers/{id}`
```dart
Future<ReceiptVoucher> updateReceiptVoucher(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/receipt-vouchers/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

#### PUT `/api/receipt-vouchers/{id}/status`
```dart
Future<ReceiptVoucher> updateReceiptVoucherStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/receipt-vouchers/$id/status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

#### PUT `/api/receipt-vouchers/{id}/pickup-status`
```dart
Future<ReceiptVoucher> updateReceiptVoucherPickupStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/receipt-vouchers/$id/pickup-status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/receipt-vouchers/{id}`
```dart
Future<void> deleteReceiptVoucher(int id) async {
  await apiService.delete('/api/receipt-vouchers/$id');
}
```

---

### 5.9 Camp

#### GET `/api/camp`
```dart
Future<CampData> getCampData() async {
  final response = await apiService.get('/api/camp');
  return BaseResponse.fromJson(
    response,
    (json) => CampData.fromJson(json),
  ).data!;
}
```

#### PUT `/api/camp/bookings/{id}/status`
```dart
Future<Booking> updateCampBookingStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/camp/bookings/$id/status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => Booking.fromJson(json),
  ).data!;
}
```

#### PUT `/api/camp/vouchers/{id}/status`
```dart
Future<ReceiptVoucher> updateCampVoucherStatus(int id, String status) async {
  final response = await apiService.put(
    '/api/camp/vouchers/$id/status',
    {'status': status},
  );
  return BaseResponse.fromJson(
    response,
    (json) => ReceiptVoucher.fromJson(json),
  ).data!;
}
```

---

### 5.10 Pickup Times

#### GET `/api/pickup-times`
```dart
Future<PickupTimesResponse> getPickupTimes() async {
  final response = await apiService.get('/api/pickup-times');
  return BaseResponse.fromJson(
    response,
    (json) => PickupTimesResponse.fromJson(json),
  ).data!;
}
```

---

### 5.11 Statistics

#### GET `/api/statistics`
```dart
Future<StatisticsResponse> getStatistics() async {
  final response = await apiService.get('/api/statistics');
  return BaseResponse.fromJson(
    response,
    (json) => StatisticsResponse.fromJson(json),
  ).data!;
}
```

---

### 5.12 Users

#### GET `/api/users`
```dart
Future<PaginatedResponse<User>> getUsers({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/users',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => User.fromJson(json),
  );
}
```

#### GET `/api/users/{id}`
```dart
Future<User> getUser(int id) async {
  final response = await apiService.get('/api/users/$id');
  return BaseResponse.fromJson(
    response,
    (json) => User.fromJson(json),
  ).data!;
}
```

#### POST `/api/users`
```dart
Future<User> createUser(User user) async {
  final response = await apiService.post('/api/users', user.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => User.fromJson(json),
  ).data!;
}
```

#### PUT `/api/users/{id}`
```dart
Future<User> updateUser(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/users/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => User.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/users/{id}`
```dart
Future<void> deleteUser(int id) async {
  await apiService.delete('/api/users/$id');
}
```

---

## 6. Error Handling

### Error Response Structure
```dart
class ApiError {
  final bool success;
  final String message;
  final String? error;

  ApiError({
    required this.success,
    required this.message,
    this.error,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    error: json['error'],
  );
}
```

### Error Handling Example
```dart
try {
  final employees = await apiService.getEmployees();
  // Handle success
} on ApiException catch (e) {
  if (e.statusCode == 401) {
    // Unauthorized - redirect to login
    print('Please login again');
  } else if (e.statusCode == 404) {
    // Not found
    print('Resource not found: ${e.message}');
  } else {
    // Other errors
    print('Error: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

---

## 7. أمثلة الاستخدام الكاملة

### Example: Complete Flutter App Setup

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Dunes App',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      
      if (response.success && response.data != null) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading 
                  ? CircularProgressIndicator() 
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _apiService.getBookings();
      setState(() {
        _bookings = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookings')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final booking = _bookings[index];
                return ListTile(
                  title: Text(booking.guestName),
                  subtitle: Text(booking.serviceName ?? ''),
                  trailing: Text(booking.status),
                  onTap: () {
                    // Navigate to booking details
                  },
                );
              },
            ),
    );
  }
}
```

---

## 📝 ملاحظات مهمة

1. **Authentication**: جميع الـ endpoints (عدا `/api/auth/login`) تحتاج إلى `Authorization: Bearer {token}` في الـ headers.

2. **Language**: استخدم `Accept-Language` header لتحديد اللغة المطلوبة للرسائل.

3. **Pagination**: جميع الـ list endpoints تدعم pagination عبر `page` و `pageSize` query parameters.

4. **Error Handling**: دائماً استخدم try-catch للتعامل مع الأخطاء.

5. **Token Storage**: احفظ الـ token في `SharedPreferences` أو `SecureStorage` لإعادة استخدامه.

6. **Base URL**: غيّر `baseUrl` حسب البيئة (Development/Production).

---

## 🔗 روابط مفيدة

- [HTTP Package Documentation](https://pub.dev/packages/http)
- [Flutter JSON Serialization](https://flutter.dev/docs/development/data-and-backend/json)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

---

### Booking Models (Complete)

```dart
class BookingService {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPriceService;

  BookingService({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPriceService,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
    id: json['id'] ?? 0,
    serviceId: json['serviceId'] ?? 0,
    serviceName: json['serviceName'],
    locationId: json['locationId'],
    adultNumber: json['adultNumber'] ?? 0,
    childNumber: json['childNumber'] ?? 0,
    kidNumber: json['kidNumber'] ?? 0,
    adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
    childPrice: (json['childPrice'] ?? 0.0).toDouble(),
    kidPrice: (json['kidPrice'] ?? 0.0).toDouble(),
    totalPriceService: (json['totalPriceService'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'locationId': locationId,
    'adultNumber': adultNumber,
    'childNumber': childNumber,
    'kidNumber': kidNumber,
  };
}

class Booking {
  final int id;
  final int? time;
  final String? voucher;
  final String? orderNumber;
  final int? pickupTime;
  final String? pickupStatus;
  final int employeeId;
  final String? employeeName;
  final String guestName;
  final String? phoneNumber;
  final String statusBook;
  final int agentName;
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
  final List<BookingService> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPrice;
  final String? bookingDate;

  Booking({
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

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] ?? 0,
    time: json['time'],
    voucher: json['voucher'],
    orderNumber: json['orderNumber'],
    pickupTime: json['pickupTime'],
    pickupStatus: json['pickupStatus'],
    employeeId: json['employeeId'] ?? 0,
    employeeName: json['employeeName'],
    guestName: json['guestName'] ?? '',
    phoneNumber: json['phoneNumber'],
    statusBook: json['statusBook'] ?? 'PENDING',
    agentName: json['agentName'] ?? 0,
    agentNameStr: json['agentNameStr'],
    locationId: json['locationId'],
    locationName: json['locationName'],
    hotelName: json['hotelName'],
    room: json['room'],
    note: json['note'],
    driver: json['driver'],
    carNumber: json['carNumber'],
    payment: json['payment'] ?? 'PENDING',
    typeOperation: json['typeOperation'] ?? '',
    services: (json['services'] as List<dynamic>?)
            ?.map((item) => BookingService.fromJson(item))
            .toList() ??
        [],
    priceBeforePercentage: (json['priceBeforePercentage'] ?? 0.0).toDouble(),
    priceAfterPercentage: (json['priceAfterPercentage'] ?? 0.0).toDouble(),
    finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
    bookingDate: json['bookingDate'],
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'voucher': voucher,
    'orderNumber': orderNumber,
    'pickupTime': pickupTime,
    'pickupStatus': pickupStatus,
    'employeeId': employeeId,
    'guestName': guestName,
    'phoneNumber': phoneNumber,
    'statusBook': statusBook,
    'agentName': agentName,
    'locationId': locationId,
    'hotelName': hotelName,
    'room': room,
    'note': note,
    'driver': driver,
    'carNumber': carNumber,
    'payment': payment,
    'typeOperation': typeOperation,
    'services': services.map((s) => s.toJson()).toList(),
    'priceBeforePercentage': priceBeforePercentage,
    'priceAfterPercentage': priceAfterPercentage,
    'finalPrice': finalPrice,
  };
}
```

### ReceiptVoucher Models

```dart
class ReceiptVoucherService {
  final int id;
  final int serviceId;
  final String? serviceName;
  final int? locationId;
  final int adultNumber;
  final int childNumber;
  final int kidNumber;
  final double adultPrice;
  final double childPrice;
  final double kidPrice;
  final double totalPriceService;

  ReceiptVoucherService({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.locationId,
    required this.adultNumber,
    required this.childNumber,
    required this.kidNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.kidPrice,
    required this.totalPriceService,
  });

  factory ReceiptVoucherService.fromJson(Map<String, dynamic> json) =>
      ReceiptVoucherService(
    id: json['id'] ?? 0,
    serviceId: json['serviceId'] ?? 0,
    serviceName: json['serviceName'],
    locationId: json['locationId'],
    adultNumber: json['adultNumber'] ?? 0,
    childNumber: json['childNumber'] ?? 0,
    kidNumber: json['kidNumber'] ?? 0,
    adultPrice: (json['adultPrice'] ?? 0.0).toDouble(),
    childPrice: (json['childPrice'] ?? 0.0).toDouble(),
    kidPrice: (json['kidPrice'] ?? 0.0).toDouble(),
    totalPriceService: (json['totalPriceService'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'locationId': locationId,
    'adultNumber': adultNumber,
    'childNumber': childNumber,
    'kidNumber': kidNumber,
  };
}

class ReceiptVoucher {
  final int id;
  final int? time;
  final String? voucher;
  final String? orderNumber;
  final int? pickupTime;
  final String? pickupStatus;
  final int employeeId;
  final String? employeeName;
  final String guestName;
  final String? phoneNumber;
  final String statusBook;
  final int agentName;
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
  final List<ReceiptVoucherService> services;
  final double priceBeforePercentage;
  final double priceAfterPercentage;
  final double finalPrice;
  final String? receiptDate;

  ReceiptVoucher({
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
    this.receiptDate,
  });

  factory ReceiptVoucher.fromJson(Map<String, dynamic> json) => ReceiptVoucher(
    id: json['id'] ?? 0,
    time: json['time'],
    voucher: json['voucher'],
    orderNumber: json['orderNumber'],
    pickupTime: json['pickupTime'],
    pickupStatus: json['pickupStatus'],
    employeeId: json['employeeId'] ?? 0,
    employeeName: json['employeeName'],
    guestName: json['guestName'] ?? '',
    phoneNumber: json['phoneNumber'],
    statusBook: json['statusBook'] ?? 'PENDING',
    agentName: json['agentName'] ?? 0,
    agentNameStr: json['agentNameStr'],
    locationId: json['locationId'],
    locationName: json['locationName'],
    hotelName: json['hotelName'],
    room: json['room'],
    note: json['note'],
    driver: json['driver'],
    carNumber: json['carNumber'],
    payment: json['payment'] ?? 'PENDING',
    typeOperation: json['typeOperation'] ?? '',
    services: (json['services'] as List<dynamic>?)
            ?.map((item) => ReceiptVoucherService.fromJson(item))
            .toList() ??
        [],
    priceBeforePercentage: (json['priceBeforePercentage'] ?? 0.0).toDouble(),
    priceAfterPercentage: (json['priceAfterPercentage'] ?? 0.0).toDouble(),
    finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
    receiptDate: json['receiptDate'],
  );

  Map<String, dynamic> toJson() => {
    'time': time,
    'voucher': voucher,
    'orderNumber': orderNumber,
    'pickupTime': pickupTime,
    'pickupStatus': pickupStatus,
    'employeeId': employeeId,
    'guestName': guestName,
    'phoneNumber': phoneNumber,
    'statusBook': statusBook,
    'agentName': agentName,
    'locationId': locationId,
    'hotelName': hotelName,
    'room': room,
    'note': note,
    'driver': driver,
    'carNumber': carNumber,
    'payment': payment,
    'typeOperation': typeOperation,
    'services': services.map((s) => s.toJson()).toList(),
    'priceBeforePercentage': priceBeforePercentage,
    'priceAfterPercentage': priceAfterPercentage,
    'finalPrice': finalPrice,
  };
}
```

### Camp Models

```dart
class CampData {
  final List<Booking> bookings;
  final List<ReceiptVoucher> vouchers;

  CampData({
    required this.bookings,
    required this.vouchers,
  });

  factory CampData.fromJson(Map<String, dynamic> json) => CampData(
    bookings: (json['bookings'] as List<dynamic>?)
            ?.map((item) => Booking.fromJson(item))
            .toList() ??
        [],
    vouchers: (json['vouchers'] as List<dynamic>?)
            ?.map((item) => ReceiptVoucher.fromJson(item))
            .toList() ??
        [],
  );
}
```

### PickupTimes Models

```dart
class PickupItem {
  final int id;
  final String type; // "booking" or "voucher"
  final String guestName;
  final int? pickupTime; // Unix timestamp
  final String? driver;
  final String? carNumber;

  PickupItem({
    required this.id,
    required this.type,
    required this.guestName,
    this.pickupTime,
    this.driver,
    this.carNumber,
  });

  factory PickupItem.fromJson(Map<String, dynamic> json) => PickupItem(
    id: json['id'] ?? 0,
    type: json['type'] ?? '',
    guestName: json['guestName'] ?? '',
    pickupTime: json['pickupTime'],
    driver: json['driver'],
    carNumber: json['carNumber'],
  );
}

class PickupTimesResponse {
  final List<PickupItem> bookings;
  final List<PickupItem> vouchers;

  PickupTimesResponse({
    required this.bookings,
    required this.vouchers,
  });

  factory PickupTimesResponse.fromJson(Map<String, dynamic> json) =>
      PickupTimesResponse(
    bookings: (json['bookings'] as List<dynamic>?)
            ?.map((item) => PickupItem.fromJson(item))
            .toList() ??
        [],
    vouchers: (json['vouchers'] as List<dynamic>?)
            ?.map((item) => PickupItem.fromJson(item))
            .toList() ??
        [],
  );
}
```

### User Models

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}
```

### AgentServicesResponse Model

```dart
class AgentServicesResponse {
  final int agentId;
  final String agentName;
  final List<ServiceAgent> globalServices;
  final Map<String, List<ServiceAgent>> locationServices;

  AgentServicesResponse({
    required this.agentId,
    required this.agentName,
    required this.globalServices,
    required this.locationServices,
  });

  factory AgentServicesResponse.fromJson(Map<String, dynamic> json) {
    final locationServicesMap = <String, List<ServiceAgent>>{};
    if (json['locationServices'] != null) {
      (json['locationServices'] as Map<String, dynamic>).forEach((key, value) {
        locationServicesMap[key] = (value as List<dynamic>)
            .map((item) => ServiceAgent.fromJson(item))
            .toList();
      });
    }

    return AgentServicesResponse(
      agentId: json['agentId'] ?? 0,
      agentName: json['agentName'] ?? '',
      globalServices: (json['globalServices'] as List<dynamic>?)
              ?.map((item) => ServiceAgent.fromJson(item))
              .toList() ??
          [],
      locationServices: locationServicesMap,
    );
  }
}
```

---

## 📦 Dependencies المطلوبة

أضف هذه الـ dependencies في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  intl: ^0.18.1  # For date formatting
```

ثم قم بتشغيل:
```bash
flutter pub get
```

---

## 🔐 Token Storage Example

```dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _languageKey = 'language';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
}
```

---

## 📱 Complete Example: Booking Creation

```dart
Future<Booking> createBookingExample() async {
  // 1. Get services for agent and location
  final services = await apiService.getServicesByAgentAndLocation(
    agentId: 1,
    locationId: 4,
  );

  // 2. Select a service
  final selectedService = services.first;

  // 3. Calculate prices
  final adults = 2;
  final children = 1;
  final kids = 0;
  
  final adultTotal = selectedService.adultPrice * adults;
  final childTotal = (selectedService.childPrice ?? 0) * children;
  final kidTotal = (selectedService.kidPrice ?? 0) * kids;
  final priceBeforePercentage = adultTotal + childTotal + kidTotal;
  final priceAfterPercentage = priceBeforePercentage; // Add commission calculation
  final finalPrice = priceAfterPercentage;

  // 4. Create booking
  final booking = Booking(
    id: 0, // Will be set by server
    employeeId: 1, // Current employee ID
    guestName: 'Ahmed Ali',
    phoneNumber: '+971501234567',
    statusBook: 'PENDING',
    agentName: 1,
    locationId: 4,
    hotelName: 'Grand Hotel',
    room: 101,
    payment: 'PENDING',
    typeOperation: 'BOOKING',
    services: [
      BookingService(
        id: 0,
        serviceId: selectedService.serviceId,
        locationId: selectedService.locationId,
        adultNumber: adults,
        childNumber: children,
        kidNumber: kids,
        adultPrice: selectedService.adultPrice,
        childPrice: selectedService.childPrice ?? 0,
        kidPrice: selectedService.kidPrice ?? 0,
        totalPriceService: adultTotal + childTotal + kidTotal,
      ),
    ],
    priceBeforePercentage: priceBeforePercentage,
    priceAfterPercentage: priceAfterPercentage,
    finalPrice: finalPrice,
  );

  // 5. Send to API
  return await apiService.createBooking(booking);
}
```

---

## 🎯 Status Values

### Booking Status
- `PENDING` - في الانتظار
- `ACCEPTED` - مقبول
- `COMPLETED` - مكتمل
- `CANCELLED` - ملغي

### Pickup Status
- `PENDING` - في الانتظار
- `PICKED` - تم الاستلام
- `NOT_PICKED` - لم يتم الاستلام

### Payment Status
- `PENDING` - في الانتظار
- `PAID` - مدفوع
- `UNPAID` - غير مدفوع

---

### 5.13 Operations

#### GET `/api/operations`
```dart
Future<PaginatedResponse<Operation>> getOperations({
  int page = 1,
  int pageSize = 20,
}) async {
  final response = await apiService.get(
    '/api/operations',
    queryParams: {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    },
  );
  
  return PaginatedResponse.fromJson(
    response,
    (json) => Operation.fromJson(json),
  );
}
```

#### GET `/api/operations/analysis`
```dart
Future<OperationAnalysis> getOperationAnalysis() async {
  final response = await apiService.get('/api/operations/analysis');
  return BaseResponse.fromJson(
    response,
    (json) => OperationAnalysis.fromJson(json),
  ).data!;
}
```

#### GET `/api/operations/{id}`
```dart
Future<Operation> getOperation(int id) async {
  final response = await apiService.get('/api/operations/$id');
  return BaseResponse.fromJson(
    response,
    (json) => Operation.fromJson(json),
  ).data!;
}
```

#### POST `/api/operations`
```dart
Future<Operation> createOperation(Operation operation) async {
  final response = await apiService.post('/api/operations', operation.toJson());
  return BaseResponse.fromJson(
    response,
    (json) => Operation.fromJson(json),
  ).data!;
}
```

#### PUT `/api/operations/{id}`
```dart
Future<Operation> updateOperation(int id, Map<String, dynamic> updates) async {
  final response = await apiService.put('/api/operations/$id', updates);
  return BaseResponse.fromJson(
    response,
    (json) => Operation.fromJson(json),
  ).data!;
}
```

#### DELETE `/api/operations/{id}`
```dart
Future<void> deleteOperation(int id) async {
  await apiService.delete('/api/operations/$id');
}
```

---

### Operation Models

```dart
class Operation {
  final int id;
  final String name;
  final String? description;
  // Add other fields based on your OperationDto

  Operation({
    required this.id,
    required this.name,
    this.description,
  });

  factory Operation.fromJson(Map<String, dynamic> json) => Operation(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };
}

class OperationAnalysis {
  final Map<String, dynamic> data;

  OperationAnalysis({required this.data});

  factory OperationAnalysis.fromJson(Map<String, dynamic> json) =>
      OperationAnalysis(data: json);
}
```

---

## 📊 Statistics Response Example

#### GET `/api/statistics`
```dart
Future<StatisticsResponse> getStatistics({
  int? startDate, // Unix timestamp
  int? endDate,   // Unix timestamp
}) async {
  final queryParams = <String, String>{};
  if (startDate != null) queryParams['startDate'] = startDate.toString();
  if (endDate != null) queryParams['endDate'] = endDate.toString();
  
  final response = await apiService.get(
    '/api/statistics',
    queryParams: queryParams,
  );
  
  return BaseResponse.fromJson(
    response,
    (json) => StatisticsResponse.fromJson(json),
  ).data!;
}
```

### Statistics Models

```dart
class StatisticsResponse {
  final BookingStatistics bookings;
  final VoucherStatistics vouchers;
  final OperationStatistics operations;
  final EmployeeStatistics employees;
  final double totalRevenue;
  final double totalProfit;

  StatisticsResponse({
    required this.bookings,
    required this.vouchers,
    required this.operations,
    required this.employees,
    required this.totalRevenue,
    required this.totalProfit,
  });

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) =>
      StatisticsResponse(
    bookings: BookingStatistics.fromJson(json['bookings'] ?? {}),
    vouchers: VoucherStatistics.fromJson(json['vouchers'] ?? {}),
    operations: OperationStatistics.fromJson(json['operations'] ?? {}),
    employees: EmployeeStatistics.fromJson(json['employees'] ?? {}),
    totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
    totalProfit: (json['totalProfit'] ?? 0.0).toDouble(),
  );
}

class BookingStatistics {
  final int total;
  final int pending;
  final int accepted;
  final int completed;
  final int cancelled;

  BookingStatistics({
    required this.total,
    required this.pending,
    required this.accepted,
    required this.completed,
    required this.cancelled,
  });

  factory BookingStatistics.fromJson(Map<String, dynamic> json) =>
      BookingStatistics(
    total: json['total'] ?? 0,
    pending: json['pending'] ?? 0,
    accepted: json['accepted'] ?? 0,
    completed: json['completed'] ?? 0,
    cancelled: json['cancelled'] ?? 0,
  );
}

class VoucherStatistics {
  final int total;
  final int pending;
  final int accepted;
  final int completed;
  final int cancelled;

  VoucherStatistics({
    required this.total,
    required this.pending,
    required this.accepted,
    required this.completed,
    required this.cancelled,
  });

  factory VoucherStatistics.fromJson(Map<String, dynamic> json) =>
      VoucherStatistics(
    total: json['total'] ?? 0,
    pending: json['pending'] ?? 0,
    accepted: json['accepted'] ?? 0,
    completed: json['completed'] ?? 0,
    cancelled: json['cancelled'] ?? 0,
  );
}

class OperationStatistics {
  final int total;
  final double profit;

  OperationStatistics({
    required this.total,
    required this.profit,
  });

  factory OperationStatistics.fromJson(Map<String, dynamic> json) =>
      OperationStatistics(
    total: json['total'] ?? 0,
    profit: (json['profit'] ?? 0.0).toDouble(),
  );
}

class EmployeeStatistics {
  final int total;
  final int active;
  final int inactive;

  EmployeeStatistics({
    required this.total,
    required this.active,
    required this.inactive,
  });

  factory EmployeeStatistics.fromJson(Map<String, dynamic> json) =>
      EmployeeStatistics(
    total: json['total'] ?? 0,
    active: json['active'] ?? 0,
    inactive: json['inactive'] ?? 0,
  );
}
```

---

## 📝 ملخص جميع الـ Endpoints

| Method | Endpoint | الوظيفة | Authentication |
|--------|----------|---------|----------------|
| POST | `/api/auth/login` | تسجيل الدخول | ❌ |
| GET | `/api/employees` | جلب جميع الموظفين | ✅ |
| GET | `/api/employees/{id}` | جلب موظف محدد | ✅ |
| POST | `/api/employees` | إنشاء موظف جديد | ✅ |
| PUT | `/api/employees/{id}` | تحديث موظف | ✅ |
| DELETE | `/api/employees/{id}` | حذف موظف | ✅ |
| GET | `/api/services` | جلب جميع الخدمات | ✅ |
| GET | `/api/services/all` | جلب جميع الخدمات بدون pagination | ✅ |
| GET | `/api/services/{id}` | جلب خدمة محددة | ✅ |
| POST | `/api/services` | إنشاء خدمة جديدة | ✅ |
| PUT | `/api/services/{id}` | تحديث خدمة | ✅ |
| DELETE | `/api/services/{id}` | حذف خدمة | ✅ |
| GET | `/api/locations` | جلب جميع المواقع | ✅ |
| GET | `/api/locations/all` | جلب جميع المواقع بدون pagination | ✅ |
| GET | `/api/locations/{id}` | جلب موقع محدد | ✅ |
| POST | `/api/locations` | إنشاء موقع جديد | ✅ |
| PUT | `/api/locations/{id}` | تحديث موقع | ✅ |
| DELETE | `/api/locations/{id}` | حذف موقع | ✅ |
| GET | `/api/agents` | جلب جميع الوكلاء | ✅ |
| GET | `/api/agents/all` | جلب جميع الوكلاء بدون pagination | ✅ |
| GET | `/api/agents/{id}` | جلب وكيل محدد | ✅ |
| POST | `/api/agents` | إنشاء وكيل جديد | ✅ |
| PUT | `/api/agents/{id}` | تحديث وكيل | ✅ |
| DELETE | `/api/agents/{id}` | حذف وكيل | ✅ |
| GET | `/api/service-agents` | جلب جميع service-agents | ✅ |
| GET | `/api/service-agents/all` | جلب جميع service-agents بدون pagination | ✅ |
| GET | `/api/service-agents/{id}` | جلب service-agent محدد | ✅ |
| GET | `/api/agents/{agentId}/services` | جلب خدمات وكيل محدد | ✅ |
| GET | `/api/service-agents/by-agent-location` | جلب خدمات وكيل حسب الموقع | ✅ |
| POST | `/api/agents/{agentId}/services` | إنشاء service-agent جديد | ✅ |
| PUT | `/api/service-agents/{id}` | تحديث service-agent | ✅ |
| DELETE | `/api/service-agents/{id}` | حذف service-agent | ✅ |
| GET | `/api/bookings` | جلب جميع الحجوزات | ✅ |
| GET | `/api/bookings/{id}` | جلب حجز محدد | ✅ |
| POST | `/api/bookings` | إنشاء حجز جديد | ✅ |
| PUT | `/api/bookings/{id}` | تحديث حجز | ✅ |
| PUT | `/api/bookings/{id}/status` | تحديث حالة الحجز | ✅ |
| PUT | `/api/bookings/{id}/pickup-status` | تحديث حالة الاستلام | ✅ |
| DELETE | `/api/bookings/{id}` | حذف حجز | ✅ |
| GET | `/api/receipt-vouchers` | جلب جميع الفواتير | ✅ |
| GET | `/api/receipt-vouchers/{id}` | جلب فاتورة محددة | ✅ |
| POST | `/api/receipt-vouchers` | إنشاء فاتورة جديدة | ✅ |
| PUT | `/api/receipt-vouchers/{id}` | تحديث فاتورة | ✅ |
| PUT | `/api/receipt-vouchers/{id}/status` | تحديث حالة الفاتورة | ✅ |
| PUT | `/api/receipt-vouchers/{id}/pickup-status` | تحديث حالة الاستلام | ✅ |
| DELETE | `/api/receipt-vouchers/{id}` | حذف فاتورة | ✅ |
| GET | `/api/camp` | جلب بيانات المعسكر | ✅ |
| PUT | `/api/camp/bookings/{id}/status` | تحديث حالة حجز في المعسكر | ✅ |
| PUT | `/api/camp/vouchers/{id}/status` | تحديث حالة فاتورة في المعسكر | ✅ |
| GET | `/api/pickup-times` | جلب أوقات الاستلام المعلقة | ✅ |
| GET | `/api/statistics` | جلب الإحصائيات | ✅ |
| GET | `/api/operations` | جلب جميع العمليات | ✅ |
| GET | `/api/operations/analysis` | جلب تحليل العمليات | ✅ |
| GET | `/api/operations/{id}` | جلب عملية محددة | ✅ |
| POST | `/api/operations` | إنشاء عملية جديدة | ✅ |
| PUT | `/api/operations/{id}` | تحديث عملية | ✅ |
| DELETE | `/api/operations/{id}` | حذف عملية | ✅ |
| GET | `/api/users` | جلب جميع المستخدمين | ✅ |
| GET | `/api/users/{id}` | جلب مستخدم محدد | ✅ |
| POST | `/api/users` | إنشاء مستخدم جديد | ✅ |
| PUT | `/api/users/{id}` | تحديث مستخدم | ✅ |
| DELETE | `/api/users/{id}` | حذف مستخدم | ✅ |

---

## 🔄 Complete Flutter Service Implementation

```dart
// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl;
  String? _token;
  String _language = 'en';

  ApiService({this.baseUrl = 'http://localhost:8080'});

  void setToken(String? token) => _token = token;
  void setLanguage(String language) => _language = language;

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': _language,
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        message: 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  // Authentication
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: getHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    final data = _handleResponse(response);
    final loginResponse = LoginResponse.fromJson(data);
    
    if (loginResponse.success && loginResponse.data != null) {
      setToken(loginResponse.data!.token);
    }
    
    return loginResponse;
  }

  // Employees
  Future<PaginatedResponse<Employee>> getEmployees({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/employees')
          .replace(queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      }),
      headers: getHeaders(),
    );
    
    return PaginatedResponse.fromJson(
      _handleResponse(response),
      (json) => Employee.fromJson(json),
    );
  }

  // Add all other methods following the same pattern...
  // (Services, Locations, Agents, ServiceAgents, Bookings, etc.)
}
```

---

## 🎨 Example: Complete Flutter App Structure

```
lib/
├── main.dart
├── models/
│   ├── employee.dart
│   ├── service.dart
│   ├── location.dart
│   ├── agent.dart
│   ├── service_agent.dart
│   ├── booking.dart
│   ├── receipt_voucher.dart
│   └── ...
├── services/
│   ├── api_service.dart
│   └── token_storage.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── bookings_screen.dart
│   └── ...
└── widgets/
    ├── booking_card.dart
    └── ...
```

---

## 🚀 Quick Start Guide

### 1. إعداد المشروع
```bash
flutter create the_dunes_app
cd the_dunes_app
```

### 2. إضافة Dependencies
```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
  intl: ^0.18.1
```

### 3. إنشاء Models
انسخ جميع الـ models من القسم 3 في هذا الملف.

### 4. إنشاء ApiService
انسخ `ApiService` class من القسم 4.

### 5. استخدام الـ API
```dart
final apiService = ApiService(baseUrl: 'http://your-api-url.com');

// Login
final loginResponse = await apiService.login('email@example.com', 'password');

// Get Employees
final employees = await apiService.getEmployees(page: 1, pageSize: 20);

// Get Services for Agent
final services = await apiService.getServicesByAgentAndLocation(
  agentId: 1,
  locationId: 4,
);
```

---

**تم إنشاء هذا التوثيق بواسطة AI Assistant**  
**آخر تحديث: 2024**

**ملاحظة:** هذا التوثيق شامل لجميع الـ endpoints المتاحة في API. استخدمه كمرجع عند تطوير تطبيق Flutter الخاص بك.

**للحصول على Swagger UI:** افتح `http://localhost:8080/swagger-ui` في المتصفح للاطلاع على التوثيق التفاعلي.


# 🔧 دليل فهم Backend Integration في The Dunes ERP

## 📋 جدول المحتويات
1. [نظرة عامة على البنية](#1-نظرة-عامة-على-البنية)
2. [Network Layer (طبقة الشبكة)](#2-network-layer-طبقة-الشبكة)
3. [Data Layer (طبقة البيانات)](#3-data-layer-طبقة-البيانات)
4. [Authentication Flow (تدفق المصادقة)](#4-authentication-flow-تدفق-المصادقة)
5. [Error Handling (معالجة الأخطاء)](#5-error-handling-معالجة-الأخطاء)
6. [Response Format (تنسيق الاستجابة)](#6-response-format-تنسيق-الاستجابة)
7. [Common Issues & Solutions (المشاكل الشائعة والحلول)](#7-common-issues--solutions-المشاكل-الشائعة-والحلول)

---

## 1. نظرة عامة على البنية

المشروع يتبع **Clean Architecture** مع فصل واضح بين الطبقات:

```
┌─────────────────────────────────────────┐
│     Presentation Layer (UI)             │
│  - Screens, Widgets, Cubits            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Domain Layer (Business Logic)      │
│  - Entities, UseCases, Repositories    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Data Layer (API Integration)       │
│  - Models, DataSources, Repositories   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Core Network Layer                  │
│  - ApiClient, ApiException, Handlers    │
└─────────────────────────────────────────┘
```

---

## 2. Network Layer (طبقة الشبكة)

### 2.1 ApiClient (العميل الرئيسي)

**الموقع:** `lib/core/network/api_client.dart`

**الوظيفة:**
- إدارة الـ Base URL
- إدارة الـ Token (التخزين والاسترجاع)
- إدارة اللغة (Language)
- توفير methods للـ HTTP requests (GET, POST, PUT, DELETE)

**المميزات:**
```dart
class ApiClient {
  final String baseUrl;
  String? _token;  // Token في الذاكرة
  String _language = 'en';
  
  // إضافة Token
  void setToken(String? token) {
    _token = token;
  }
  
  // إضافة اللغة
  void setLanguage(String language) {
    _language = language;
  }
  
  // جلب Headers مع Token تلقائياً
  Future<Map<String, String>> _getHeaders() async {
    // يحاول جلب Token من:
    // 1. _token (في الذاكرة)
    // 2. TokenStorage (من SharedPreferences)
    
    String? token = _token ?? await TokenStorage.getToken();
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}
```

**الاستخدام:**
```dart
final apiClient = di<ApiClient>();

// GET request
final response = await apiClient.get(
  ApiConstants.bookingsEndpoint,
  queryParams: {'page': '1', 'pageSize': '20'},
);

// POST request
final response = await apiClient.post(
  ApiConstants.bookingsEndpoint,
  {'guestName': 'Ahmed', 'phoneNumber': '+971501234567'},
);

// PUT request
final response = await apiClient.put(
  ApiConstants.bookingByIdEndpoint(1),
  {'statusBook': 'ACCEPTED'},
);

// DELETE request
await apiClient.delete(ApiConstants.bookingByIdEndpoint(1));
```

### 2.2 ApiClientMethods (تنفيذ HTTP Methods)

**الموقع:** `lib/core/network/api_client_methods.dart`

**الوظيفة:**
- تنفيذ HTTP requests الفعلية
- معالجة Timeouts
- Logging للـ Debug
- معالجة CORS errors

**المميزات:**
```dart
class ApiClientMethods {
  final String baseUrl;
  final Future<Map<String, String>> Function() getHeaders;
  
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    // 1. بناء URI مع query parameters
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    
    // 2. جلب Headers (مع Token)
    final headers = await getHeaders();
    
    // 3. إرسال Request مع Timeout (30 ثانية)
    final response = await http.get(uri, headers: headers).timeout(
      const Duration(seconds: 30),
    );
    
    // 4. معالجة Response
    return ApiResponseHandler.handleResponse(response);
  }
}
```

**Error Handling:**
- `http.ClientException`: CORS issues (Flutter Web)
- `TimeoutException`: Request timeout
- `ApiException`: API errors (401, 404, 500, etc.)

### 2.3 ApiConstants (الثوابت)

**الموقع:** `lib/core/network/api_constants.dart`

**الوظيفة:**
- تعريف Base URL
- تعريف جميع الـ Endpoints
- تعريف Headers constants

**Base URL:**
```dart
static String get baseUrl => kIsWeb 
    ? 'http://127.0.0.1:8080'  // للويب (لتجنب CORS)
    : 'http://localhost:8080'; // للموبايل/ديسكتوب
```

**Endpoints Examples:**
```dart
// Auth
static const String loginEndpoint = '/api/auth/login';
static const String checkTokenEndpoint = '/api/auth/check-token';

// Bookings
static const String bookingsEndpoint = '/api/bookings';
static String bookingByIdEndpoint(int id) => '/api/bookings/$id';
static String bookingStatusEndpoint(int id) => '/api/bookings/$id/status';

// Options
static const String locationsAllEndpoint = '/api/locations/all';
static const String agentsAllEndpoint = '/api/agents/all';
static const String driversAllEndpoint = '/api/drivers/all';
static const String hotelsAllEndpoint = '/api/hotels/all';
```

### 2.4 ApiResponseHandler (معالج الاستجابات)

**الموقع:** `lib/core/network/api_response_handler.dart`

**الوظيفة:**
- معالجة HTTP responses
- تحويل JSON إلى Map
- معالجة 401 Unauthorized (تسجيل خروج تلقائي)
- معالجة الأخطاء

**Response Handling:**
```dart
static Map<String, dynamic> handleResponse(http.Response response) {
  // 401 Unauthorized → تسجيل خروج تلقائي
  if (response.statusCode == 401) {
    _handleUnauthorized();
    throw ApiException(message: 'errors.not_logged_in', statusCode: 401);
  }
  
  // 200-299 → Success
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  
  // Other errors → Throw ApiException
  throw ApiException.fromStatusCode(response.statusCode);
}
```

**401 Handling:**
```dart
static void _handleUnauthorized() {
  // 1. حذف Token من Storage
  TokenStorage.deleteToken();
  
  // 2. إظهار رسالة خطأ
  AppSnackbar.showTranslated(
    context: navigatorContext,
    translationKey: 'errors.not_logged_in',
    type: SnackbarType.error,
  );
  
  // 3. إعادة توجيه إلى Login
  navigatorContext.go(AppRouter.login);
}
```

### 2.5 ApiException (استثناءات API)

**الموقع:** `lib/core/network/api_exception.dart`

**الوظيفة:**
- تمثيل أخطاء API
- رسائل خطأ مترجمة
- Status codes

**الاستخدام:**
```dart
class ApiException implements Exception {
  final String message;  // رسالة مترجمة
  final String? error;   // تفاصيل الخطأ
  final int statusCode;  // HTTP status code
  
  // Factory للـ Status Codes الشائعة
  factory ApiException.fromStatusCode(int statusCode, String? message) {
    switch (statusCode) {
      case 400: return ApiException(message: 'errors.bad_request', statusCode: 400);
      case 401: return ApiException(message: 'errors.unauthorized', statusCode: 401);
      case 404: return ApiException(message: 'errors.not_found', statusCode: 404);
      case 500: return ApiException(message: 'errors.internal_server_error', statusCode: 500);
    }
  }
}
```

---

## 3. Data Layer (طبقة البيانات)

### 3.1 Remote Data Sources

**الموقع:** `lib/features/{feature}/data/datasources/`

**الوظيفة:**
- تنفيذ API calls
- تحويل JSON إلى Models
- معالجة الأخطاء

**مثال: BookingRemoteDataSource**
```dart
class BookingRemoteDataSource {
  final ApiClient apiClient;
  
  Future<PaginatedResponse<BookingModel>> getBookings({
    int? employeeId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (employeeId != null) 'employeeId': employeeId.toString(),
      };
      
      final response = await apiClient.get(
        ApiConstants.bookingsEndpoint,
        queryParams: queryParams,
      );
      
      return PaginatedResponse.fromJson(
        response,
        (json) => BookingModel.fromJson(json as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;  // إعادة رمي ApiException
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
```

### 3.2 Models

**الموقع:** `lib/features/{feature}/data/models/`

**الوظيفة:**
- تمثيل البيانات
- JSON Serialization/Deserialization
- Business Logic (حسابات، تحويلات)

**مثال: BookingModel**
```dart
class BookingModel {
  final int id;
  final String guestName;
  final String? phoneNumber;
  final int agentName;  // agentId
  final int? locationId;
  final List<BookingServiceModel> services;
  final double finalPrice;
  
  // من JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingFactory.fromJson(json);
  }
  
  // إلى JSON
  Map<String, dynamic> toJson() {
    return BookingJsonHelper.toJson(this);
  }
}
```

### 3.3 Repositories

**الموقع:** `lib/features/{feature}/data/repositories/`

**الوظيفة:**
- الجسر بين Domain و Data layers
- معالجة Business Logic
- إدارة Token Storage

**مثال: LoginRepositoryImpl**
```dart
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  
  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      
      if (response.success && response.data != null) {
        // حفظ Token
        await TokenStorage.saveToken(response.data!.token);
        
        // تحديث Token في ApiClient فوراً
        di.di<ApiClient>().setToken(response.data!.token);
        
        // حفظ Permissions
        if (response.data!.employee.permissions != null) {
          await TokenStorage.savePermissions(
            response.data!.employee.permissions!,
          );
        }
        
        return UserModel.fromEmployeeData(response.data!.employee);
      }
    } on ApiException {
      rethrow;
    }
  }
}
```

---

## 4. Authentication Flow (تدفق المصادقة)

### 4.1 Login Flow

```
1. User enters email/password
   ↓
2. LoginCubit validates input
   ↓
3. LoginUseCase calls LoginRepository
   ↓
4. LoginRepository calls LoginRemoteDataSource
   ↓
5. ApiClient sends POST /api/auth/login
   ↓
6. Server returns {accessToken, employee}
   ↓
7. TokenStorage.saveToken(token)
   ↓
8. ApiClient.setToken(token)  ← مهم جداً!
   ↓
9. Navigate to Home
```

### 4.2 Token Management

**Token Storage:**
```dart
// حفظ Token
await TokenStorage.saveToken(token);

// جلب Token
final token = await TokenStorage.getToken();

// حذف Token (عند Logout أو 401)
await TokenStorage.deleteToken();
```

**Token في ApiClient:**
```dart
// بعد Login مباشرة
di.di<ApiClient>().setToken(token);

// في كل Request، ApiClient يجلب Token تلقائياً:
Future<Map<String, String>> _getHeaders() async {
  String? token = _token ?? await TokenStorage.getToken();
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}
```

### 4.3 Auto-Logout على 401

عند استلام `401 Unauthorized`:
1. حذف Token من Storage
2. إظهار رسالة خطأ
3. إعادة توجيه إلى Login

---

## 5. Error Handling (معالجة الأخطاء)

### 5.1 Error Types

**1. ApiException (API Errors)**
```dart
try {
  final booking = await createBooking(bookingModel);
} on ApiException catch (e) {
  // 400, 401, 404, 500, etc.
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
}
```

**2. ClientException (Network Errors)**
```dart
// CORS issues في Flutter Web
// Connection errors
catch (e) {
  if (e is http.ClientException) {
    print('Network Error: ${e.message}');
  }
}
```

**3. TimeoutException**
```dart
// Request timeout (30 seconds)
catch (e) {
  if (e is TimeoutException) {
    print('Request timeout');
  }
}
```

### 5.2 Error Handling في Cubits

```dart
class BookingCubit extends Cubit<BookingState> {
  Future<void> loadBookings() async {
    emit(BookingLoading());
    try {
      final bookings = await remoteDataSource.getBookings();
      emit(BookingSuccess(bookings));
    } on ApiException catch (e) {
      emit(BookingError(e.message));
    } catch (e) {
      emit(BookingError('errors.unexpected_error'.tr()));
    }
  }
}
```

### 5.3 Error Display في UI

```dart
BlocListener<BookingCubit, BookingState>(
  listener: (context, state) {
    if (state is BookingError) {
      AppSnackbar.showTranslated(
        context: context,
        translationKey: state.message,
        type: SnackbarType.error,
      );
    }
  },
  child: ...,
)
```

---

## 6. Response Format (تنسيق الاستجابة)

### 6.1 Success Response

```json
{
  "success": true,
  "message": "Bookings retrieved successfully",
  "data": [
    {
      "id": 1,
      "guestName": "Ahmed",
      "phoneNumber": "+971501234567",
      ...
    }
  ],
  "pagination": {
    "currentPage": 1,
    "pageSize": 20,
    "totalItems": 100,
    "totalPages": 5,
    "hasNext": true,
    "hasPrevious": false
  }
}
```

### 6.2 Error Response

```json
{
  "success": false,
  "message": "Error message here",
  "error": "Detailed error information"
}
```

### 6.3 Paginated Response

```dart
class PaginatedResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final PaginationInfo pagination;
  
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
```

---

## 7. Common Issues & Solutions (المشاكل الشائعة والحلول)

### 7.1 مشكلة: 401 Unauthorized على جميع الـ Requests

**السبب:**
- Token غير موجود في Headers
- Token منتهي الصلاحية
- Token غير صحيح

**الحل:**
```dart
// 1. تأكد من حفظ Token بعد Login
await TokenStorage.saveToken(token);
di.di<ApiClient>().setToken(token);

// 2. تأكد من أن ApiClient يجلب Token تلقائياً
Future<Map<String, String>> _getHeaders() async {
  String? token = _token ?? await TokenStorage.getToken();
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

// 3. تحقق من الـ Logs
// يجب أن ترى: [ApiClient] ✅ Authorization header: Bearer {token}
```

### 7.2 مشكلة: CORS Error في Flutter Web

**السبب:**
- Server لا يسمح بـ CORS requests
- Authorization header غير مسموح في preflight requests

**الحل:**

**Server-side (مطلوب):**
```kotlin
// في Ktor أو Spring Boot
cors {
    allowCredentials = true
    allowNonSimpleContentTypes = true
    anyHost()
    allowHeader(HttpHeaders.Authorization)
    allowHeader(HttpHeaders.ContentType)
    allowMethod(HttpMethod.Options)
    allowMethod(HttpMethod.Get)
    allowMethod(HttpMethod.Post)
    allowMethod(HttpMethod.Put)
    allowMethod(HttpMethod.Delete)
}
```

**Client-side (Development فقط):**
```bash
# تشغيل Chrome بدون web security
chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security
```

### 7.3 مشكلة: Data لا تظهر بعد API Call

**السبب:**
- Response format غير متوقع
- JSON parsing error
- Data في مكان مختلف في Response

**الحل:**
```dart
// 1. تحقق من Response Structure
if (kDebugMode) {
  print('[ApiClient] Response Body: ${response.body}');
}

// 2. تحقق من Data Location
final response = await apiClient.get(endpoint);
final data = response['data'];  // قد يكون List أو Map

// 3. استخدم try-catch للـ Parsing
try {
  final data = response['data'] as List<dynamic>;
  return data.map((json) => Model.fromJson(json)).toList();
} catch (e) {
  print('Parsing error: $e');
  return [];
}
```

### 7.4 مشكلة: Token لا يُحفظ بعد Login

**السبب:**
- TokenStorage.saveToken() لم يتم استدعاؤه
- SharedPreferences error

**الحل:**
```dart
// في LoginRepositoryImpl
@override
Future<UserEntity> login(String email, String password) async {
  final response = await remoteDataSource.login(email, password);
  
  if (response.success && response.data != null) {
    // 1. حفظ Token
    await TokenStorage.saveToken(response.data!.token);
    
    // 2. تحديث ApiClient فوراً
    di.di<ApiClient>().setToken(response.data!.token);
    
    // 3. التحقق
    final savedToken = await TokenStorage.getToken();
    print('Token saved: ${savedToken != null}');
    
    return UserModel.fromEmployeeData(response.data!.employee);
  }
}
```

### 7.5 مشكلة: OPTIONS Request يحصل على 401

**السبب:**
- Server يطلب Authentication حتى في Preflight requests
- CORS configuration غير صحيح

**الحل:**

**Server-side:**
```kotlin
// يجب أن يكون OPTIONS request بدون Authentication
if (call.request.httpMethod == HttpMethod.Options.name) {
    call.respond(HttpStatusCode.OK)
    return
}

// ثم التحقق من Authentication للـ requests الأخرى
if (call.request.httpMethod != HttpMethod.Options.name) {
    val token = call.request.header(HttpHeaders.Authorization)
    if (token == null) {
        call.respond(HttpStatusCode.Unauthorized)
        return
    }
}
```

### 7.6 مشكلة: Timeout على Requests الكبيرة

**السبب:**
- Timeout قصير (30 ثانية)
- Network بطيء
- Server بطيء في الرد

**الحل:**
```dart
// زيادة Timeout في ApiClientMethods
final response = await http.get(uri, headers: headers).timeout(
  const Duration(seconds: 60),  // زيادة من 30 إلى 60
);
```

### 7.7 مشكلة: Pagination لا يعمل

**السبب:**
- Query parameters غير صحيحة
- Response structure مختلف

**الحل:**
```dart
// تأكد من Query Parameters
final queryParams = {
  'page': page.toString(),      // String, ليس int
  'pageSize': pageSize.toString(), // String, ليس int
};

// تحقق من Response Structure
final response = await apiClient.get(
  ApiConstants.bookingsEndpoint,
  queryParams: queryParams,
);

// Response يجب أن يحتوي على 'pagination'
if (response.containsKey('pagination')) {
  return PaginatedResponse.fromJson(response, fromJsonT);
}
```

---

## 8. Debugging Tips (نصائح للتصحيح)

### 8.1 Enable Debug Logging

```dart
// في ApiClientMethods
if (kDebugMode) {
  print('[ApiClient] GET Request:');
  print('[ApiClient] Full URL: $uri');
  print('[ApiClient] Headers: $headers');
  print('[ApiClient] Response Status: ${response.statusCode}');
  print('[ApiClient] Response Body: ${response.body}');
}
```

### 8.2 Check Token Status

```dart
// في أي مكان
final token = await TokenStorage.getToken();
print('Token exists: ${token != null}');
print('Token length: ${token?.length ?? 0}');
print('Token preview: ${token?.substring(0, token.length > 20 ? 20 : token.length)}...');
```

### 8.3 Verify API Client Configuration

```dart
final apiClient = di<ApiClient>();
print('Base URL: ${apiClient.baseUrl}');
print('Language: ${apiClient._language}');
```

---

## 9. Best Practices (أفضل الممارسات)

### 9.1 Always Use Dependency Injection

```dart
// ✅ صحيح
final apiClient = di<ApiClient>();
final dataSource = BookingRemoteDataSource(apiClient);

// ❌ خطأ
final apiClient = ApiClient();
```

### 9.2 Handle Errors Properly

```dart
// ✅ صحيح
try {
  final result = await dataSource.getData();
} on ApiException catch (e) {
  emit(ErrorState(e.message));
} catch (e) {
  emit(ErrorState('errors.unexpected_error'.tr()));
}

// ❌ خطأ
try {
  final result = await dataSource.getData();
} catch (e) {
  print(e);  // لا تفعل هذا!
}
```

### 9.3 Always Update Token After Login

```dart
// ✅ صحيح
await TokenStorage.saveToken(token);
di.di<ApiClient>().setToken(token);

// ❌ خطأ
await TokenStorage.saveToken(token);
// نسيان تحديث ApiClient
```

### 9.4 Use Translation Keys

```dart
// ✅ صحيح
throw ApiException(message: 'errors.not_found'.tr(), statusCode: 404);

// ❌ خطأ
throw ApiException(message: 'Not found', statusCode: 404);
```

---

## 10. Summary (الخلاصة)

### الـ Flow الكامل:

```
1. User Action (UI)
   ↓
2. Cubit (State Management)
   ↓
3. UseCase (Business Logic)
   ↓
4. Repository (Data Access)
   ↓
5. RemoteDataSource (API Call)
   ↓
6. ApiClient (HTTP Request)
   ↓
7. ApiClientMethods (Actual HTTP)
   ↓
8. Server (Backend)
   ↓
9. ApiResponseHandler (Response Processing)
   ↓
10. Model (JSON → Object)
   ↓
11. Repository (Return Entity)
   ↓
12. UseCase (Return Entity)
   ↓
13. Cubit (Emit State)
   ↓
14. UI (Update)
```

### النقاط المهمة:

1. **Token Management**: دائماً احفظ Token بعد Login وحدّث ApiClient
2. **Error Handling**: استخدم ApiException وترجم الرسائل
3. **CORS**: تأكد من إعداد Server بشكل صحيح
4. **Debugging**: استخدم Logging للتحقق من Requests/Responses
5. **Clean Architecture**: احترم الفصل بين الطبقات

---

تم إنشاء الدليل. استخدمه كمرجع لفهم وحل مشاكل Backend Integration في المشروع.


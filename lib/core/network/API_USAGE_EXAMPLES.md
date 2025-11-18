# API Usage Examples

## استخدام الـ Endpoints

جميع الـ endpoints متاحة الآن في `ApiConstants` ويمكن استخدامها مع `ApiClient`.

### مثال 1: جلب جميع الموظفين

```dart
final apiClient = di.di<ApiClient>();

// GET /api/employees?page=1&pageSize=20
final response = await apiClient.get(
  ApiConstants.employeesEndpoint,
  queryParams: {
    'page': '1',
    'pageSize': '20',
  },
);
```

### مثال 2: جلب موظف محدد

```dart
// GET /api/employees/1
final response = await apiClient.get(
  ApiConstants.employeeByIdEndpoint(1),
);
```

### مثال 3: إنشاء موظف جديد

```dart
// POST /api/employees
final response = await apiClient.post(
  ApiConstants.employeesEndpoint,
  {
    'name': 'Ahmed Ali',
    'email': 'ahmed@example.com',
    'position': 'Manager',
    // ... other fields
  },
);
```

### مثال 4: تحديث موظف

```dart
// PUT /api/employees/1
final response = await apiClient.put(
  ApiConstants.employeeByIdEndpoint(1),
  {
    'name': 'Ahmed Ali Updated',
    // ... other fields to update
  },
);
```

### مثال 5: حذف موظف

```dart
// DELETE /api/employees/1
final response = await apiClient.delete(
  ApiConstants.employeeByIdEndpoint(1),
);
```

### مثال 6: جلب جميع الخدمات بدون pagination

```dart
// GET /api/services/all
final response = await apiClient.get(
  ApiConstants.servicesAllEndpoint,
);
```

### مثال 7: جلب خدمات وكيل محدد

```dart
// GET /api/agents/1/services?locationId=4
final response = await apiClient.get(
  ApiConstants.agentServicesEndpoint(1),
  queryParams: {
    'locationId': '4',
  },
);
```

### مثال 8: جلب خدمات وكيل حسب الموقع

```dart
// GET /api/service-agents/by-agent-location?agentId=1&locationId=4
final response = await apiClient.get(
  ApiConstants.serviceAgentsByAgentLocationEndpoint,
  queryParams: {
    'agentId': '1',
    'locationId': '4',
    'includeGlobal': 'true',
  },
);
```

### مثال 9: تحديث حالة الحجز

```dart
// PUT /api/bookings/1/status
final response = await apiClient.put(
  ApiConstants.bookingStatusEndpoint(1),
  {
    'status': 'ACCEPTED',
  },
);
```

### مثال 10: جلب الإحصائيات

```dart
// GET /api/statistics?startDate=1234567890&endDate=1234567890
final response = await apiClient.get(
  ApiConstants.statisticsEndpoint,
  queryParams: {
    'startDate': '1234567890',
    'endDate': '1234567890',
  },
);
```

### مثال 11: جلب أوقات الاستلام

```dart
// GET /api/pickup-times
final response = await apiClient.get(
  ApiConstants.pickupTimesEndpoint,
);
```

### مثال 12: جلب بيانات المعسكر

```dart
// GET /api/camp
final response = await apiClient.get(
  ApiConstants.campEndpoint,
);
```

## ملاحظات مهمة

1. جميع الـ endpoints (عدا `/api/auth/login`) تحتاج إلى token
2. الـ token يتم إضافته تلقائياً من `ApiClient`
3. اللغة يتم إرسالها تلقائياً في header `Accept-Language`
4. استخدم `queryParams` للـ query parameters
5. استخدم `Map<String, dynamic>` للـ request body


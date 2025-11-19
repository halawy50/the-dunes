# حل مشكلة CORS في الـ Server

## المشكلة
الـ server يرجع `405 Method Not Allowed` لطلبات `OPTIONS`:
```
405 Method Not Allowed: OPTIONS - /api/auth/login
```

## السبب
المتصفح يرسل طلب `OPTIONS` (preflight request) قبل `POST` للتحقق من CORS. الـ server لا يدعم `OPTIONS`.

## الحل

### إذا كان الـ Server بـ Kotlin/Exposed (Ktor):

```kotlin
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.routing.*

fun Application.configureCORS() {
    install(CORS) {
        allowMethod(HttpMethod.Options)
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowHeader(HttpHeaders.ContentType)
        allowHeader(HttpHeaders.Authorization)
        allowHeader("Accept-Language")
        allowCredentials = true
        anyHost() // في Production، استخدم origin محدد
    }
}
```

### إذا كان الـ Server بـ Spring Boot:

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins("*")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("Content-Type", "Authorization", "Accept-Language")
            .allowCredentials(false);
    }
}
```

### إذا كان الـ Server بـ Node.js/Express:

```javascript
const cors = require('cors');
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept-Language']
}));
```

## الخطوات

1. **أضف CORS configuration في الـ server**
2. **تأكد من دعم `OPTIONS` method**
3. **أضف CORS headers في الـ response:**
   - `Access-Control-Allow-Origin: *`
   - `Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS`
   - `Access-Control-Allow-Headers: Content-Type, Authorization, Accept-Language`

## ملاحظات

- في **Development**: يمكن استخدام `*` للـ origin
- في **Production**: استخدم origin محدد للأمان
- بعد إضافة CORS، يجب أن يعمل Flutter Web بدون مشاكل

## التحقق

بعد إضافة CORS، يجب أن ترى في الـ logs:
```
200 OK: OPTIONS - /api/auth/login
200 OK: POST - /api/auth/login
```

بدلاً من:
```
405 Method Not Allowed: OPTIONS - /api/auth/login
```


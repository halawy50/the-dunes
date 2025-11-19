# حل مشكلة CORS في Flutter Web

## المشكلة
Flutter Web لا يمكنه الوصول إلى API بسبب CORS policy في المتصفح.

## الحلول المتاحة

### الحل 1: إضافة CORS في الـ Server (الأفضل للإنتاج)

#### Spring Boot:
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins("*")
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                    .allowedHeaders("*")
                    .allowCredentials(false);
            }
        };
    }
}
```

#### Node.js/Express:
```javascript
const cors = require('cors');
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept-Language']
}));
```

### الحل 2: استخدام Chrome مع CORS Disabled (للـ Development فقط)

1. أغلق جميع نوافذ Chrome
2. افتح PowerShell أو CMD
3. شغل الأمر:
```bash
start chrome.exe --user-data-dir="C:/temp/chrome_dev" --disable-web-security --disable-features=VizDisplayCompositor
```
4. في نافذة Chrome الجديدة، افتح: `http://localhost:8080`
5. شغل Flutter:
```bash
flutter run -d chrome --web-port=8080
```

### الحل 3: استخدام Proxy في Flutter Web

إنشاء ملف `web/proxy.dart` (يتطلب إعدادات إضافية)

### الحل 4: استخدام Postman/Thunder Client للاختبار

استخدم Postman أو Thunder Client للاختبار بدلاً من Flutter Web أثناء التطوير.

## ملاحظات مهمة

- **الحل 1** هو الأفضل للإنتاج
- **الحل 2** للـ Development فقط
- **لا تستخدم** `--disable-web-security` في Production

## الخطوات التالية

1. إذا كان لديك وصول للـ server → استخدم **الحل 1**
2. إذا كنت تطور فقط → استخدم **الحل 2**
3. إذا لم يكن لديك وصول للـ server → تواصل مع فريق الـ Backend لإضافة CORS


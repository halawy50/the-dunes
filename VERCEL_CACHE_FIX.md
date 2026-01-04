# حل مشكلة عدم ظهور التحديثات على Vercel

## المشكلة
عند رفع تحديثات جديدة على Vercel، لا تظهر التحديثات بسبب التخزين المؤقت (Cache).

## الحل المطبق

### 1. تحديث ملف `vercel.json`
تم إضافة إعدادات لمنع تخزين الملفات الرئيسية مؤقتاً:
- `index.html` - لا يتم تخزينه مؤقتاً
- `main.dart.js` - لا يتم تخزينه مؤقتاً
- `flutter_bootstrap.js` - لا يتم تخزينه مؤقتاً
- `flutter_service_worker.js` - لا يتم تخزينه مؤقتاً

### 2. تحديث سكربت النشر
تم تحديث `deploy-vercel.bat` ليقوم بـ:
- تنظيف البناء السابق قبل البناء الجديد
- نسخ `vercel.json` إلى مجلد `build/web`

## خطوات النشر الصحيحة

### الطريقة 1: استخدام السكربت (موصى بها)

```bash
.\deploy-vercel.bat
```

### الطريقة 2: النشر اليدوي

```bash
# 1. تنظيف البناء السابق
rmdir /s /q build\web

# 2. بناء المشروع
flutter build web --release

# 3. نسخ vercel.json
copy vercel.json build\web\vercel.json

# 4. الانتقال إلى مجلد البناء
cd build\web

# 5. النشر على Vercel
vercel --prod
```

## حل مشاكل التخزين المؤقت في المتصفح

بعد النشر، إذا لم تظهر التحديثات:

### في Chrome/Edge:
1. اضغط `Ctrl + Shift + Delete`
2. اختر "Cached images and files"
3. اضغط "Clear data"
4. أو اضغط `Ctrl + F5` لإعادة تحميل الصفحة بدون Cache

### في Firefox:
1. اضغط `Ctrl + Shift + Delete`
2. اختر "Cache"
3. اضغط "Clear Now"
4. أو اضغط `Ctrl + F5`

### في Safari:
1. اضغط `Cmd + Option + E` لمسح Cache
2. أو اضغط `Cmd + Shift + R` لإعادة تحميل بدون Cache

## التحقق من النشر

1. بعد النشر، انتظر دقيقة أو دقيقتين
2. افتح الموقع في نافذة متصفح خاصة (Incognito/Private)
3. أو استخدم أداة مثل [WebPageTest](https://www.webpagetest.org/) للتحقق

## ملاحظات مهمة

- ✅ الملفات الثابتة (assets, canvaskit) يتم تخزينها مؤقتاً لمدة طويلة (لتحسين الأداء)
- ✅ الملفات الرئيسية (HTML, JS) لا يتم تخزينها مؤقتاً (لضمان ظهور التحديثات)
- ✅ بعد كل تحديث، يجب عمل Build جديد قبل النشر

## إذا استمرت المشكلة

1. تحقق من أن `vercel.json` موجود في `build/web`
2. تأكد من أنك تقوم بـ Build جديد قبل كل نشر
3. جرب حذف المشروع من Vercel وإعادة رفعه
4. تحقق من إعدادات Cache في Vercel Dashboard


# إصلاح مشكلة تحميل الصور والملفات الثابتة في Vercel

## المشكلة

عند رفع Flutter Web على Vercel، تظهر أخطاء:
- `Unable to load asset: "AssetManifest.bin.json"`
- `Unable to load asset: "assets/icons/notification.svg"`

## السبب

`vercel.json` يعيد توجيه جميع الطلبات إلى `index.html`، بما في ذلك الملفات الثابتة. يجب استثناء الملفات الثابتة من rewrites.

## الحل

تم تحديث `vercel.json` لاستثناء الملفات الثابتة:
- `assets/` - جميع الملفات الثابتة
- `canvaskit/` - مكتبة CanvasKit
- `icons/` - أيقونات التطبيق
- `favicon.png` - أيقونة الموقع
- `manifest.json` - ملف Manifest
- `flutter.js`, `flutter_bootstrap.js`, `main.dart.js` - ملفات Flutter
- `flutter_service_worker.js` - Service Worker
- `version.json` - ملف الإصدار

## الخطوات

1. **إعادة بناء المشروع:**
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **رفع `build/web` إلى Vercel:**
   ```bash
   cd build/web
   npx vercel --prod
   ```

## ملاحظات

- تأكد من رفع محتويات `build/web` وليس المجلد نفسه
- جميع الملفات موجودة في المكان الصحيح: `build/web/assets/`
- `vercel.json` يستثني الملفات الثابتة من rewrites


# رفع المشروع على Vercel

## ملاحظة مهمة

Vercel لا يدعم Flutter SDK بشكل مباشر. لذلك، نحتاج إلى بناء المشروع محلياً أو استخدام GitHub Actions لبناء المشروع ثم رفع الملفات المبنية.

## الطريقة 1: البناء المحلي ثم الرفع

### الخطوات:

1. **بناء المشروع كـ Flutter Web:**
   ```bash
   flutter build web --release
   ```

2. **تثبيت Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

3. **تسجيل الدخول إلى Vercel:**
   ```bash
   vercel login
   ```

4. **رفع المشروع:**
   ```bash
   vercel --prod
   ```

5. **أو رفع مجلد build/web مباشرة:**
   ```bash
   cd build/web
   vercel --prod
   ```

## الطريقة 2: استخدام GitHub Actions (موصى بها)

تم إنشاء ملف `.github/workflows/deploy-vercel.yml` لبناء المشروع تلقائياً ورفعه على Vercel.

### الخطوات:

1. **رفع المشروع على GitHub**

2. **إضافة Vercel إلى GitHub:**
   - اذهب إلى [Vercel Dashboard](https://vercel.com/dashboard)
   - اضغط على "Add New Project"
   - اختر مستودع GitHub الخاص بك
   - في إعدادات البناء:
     - **Build Command:** `flutter build web --release`
     - **Output Directory:** `build/web`
     - **Install Command:** `flutter pub get`
   - اضغط على "Deploy"

3. **إضافة Environment Variables (إن وجدت):**
   - في إعدادات المشروع على Vercel
   - اذهب إلى Settings > Environment Variables
   - أضف أي متغيرات بيئة مطلوبة

## الطريقة 3: استخدام Vercel CLI مع Docker (متقدم)

إذا كنت تريد استخدام Vercel Build Command مباشرة، يمكنك استخدام Docker:

1. **إنشاء Dockerfile:**
   ```dockerfile
   FROM cirrusci/flutter:stable
   WORKDIR /app
   COPY . .
   RUN flutter pub get
   RUN flutter build web --release
   ```

2. **تحديث vercel.json:**
   ```json
   {
     "buildCommand": "docker build -t flutter-app . && docker run flutter-app",
     "outputDirectory": "build/web"
   }
   ```

## ملاحظات مهمة:

1. **CORS:** تأكد من أن API الخاص بك يدعم CORS للطلبات من Vercel domain
2. **Base URL:** قد تحتاج إلى تعديل `base href` في `web/index.html` إذا كان المشروع في subdirectory
3. **Environment Variables:** أضف أي متغيرات بيئة مطلوبة في Vercel Dashboard

## استكشاف الأخطاء:

- إذا فشل البناء، تحقق من أن Flutter SDK مثبت في بيئة البناء
- تأكد من أن جميع dependencies مثبتة (`flutter pub get`)
- تحقق من أن `build/web` يحتوي على الملفات المبنية

## بدائل Vercel:

إذا واجهت مشاكل مع Vercel، يمكنك استخدام:
- **Firebase Hosting:** يدعم Flutter Web بشكل ممتاز
- **Netlify:** يدعم Flutter Web أيضاً
- **GitHub Pages:** مجاني وسهل الاستخدام



# تعليمات رفع المشروع على Vercel

## ⚠️ ملاحظة مهمة

Vercel **لا يدعم Flutter SDK** بشكل افتراضي. لذلك يجب بناء المشروع محلياً أولاً.

## الطريقة الموصى بها: البناء المحلي ثم الرفع

### الخطوة 1: بناء المشروع محلياً

```bash
# تأكد من أن Flutter مثبت
flutter --version

# الحصول على dependencies
flutter pub get

# بناء المشروع كـ Web
flutter build web --release
```

### الخطوة 2: رفع مجلد build/web فقط

#### الطريقة أ: عبر Vercel CLI

```bash
# تثبيت Vercel CLI (إذا لم يكن مثبتاً)
npm install -g vercel

# الانتقال إلى مجلد build/web
cd build/web

# رفع المشروع
vercel --prod
```

#### الطريقة ب: عبر Vercel Dashboard

1. اذهب إلى [vercel.com](https://vercel.com)
2. اضغط على "Add New Project"
3. اختر "Upload" أو "Import Git Repository"
4. إذا اخترت Upload:
   - ارفع محتويات مجلد `build/web` (ليس المجلد نفسه)
   - أو استخدم Drag & Drop
5. إذا اخترت Git Repository:
   - اختر مستودع GitHub
   - **مهم:** في إعدادات البناء:
     - **Build Command:** اتركه فارغاً أو `echo "Already built"`
     - **Output Directory:** اتركه فارغاً (لأنك سترفع build/web مباشرة)
     - **Install Command:** اتركه فارغاً

### الخطوة 3: إعداد Vercel للمستقبل

إذا كنت تريد رفع المشروع من Git مباشرة:

1. **استخدم GitHub Actions** (الطريقة الأفضل):
   - الملف `.github/workflows/deploy-vercel.yml` جاهز
   - يحتاج إلى إضافة Secrets في GitHub:
     - `VERCEL_TOKEN`
     - `VERCEL_ORG_ID`
     - `VERCEL_PROJECT_ID`

2. **أو استخدم Vercel مع Docker**:
   - استخدم `Dockerfile` الموجود في المشروع
   - في Vercel Dashboard:
     - Build Command: `docker build -t flutter-app . && docker run --rm -v $(pwd)/build/web:/output flutter-app`
     - Output Directory: `build/web`

## الطريقة البديلة: استخدام Netlify أو Firebase Hosting

إذا واجهت مشاكل مع Vercel، يمكنك استخدام:

### Netlify (سهل جداً)

```bash
# بناء المشروع
flutter build web --release

# تثبيت Netlify CLI
npm install -g netlify-cli

# رفع المشروع
cd build/web
netlify deploy --prod
```

### Firebase Hosting (موصى به لـ Flutter)

```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تسجيل الدخول
firebase login

# تهيئة المشروع
firebase init hosting

# بناء المشروع
flutter build web --release

# رفع المشروع
firebase deploy --only hosting
```

## استكشاف الأخطاء

### خطأ: "flutter: command not found"
- **الحل:** بناء المشروع محلياً أولاً، ثم رفع `build/web` فقط

### خطأ: "Build failed"
- **الحل:** تأكد من أن `flutter build web --release` يعمل محلياً بدون أخطاء

### خطأ: "404 Not Found" عند التنقل
- **الحل:** تأكد من أن `vercel.json` يحتوي على `rewrites` صحيحة

## نصائح

1. **CORS:** تأكد من أن API يدعم CORS من Vercel domain
2. **Environment Variables:** أضف أي متغيرات بيئة مطلوبة في Vercel Dashboard
3. **Base URL:** قد تحتاج إلى تعديل `base href` في `web/index.html` إذا كان المشروع في subdirectory


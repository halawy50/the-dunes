# إعداد Vercel للمشروع

## الخطوات السريعة:

### 1. إنشاء حساب Vercel
- اذهب إلى [vercel.com](https://vercel.com)
- سجل الدخول باستخدام GitHub

### 2. إعداد المشروع على Vercel

#### الطريقة الأولى: عبر Vercel Dashboard

1. اضغط على "Add New Project"
2. اختر مستودع GitHub الخاص بك
3. في إعدادات البناء:
   - **Framework Preset:** Other
   - **Build Command:** `flutter build web --release`
   - **Output Directory:** `build/web`
   - **Install Command:** `flutter pub get`
   - **Root Directory:** `.` (أو اتركه فارغاً)
4. اضغط على "Deploy"

#### الطريقة الثانية: عبر Vercel CLI

```bash
# تثبيت Vercel CLI
npm install -g vercel

# تسجيل الدخول
vercel login

# ربط المشروع
vercel link

# رفع المشروع
vercel --prod
```

### 3. إعداد Environment Variables (إن وجدت)

في Vercel Dashboard:
- Settings > Environment Variables
- أضف المتغيرات المطلوبة (مثل API URLs، API Keys، إلخ)

### 4. إعداد GitHub Secrets (لـ GitHub Actions)

إذا كنت تستخدم GitHub Actions:
- اذهب إلى GitHub Repository > Settings > Secrets and variables > Actions
- أضف:
  - `VERCEL_TOKEN`: احصل عليه من [Vercel Settings > Tokens](https://vercel.com/account/tokens)
  - `VERCEL_ORG_ID`: من Vercel Dashboard > Settings > General
  - `VERCEL_PROJECT_ID`: من Vercel Dashboard > Settings > General

## ملاحظات:

1. **CORS:** تأكد من أن API يدعم CORS من Vercel domain
2. **Base URL:** قد تحتاج إلى تعديل `base href` في `web/index.html`
3. **Build Time:** البناء قد يستغرق وقتاً طويلاً لأن Flutter SDK كبير

## استكشاف الأخطاء:

### خطأ: "Flutter command not found"
- Vercel لا يدعم Flutter SDK بشكل افتراضي
- استخدم GitHub Actions للبناء ثم ارفع الملفات المبنية

### خطأ: "Build failed"
- تحقق من أن جميع dependencies موجودة في `pubspec.yaml`
- تأكد من أن `flutter pub get` يعمل بدون أخطاء

### خطأ: "404 Not Found"
- تأكد من أن `outputDirectory` مضبوط على `build/web`
- تحقق من أن `vercel.json` موجود وصحيح


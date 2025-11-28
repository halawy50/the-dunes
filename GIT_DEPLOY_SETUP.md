# إعداد الرفع التلقائي عبر Git

## 🎯 الهدف

عند الرفع (push) على Git، يتم بناء ورفع المشروع تلقائياً على Vercel.

## 📋 المتطلبات

1. حساب GitHub
2. حساب Vercel
3. المشروع موجود على GitHub

## 🚀 الخطوات

### الخطوة 1: رفع المشروع على GitHub

```bash
# إذا لم يكن المشروع على GitHub
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/the_dunes.git
git push -u origin main
```

### الخطوة 2: إعداد Vercel

#### الطريقة أ: عبر Vercel Dashboard (الأسهل)

1. اذهب إلى [vercel.com](https://vercel.com)
2. اضغط "Add New Project"
3. اختر "Import Git Repository"
4. اختر مستودع GitHub الخاص بك (`the_dunes`)
5. في إعدادات البناء:
   - **Framework Preset:** Other
   - **Build Command:** `flutter build web --release`
   - **Output Directory:** `build/web`
   - **Install Command:** `flutter pub get`
   - **Root Directory:** `.` (أو اتركه فارغاً)
6. اضغط "Deploy"

Vercel سيربط المشروع تلقائياً مع GitHub وسيقوم بالـ deploy عند كل push.

#### الطريقة ب: يدوياً (للمزيد من التحكم)

1. اذهب إلى [vercel.com/account/tokens](https://vercel.com/account/tokens)
2. أنشئ Token جديد وانسخه
3. اذهب إلى GitHub Repository > Settings > Secrets and variables > Actions
4. أضف Secrets التالية:
   - `VERCEL_TOKEN`: Token الذي أنشأته في Vercel
   - `VERCEL_ORG_ID`: من Vercel Dashboard > Settings > General
   - `VERCEL_PROJECT_ID`: من Vercel Dashboard > Settings > General

### الخطوة 3: ربط Vercel مع GitHub (إذا لم يتم تلقائياً)

1. في Vercel Dashboard > Project Settings > Git
2. اضغط "Connect Git Repository"
3. اختر GitHub واسم المستودع
4. اضغط "Connect"

## 🔄 سير العمل

بعد الإعداد:

1. **عند Push على `main` أو `master`:**
   - GitHub Actions يبدأ البناء تلقائياً
   - يتم بناء المشروع باستخدام Flutter
   - يتم رفع المشروع على Vercel
   - Vercel يقوم بالـ deploy تلقائياً

2. **عند Pull Request:**
   - يتم إنشاء Preview Deployment على Vercel
   - يمكنك مراجعة التغييرات قبل الدمج

## 📝 ملاحظات مهمة

### Vercel Git Integration (موصى به):

- **الأسهل:** ربط Vercel مباشرة مع GitHub
- **تلقائي:** Vercel يبني ويرفع تلقائياً عند كل push
- **لا يحتاج:** GitHub Actions أو Secrets

### GitHub Actions (للمزيد من التحكم):

- **مرونة أكبر:** تحكم كامل في عملية البناء
- **يتطلب:** إعداد Secrets في GitHub
- **أفضل:** للمشاريع المعقدة

## 🛠️ استكشاف الأخطاء

### خطأ: "Flutter command not found"
- **الحل:** Vercel لا يدعم Flutter SDK بشكل مباشر
- **الحل:** استخدم GitHub Actions للبناء (كما في `.github/workflows/deploy-vercel.yml`)

### خطأ: "Build failed"
- **الحل:** تحقق من أن `flutter build web --release` يعمل محلياً
- **الحل:** تحقق من أن جميع dependencies موجودة في `pubspec.yaml`

### خطأ: "Secrets not found"
- **الحل:** تأكد من إضافة جميع Secrets في GitHub Repository Settings

## ✅ التحقق من الإعداد

بعد الإعداد:

1. **ارفع تغيير بسيط على GitHub:**
   ```bash
   git add .
   git commit -m "Test deployment"
   git push origin main
   ```

2. **تحقق من GitHub Actions:**
   - اذهب إلى GitHub Repository > Actions
   - يجب أن ترى workflow يعمل

3. **تحقق من Vercel:**
   - اذهب إلى Vercel Dashboard
   - يجب أن ترى deployment جديد

## 🎉 النتيجة

الآن عند كل push على `main`:
- ✅ يتم بناء المشروع تلقائياً
- ✅ يتم رفع المشروع على Vercel تلقائياً
- ✅ الموقع محدث تلقائياً


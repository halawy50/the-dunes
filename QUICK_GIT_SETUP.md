# إعداد الرفع التلقائي السريع

## 🚀 الطريقة الأسهل: Vercel Git Integration

### الخطوات:

1. **ارفع المشروع على GitHub:**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **اربط Vercel مع GitHub:**
   - اذهب إلى [vercel.com](https://vercel.com)
   - اضغط "Add New Project"
   - اختر "Import Git Repository"
   - اختر مستودع GitHub الخاص بك
   - في إعدادات البناء:
     - **Build Command:** `flutter build web --release`
     - **Output Directory:** `build/web`
     - **Install Command:** `flutter pub get`
   - اضغط "Deploy"

3. **جاهز!** 🎉
   - عند كل push على `main`، Vercel سيبني ويرفع تلقائياً

## 🔧 الطريقة المتقدمة: GitHub Actions

إذا كنت تريد المزيد من التحكم:

1. **أضف Secrets في GitHub:**
   - اذهب إلى Repository > Settings > Secrets and variables > Actions
   - أضف:
     - `VERCEL_TOKEN` - من [vercel.com/account/tokens](https://vercel.com/account/tokens)
     - `VERCEL_ORG_ID` - من Vercel Dashboard > Settings > General
     - `VERCEL_PROJECT_ID` - من Vercel Dashboard > Settings > General

2. **ارفع الكود:**
   ```bash
   git add .
   git commit -m "Setup GitHub Actions"
   git push origin main
   ```

3. **GitHub Actions سيقوم بالباقي تلقائياً!**

## ✅ التحقق

بعد الإعداد، عند push على `main`:
- ✅ GitHub Actions يبدأ البناء (إذا استخدمت الطريقة المتقدمة)
- ✅ Vercel يستقبل التحديثات
- ✅ الموقع يتم تحديثه تلقائياً


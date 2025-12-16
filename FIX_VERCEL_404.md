# إصلاح خطأ 404 في Vercel

## المشكلة
Vercel يعرض خطأ 404 لأن:
- Vercel يحاول بناء المشروع من GitHub
- Flutter غير مدعوم في Vercel
- مجلد `build/web` غير موجود في بناء Vercel

## الحل: تعطيل البناء في Vercel

### الطريقة 1: تعطيل البناء من إعدادات Vercel (موصى بها)

1. اذهب إلى [Vercel Dashboard](https://vercel.com/dashboard)
2. اختر مشروعك
3. اذهب إلى **Settings** → **Git**
4. في قسم **"Ignored Build Step"**:
   - اضغط على **Edit**
   - أدخل: `echo "Skipping Vercel build - using GitHub Actions"`
   - أو: `exit 1` (لإيقاف البناء تماماً)
   - احفظ

5. اذهب إلى **Settings** → **General**
6. في قسم **Build & Development Settings**:
   - **Build Command:** اتركه فارغاً أو `echo "Build handled by GitHub Actions"`
   - **Output Directory:** اتركه فارغاً
   - **Install Command:** اتركه فارغاً
   - احفظ

### الطريقة 2: استخدام GitHub Actions فقط

1. في Vercel Dashboard → Settings → Git
2. **Disconnect** المستودع من Vercel
3. استخدم GitHub Actions فقط للنشر (الذي يعمل بالفعل)

### الطريقة 3: تحديث vercel.json

إذا كنت تريد أن يبني Vercel (لكن لن يعمل مع Flutter)، يمكنك إضافة:

```json
{
  "buildCommand": "echo 'Build handled by GitHub Actions'",
  "outputDirectory": ".",
  ...
}
```

**لكن الأفضل:** استخدم GitHub Actions فقط.

## ✅ الحل الموصى به

**استخدم GitHub Actions فقط للنشر:**

1. **تعطيل البناء في Vercel:**
   - Settings → Git → Ignored Build Step: `exit 1`

2. **أو إزالة الاتصال:**
   - Settings → Git → Disconnect Repository
   - استخدم GitHub Actions فقط

3. **تأكد من إضافة GitHub Secrets:**
   - `VERCEL_TOKEN`
   - `VERCEL_ORG_ID`
   - `VERCEL_PROJECT_ID`

4. **GitHub Actions سيقوم بـ:**
   - بناء Flutter
   - نشر الملفات إلى Vercel
   - كل شيء تلقائي!

## 🔍 التحقق

بعد التعديل:
1. ادفع تغييراً صغيراً إلى GitHub
2. تحقق من GitHub Actions (يجب أن يعمل)
3. تحقق من Vercel Dashboard (يجب أن يظهر نشر جديد)
4. افتح الموقع (يجب أن يعمل!)

## 📝 ملاحظات

- Vercel لا يدعم Flutter SDK
- GitHub Actions يبني Flutter ثم ينشر إلى Vercel
- هذا هو الحل الأفضل والأكثر موثوقية

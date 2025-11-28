# رفع المشروع على Vercel - خطوات سريعة

## الخطوة 1: تثبيت Vercel CLI

### على Windows (PowerShell):

```powershell
# تثبيت Node.js أولاً (إذا لم يكن مثبتاً)
# اذهب إلى https://nodejs.org/ وقم بتحميل وتثبيت Node.js

# تثبيت Vercel CLI
npm install -g vercel
```

### التحقق من التثبيت:

```powershell
vercel --version
```

## الخطوة 2: تسجيل الدخول إلى Vercel

```powershell
vercel login
```

سيُفتح المتصفح تلقائياً لتسجيل الدخول.

## الخطوة 3: رفع المشروع

### أنت بالفعل في المجلد الصحيح (`build/web`)

```powershell
# تأكد من أنك في المجلد الصحيح
pwd
# يجب أن يظهر: D:\the_dunes\build\web

# رفع المشروع
vercel --prod
```

### أو إذا كنت في المجلد الرئيسي:

```powershell
# من المجلد الرئيسي للمشروع
cd build\web
vercel --prod
```

## الخطوة 4: اتباع التعليمات

Vercel سيطرح عليك بعض الأسئلة:
1. **Set up and deploy?** → اضغط `Y`
2. **Which scope?** → اختر حسابك
3. **Link to existing project?** → اضغط `N` (للمرة الأولى)
4. **What's your project's name?** → اكتب اسم المشروع (مثلاً: `the-dunes`)
5. **In which directory is your code located?** → اضغط Enter (لأنك في المجلد الصحيح)

## ملاحظات مهمة:

- تأكد من أن `build/web` يحتوي على الملفات المبنية
- إذا لم تكن الملفات موجودة، قم ببناء المشروع أولاً:
  ```powershell
  cd D:\the_dunes
  flutter build web --release
  ```

## استكشاف الأخطاء:

### خطأ: "vercel: command not found"
- **الحل:** تأكد من تثبيت Node.js و Vercel CLI:
  ```powershell
  npm install -g vercel
  ```

### خطأ: "Cannot find path"
- **الحل:** تأكد من أنك في المجلد الصحيح:
  ```powershell
  cd D:\the_dunes\build\web
  ```


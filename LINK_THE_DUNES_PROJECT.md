# ربط المشروع بـ the-dunes.vercel.app

## المشكلة
آخر deployment كان منذ أسبوعين، والتحديثات الجديدة لا تظهر على `the-dunes.vercel.app` لأن المشروع مرتبط بمشروع "web" الجديد.

## الحل - اتبع الخطوات التالية:

### الخطوة 1: افتح PowerShell

### الخطوة 2: انتقل إلى مجلد build/web
```powershell
cd D:\the_dunes\build\web
```

### الخطوة 3: احذف مجلد .vercel القديم
```powershell
if (Test-Path .vercel) { Remove-Item -Recurse -Force .vercel }
```

### الخطوة 4: اربط المشروع
```powershell
npx vercel link
```

**عندما تظهر لك القائمة:**
1. ستظهر قائمة بالمشاريع المتاحة:
   - `web`
   - `the-dunes` ← **اختر هذا**
   - `rimal`

2. استخدم الأسهم ↑↓ للتنقل
3. اضغط Enter على `the-dunes`

### الخطوة 5: تحقق من الربط
```powershell
Get-Content .vercel\project.json
```

يجب أن ترى:
```json
{
  "projectId": "...",
  "orgId": "ahmedhalawy50-8127s-projects",
  "projectName": "the-dunes"
}
```

### الخطوة 6: انشر التحديثات
```powershell
npx vercel --prod --yes
```

## بعد النشر

بعد النشر بنجاح:
1. افتح **https://the-dunes.vercel.app**
2. اضغط `Ctrl + F5` لإزالة التخزين المؤقت
3. التحديثات ستظهر فوراً

## للمستقبل

بعد ربط المشروع مرة واحدة، لن تحتاج لربطه مرة أخرى. فقط:

```powershell
# من المجلد الرئيسي
cd D:\the_dunes
flutter build web --release
copy vercel.json build\web\vercel.json
cd build\web
npx vercel --prod --yes
```

أو استخدم السكربت:
```powershell
cd D:\the_dunes
.\deploy-vercel.bat
```


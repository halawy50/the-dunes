# حل مشكلة ربط المشروع بـ the-dunes.vercel.app

## المشكلة
عند النشر، يتم ربط المشروع بمشروع جديد باسم "web" بدلاً من المشروع الموجود "the-dunes".

## الحل السريع

### الخطوة 1: ربط المشروع يدوياً

افتح PowerShell واتبع الخطوات التالية:

```powershell
# 1. انتقل إلى مجلد build/web
cd D:\the_dunes\build\web

# 2. احذف مجلد .vercel القديم
if (Test-Path .vercel) { Remove-Item -Recurse -Force .vercel }

# 3. اربط المشروع (سيطلب منك اختيار المشروع)
npx vercel link
```

**عندما يظهر لك قائمة المشاريع:**
- استخدم الأسهم ↑↓ للتنقل
- اختر **"the-dunes"**
- اضغط Enter

### الخطوة 2: النشر

بعد الربط، انشر مباشرة:

```powershell
npx vercel --prod --yes
```

## التحقق من الربط

بعد الربط، تحقق من ملف `.vercel/project.json`:

```powershell
Get-Content .vercel\project.json
```

يجب أن يحتوي على:
```json
{
  "projectId": "...",
  "orgId": "ahmedhalawy50-8127s-projects",
  "projectName": "the-dunes"
}
```

## بعد النشر

بعد النشر بنجاح، افتح:
- **https://the-dunes.vercel.app**

التحديثات ستظهر فوراً على هذا الدومين.

## ملاحظة مهمة

بعد ربط المشروع مرة واحدة، لن تحتاج لربطه مرة أخرى. فقط قم بـ:
1. بناء المشروع: `flutter build web --release`
2. نسخ vercel.json: `copy vercel.json build\web\vercel.json`
3. النشر: `cd build\web && npx vercel --prod --yes`


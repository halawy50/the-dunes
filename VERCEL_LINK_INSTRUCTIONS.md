# ربط المشروع بـ the-dunes.vercel.app

## المشكلة
عند النشر، يتم ربط المشروع بمشروع جديد باسم "web" بدلاً من المشروع الموجود "the-dunes".

## الحل

### الطريقة 1: ربط يدوي (موصى بها)

1. **انتقل إلى مجلد build/web:**
   ```powershell
   cd D:\the_dunes\build\web
   ```

2. **احذف مجلد .vercel إذا كان موجوداً:**
   ```powershell
   if (Test-Path .vercel) { Remove-Item -Recurse -Force .vercel }
   ```

3. **اربط المشروع:**
   ```powershell
   npx vercel link
   ```
   
4. **عندما يطلب منك اختيار المشروع:**
   - اختر **"the-dunes"** من القائمة
   - اضغط Enter

5. **بعد الربط، انشر:**
   ```powershell
   npx vercel --prod --yes
   ```

### الطريقة 2: استخدام vercel link مع --yes (أسرع)

```powershell
cd D:\the_dunes\build\web
npx vercel link --yes
```

**ملاحظة:** هذه الطريقة قد تربط بأول مشروع في القائمة. تأكد من أن "the-dunes" هو أول مشروع.

### الطريقة 3: النشر مباشرة مع تحديد المشروع

```powershell
cd D:\the_dunes\build\web
npx vercel --prod --yes --scope ahmedhalawy50-8127s-projects
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
  "orgId": "ahmedhalawy50-8127s-projects"
}
```

## بعد النشر

بعد النشر بنجاح، افتح:
- **https://the-dunes.vercel.app**

التحديثات ستظهر فوراً على هذا الدومين.


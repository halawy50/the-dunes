# دليل التطوير والرفع

## 🛠️ التطوير المحلي (Development)

### تشغيل المشروع في وضع التطوير:

```bash
# تشغيل على Chrome
flutter run -d chrome

# أو تشغيل على منفذ محدد
flutter run -d chrome --web-port=8080
```

### التأكد من عمل Assets:

- المسار في `main.dart`: `assets/translations` ✅
- الملفات موجودة في: `assets/translations/` ✅
- في وضع التطوير، Flutter يخدم الملفات مباشرة من `assets/`

## 🚀 رفع المشروع على Vercel

### الطريقة 1: استخدام Script (موصى به)

#### على Windows:
```powershell
.\deploy.bat
```

#### على Linux/Mac:
```bash
chmod +x deploy.sh
./deploy.sh
```

### الطريقة 2: يدوياً

```bash
# 1. تنظيف المشروع
flutter clean

# 2. الحصول على dependencies
flutter pub get

# 3. بناء المشروع
flutter build web --release

# 4. رفع build/web
cd build/web
npx vercel --prod
```

### الطريقة 3: عبر Vercel Dashboard

1. اذهب إلى [vercel.com](https://vercel.com)
2. اضغط "Add New Project"
3. اختر "Upload"
4. اسحب محتويات مجلد `build/web` (ليس المجلد نفسه)
5. اضغط "Deploy"

## 📝 ملاحظات مهمة:

### للمطورين:

1. **في Development:**
   - المسار: `assets/translations` ✅
   - Flutter يخدم الملفات مباشرة من `assets/`

2. **في Production (build/web):**
   - المسار: `assets/translations` ✅
   - الملفات موجودة في: `build/web/assets/assets/translations/`
   - Flutter Web يضيف `assets/` تلقائياً

3. **vercel.json:**
   - يستثني الملفات الثابتة من rewrites ✅
   - يضمن تحميل الصور والملفات بشكل صحيح ✅

### استكشاف الأخطاء:

#### المشكلة: "Unable to load asset"
- **الحل:** تأكد من أن `flutter build web --release` يعمل بدون أخطاء
- تأكد من أن جميع الملفات موجودة في `build/web/assets/`

#### المشكلة: الصور لا تظهر
- **الحل:** تأكد من رفع محتويات `build/web` وليس المجلد نفسه
- تحقق من أن `vercel.json` موجود في `build/web/`

## 🔄 سير العمل الموصى به:

1. **التطوير:**
   ```bash
   flutter run -d chrome
   ```

2. **البناء للرفع:**
   ```bash
   .\deploy.bat  # أو deploy.sh
   ```

3. **الرفع:**
   ```bash
   cd build\web
   npx vercel --prod
   ```


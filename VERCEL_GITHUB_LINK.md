# ربط Vercel مع GitHub - حل المشكلة

## المشكلة
رسالة الخطأ: "To link a GitHub repository, you need to install the GitHub integration first"

## الحل

### الخطوة 1: تثبيت GitHub Integration في Vercel

1. **اذهب إلى Vercel Dashboard:**
   - افتح: [vercel.com/dashboard](https://vercel.com/dashboard)

2. **اذهب إلى Settings → Integrations:**
   - اضغط على **"Settings"** (أيقونة الترس في القائمة الجانبية)
   - اضغط على **"Integrations"** (من القائمة الفرعية)

3. **أضف GitHub Integration:**
   - ابحث عن **"GitHub"** في قائمة Integrations
   - اضغط على **"Add Integration"** أو **"Install"**
   - ستحتاج للموافقة على الصلاحيات

4. **اختر المستودعات:**
   - اختر المستودع **"the-dunes"** أو **"All repositories"**
   - اضغط **"Install"** أو **"Save"**

### الخطوة 2: ربط المشروع بمستودع GitHub

#### الطريقة 1: من Vercel Dashboard (موصى بها)

1. **اذهب إلى مشروع the-dunes:**
   - من Dashboard، اضغط على مشروع **"the-dunes"**

2. **اذهب إلى Settings → Git:**
   - اضغط **"Settings"** (في القائمة العلوية)
   - اضغط **"Git"** (من القائمة الجانبية)

3. **اربط المستودع:**
   - اضغط **"Connect Git Repository"** أو **"Edit"**
   - اختر **"GitHub"**
   - ابحث عن **"halawy50/the-dunes"**
   - اضغط **"Import"** أو **"Connect"**

#### الطريقة 2: إنشاء مشروع جديد من GitHub

1. **اذهب إلى Vercel Dashboard:**
   - اضغط **"Add New Project"** أو **"New Project"**

2. **اختر Import Git Repository:**
   - اضغط **"Import Git Repository"**
   - اختر **"GitHub"**
   - إذا لم يظهر GitHub، اضغط **"Configure GitHub App"** أو **"Install GitHub App"**

3. **اختر المستودع:**
   - ابحث عن **"halawy50/the-dunes"**
   - اضغط **"Import"**

4. **الإعدادات:**
   - **Framework Preset:** `Other` أو `Other (no framework)`
   - **Root Directory:** `.` (افتراضي)
   - **Build Command:** اتركه **فارغاً** (GitHub Actions سيقوم بالبناء)
   - **Output Directory:** `build/web`
   - **Install Command:** اتركه **فارغاً**

5. **اضغط "Deploy"**

### الخطوة 3: التحقق من الربط

بعد الربط:

1. **في Vercel:**
   - Settings → Git
   - يجب أن ترى معلومات المستودع المرتبط

2. **في GitHub:**
   - اذهب إلى المستودع
   - Settings → Webhooks
   - يجب أن ترى webhook من Vercel

## ملاحظات مهمة

### إذا لم يظهر GitHub في قائمة Integrations:

1. **تحقق من الصلاحيات:**
   - تأكد أن لديك صلاحيات كافية في Vercel
   - إذا كنت تستخدم Team/Organization، تأكد من الصلاحيات

2. **جرب من صفحة المستودع مباشرة:**
   - اذهب إلى GitHub: `https://github.com/halawy50/the-dunes`
   - اضغط **"Settings"** → **"Webhooks"**
   - يمكنك إضافة webhook يدوياً إذا لزم الأمر

### إذا كان المستودع Private:

- تأكد أن GitHub Integration لديه صلاحيات للمستودعات الخاصة
- في صفحة تثبيت GitHub App، اختر **"All repositories"** أو **"Only select repositories"**

### بديل: استخدام GitHub Actions فقط

إذا واجهت مشاكل في ربط Vercel مع GitHub، يمكنك استخدام GitHub Actions فقط:

1. **أضف Secrets في GitHub:**
   - اذهب إلى: `https://github.com/halawy50/the-dunes/settings/secrets/actions`
   - أضف: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`

2. **GitHub Actions سينشر تلقائياً:**
   - عند كل push على `main`
   - GitHub Actions سيبني وينشر على Vercel
   - لا حاجة لربط Vercel مع GitHub مباشرة

## الطريقة الموصى بها

**استخدم GitHub Actions** (الطريقة الأسهل والأكثر موثوقية):

1. ✅ أضف Secrets في GitHub
2. ✅ GitHub Actions workflow جاهز (`.github/workflows/deploy-vercel.yml`)
3. ✅ عند كل push، سيتم النشر تلقائياً
4. ✅ لا حاجة لربط Vercel مع GitHub

راجع ملف `GIT_DEPLOY_ARABIC.md` للتفاصيل الكاملة.


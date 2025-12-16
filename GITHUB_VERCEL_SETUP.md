# GitHub to Vercel Deployment Setup

This guide will help you set up automatic deployment from GitHub to Vercel for your Flutter web project.

## 🎯 Two Deployment Options

### Option 1: Vercel Native GitHub Integration (Recommended - Easier)

Vercel can automatically deploy when you push to GitHub, but since Vercel doesn't support Flutter natively, we'll use GitHub Actions to build and then Vercel to deploy.

### Option 2: GitHub Actions Only (More Control)

Use GitHub Actions to build Flutter and deploy directly to Vercel using the CLI.

---

## 🚀 Option 1: Vercel Native GitHub Integration

### Step 1: Push Your Code to GitHub

```bash
# If not already on GitHub
git init
git add .
git commit -m "Initial commit - Flutter web project"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/the_dunes.git
git push -u origin main
```

### Step 2: Connect Vercel to GitHub

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click **"Add New Project"**
3. Click **"Import Git Repository"**
4. Select your GitHub repository (`the_dunes`)
5. **Important Configuration:**
   - **Framework Preset:** `Other` or `Other (no framework)`
   - **Root Directory:** `.` (leave as default)
   - **Build Command:** Leave **EMPTY** (we'll use GitHub Actions)
   - **Output Directory:** `build/web`
   - **Install Command:** Leave **EMPTY**
6. Click **"Deploy"**

**Note:** Since Vercel can't build Flutter, the first deployment might fail. That's okay - we'll use GitHub Actions for building.

### Step 3: Configure GitHub Actions (Automatic Build)

The GitHub Actions workflow is already configured at `.github/workflows/deploy-vercel.yml`.

You need to add Vercel secrets to your GitHub repository:

1. **Get Vercel Credentials:**
   - Go to [vercel.com/account/tokens](https://vercel.com/account/tokens)
   - Create a new token (name it "GitHub Actions")
   - Copy the token

2. **Get Vercel Project IDs:**
   - Go to your project on Vercel Dashboard
   - Go to **Settings** → **General**
   - Copy:
     - **Project ID** (this is `VERCEL_PROJECT_ID`)
     - **Team ID** or **Organization ID** (this is `VERCEL_ORG_ID`)

3. **Add Secrets to GitHub:**
   - Go to your GitHub repository
   - Click **Settings** → **Secrets and variables** → **Actions**
   - Click **"New repository secret"**
   - Add these three secrets:
     - `VERCEL_TOKEN` - The token from step 1
     - `VERCEL_ORG_ID` - Your organization/team ID
     - `VERCEL_PROJECT_ID` - Your project ID

### Step 4: Test the Deployment

1. Make a small change to your code
2. Commit and push:
   ```bash
   git add .
   git commit -m "Test deployment"
   git push origin main
   ```
3. Check GitHub Actions:
   - Go to your repository on GitHub
   - Click **Actions** tab
   - You should see the workflow running
4. Check Vercel:
   - Go to Vercel Dashboard
   - You should see a new deployment

---

## 🔧 Option 2: GitHub Actions Only (Full Control)

This option uses GitHub Actions to both build and deploy.

### Setup Steps:

1. **Add Vercel Secrets to GitHub** (same as Option 1, Step 3)

2. **The workflow is already configured** at `.github/workflows/deploy-vercel.yml`

3. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Setup GitHub Actions deployment"
   git push origin main
   ```

4. **Monitor deployment:**
   - Check GitHub Actions tab for build status
   - Check Vercel Dashboard for deployment status

---

## 📋 Workflow Details

The GitHub Actions workflow (`.github/workflows/deploy-vercel.yml`) does the following:

1. ✅ Triggers on push to `main`, `master`, or `development` branches
2. ✅ Sets up Flutter SDK
3. ✅ Gets dependencies (`flutter pub get`)
4. ✅ Builds Flutter web (`flutter build web --release`)
5. ✅ Copies and configures `vercel.json`
6. ✅ Deploys to Vercel production

---

## 🔍 Troubleshooting

### Issue: "Vercel deployment skipped - secrets not configured"

**Solution:** Add the three required secrets to GitHub:
- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

### Issue: Build fails in GitHub Actions

**Solution:** 
- Check the Actions log for specific errors
- Ensure `pubspec.yaml` is valid
- Try running `flutter pub get` and `flutter build web --release` locally first

### Issue: Deployment fails on Vercel

**Solution:**
- Check that `vercel.json` is in `build/web` directory
- Verify the `outputDirectory` in `vercel.json` is set to `.`
- Check Vercel deployment logs

### Issue: 404 errors when navigating

**Solution:** 
- The `vercel.json` rewrites are configured correctly
- Make sure the file is deployed with the build

---

## 🔄 How It Works

1. **You push code to GitHub** → Triggers GitHub Actions
2. **GitHub Actions builds Flutter** → Creates `build/web` folder
3. **GitHub Actions deploys to Vercel** → Uses Vercel CLI
4. **Vercel serves your app** → Your Flutter web app is live!

---

## ✅ Verification Checklist

- [ ] Code is pushed to GitHub
- [ ] Vercel project is created and connected to GitHub
- [ ] Vercel secrets are added to GitHub repository
- [ ] GitHub Actions workflow runs successfully
- [ ] Deployment appears in Vercel Dashboard
- [ ] Website is accessible at Vercel URL

---

## 📝 Next Steps After Setup

1. **Set Environment Variables** (if needed):
   - Vercel Dashboard → Your Project → Settings → Environment Variables
   - Add API endpoints, keys, etc.

2. **Configure Custom Domain**:
   - Vercel Dashboard → Your Project → Settings → Domains
   - Add your custom domain

3. **Set up Branch Deployments**:
   - The workflow is configured for `main`, `master`, and `development`
   - Each branch will deploy to a preview URL

---

## 🎉 Success!

Once set up, every push to your main branch will:
- ✅ Automatically build your Flutter web app
- ✅ Deploy to Vercel
- ✅ Make your app live in seconds!

No manual steps needed! 🚀

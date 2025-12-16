# Quick Setup: Deploy Flutter to Vercel from GitHub

## 🚀 Quick Start (5 minutes)

### Step 1: Push to GitHub
```bash
git add .
git commit -m "Setup Vercel deployment"
git push origin main
```

### Step 2: Get Vercel Credentials

1. **Create Vercel Token:**
   - Go to: https://vercel.com/account/tokens
   - Click "Create Token"
   - Name it "GitHub Actions"
   - Copy the token

2. **Get Project IDs:**
   - Go to: https://vercel.com/dashboard
   - Click "Add New Project"
   - Import your GitHub repository
   - Go to Project Settings → General
   - Copy:
     - **Project ID** → This is `VERCEL_PROJECT_ID`
     - **Team ID** → This is `VERCEL_ORG_ID`

### Step 3: Add Secrets to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add these 3 secrets:

   | Secret Name | Value |
   |------------|-------|
   | `VERCEL_TOKEN` | Token from Step 2.1 |
   | `VERCEL_ORG_ID` | Team ID from Step 2.2 |
   | `VERCEL_PROJECT_ID` | Project ID from Step 2.2 |

### Step 4: Test Deployment

```bash
git commit --allow-empty -m "Test deployment"
git push origin main
```

Then check:
- **GitHub Actions:** Repository → Actions tab
- **Vercel:** Dashboard → Your project → Deployments

---

## ✅ That's It!

Every time you push to `main`, `master`, or `development`:
- ✅ Flutter builds automatically
- ✅ Deploys to Vercel
- ✅ Your app goes live!

---

## 📚 Full Documentation

See `GITHUB_VERCEL_SETUP.md` for detailed instructions and troubleshooting.

# 🔐 Manual OIDC Setup for GitHub Actions

## Step 1: Create OIDC Provider in AWS Console

1. Go to **IAM Console** → **Identity providers**
2. Click **Add provider**
3. Select **OpenID Connect**
4. Fill in:
   - **Provider URL**: `https://token.actions.githubusercontent.com`
   - Click **Get thumbprint**
   - **Audience**: `sts.amazonaws.com`
5. Click **Add provider**

---

## Step 2: Create IAM Role

1. Go to **IAM Console** → **Roles**
2. Click **Create role**
3. Select **Web identity**
4. Choose:
   - **Identity provider**: `token.actions.githubusercontent.com`
   - **Audience**: `sts.amazonaws.com`
5. Click **Next**
6. Add condition (click **Add condition**):
   - **Condition key**: `token.actions.githubusercontent.com:sub`
   - **Operator**: `StringLike`
   - **Value**: `repo:YOUR_USERNAME/YOUR_REPO_NAME:*`
   
   Example: `repo:maheshpilla/AWS-Services-Terraform:*`

7. Click **Next**
8. **Skip policy selection** (we'll add custom policy)
9. Click **Next**
10. Role name: `github-actions-terraform-role`
11. Click **Create role**

---

## Step 3: Attach Custom Policy

1. Go to **IAM** → **Policies** → **Create policy**
2. Click **JSON** tab
3. Copy and paste from `github-actions-policy.json`
4. Click **Next**
5. Policy name: `GitHubActionsTerraformPolicy`
6. Click **Create policy**
7. Go back to **Roles** → `github-actions-terraform-role`
8. Click **Add permissions** → **Attach policies**
9. Search and select: `GitHubActionsTerraformPolicy`
10. Click **Add permissions**

---

## Step 4: Copy Role ARN

1. Go to **IAM** → **Roles**
2. Click on `github-actions-terraform-role`
3. Copy the **ARN** (looks like: `arn:aws:iam::123456789012:role/github-actions-terraform-role`)

---

## Step 5: Add to GitHub Secrets

1. Go to your GitHub repo
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add:
   - **Name**: `AWS_ROLE_ARN`
   - **Value**: `arn:aws:iam::YOUR_ACCOUNT_ID:role/github-actions-terraform-role`
5. Click **Add secret**

---

## Step 6: Keep These Secrets

Keep these existing secrets:
- ✅ `DB_PASSWORD`
- ✅ `ALARM_EMAIL`

Remove these (no longer needed):
- ❌ `AWS_ACCESS_KEY_ID`
- ❌ `AWS_SECRET_ACCESS_KEY`

---

## ✅ Test

```bash
git add .
git commit -m "Setup OIDC"
git push origin dev
```

Check **Actions** tab - should work! 🎉

---

## 📋 Trust Policy (For Reference)

If manually editing the role trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_USERNAME/YOUR_REPO:*"
        }
      }
    }
  ]
}
```

Replace:
- `YOUR_ACCOUNT_ID` with your AWS account ID
- `YOUR_USERNAME/YOUR_REPO` with your GitHub username/repo name

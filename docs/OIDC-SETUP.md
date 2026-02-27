# 🔐 GitHub OIDC Setup Guide

## What is OIDC?

OIDC (OpenID Connect) allows GitHub Actions to authenticate with AWS without storing long-lived access keys. More secure!

---

## 🚀 Setup Steps

### Step 1: Update oidc.tf with Your Repository

Edit `oidc.tf` and replace:
```hcl
"token.actions.githubusercontent.com:sub" = "repo:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME:*"
```

With your actual repository:
```hcl
"token.actions.githubusercontent.com:sub" = "repo:maheshpilla/AWS-Services-Terraform:*"
```

### Step 2: Deploy OIDC Infrastructure

```bash
# Initialize and apply OIDC configuration
terraform init
terraform apply -target=aws_iam_openid_connect_provider.github -target=aws_iam_role.github_actions

# Copy the role ARN from output
terraform output github_actions_role_arn
```

### Step 3: Add Role ARN to GitHub Secrets

1. Go to: `GitHub Repo → Settings → Secrets and variables → Actions`
2. Click: `New repository secret`
3. Name: `AWS_ROLE_ARN`
4. Value: `arn:aws:iam::YOUR_ACCOUNT_ID:role/github-actions-terraform-role`
5. Click: `Add secret`

### Step 4: Remove Old Secrets (Optional)

You can now delete:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Keep:
- `DB_PASSWORD`
- `ALARM_EMAIL`

---

## ✅ Verification

```bash
# Test the workflow
git add .
git commit -m "Setup OIDC authentication"
git push origin dev
```

Check GitHub Actions tab - should authenticate successfully!

---

## 🔧 Manual AWS Setup (Alternative)

If you prefer AWS CLI:

```bash
# 1. Create OIDC provider
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

# 2. Create trust policy file
cat > trust-policy.json <<EOF
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
EOF

# 3. Create IAM role
aws iam create-role \
  --role-name github-actions-terraform-role \
  --assume-role-policy-document file://trust-policy.json

# 4. Attach admin policy
aws iam attach-role-policy \
  --role-name github-actions-terraform-role \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# 5. Get role ARN
aws iam get-role --role-name github-actions-terraform-role --query 'Role.Arn'
```

---

## 📋 What Changed

### Before (Access Keys):
```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1
```

### After (OIDC):
```yaml
permissions:
  id-token: write
  contents: read

- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: us-east-1
```

---

## 🎯 Benefits

✅ No long-lived credentials in GitHub
✅ Automatic credential rotation
✅ Better security posture
✅ Audit trail in AWS CloudTrail
✅ Temporary credentials only

---

## 🔍 Troubleshooting

**Error: "Not authorized to perform sts:AssumeRoleWithWebIdentity"**
- Check repository name in trust policy matches exactly
- Verify OIDC provider exists in AWS
- Ensure role ARN is correct in GitHub secret

**Error: "Token audience validation failed"**
- Verify `client_id_list` includes `sts.amazonaws.com`

**Error: "No permissions to perform action"**
- Check IAM role has necessary policies attached

---

## 📊 Quick Reference

| Item | Value |
|------|-------|
| OIDC Provider URL | `https://token.actions.githubusercontent.com` |
| Audience | `sts.amazonaws.com` |
| Thumbprint | `6938fd4d98bab03faadb97b34396831e3780aea1` |
| Role Name | `github-actions-terraform-role` |
| GitHub Secret | `AWS_ROLE_ARN` |

---

**Setup Time**: ~5 minutes
**Security**: ⭐⭐⭐⭐⭐

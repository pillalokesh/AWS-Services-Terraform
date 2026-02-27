# 🚀 Simple Workflow Usage

## How to Use

### 1. Go to GitHub Actions
- Click **Actions** tab
- Select **Terraform Workflow**
- Click **Run workflow** button

### 2. Select Options
- **Action**: Choose `plan`, `apply`, or `destroy`
- **Environment**: Choose `dev`, `staging`, or `prod`
- Click **Run workflow**

---

## 📋 Actions Explained

### **Plan** 
Shows what will be created/changed without making changes
```
Action: plan
Environment: dev
```

### **Apply**
Creates/updates all infrastructure
```
Action: apply
Environment: dev
```

### **Destroy**
Removes all infrastructure
```
Action: destroy
Environment: dev
```

---

## 🎯 Typical Workflow

1. **First time:** Run `plan` to see what will be created
2. **Deploy:** Run `apply` to create infrastructure
3. **Cleanup:** Run `destroy` when done

---

## ⚡ Quick Start

1. Add GitHub Secrets:
   - `AWS_ROLE_ARN`
   - `DB_PASSWORD`
   - `ALARM_EMAIL`

2. Run workflow:
   - Action: `plan`
   - Environment: `dev`

3. If plan looks good:
   - Action: `apply`
   - Environment: `dev`

**Done!** 🎉

# 🔧 Scripts

Helper scripts for Terraform operations.

## 📜 Available Scripts

### **deploy.sh / deploy.ps1**
Quick deployment script
```bash
# Linux/Mac
./scripts/deploy.sh dev

# Windows
.\scripts\deploy.ps1 -Environment dev
```

### **destroy.sh**
Safely destroy infrastructure
```bash
./scripts/destroy.sh dev
```

### **validate.sh**
Validate Terraform configuration
```bash
./scripts/validate.sh
```

---

## 🚀 Usage

**Linux/Mac:**
```bash
chmod +x scripts/*.sh
./scripts/deploy.sh dev
```

**Windows:**
```powershell
.\scripts\deploy.ps1 -Environment dev
```

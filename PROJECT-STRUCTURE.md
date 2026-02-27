# 📁 Project Structure

```
AWS-Services-Terraform/
│
├── 📂 .github/workflows/          # CI/CD GitHub Actions
│   └── deploy.yml
│
├── 📂 modules/                    # Terraform Modules
│   ├── vpc/
│   ├── security-group/
│   ├── s3/
│   ├── iam/
│   ├── ec2/
│   ├── cloudwatch/
│   ├── autoscaling/
│   ├── alb/
│   ├── cloudfront/
│   ├── route53/
│   ├── rds/
│   └── lambda/
│
├── 📂 environments/               # Environment Configurations
│   ├── terraform.tfvars          # Default values
│   ├── dev.tfvars                # Development
│   ├── staging.tfvars            # Staging
│   └── prod.tfvars               # Production
│
├── 📂 assets/                     # Static Files
│   ├── index.html                # Website content
│   ├── lambda_function.py        # Lambda code
│   └── github-actions-policy.json # IAM policy
│
├── 📂 docs/                       # Documentation
│   ├── README.md                 # Docs index
│   ├── BACKEND-SETUP.md
│   ├── OIDC-MANUAL-SETUP.md
│   ├── GITHUB-ACTIONS-GUIDE.md
│   ├── DEPLOYMENT.md
│   └── ... (all guides)
│
├── 📄 main.tf                     # Main Terraform config
├── 📄 variables.tf                # Input variables
├── 📄 outputs.tf                  # Output values
├── 📄 backend.tf                  # S3 backend config
├── 📄 README.md                   # Project readme
└── 📄 .gitignore                  # Git ignore rules
```

---

## 🎯 Clean & Professional

✅ Root has only essential Terraform files  
✅ All docs organized in `/docs`  
✅ All environments in `/environments`  
✅ All static files in `/assets`  
✅ Easy to navigate and maintain

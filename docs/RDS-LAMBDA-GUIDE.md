# RDS and Lambda Integration Guide

## 🎉 New Services Added!

Your infrastructure now includes:
- ✅ **RDS (Relational Database Service)** - MySQL/PostgreSQL database
- ✅ **Lambda Functions** - Serverless compute

---

## 🗄️ RDS (Database) Module

### **What It Does**
- Creates MySQL or PostgreSQL database
- Multi-AZ deployment for high availability
- Automatic backups
- Secure in private subnet
- Only accessible from EC2 instances

### **Configuration (terraform.tfvars)**
```hcl
db_name              = "myappdb"
db_username          = "admin"
db_password          = "ChangeMe123!"  # CHANGE THIS!
db_engine            = "mysql"         # or "postgres"
db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"   # ~$15/month
db_allocated_storage = 20              # GB
db_multi_az          = false           # true for production
```

### **Features**
- **Private Access**: Only EC2 can connect
- **Security Group**: Automatic firewall rules
- **Subnet Group**: Spans multiple AZs
- **Backups**: Automatic daily backups
- **Encryption**: At rest and in transit

### **Connection from EC2**
```bash
# MySQL
mysql -h <rds_endpoint> -u admin -p myappdb

# PostgreSQL
psql -h <rds_endpoint> -U admin -d myappdb
```

### **Cost**
- db.t3.micro: ~$15/month
- db.t3.small: ~$30/month
- Storage: $0.115/GB/month

---

## ⚡ Lambda Function Module

### **What It Does**
- Runs code without servers
- Triggered by events (S3, API Gateway, etc.)
- Scales automatically
- Pay only for execution time
- Can access RDS and S3

### **Configuration (terraform.tfvars)**
```hcl
lambda_function_name = "my-lambda-function"
lambda_runtime       = "python3.11"     # or nodejs20.x, java17, etc.
lambda_handler       = "lambda_function.lambda_handler"
lambda_timeout       = 30               # seconds
lambda_memory_size   = 128              # MB
```

### **Sample Function (lambda_function.py)**
```python
import json

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'event': event
        })
    }
```

### **Environment Variables**
Lambda automatically gets:
- `DB_ENDPOINT`: RDS database endpoint
- `DB_NAME`: Database name
- `BUCKET_NAME`: S3 bucket name

### **Cost**
- First 1M requests/month: FREE
- After: $0.20 per 1M requests
- Compute: $0.0000166667 per GB-second
- **Typical cost**: $0-5/month

---

## 🔄 How They Work Together

### **Architecture**
```
User Request
    ↓
API Gateway (optional)
    ↓
Lambda Function
    ↓
├─→ RDS Database (read/write data)
└─→ S3 Bucket (store files)
```

### **Use Cases**

#### **1. API Backend**
```
API Gateway → Lambda → RDS
- Lambda processes API requests
- Reads/writes to RDS
- Returns JSON response
```

#### **2. S3 Event Processing**
```
S3 Upload → Lambda → RDS
- User uploads file to S3
- Lambda triggered automatically
- Processes file and saves to RDS
```

#### **3. Scheduled Tasks**
```
CloudWatch Event → Lambda → RDS
- Lambda runs on schedule (cron)
- Performs database cleanup
- Generates reports
```

---

## 📊 Complete Infrastructure Now

```
┌─────────────────────────────────────────────────────────┐
│                    Internet                              │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
    CloudFront              Load Balancer
         │                       │
         ▼                       ▼
    S3 Bucket              EC2 Instances
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                    ▼           ▼           ▼
              Lambda ──→ RDS Database ←── EC2
                    │
                    └──→ S3 Bucket
```

---

## 🚀 Deployment Steps

### **1. Update terraform.tfvars**
```hcl
# Change database password!
db_password = "YourSecurePassword123!"

# Customize database name
db_name = "myapp"

# Customize Lambda function
lambda_function_name = "my-api-function"
```

### **2. Deploy**
```bash
terraform init
terraform plan
terraform apply
```

### **3. Get Outputs**
```bash
terraform output rds_endpoint
terraform output lambda_function_name
```

---

## 🔐 Security Best Practices

### **Database Security**
1. ✅ **Strong Password**: Use complex password
2. ✅ **Private Subnet**: Not publicly accessible
3. ✅ **Security Groups**: Only EC2/Lambda can connect
4. ✅ **Encryption**: Enable at rest encryption
5. ✅ **Backups**: Automatic daily backups

### **Lambda Security**
1. ✅ **IAM Roles**: Least privilege permissions
2. ✅ **VPC**: Runs in private subnet
3. ✅ **Environment Variables**: For configuration
4. ✅ **Secrets Manager**: For sensitive data (optional)

---

## 💡 Example Use Cases

### **1. Blog Application**
- **EC2**: Runs web server
- **RDS**: Stores blog posts, users
- **S3**: Stores images
- **Lambda**: Resizes uploaded images
- **CloudFront**: Serves static content

### **2. E-commerce Site**
- **EC2**: Application server
- **RDS**: Products, orders, customers
- **S3**: Product images
- **Lambda**: Process payments, send emails
- **ALB**: Load balancing

### **3. Data Processing**
- **S3**: Upload CSV files
- **Lambda**: Process files automatically
- **RDS**: Store processed data
- **CloudWatch**: Monitor processing

---

## 📝 Lambda Function Examples

### **Example 1: Connect to RDS**
```python
import pymysql
import os

def lambda_handler(event, context):
    # Get environment variables
    db_endpoint = os.environ['DB_ENDPOINT']
    db_name = os.environ['DB_NAME']
    
    # Connect to RDS
    connection = pymysql.connect(
        host=db_endpoint.split(':')[0],
        user='admin',
        password='your-password',
        database=db_name
    )
    
    # Query database
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM users LIMIT 10")
        results = cursor.fetchall()
    
    connection.close()
    
    return {
        'statusCode': 200,
        'body': str(results)
    }
```

### **Example 2: Process S3 Upload**
```python
import boto3
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Get S3 event details
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Download file
    s3.download_file(bucket, key, '/tmp/file.txt')
    
    # Process file
    with open('/tmp/file.txt', 'r') as f:
        content = f.read()
        # Process content...
    
    return {
        'statusCode': 200,
        'body': 'File processed successfully'
    }
```

---

## 💰 Cost Breakdown (Updated)

### **Monthly Costs**
| Service | Configuration | Cost |
|---------|--------------|------|
| EC2 | 1x t3.micro | $7.50 |
| ALB | Standard | $16.00 |
| S3 | 10GB | $0.50 |
| CloudFront | 100GB transfer | $1.00 |
| **RDS** | **db.t3.micro** | **$15.00** |
| **Lambda** | **1M requests** | **$0.20** |
| CloudWatch | Basic | $0.50 |
| Route 53 | 1 zone | $0.50 |
| **Total** | | **~$41/month** |

### **Cost Optimization**
- Use RDS only when needed
- Lambda is very cheap (pay per use)
- Stop RDS during development
- Use Aurora Serverless for variable workloads

---

## 🔧 Troubleshooting

### **RDS Connection Issues**
```bash
# Check security group allows EC2
# Check RDS is in same VPC
# Verify credentials
# Check RDS endpoint is correct
```

### **Lambda Timeout**
```hcl
# Increase timeout in terraform.tfvars
lambda_timeout = 60  # seconds
```

### **Lambda Can't Connect to RDS**
```bash
# Ensure Lambda is in VPC
# Check security group allows Lambda
# Verify subnet has NAT gateway (for internet access)
```

---

## 📚 Next Steps

1. **Customize Lambda Function**: Edit lambda_function.py
2. **Add More Functions**: Create multiple Lambda functions
3. **Set Up API Gateway**: Expose Lambda via HTTP API
4. **Enable RDS Backups**: Set backup retention
5. **Add Monitoring**: CloudWatch dashboards
6. **Implement CI/CD**: Automate deployments

---

## ✅ Deployment Checklist

- [ ] Change db_password in terraform.tfvars
- [ ] Customize database name
- [ ] Update Lambda function code
- [ ] Run terraform init
- [ ] Run terraform plan
- [ ] Run terraform apply
- [ ] Test RDS connection from EC2
- [ ] Test Lambda function
- [ ] Set up monitoring
- [ ] Configure backups

---

**Your infrastructure now has database and serverless capabilities!** 🎉

**Total Services**: 12 AWS services fully integrated!

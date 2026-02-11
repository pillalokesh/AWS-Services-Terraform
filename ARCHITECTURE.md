# Architecture Documentation

## 🏗️ Complete Infrastructure Architecture

This document explains the architecture, data flow, and design decisions.

---

## 📐 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         INTERNET                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │     Route 53 (DNS)   │
              │  www.example.com     │
              └──────────┬───────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
         ▼                               ▼
┌─────────────────┐           ┌──────────────────┐
│   CloudFront    │           │  Load Balancer   │
│   (CDN/HTTPS)   │           │      (ALB)       │
└────────┬────────┘           └────────┬─────────┘
         │                              │
         ▼                              ▼
┌─────────────────┐           ┌──────────────────┐
│   S3 Bucket     │           │  EC2 Instances   │
│ (Static Files)  │           │  (Auto Scaling)  │
└─────────────────┘           └────────┬─────────┘
                                       │
                              ┌────────┴────────┐
                              │                 │
                              ▼                 ▼
                      ┌──────────────┐  ┌──────────────┐
                      │  CloudWatch  │  │  IAM Role    │
                      │  (Monitor)   │  │  (S3 Access) │
                      └──────────────┘  └──────────────┘
```

---

## 🌐 Network Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                            │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Internet Gateway                               │ │
│  └───────────────────────┬────────────────────────────────────┘ │
│                          │                                       │
│  ┌───────────────────────┴────────────────────────────────────┐ │
│  │              Route Table (0.0.0.0/0 → IGW)                 │ │
│  └───────────────────────┬────────────────────────────────────┘ │
│                          │                                       │
│         ┌────────────────┴────────────────┐                     │
│         │                                 │                     │
│  ┌──────▼──────────┐            ┌────────▼────────┐            │
│  │  Public Subnet  │            │  Public Subnet  │            │
│  │  10.0.1.0/24    │            │  10.0.2.0/24    │            │
│  │  us-east-1a     │            │  us-east-1b     │            │
│  │                 │            │                 │            │
│  │  ┌───────────┐  │            │  ┌───────────┐  │            │
│  │  │ EC2       │  │            │  │ EC2       │  │            │
│  │  │ Instance  │  │            │  │ Instance  │  │            │
│  │  └───────────┘  │            │  └───────────┘  │            │
│  │                 │            │                 │            │
│  │  ┌───────────┐  │            │                 │            │
│  │  │   ALB     │◄─┼────────────┼─────────────────┤            │
│  │  │ Target    │  │            │                 │            │
│  │  └───────────┘  │            │                 │            │
│  └─────────────────┘            └─────────────────┘            │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │           Security Group (Firewall)                       │  │
│  │           - Port 22 (SSH)                                 │  │
│  │           - Port 80 (HTTP)                                │  │
│  │           - All Outbound                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Diagrams

### **Static Website Flow (S3 + CloudFront)**

```
User Browser
    │
    │ 1. Request: www.example.com
    ▼
Route 53
    │
    │ 2. DNS Resolution → CloudFront domain
    ▼
CloudFront Edge Location (Nearest to User)
    │
    │ 3. Check cache
    │
    ├─ Cache HIT ──────────┐
    │                      │
    │ Cache MISS           │
    │                      │
    ▼                      │
S3 Bucket                  │
    │                      │
    │ 4. Fetch index.html  │
    │                      │
    ▼                      │
CloudFront                 │
    │                      │
    │ 5. Cache content     │
    │                      │
    ▼                      ▼
User Browser ◄─────────────┘
    │
    │ 6. Display website
    ▼
```

### **Application Traffic Flow (ALB + EC2)**

```
User Browser
    │
    │ 1. HTTP Request
    ▼
Application Load Balancer
    │
    │ 2. Health Check
    │    - Check EC2 instances
    │    - Remove unhealthy
    │
    ├─ Round Robin Algorithm
    │
    ▼
EC2 Instance (Healthy)
    │
    │ 3. Process Request
    │
    ├─ Need S3 Access?
    │
    ▼
IAM Role
    │
    │ 4. Temporary Credentials
    │
    ▼
S3 Bucket
    │
    │ 5. Read/Write Data
    │
    ▼
EC2 Instance
    │
    │ 6. Generate Response
    │
    ▼
Application Load Balancer
    │
    │ 7. Return Response
    │
    ▼
User Browser
```

### **Auto Scaling Flow**

```
EC2 Instances Running
    │
    │ 1. Send Metrics
    ▼
CloudWatch
    │
    │ 2. Evaluate Metrics
    │    - CPU > 80%?
    │    - Memory high?
    │
    ├─ Threshold Exceeded
    │
    ▼
Auto Scaling Group
    │
    │ 3. Trigger Scale Up Policy
    │
    ▼
Launch Template
    │
    │ 4. Launch New Instance
    │    - Same AMI
    │    - Same config
    │    - Same IAM role
    │
    ▼
New EC2 Instance
    │
    │ 5. Initialize
    │
    ▼
Application Load Balancer
    │
    │ 6. Health Check
    │    - Wait for healthy
    │
    ▼
Target Group
    │
    │ 7. Add to pool
    │
    ▼
Receive Traffic
```

### **Monitoring & Alerting Flow**

```
EC2 Instances
    │
    │ 1. Metrics (every 5 min)
    │    - CPU: 85%
    │    - Network: 100 MB/s
    │    - Disk: 50% used
    ▼
CloudWatch
    │
    │ 2. Check Alarms
    │    - CPU > 80%? YES
    │
    ▼
CloudWatch Alarm (ALARM state)
    │
    │ 3. Trigger Action
    │
    ▼
SNS Topic
    │
    │ 4. Publish Message
    │
    ├─────────┬─────────┬─────────┐
    │         │         │         │
    ▼         ▼         ▼         ▼
Email    SMS    Lambda   Webhook
    │
    │ 5. Notification
    │
    ▼
Administrator
    │
    │ 6. Take Action
    │    - Investigate
    │    - Scale manually
    │    - Fix issue
    ▼
```

---

## 🔐 Security Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Security Layers                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Layer 1: Network Security                                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  • VPC Isolation (10.0.0.0/16)                             │ │
│  │  • Security Groups (Stateful Firewall)                     │ │
│  │  • Network ACLs (Stateless Firewall)                       │ │
│  │  • Private Subnets (Future: Databases)                     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Layer 2: Identity & Access                                      │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  • IAM Roles (No hardcoded credentials)                    │ │
│  │  • Instance Profiles (EC2 → S3 access)                     │ │
│  │  • Least Privilege Policies                                │ │
│  │  • MFA for AWS Console (Recommended)                       │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Layer 3: Data Encryption                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  • HTTPS (CloudFront SSL/TLS)                              │ │
│  │  • S3 Encryption at Rest (Optional)                        │ │
│  │  • EBS Encryption (Optional)                               │ │
│  │  • Secrets Manager (For passwords)                         │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Layer 4: Monitoring & Logging                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  • CloudWatch Logs (Application logs)                      │ │
│  │  • CloudTrail (API audit logs)                             │ │
│  │  • VPC Flow Logs (Network traffic)                         │ │
│  │  • ALB Access Logs (HTTP requests)                         │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Layer 5: Application Security                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  • WAF (Web Application Firewall) - Optional               │ │
│  │  • Shield (DDoS Protection) - Automatic                    │ │
│  │  • Security Groups (Port restrictions)                     │ │
│  │  • Regular Updates (Patch management)                      │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Design Decisions

### **Why Multi-AZ?**
- **High Availability**: If us-east-1a fails, us-east-1b continues
- **ALB Requirement**: Needs 2+ subnets in different AZs
- **Fault Tolerance**: Automatic failover

### **Why Application Load Balancer?**
- **Layer 7**: HTTP/HTTPS routing
- **Health Checks**: Automatic instance removal
- **Path Routing**: Future expansion (/api, /admin)
- **SSL Termination**: Offload encryption from EC2

### **Why Auto Scaling?**
- **Cost Optimization**: Scale down when idle
- **Performance**: Scale up during traffic spikes
- **Automation**: No manual intervention
- **Reliability**: Replace failed instances

### **Why CloudFront?**
- **Global Performance**: 200+ edge locations
- **HTTPS**: Free SSL certificate
- **Cost Reduction**: Reduce S3 bandwidth costs
- **DDoS Protection**: AWS Shield Standard

### **Why IAM Roles?**
- **Security**: No credentials in code
- **Automatic Rotation**: AWS manages credentials
- **Audit Trail**: CloudTrail logs all access
- **Best Practice**: Industry standard

### **Why CloudWatch?**
- **Proactive Monitoring**: Detect issues early
- **Alerting**: Email notifications
- **Metrics**: Performance insights
- **Troubleshooting**: Historical data

---

## 📊 Scalability Architecture

```
Current State (1 instance)
┌─────────────────────┐
│  ALB                │
│   │                 │
│   ▼                 │
│  EC2 (1)            │
└─────────────────────┘

Traffic Increases
┌─────────────────────┐
│  ALB                │
│   │                 │
│   ├──► EC2 (1)      │
│   └──► EC2 (2)      │
└─────────────────────┘

Peak Traffic
┌─────────────────────┐
│  ALB                │
│   │                 │
│   ├──► EC2 (1)      │
│   ├──► EC2 (2)      │
│   └──► EC2 (3)      │
└─────────────────────┘

Traffic Decreases
┌─────────────────────┐
│  ALB                │
│   │                 │
│   ▼                 │
│  EC2 (1)            │
└─────────────────────┘
```

### **Scaling Metrics**
- CPU > 80% → Scale Up
- CPU < 20% → Scale Down
- Network throughput
- Request count
- Custom metrics

---

## 🔄 Disaster Recovery

### **Backup Strategy**
```
┌─────────────────────────────────────┐
│  Component    │  Backup Method      │
├─────────────────────────────────────┤
│  EC2          │  AMI Snapshots      │
│  S3           │  Versioning         │
│  RDS          │  Automated Backups  │
│  EBS          │  EBS Snapshots      │
│  Config       │  Terraform State    │
└─────────────────────────────────────┘
```

### **Recovery Time Objective (RTO)**
- EC2 Failure: < 5 minutes (Auto Scaling)
- AZ Failure: < 1 minute (Multi-AZ)
- Region Failure: Manual (1-2 hours)

### **Recovery Point Objective (RPO)**
- S3 Data: 0 (versioning)
- EC2 State: 5 minutes (Auto Scaling)
- Database: 5 minutes (RDS automated backups)

---

## 📈 Performance Optimization

### **Caching Strategy**
```
Level 1: CloudFront Edge Cache
    │ TTL: 1 hour
    │ Hit Ratio: 80-90%
    ▼
Level 2: S3 Origin
    │ Static files
    │ Low latency
    ▼
Level 3: EC2 Application Cache
    │ Redis/Memcached (Future)
    │ Database query cache
    ▼
Level 4: Database
    │ RDS (Future)
    │ Read replicas
```

### **Latency Targets**
- CloudFront: < 50ms (global)
- ALB → EC2: < 10ms (same region)
- EC2 → S3: < 5ms (same region)
- Total Page Load: < 2 seconds

---

## 💰 Cost Optimization

### **Cost Breakdown**
```
┌──────────────────────────────────────────┐
│  Service          │  Monthly Cost        │
├──────────────────────────────────────────┤
│  EC2 (t3.micro)   │  $7.50              │
│  ALB              │  $16.00             │
│  S3               │  $0.50              │
│  CloudFront       │  $1.00              │
│  Route 53         │  $0.50              │
│  CloudWatch       │  $0.50              │
│  Data Transfer    │  $2.00              │
├──────────────────────────────────────────┤
│  Total            │  ~$28/month         │
└──────────────────────────────────────────┘
```

### **Cost Saving Strategies**
1. **Reserved Instances**: Save 30-70% on EC2
2. **S3 Lifecycle**: Move old files to Glacier
3. **CloudFront**: Reduce S3 bandwidth costs
4. **Auto Scaling**: Scale down during off-hours
5. **Spot Instances**: Save 90% for non-critical workloads

---

## 🚀 Future Enhancements

### **Phase 2: Database Layer**
```
Add RDS (MySQL/PostgreSQL)
    │
    ├─ Multi-AZ deployment
    ├─ Read replicas
    ├─ Automated backups
    └─ Encryption at rest
```

### **Phase 3: Caching Layer**
```
Add ElastiCache (Redis)
    │
    ├─ Session storage
    ├─ Query caching
    ├─ Real-time analytics
    └─ Pub/Sub messaging
```

### **Phase 4: CI/CD Pipeline**
```
GitHub → CodePipeline → CodeBuild → CodeDeploy → EC2
    │
    ├─ Automated testing
    ├─ Blue/Green deployment
    ├─ Rollback capability
    └─ Zero downtime
```

### **Phase 5: Advanced Security**
```
Add WAF + Shield Advanced
    │
    ├─ SQL injection protection
    ├─ XSS protection
    ├─ Rate limiting
    ├─ DDoS mitigation
    └─ Bot detection
```

---

## 📚 Architecture Patterns

### **Current Pattern: 3-Tier Architecture**
```
Presentation Tier: CloudFront + S3
    ↓
Application Tier: ALB + EC2
    ↓
Data Tier: S3 (Future: RDS)
```

### **Scalability Pattern: Horizontal Scaling**
- Add more EC2 instances (not bigger instances)
- Stateless application design
- Load balancer distributes traffic
- Auto Scaling manages capacity

### **Availability Pattern: Multi-AZ**
- Resources in 2+ availability zones
- Automatic failover
- No single point of failure
- 99.99% uptime SLA

---

**End of Architecture Documentation**

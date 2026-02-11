# AWS Services Explained - What Each Service Does

## 🌐 Complete AWS Services Guide

This document explains each AWS service used in this project, what it does, and why we need it.

---

## 1. Amazon VPC (Virtual Private Cloud)

### **What is it?**
A logically isolated section of AWS cloud where you launch resources.

### **Real-World Analogy**
Think of it as your own private data center in the cloud.

### **What it does in this project**
- Creates isolated network (10.0.0.0/16)
- Provides 65,536 IP addresses
- Separates your resources from other AWS customers
- Controls network traffic flow

### **Components**
- **Subnets**: Subdivisions of VPC (like floors in a building)
- **Internet Gateway**: Door to the internet
- **Route Tables**: Traffic directions (like road signs)

### **Why we need it**
- Security isolation
- Network control
- Organize resources
- Required for EC2, ALB, etc.

### **Cost**: FREE

---

## 2. Amazon EC2 (Elastic Compute Cloud)

### **What is it?**
Virtual servers in the cloud.

### **Real-World Analogy**
Like renting a computer in AWS data center.

### **What it does in this project**
- Runs your web application
- Hosts backend services
- Processes user requests
- Can scale up/down based on demand

### **Instance Type: t3.micro**
- 2 vCPUs (virtual processors)
- 1 GB RAM
- Burstable performance
- Good for small websites

### **Why we need it**
- Run application code
- Host web servers
- Process business logic
- Handle user traffic

### **Cost**: ~$7.50/month per instance

---

## 3. Amazon S3 (Simple Storage Service)

### **What is it?**
Object storage for files, images, videos, backups.

### **Real-World Analogy**
Like Google Drive or Dropbox, but for applications.

### **What it does in this project**
- Hosts static website (HTML, CSS, JS)
- Stores index.html file
- Serves content to CloudFront
- Provides public website access

### **Features**
- 99.999999999% durability (11 nines)
- Unlimited storage
- Website hosting capability
- Versioning support

### **Why we need it**
- Store static website files
- Low-cost storage
- High availability
- Integrates with CloudFront

### **Cost**: ~$0.50/month for small websites

---

## 4. Amazon CloudFront

### **What is it?**
Content Delivery Network (CDN) - distributes content globally.

### **Real-World Analogy**
Like having copies of your website in 200+ cities worldwide.

### **What it does in this project**
- Caches website content at edge locations
- Serves content from nearest location to user
- Provides HTTPS encryption
- Speeds up website loading

### **Edge Locations**
- 200+ locations worldwide
- User connects to nearest location
- Reduces latency (faster loading)

### **Why we need it**
- Faster website performance
- HTTPS/SSL encryption
- DDoS protection
- Reduce S3 costs
- Global reach

### **Cost**: ~$1/month for small traffic

---

## 5. Amazon Route 53

### **What is it?**
DNS (Domain Name System) service.

### **Real-World Analogy**
Like a phone book that converts website names to IP addresses.

### **What it does in this project**
- Maps your domain (www.example.com) to CloudFront
- Routes users to your website
- Provides DNS resolution
- Health checks

### **How it works**
```
User types: www.example.com
    ↓
Route 53 translates to: CloudFront distribution
    ↓
User sees your website
```

### **Why we need it**
- Use custom domain names
- Professional appearance
- Easy to remember URLs
- Automatic failover

### **Cost**: ~$0.50/month per hosted zone

---

## 6. Application Load Balancer (ALB)

### **What is it?**
Distributes incoming traffic across multiple servers.

### **Real-World Analogy**
Like a traffic cop directing cars to different lanes.

### **What it does in this project**
- Distributes traffic across EC2 instances
- Performs health checks
- Removes unhealthy instances
- Provides single entry point

### **Features**
- Layer 7 (HTTP/HTTPS) load balancing
- Path-based routing
- Host-based routing
- SSL termination
- WebSocket support

### **Health Checks**
- Checks every 30 seconds
- Sends HTTP request to /
- Expects 200 OK response
- Removes unhealthy instances

### **Why we need it**
- High availability
- Distribute load evenly
- Automatic failover
- Better performance
- Handle more traffic

### **Cost**: ~$16/month

---

## 7. Auto Scaling Group

### **What is it?**
Automatically adjusts number of EC2 instances.

### **Real-World Analogy**
Like hiring temporary workers during busy hours.

### **What it does in this project**
- Monitors application load
- Adds instances when busy
- Removes instances when idle
- Maintains desired capacity
- Saves costs

### **Scaling Policies**
- **Scale Up**: Add 1 instance when CPU > 80%
- **Scale Down**: Remove 1 instance when CPU < 20%
- **Cooldown**: Wait 5 minutes between actions

### **Configuration**
- Minimum: 1 instance (always running)
- Maximum: 3 instances (peak capacity)
- Desired: 1 instance (normal state)

### **Why we need it**
- Handle traffic spikes
- Cost optimization
- Automatic management
- High availability
- No manual intervention

### **Cost**: FREE (pay only for EC2 instances)

---

## 8. IAM (Identity and Access Management)

### **What is it?**
Manages permissions and access control.

### **Real-World Analogy**
Like security badges that grant access to specific rooms.

### **What it does in this project**
- Creates role for EC2 instances
- Grants S3 access permissions
- No hardcoded credentials needed
- Secure access management

### **Components**
- **Role**: Identity with permissions
- **Policy**: Rules defining what's allowed
- **Instance Profile**: Attaches role to EC2

### **Permissions Granted**
- `s3:GetObject`: Read files from S3
- `s3:PutObject`: Write files to S3
- `s3:ListBucket`: List bucket contents

### **Why we need it**
- Security best practice
- No credential management
- Automatic credential rotation
- Audit trail
- Least privilege access

### **Cost**: FREE

---

## 9. CloudWatch

### **What is it?**
Monitoring and observability service.

### **Real-World Analogy**
Like a security camera system monitoring your infrastructure.

### **What it does in this project**
- Monitors EC2 CPU usage
- Collects metrics every 5 minutes
- Sends email alerts
- Tracks performance

### **Alarms**
- **Metric**: CPUUtilization
- **Threshold**: 80%
- **Period**: 5 minutes
- **Action**: Send email via SNS

### **Metrics Collected**
- CPU utilization
- Network in/out
- Disk read/write
- Status checks

### **Why we need it**
- Proactive monitoring
- Early problem detection
- Performance insights
- Troubleshooting
- Capacity planning

### **Cost**: ~$0.50/month for basic monitoring

---

## 10. SNS (Simple Notification Service)

### **What is it?**
Pub/Sub messaging service for notifications.

### **Real-World Analogy**
Like a notification system that sends alerts to subscribers.

### **What it does in this project**
- Receives alerts from CloudWatch
- Sends email notifications
- Notifies when CPU is high
- Supports multiple subscribers

### **How it works**
```
CloudWatch Alarm triggers
    ↓
SNS Topic receives message
    ↓
Email sent to subscriber
```

### **Why we need it**
- Real-time alerts
- Multiple notification channels
- Reliable delivery
- Easy integration

### **Cost**: ~$0.50/month for low volume

---

## 🔄 How Services Work Together

### **Website Hosting Flow**
```
1. User types domain → Route 53
2. Route 53 → CloudFront
3. CloudFront → S3 bucket
4. S3 returns index.html
5. CloudFront caches and serves
6. User sees website
```

### **Application Traffic Flow**
```
1. User requests page → Route 53
2. Route 53 → Application Load Balancer
3. ALB → Healthy EC2 instance
4. EC2 processes request
5. EC2 reads/writes to S3 (via IAM role)
6. Response → User
```

### **Monitoring Flow**
```
1. EC2 sends metrics → CloudWatch
2. CloudWatch checks thresholds
3. If CPU > 80% → Alarm triggers
4. Alarm → SNS Topic
5. SNS → Email notification
6. Admin receives alert
```

### **Auto Scaling Flow**
```
1. CloudWatch detects high CPU
2. Auto Scaling adds instance
3. New instance launches from template
4. ALB adds instance to target group
5. Health check passes
6. ALB sends traffic to new instance
```

---

## 📊 Service Comparison

| Service | Type | Purpose | Cost |
|---------|------|---------|------|
| VPC | Network | Isolation | FREE |
| EC2 | Compute | Run apps | $7.50/mo |
| S3 | Storage | Store files | $0.50/mo |
| CloudFront | CDN | Fast delivery | $1/mo |
| Route 53 | DNS | Domain routing | $0.50/mo |
| ALB | Load Balancer | Distribute traffic | $16/mo |
| Auto Scaling | Automation | Scale instances | FREE |
| IAM | Security | Permissions | FREE |
| CloudWatch | Monitoring | Track metrics | $0.50/mo |
| SNS | Notifications | Send alerts | $0.50/mo |

**Total**: ~$27/month

---

## 🎯 Service Categories

### **Compute**
- EC2: Virtual servers
- Auto Scaling: Automatic scaling

### **Storage**
- S3: Object storage

### **Networking**
- VPC: Virtual network
- ALB: Load balancer
- CloudFront: CDN
- Route 53: DNS

### **Security**
- IAM: Access management
- Security Groups: Firewall

### **Monitoring**
- CloudWatch: Metrics and alarms
- SNS: Notifications

---

## 🔐 Security Services

### **Network Security**
- VPC: Network isolation
- Security Groups: Firewall rules
- NACLs: Subnet-level firewall

### **Identity Security**
- IAM: Role-based access
- Instance Profiles: EC2 permissions

### **Data Security**
- S3 Encryption: At rest
- CloudFront: HTTPS in transit

### **Monitoring Security**
- CloudWatch: Audit logs
- CloudTrail: API tracking

---

## 💡 Key Takeaways

1. **VPC**: Your private network in AWS
2. **EC2**: Virtual servers for applications
3. **S3**: Storage for files and websites
4. **CloudFront**: Fast global content delivery
5. **Route 53**: Domain name management
6. **ALB**: Traffic distribution
7. **Auto Scaling**: Automatic capacity adjustment
8. **IAM**: Secure access control
9. **CloudWatch**: Monitoring and alerts
10. **SNS**: Notification delivery

---

## 🚀 Service Benefits

### **Scalability**
- Auto Scaling: Automatic capacity
- ALB: Handle more traffic
- CloudFront: Global reach

### **Reliability**
- Multi-AZ: High availability
- Health Checks: Automatic failover
- S3: 99.999999999% durability

### **Security**
- IAM: No credentials in code
- VPC: Network isolation
- HTTPS: Encrypted traffic

### **Cost Optimization**
- Auto Scaling: Pay for what you use
- S3: Low storage costs
- CloudFront: Reduce bandwidth

### **Performance**
- CloudFront: Edge caching
- ALB: Load distribution
- Auto Scaling: Handle spikes

---

**End of AWS Services Documentation**

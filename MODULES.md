# Modules Documentation - Detailed Explanation

## 📦 What are Modules?

**Modules** are reusable, self-contained packages of Terraform configurations. Each module manages a specific AWS service or component.

**Benefits**:
- **Reusability**: Use same code multiple times
- **Organization**: Keep code clean and structured
- **Maintainability**: Update one place, affects all uses
- **Abstraction**: Hide complexity behind simple interfaces

---

## 🗂️ Module Structure

Each module contains 3 files:

### **main.tf**
- Contains resource definitions
- Creates actual AWS infrastructure
- Implements the module's logic

### **variables.tf**
- Defines input parameters
- Allows customization
- Documents expected inputs

### **outputs.tf**
- Exports values for other modules
- Provides information after creation
- Enables module chaining

---

## 📋 All Modules Explained

---

## 1️⃣ VPC Module (`modules/vpc/`)

### **Purpose**
Creates the network foundation for all resources.

### **What it Creates**
- 1 Virtual Private Cloud (VPC)
- 2 Public Subnets (in different availability zones)
- 1 Internet Gateway
- 1 Route Table
- 2 Route Table Associations

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates isolated network (10.0.0.0/16)
resource "aws_vpc" "main"

# Creates first subnet (10.0.1.0/24) in us-east-1a
resource "aws_subnet" "public"

# Creates second subnet (10.0.2.0/24) in us-east-1b
resource "aws_subnet" "public_2"

# Provides internet access
resource "aws_internet_gateway" "main"

# Routes traffic to internet
resource "aws_route_table" "public"

# Associates subnets with route table
resource "aws_route_table_association" "public"
resource "aws_route_table_association" "public_2"
```

#### **variables.tf**
- `vpc_cidr`: IP range for VPC
- `vpc_name`: Name tag for VPC
- `subnet_cidr`: IP range for first subnet
- `subnet_cidr_2`: IP range for second subnet
- `subnet_name`: Name tag for subnets
- `availability_zone`: AZ for first subnet
- `availability_zone_2`: AZ for second subnet

#### **outputs.tf**
- `vpc_id`: VPC identifier (used by other modules)
- `subnet_id`: First subnet ID (for EC2)
- `subnet_ids`: Both subnet IDs (for ALB)
- `route_table_id`: Route table ID

### **Why 2 Subnets?**
- Application Load Balancer requires minimum 2 subnets
- High availability across multiple data centers
- Fault tolerance if one AZ fails

---

## 2️⃣ Security Group Module (`modules/security-group/`)

### **Purpose**
Acts as a virtual firewall controlling inbound/outbound traffic.

### **What it Creates**
- 1 Security Group with ingress and egress rules

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates firewall rules
resource "aws_security_group" "ec2_sg"

# Ingress Rules (Incoming Traffic):
- Port 22 (SSH): For remote access
- Port 80 (HTTP): For web traffic

# Egress Rules (Outgoing Traffic):
- All ports: Allow all outbound traffic
```

#### **variables.tf**
- `vpc_id`: Which VPC to attach to
- `sg_name`: Security group name
- `sg_description`: Description of purpose

#### **outputs.tf**
- `security_group_id`: SG identifier (used by EC2, ALB)

### **Security Rules**
- **SSH (22)**: Access EC2 instances remotely
- **HTTP (80)**: Serve web traffic
- **Egress (All)**: Allow instances to download updates

---

## 3️⃣ EC2 Module (`modules/ec2/`)

### **Purpose**
Creates virtual servers to run applications.

### **What it Creates**
- Multiple EC2 instances (based on instance_count)
- Attached to subnet and security group
- With IAM instance profile for S3 access

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates EC2 instances
resource "aws_instance" "ec2"
  - Uses count to create multiple instances
  - Attaches IAM role for S3 access
  - Places in public subnet
  - Applies security group rules
  - Tags with unique names
```

#### **variables.tf**
- `ami_id`: Amazon Machine Image (OS template)
- `instance_type`: Size (t3.micro = 2 vCPU, 1GB RAM)
- `instance_count`: How many instances to create
- `subnet_id`: Which subnet to place in
- `security_group_ids`: Which firewall rules to apply
- `instance_name`: Base name for tagging
- `iam_instance_profile`: IAM role for permissions

#### **outputs.tf**
- `instance_ids`: List of instance IDs
- `public_ips`: Public IP addresses
- `private_ips`: Private IP addresses

### **Use Cases**
- Web servers
- Application servers
- Backend processing

---

## 4️⃣ S3 Module (`modules/s3/`)

### **Purpose**
Creates object storage for static website hosting.

### **What it Creates**
- 1 S3 Bucket
- Website hosting configuration
- Public access settings
- Bucket policy for public read
- Uploads index.html file

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates storage bucket
resource "aws_s3_bucket" "service_bucket"

# Allows public access
resource "aws_s3_bucket_public_access_block" "bucket_pab"

# Enables website hosting
resource "aws_s3_bucket_website_configuration" "website"
  - Sets index.html as default page

# Allows public read access
resource "aws_s3_bucket_policy" "bucket_policy"

# Uploads HTML file
resource "aws_s3_object" "index"
```

#### **variables.tf**
- `bucket_name`: Globally unique bucket name
- `index_html_path`: Path to HTML file

#### **outputs.tf**
- `bucket_id`: Bucket name
- `bucket_arn`: Amazon Resource Name
- `website_endpoint`: S3 website URL
- `bucket_regional_domain_name`: For CloudFront

### **Features**
- Static website hosting
- Public read access
- Automatic HTML upload
- Low-cost storage

---

## 5️⃣ IAM Module (`modules/iam/`)

### **Purpose**
Manages permissions for EC2 to access S3 securely.

### **What it Creates**
- 1 IAM Role (for EC2)
- 1 IAM Policy (S3 permissions)
- 1 Instance Profile (attaches role to EC2)

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates IAM role for EC2
resource "aws_iam_role" "ec2_role"
  - Allows EC2 service to assume this role

# Attaches S3 permissions
resource "aws_iam_role_policy" "s3_access"
  - GetObject: Read files from S3
  - PutObject: Write files to S3
  - ListBucket: List bucket contents

# Creates instance profile
resource "aws_iam_instance_profile" "ec2_profile"
  - Attaches role to EC2 instances
```

#### **variables.tf**
- `role_name`: Name of IAM role
- `bucket_arn`: Which S3 bucket to access

#### **outputs.tf**
- `instance_profile_name`: For EC2 attachment
- `role_arn`: Role identifier

### **Security Benefits**
- No hardcoded credentials
- Automatic credential rotation
- Least privilege access
- Audit trail in CloudTrail

---

## 6️⃣ CloudFront Module (`modules/cloudfront/`)

### **Purpose**
Content Delivery Network for fast global access with HTTPS.

### **What it Creates**
- 1 CloudFront Distribution
- 1 Origin Access Identity (OAI)
- Cache behaviors
- SSL/TLS certificate configuration

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates OAI for secure S3 access
resource "aws_cloudfront_origin_access_identity" "oai"

# Creates CDN distribution
resource "aws_cloudfront_distribution" "website_distribution"
  - Origin: S3 bucket
  - Default root: index.html
  - Viewer protocol: Redirect to HTTPS
  - Cache TTL: 1 hour default
  - Geographic restrictions: None
  - SSL certificate: CloudFront default or custom
```

#### **variables.tf**
- `bucket_name`: S3 bucket to serve from
- `bucket_regional_domain_name`: S3 endpoint
- `domain_name`: Custom domain (optional)
- `acm_certificate_arn`: SSL certificate (optional)

#### **outputs.tf**
- `distribution_id`: CloudFront ID
- `distribution_domain_name`: CDN URL
- `distribution_hosted_zone_id`: For Route 53

### **Benefits**
- Global edge locations (200+ worldwide)
- HTTPS encryption
- Faster load times
- DDoS protection
- Reduced S3 costs

---

## 7️⃣ Route 53 Module (`modules/route53/`)

### **Purpose**
DNS management for custom domain names.

### **What it Creates**
- DNS A record pointing to CloudFront
- Alias record (no additional cost)

### **Files Breakdown**

#### **main.tf**
```hcl
# Looks up existing hosted zone
data "aws_route53_zone" "main"

# Creates DNS record
resource "aws_route53_record" "website"
  - Type: A (IPv4 address)
  - Alias: Points to CloudFront
  - Only created if domain_name is provided
```

#### **variables.tf**
- `domain_name`: Your domain (e.g., www.example.com)
- `hosted_zone_name`: Root domain (e.g., example.com)
- `cloudfront_domain_name`: CloudFront URL
- `cloudfront_hosted_zone_id`: CloudFront zone

#### **outputs.tf**
- `record_name`: DNS record name
- `record_fqdn`: Fully qualified domain name

### **Requirements**
- Existing Route 53 hosted zone
- Domain registered (Route 53 or external)
- ACM certificate in us-east-1

---

## 8️⃣ ALB Module (`modules/alb/`)

### **Purpose**
Distributes traffic across multiple EC2 instances.

### **What it Creates**
- 1 Application Load Balancer
- 1 Target Group
- 1 HTTP Listener (port 80)
- Target Group Attachments (EC2 instances)

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates load balancer
resource "aws_lb" "main"
  - Type: Application (Layer 7)
  - Scheme: Internet-facing
  - Subnets: 2 public subnets (required)

# Creates target group
resource "aws_lb_target_group" "main"
  - Protocol: HTTP
  - Port: 80
  - Health checks every 30 seconds
  - Healthy threshold: 2 checks
  - Unhealthy threshold: 2 checks

# Creates listener
resource "aws_lb_listener" "http"
  - Listens on port 80
  - Forwards to target group

# Attaches EC2 instances
resource "aws_lb_target_group_attachment" "instances"
```

#### **variables.tf**
- `alb_name`: Load balancer name
- `vpc_id`: Which VPC
- `subnet_ids`: 2+ subnets required
- `security_group_ids`: Firewall rules
- `instance_ids`: EC2 instances to balance

#### **outputs.tf**
- `alb_dns_name`: Load balancer URL
- `alb_arn`: ALB identifier
- `target_group_arn`: Target group ID
- `alb_zone_id`: For DNS

### **Features**
- Health checks
- Automatic failover
- Session stickiness
- Path-based routing
- SSL termination

---

## 9️⃣ Auto Scaling Module (`modules/autoscaling/`)

### **Purpose**
Automatically adjusts number of EC2 instances based on demand.

### **What it Creates**
- 1 Launch Template
- 1 Auto Scaling Group
- 2 Scaling Policies (up/down)

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates launch template
resource "aws_launch_template" "ec2_template"
  - Defines instance configuration
  - AMI, instance type, security groups
  - IAM instance profile

# Creates auto scaling group
resource "aws_autoscaling_group" "ec2_asg"
  - Min size: 1 instance
  - Max size: 3 instances
  - Desired: 1 instance
  - Uses launch template
  - Placed in subnet

# Scale up policy
resource "aws_autoscaling_policy" "scale_up"
  - Adds 1 instance
  - 5-minute cooldown

# Scale down policy
resource "aws_autoscaling_policy" "scale_down"
  - Removes 1 instance
  - 5-minute cooldown
```

#### **variables.tf**
- `ami_id`: OS image
- `instance_type`: Instance size
- `security_group_ids`: Firewall rules
- `subnet_id`: Placement
- `min_size`: Minimum instances
- `max_size`: Maximum instances
- `desired_capacity`: Starting count
- `instance_profile_name`: IAM role

#### **outputs.tf**
- `autoscaling_group_name`: ASG name
- `launch_template_id`: Template ID

### **Scaling Triggers**
- CPU utilization
- Network traffic
- Custom CloudWatch metrics
- Scheduled scaling

---

## 🔟 CloudWatch Module (`modules/cloudwatch/`)

### **Purpose**
Monitors resources and sends alerts.

### **What it Creates**
- SNS Topic (for notifications)
- Email subscription
- CPU alarms for each EC2 instance

### **Files Breakdown**

#### **main.tf**
```hcl
# Creates notification topic
resource "aws_sns_topic" "alarms"

# Subscribes email
resource "aws_sns_topic_subscription" "alarm_email"
  - Protocol: Email
  - Requires email confirmation

# Creates CPU alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high"
  - Metric: CPUUtilization
  - Threshold: 80%
  - Period: 5 minutes
  - Evaluation: 2 periods
  - Action: Send SNS notification
```

#### **variables.tf**
- `instance_ids`: EC2 instances to monitor
- `alarm_email`: Email for notifications

#### **outputs.tf**
- `sns_topic_arn`: Topic identifier

### **Monitoring Capabilities**
- CPU utilization
- Network traffic
- Disk I/O
- Memory (with CloudWatch agent)
- Custom metrics

---

## 🔄 Module Dependencies

```
VPC
 ├── Security Group
 ├── EC2 ──┬── CloudWatch
 │         └── ALB
 ├── Auto Scaling
 └── ALB

S3
 ├── IAM
 └── CloudFront ──> Route 53
```

---

## 📊 Module Interaction Flow

1. **VPC** creates network foundation
2. **Security Group** defines firewall rules
3. **S3** creates storage bucket
4. **IAM** creates permissions for EC2
5. **EC2** launches with IAM role
6. **CloudWatch** monitors EC2 instances
7. **Auto Scaling** manages EC2 scaling
8. **ALB** distributes traffic to EC2
9. **CloudFront** serves S3 content globally
10. **Route 53** maps domain to CloudFront

---

## 🎓 Key Concepts

### **Resource**
Individual AWS component (e.g., EC2 instance, S3 bucket)

### **Module**
Collection of resources working together

### **Variable**
Input parameter for customization

### **Output**
Value exported for use by other modules

### **Data Source**
Read-only information from AWS (e.g., existing hosted zone)

---

## 💡 Best Practices

1. **One Module = One Purpose**: Each module manages one service
2. **Use Variables**: Make modules reusable
3. **Export Outputs**: Share data between modules
4. **Document Everything**: Clear descriptions
5. **Version Control**: Track changes with Git
6. **Test Modules**: Validate before production

---

**End of Modules Documentation**

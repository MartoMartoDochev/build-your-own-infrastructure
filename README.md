###
This project is called Build Your Own Infrastructure. It provisions a robust architecture that ensures continuous availability and scalability for WordPress, utilizing AWS services like EC2, RDS, ELB, and Auto Scaling.

###
The used method for provisioning here is modular Terraform infrastructure provisioning. I chose that method, because it lets you break your infrastructure into logical, reusable parts which are easy to track,
define and control. The method consists of:
- Modules for the main configuration definitions and submodules used to structure larger setups
- Module input variables for parametarization
- Output variables for cross-module dependency

### 
What is deployed:

1. Networking Infrastructure
- Custom VPC spanning multiple Availability Zones
- Two public subnets for web servers and loadbalancers and two private subnets for databases
- Internet Gateway for the public subnets to be able to communicate to the internet
- Two NAT Gateways for the two private subnets to be able to access the internet
- Two route tables for the private subnets and one route table for the public subnets

2. Compute Resources
- Auto Scaling Group (ASG) of EC2 instances running WordPress with minimum capacity of 2 and maximum capacity of 4 instances, spread across two availability zones
- Launch Template with custom user data for WordPress installation and CloudWatch agent installation and configuration, using the t3.micro instance type and amazon-linux AMI
- Automatic horizontal scaling based on CPU and Memory utilization using scaling policies, associated with the ALB target group


3. Database
- Amazon RDS (MySQL) instance for the WordPress backend
- Multi-AZ deployment for high availability and failover
- Secure access from web servers only (via security group rules)

4. Load Balancing & Traffic Distribution
- Application Load Balancer (ALB) for routing traffic to EC2 instances that are part of the target group  
- Health checks and default load balancing policies(Round Robin HTTP/HTTPS)
- Integration with ASG for dynamic target registration

5. Security & Access Control
- Security groups for EC2, RDS, and ALB
- One NACL for the private subnets with inbound rule for allowance of MySQL on port 3306
- Two IAM roles and policies for EC2, RDS monitoring and logging using least privilege for both
- One instance profile used to wrap the EC2 IAM role and policy for the launch template

6. Monitoring & Logging
- CloudWatch metrics and alarms for CPU, memory of the ASG instances
- Enhanced monitoring enabled for the RDS resources
- S3 bucket for ALB access logs
- EC2 and RDS logging via CloudWatch Logs
- SNS topic for alerting (email subscription chosen)

---

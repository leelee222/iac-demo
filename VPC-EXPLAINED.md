# VPC and Network Security Explained

## What is a VPC?

VPC (Virtual Private Cloud) is your own private, isolated section of the cloud.

Network hierarchy analogy:
- AWS Cloud = Entire city
- VPC = Your private gated community in that city
- Subnets = Individual streets in your community
- Security Groups = Door locks on your house
- Network ACLs = Security gate at the community entrance

---

## Our VPC Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      VPC (10.0.0.0/16)                       │
│                    Your Private Network                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌────────────────────┐       ┌────────────────────┐        │
│  │  Public Subnet     │       │  Private Subnet    │        │
│  │  (10.0.1.0/24)     │       │  (10.0.2.0/24)     │        │
│  │                    │       │                    │        │
│  │  ┌──────────┐      │       │  ┌──────────┐     │        │
│  │  │   EC2    │      │       │  │ Database │     │        │
│  │  │ Instance │      │       │  │  (future)│     │        │
│  │  └──────────┘      │       │  └──────────┘     │        │
│  │                    │       │                    │        │
│  │  Internet          │       │  No direct         │        │
│  │  accessible        │       │  internet access   │        │
│  └────────┬───────────┘       └──────────┬─────────┘        │
│           │                              │                   │
│           │                              │                   │
│  ┌────────▼──────────┐         ┌────────▼──────────┐        │
│  │ Internet Gateway  │         │  NAT Gateway      │        │
│  │ (Two-way traffic) │         │ (One-way outbound)│        │
│  └───────────────────┘         └───────────────────┘        │
│           │                              │                   │
└───────────┼──────────────────────────────┼───────────────────┘
            │                              │
            ▼                              ▼
        Internet                       Internet
```

---

## Components Explained

### 1. VPC (Virtual Private Cloud)
- **CIDR**: `10.0.0.0/16` (65,536 IP addresses)
- **Purpose**: Your isolated network in the cloud
- **Security**: Completely separated from other AWS customers

### 2. Public Subnet (`10.0.1.0/24`)
- **Purpose**: For resources that need to be accessible from the internet
- **Use Cases**: Web servers, load balancers, bastion hosts
- **Our Usage**: EC2 instance (web server)
- **Internet Access**: Two-way via Internet Gateway

### 3. Private Subnet (`10.0.2.0/24`)
- **Purpose**: For resources that should NEVER be directly accessible from internet
- **Use Cases**: Databases, application servers, internal APIs
- **Our Usage**: Reserved for future database deployment
- **Internet Access**: One-way outbound via NAT Gateway (can download updates but cannot be accessed from outside)

### 4. Internet Gateway
- **Purpose**: Allows public subnet to communicate with the internet
- **Traffic**: Two-way (inbound and outbound)
- **Attached to**: Public subnet via route table

### 5. NAT Gateway
- **Purpose**: Allows private subnet to access internet for updates
- **Traffic**: One-way outbound only (private resources initiate connections, but internet cannot initiate connections to them)
- **Security**: Prevents direct attacks on private resources

### 6. Route Tables
- **Public Route Table**: Routes `0.0.0.0/0` → Internet Gateway
- **Private Route Table**: Routes `0.0.0.0/0` → NAT Gateway
- **Purpose**: Tells traffic where to go

### 7. Network ACL (Access Control List)
- **Level**: Subnet-level firewall
- **Type**: Stateless (must allow both inbound and outbound)
- **Our Rules**:
  - Allow HTTP (80) and HTTPS (443) from anywhere
  - Allow SSH (22) from specific IPs only
  - Allow ephemeral ports (1024-65535) for return traffic
  - Allow all outbound traffic

### 8. Security Groups
- **Level**: Instance-level firewall
- **Type**: Stateful (return traffic automatically allowed)
- **Attached to**: EC2 instances
- **Our Rules**: SSH from trusted IPs, HTTP from anywhere, limited egress

### 9. VPC Flow Logs
- **Purpose**: Record all network traffic for security monitoring
- **Storage**: CloudWatch Logs
- **Retention**: 7 days
- **Use Cases**: Troubleshooting, security analysis, compliance

---

## Security Layers

Our infrastructure has 4 layers of security:

### Layer 1: Network ACL (Subnet Level)

Allows: HTTP, HTTPS, SSH (from specific IPs), return traffic
Blocks: Everything else

### Layer 2: Security Group (Instance Level)

Allows: HTTP from anywhere, SSH from 10.0.0.0/8
Blocks: All other inbound traffic
Egress: Only HTTP, HTTPS, DNS (not all ports)

### Layer 3: IAM Roles

EC2 can: Write to CloudWatch, Read from specific S3 bucket
EC2 cannot: Modify S3, access other AWS services

### Layer 4: Encryption

All EBS volumes encrypted at rest
IMDSv2 enforced (prevents SSRF attacks)

---

## Why Two Subnets?

### Public Subnet (10.0.1.0/24)

Who goes here:
- Web servers that users access
- Load balancers
- Bastion hosts (jump boxes for SSH)

Why public:
- Users need to reach them from the internet

### Private Subnet (10.0.2.0/24)

Who goes here:
- Databases (PostgreSQL, MySQL)
- Application servers
- Internal APIs
- Backend services

Why private:
- Security: No direct internet access = No direct attacks
- Best Practice: Databases should NEVER be internet-facing
- Defense in Depth: Even if web server is compromised, attacker cannot directly access database from internet

---

## Defense in Depth

House security analogy:

1. VPC = Gated community wall
2. Network ACL = Security checkpoint at community gate
3. Security Group = Lock on your front door
4. IAM Roles = House rules (what residents can do)
5. Encryption = Safe for valuables

All layers work together. If one fails, others still protect you.

---

## Network Flow Examples

### Example 1: User Accesses Your Website
```
User (Internet) 
  → Internet Gateway 
    → Public Subnet 
      → Security Group (check: HTTP allowed?) 
        → EC2 Instance 
          → IAM Role (check: can read S3?) 
            → S3 Bucket
```

### Example 2: EC2 Downloads Updates
```
EC2 Instance (Public Subnet) 
  → Security Group (check: HTTPS outbound allowed?) 
    → Internet Gateway 
      → Internet (update server)
```

### Example 3: Future Database Access
```
EC2 (Public Subnet) 
  → Security Group (egress allowed?) 
    → Private Subnet 
      → Database Security Group (check: only allow from public subnet?) 
        → Database
```

### Example 4: Database Downloads Updates
```
Database (Private Subnet) 
  → NAT Gateway (in public subnet) 
    → Internet Gateway 
      → Internet (update server)
      
Note: Internet CANNOT initiate connection to database!
```

---

## Key Concepts

### Stateful vs Stateless

Security Groups (Stateful):
- If you allow inbound HTTP, return traffic is automatically allowed
- Don't need to configure return traffic rules

Network ACLs (Stateless):
- Must explicitly allow both directions
- That's why we allow ephemeral ports (1024-65535) for return traffic

### CIDR Notation

- `10.0.0.0/16` = 10.0.0.0 to 10.0.255.255 (65,536 IPs)
- `10.0.1.0/24` = 10.0.1.0 to 10.0.1.255 (256 IPs)
- Smaller number after `/` = More IP addresses

### Private IP Ranges (RFC 1918)

- `10.0.0.0/8` = 10.0.0.0 to 10.255.255.255
- `172.16.0.0/12` = 172.16.0.0 to 172.31.255.255
- `192.168.0.0/16` = 192.168.0.0 to 192.168.255.255

These are never routable on the public internet.

---

## What We Built

### Before (Week 5-6)
```
┌──────────────────┐
│  Default VPC     │
│  (AWS provided)  │
│                  │
│  ┌────────┐      │
│  │  EC2   │      │
│  └────────┘      │
│                  │
│  No isolation    │
└──────────────────┘
```

### After (Week 7)
```
┌─────────────────────────────────────────┐
│           Custom VPC                     │
│  ┌─────────────┐    ┌──────────────┐   │
│  │ Public Sub  │    │ Private Sub  │   │
│  │             │    │              │   │
│  │ ┌─────┐     │    │ (Reserved)   │   │
│  │ │ EC2 │     │    │              │   │
│  │ └─────┘     │    │              │   │
│  │             │    │              │   │
│  │ + IAM Role  │    │ + NAT GW     │   │
│  │ + Encryption│    │ + Isolated   │   │
│  │ + Monitoring│    │              │   │
│  └─────────────┘    └──────────────┘   │
│                                          │
│  + VPC Flow Logs                        │
│  + Network ACLs                         │
│  + Route Tables                         │
└─────────────────────────────────────────┘
```

---

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| VPC | 1 | Isolated network |
| Subnets | 2 | Public + Private |
| Internet Gateway | 1 | Public internet access |
| NAT Gateway | 1 | Private outbound access |
| Elastic IP | 1 | Static IP for NAT |
| Route Tables | 2 | Traffic routing |
| Route Table Associations | 2 | Link tables to subnets |
| Network ACL | 1 | Subnet firewall |
| VPC Flow Logs | 1 | Traffic monitoring |
| CloudWatch Log Group | 1 | Store flow logs |
| IAM Role (Flow Logs) | 1 | Permissions for logging |
| IAM Policy (Flow Logs) | 1 | Define log permissions |
| **Total** | **15** | **Complete VPC setup** |

---

## Best Practices Followed

- Network Isolation: Public and private subnets separated  
- Defense in Depth: Multiple security layers (NACL + SG + IAM)  
- Principle of Least Privilege: Only necessary ports open  
- Monitoring: VPC Flow Logs enabled  
- High Availability: Can add multiple AZs later  
- Security by Default: Private subnet has no direct internet access  
- Encryption: EBS volumes encrypted  
- IAM Roles: No hardcoded credentials  

---

## Production Improvements (Future)

For production environments, you'd add:

1. Multiple Availability Zones: Deploy across 2-3 AZs for high availability
2. VPC Endpoints: Direct access to S3/DynamoDB without NAT Gateway (saves cost)
3. AWS PrivateLink: Private connectivity to AWS services
4. VPN/Direct Connect: Secure connection to on-premises network
5. Transit Gateway: Connect multiple VPCs
6. GuardDuty: Threat detection for VPC traffic
7. Web Application Firewall (WAF): Layer 7 protection
8. DDoS Protection (Shield): Protect against DDoS attacks

---

## Testing VPC Security

```bash
# 1. Verify VPC created
aws --endpoint-url=http://localhost:4566 ec2 describe-vpcs

# 2. Check subnets
aws --endpoint-url=http://localhost:4566 ec2 describe-subnets

# 3. Verify route tables
aws --endpoint-url=http://localhost:4566 ec2 describe-route-tables

# 4. Check security groups
aws --endpoint-url=http://localhost:4566 ec2 describe-security-groups

# 5. View flow logs
aws --endpoint-url=http://localhost:4566 logs describe-log-groups

# 6. Verify NAT Gateway
aws --endpoint-url=http://localhost:4566 ec2 describe-nat-gateways
```

---

## Further Reading

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [VPC Security Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Network ACLs vs Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html)
- [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)

---

You now have enterprise-grade network security.

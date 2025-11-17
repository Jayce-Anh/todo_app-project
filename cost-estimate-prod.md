# AWS Cost Estimate - PROD Environment

**Environment:** Production  
**Region:** us-east-1 (US East - N. Virginia)  
**Generated:** November 2025

---

## Infrastructure Overview

The PROD environment uses a modern, scalable architecture with:
- Multi-AZ VPC infrastructure
- ECS Fargate for containerized backend
- CloudFront + S3 for frontend static hosting
- RDS MySQL database with autoscaling storage
- ElastiCache Redis for caching
- CI/CD pipelines with CodePipeline
- Bastion host for secure access

---

## Monthly Cost Breakdown

### 1. **Networking (1-network)**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| VPC | 1 VPC with subnets | $0.00 |
| Public Subnets | 2 subnets (us-east-1a, us-east-1c) | $0.00 |
| Private Subnets | 4 subnets (2 per AZ) | $0.00 |
| NAT Gateway | 2 NAT Gateways (Multi-AZ) | $65.70 |
| Elastic IPs | 2 EIPs for NAT Gateways | $0.00 |
| **Subtotal** | | **$65.70** |

**Calculations:**
- NAT Gateway: $0.045/hour × 2 × 730 hours = $65.70
- Data processing: ~$20-40/month additional (estimate based on 500GB)

---

### 2. **Dependencies (2-dependence)**

#### Container Registry
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| ECR Repository | 1 repository for backend | $0.10/GB |
| Storage | ~5GB of images | $0.50 |
| **Subtotal** | | **$0.50** |

#### Bastion Host
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| EC2 Instance | t3.small (2 vCPU, 2GB RAM) | $15.18 |
| EBS Volume | 40GB gp3 default | $3.20 |
| Elastic IP | 1 EIP for bastion | $0.00 |
| **Subtotal** | | **$18.38** |

**Calculations:**
- EC2: $0.0208/hour × 730 hours = $15.18
- EBS: $0.08/GB × 40GB = $3.20

#### Certificates
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| ACM Certificate (ALB) | *.todo.jayce-lab.work | $0.00 |
| ACM Certificate (CloudFront) | *.todo.jayce-lab.work | $0.00 |
| **Subtotal** | | **$0.00** |

**2-dependence Total:** **$18.88**

---

### 3. **Application (3-application)**

#### Load Balancing
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Application Load Balancer | 1 ALB, 1 target group | $16.20 |
| LCU Charges | Estimated ~25 LCU hours | $14.60 |
| **Subtotal** | | **$30.80** |

#### CloudFront + S3 (Frontend)
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| S3 Storage | ~1GB static files | $0.023 |
| S3 Requests | ~100K GET requests/month | $0.04 |
| CloudFront Distribution | 1 distribution | $0.00 |
| Data Transfer Out | 50GB/month @ $0.085/GB | $4.25 |
| HTTPS Requests | ~1M requests @ $0.01/10K | $1.00 |
| **Subtotal** | | **$5.29** |

**Notes:**
- First 1TB CloudFront transfer is $0.085/GB
- First 10M HTTPS requests are $0.01 per 10,000

#### RDS MySQL Database
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| RDS Instance | db.t4g.micro, Single-AZ | $12.41 |
| Storage | 30GB gp3 @ $0.115/GB | $3.45 |
| Backup Storage | ~30GB (free up to DB size) | $0.00 |
| Provisioned IOPS | 3000 IOPS included in gp3 | $0.00 |
| **Subtotal** | | **$15.86** |

**Calculations:**
- Instance: $0.017/hour × 730 hours = $12.41
- Storage: $0.115/GB × 30GB = $3.45
- Auto-scaling: Up to 100GB (pay as you grow)

**Additional costs if enabled:**
- Multi-AZ deployment: +100% instance cost ($12.41 more)
- Performance Insights: $0.00 (disabled)

#### ElastiCache Redis
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Redis Node | cache.t4g.micro × 1 node | $11.68 |
| Backup Storage | ~1GB snapshots | $0.085 |
| **Subtotal** | | **$11.77** |

**Calculations:**
- Node: $0.016/hour × 730 hours = $11.68
- Backup: $0.085/GB-month

#### ECS Fargate
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| vCPU | 1 vCPU × 730 hours | $29.57 |
| Memory | 2GB × 730 hours | $6.49 |
| Storage | 20GB ephemeral (included) | $0.00 |
| **Subtotal** | | **$36.06** |

**Calculations:**
- vCPU: $0.04048/vCPU/hour × 1 × 730 = $29.57
- Memory: $0.004445/GB/hour × 2 × 730 = $6.49

**Note:** Assumes 1 task running continuously (desired_count = 1)

#### CloudWatch (Application Monitoring)
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Metrics | Custom metrics for ALB, RDS, Redis, ECS | ~$1.50 |
| Logs | ~5GB logs/month | ~$2.50 |
| Dashboards | 1 dashboard | $3.00 |
| Alarms | ~10 alarms | $1.00 |
| **Subtotal** | | **$8.00** |

**3-application Total:** **$107.78**

---

### 4. **CI/CD (4-cicd)**

#### CodePipeline
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Frontend Pipeline | 1 active pipeline | $1.00 |
| Backend Pipeline | 1 active pipeline | $1.00 |
| **Subtotal** | | **$2.00** |

#### CodeBuild
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| FE Build | general1.small, ~10 builds/month, 5 min each | $0.25 |
| BE Build | general1.small, ~10 builds/month, 10 min each | $0.50 |
| **Subtotal** | | **$0.75** |

**Calculations:**
- general1.small: $0.005/min
- FE: 10 builds × 5 min × $0.005 = $0.25
- BE: 10 builds × 10 min × $0.005 = $0.50

#### S3 for Artifacts
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| S3 Storage | ~5GB build artifacts | $0.115 |
| S3 Requests | ~1,000 PUT/GET | $0.01 |
| **Subtotal** | | **$0.13** |

**4-cicd Total:** **$2.88**

---

### 5. **Data Transfer**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Data Transfer Out (EC2/ECS) | ~100GB @ $0.09/GB | $9.00 |
| Inter-AZ Transfer | ~50GB @ $0.01/GB | $0.50 |
| NAT Gateway Data Processing | ~500GB @ $0.045/GB | $22.50 |
| **Subtotal** | | **$32.00** |

---

## Total Monthly Cost Estimate

| Category | Cost |
|----------|------|
| **1. Networking** | $65.70 |
| **2. Dependencies** | $18.88 |
| **3. Application** | $107.78 |
| **4. CI/CD** | $2.88 |
| **5. Data Transfer** | $32.00 |
| **TOTAL** | **$227.24/month** |

---

## Detailed Cost Summary by Service

| Service | Monthly Cost | Annual Cost |
|---------|--------------|-------------|
| NAT Gateway | $65.70 | $788.40 |
| ECS Fargate | $36.06 | $432.72 |
| ALB | $30.80 | $369.60 |
| NAT Data Processing | $22.50 | $270.00 |
| Bastion EC2 | $15.18 | $182.16 |
| RDS MySQL | $15.86 | $190.32 |
| ElastiCache Redis | $11.77 | $141.24 |
| Data Transfer Out | $9.00 | $108.00 |
| CloudWatch | $8.00 | $96.00 |
| CloudFront + S3 | $5.29 | $63.48 |
| EBS Volumes | $3.20 | $38.40 |
| CodePipeline | $2.00 | $24.00 |
| CodeBuild | $0.75 | $9.00 |
| ECR | $0.50 | $6.00 |
| Others | $0.63 | $7.56 |
| **TOTAL** | **$227.24** | **$2,726.88** |

---

## Cost Optimization Recommendations

### High Impact Savings

#### 1. **Use Single NAT Gateway** - Save ~$32.85/month
- Remove one NAT Gateway if high availability not critical
- Trade-off: Single point of failure for internet access

#### 2. **ECS Fargate → EC2 with Spot Instances** - Save ~$25/month
- Use t3a.medium with ECS on EC2
- Enable Spot instances for ~70% discount
- Trade-off: More management overhead

#### 3. **Reserved Instances / Savings Plans**
- 1-year commitment: Save ~30-40%
  - Bastion EC2: Save $4-6/month
  - RDS: Save $4-5/month
  - ElastiCache: Save $3-4/month
- **Total savings: $11-15/month**

#### 4. **RDS Backup Optimization**
- Reduce backup retention from 7 to 1 day
- Save on backup storage as database grows

### Medium Impact Savings

#### 5. **Stop Non-Production Resources During Off-Hours**
- Stop Bastion at night/weekends: Save ~40% ($6/month)
- Use Lambda to automate start/stop

#### 6. **Optimize CloudWatch Logs**
- Reduce log retention from default (never expire) to 30 days
- Filter out verbose logs
- Potential savings: $1-2/month

#### 7. **Use VPC Endpoints**
- Add VPC Endpoints for S3, ECR, Secrets Manager
- Reduce NAT Gateway data processing charges
- Save ~$5-10/month on NAT data processing

### Low Impact / Future Considerations

#### 8. **Enable RDS Multi-AZ Only in Production**
- Currently single-AZ (good)
- Multi-AZ would add $12.41/month

#### 9. **Consider Aurora Serverless v2**
- For variable workloads
- Pay only for actual usage
- May save 30-50% if low utilization

#### 10. **CloudFront Optimization**
- Use CloudFront Functions instead of Lambda@Edge
- Optimize cache hit ratio to reduce origin requests

---

## Estimated Costs by Optimization Level

| Scenario | Monthly | Annual | Savings |
|----------|---------|--------|---------|
| **Current Setup** | $227.24 | $2,726.88 | - |
| **Level 1 Optimized** (Single NAT) | $194.39 | $2,332.68 | $394.20/year |
| **Level 2 Optimized** (+ Reserved) | $179.39 | $2,152.68 | $574.20/year |
| **Level 3 Optimized** (+ VPC Endpoints) | $172.39 | $2,068.68 | $658.20/year |
| **Aggressive** (ECS on Spot EC2) | $147.39 | $1,768.68 | $958.20/year |

---

## Scaling Considerations

### If Traffic Increases 10x:
| Component | Impact |
|-----------|--------|
| ECS Fargate | +$360/month (scale to 10 tasks) |
| RDS | +$100/month (upgrade to db.t4g.medium) |
| ElastiCache | +$60/month (upgrade to cache.t4g.small) |
| ALB LCU | +$50/month |
| Data Transfer | +$200/month |
| CloudFront | +$40/month |
| **Total at 10x** | **~$1,037/month** |

### Cost per User Estimates:
- At 1,000 active users: ~$0.23/user/month
- At 10,000 active users: ~$0.10/user/month
- At 100,000 active users: ~$0.04/user/month

---

## Cost Monitoring & Alerts

### Recommended Budget Alerts
1. **Warning Alert:** $200/month (88% of estimate)
2. **Critical Alert:** $250/month (110% of estimate)
3. **Emergency Alert:** $300/month (132% of estimate)

### Key Metrics to Monitor
- NAT Gateway data processing charges
- ECS Fargate task hours
- RDS storage growth
- ALB LCU consumption
- Data transfer out
- CloudWatch logs volume

### Monthly Review Checklist
- [ ] Review Cost Explorer for anomalies
- [ ] Check unused resources (EIPs, volumes, snapshots)
- [ ] Validate RDS storage autoscaling
- [ ] Review CloudWatch log retention policies
- [ ] Analyze ALB target health and traffic patterns
- [ ] Review ECS task scaling events
- [ ] Check ECR image cleanup policies

---




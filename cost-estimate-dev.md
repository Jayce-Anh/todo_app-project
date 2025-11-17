# AWS Cost Estimate - DEV Environment

**Environment:** Development  
**Region:** us-east-1 (US East - N. Virginia)  
**Generated:** November 2025

---

## Infrastructure Overview

The DEV environment uses a simplified architecture with a single EC2 instance hosting both frontend and backend applications behind an Application Load Balancer.

---

## Monthly Cost Breakdown

### 1. **Networking**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| VPC | 1 VPC with subnets | $0.00 |
| Public Subnets | 2 subnets (us-east-1a, us-east-1c) | $0.00 |
| Private Subnets | 2 subnets (us-east-1a, us-east-1c) | $0.00 |
| NAT Gateway | Estimated (if used) | ~$32.85 |
| Elastic IP | 1 EIP attached to EC2 | $0.00 |
| **Subtotal** | | **~$32.85** |

> **Note:** NAT Gateway cost = $0.045/hour + data processing charges ($0.045/GB)

---

### 2. **Compute Resources**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| EC2 Instance | t3a.medium (2 vCPU, 4GB RAM) | $30.37 |
| EBS Volume | 40GB gp3, 3000 IOPS, 125 MB/s | $3.20 |
| **Subtotal** | | **$33.57** |

**Calculations:**
- EC2: $0.0416/hour × 730 hours = $30.37
- EBS gp3: $0.08/GB-month × 40GB = $3.20

---

### 3. **Load Balancing**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Application Load Balancer | 1 ALB, 2 target groups | $16.20 |
| LCU Charges | Estimated ~10 LCU hours | $7.30 |
| **Subtotal** | | **$23.50** |

**Calculations:**
- ALB fixed cost: $0.0225/hour × 720 hours = $16.20
- LCU: $0.008/LCU-hour × 10 LCU × 730 hours = $58.40 (estimated based on usage)
- Realistic LCU for dev environment: ~$7.30

---

### 4. **Security & Certificates**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| ACM Certificate | *.todo.jayce-lab.work | $0.00 |
| Security Groups | Multiple SGs | $0.00 |
| **Subtotal** | | **$0.00** |

---

### 5. **Configuration Management**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Parameter Store | Standard parameters (2 services) | $0.00 |
| **Subtotal** | | **$0.00** |

> **Note:** First 10,000 standard parameter transactions are free

---

### 6. **Data Transfer**
| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Data Transfer Out | First 1GB free, then $0.09/GB | ~$5.00 |
| Inter-AZ Transfer | Estimated ~20GB | ~$0.40 |
| **Subtotal** | | **~$5.40** |

**Assumptions:**
- ~60GB data transfer out/month
- Minimal inter-AZ traffic

---

## Total Monthly Cost Estimate

| Category | Cost |
|----------|------|
| Networking | $32.85 |
| Compute | $33.57 |
| Load Balancing | $23.50 |
| Security & Certificates | $0.00 |
| Configuration Management | $0.00 |
| Data Transfer | $5.40 |
| **TOTAL** | **$95.32/month** |

---

## Cost Optimization Recommendations

### Immediate Savings
1. **Remove NAT Gateway** - Save $32.85/month
   - If not accessing private resources requiring internet access
   - Use VPC Endpoints for AWS services instead

2. **Use t3a.small instead** - Save $15.19/month
   - Sufficient for low-traffic dev environment
   - t3a.small: $15.18/month vs t3a.medium: $30.37/month

3. **Stop EC2 during non-working hours**
   - Run 12 hours/day (weekdays only): Save ~70% on EC2
   - Potential savings: ~$21/month

### Annual Commitment
4. **Reserved Instance or Savings Plan**
   - 1-year no upfront: ~20% savings
   - 3-year no upfront: ~40% savings
   - Potential savings: $6-12/month on EC2

---

## Estimated Annual Cost

| Scenario | Monthly | Annual |
|----------|---------|--------|
| Current Setup | $95.32 | $1,143.84 |
| Optimized (no NAT) | $62.47 | $749.64 |
| Highly Optimized | $47.28 | $567.36 |

---

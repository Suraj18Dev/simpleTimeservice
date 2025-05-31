
# SimpleTimeService 🚀

A tiny web app that returns the current timestamp and the IP address of the client. Deployed to AWS ECS using Terraform and Docker.

---

## 🧰 Tech Stack

- Python (Flask)
- Docker
- AWS ECS (Fargate)
- AWS ALB (Load Balancer)
- Terraform

---

## 📦 API

**GET /**  
Returns:
```json
{
  "timestamp": "2025-05-19 15:43:12",
  "ip": "203.0.113.42"
}
```

---

## 🧪 Local Development

1. **Clone the Repo**
   ```bash
   git clone https://github.com/your-username/simpletimeservice.git
   cd simpletimeservice
   ```

2. **Build the Docker Image**
   ```bash
   docker build -t simpletimeservice:latest ./app
   ```

3. **Run the App**
   ```bash
   docker run -p 5000:5000 simpletimeservice:latest
   ```

4. **Test it**
   Visit: [http://localhost:5000](http://localhost:5000)

---

## ☁️ Deploying to AWS with Terraform

### 🔐 Prerequisites

- An AWS account
- AWS CLI configured with your credentials:
  ```bash
  aws configure
  ```
- Terraform installed

---

### 🌍 Infrastructure Setup

1. **Navigate to terraform directory**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Preview the plan**
   ```bash
   terraform plan
   ```
   Note:-
 *** This will ask for VPC id, enter your created vpc id ***
4. **Apply the infrastructure**
   ```bash
   terraform apply
   ```

   Note:-
 *** This will ask for VPC id, enter your created vpc id ***
   
   > Type `yes` when prompted.

6. **Find your service URL**
   After the apply is complete, the load balancer DNS will be shown in the output like:
   ```
   alb_dns = simpletime-alb-XXXXXX.ap-south-1.elb.amazonaws.com
   ```

---

## 📌 Terraform Variables (terraform.tfvars example)

```hcl
aws_region       = "ap-south-1"
vpc_cidr         = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

task_cpu         = 256
task_memory      = 512
container_name   = "simpletime-container"
container_port   = 5000
container_image  = "your-dockerhub-username/simpletimeservice:latest"
task_family      = "simpletime-task"
```

---

## 🛠 Troubleshooting

- **504 Gateway Timeout**: 
  - Ensure your container is listening on the correct port (matching the one in your ECS task definition and load balancer target group).
  - Check ECS logs in CloudWatch for errors.

- **Target group issues**:
  - Ensure target type is `ip` if using `awsvpc` mode.
  - Clean up previously created target groups before reapplying Terraform.
 or  You can check for the SG for port, allow port : 8080 in inbound rule.
---

## 🧽 Clean Up

To delete all resources:
```bash
terraform destroy
```

---

## 👨‍🔧 Maintainer

**Suraj Singh**

---

## 🔐 Security Warning

NEVER commit AWS credentials, secrets, or `.tfstate` files to a public repo.

---

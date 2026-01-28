## End-to-End Azure 3-Tier Architecture Implementation Using Terraform

### 📚 Overview
This video introduces an in-depth, practical project demonstrating how to build a full Azure 3-tier architecture with Terraform, focusing on infrastructure-as-code and best networking practices. The instructor emphasizes not just watching but actively implementing this real-world project to confidently discuss it in interviews. The video guides through the architecture components, Terraform modular code, deployment demos, and improvements for a professional resume-worthy capstone project.

---

### 🧠 Summary of Core Knowledge Points

- **(00:00 - 04:56) Introduction to 3-Tier Architecture & Project Motivation**  
  The project showcases a 3-tier Azure architecture—front-end (presentation layer), application tier (business logic), and database tier—each separated by subnets for security and network control. The goal is to build hands-on expertise for job interviews by creating an end-to-end infrastructure that includes app gateways, firewalls, VM scale sets, containers, databases, and Azure networking components.

- **(04:57 - 11:16) Architecture Components & Networking Setup**  
  User requests hit an Application Gateway with Web Application Firewall (WAF) protecting against attacks. App Gateway has a public IP and directs traffic to the front-end servers within public subnets. Virtual Machine Scale Sets (VMSS) provide high availability by managing identical VM instances (similar to AWS Auto Scaling groups). Containers run front end and back end applications. The database uses Azure managed PostgreSQL with primary and read replicas for fault tolerance. Network Security Groups restrict traffic by tiers, and Azure NAT Gateway securely enables internet access for private subnet instances without exposing them publicly.

- **(11:17 - 15:42) Project Files & Terraform Modular Structure Overview**  
  The GitHub repo includes application code (NodeJS front end, Go backend, PostgreSQL DB) and Terraform infrastructure-as-code split into custom reusable modules per component (networking, compute, database, key vault, DNS). Local variables and naming best practices generate resource names dynamically using random suffixes. Modules enforce standards like VM types and Linux images to ensure consistency.

- **(15:43 - 29:27) Terraform Setup & Networking Module Details**  
  Steps to authenticate using Azure service principals are shown, including setting environment variables for secure login. The networking module provisions virtual networks, multiple subnets (public, private, database, bastion, and app gateway), and attaches Network Security Group rules defining allowed traffic and ports for each subnet. Bastion host provides secure jump server access, and user scripts configure necessary connection permissions.

- **(29:28 - 41:47) Other Modules: Key Vault and Database**  
  Key Vault stores sensitive credentials like database login info and Docker Hub tokens, provisioning only after database resources are created. The database module provisions a PostgreSQL flexible server with asynchronous replication for fault tolerance. Module dependencies ensure correct resource creation order.

- **(41:48 - 50:27) Compute Modules and Deployment Process**  
  Front-end and back-end VM Scale Sets configure containerized applications on defined ports (3000 & 8080) with health probes ensuring instance availability. Terraform output files display URLs and connection info post-deployment. The instructor details managing multiple environments (prod, test, dev) with separate variable files and backend state configurations to avoid accidental changes in production.

- **(50:28 - 58:17) Demo Run, Cost Warnings & Cleanup Best Practices**  
  The Terraform deployment runs, provisioning around 63 resources across availability zones, taking ~15 minutes. The application demo is a goal tracker with a front end connected to back-end APIs and PostgreSQL database. The instructor warns about Azure costs accruing quickly, especially for multi-AZ database and app gateway. Emphasizes proper infrastructure teardown with `terraform destroy` to avoid unexpected charges and warns against manual deletion outside Terraform to prevent inconsistent state errors.

---

### 🔑 Key Terms and Definitions

- **3-Tier Architecture**: Software design dividing presentation (front end), application (business logic), and data (database) layers into separate tiers for security and maintainability.

- **Terraform**: Infrastructure as Code (IaC) tool used to provision and manage cloud resources declaratively.

- **Virtual Machine Scale Set (VMSS)**: Azure service managing a set of identical VMs, automatically scaling and replacing unhealthy instances—equivalent to AWS Auto Scaling Groups or GCP Managed Instance Groups.

- **Application Gateway with Web Application Firewall (WAF)**: Layer 7 load balancer that routes traffic to backend instances while protecting against common web exploits and attacks.

- **Network Security Group (NSG)**: Azure firewall-like component restricting inbound/outbound traffic through rule-based filtering per subnet or VM.

- **Azure NAT Gateway**: Provides outbound internet connectivity for private subnet resources securely without exposing them directly.

- **Azure Key Vault**: Managed service to securely store secrets, keys, and credentials used by applications and infrastructure.

- **Service Principal**: An identity used by applications or automation tools to access Azure resources, assigned roles for permission control.

---

### 🧩 Reasoning Structure (Resource Provisioning Dependencies)

1. **Authenticate with Azure**  
   - Premise: Terraform requires Azure credentials →  
   - Process: Create service principal with Contributor role →  
   - Conclusion: Allows Terraform to provision resources in target subscription.

2. **Network Infrastructure**  
   - Premise: Infrastructure needs segregated network →  
   - Process: Provision VNet, subnets, and NSGs for tiered security →  
   - Conclusion: Secure communication and restricted access policies per tier.

3. **Database Creation Before Dependent Modules**  
   - Premise: Application tiers require a running database →  
   - Process: Deploy PostgreSQL server first with primary and replica →  
   - Conclusion: Modules depending on DB connect only after it’s ready.

4. **Key Vault Dependence on Database**  
   - Premise: Secrets (DB credentials) not available before DB →  
   - Process: Provision Key Vault storing DB secrets post DB creation →  
   - Conclusion: Secure credential storage access by other modules.

5. **Compute Modules Dependent on Key Vault and Database**  
   - Premise: VMSS needs DB connection info and secrets →  
   - Process: Deploy back end and front end VMSS only after DB and KV ready →  
   - Conclusion: Smooth application deployment with proper configurations.

6. **Deployment and Cleanup**  
   - Premise: Running cloud resources incur cost →  
   - Process: Use Terraform destroy for proper cleanup →  
   - Conclusion: Avoid resource sprawl, redundant charges, and inconsistent state files.

---

### 💡 Examples

- **Virtual Machine Scale Set Analogy**  
  Explained as Azure’s equivalent to AWS Auto Scaling Group or GCP Managed Instance Group, illustrating how VMSS manages identical VM instances automatically for fault tolerance and scalability.

- **Security Group Rules**  
  Front-end servers allow HTTP/HTTPS traffic from internet, SSH access restricted to bastion subnet only, demonstrating layered security and principle of least privilege in networking.

- **Database Replication**  
  PostgreSQL setup with primary and reader replica acts as failover, where read replicas can become primary, ensuring continuous availability.

- **Application Demo**  
  Goal tracker web app with NodeJS front end and Go back end runs inside Docker containers on VMSS, using PostgreSQL as a backend, showing real application deployment on the generated infrastructure.

---

### ⚠️ Error-Prone Points

- **Misunderstanding Networking Layers**  
  Confusion between public and private subnets may lead to improperly exposing sensitive backend or database servers to internet. Correct answer: Use separate subnets and NSGs strictly controlling access.

- **Skipping Infrastructure Teardown**  
  Not destroying resources after demo leads to expensive Azure bills. Always run `terraform destroy` or else face unexpected costs.

- **Deleting Resources Outside Terraform**  
  Manual deletion of resources in Azure Portal without updating Terraform state causes state inconsistency and errors in future deployments. Correct approach: Use Terraform lifecycle commands for resource updates and deletion.

- **Ignoring Module Dependencies**  
  Provisioning modules out of order (e.g., compute before DB ready) can cause deployment failure. Define explicit dependencies for correctness.

- **Incorrect Environment Configurations**  
  Not isolating environments (prod, test, dev) with separate Terraform variable files increases risk of accidental changes in production. Use environment folders with distinct state and variables.

---

### 🎯 Quick Review Tips / Self-Test Exercises

#### Tips (No answers)
- What are the three tiers in a typical 3-tier architecture, and why are they separated in networking?  
- How does a Virtual Machine Scale Set ensure high availability in Azure?  
- Explain the role of Azure NAT Gateway in private subnet internet access.  
- Why is using Terraform modules considered a best practice for infrastructure management?  
- What is the function of Azure Key Vault in this project?  
- How are Network Security Groups applied in multi-tier Azure architectures?  
- Why must Terraform state be managed carefully, especially in production environments?

#### Exercises (With answers)  
1. **Question:** What Terraform resource manages groups of identical virtual machines in Azure?  
   **Answer:** Virtual Machine Scale Set (VMSS) manages identical VM instances.

2. **Question:** Which Azure service provides outbound access to the internet for resources in private subnets without exposing them?  
   **Answer:** Azure NAT Gateway.

3. **Question:** What is the key benefit of separating the database tier into a private subnet?  
   **Answer:** It keeps sensitive data secure and inaccessible from the public internet.

4. **Question:** How does Terraform ensure modular and reusable infrastructure code?  
   **Answer:** Through the use of custom modules with specified inputs and outputs enforcing standards.

5. **Question:** What command should you run to safely remove all Terraform provisioned resources after testing?  
   **Answer:** `terraform destroy -auto-approve`

---

### 📌 Summary and Review
This video detailed a comprehensive project building a secure, resilient Azure 3-tier architecture using Terraform, illustrating best practices such as tier separation, modular infrastructure code, secure credential management, and automated deployment with containerized applications. It walked through the networking setup, VM scale sets, database replication, security policies, Terraform module creation, environment management, and real deployment demos. The instructor emphasized hands-on practice and warned about operational costs and proper cleanup to maintain good cloud hygiene. This capstone project equips learners with a strong foundation to confidently discuss cloud infrastructure in technical interviews while being ready to extend and professionalize the setup further.

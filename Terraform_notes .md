Perfect 👍
Let’s create structured Terraform notes based on everything you’ve studied so far during our mock sessions.

I’ll organize this in layers so you can revise quickly before interviews.


---

📘 Terraform Notes – Azure DevOps Engineer


---

1️⃣ Terraform Fundamentals

What is Terraform?

Infrastructure as Code (IaC) tool

Declarative language (HCL)

Maintains desired state

Uses providers (AzureRM, AWS, etc.)


Core Commands

- terraform init
- terraform plan
- terraform apply
- terraform destroy
- terraform validate
- terraform fmt

Important Concepts

Providers

Resources

Variables

Outputs

Modules

Data sources



---

2️⃣ Terraform State (Very Important for Interviews)

What is State?

Terraform’s source of truth

Maps logical resource → real cloud resource

Stored locally or remote backend


State File Contains:

Resource IDs

Attributes

Sensitive values (passwords, keys)

Dependencies


State Commands

- terraform state list
- terraform state show
- terraform state mv
- terraform state rm
- terraform import

Important Notes

State updates incrementally during apply

Destroy happens if logical name changes

Renaming resource requires terraform state mv

State locking prevents corruption



---

3️⃣ Backend Configuration (Azure)

Remote Backend Example
```
terraform {
  backend "azurerm" {
    resource_group_name = "rg-tf"
    storage_account_name = "stterraform"
    container_name = "tfstate"
    key = "prod.tfstate"
  }
}
```
Important:

Azure Blob uses lease mechanism for locking

Enable:

Soft delete

Versioning

Encryption at rest


Separate backend per environment (dev, qa, prod)



---

4️⃣ Drift Management

What is Drift?

Actual infra ≠ Desired configuration

When It Happens:

Manual portal change

Policy enforcement

External script modification


Detection:

terraform plan

Handling:

Revert manual change via apply OR

Update Terraform code to match change


Enterprise prevention:

RBAC restrictions

Azure Policy

CI/CD-only deployment



---

5️⃣ Lifecycle Meta-Arguments
```
lifecycle {
  prevent_destroy = true
  create_before_destroy = true
  ignore_changes = [tags]
}
```

Use Cases:

Protect production resources

Zero downtime deployments

Ignore auto-generated changes



---

6️⃣ Partial Apply Behavior

If apply fails midway:

Successfully created resources are in state

Fix error

Re-run apply

Terraform continues from failed resource


Do NOT redeploy everything blindly.


---

7️⃣ Sensitive Data Handling

Risk Areas:

tfvars file

Git commits

Terraform state file

CI/CD logs


Secure Alternatives:

Azure Key Vault

Pipeline secret variables

sensitive = true

Restrict backend access



---

8️⃣ Importing Existing Infrastructure

Steps:

1. Write Terraform config first


2. Use:



terraform import

3. Adjust until plan shows no changes



Risks:

Accidental replacement

Missing dependencies

Misconfiguration



---

9️⃣ Multi-Environment Design

Recommended Structure
```
modules/
   network/
   compute/
   storage/

environments/
   dev/
   qa/
   prod/
```
Best Practice:

Separate state per environment

Separate service principal per environment

Separate subscription for prod

CI/CD-only apply for production



---

🔟 Performance & Optimization

Slow Apply Causes:

Large state file

Too many dependencies

API throttling

Large parallel resource creation


Optimize:

terraform apply -parallelism=10

Split state logically (network, compute, data)

Avoid unnecessary depends_on



---

1️⃣1️⃣ Common Interview Traps

| Scenario | Correct Action / Thinking |
| :--- | :--- |
| **Rename resource** | Use `terraform state mv` |
| **State locked** | Check active deployment first |
| **Manual change** | Decide: revert or update code |
| **Secret in tfvars** | Move to Key Vault |
| **Backend deleted** | Restore from versioning/backup |
| **Apply failed midway** | Fix error & reapply |


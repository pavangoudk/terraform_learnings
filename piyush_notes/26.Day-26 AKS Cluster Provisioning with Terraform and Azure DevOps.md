## End-to-End Corporate Level Project: AKS Cluster Provisioning with Terraform and Azure DevOps

### Overview 🛠️
This video presents a comprehensive, real-world project combining Terraform and Azure DevOps to automate the provisioning of Azure Kubernetes Service (AKS) clusters across multiple environments. It focuses on infrastructure as code principles, building CI/CD pipelines, implementing Git branching strategies, and managing complex Azure resources via modular Terraform code. The tutorial unifies key concepts covered in previous lessons into a practical workflow: starting from backend preparation and code validation to automated deployment and resource destruction. This end-to-end demonstration encourages active hands-on practice, emphasizing troubleshooting and real-time problem-solving essential for DevOps engineers and interview preparation.

### Summary of core knowledge points ⏰

- **00:00 - 02:00: Project Introduction and Goals**  
  - The project automates provisioning of AKS clusters for multiple environments (Dev, Stage) using Terraform and Azure DevOps pipelines.  
  - Emphasizes modular Terraform resource creation, CI/CD pipeline automation, and Git branching best practices.  
  - Encourages active implementation rather than passive watching for effective learning and interview readiness.

- **02:00 - 04:30: Overview of Continuous Integration Flow**  
  - Manual Terraform commands previously used are replaced with automated pipelines triggered by Git commits and merges.  
  - Feature branches undergo testing and validation; merged code on the main branch triggers environment-specific deployments.  
  - Separate Terraform state files per environment are stored in dedicated Azure storage accounts to maintain separation and prevent conflicts.

- **04:30 - 07:00: Resource Destruction Pipeline & Prerequisites Setup**  
  - Non-production environments are destroyed post-testing to reduce costs using a dedicated destruction pipeline that accepts environment parameters at runtime.  
  - Preliminary scripts create backend storage accounts and blob containers essential for Terraform state management.

- **07:00 - 11:30: Branching Strategy Explanation**  
  - Discusses common Git branching models (trunk-based, Git Flow, GitHub Flow, Feature Branch).  
  - The project uses a feature branch strategy where each feature or fix is developed in isolation, tested, and merged back to main, triggering deployments.  
  - Highlights the importance of maintaining commit history, reviewing pull requests, and ensuring stable production code.

- **11:30 - 20:00: Terraform Code Structure and Modular Approach**  
  - Walkthrough of Terraform file hierarchy: modules for service principals, AKS cluster, Azure Key Vault; separate directories for Dev and Stage environments.  
  - Variables manage customizable parameters like resource names, subscription IDs, and SSH keys.  
  - Illustrates dependency relations, e.g., resource creation order between service principal, Key Vault, and secrets.

- **20:00 - 32:00: Azure CLI and Backend Initialization**  
  - Demonstrates using Azure CLI to authenticate (`az login`) and execute a shell script that sets up resource groups and storage accounts for Terraform backend state.  
  - Validates backend resources via Azure portal.  
  - Explains benefits of isolated backend stores for each environment.

- **32:00 - 38:30: Azure DevOps Repo Import and Pipeline Creation**  
  - Steps to create an Azure DevOps project and import an existing Git repo containing Terraform code.  
  - Introduces creating a starter multi-stage build pipeline from scratch with triggers on specific branches and paths to avoid unnecessary runs.  
  - Segregates pipeline into stages: validation, Dev deployment, and Stage deployment.

- **38:30 - 51:30: Building Pipeline Stages and Jobs**  
  - Detailed YAML pipeline structure: defining stages, jobs, agent pools, and sequential steps like terraform tool installation, initialization (`terraform init`), validation (`terraform validate`), plan, and apply.  
  - Explains agent pools and job parallelism benefits.  
  - Conditions ensure deployment stages run only on main branch merges and after successful validations.

- **51:30 - 56:00: Triggering Pipelines with Feature Branches and Pull Requests**  
  - Demonstrates feature branch commits triggering validation stage only due to branch conditions.  
  - Pull requests are created and reviewed, then merged to main to trigger full deployment pipelines.  
  - Reviews handling permissions and pipeline errors like missing SSH keys.

- **56:00 - 01:05:00: SSH Key Setup and Pipeline Troubleshooting**  
  - Identifies and resolves errors related to missing SSH public key files by creating and committing keys in proper repo directories.  
  - Adjusts paths in Terraform variable references for successful key discovery during pipeline execution.  
  - Encountering and fixing permission-related errors for service principals in Azure Active Directory.

- **01:05:00 - 01:15:00: Assigning Required Azure AD Permissions**  
  - Adds API permissions (`Application.ReadWrite.All`) for the Azure DevOps service principal via Microsoft Graph.  
  - Grants admin consent to these permissions within the Azure portal.  
  - Adds both Contributor and Key Vault Administrator roles to the service principal to enable secret creation and management.  
  - Discusses the necessity of granting Owner or User Access Administrator role assignments to service principal to resolve authorization errors during deployments.

- **01:15:00 - 01:35:00: Successful Infrastructure Deployment and Cluster Validation**  
  - Upon permission fixes, pipelines successfully provision AKS clusters in both Dev and Stage environments.  
  - Validates cluster creation by connecting via Azure Cloud Shell and using `kubectl` commands to view nodes and running pods.  
  - Confirms infrastructure consistency and readiness for further testing or app deployment.

- **01:35:00 - 01:48:00: Creating and Running Destroy Pipelines**  
  - Builds dedicated destruction pipeline with input parameters for environment selection to clean up Dev/Stage resources on demand.  
  - Implements Terraform destroy commands with auto-approve to automate resource removal and cost saving.  
  - Validates destruction success by confirming absent resource groups in Azure portal.

- **01:48:00 - End: Recap, Cleanup, and Final Notes**  
  - Recap of steps including variable settings, backend initialization, manual Terraform executions, permissions setup, and pipeline executions.  
  - Stresses importance of applying the same changes consistently across Dev and Stage folders.  
  - Demonstrates cleanup of auxiliary resource groups and service principals to avoid orphaned resources.  
  - Encourages further practice, sharing, and feedback to promote learning.

### Key terms and definitions 📚

- **Terraform**: Infrastructure-as-code tool to define and provision cloud resources declaratively.  
- **AKS (Azure Kubernetes Service)**: Managed Kubernetes service on Azure for container orchestration.  
- **Azure DevOps Pipelines**: Automated workflows for building, testing, and deploying code.  
- **Terraform State File**: A file tracking the current state of infrastructure managed by Terraform; backend storage stores and locks state files.  
- **Service Principal**: Azure security identity for apps or services to authenticate and access resources securely.  
- **Key Vault (Keyal)**: Azure service for securely storing keys, secrets, and certificates.  
- **CI/CD (Continuous Integration/Continuous Deployment)**: Practices automating code integration tests and deployments.  
- **Feature Branch**: Git branch strategy where each new feature or fix is isolated before merging to main.  
- **Pull Request**: Request to merge code changes from a feature branch into main branch, often requiring review.  
- **Azure CLI (`az`)**: Command-line tool to manage Azure resources.  
- **Admin Consent**: Approval from an Azure Active Directory administrator to grant an app permissions to access APIs.  
- **Terraform `init`**: Command initializing Terraform working directory and backend configuration.  
- **Terraform `validate`**: Command checking Terraform configuration syntax and structural correctness.  
- **Terraform `plan`**: Command showing proposed changes Terraform will make without applying them.  
- **Terraform `apply`**: Command to provision or update infrastructure as per configuration.  
- **Terraform `destroy`**: Command to delete infrastructure resources managed by Terraform.

### Reasoning structure 🔍

1. **Premise**: Infrastructure provisioning should be automated for consistency, repeatability, and speed.  
   → **Reasoning**: Manual execution of Terraform commands is error-prone and not scalable in corporate environments.  
   → **Conclusion**: Build automated pipelines triggered by Git events to manage infrastructure lifecycle.

2. **Premise**: Different environments require isolated infra state and controlled deployments.  
   → **Reasoning**: Storing Terraform state files separately per environment prevents accidental overlaps or corruption; deploying sequentially ensures stability.  
   → **Conclusion**: Implement multi-branch Git workflow, separate backends, and sequential pipeline stages.

3. **Premise**: Pipeline agents are ephemeral; dependencies must be installed per job/stage.  
   → **Reasoning**: Each pipeline job runs on a clean agent, so Terraform and other tools must be installed each time.  
   → **Conclusion**: Add Terraform installation steps in every pipeline job.

4. **Premise**: Azure AD permissions errors block resource provisioning tasks such as service principals creation.  
   → **Reasoning**: The Azure DevOps service principal requires correct API permissions plus admin consent and role assignments at subscription level.  
   → **Conclusion**: Assign Application.ReadWrite.All permissions and Owner or equivalent role to resolve authorization errors.

5. **Premise**: Cost management necessitates resource destruction in non-prod environments after testing.  
   → **Reasoning**: Leaving non-prod clusters running accumulates unnecessary costs; controlled destruction pipelines help.  
   → **Conclusion**: Build dedicated destroy pipeline with parameterized environment choice.

### Examples 💡

- **Pipeline Trigger Example**: Commits to a feature branch trigger the validation stage only; merging into main triggers full deployment to Dev and Stage environments. This separation ensures only tested code reaches main, preventing broken deployments.  
- **Error Handling Example**: Missing SSH public key files led to Terraform failing; resolved by creating key files and adjusting Terraform variables to proper paths. Demonstrates necessity to correctly organize repo for pipeline success.  
- **Permission Fix Example**: Permission denied errors when creating service principal resolved by adding Microsoft Graph API permissions and granting admin consent in Azure portal. Highlights real-world need to align cloud permissions with automation workflows.  
- **Resource Destruction Example**: Running the destruction pipeline with environment parameter selects and destroys corresponding resources without manual portal intervention, saving cost and effort.

### Error-prone points ⚠️

- **Trigger Conditions Misconfiguration**: Pipelines skipping deployment stages because conditions check if build is from main branch — feature branch commits only run validation, which can confuse beginners. Correct understanding of trigger conditions is essential.  
- **Incorrect SSH Key Paths**: Terraform errors occur if SSH public key files are missing or referenced with incorrect relative paths; must store keys inside environment folder consistent with pipeline working directory.  
- **Insufficient Azure AD Permissions**: Lack of API permissions or missing admin consent causes application creation errors; simply assigning Contributor role is insufficient. Must assign `Application.ReadWrite.All` with admin consent and Owner/User Access Administrator role for service principal.  
- **Backend Resource Naming Mismatch**: Using inconsistent folder names (stage vs. staging) or storage account names leads to pipeline initialization failure. Naming conventions must be uniform.  
- **Agent Pool and Task Indentation in YAML**: Misplaced indentation in pipeline YAML leads to syntax errors causing pipeline failures. Correct YAML structure is critical for build execution.

### Quick review tips/self-test exercises 📝

**Tips (no answers):**  
- What is the purpose of having separate Terraform state files for each environment?  
- Why is admin consent required when assigning API permissions to a service principal?  
- How does the feature branch strategy protect production code during deployment?  
- What are the key stages in a multi-stage Terraform deployment pipeline?  
- How do you configure pipeline triggers to avoid unnecessary runs from non-relevant path changes?  

**Exercises (with answers):**

1. **Q:** Define what happens in the Terraform `init` and `validate` steps in a pipeline.  
   **A:** `terraform init` initializes the working directory and configures backend state; `terraform validate` checks the syntax and correctness of the Terraform configuration files.

2. **Q:** You receive a permission error when your pipeline tries to create a service principal. What minimum Azure AD API permission is required?  
   **A:** `Application.ReadWrite.All` permission on Microsoft Graph API, granted with admin consent.

3. **Q:** In the Git feature branch model, when should the deployment pipelines for environments like Dev or Stage run?  
   **A:** Deployment pipelines run only when changes are merged into the main branch, not on feature branch commits.

4. **Q:** What Terraform command and pipeline stage automate the resource destruction process?  
   **A:** `terraform destroy` command in a dedicated destroy stage/pipeline.

### Summary and review 🔄

This video walks you through a practical, end-to-end corporate-level project automating AKS cluster deployment using Terraform and Azure DevOps pipelines. It integrates branching strategies and modular Terraform code to manage infrastructure lifecycle reliably and securely. Key takeaways include the importance of separate state management per environment, the orchestration of multi-stage CI/CD pipelines, and the need to correctly assign Azure AD permissions for seamless automation. The demonstrated troubleshooting process reinforces real-world complexities in cloud automation, preparing you for professional projects and interviews. Hands-on practice following this guide will help solidify your grasp of Terraform, Azure DevOps, and Kubernetes infrastructure management.

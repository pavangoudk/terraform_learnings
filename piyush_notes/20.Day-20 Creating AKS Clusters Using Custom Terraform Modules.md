## Creating AKS Clusters Using Custom Terraform Modules

### Overview 🎯
This video dives into an advanced Terraform project focused on provisioning Azure Kubernetes Service (AKS) clusters using **custom Terraform modules**. It emphasizes why and how to create reusable, manageable infrastructure code through modules, covering the step-by-step setup of essential Azure resources such as Resource Groups, Service Principals, Key Vaults, and AKS clusters. The explanation method includes walking through project architecture, Terraform directory structure, module design, and best practices, supported by detailed code walkthroughs and real-world application deployment. This practical approach helps viewers understand modular Terraform's benefits and industry-standard infrastructure automation.

### Summary of Core Knowledge Points ⏰

- **00:00 - 03:40: Introducing the Project and Core Resources**  
  The video starts by outlining the key resources involved: Resource Group, Service Principal (used to provision and manage the AKS cluster securely), Azure Key Vault (to store Service Principal secrets), and the AKS cluster itself. It establishes the workflow where Terraform provisions these resources, and then the secret credentials stored in Key Vault enable secure deployments and maintenance.

- **03:40 - 06:50: What Are Terraform Modules and Their Benefits**  
  Modules are reusable blocks of Terraform code designed to avoid repetition. Instead of defining an AKS cluster multiple times, a module lets you instantiate it with different parameters for multiple clusters. The video categorizes modules into **local modules** (created and used within the project) and **remote modules** (published to registries, either public or private). The explanation includes how modules simplify maintenance and make code scalable.

- **06:50 - 09:40: Understanding Root Module and Calling Child Modules**  
  The video explains the **root module**—the main Terraform directory where you run Terraform commands—and how it calls **child modules** via the `module` block. It shows setting the `source` directory for child modules and passing input variables. It also covers establishing explicit dependencies to control resource creation order, e.g., creating the Resource Group before the Service Principal.

- **09:40 - 13:30: Service Principal Module Walkthrough**  
  The **service principal custom module** includes resources like Azure AD application, service principal, and its password, mimicking manual Terraform resource definitions but wrapped as reusable code. It outputs sensitive values like `client_id` and `client_secret` to pass on securely to other parts of code, especially for Key Vault integration.

- **13:30 - 16:20: Role Assignment and Key Vault Module Insights**  
  Demonstrates assigning a **Contributor role** to the service principal with an explicit dependency to prevent ordering errors. Showcases creating a **Key Vault** module to securely store the service principal secrets (`client_id` and `client_secret`) as secrets, emphasizing secure credential management practices.

- **16:20 - 20:40: AKS Module Internal Structure and Enhancements**  
  Discusses the AKS cluster provisioning module, including fetching the latest Kubernetes version dynamically using data sources with a suggestion to optionally allow users to specify a version. It covers defining node pools, labels, autoscaling parameters, SSH key authentication—with a recommendation to generate SSH keys using Terraform's `tls_private_key` resource rather than local keys—and network configuration details.

- **20:40 - 22:10: Kubernetes Config Generation and Terraform Plan/Apply Walkthrough**  
  Explains creating a kubeconfig file dynamically after the cluster creation to authenticate and connect to the AKS cluster easily. Performs Terraform `plan` and `apply` commands, indicating the creation of multiple resources spanning resource groups, service principal, Key Vault, secrets, and the AKS cluster itself, illustrating modular resource orchestration.

- **22:10 - 25:20: Verifying Resources and Cluster Health**  
  Shows validation steps in Azure Portal, confirming the creation of AKS cluster resource groups, node pools, and health status of pods and components. Discusses expected initial warnings due to node warm-up.

- **25:20 - 29:20: Deploying a Real-world Application on AKS & Final Advice**  
  Introduces an open-source Kubernetes microservices project Bank of Anthos (a sample online banking system) for deployment on the AKS cluster. The video encourages hands-on deployment of the app using Kubernetes manifests, either via Terraform provisioners or CI/CD pipelines for further learning and project scaling. It concludes by urging viewers to understand the modular approach in-depth and apply it to real projects.

### Key Terms and Definitions 📚

- **Terraform Module:** A self-contained Terraform configuration that can be reused anywhere in the same or different projects to organize and simplify infrastructure code.
- **Root Module:** The main Terraform directory containing the default configuration files; acts as the entry point during Terraform execution.
- **Child Module:** A module called from within another module (usually root) to manage specific infrastructure components.
- **Service Principal:** A security identity used by apps, services, and automation tools to access specific Azure resources.
- **Azure Key Vault:** A cloud service to securely store and access secrets like passwords, tokens, and certificates.
- **Contributor Role:** An Azure role granting full access to manage all resources but doesn't allow access to user assignments.
- **Data Source:** A Terraform block that retrieves information from an external source but does not manage or create resources.
- **Kubeconfig File:** A YAML file that stores cluster connection info and credentials to communicate with Kubernetes clusters.
- **Terraform Output Variable:** Variables declared to pass data from modules back to the root module or other modules, often used for sensitive information sharing.
- **TLS Private Key Resource:** A Terraform resource to generate private keys dynamically for SSH authentication.

### Reasoning Structure 🔍

1. **Premise:** Need to provision multiple Azure resources (Resource Group, Service Principal, AKS cluster) repeatedly across projects.  
   → **Reasoning:** Define these resources once as a module.  
   → **Conclusion:** Reusable modules reduce code duplication, improve maintainability, and enforce best practices.

2. **Premise:** Service Principals require secure handling of secrets.  
   → **Reasoning:** Store sensitive service principal credentials securely in Azure Key Vault rather than exposing them.  
   → **Conclusion:** Enhances security posture of infrastructure management.

3. **Premise:** AKS clusters need to be provisioned with dynamic version control.  
   → **Reasoning:** Use Terraform data sources to get the latest Kubernetes version but allow overriding via variables.  
   → **Conclusion:** Provides flexibility and ensures clusters run supported versions.

4. **Premise:** Terraform executes resource creation concurrently by default.  
   → **Reasoning:** Add explicit dependencies where necessary (e.g., Role Assignment depends on Service Principal creation).  
   → **Conclusion:** Avoids provisioning errors and resource conflicts.

### Examples 🛠️

- **Service Principal Creation:** The module creates an Azure AD application and service principal along with generating a client secret, outputting these sensitive credentials for later usage in the Key Vault module.
- **AKS Module Use:** Instead of repeating complex AKS resource blocks for each cluster, the module is called with different parameters (e.g., cluster name, location) to provision multiple clusters efficiently.
- **Bank of Anthos Deployment:** Using the provisioned AKS cluster, deploy a sample microservices banking app containing front-end, backend, and database pods, demonstrating how infrastructure provisioning links to application deployment.

### Error-prone Points ⚠️

- **Misunderstanding:** Assuming Terraform modules are only for large projects.  
  **Correction:** Even a single reusable component benefits from modularization to simplify code and maintenance.
- **Misunderstanding:** Overusing modules unnecessarily.  
  **Correction:** Use modules judiciously; don't create modules for every small resource—balance complexity and maintainability.
- **Misunderstanding:** Ignoring explicit dependencies causing resource creation errors.  
  **Correction:** Define dependencies explicitly where resource creation order matters (e.g., role assignments depend on service principal existence).
- **Misunderstanding:** Managing secrets insecurely or exposing credentials in outputs.  
  **Correction:** Always store sensitive data in secure services like Azure Key Vault and use Terraform `sensitive` outputs to avoid accidental exposure.
- **Misunderstanding:** Using hardcoded Kubernetes versions leading to version mismatches.  
  **Correction:** Use Terraform data sources with optional user-specified overrides for reliable versioning.

### Quick Review Tips / Self-test Exercises 📝

**Tips (no answers):**  
- What is the difference between a root module and a child module in Terraform?  
- Why is it important to store service principal secrets in Azure Key Vault?  
- How does Terraform ensure the order of resource creation when dependencies are not explicit?  
- What are the benefits of using modules for replicating infrastructure components like AKS clusters?  
- How can you dynamically fetch the latest Kubernetes version for AKS cluster provisioning?  

**Exercises (with answers):**  
1. **Q:** What Terraform block lets you reuse configuration code multiple times?  
   **A:** A Terraform **module**.

2. **Q:** In Terraform, how do you pass values from a child module back to the root module?  
   **A:** Using **output variables** defined in the child module.

3. **Q:** Why do you need to create an explicit dependency when assigning a role to a service principal?  
   **A:** To ensure the **service principal exists before** the role assignment is attempted, preventing errors.

4. **Q:** Name one way to securely store secrets generated by Terraform.  
   **A:** Store them in **Azure Key Vault** as secrets.

5. **Q:** What Terraform resource can generate SSH keys dynamically?  
   **A:** The **`tls_private_key`** resource.

### Summary and Review 🔄
This video presents a comprehensive walk-through of **Terraform custom modules** for provisioning an AKS cluster and supporting Azure infrastructure components. Modules are emphasized as the clean, reusable, and scalable way to manage infrastructure code efficiently. The stepwise design covers resource group creation, service principal management, secret handling using Azure Key Vault, and dynamic AKS cluster provisioning with version and SSH key enhancements. It culminates in deploying a multi-microservice Kubernetes application, demonstrating an end-to-end real-world infrastructure-as-code project. This approach reflects industry best practices and prepares learners to build secure, maintainable, and extensible cloud environments using Terraform.

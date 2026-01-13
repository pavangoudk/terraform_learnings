## Deploying Azure Web Apps with Terraform: Blue-Green Deployment Mini Project

### Overview 📝
This video is a practical tutorial that walks through creating and managing Azure web app resources using Terraform. It focuses on deploying a web application in Azure App Service with a blue-green deployment strategy to minimize downtime during application updates. The instructor explains how to set up core Azure resources such as Resource Groups, App Service Plans, Web Apps, and deployment slots. Throughout, the explanation mixes live coding with troubleshooting, version compatibility considerations, and best practices for deployment automation and resource cleanup. This session is valuable for learners who want an end-to-end, stepwise demonstration of Terraform usage on Azure with a focus on practical cloud DevOps patterns.

### Summary of Core Knowledge Points ⏳

- **00:00 - 03:30 | Setting Up Azure Resources and Project Outline**  
  The tutorial starts by explaining the objective: to create an Azure Resource Group, an App Service Plan, a web app along with two deployment slots (production and staging), and perform a blue-green deployment swap to minimize downtime. The instructor outlines the necessary Terraform resources and how these will support deploying different versions of the app.

- **03:30 - 07:00 | Writing Terraform Configuration for Resource Group and App Service Plan**  
  A new Terraform file (`main.tf`) is created to define resources. Variables like `prefix` are introduced for resource naming consistency. The Resource Group includes mandatory fields (name, location). The App Service Plan is configured with considerations about deprecated and updated resource types in Terraform AzureRM provider, including SKU tiers to enable deployment slots (Standard or Premium).

- **07:00 - 13:00 | Handling Deprecated vs New Terraform Resources for App Service Plan**  
  The instructor navigates Azure provider documentation to detect deprecation warnings and new resource types. Discussion centers on the switch from `azurerm_app_service_plan` to `azurerm_service_plan` and SKU configurations including tier and size options. The necessity to align Terraform config with valid resource names and attributes to avoid errors is emphasized.

- **13:00 - 20:00 | Creating Azure Linux Web App and Deployment Slots**  
  Use of updated Terraform resources is explained: switching to `azurerm_linux_web_app` instead of the deprecated `azurerm_app_service`. Unique web app naming is stressed because Azure generates domain names from it. Deployment slots are added via `azurerm_linux_web_app_slot` resource. The need for certain fields and site configuration blocks is mentioned to avoid errors.

- **20:00 - 29:00 | Applying Configuration, Resource Cleanup, and Deploying Sample Application**  
  Tutorial showcases running `terraform apply`, handling resource cleanup manually since some were pre-existing, and deploying a sample .NET Core app from a forked GitHub repo. Troubleshooting runtime version issues emerges here: the .NET version defaulting incorrectly causing deployment failures. Various configuration attempts to fix NET version are discussed.

- **29:00 - 35:00 | Downgrading Provider & Workarounds for .NET Compatibility**  
  Faced with compatibility problems in new resources and provider versions, the instructor reverts to earlier resource types that work better for legacy .NET deployments despite deprecation warnings. This pragmatic approach highlights real-world challenges integrating cutting-edge Terraform features with existing technology stacks.

- **35:00 - 42:00 | Deploying App to Production and Staging Slots via Terraform SCM Resources**  
  Detailed configuration for automated deployment through Terraform-based source control management (`azurerm_app_service_source_control` and `azurerm_app_service_slot_source_control`) is added. Different repository branches deploy to separate slots mimicking blue-green deployment. The instructor explains setting up repo URL, branch, and linking with slots.

- **42:00 - 47:30 | Performing Blue-Green Deployment Swap and Best Practices**  
  The swap step switches traffic between staging and production slots using `azurerm_web_app_active_slot` resource to avoid downtime. Manual swap demonstration in Azure portal clarifies the process. Keeping the swap step separate from other deployments in CI/CD pipelines with manual approval is recommended to reduce risk. Finally, resource destruction advice is emphasized to avoid unnecessary cloud costs.

### Key Terms and Definitions 🔑
- **Azure Resource Group**: Logical container in Azure that holds related resources for an application.  
- **App Service Plan**: Defines compute resources (machine size, tier) for hosting web apps in Azure App Service.  
- **Azure Web App (App Service)**: Platform-as-a-Service offering to host web applications in Azure.  
- **Deployment Slots**: Separate deployment environments for Azure Web Apps used for staging/testing different versions before swapping.  
- **Blue-Green Deployment**: A deployment practice where two production environments (blue and green) run different versions to enable instant traffic switch with zero downtime.  
- **Terraform AzureRM Provider**: The Terraform plugin to manage Azure resources declaratively.  
- **SKU (Stock Keeping Unit)**: Specifies the pricing tier and size of Azure App Service Plans (e.g., Standard S1, Premium P1).  
- **Source Control Management (SCM) in Azure App Service**: Integration points for automated deployments from code repositories.  
- **`terraform apply` / `terraform plan`**: Terraform commands to apply configuration changes or view proposed changes.  
- **Deprecated Resource**: Terraform resources or attributes marked obsolete and scheduled for removal in future versions.  

### Reasoning Structure 🧩
1. **Premise**: To deploy a web app on Azure capable of zero-downtime deployments, multiple Azure and Terraform resources are needed.  
2. **Reasoning**: Create a Resource Group to group resources → Define App Service Plan to specify compute size → Define Web App + slots to host app with staging → Deploy different app versions in respective slots → Swap active slot to redirect traffic with no downtime.  
3. **Conclusion**: This sequence results in a robust, automated blue-green deployment pipeline that can be managed by Terraform and integrated into CI/CD workflows, ensuring minimal downtime during application updates.

### Examples ⚙️
- Deploying a simple .NET sample app from a forked GitHub repository to Azure web app's production and staging slots.  
- Using two branches (`master` and a secondary branch) to simulate blue (production) and green (staging) deployments respectively.  
- Demonstrating manual swap in Azure portal versus automated slot swapping through Terraform resource `azurerm_web_app_active_slot`.  
These examples ground abstract concepts into tangible workflows that learners can replicate.

### Error-Prone Points ⚠️
- **Using deprecated Terraform resources**: New provider versions often deprecate existing resource names which may mismatch documentation and cause confusing warnings.  
- **NET runtime version mismatches**: Deployments failing with unsupported framework versions if site config is not properly set. Correct runtime must be specified either in Terraform config or Azure portal settings.  
- **Unique naming of web app**: Azure requires globally unique web app names; omission leads to deployment errors.  
- **Configuring SKU for deployment slots**: Deployment slots require Standard or Premium tiers, using lower tiers will cause failures.  
- **Incorrect resource attributes**: For example, misunderstanding SKU name settings or app service plan ID formatting can cause Terraform plan/apply errors.  
- **Manual deletion of pre-existing resources**: Terraform cannot manage or destroy resources created outside its control, requiring manual cleanup to avoid conflicts.

### Quick Review Tips / Self-Test Exercises 🔄
**Tips (No Answers):**  
- What is the purpose of an Azure App Service Plan?  
- Why are deployment slots important in blue-green deployments?  
- What Terraform resource types replaced `azurerm_app_service` and `azurerm_app_service_plan` in newer AzureRM provider versions?  
- How can you manage different versions of the application using Terraform and Azure deployment slots?  
- What are common runtime version issues when deploying .NET apps to Azure Web Apps and how do you fix them?  

**Exercises (With Answers):**  
1. _Fill in the blank_: In Terraform, the resource type to create an Azure Resource Group is `azurerm________.`  
   **Answer**: resource_group  
2. _True or False_: Deployment slots can be created with any App Service Plan tier.  
   **Answer**: False; slots require Standard or Premium tiers.  
3. _Multiple-choice_: Which Terraform resource is used to swap deployment slots programmatically?  
   - a) azurerm_app_service_slot_swap  
   - b) azurerm_web_app_active_slot  
   - c) azurerm_app_service_deployment  
   **Answer**: b) azurerm_web_app_active_slot

### Summary and Review 🔍
This video thoroughly guides you through setting up a robust Azure web application deployment environment with Terraform, focusing on implementing blue-green deployment practices. It covers initializing necessary Azure infrastructure components, deploying multiple app versions to distinct deployment slots, troubleshooting runtime and resource deprecation issues, and automating deployment and swap actions. Practical demonstrations supplemented by live troubleshooting deepen understanding of cloud infrastructure lifecycle management and highlight important Azure and Terraform nuances. By mastering this, you build a foundation for reliable, zero-downtime web app deployments on Azure, integrated seamlessly with Infrastructure-as-Code and CI/CD pipelines.

## Implementing Azure Functions with Terraform: Mini Project on QR Code Generator

### Overview 📘
This video demonstrates how to implement Azure Functions using Terraform, focusing on a practical mini project—a QR code generator. The tutorial combines infrastructure provisioning with actual deployment of a Node.js Azure Function that generates QR codes based on user input URLs. Starting from setting up Terraform resources (Resource Group, Storage Account, App Service Plan, Azure Linux Function App), the video guides through referencing official Terraform provider documentation, configuring runtime environments, deploying function code via Azure CLI, troubleshooting common errors, and testing the deployed function. The presenter emphasizes practical steps, error handling, and integration with Azure storage, providing a solid hands-on introduction for learners familiar with Azure Functions basics and eager to use Terraform for infrastructure as code.

### Summary of core knowledge points ⏱️

- **00:00–03:04: Introduction and Project Overview**
  - The presenter introduces the video as part of a Terraform series, focusing on Azure Functions implemented with Terraform.
  - The mini project QR code generator is introduced as a simple, practical example to combine function app provisioning and code deployment.
  - Important Terraform Azure resources needed: Resource Group, Storage Account, App Service Plan, and an Azure Linux Function App.
  - Reference to Azure Functions fundamentals and Terraform documentation is encouraged for background knowledge.

- **03:05–07:56: Setting Up Terraform Configuration**
  - Terraform code structure is built with provider and backend files reused from previous lessons.
  - Discussion on Resource Group naming, Storage Account properties (unique names, replication type), and the Azure Function App settings.
  - Explanation on specifying runtime environment versions (Node.js 18 here) via the `site_config` and `application_stack` blocks in Terraform.
  - Correct referencing of variables and interdependencies between resource definitions.

- **08:00–13:30: Terraform Plan and Apply, Initial Deployment**
  - Running `terraform plan` and `terraform apply` to provision infrastructure.
  - Overview of the three main resources provisioned—resource group, storage account, app service plan, and function app.
  - Introduction of a pre-built Node.js Azure Function app QR code generator from GitHub to deploy onto the provisioned infrastructure.
  - Step to clone the project repo, manage dependencies, and prepare local settings json to provide storage account connection string.

- **13:31–20:00: Deploying Function Code with Azure CLI**
  - Steps to configure `local.settings.json` with storage connection string, fetched securely from Azure portal.
  - Use of Azure Functions Core Tools CLI (`func`) to publish both code and settings to the Azure Function App.
  - Emphasis on keeping sensitive settings like connection strings out of source control using `.gitignore`.
  - Explanation of deployment success verification via Azure Portal logs.

- **20:01–27:00: Testing the Azure Function and Troubleshooting**
  - Description of calling the deployed function with HTTP GET requests, providing a URL query parameter to generate a QR code.
  - Common errors encountered: 404 Not Found, 500 Internal Server Error due to missing module dependencies.
  - Demonstration of interpreting Azure activity logs and function logs for diagnosing runtime errors.

- **27:01–35:48: Error Diagnosis—Missing Dependencies**
  - Deep dive into SSH-ing into the App Service environment for log inspection.
  - Identification that error Cannot find module QR code is due to missing Node.js dependencies (`npm install` step not done before deployment).
  - Explanation of importance of running `npm install` locally before pushing the code.
  - Suggestion to restart function app service after deployments.

- **35:49–41:39: Final Fixes and Validation**
  - Final fix applied: running `npm install` locally, pushing updated code, rotating storage account keys and updating them in `local.settings.json`, publishing updated settings, and restarting function app.
  - Successful generation of QR codes on HTTP requests, with performance explanation (cold start latency).
  - Preview of generated QR code stored in Azure Blob Storage.
  - Recommendations for further project enhancement: setting up automated CI/CD pipelines using Azure DevOps as covered in previous videos.
  - Summary highlighting learnings, especially dependency management and correct configuration as key success factors.

### Key terms and definitions 📚
- **Azure Functions**: Serverless compute service to run event-driven code without managing infrastructure.
- **Terraform**: Infrastructure as Code tool to provision cloud resources declaratively.
- **Resource Group**: A container in Azure that holds related resources for an application.
- **Storage Account**: Azure service providing scalable cloud storage for blobs, files, queues, and tables.
- **App Service Plan**: Defines the compute resources for hosting web apps and functions.
- **Azure Linux Function App**: Linux-based Azure Function hosting environment supporting various runtimes.
- **`local.settings.json`**: Configuration file for local Azure Function settings, including connection strings, not committed to source control.
- **`terraform plan`**: Command showing planned resource changes without applying them.
- **`terraform apply`**: Command to create or update resources in Azure based on Terraform configuration.
- **`func azure functionapp publish`**: Azure Functions CLI command to deploy function code to Azure.
- **npm install**: Node.js package manager command to download and install dependencies defined in `package.json`.
- **Cold start**: Delay incurred when a serverless function is invoked after a period of inactivity.
- **Blob Storage**: Azure storage service optimized for storing large amounts of unstructured data like images, videos or files.

### Reasoning structure 🔍
1. **Premise:** Need to deploy Azure Functions infrastructure and code using Terraform and Azure CLI.  
   → **Reasoning:** Define and provision required Azure resources with Terraform (Resource Group, Storage Account, App Service Plan, Function App).  
   → **Conclusion:** Infrastructure ready to host Azure Function.

2. **Premise:** Function code depends on Node.js packages and requires storage account connection string.  
   → **Reasoning:** Configure project locally with `npm install` and `local.settings.json` containing storage keys, then deploy code and settings separately.  
   → **Conclusion:** Code can execute successfully with correct dependencies and configuration.

3. **Premise:** Error occurs (module not found) and function runtime logs show deployment success but runtime failure.  
   → **Reasoning:** Investigate logs, discover missing npm dependencies, implying they were not bundled before pushing.  
   → **Conclusion:** Running `npm install` locally before publishing fixes runtime errors.

4. **Premise:** Initial storage account keys are compromised or incorrect causing authentication errors.  
   → **Reasoning:** Rotate storage keys in Azure portal, update local settings, re-publish settings to Azure.  
   → **Conclusion:** Authentication errors resolved.

5. **Premise:** Function deployed and running, but initial requests are slower than subsequent ones.  
   → **Reasoning:** Cold start effect in serverless functions explains latency difference.  
   → **Conclusion:** Understanding of Azure Functions performance characteristics acquired.

### Examples 💡
- **QR Code Generator App:** A Node.js Azure Function that accepts a URL via HTTP request, generates a QR code image, stores it in blob storage, and returns a download link.  
  - This illustrates a real-world practical use case, covering HTTP triggers, storage interaction, and deployment.
- **Storage Account Connection String Configuration:** Using local.settings.json to store and inject sensitive Azure Storage keys into the function environment, demonstrating secure configuration management.
- **Troubleshooting Missing Modules:** Missing npm install step leading to runtime error; resolving by installing dependencies locally before pushing.
- **Cold Start Concept:** Measured longer execution time on first request vs subsequent requests to the function, illustrating serverless environment behavior.

### Error-prone points ⚠️
- **Misunderstanding:** Assuming Terraform alone deploys function code.  
  **Correct:** Terraform provisions infrastructure, but code deployment requires additional CLI tools (`func`).
- **Misuse:** Not running `npm install` before deploying code, leading to “module not found” errors.  
  **Correct:** Always run `npm install` locally to bundle dependencies before deployment.
- **Connection String Handling:** Committing `local.settings.json` with sensitive keys into source control.  
  **Correct:** Add local.settings.json to `.gitignore` to keep secrets safe.
- **Storage Account Name Uniqueness:** Failure due to duplicate or invalid storage account names (length > 24 chars).  
  **Correct:** Choose unique and compliant storage account names.
- **Function URL Construction:** Incorrect HTTP request endpoints causing 404 errors.  
  **Correct:** Ensure request URLs include correct API path and function name.
- **Not Restarting Function App after Deployment:** Runtime errors persisting until restart.  
  **Correct:** Restart function app service after deployment to ensure new code and config are loaded.

### Quick review tips/self-test exercises 📝

**Tips (No answers):**  
- What are the core Azure resources needed to deploy an Azure Function with Terraform?  
- Why is the `npm install` step crucial before deploying a Node.js Azure Function?  
- How do you securely provide Azure Storage connection strings to your function app?  
- What steps must you follow to deploy function code and settings separately using Azure CLI?  
- What is a cold start in the context of serverless Azure Functions?  

**Exercises (With answers):**  
1. **Q:** Which Terraform resource type is used to create a hosting environment suitable for Linux-based Azure Functions?  
   **A:** `azurerm_linux_function_app`

2. **Q:** Name two deployment commands needed to push an Azure Function's Node.js code and its settings using Azure Functions Core Tools.  
   **A:** `func azure functionapp publish <app-name>` (for code) and `func azure functionapp publish <app-name> --publish-settings-only` (for settings)

3. **Q:** What common error results from omitting `npm install` before publishing a Node.js Azure Function?  
   **A:** Cannot find module runtime errors due to missing dependencies.

4. **Q:** What is one security measure to avoid exposing storage account keys in source repos?  
   **A:** Add `local.settings.json` to `.gitignore` and do not commit it.

5. **Q:** If an Azure Function app returns 500 Internal Server Error but deployment logs show success, where should you inspect for root causes?  
   **A:** Check function runtime logs and App Service environment logs, possibly via SSH or Azure Portal logs.

### Summary and review 🔄
This tutorial guided through provisioning Azure Functions infrastructure with Terraform, deploying Node.js function code that generates QR codes, and managing key configurations like storage connection strings securely. Important learnings include understanding the Terraform setup for Resource Group, Storage Account, App Service Plan, and Azure Linux Function App; the need for dependency management via `npm install`; usage of Azure Functions Core Tools for deployment; error troubleshooting via logs; and function testing with HTTP requests. The project offers a concise yet comprehensive example blending infrastructure as code with serverless app deployment, reinforcing best practices and revealing common pitfalls. This solid foundation supports future scaling to automated CI/CD pipelines and more elaborate Azure Functions scenarios.

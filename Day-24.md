## Importing and Managing Existing Azure Resources with Terraform: Practical Guide

### Overview 📚
This video provides an in-depth walkthrough on how to import existing cloud infrastructure, specifically Azure resources, into Terraform for ongoing management. Rather than building infrastructure from scratch, it focuses on transitioning manually created resources into Terraform's control through **terraform import** and related tools. The instructor uses a hands-on example of an Azure web app environment to demonstrate how to align real-world deployed resources with Terraform configurations. The explanation covers the native Terraform approach, plus two automated export utilities, highlighting their pros, cons, and practical considerations in a production setting.

### Summary of Core Knowledge Points ⏱️

- **00:00 - 02:10 | Introduction to Terraform Importing**
  - The video sets the stage by explaining the need to import live Azure resources into Terraform to manage them declaratively going forward.
  - It briefly mentions existing approaches: native `terraform import`, Microsoft’s `aztfexport` tool, and Google’s `terraformer`.
  - Emphasis: importing enables Terraform to take control of infrastructure not originally created with Terraform.

- **02:10 - 06:40 | Native Terraform Import Approach Overview**
  - The instructor introduces the workflow: first write Terraform resource configurations matching existing Azure resources, then use `terraform import` to map each live resource to its Terraform counterpart.
  - Highlight: It requires writing code manually in a **top-down order** (resource group ➔ virtual network ➔ subnet ➔ app service plan ➔ web app).
  - Verification is done via `terraform state show` to confirm resources are tracked in Terraform’s state file.

- **06:40 - 14:30 | Hands-on: Importing Azure Resource Group and Virtual Network**
  - Creation of `main.tf` with resource group and virtual network resource blocks using variables for names and locations.
  - Running `terraform init`, `terraform plan` (shows planned resource creation since state is empty).
  - Executing `terraform import azure_rm_resource_group.rg <resource_id>` to import resource.
  - Verifying import success with `terraform state list` and `terraform state show`.
  - Similar steps repeated for importing the Azure virtual network.

- **14:30 - 21:30 | Continuing Imports: Subnet, App Service Plan, and Web App**
  - Further Terraform resource blocks created for subnet with correct address prefix.
  - App service plan resource defined with updated provider resource name (`azure_rm_service_plan` replacing deprecated `azure_rm_app_service_plan`) including OS type and SKU.
  - Linux web app resource defined with site config including node version to match deployed app.
  - Each resource imported individually with their Azure resource IDs.
  - After all imports, running `terraform plan` ideally shows **zero changes**, indicating live resources match Terraform desired state.

- **21:30 - 27:30 | Removing Imported Resources from Terraform State**
  - Demonstrates how to **remove** resources from Terraform management using `terraform state rm` if needed.
  - Removing all imports allows starting fresh or switching to alternative importing tools.

- **27:30 - 33:30 | Azure TF Export Tool Usage**
  - Introduces Microsoft’s `aztfexport` utility for automating export of Azure resources to Terraform configurations and state.
  - Shows installation commands (`brew install` for macOS), basic usage, and output files.
  - Highlights the convenience of generating full Terraform configs quickly but warns of limitations such as hardcoded values and limited variable usage, requiring manual adjustments later.
  - Verification by running `terraform plan` and eventually destroying resources with `terraform destroy`.

- **33:30 - 38:50 | Manual Azure Resource Creation Script and Deployment**
  - Shows a simple Azure CLI bash script automating manual creation of the demo resources.
  - Demonstrates connecting Azure Web App to GitHub for continuous deployment or manual source setup through Azure Portal deployment center.

- **38:50 - 43:00 | Terraformer Tool Overview**
  - Presents Google’s open-source `terraformer` as a multi-cloud resource exporter.
  - Explains authentication methods and supported Azure services.
  - Commands for importing, filtering resources, and generating Terraform configurations.
  - Notes tool limitations and unofficial status; useful for quick exports but not recommended for production-critical import tasks.

- **43:00 - 45:00 | Final Cleanup & Key Takeaways**
  - Running `terraform destroy` to clean up the resources imported and created during the demonstration.
  - Addresses common issues like undeletable custom hostname bindings by removing them from Terraform state before destroying.
  - Reiterates the recommendation to use native `terraform import` for production, while the export tools are helpful for learning and quick tests.

### Key Terms and Definitions 🔑

- **Terraform Import**: A native Terraform command that allows existing infrastructure to be brought under Terraform management by linking live resources to Terraform configuration and state.
- **Terraform State File**: The local or remote file where Terraform keeps track of resources it manages, ensuring synchronization between the declared infrastructure and actual deployment.
- **Azure Resource Group**: A container in Azure that holds related resources for an Azure solution, providing logical grouping.
- **Azure RM Provider**: The Terraform provider for Microsoft Azure Resource Manager, enabling Terraform to manage Azure resources.
- **aztfexport**: An open-source tool by Microsoft designed to export Azure resources into Terraform configuration files and state automatically.
- **Terraformer**: An open-source project by Google that auto-generates Terraform files from existing cloud resources for multiple providers, including Azure.
- **Site Config Block (in Azure Web App)**: A configuration structure within Terraform representing settings like application stack and node version for web applications.
- **Top-Down Approach (Terraform Import)**: Writing Terraform configurations in a hierarchical order starting from fundamental resources like Resource Groups, proceeding to dependencies like Virtual Networks, subnets, and then to services like App Service Plans and Web Apps.

### Reasoning Structure 🔍

1. **Premise:** Resources exist in Azure but were created outside Terraform using CLI or portal.
2. **Hypothesis:** To manage these existing resources with Terraform, we must import them.
3. **Reasoning:** 
   - Terraform requires configuration files matching actual deployed resource properties.
   - Top-down resource creation order prevents dependency conflicts.
   - Resources are imported individually with their full Azure Resource IDs to bind state.
4. **Conclusion:** Once imported and verified, Terraform can manage these resources fully, including planning, applying updates, and destroying.

### Examples 👨‍💻

- **Real-time Example:** Importing an existing Azure Resource Group named `day24-RG`:
  - Write a Terraform resource block matching the Resource Group.
  - Use the Azure Portal to retrieve the Resource ID.
  - Run `terraform import azure_rm_resource_group.rg <resource_id>` to link it.
  - Validate with `terraform state show` and `terraform plan` showing zero changes.

- **CLI Bash Script:** For manual resource creation mimicking imported resources, a script uses Azure CLI commands to create resource group, virtual network, subnet, app service plan, and web app, simulating the initial environment pre-import.

### Error-prone Points ⚠️

- **Misunderstanding:** Assuming `terraform plan` will immediately show zero changes before importing resources.
  - **Correction:** Without importing, Terraform doesn't know about existing resources hence indicates they need to be created.

- **Misunderstanding:** Ignoring the top-down order when writing Terraform configurations leading to errors resolving resource dependencies.
  - **Correction:** Always create foundational resources like resource groups and virtual networks before dependent ones.

- **Misunderstanding:** Believing tools like `aztfexport` or `terraformer` produce production-ready code automatically.
  - **Correction:** These tools generate basic configuration that may include hardcoded values and sensitive info; manual refinement is needed for production.

- **Mistake:** Forgetting to remove problematic auto-generated resources (e.g., custom hostname bindings) from Terraform state before destroying, causing destroy operation failures.
  - **Correction:** Use `terraform state rm` to unmanage such resources before destruction.

### Quick Review Tips / Self-Test Exercises 🎯

**Tips (No Answers):**

- What command links an existing Azure resource to Terraform state?
- Why must Terraform resource files be written in a top-down order before importing?
- Name two tools other than `terraform import` that export Azure resources to Terraform configurations.
- How do you verify that Terraform successfully imported a resource?
- What must you do before running `terraform destroy` on previously imported resources?

**Exercises (With Answers):**

1. **Q:** You have a resource group `prod-rg` created manually. How do you import it into Terraform state?
   **A:** Write a Terraform resource block for the resource group, retrieve its Resource ID from Azure Portal, then run `terraform import azure_rm_resource_group.<name> <resource_id>`.

2. **Q:** What does running `terraform plan` show immediately after writing configuration files but before import?
   **A:** It shows resources planned to be created because Terraform state does not yet know about existing resources.

3. **Q:** After importing a resource, how do you check its details within Terraform?
   **A:** Use `terraform state show <resource_name>` to view imported resource attributes.

4. **Q:** Name a key limitation of using automated exporters like `aztfexport`.
   **A:** Generated resources have hardcoded values and may require manual refactoring for variables and secret handling.

5. **Q:** What command removes a resource from Terraform state without destroying it?
   **A:** `terraform state rm <resource_name>`

### Summary and Review 🔄

This session emphasized importing and managing existing Azure cloud infrastructure using Terraform, focusing on the **native terraform import** process. By first writing Terraform configuration files to reflect existing resources and then using `terraform import` with resource IDs, you enable Terraform to manage live environments seamlessly. While utilities like `aztfexport` and `terraformer` simplify initial code generation, they introduce limitations and are not advised for production. Crucially, managing state carefully—especially removing problematic resources—and following a logical top-down configuration approach ensure smooth imports. Beyond importing, the video also covered manually recreating and deploying resources, allowing a full lifecycle Terraform management for previously unmanaged environments. This knowledge empowers infrastructure engineers to adopt Infrastructure as Code best practices even with pre-existing legacy or manual cloud setups.

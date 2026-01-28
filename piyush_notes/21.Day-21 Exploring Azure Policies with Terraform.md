## Exploring Azure Policies with Terraform: Mini Project Walkthrough

### Overview 📚
This video is part of a Terraform-focused series aiming to simplify infrastructure as code with practical mini projects. Specifically, it teaches how to create and enforce **Azure Policies** using Terraform, which are critical for governing compliance, cost control, and configuration standards across Azure subscriptions. The instructor demonstrates hands-on how to define **multiple kinds of policies** (location restrictions, mandatory tagging, VM size limitations), assign them to Azure subscriptions, and validate enforcement. The teaching style is pragmatic, combining code walkthroughs, debugging attempts, and live testing to emphasize real-world application and problem-solving.

### Summary of core knowledge points ⏱️

- **00:00 - 02:21 — Introduction & Use Case for Azure Policies**
  - The video introduces three critical policy types: allowed locations (restrict resource locations), mandatory tags (enforce resource metadata), and allowed VM sizes (control cost and compliance).
  - Azure Policy differs from validation in Terraform variables by being a strict enforcement mechanism applied at the subscription level rather than a suggestion.

- **02:21 - 06:46 — Setting Up Terraform for Azure Policy**
  - The instructor sets up the Terraform environment with a backend and provider.
  - Demonstrates how to fetch the current Azure subscription as a data source.
  - Defines three Terraform variables for allowed locations, VM sizes, and mandatory tags (using list and set types).
  - Explains choosing data types and setting default values for convenient policy parameterization.

- **06:46 - 11:02 — Defining the Mandatory Tag Policy**
  - Walks through writing a custom Azure RM policy definition resource in Terraform.
  - Explains the JSON-like `policy_rule` structure with logic: if tags are missing then deny.
  - Shows crafting conditions with `anyOf` and `exists` operators for tag presence.
  - Highlights trial-and-error fixing of Terraform JSON syntax errors in the policy definition.

- **11:02 - 18:17 — Assigning Policy and Testing Compliance Enforcement**
  - Explains policy assignment by linking the policy definition to the subscription.
  - Runs `terraform plan` and `terraform apply` to deploy policy.
  - Creates a test resource group without required tags to induce a **policy violation**.
  - Adds mandatory tags incrementally to observe acceptance by Azure Policy.
  - Discusses challenges with referencing Terraform variables inside JSON policy rules, resorting to hardcoded values due to limitations.

- **18:17 - 26:56 — Working with JSON Encoding and HCL Interpolation**
  - Introduces the `jsonencode()` Terraform function to convert HCL syntax to JSON string required by Azure policies.
  - Explains the importance of correctly formatting strings without extra quotes for interpolation.
  - Fixes errors by switching between `jsondecode()` and `jsonencode()` and managing variable references correctly.

- **26:56 - 34:40 — Defining VM Size and Location Policies**
  - Copies the tag policy structure to create VM size and location policies.
  - VM size policy checks if the VM size is within a specified allowed list (not using negation but an inclusion check).
  - Location policy denies resources created outside allowed regions.
  - Demonstrates minor tweaks in policy_rule JSON to match resource fields for VM size and location.

- **34:40 - 39:52 — Assigning Remaining Policies and Azure Portal Validation**
  - Assigns VM size and location policies similarly.
  - Shows navigation in the Azure portal to observe policy compliance states for resources.
  - Notes that compliance evaluation cycles occur every 24 hours, so immediate results for resource group compliance may not show.
  - Creates new resources to effectively trigger and observe policy denial based on location restrictions.

- **39:52 - 40:38 — Summary and Encouragement to Experiment**
  - Recaps learning how to create policy definitions, assignments, test compliance enforcement, and understand Azure policy JSON and Terraform integration.
  - Encourages hands-on experimentation with the provided GitHub repo to deepen understanding through trial and error.

### Key terms and definitions 🔑

- **Azure Policy**: A governance tool in Azure that enforces rules over resources, automatically auditing or denying non-compliant resource deployments to maintain organizational standards.

- **Terraform AzureRM Provider**: The Terraform plugin that allows you to manage Azure resources declaratively.

- **Policy Definition**: The rule set written in JSON that specifies conditions and effects (e.g., deny, audit) for resources.

- **Policy Assignment**: The act of binding a policy definition to a scope, such as a subscription, resource group, or management group.

- **`jsonencode()`**: A Terraform function that converts HCL syntax to JSON string format, essential for embedding policy JSON structures in Terraform files.

- **`anyOf` Operator**: In Azure Policy JSON rules, a logical operator that checks if any listed condition is true.

- **`exists` Operator**: Used in policy rules to check for the presence or absence of a specified field (e.g., tag).

- **Resource Groups (RG)**: Azure containers for resources; policies assigned at subscription level affect all resources in RGs.

### Reasoning structure 🔍

1. **Premise:** We need to enforce organizational standards for resource creation (location, tags, VM size) on Azure.
2. **Process:**
   - Use Terraform to define reusable policy definitions specifying allowed resource parameters.
   - Assign these policies to the subscription scope in Terraform.
   - Attempt resource creation that violates policies.
3. **Conclusion:** Azure Policy engine audits and denies non-compliant resources during deployment, enforcing compliance automatically.

### Examples 📖

- Creating a Resource Group in Canada Central without the mandatory tags triggers a policy violation due to missing tags.
- After adding both required tags (department and project), the Resource Group creation succeeds, illustrating tag enforcement.
- Attempting to create a resource in a disallowed location such as Canada Central when only East US and West US are allowed results in denial.
- Testing VM size restriction with allowed sizes Standard_B2s and Standard_B2ms demonstrates limiting costly or unsupported VM flavors.

### Error-prone points ⚠️

- **Misunderstanding policy JSON formatting:** Azure policies expect JSON rules embedded within Terraform; using incorrect JSON syntax or extra commas causes errors.
- **Variable interpolation in policy rules:** Directly referencing Terraform variables in policy JSON does not work seamlessly; requires `jsonencode()` and careful formatting or hardcoding values.
- **Using `anyOf` with operators:** The policy logic requires understanding `anyOf` combined with `exists` or membership operators; incorrect clause nesting breaks rules.
- **Deployment timing for compliance:** Azure policy compliance evaluation occurs every 24 hours, so immediate compliance results might not show right after resource creation.

### Quick review tips/self-test exercises 🎯

**Tips (no answers):**

- What are the main types of Azure policies demonstrated?
- How does `jsonencode()` help when embedding JSON in Terraform code?
- Why is tagging enforcement critical in Azure policies?
- What does an Azure policy assignment require as parameters?

**Exercises (with answers):**


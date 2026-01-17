## Data Sources in Terraform: Understanding and Implementation (Day 13)

### Overview 📚
This video introduces the concept of **data sources** in Terraform, explaining their purpose, use cases, and practical implementation with a detailed Azure example. It focuses on how data sources enable referencing existing infrastructure components—like virtual networks and subnets—managed by different teams without recreating resources. The tutorial uses a real-world scenario involving a shared Azure virtual network managed by a network team and shows step-by-step how a devops engineer can provision a virtual machine within existing network setups via Terraform data sources.

### Summary of core knowledge points ⏱️

- **00:00 - 01:54: Introduction to data sources and organizational context**  
  - Data sources allow teams to reference existing infrastructure managed by others, avoiding duplication.  
  - Example: A shared Azure virtual network with multiple subnets managed by a network team across several environments (dev, test, prod) and teams.  
  - Different teams manage distinct parts of infrastructure; hence, developers use data sources to consume shared resources without re-creating them.

- **01:55 - 04:40: Real-world need for data sources in shared environments**  
  - For provisioning a VM, a DevOps engineer cannot create a new virtual network or subnet but must reference the existing ones.  
  - Data sources provide a way to import references of existing resources (virtual network, subnet, resource group) into Terraform configurations.  
  - This standardizes resource usage for compliance and process control, helping multiple engineers work cohesively.

- **04:41 - 09:45: Setting up Terraform code with data sources**  
  - Begin with existing Azure resources: resource group, virtual network, subnet.  
  - The Terraform file (main.tf) is created, and default resources for virtual network and subnet are removed to avoid duplication.  
  - Data sources are declared with the syntax: `data azurerm_virtual_network vnet_share { ... }` specifying the existing resource’s name and resource group.  
  - Resource group data, virtual network data, and subnet data blocks are configured to fetch existing infrastructure references.

- **09:46 - 12:35: Referencing data source outputs in resource configuration**  
  - Data source attributes like `name`, `id`, and `location` are accessed to configure new resources such as the VM, network interface, and others.  
  - For example, the subnet ID is provided to the VM’s network interface IP configuration to place it correctly within the existing subnet.  
  - Dynamic referencing avoids hardcoding of values like region/location, improving maintainability.

- **12:36 - 15:06: Terraform plan, validation, and correction**  
  - Initialization (`terraform init`) and planning (`terraform plan`) steps are executed; an error arises due to mistyped virtual network name.  
  - After correction, Terraform correctly plans to create only the virtual machine, network interface, and related resources but reuses existing virtual network and subnet.  
  - The apply step confirms successful creation, and validation via Azure Portal shows the VM is placed within the intended shared virtual network and subnet.

- **15:07 - 16:30: Summary and upcoming content**  
  - Summary of data source utility in Terraform for reusing existing infrastructure components.  
  - Encouragement for viewers to practice with the demo shown.  
  - Mention of next video focusing on mini-projects involving provisioning of multiple resources, emphasizing continued hands-on learning.

### Key terms and definitions 🔑

- **Data Source**: A Terraform configuration block that fetches information about existing resources managed outside the current Terraform configuration, allowing these to be referenced without recreating them.  
- **Resource Group (Azure)**: A container that holds related Azure resources for an Azure solution, organizing those resources for management and billing.  
- **Virtual Network (VNet)**: An Azure logical isolation network used to provision private networks and subnets.  
- **Subnet**: A segmented section of a virtual network, allowing separation of different applications or teams within the same network.  
- **Terraform Plan**: A command that previews changes Terraform will make to the infrastructure, allowing users to verify before application.  
- **Terraform Apply**: Executes the planned changes in the actual cloud or infrastructure environment.  
- **Reference Attribute**: A property provided by a data source or resource (like `id`, `name`, or `location`) that is used to link between different infrastructure components.

```tf
# Fetch an existing resource group
data "azurerm_resource_group" "shared_rg" {
  name = "your-shared-resource-group"
}

# Fetch an existing virtual network within that resource group
data "azurerm_virtual_network" "shared_vnet" {
  name                = "your-shared-vnet"
  resource_group_name = data.azurerm_resource_group.shared_rg.name
}

# Fetch an existing subnet within that virtual network
data "azurerm_subnet" "shared_subnet" {
  name                 = "your-shared-subnet"
  resource_group_name  = data.azurerm_resource_group.shared_rg.name
  virtual_network_name = data.azurerm_virtual_network.shared_vnet.name
}

# Create a new network interface in the shared subnet
resource "azurerm_network_interface" "vm_nic" {
  name                = "demo-vm-nic"
  location            = data.azurerm_resource_group.shared_rg.location
  resource_group_name = data.azurerm_resource_group.shared_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.shared_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a new VM using the network interface and resource group info from data
resource "azurerm_linux_virtual_machine" "demo_vm" {
  name                  = "demo-vm"
  location              = data.azurerm_resource_group.shared_rg.location
  resource_group_name   = data.azurerm_resource_group.shared_rg.name
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..." # Replace with your actual public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

```

### Reasoning structure 🧠

1. **Premise:** Existing network infrastructure is managed separately by a network team; other teams cannot create or alter it.  
   → **Reasoning:** To provision resources like VMs in this shared infra, developers need a way to reference existing resources without recreating.  
   → **Conclusion:** Terraform data sources provide this referencing functionality.

2. **Premise:** Terraform configuration initially contains resource creation blocks for virtual network and subnet that already exist.  
   → **Reasoning:** Creating these resources twice will cause conflicts; instead, they should be replaced with data source blocks.  
   → **Conclusion:** Remove resource blocks and add data source blocks pointing to existing infra identifiers.

3. **Premise:** Terraform resources (like VM) require location, subnet ID, and resource group to be specified.  
   → **Reasoning:** Accessing these values dynamically from data sources promotes consistency with existing infrastructure settings.  
   → **Conclusion:** Use `${data_resource.attribute}` references in resource blocks.

4. **Premise:** Mistyping or incorrect names in data source configuration result in Terraform errors or failure to find resources.  
   → **Reasoning:** Double-check names and use copy-paste from reliable sources to avoid errors.  
   → **Conclusion:** Accurate references are crucial for successful plan and apply.

### Examples 🔍

- **Shared Virtual Network with Multiple Subnets**: The example shows a shared Azure virtual network where six different subnets correspond to different teams or environments—Dev, Test, Prod, etc. This illustrates why teams must reference existing networking resources instead of creating new ones.  
- **Terraform Data Source for Azure Resource Group**: The video shows how to define a `data azurerm_resource_group` block to fetch an existing resource group named `shared network RG`, demonstrating how existing resource metadata (like location) can be obtained for reuse.  
- **Provisioning VM in Existing Network**: The VM configuration uses subnet ID and virtual network references pulled from data sources rather than defining new networking resources, showing practical use of data sources to maintain infra separation by team.

### Error-prone points ⚠️

- **Misnaming Resources**: A common mistake is incorrectly typing the existing resource names or resource group names, leading to resource not found errors. E.g., confusing the virtual network name which was `shared network vnet` but mistyped as `shared network RG`.  
  - **Correct answer:** Always verify names carefully, preferably copy-paste from Azure portal or CLI outputs.

- **Hardcoding Location vs. Referencing via Data Source**: Manually setting locations (e.g., `Canada Central`) can cause inconsistency if the existing resources are deployed elsewhere.  
  - **Correct answer:** Reference location dynamically from the data source representing the resource group or virtual network to maintain alignment.

- **Confusing when to use resource block vs. data source block**: Beginners might try to create a resource that already exists instead of referencing it, causing conflicts or duplication.  
  - **Correct answer:** Use resource blocks to create new infrastructure; use data source blocks to refer to existing infrastructure components.

### Quick review tips/self-test exercises 💡

**Tips (no answers)**  
- What is the role of a data source in Terraform?  
- How do you reference an existing subnet within your Terraform VM resource configuration?  
- Why is dynamic referencing of location important in multi-team environments?  
- Where do you find correct names and resource group details to configure data sources?

**Exercises (with answers)**  
1. Fill in the blank: In Terraform, to use an existing Azure Virtual Network, you configure a `data _________` block with the resource group and network name.  
   - **Answer:** azurerm_virtual_network

2. True or False: Terraform data sources create new resources in your cloud environment.  
   - **Answer:** False. Data sources only reference existing resources.

3. If Terraform throws an error Resource not found for a data source, what is the most likely cause?  
   - **Answer:** Incorrect resource name or resource group name specified in the data source block.

### Summary and review 🔄

This video thoroughly explains **Terraform data sources** as a crucial feature that allows seamless integration of shared resources managed by multiple teams, especially in complex organizational structures like Azure environments with segregated networking teams. It guides through the creation of data source blocks to reference existing resource groups, virtual networks, and subnets, and then how to consume these references to provision a new virtual machine within the shared infrastructure. The emphasis on avoiding duplication and ensuring compliance while enabling collaboration is key. The demonstrated hands-on example brings clarity to the conceptual understanding by walking through Terraform code setup, initialization, troubleshooting, and verification in the Azure Portal. This foundational knowledge prepares viewers for upcoming mini-projects involving complex infrastructure provisioning with Terraform.

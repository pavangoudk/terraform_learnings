## Understanding VNet Peering and Terraform Implementation in Azure

### Overview 🧑‍🏫
This video, part of a 28-day Terraform learning series, dives deep into the concept of Azure Virtual Network (VNet) Peering and demonstrates how to implement it using Terraform. The core focus is on setting up multiple VNets, establishing secure connectivity between them via peering, and deploying virtual machines within these networks to verify communication. Through a step-by-step Terraform coding session combined with a practical demo, the presenter explains key networking concepts such as address spaces, subnets, and peering relationships, culminating in testing connectivity and troubleshooting common pitfalls. The tutorial balances theory with hands-on application, perfect for learners progressing in Azure infrastructure as code.

### Summary of core knowledge points ⏱️
- **00:00 - 03:30 | Introduction to VNet Peering and Its Importance**  
  - Explained the need for connecting multiple VNets securely within Azure using VNet peering instead of routing traffic over the internet.  
  - Clarified that peering happens between entire VNets, not individual machines or subnets.  
  - Scenario: One shared VNet hosting resources like storage and VMs, and a separate test VNet requiring access to those resources, illustrating why peering is essential.

- **03:30 - 08:20 | Terraform Setup for Resource Group, Virtual Networks, and Subnets**  
  - Guided creation of an Azure Resource Group as a container for resources.  
  - Demonstrated declaring two VNets (`vnet1` and `vnet2`) with distinct CIDR address spaces (`10.0.0.0/16` and `10.1.0.0/16`).  
  - Defined subnets within each VNet with smaller CIDR blocks (`/24` mask) and explained subnet IP capacity calculations using CIDR notation.  
  - Highlighted the need for resource and location attributes and correct syntax to avoid Terraform errors.

- **08:20 - 16:40 | Establishing VNet Peering via Terraform**  
  - Showed how to establish bidirectional peering using two peering resources: from VNet1 to VNet2 and from VNet2 to VNet1.  
  - Explained the importance of referencing VNet IDs rather than names for remote network configuration.  
  - Validated Terraform plan output counting seven resources, confirming the full infrastructure set (resource group, VNets, subnets, peering connections).

- **16:40 - 26:30 | Creating Virtual Machines in Each Subnet**  
  - Added two virtual machines, one in each subnet, setting their configuration via Terraform.  
  - Discussed troubleshooting Terraform errors with OS disk naming conflicts due to resource name duplications and how to resolve them by renaming disks or recreating resources.

- **26:30 - 31:00 | Verifying Azure Resources and Peering Status in the Portal**  
  - Explored the Azure portal to confirm the provisioning of resources and check peering states.  
  - Highlighted “fully synchronized” status indicating functional peering links.

- **31:00 - 36:50 | Demonstrating SSH Access Using Azure Bastion Host**  
  - Explained limitations of directly SSH-ing into VMs without public IPs.  
  - Introduced the managed Azure Bastion service as a secure jump host for accessing VMs without exposing them publicly.  
  - Showed SSH login process using Bastion and validating private IP addresses.

- **36:50 - 40:00 | Testing Connectivity and Impact of Removing Peering**  
  - Performed ping and SSH tests between VMs across different VNets confirming successful connectivity due to peering.  
  - Illustrated effect of deleting peering: initial connection persistence due to caching, followed by connection failures after re-login, reinforcing need for active peering.

- **40:00 - 45:00 | Troubleshooting and Common Mistake Identification**  
  - Investigated unexpected connectivity despite absence of peering, discovering both VMs were mistakenly deployed in the same VNet.  
  - Emphasized correct addressing and subnet configurations to truly isolate VNets and validate peering necessity.

- **45:00 - 48:00 | Best Practices and Recommendations**  
  - Recommended use of variables and count/index in Terraform to reduce repetitive code for multiple similar resources.  
  - Suggested managing SSH keys securely via Azure Key Vault integration.  
  - Advised automating Bastion host deployment within Terraform for better lifecycle management.  
  - Encouraged testing connectivity before and after peering and cleaning up resources to save costs.

### Key terms and definitions 📚
- **Virtual Network (VNet)**: A logically isolated private network in Azure where you deploy your resources, similar to a traditional network in on-premises environments.
- **Subnet**: A subdivision of a VNet’s IP address range, used to organize and isolate resources.
- **CIDR (Classless Inter-Domain Routing)**: IP address notation that specifies IP address and subnet mask; e.g., `10.0.0.0/16`.
- **VNet Peering**: A connection between two VNets that allows traffic to flow securely and directly between them without going over the internet.
- **Terraform Resource Group**: A container object that holds related Azure resources, used to manage lifecycle.
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs without exposing public IP addresses.
- **Resource ID**: A unique identifier for Azure resources used in cross-resource references.
- **Public IP Address**: An IP address that can be accessed over the internet.
- **Subnet Mask**: Defines the size of a subnet and how many IP addresses it contains.

### Reasoning structure 🔍
1. **Premise**: Need secure communication between separate Azure VNets without exposing traffic to the internet.  
   → **Reasoning**: Direct peering of VNets enables private communication paths whereas default configurations isolate VNets.  
   → **Conclusion**: VNet peering is used to create this secure private link.

2. **Premise**: Terraform configuration requires explicit resource declaration with correct dependencies and resource references.  
   → **Reasoning**: Errors encountered (e.g., missing `resource` keyword, name conflicts) reveal requirement for resource correctness and uniqueness.  
   → **Conclusion**: Proper syntax, names, and dependencies are mandatory for successful deployment.

3. **Premise**: Without peering, resources in separate VNets cannot communicate; peering must be configured bidirectionally and verified.  
   → **Reasoning**: Testing connectivity before and after applying/removing peering confirms its effect and exposes issues like caching delays.  
   → **Conclusion**: Peering is essential for cross-VNet communication and must be correctly maintained.

4. **Premise**: Misconfiguration (like creating VMs in the same VNet instead of separately) leads to misleading results during peering tests.  
   → **Reasoning**: Observed connectivity without peering triggered investigation showing all VMs in one VNet.  
   → **Conclusion**: Accurate addressing and subnet allocation are prerequisites for meaningful VNet peering.

### Examples 💡
- **Shared vs Test VNet Scenario**: A shared network hosting common resources like storage and VMs, paired with a test VNet containing a VM that needs access to shared resources, showing necessity of VNet peering.
- **IP Address Calculation Example**: Using `10.0.0.0/16` for a VNet and subnetting it into `10.0.0.0/24` provides 256 usable IPs, demonstrating how subnet mask affects number of hosts.
- **Removing Peering and Testing Impact**: After deleting peering, connection briefly persisted due to cached sessions but failed after reconnect, underscoring how peering affects communication.

### Error-prone points ⚠️
- **Misunderstanding Peering Scope**: VNet peering occurs between entire virtual networks, not individual VMs or subnets, often leading to incorrect expectations about connectivity.
- **Resource Naming Conflicts**: Reusing names for OS disks results in Terraform errors — unique naming or recreating resources is necessary.
- **Incorrect Subnet Addressing**: Deploying two supposedly separate VNets but allocating overlapping or identical CIDRs causes all VMs to reside in one network, invalidating peering tests.
- **Forgetting ‘resource’ Keyword in Terraform**: Missing the `resource` block keyword triggers syntax errors; careful structure is required.
- **SSH Access Restrictions**: VMs without public IPs cannot be accessed directly by SSH without a Bastion host; assuming direct access may cause confusion.

### Quick review tips/self-test exercises 📝
- **Tips (no answers):**  
  - What is the fundamental difference between VNet peering and subnet communication?  
  - Why is bidirectional peering required between two VNets?  
  - How does subnet mask influence the number of possible IP addresses?  
  - Why do VMs within the same VNet communicate by default without additional configuration?  
  - What role does Azure Bastion serve in VM access?

- **Exercises (with answers):**  
  1. Explain why you must use Resource IDs rather than names when configuring the remote virtual network in a peering resource.  
     **Answer:** Azure requires the unique Resource ID to unambiguously identify the remote VNet during peering setup, avoiding naming conflicts.

  2. You see Terraform error upgrading OS disk names. What could be the solution?  
     **Answer:** Either destroy and recreate the VM with new disk names or ensure disk names are unique before creation to avoid conflicts.

  3. If two VNets have address spaces `10.0.0.0/16` and `10.1.0.0/16`, can you create subnets `10.0.0.0/24` and `10.1.0.0/24` respectively without overlap?  
     **Answer:** Yes, these subnets are disjoint and correctly partitioned within their VNets.

  4. How does establishing VNet peering affect network traffic flow between VNets?  
     **Answer:** It enables direct private IP connectivity across VNets without routing through the internet, improving latency and security.

### Summary and review 🔄
This video comprehensively covers the process of setting up Azure Virtual Network Peering using Terraform, starting from creating resource groups, VNets, and subnets, to deploying VMs and validating peering connectivity. It underscores the importance of understanding IP addressing, Terraform configuration syntax, and security accessibility via Bastion hosts. The hands-on demonstration highlights common pitfalls such as resource naming conflicts and misconfigurations, providing learners with actionable insights and best practices for scalable, secure Azure networking automation. Ultimately, it equips viewers with practical skills to implement VNet peering and manage Azure infrastructure confidently using Terraform.

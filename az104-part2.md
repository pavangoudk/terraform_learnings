# Azure Storage, Compute Provisioning, and Monitoring — Exam-Focused Walkthrough Notes

# 
The speaker transitions from networking into **storage**, then **compute/provisioning**, then **monitoring + troubleshooting**, closing with **exam advice**. Notes below follow the speaker’s order and stick to what was said.

## Storage (Azure): durable, persistent, long-term

# 
- The speaker frames storage as: *durable, persistent long-term storage for various things*.
- **Basic building block:** a **Storage Account**
- Lives in a **particular region**
- Has a **performance** option
- Most common choice: **General Purpose v2 (GPv2)**
- *“exposes all of the types of blobs and queues and tables and files”*
- Speaker recommendation: *“I wouldn't ever use general purpose V1… you’re just going to use general purpose V2.”*

### Premium storage account options (service-specific)

# 
- Premium is **SSD-based** and depends on the service type:
- **Block blob**
- **Page blob** (speaker says typically not used much)
- **Files**
- Key callout on **Premium Files** billing:
- *“Premium files bills you based on the provisioned size… not the amount of data you write.”*
- Rationale: performance scales with provisioned share size, so you pay even if empty.

## Blob / File / Table / Queue services inside a Storage Account

### Blob storage (block / page / append)

# 

- **Block blobs:** most common (example: multimedia files).
- **Page blobs:** random access; historically for disks; less used now due to managed disks.
- **Append blobs:** for *“keep adding… like logging to the end of something.”*

### Azure Files

# 
- File-based shares via **SMB** or **NFS**.

### Table storage

# 
- Speaker defines it as essentially schema-less key/value:
- *“There’s no schema… it’s just… key values… it’s schema-less.”*
- Mentions **partition key** and **row key**, plus arbitrary properties.

### Queue storage

# 
- First-in, first-out messaging (speaker: *“first in first out”*).

## ### Storage Explorer (tool)

# 
- Speaker highlights **Storage Explorer** as a “great” way to interact with storage accounts.
- Demonstrated capabilities:
- Browse **containers**, **file shares**, **queues**, **tables**
- Queue operations: add item, dequeue (removes it)
- Table operations: add entities/properties without a schema
- Portal also has a **Storage Browser** experience.

## Storage redundancy (resiliency options)

# 
- Redundancy is set on creation but can be changed after creation.
- Storage account is in a **region**; regions may have **Availability Zones (AZs)**.

### Redundancy types described

# 
1. **Locally Redundant Storage (LRS)**
- *Minimum three copies* in the same storage cluster.
2. **Zone Redundant Storage (ZRS)** (only where AZs exist)
- Three copies spread across the **three availability zones**.
3. **Geo-Redundant Storage (GRS)**
- Three copies in primary region + three in paired region (six total).
- Replication is **asynchronous**:
- *“As soon as it’s durably stored to the primary it will acknowledge… then… replicate.”*
4. **Geo-Zone Redundant Storage (GZRS)**
- Three copies across AZs in primary + three copies in a storage cluster in the secondary (six total).

### Read access option (RA-*)

# 
- Optional **Read Access** lets you read from the replica region (example given: blob reads).

## Storage account features mentioned (security + data features)

# 
- **Hierarchical namespace** (for blobs): *“POSIX style ACLs.”*
- **Firewall** on the storage account:
- Restrict via **service endpoints** or **private endpoints**.

## ### AzCopy (tool)

# 
- Described as a powerful command-line copy tool.
- Supports upload/download.
- Highlighted feature: **server-side asynchronous copy**
- *“copies it directly between [storage accounts]”* (avoids download-then-upload via client).

## ### Azure Data Box / Data Box Disks (method/tool)

# 
- For large-scale data migrations:
- Get devices/disks shipped, send to Azure datacenters for import (or return).

## ### Azure Data Factory (tool)

# 
- Used to create pipelines to bulk move data and perform **extract/transform/load (ETL)**-type tasks.

## ### Blobfuse (tool)

# 
- Lets you mount blob storage within a Linux filesystem.

## Blob access tiers (cost optimization)

# 
- Speaker emphasizes optimizing spend: you pay for **capacity** and **transactions**.
- Four tiers (set per blob):
1. **Hot**
2. **Cool**
3. **Cold**
4. **Archive**
- Tradeoff explained:
- *Hot:* highest capacity cost, lowest transaction cost
- *Cold:* lower capacity cost, higher transaction cost
- *Archive:* “super cheap” but offline; must rehydrate to read (can take hours)
- Usage guidance examples:
- Constantly accessed → hot
- Occasionally → cool
- Rarely but must be online instantly → cold
- Long-term retention, can wait ~12–13 hours to read → archive

### Minimum retention / early deletion charges

# 
- Must remain at least:
- Cool: **30 days**
- Cold: **90 days**
- Archive: **180 days**
- Deleting earlier still bills remaining minimum days.

### Archive behavior example

# 
- In UI, archive blobs can’t be downloaded (download disabled) until moved to another tier.

## ### Lifecycle Management (technique)

# 
- Automates tiering and deletion via rules based on:
- Name filters
- Last access / modified / created times
- Blob index tags/keys (mentioned as an option)
- Example rules speaker shows:
- Not accessed 15 days → cool
- 45 days → cold
- 135 days → archive
- Reminder to respect minimum tier durations.

## Failover + replication lag note

# 
- Speaker notes you can trigger failover and see how up-to-date replication is; warns there may be data loss past the last replicated point (example: ~2 minutes behind).

## Object replication (container-level replication flexibility)

# 
- Motivation: default geo-replication is tied to **paired region** behavior.
- **Object replication** lets you define replication between:
- specific **containers** across storage accounts
- storage accounts can be in different regions (“anywhere”)
- with **filters** controlling what replicates
- Example described:
- Container1 → StorageAccount2/ContainerX
- Container2 → StorageAccount3/ContainerY

## Azure Files: tiers + protection + identity + sync

### Azure Files tiers

# 

- Mentions tiers like:
- transaction optimized
- hot
- cool
- plus **premium** (requires a different kind of storage account)

### File share protection features

# 
- **Snapshots** (point-in-time)
- **Soft delete**
- default example: undelete up to 14 days
- configurable range: 1–365 days
- **Backup vault** can orchestrate snapshots.

### Identity integration

# 
- Can integrate with **Entra ID (Azure AD)** for data-plane access control.
- Speaker notes blob also supports data-plane permissions.

## ### Azure File Sync (tool)

# 
- Scenario: on-prem Windows file shares + Azure Files SMB share.
- Uses a **sync group**:
- One **cloud endpoint** per sync group
- Up to 100 endpoints mentioned
- Changes flow to cloud, then others read updates from there (as described)
- Adds **tiering** on-prem:
- When free space drops to a threshold, least-used data tiers to cloud
- Leaves a “thumbnail/link” and recalls data when accessed
- Positioned as scale + disaster recovery (DR) benefit.

## Storage access control: keys, RBAC, SAS

# 
- Storage account has **two access keys** to allow rotation without downtime:
- Use one, regenerate the other, switch, then regenerate the first.
- Preferred approach: **data-plane role-based access control (RBAC)** using Entra identities
- Examples of roles mentioned: blob data reader/contributor/owner; queue/table/file data roles.
- Option to disable key access:
- Setting: **allow storage account key access** (can be disabled).

### Shared Access Signatures (SAS)

# 
- Can be **account-level** or **service-level**.
- SAS is **signed by the access key**:
- If you disable key access, SAS won’t work.
- SAS provides more granular constraints:
- services allowed
- permissions
- time window
- IP ranges

## Storage encryption: platform keys, customer keys, scopes

# 
- Default: **platform-managed keys** (Microsoft-managed).
- Option: **customer-managed key (CMK)** via **Azure Key Vault**
- You’re responsible for rotation (speaker mentions auto-rotation policies and policy alerts).
- **Encryption scopes**
- Use different keys at:
- container level, and even
- blob level at upload time (if container not fixed to a scope)
- Example scenario: ISV wants per-customer keys without separate storage accounts.

## Managed disks (why page blobs are abstracted)

# 
- Speaker: managed disk abstracts underlying storage account + page blob:
- *“All I see is my managed disk… it is completely abstracted away.”*
- Disk types mentioned:
- Standard HDD
- Standard SSD
- Premium SSD
- Premium SSD v2
- Ultra disk
- Performance relationship:
- For many disks: *“as the capacity goes up so too does the performance.”*
- Notes on bursting and performance tiers:
- Some disks have burst capabilities.
- Premium SSD: can pick a higher performance tier temporarily since you can’t shrink disks.
- Key constraint: *“you can never shrink a disk; you can only make them bigger.”*
- Premium SSD v2 and Ultra Disk:
- You pick **capacity** plus **IOPS** and **throughput**
- IOPS/throughput can be adjusted dynamically (subject to constraints/minimum times)

### Managed disk encryption options

# 
1. **Disk Encryption Set (DES)**
- Create DES tied to a Key Vault key
- Place managed disks into the DES to use that key
2. **Guest-based encryption**
- Windows: BitLocker
- Linux: dm-crypt
- Referred to as “Azure disk encryption” (agent-based approach)
3. **Encryption at host**
- Encrypts cache files on host with same key
- Temp disk encrypted with platform-managed key
- Encrypts data in transit between disk and host (as described)

- Speaker suggests pairing DES + encryption-at-host for “always encrypted.”

## Provisioning approach (avoid portal at scale)

# 
- Speaker discourages portal for large-scale consistency (too many pages, error-prone).
- Also not a fan of scripting with **Azure CLI**/**PowerShell** for provisioning because updates require different commands and resources already exist.
- Recommended: Infrastructure as Code (IaC) templates:
- **ARM JSON templates**
- **Azure Bicep** (transpiles to JSON)
- Mentions third-party options like Terraform
- Key definition: *“They are declarative—we’re telling it what we want, not how to do it.”*
- Benefit: re-applying template enforces desired state; supports version control + pipelines.

### ARM template / Bicep basics (speaker walkthrough)

# 
- ARM template structure:
- parameters
- resources (resource providers like Microsoft.Network and Microsoft.Compute)
- Helpful tip: many resources allow **Export template** to generate the JSON.
- Bicep is more human-friendly; can decompile JSON to Bicep via commands.

## Compute responsibility model (IaaS → PaaS → SaaS)

# 
- Speaker layers: storage, network, compute/server, hypervisor, OS, runtime, application, data.
- On-prem: all your responsibility.
- **Infrastructure as a Service (IaaS)** (e.g., VM)
- Azure manages hypervisor/physical/networking/storage
- You manage OS and above (patching, antivirus, backup, DR, antimalware)
- Azure has helpers (agents/extensions), but responsibility remains yours
- **Platform as a Service (PaaS)**
- You’re mainly responsible for application and data
- Examples mentioned: managed databases, App Services, Azure Kubernetes Service (AKS)
- Push toward more managed/serverless when possible
- **Serverless** examples:
- Azure Functions
- Logic Apps
- **Software as a Service (SaaS)**
- Examples: Microsoft 365, Dynamics 365
- You’re still responsible for identities, but not patching the service components
- Business rationale:
- *“What differentiates my business… is… the business value… in my application.”*

## Virtual machine sizing: match workload “shape”

# 
- VM has multiple dimensions (CPU, memory, storage characteristics, network, GPUs).
- Common way to think: CPU-to-memory ratios.
- Principle: pick the VM SKU/size that matches workload shape to avoid waste:
- Database → more memory/storage throughput
- Batch processing → more CPU
- Scaling philosophy:
- Prefer multiple smaller instances over one huge one to scale with demand.

### VM series examples + traits (as described)

# 
- General purpose example ratio: 1:4 vCPU:memory
- Compute optimized: 1:2
- Memory optimized: 1:8
- Variants:
- “D” variant: has temp disk
- “S” variant: supports premium storage
- GPU series exist
- Storage optimized variants with local NVMe
- B-series burstable:
- *“like a mobile phone plan”*—bank CPU credits then burst

## VM storage: OS disk, temp disk, ephemeral OS disk, data disks

# 
- VM runs on a physical host; connects to managed disks for OS (typically).
- **Ephemeral OS disk** option:
- OS runs from local host disk for high performance/low latency
- Useful for scale sets and AKS node pools; avoids paying for managed OS disk
- Best when you don’t care about OS state persistence
- Temp drive naming mentioned:
- Windows: typically D:
- Linux: typically /dev/sdb (for certain variants)

### VM extensions and operations

# 
- Extensions can add capabilities (custom scripts, etc.).
- Run Command can run commands.
- Can integrate with Azure Backup and Disaster Recovery.
- Auto-shutdown to save money (billed per second running).

## ### Backup Center + Vault types (tools)

# 
- Backup Center: central place for backup management.
- Two vault types mentioned:
- **Recovery Services Vault** (more legacy; supports certain workloads)
- **Backup Vault** (supports Azure disks, blobs, PostgreSQL flexible, Kubernetes)
- Backup Center helps centrally configure/manage.

## ### Azure Bastion (tool)

# 
- Speaker advises against direct public IP access to VMs (attack surface).
- Azure Bastion provides a managed jumpbox capability for safer access.

## Availability sets vs availability zones

# 
- Rack-level concept: **fault domains** (racks).
- **Availability Sets**
- Distribute VMs across racks (round-robin)
- Warning: don’t mix different workloads in the same availability set; separate sets per workload.
- **Availability Zones (AZs)**
- Prefer AZs over availability sets when supported:
- isolate power, cooling, networking, and control plane/fabric controllers
- Protects against larger failures (e.g., datacenter/power substation) compared to rack-level.

## Virtual Machine Scale Sets (VMSS): autoscaling

# 
- Purpose: scale without manually creating/deleting VMs.
- Two types mentioned:
- **Uniform** (traditional)
- **Flex**
- Scaling profile includes:
- VM template (SKU, image, config)
- min and max instance count
- scaling rules (example):
- CPU > 70% → add 2 instances
- CPU < 30% → remove 1 instance
- Speaker clarifies conceptually:
- This is **horizontal autoscaling** (add/remove instances)
- Vertical scaling (resize VM) is impractical due to downtime.

### VMSS Flex extra notes

# 
- Can mix SKUs.
- Can incorporate **spot instances** (spare capacity at cheaper prices; interruptible workloads).

## Containers and orchestration

# 
- VM virtualizes hardware; containers virtualize OS (share kernel).
- Typical flow:
1. Container registry stores images
2. Write a **Dockerfile** to build your image (layers, commands, software)
3. Run on a container host where kernel is shared; containers are isolated in user mode sandboxes

### Azure Container Instances (ACI)

# 
- Most basic Azure container service:
- Run an image; pay for runtime
- Can group containers with shared networking concepts

### Kubernetes / AKS

# 
- Kubernetes described as de facto orchestrator.
- **Azure Kubernetes Service (AKS)** split:
- **Control plane** (managed by Azure): API server, etcd, scheduler, controllers
- **Node pools** (in your subscription): nodes that run workloads; built on VM scale sets
- Workload units:
- **Pods** run containers
- Storage via **persistent volume claims** to **persistent volumes**
- Examples mentioned: Azure Files, Azure NetApp Files, Azure Disk, Azure Container Storage

### AKS networking options (speaker progression)

# 
- kubenet (less popular now; NAT/rules complexity)
- Azure CNI (pods share IP space; can strain IP planning)
- Azure CNI dynamic (pods in different subnet; allocated in batches)
- Preferred: **overlay**
- separate IP range for pods with better native plumbing (as described)

### AKS scaling

# 
- Pod level:
- **Horizontal Pod Autoscaler (HPA)**
- **KEDA** (event-driven; more powerful triggers)
- Node level:
- **Cluster Autoscaler** adds nodes when pods can’t be scheduled due to capacity.
- Burst concept:
- Burst to **ACI** via a “virtual kubelet” representing ACI.

## App Service (PaaS web/app hosting)

# 
- App Service is described as an early/most common PaaS service.
- Structure:
- Create an **App Service Plan**
- Run multiple apps in it (apps share worker capacity)
- Supports deployment slots (staging/production) on same capacity
- Configuration choices:
- Windows or Linux
- runtime stack
- **App Service Environment (ASE)**
- Deploys directly into your virtual network (vNet) with no shared components.

### App Service Plan features (speaker examples)

# 
- Pricing plan determines hardware + features:
- custom domains availability depends on tier
- zone redundancy, VNet integration depend on tier
- Scaling:
- rule-based scaling (manual rules)
- “elastic” scaling (auto based on HTTP load)
- pre-warmed instances (mentioned)
- Deployment methods mentioned:
- Azure DevOps pipeline
- GitHub Actions
- URL-based deployment
- FTP
- ZIP/WAR upload

## Monitoring and observability (Azure Monitor ecosystem)

# 
- Speaker emphasizes monitoring as essential for “observability” and ensuring health.

### Control plane: Activity Log

# 
- Subscription-level changes show up in **Activity Log**.
- Activity log is free; can filter per resource/resource group.

### Metrics: Azure Monitor Metrics

# 
- Resource metrics are time-based signals, written to Azure Monitor Metrics (free).

### Logs: require Diagnostic Settings

# 
- Logs are not enabled by default.
- Must configure **Diagnostic Settings**:
- choose which logs/metrics
- choose destinations:
- Azure Storage (cheap, less interactive)
- Event Hub (pub/sub for external SIEM or subscribers)
- Log Analytics Workspace (powerful analytics)

### Guest-level monitoring

# 
- Mentioned for VMs:
- Azure Monitor Agent
- Data Collection Rules
- guest metrics/logs from inside OS

### KQL (query language)

# 
- In Log Analytics, you can query logs using **Kusto Query Language (KQL)** for analytics.

### Application-level: Application Insights

# 
- Can observe application behavior and do synthetic transactions to validate end-to-end functionality.

## Alerting (awareness + action)

# 
- Alerts can be based on:
- Activity log
- Azure Monitor metrics
- Log Analytics queries (KQL query results)
- Mention of Sentinel using its own workspace
- Types include:
- recommended alerts
- custom alerts
- ML-based alerts (baseline + sensitivity; low/medium/high)

### ### Alert Processing Rules (technique/tooling)

# 
- Best practice in speaker’s framing:
- Use alert processing rules to route/suppress alerts cleanly
- Capabilities:
- Call an **Action Group**
- Suppress alerts (e.g., weekends/holidays/out-of-hours, priority-based schedules)
- Benefit:
- Centralizes routing so you don’t wire action groups into hundreds of alert rules individually.

### ### Action Groups (tooling)

# 
- Can trigger:
- SMS, email
- webhook/secure webhook
- Azure Function
- Logic App
- Runbook
- ITSM ticket creation
- ARM role action (mentioned in list)

## Log Analytics Workspace: Analytics logs vs Basic logs vs Archive

# 
- Speaker explains cost/control options:

### Analytics logs

# 
- Full KQL capabilities included.
- Cost drivers: ingestion + retention storage beyond included time.
- Retention examples mentioned: 30/90 days; up to two years interactive with Sentinel; archive up to 12 years.

### Basic logs

# 
- Cheaper ingestion/storage model but:
- only 8 days retention in basic
- subset of KQL
- pay when you run queries
- limitations like no cross-table queries (as stated)

### Archive

# 
- Up to 12 years retention.
- Cheaper to store, but to use data you must run:
- search job or restore job (costs money)
- restore brings data back to interactive store for querying

### Table-level control example

# 
- Per table, you can choose analytics vs basic.
- Interactive vs archive split based on configured retention.

## ### Network Watcher (tool): network troubleshooting

# 
- Used for overall network health and troubleshooting.
- Capabilities listed:
- Topology view
- IP flow verify (checks if NSG rule blocks traffic)
- Next hop
- VPN troubleshooting
- Connection statistics
- NSG diagnostics / flow logs
- Packet capture
- Connection troubleshoot (synthetic test via extension)

## Closing exam guidance (speaker’s advice)

# 
- Do hands-on practice and use Microsoft Learn modules.
- During the exam:
- Don’t panic if something is unfamiliar.
- Eliminate obvious wrong answers and make an intelligent guess.
- Speaker framing: Microsoft features are designed to be logical, not confusing.
- If you fail:
- Use the score report to find weak areas and focus there for the retake.

# - -

# 

# 

#

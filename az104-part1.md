# AZ- 104 v2 Study Cram (Updated): Identity, Governance, Networking

## Orientation (how to use this cram)

- This is an **updated AZ- 104 v2 study cram** (prior version hit ~1M views).
-  The creator recommends you **use the video as a map**, but **do the hands- on activities**:
1. Review the **official study guide** topics and “tick off” each area.
2. Complete the **self- paced learning modules** (with labs).
3. Practice tasks via **Portal**, **CLI**, and **templates** (where applicable).
-  The exam is framed as **administrator- focused**: *knowing how to do the tasks*, not just theory.

## Identity (starts with Entra ID)

### ### Microsoft Entra ID (formerly Azure AD)

- Renaming note: Azure Active Directory (Azure AD) is now **Microsoft Entra ID**.
-  *Entra ID is the “identity provider from Microsoft” that “speaks cloud.”*
-  Cloud- friendly protocols mentioned:
-  OAuth 2.0, OpenID Connect (identification/auth)
-  SAML, WS- Fed
-  Emphasis: these work well over the internet via **HTTPS/TLS**, without requiring “a whole bunch of ports.”

### ### Active Directory Domain Services (on- prem comparison)

- On- prem model: **Active Directory Domain Services (AD DS)** with domain controllers.
-  Protocols called out:
-  Kerberos
-  NTLM
-  LDAP (to interact with AD DS)
-  Structural difference:
-  AD DS has **organizational units (OUs)** and hierarchy.
-  *Entra ID is “primarily flat.”*
-  Delegation alternative: **Administrative Units** (covered later).

### ### Microsoft Graph (how you interact with Entra/M365)

- *Microsoft Graph is described as the “standard way” to interact with many services (Microsoft 365 and Entra ID).*
-  Uses **REST- based calls over HTTPS (443)**.

### ### Directory sync: Entra Connect Sync vs Entra Cloud Sync

- Common need: replicate identities from AD DS to Entra ID.
-  Key directionality: *AD DS is the “source of truth,” and replication flows AD DS → Entra ID tenant.*
-  Two technologies:
-  **Entra Connect Sync**: sync “engine runs on premises.”
-  **Entra Connect Cloud Sync**: sync “engine runs in the cloud,” with lightweight on- prem agents (e.g., on domain controllers).
-  Outcome: once identities exist in Entra, applications can **trust the tenant** for authentication/authorization (Azure, Microsoft 365, many third- party SaaS apps).

### ### Secure Service Edge extensions (mentioned)

- Entra can extend controls to:
-  “any internet site” via **internet access feature**
-  on- prem TCP/UDP apps via **Entra private access**

### ### Tenant basics and custom domains

- Each organization has an **Entra tenant**: users, groups, devices, applications, conditional access policies.
-  Default domain: `*.onmicrosoft.com`
-  Add a custom domain:
1. Add the domain.
2. Verify ownership by creating a **DNS record**.
3. Then you can use it for users and optionally set it as **primary**.

### ### Tenant vs Azure subscription (common confusion)

- *A tenant “does not live in an Azure subscription.”*
-  A subscription **trusts** a tenant, but the tenant is a **global instance** (not an Azure subscription resource).

### ### Company branding

- Tenant can customize user experience (backgrounds, images, login messages with formatting).

### ### User types: cloud, hybrid, guest/external

- User origins shown:
-  **Cloud accounts**: created directly in Entra.
-  **Hybrid accounts**: created in AD DS, synced up.
-  **Guests/external users**: from other Entra tenants or other identity providers (Google, Facebook, Microsoft account, etc.).
-  Motivation for external users: avoid separate passwords, password resets, and deprovisioning issues across orgs.
-  *External user is described as having a “stub object” in your tenant that refers to their primary identity elsewhere.*

### ### Provisioning methods

- Ways accounts get created:
-  Sync from AD DS
-  Manual creation
-  HR- driven provisioning endpoints (and Entra can even create in AD first via connectors, then sync to Entra)
-  Bulk create / bulk invite (CSV template upload)
-  Scripts (mentioned as an option)

### ### Groups (why they matter)

- Reasoning: don’t assign permissions/licenses to individuals; use groups to avoid “left behind” access/licenses.
-  Two group types:
-  **Security groups** (most common; can assign to roles)
-  **Microsoft 365 groups** (collaboration: calendars, SharePoint, etc.)
-  Membership modes:
-  **Assigned** (direct membership)
-  **Dynamic** (users *or* devices): rules like department, job title, etc.
-  Example dynamic rule shown: job title matches a wildcard (e.g., `hero*`).

### ### Devices: register vs join

- Shift from classic domain- join toward cloud management for remote work.
-  Two options:
-  **Register**: typically for personal/BYOD devices; becomes a known entity for management/validation.
-  **Join**: for corporate- owned devices; enables login using Entra accounts and stronger control.
-  Devices become objects in the tenant.

### ### Entra licensing (Free, P1, P2, and Governance add- on)

- Licenses can be assigned **per user** (not everyone must have the same).
-  Notes:
-  Licenses may be bundled (e.g., Microsoft 365 E3/E5).
-  **P1** adds big features like **Conditional Access** and **HR- driven provisioning**.
-  **P2** adds richer features like **Privileged Identity Management**, core Access Reviews, and Identity Protection.
-  **Governance add- on** adds items like lifecycle workflows and governance dashboards.

### ### Self- service password reset (SSPR)

- *SSPR reduces help desk calls when users forget passwords.*
-  Passwordless is encouraged, but SSPR still matters.
-  Hybrid scenario: **password writeback** (P1 feature) writes changes back to on- prem AD DS.
-  Configurable: who is enabled, required methods (1 method vs 2+ methods, custom questions, etc.).

### ### Entra roles and Administrative Units

- Key Entra role called out: **Global Administrator** (most privileged; restrict tightly).
-  **Administrative Units (AUs)** enable more granular delegation:
-  Put users/groups/devices into an AU.
-  Assign roles scoped to that AU.
-  Safety behavior: adding a **group** to an AU does **not** automatically grant AU- scoped permissions over the **users in that group**; users must be explicitly added if that’s intended.

## Azure foundations: clouds, regions, and resiliency

### ### Azure clouds/environments (Commercial, Gov, China)

- Different Azure “clouds” are also called **environments**:
-  Azure Commercial
-  Azure US Gov
-  Azure China
-  Each environment has different URLs for:
-  Azure control plane endpoints
-  Entra endpoints
-  Tenants are **not shared** across these environments (commercial vs gov vs China are separate instances).

### ### Regions and Availability Zones

- Deploy resources into a **region** (region contains multiple datacenters).
-  Availability Zones (AZs): typically shown as **AZ1, AZ2, AZ3**.
-  Common deployment choices:
-  **Zone- redundant**: spans zones
-  **Zonal**: pinned to one zone
-  Note: a subscription exposes **three** availability zones per region (even if physical infrastructure is more complex).

### ### Multi- region design + paired regions (and what they’re for)

- Natural disasters happen → design for **at least two regions**, far apart.
-  Azure has **paired regions**:
-  Used in Microsoft safe deployment practices (rollout sequencing).
-  Pairing tries to stay within geopolitical boundaries (Brazil noted as an exception historically).
-  Pairing is “being deemphasized” for many services (more replication choices), but rollout practices still matter.

## Azure resource organization and governance (tenant → management groups → subscriptions → resource groups)

### ### Subscriptions

- You deploy resources into a **subscription**.
-  Subscriptions help with organization and act as boundaries for some resources (e.g., virtual networks are later stated to live in a subscription + region).

### ### Management Groups

- Hierarchy starts at the tenant:
-  Tenant → **Root Management Group** → your custom management groups → subscriptions
-  Why management groups: apply governance and tracking at scale (inherited downward).
-  Three core uses emphasized:
-  **Access control (RBAC)**
-  **Policy**
-  **Budgets**

### ### Cost Management: cost analysis, forecasting, and Azure Advisor

- Cloud is consumption- based: pay for what you use; avoid leaving resources running.
-  Cost analysis capabilities shown:
-  views by resource/service/location/resource group
-  forecasts and budget lines
-  “smart views” (e.g., which RG drives cost, anomaly detection)
-  **Azure Advisor** is called out as a source of recommendations (cost, reliability, performance, operational excellence, security).
-  Suggested cadence: review at least **weekly**.

### ### Budgets and alerts

- Budget sets a spending amount (e.g., dollars).
-  Alerts can trigger based on:
-  **Actual spend** thresholds (e.g., 80%)
-  **Forecasted spend** thresholds (e.g., projected 120%)
-  Alerts can invoke **Action Groups** (examples later: SMS, webhook, functions, etc.) and notify recipients.

### ### Resource Groups (RGs)

- Inside a subscription, create **resource groups** (cannot be nested).
-  Guidance: group resources that are provisioned/run/decommissioned together (e.g., one application stack).
-  Same governance primitives apply at RG level too: RBAC, policy, budgets.

## Financial optimization (beyond “turn it off / right- size it”)

### ### Azure Hybrid Benefit

- *“Applying to licenses”*: bring eligible licenses to reduce billable components.
-  Examples mentioned: Windows Server (with Software Assurance), SQL Server, Red Hat Enterprise Linux.
-  Effect: removes the Azure consumption cost portion associated with licensing.

### ### Azure Reservations

- Commitment for a **specific service** in a **specific region** (high specificity), typically 1 or 3 years, for discount.

### ### Azure Savings Plan

- More flexible, but only for **included compute services**.
-  Commitment is based on spending rate (e.g., “$20/hour for 1 or 3 years”).
-  Discount varies by SKU.
-  Note: a given resource effectively uses either **reservation** or **savings plan**, not both simultaneously.

## Tags (resource metadata)

### ### Azure Tags

- Tags are *key/value pairs* for subscription, resource group, or resource.
-  Common uses: filtering, organization, cost/billing attribution.
-  Limits mentioned: typically ~50 tags per resource/RG.
-  Important behavior: *tags are “not inherited”* by default:
-  subscription tags do not automatically apply to RGs/resources
-  RG tags do not automatically apply to resources
-  Enforcement workaround previewed: **Azure Policy** can be used to inherit/copy tags from parent scopes.

## Policy and compliance (guardrails)

### ### Azure Policy

- Motivation: cloud is self- service (no human “ops approval gate”), so policy provides guardrails.
-  Policy basics:
-  A **definition** has conditions + an **effect**.
-  Example: allowed locations policy with effect **Deny** if location isn’t in allowed list (and not “global”).
-  Effects mentioned:
-  **Deny** (blocks creation)
-  **Audit** (tracks compliance without blocking; recommended starting point)
-  **Deploy if not exists** (can deploy missing requirements via a template, e.g., agents)
-  Azure Policy tracks compliance at scale (overview shows compliance posture).

### ### Initiatives (policy sets)

- *An initiative is “a set of policies.”*
-  Benefits:
1. assign many policies at once (e.g., 665 policies)
2. track compliance at the initiative level vs hundreds of individual policies
-  Regulatory note:
-  “Microsoft cloud security benchmark” initiative is free.
-  Additional regulatory compliance initiatives require a paid plan.

## Access control (Azure RBAC vs Entra roles)

### ### Azure Role- Based Access Control (RBAC)

- Azure built from resource providers/resources; roles map to sets of actions.
-  Role assignment = **identity + role + scope**.
-  Scopes: management group, subscription, resource group, or individual resource.
-  Principle emphasized repeatedly: *least privilege* (minimum permissions at smallest scope).

### ### Built- in roles (examples)

- **Owner**: full control including permission changes (very broad; “16,000 permissions” example).
-  **Contributor**: can manage resources but not permissions.
-  **Reader**: read- only.

### ### Custom roles

- Create custom roles (often by cloning an existing role) and then add/remove actions.
-  Define assignable scopes for the custom role.

### ### Inheritance visibility

- Role assignments can be inherited from:
-  management group
-  subscription
-  resource group
-  or set directly on the resource
-  Example observation: a storage account showing some roles inherited and some assigned directly.

### ### Important distinction: Entra roles vs Azure RBAC roles

- Entra roles apply to tenant- level permissions; Azure RBAC applies to Azure resource scopes.
-  Mentioned capability: a tenant **Global Administrator** can elevate to **User Access Administrator** to grant themselves access in subscriptions that trust the tenant.

## Resource locks (control plane vs data plane)

### ### Azure Resource Locks

- Lock scopes: subscription, resource group, resource.
-  Lock types:
-  **Cannot delete**
-  **Read- only**
-  Critical caveat: *locks apply only to the Azure “control plane,” not the “data plane.”*
-  Control plane: create/size/configure the Azure resource.
-  Data plane: operations inside the service (e.g., write DB records, create/delete blobs).
-  Example: a “cannot delete” lock on a storage account prevents deleting the account, but blobs can still be deleted.

## Networking (foundations through global load balancing)

### ### Cost note: ingress vs egress

- Generally: no charge for inbound data (**ingress**) into Azure, but you do pay for outbound data (**egress**).

### ### Virtual Network (VNet) and subnets

- *A VNet is bound to a specific subscription and region* (cannot span regions or subscriptions).
-  Addressing:
-  one or more IPv4 ranges (often RFC1918)
-  optional IPv6 (requires IPv4 + IPv6 subnets)
-  Subnets:
-  VNet is broken into one or more subnets.
-  Warning: choose unique IP ranges to avoid routing conflicts (otherwise NAT complexity).
-  Availability Zones note: VNets/subnets are regional; subnets can contain resources across AZs.

### ### Subnet reserved addresses (the “lose five” rule)

- *Every subnet “loses five IP addresses,” regardless of subnet size:*
1. network address (.0)
2. broadcast (last)
3. gateway (.1)
4. DNS (.2)
5. DNS (.3)

### ### IP assignment (DHCP via Azure fabric)

- Resources receive private IPs via Azure- managed DHCP (you don’t run your own DHCP in the VNet).
-  You can configure a resource to always get the same private IP (static assignment via Azure fabric).

### ### Public IP addresses (and retirement note)

- Direct public IP on a VM is called out as “ugly” (not preferred).
-  Public IP SKU guidance:
-  prefer **Standard** (static)
-  **Basic** can be dynamic, but the transcript notes a retirement notice: *Basic public IPs retire Sept 30, 2025* (as shown in the portal UI).
-  Public IP can be IPv4/IPv6 and Regional/Global (Global for anycast services).
-  Public IP prefixes (contiguous blocks) mentioned.
-  Bring- your- own public IP range:
-  process- heavy (prove ownership, provision, commission/advertise)
-  size examples mentioned (IPv4 /21 to /24; IPv6 /48)

### ### Explicit outbound internet access (implicit default is “going away”)

- The “implicit default internet access” is stated to be going away; outbound will require an explicit mechanism such as:
-  public IP
-  NAT Gateway
-  Azure Firewall / network virtual appliance with user- defined routes
-  Standard Load Balancer outbound rules

### ### VNet peering + hub- and- spoke gateway transit

- VNets can be peered (same region or cross- region).
-  Hub- and- spoke pattern:
-  Hub hosts gateway connectivity.
-  Configure hub to **allow gateway transit** (terminology noted as changed in UI).
-  Configure spoke to **use remote gateway**.
-  Routes are propagated via **BGP**.

### ### Non- transitive peering (and how to make it transitive)

- Peering is not transitive by default: spoke- to- spoke doesn’t work automatically.
-  To enable transitive routing, use a routing appliance (e.g., **Azure Firewall**) and **user- defined routes (UDRs)** to forward traffic.

### ### Azure Virtual Network Manager (centralized connectivity + admin rules)

- Creates **network groups** (static or dynamic membership rules).
-  Apply connectivity configurations:
-  **Hub- and- spoke**
-  **Mesh**
-  Also provides **Security Admin Rules** that apply *before* local VNet/subnet/NIC rules:
-  **Allow** (traffic continues to NSGs)
-  **Always allow** (bypasses NSGs)
-  **Deny** (blocked before NSGs)
-  Example use case: ensure critical traffic (domain controllers, patching/maintenance) can’t be accidentally blocked by local admins.

### ### Network Security Groups (NSGs)

- NSG = set of rules with:
-  priority (lower number = higher priority)
-  name, source, destination, ports, action (allow/deny)
-  Default rules highlighted conceptually:
-  allow VNet- to- VNet
-  allow outbound to internet
-  deny everything else inbound
-  Sources/destinations can use:
-  IP addresses/ranges
-  **Service tags** (to avoid managing changing Azure service IP ranges)
-  **Application Security Groups (ASGs)**

### ### Application Security Groups (ASGs)

- *ASG is described as “just a tag” applied to a NIC.*
-  Benefit: write NSG rules in terms of roles (e.g., “web front ends” → “SQL databases” on port 1433) instead of tracking IPs.

### ### Effective routes (troubleshooting visibility)

- For a NIC, you can view **effective routes** (includes VNet system routes, peering- learned routes, UDRs, etc.).

### ### Azure Firewall

- First- party Microsoft network virtual appliance.
-  Supports:
-  Layer 4 rules (TCP/UDP)
-  Layer 7 application rules
-  SNAT (outbound) and DNAT (inbound)
-  SKUs and feature differences:
-  Basic / Standard / Premium
-  Premium adds capabilities like TLS termination, IDS/IPS, URL filtering.

### ### Azure DNS (public + private) and dangling DNS risk

- Public DNS zones:
-  record types (A, CNAME, MX, etc. mentioned)
-  **Alias records** to point directly to Azure resources.
-  *Dangling DNS scenario:* if a record points to a deleted resource, an attacker could create a resource with that name and hijack traffic.
-  *Alias behavior:* if the target Azure resource is deleted, the record becomes an empty set (mitigates hijack risk).

### ### Private DNS zones and auto- registration

- Private DNS zones are used for internal name resolution.
-  Two linking purposes:
-  **Auto- registration** (VNet registers records automatically)
-  VNet can auto- register to only **one** private DNS zone
-  a zone can support auto- registration from up to **100** VNets
-  **Resolution** (VNets can resolve zone records)
-  VNet can link up to **1000** private DNS zones for resolution
-  a zone can be linked by up to **1000** VNets for resolution
-  Azure- provided DNS IP inside VNets: **168.63.129.16** (used by Azure resources for DNS).
-  For on- prem resolution of private zones, you need a resolver:
-  **Azure Private DNS Resolver** can serve as a target for external networks to resolve private zones.
-  It can also forward Azure DNS queries to custom DNS servers for your own zones.
-  Default internal DNS namespace mentioned: `internal.cloudapp.net` (not manually editable).
-  If using custom DNS servers, ensure they can still resolve Azure/private link names (often via forwarding).

### ### VPN Gateway (site- to- site and point- to- site)

- VPN gateway sits in a **GatewaySubnet**:
-  minimum size: /29
-  recommended: /27 (for coexistence with S2S VPN and ExpressRoute)
-  Two VPN types:
-  **Policy- based** (static; legacy/restricted; generally not recommended)
-  **Route- based** (dynamic; supports multiple tunnels; supports **point- to- site** VPN)
-  Resiliency patterns: active/passive or active/active designs.

### ### ExpressRoute (private connectivity over Microsoft backbone)

- Uses Microsoft’s global backbone + partner/carrier connectivity into a peering location.
-  ExpressRoute circuit connects customer network to Microsoft backbone, then to an **ExpressRoute gateway** for private peering into VNets.
-  **ExpressRoute Global Reach**:
-  *connects your on- prem locations to each other using the Microsoft backbone via your ExpressRoute circuits.*

### ### ExpressRoute Microsoft peering (for Microsoft/Azure PaaS)

- Enable **Microsoft peering** and use a **route filter** to choose which services/routes are advertised for on- prem access (for certain PaaS services without needing VNet private endpoints).

### ### Azure Virtual WAN (virtual WAN)

- Framed as “can’t someone else do it” for complex networking.
-  Two SKUs:
-  **Basic**: primarily site- to- site VPN.
-  **Standard**: adds ExpressRoute, point- to- site, VNet- to- VNet, transitive connectivity, and can integrate security (Azure Firewall) and deploy NVAs into the virtual WAN.

### ### User- defined routes (UDRs)

- Used to override default routing: *for a given destination IP prefix, set the next hop type and IP address* (e.g., send traffic to Azure Firewall).

### ### Service Endpoints (PaaS access control by subnet)

- Problem: PaaS services have public endpoints, but you want to restrict access.
-  *Service endpoint makes a subnet a “known entity” to a service type.*
-  Then the service firewall can allow specific VNets/subnets, and logs can reflect private IPs.

### ### Private Endpoints + Private Link Service

- **Private endpoint**:
-  creates a private IP in your subnet that maps to a specific service instance
-  public endpoint can be disabled
-  requires DNS adjustments (often via private DNS zone) so the service name resolves to the private IP while TLS still works
-  **Private Link Service** (for your own services):
-  expose a service behind a **Standard Load Balancer**
-  consumers can connect via private endpoints **without VNet peering**
-  uses NAT internally to facilitate the connection model

### ### Azure Bastion

- Managed “jump box” service for RDP/SSH without public IPs on VMs.
-  Deployed into **AzureBastionSubnet** (size /26).
-  Integrates with Entra (supports Conditional Access ideas).
-  SKUs/features mentioned:
-  Developer: only VMs in same VNet
-  Basic/Standard: can access VMs in peered VNets
-  Standard adds features like CLI- based connect, better scaling, shareable links, disable copy/paste, and cross- platform protocol options (RDP to Linux, SSH to Windows).

## Load balancing and application delivery (regional and global)

### ### Azure Load Balancer (Layer 4)

- Layer 4 (TCP/UDP) regional load balancing.
-  Structure:
-  front- end IP (internal or external)
-  backend pools
-  health probes
-  rules
-  “Tuple” options (stickiness):
-  5- tuple: dst IP, src IP, dst port, src port, protocol
-  3- tuple: removes ports
-  2- tuple: only source/destination IP
-  SKUs:
-  Basic (called out as “going away” similar retirement timeframe; no SLA; limited scale)
-  Standard (SLA, zone support, larger backend pools; backend can be NICs or IPs)
-  Standard Load Balancer notes:
-  external uses Standard public IP
-  “locked down by default” and needs outbound rules for internet egress
-  Floating IP concept:
-  backend sees the **front- end IP** as destination (avoids rewrite in certain scenarios).

### ### Azure Application Gateway (Layer 7)

- Focus: HTTP/HTTPS/HTTP2/websockets (Layer 7).
-  Front- end IP options: public and/or private; public used to be required, now (preview at recording) can be removed.
-  V2 SKU adds autoscaling; can be zone- redundant or zonal; still regional.
-  Deployment subnet sizing guidance:
-  recommended /24 (growth)
-  V1 supports up to 32 instances (smaller subnet like /26 noted as optional)
-  Optional **Web Application Firewall (WAF)**:
-  protects against OWASP common web vulnerabilities (paid add- on).
-  Key capabilities:
-  URL/path- based routing, redirects (HTTP→HTTPS), URL rewrite, header rewrite
-  TLS termination/offload
-  cookie- based affinity
-  Structure components described:
-  listener (port- based; basic vs multisite using FQDN/SNI)
-  rule (basic or path- based)
-  backend pools + HTTP settings + health probes
-  Backend targets can include: VMs, VM scale sets, IPs, FQDNs, App Service, and even on- prem targets (via VPN/ExpressRoute).

### ### Azure Traffic Manager (Global DNS- based routing)

- Global endpoint via DNS; returns a target based on routing method.
-  Target types: Azure endpoints, public IPs, FQDNs, nested endpoints (including another Traffic Manager).
-  Routing methods mentioned: priority, weighted, performance (closest), geographic, multivalue, subnet.
-  TTL controls caching duration before re- resolution.

### ### Cross- region Load Balancer (Global Layer 4)

- Global anycast public IP.
-  Routes clients to regional load balancers closest to them (layer 4 global distribution).

### ### Azure Front Door (Global Layer 7 + acceleration)

- Global, public, layer 7 load balancing.
-  WAF option available; supports many Application Gateway- like features (TLS offload, affinity, redirects, rewrites).
-  “Split TCP” described:
-  client establishes TCP/TLS to a nearby point of presence (PoP)
-  Front Door fetches content over Microsoft backbone, using larger block transfers
-  optional caching features (CDN- like acceleration)
-  Backend targets must be public endpoints (public IP or publicly resolvable DNS), can be across regions and even outside Azure.
-  SKUs: Standard and Premium emphasized; Classic de- emphasized.

## Transition to storage (video moves on)

- Speaker closes networking emphasis (“networking is one of the biggest things”) and transitions: “let’s talk about storage,” but the provided transcript ends at the start of that section.

# 

# 

#

## Setting up Azure Monitoring and Alerts Using Terraform 🚀

### Overview
This video is part of a Terraform learning series and focuses on configuring monitoring and alerting for Azure infrastructure using Terraform code. The presenter guides viewers through creating a virtual machine with necessary network components, deploying a sample web application, and setting up Azure Monitor's action groups and metric alerts for proactive resource management. The approach is hands-on, illustrating the entire workflow from infrastructure provisioning to alert triggering by simulating CPU stress and disk utilization conditions. Key knowledge points revolve around defining alerting logic via Terraform, configuring notification channels, and testing the alerts in real scenarios.

### Summary of Core Knowledge Points ⏱️

- **00:00 - 01:30 | Introduction and project overview**  
  The video will provision Azure infrastructure including a VM and associated networking resources, deploy a simple Nginx-hosted HTML webpage, and implement Azure Monitor alerting through Terraform. Two metric alerts will be created: one for high CPU usage and one for low disk space, with notifications sent via email.

- **01:30 - 04:30 | Infrastructure setup recap**  
  A brief review covers creating resource groups, virtual networks, subnets, security groups, public IPs, NICs, and the demo VM. The VM runs Nginx serving a basic static page. This forms the baseline infrastructure onto which alerts will be layered.

- **04:30 - 07:00 | Creating the Azure Monitor Action Group using Terraform**  
  The action group is defined with a name, associated resource group, and notification channels—in this case, an email receiver. The email address is managed via Terraform variables, enabling user customization for alert recipients.

- **07:00 - 09:30 | Defining the first Metric Alert: High CPU utilization**  
  The metric alert monitors the VM's CPU percentage through the Azure Compute namespace metric Percentage CPU. The alert triggers if the average CPU utilization exceeds 60% over a default five-minute window. Aggregation method and operator (greater than) are specified to define the condition precisely.

- **09:30 - 11:30 | Defining the second Metric Alert: Low disk space**  
  A second metric alert targets free disk space, triggering if the available space drops below 20%. The metric used is Available Bytes in the virtual machine namespace. The operator is less than the threshold, and the alert links to the same action group for notification.

- **11:30 - 13:30 | Applying Terraform changes and verifying resources in Azure**  
  The usual Terraform workflow is executed: `terraform init`, `plan`, and `apply`. After deployment, checking the Azure portal confirms the creation of resources including the VM, action groups, and metric alerts.

- **13:30 - 15:30 | Viewing Azure Monitor configuration and alert details**  
  Detailed review of the Action Group and Metric Alerts is shown in Azure Portal, including metrics monitored, alert thresholds, notification types, and estimated monthly costs. The importance of reading documentation to customize optional parameters like alert severity (severity levels 0-4) is highlighted.

- **15:30 - 17:00 | Stress testing CPU utilization on the VM**  
  To trigger high CPU alerts, the video demonstrates SSH access into the VM and running a stress-testing utility that loads 6 CPUs for five minutes. Monitoring on Azure displays the CPU utilization spiking past the 60% threshold, triggering the alert.

- **17:00 - 18:30 | Alert notifications and validation**  
  Upon the CPU utilization threshold breach, alert emails are received with detailed info — metric values, rule IDs, and investigation links. When CPU usage falls below the threshold after the test, a deactivation alert is also sent, demonstrating the alert lifecycle.

- **18:30 - 19:40 | Assignment: Disk space stress test setup**  
  The video suggests creating or deleting large files on the VM to simulate disk usage reaching the threshold and triggering the second alert. Various shell scripting methods or loops can fill disk space as a practice assignment.

- **19:40 - End | Wrap-up and call to action**  
  The presenter encourages viewers to like and comment to unlock further videos, emphasizing that this module enables effective proactive monitoring and alerting configuration in Azure using Terraform.

### Key Terms and Definitions 📚

- **Terraform**: An Infrastructure as Code (IaC) tool that allows defining and provisioning cloud infrastructure using a declarative configuration language.

- **Resource Group**: A container in Azure that holds related resources for an Azure solution.

- **Action Group**: A collection of notification preferences (email, SMS, webhook, etc.) and actions that are used in Azure Monitor alerts to notify stakeholders or trigger automated processes.

- **Metric Alert**: An alert rule in Azure Monitor that triggers when a specific metric crosses a defined threshold over a time window.

- **Namespace (Metric Namespace)**: A logical container for Azure Monitor metrics; for example, Microsoft.Compute/virtualMachines contains VM metrics like CPU percentage.

- **Aggregation**: A method of summarizing metric data over time such as average, minimum, or maximum.

- **Stress Test**: A method to artificially increase resource usage to test system behavior under load.

### Reasoning Structure 🔍

1. **Premise:** Monitoring the VM’s health is essential to prevent performance issues.  
   → **Reasoning:** Use Azure Monitor metric alerts to watch CPU and disk space thresholds.  
   → **Conclusion:** When metrics cross thresholds, trigger alerts to notify administrators proactively.

2. **Premise:** Alerts require a notification channel to inform responsible parties.  
   → **Reasoning:** Define an Action Group with email receivers or other communication methods.  
   → **Conclusion:** Alerts will send notifications through configured channels upon trigger.

3. **Premise:** Real conditions might be infrequent, so alerts may not trigger spontaneously.  
   → **Reasoning:** Perform stress testing to simulate high CPU and disk usage scenarios.  
   → **Conclusion:** Validate that alerts are functioning as expected by observing notification and alert lifecycle.

### Examples 🧩

- **Example of High CPU Alert:** Running a shell script using the `stress` utility on the VM artificially raises CPU usage above 60% average for 5 minutes, triggering the CPU utilization alert email. This illustrates how alerts react to defined metric thresholds in real time.

- **Example of Disk Space Simulation:** Filling disk space with large or multiple files to decrease free disk space below 20% to trigger the disk metric alert. This shows practical testing of storage monitoring.

### Error-Prone Points ⚠️

- **Misunderstanding the metric namespace and metric names:** Using incorrect metric namespace or metric names in Terraform will cause alert creation to fail. Always refer to official Azure Monitor documentation for exact metrics like Percentage CPU or Available Bytes.

- **Assuming alert triggers instantly:** Alerts trigger based on aggregated metrics over time windows (default 5 minutes). Sudden spikes may not immediately cause alerts until the threshold is met over the specified duration.

- **Incorrect notification configuration:** If the action group notification channel is not properly configured (e.g., email missing or webhook URL invalid), alerts will trigger but notifications won’t be received.

- **Threshold definitions confusion:** For CPU, alert is triggered when usage is greater than 60%, but for free disk space, alert triggers when free space falls below 20%. Mixing these conditions can cause misconfiguration.

### Quick Review Tips / Self-Test Exercises 🎯

**Tips (without answers):**

- Explain the purpose of an Azure Monitor action group and what it contains.  
- Describe the difference between metric alert criteria with greater than and less than operators.  
- List the Terraform resources used to set up monitoring and alerting in Azure.  
- How do you simulate high CPU usage on a VM to test alerting?  
- Why is understanding the metric namespace important in alert configuration?

**Exercises (with answers):**

1. _What Terraform resource defines the notification channels for alerts?_  
   **Answer:** `azurerm_monitor_action_group`

2. _If you want to alert when CPU usage exceeds 70% over 10 minutes, which two alert properties must you change?_  
   **Answer:** Adjust the `criteria.threshold` to 70 and configure the evaluation period or window to 10 minutes (if supported).

3. _What is the metric name to monitor free disk space on an Azure VM?_  
   **Answer:** `Available Bytes`

4. _How can you test the disk space alert on your VM?_  
   **Answer:** By creating large or multiple files to reduce free disk space below the specified threshold.

### Summary and Review 📌

This tutorial breaks down the steps to implement monitoring and alerting for an Azure virtual machine using Terraform. Starting from infrastructure setup to defining actionable alerts, it shows how to create an action group with email notifications and configure metric alerts based on CPU and disk space utilization. The video also covers practical testing techniques using stress utilities and file system operations to validate alert triggering. With this knowledge, you can proactively safeguard your cloud environments by automating monitoring rules and ensuring timely notifications for system health issues in Azure.

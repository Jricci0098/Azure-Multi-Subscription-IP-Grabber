# Azure-Multi-Subscription-IP-Grabber

A PowerShell script to retrieve public and private IP addresses from all subscriptions in an Azure tenant and export the results to an Excel file.

## Prerequisites

- PowerShell 5.1 or later
- Azure PowerShell module
  ```bash
  Install-Module -Name Az -AllowClobber -Scope CurrentUser```

- AzureAD module for login authentication
  ```bash
  Install-Module -Name AzureAD -Scope CurrentUser```

## Script Overview

The script performs the following tasks:
1. Authenticates into Azure using your credentials.
2. Retrieves all Azure subscriptions in the tenant.
3. Gathers public and private IP addresses from each subscription.
4. Exports the IP data into an Excel file with a timestamped filename.

## How to Use

1. Install the required PowerShell modules using the commands listed in the prerequisites.
2. Download the script or clone the repository.
3. Open PowerShell and navigate to the directory where the script is saved.
4. Run the script:
   ```bash
   .\Get-AzureIPs.ps1
```
5. After running the script, you will be prompted to provide the following details:
- Azure Username: Enter your Azure account username.
- Password: Enter your account password (this will be secured as a SecureString input).
- Tenant ID: Enter the Azure Tenant ID where your subscriptions are located.

6. Once authenticated, the script will:
- Retrieve all Azure subscriptions tied to your account.
- Switch the context to each subscription and gather the public IP addresses from each.
- Collect the private IP addresses from network interfaces in each subscription.

7. The script will compile the data into a PowerShell array and export the results to an Excel file using the Export-Excel cmdlet. The Excel file will be saved with the following naming convention:
```IPAddresses_<timestamp>.xlsx``` where <timestamp> is the current date and time (formatted as yyyyMMdd).

8. After the export is complete, a message will be displayed confirming the name of the file:
```Data exported to file: IPAddresses_yyyMMdd.xlsx```

### File Structure

The exported Excel file will contain the following columns:

| Column Name         | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| **SubscriptionId**   | The unique identifier for the Azure subscription.                           |
| **SubscriptionName** | The name of the Azure subscription.                                         |
| **Name**             | The name of the resource (either the public IP or network interface).        |
| **IpAddress**        | The public or private IP address of the resource.                           |
| **ResourceGroupName**| The name of the resource group that contains the resource.                  |
| **IPType**           | The type of IP address (either Public or Private).                          |
| **ResourceId**       | The unique Azure resource ID for the specific resource (public IP or NIC).  |

### Example

Here is a sample of what the data might look like in the exported Excel file:

| SubscriptionId        | SubscriptionName     | Name            | IpAddress    | ResourceGroupName | IPType  | ResourceId                                  |
|-----------------------|----------------------|-----------------|--------------|------------------|---------|---------------------------------------------|
| 12345678-90ab-cdef-1234| MySubscription       | publicIP-01     | 52.123.45.67 | myResourceGroup   | Public  | /subscriptions/.../publicIP-01              |
| 87654321-fedc-ba09-8765| AnotherSubscription  | nic-private-01  | 10.0.1.2     | anotherResourceGroup | Private | /subscriptions/.../nic-private-01           |

The `SubscriptionId` and `SubscriptionName` columns allow you to identify which subscription the IP address belongs to. The `ResourceGroupName` field helps you determine the grouping of resources within the subscription. The `IPType` field will clearly distinguish between Public and Private IPs.

### Use Cases

This script can be beneficial for:
- **Auditing**: Gathering public and private IP addresses across your Azure subscriptions to ensure proper IP management and security measures are in place.
- **Cloud Management**: Tracking IP addresses, especially in large-scale environments with multiple subscriptions and network interfaces.
- **Security Reviews**: Identifying public IP addresses to review exposure and access controls in your Azure environment.

### Performance Considerations

- The performance of the script will depend on the number of subscriptions, the number of resources, and the complexity of your network architecture.
- If you have a large number of resources, the script might take longer to complete as it iterates over each subscription and gathers IP details.
- It is recommended to run the script during off-peak hours or schedule it as part of a regular audit process to avoid impacting other Azure management activities.

### Future Improvements

There are several enhancements you can make to this script for more advanced functionality:
- **Filter by Resource Group**: Add an option to only gather IP addresses from specific resource groups.
- **Include Additional Resource Details**: Gather more information about the IP addresses, such as their DNS settings, provisioning state, or association with specific resources like Virtual Machines.
- **Email Reporting**: Automatically email the Excel file to a distribution list once the script has completed.
- **Scheduled Execution**: Use Azure Automation or Windows Task Scheduler to run this script on a regular basis for continuous IP tracking.

### Customizing the Script

To modify the script to suit your specific needs, you can:
- **Change the Excel Output Format**: Customize the Excel export (e.g., add charts or formatting) by modifying the `Export-Excel` command.
- **Select Specific Subscriptions**: If you don’t want to scan all subscriptions, you can modify the script to only target specific subscriptions by filtering the `$subscriptions` variable.
  Example:
  ```powershell
  $subscriptions = Get-AzSubscription | Where-Object { $_.Name -eq "MyTargetSubscription" }

### Known Limitations

1. **Permissions**: The script requires at least `Reader` access to the subscriptions and resources. If you lack proper permissions, the script may fail to retrieve data from certain subscriptions.

2. **Large Data Sets**: For environments with thousands of IP addresses, exporting the data to Excel may be slow or memory-intensive. Consider filtering by subscription or resource group to manage smaller data sets.

3. **Azure Authentication**: If you have MFA (Multi-Factor Authentication) enabled, you may need to modify the authentication mechanism, as the current script uses username and password authentication. You can use `Connect-AzAccount` to handle more advanced authentication scenarios.

4. **Network Latency**: Depending on the location of your Azure resources, network latency can affect the time it takes to collect the data. In larger environments with many subscriptions, expect longer execution times.

5. **Output Size**: The Excel file size may grow large if you have numerous IP addresses across many subscriptions, which could result in performance issues when opening or analyzing the file.

License
This project is licensed under the MIT License - see the LICENSE file for details.



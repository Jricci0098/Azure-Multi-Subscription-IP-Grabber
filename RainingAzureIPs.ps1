# You may need to install the excel module
# Install-Module -Name ImportExcel -Scope CurrentUser -Force

# Login to Azure
$username = Read-Host "Enter your Azure Username: "
$password = Read-Host "Enter a Password: " -AsSecureString
$TenantId = Read-Host "Enter your Tenant ID: "

$MyCredential = New-Object Management.Automation.PSCredential ($username, $password);
Connect-AzureAD -TenantId $TenantId -credential $MyCredential

# Retrieve all subscriptions 
$subscriptions = Get-AzSubscription 

# Initialize an array to hold the data 
$data = @() 

# Iterate over each subscription 
foreach ($sub in $subscriptions) { 
    # Set the context to the current subscription 
    Set-AzContext -SubscriptionId $sub.SubscriptionId 

    # Get public IP addresses 
    $publicIPs = Get-AzPublicIpAddress | Select-Object @{Name="SubscriptionId"; Expression={$sub.SubscriptionId}}, @{Name="SubscriptionName"; Expression={$sub.Name}}, Name, IpAddress, ResourceGroupName, @{Name="IPType"; Expression={"Public"}}, @{Name="ResourceId"; Expression={$_.Id}} 

    # Add to the data array 
    $data += $publicIPs 

    # Get private IP addresses from network interfaces 
    $privateIPs = Get-AzNetworkInterface | Select-Object -ExpandProperty IpConfigurations | Select-Object @{Name="SubscriptionId"; Expression={$sub.SubscriptionId}}, @{Name="SubscriptionName"; Expression={$sub.Name}}, @{Name="Name"; Expression={$_.Id.Split('/')[-1]}}, @{Name="IpAddress"; Expression={$_.PrivateIpAddress}}, @{Name="ResourceGroupName"; Expression={$_.Id.Split('/')[4]}}, @{Name="IPType"; Expression={"Private"}}, @{Name="ResourceId"; Expression={$_.Id}}

    # Add to the data array 
    $data += $privateIPs 
} 

# Define the file name with timestamp 
$timestamp = Get-Date -Format "yyyyMMddHHmm" 
$fileName = "IPAddresses_$timestamp.xlsx" 

# Export the data to an Excel file 
$data | Export-Excel -Path $fileName -WorksheetName "IP Addresses" -AutoSize 

# Output the file name 
Write-Host "Data exported to file: $fileName" 

# Accept parameters when running the script

param([string]$size, [string]$location, [int]$count)

#Import the Azure Module
Import-Module -Name Az

#Accept the credentials to be connected to the Azure Subscription
$credentials = Get-Credential -Message "Enter Credentials for the Subscription"
Connect-AzAccount -Credential $credentials

#Define variables for the resources

$resourceGroup = "demoresource"
$vNetName = "demoVnet"
$subnetName = "demoSubnet"
$imageName = "UbuntuLTS"

#create resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location -Name $vNetName -AddressPrefix 10.0.0.0/16

#create subnet
$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24 -VirtualNetwork $virtualNetwork

#write subnet config to virtual network
$virtualNetwork | Set-AzVirtualNetwork

#get credential for vm
$adminCredential = Get-Credential -Message "Enter username and password for vm admin"

#this loop will create vm's and it depends on count, which was passed as parameter
For ($i = 1; $i -le $count; $i++)
{
    $vmName = "demoVM" + $i
    Write-Host "Creating VM: "vmName
    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image $imageName -Size $size -VirtualNetworkName $vNetName -SubnetName $subnetName
}
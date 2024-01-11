---
description: Enabling app deployments to self-discover resources through Azure Tags
page_type: sample
products:
- azure
- azure-resource-manager
- tags
urlFragment: tags-for-self-discovery
languages:
- json
- bicep
---
# Azure Tags - An Azure Tag Strategy for Self-Discovery

This template demonstrates how you can use Azure resource tags for application deployments to self-discover infrastructure resources.

To start, you'll want to use the deployments steps to create a resource group and then deploy the bicep template first. The bicep template assigns "discovery" tags to each component in the deployment definition. Once deployed, you can use the `BuildApp.ps1` powershell script to build a container image against the Azure Container Registry. The `DeployApp.ps1` powershell script will deploy the container image to the Azure Container App Environment. Both scripts will use the discovery tags to self-discover their infrastructure dependencies.

The bicep templates deploys the following resources:

- An Azure Managed Identity
- An Azure Container Registry
- An Azure Container App Environment

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
- [PowerShell](https://docs.microsoft.com/powershell/scripting/install/installing-powershell?view=powershell-7.1)

## Deployment steps

Deploy a resource group and bicep template using the following az cli commands:

```powershell
az group create --name 'tags-for-self-discovery' --location "westus" --tags "solution-id=self-discovery-demo" "environment=dev"
az deployment group create --name deploytagdemo --resource-group 'tags-for-self-discovery' --template-file main.bicep --parameters param.json
```

## Usage

### Connect

Confirm deployment by visiting the resources in the Azure cloud portal.

#### Build Container Image

1. Run the following command to build the container image.

    ```powershell
    .\scripts\BuildApp.ps1 -APP_VERSION 0.1
    ```

2. Run the following command to deploy the container image to an Azure Container App Environment.

    ```powershell
    .\scripts\DeployApp.ps1 -APP_VERSION 0.1
    ```

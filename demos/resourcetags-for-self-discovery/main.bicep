@description('Specifies the location in which the Azure resources should be deployed.')
param location string = resourceGroup().location

@description('Specifies the environment in which to deploy the azure container registry.')
param environment string = 'dev'

@description('A solution and environment tag to support self-discovery of resources for application deployments.')
var solutionDiscoveryTags = { 'solution-id': 'self-discovery-demo', environment: environment }

@description('Specifies the name of the managed identity.')
param managedIdentityName string = 'demouseridentity'
var managedIdentityDiscoveryTags = { 'resource-id': 'demo-mi'}

@description('Specifies the name of the container registry.')
param containerRegistryName string = 'discovereddemoregistry'
var containerRegistryDiscoveryTags = { 'resource-id': 'demo-container-registry' }

@description('Specifies the name of the container app environment.')
param containerAppEnvironmentName string = 'discovereddemocontainerappenvironment'
var containerAppDiscoveryTags = { 'resource-id': 'demo-containerappenvironment'}

@description('Adds tags to the resource group.')
resource tag 'Microsoft.Resources/tags@2022-09-01' = {
  name: 'default'
  properties: {
    tags: solutionDiscoveryTags
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: managedIdentityDiscoveryTags
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
  tags: containerRegistryDiscoveryTags
  dependsOn: [
    managedIdentity
  ]
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: containerAppEnvironmentName
  location: location
  tags: containerAppDiscoveryTags
  properties: {}
}


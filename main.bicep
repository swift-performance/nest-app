@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'development'
  'prod'
])
param environmentType string

@description('Indicates whether to deploy the storage account for bicep manuals.')
param deploybicepManualsStorageAccount bool

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().name)

var appServiceAppName = '${resourceNameSuffix}-app'
var appServicePlanName = '${resourceNameSuffix}-plan'
var bicepManualsStorageAccountName = '${resourceNameSuffix}-storage-account'

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  development: {
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    bicepManualsStorageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
  }
  production: {
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    bicepManualsStorageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
    }
  }
}
var bicepManualsStorageAccountConnectionString = deploybicepManualsStorageAccount ? 'DefaultEndpointsProtocol=https;AccountName=${bicepManualsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${bicepManualsStorageAccount.listKeys().keys[0].value}' : ''

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}

resource appServiceApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'bicepManualsStorageAccountConnectionString'
          value: bicepManualsStorageAccountConnectionString
        }
      ]
    }
  }
}

resource bicepManualsStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = if (deploybicepManualsStorageAccount) {
  name: bicepManualsStorageAccountName
  location: location
  kind: 'StorageV2'
  sku: environmentConfigurationMap[environmentType].bicepManualsStorageAccount.sku
}

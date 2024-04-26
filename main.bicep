param appName string = 'myWebApp-test-JW'
param location string = 'westeurope'
param skuName string = 'S1' // Premium tier, można dostosować do potrzeb

// Tworzenie planu App Service
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'asp-${appName}'
  location: location
  sku: {
    name: skuName
  }
  properties: {
    reserved: false // set to true for Linux
  }
  kind: 'windows'
}

// Tworzenie głównej aplikacji App Service
resource mainAppService 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

// Tworzenie slotu staging
resource stagingSlot 'Microsoft.Web/sites/slots@2021-02-01' = {
  name: '${appName}/staging'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output productionUrl string = mainAppService.properties.defaultHostName
output stagingUrl string = stagingSlot.properties.defaultHostName

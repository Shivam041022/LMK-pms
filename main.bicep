param location string
param functionAppName string
param appServicePlanName string
param tags object

resource functionAppResource 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanName
    httpsOnly: true

    siteConfig: {
      ftpsState: 'FtpsOnly'
    }
  }
  tags: tags
}

resource functionAppStagingSlotResource 'Microsoft.Web/sites/slots@2021-02-01' = {
  parent: functionAppResource
  name: 'Staging'
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanName
    httpsOnly: true
    siteConfig: {
      ftpsState: 'FtpsOnly'
    }
  }
  tags: tags
}

output prodFunctionAppName string = functionAppResource.name
output productionTenantId string = functionAppResource.identity.tenantId
output productionPrincipalId string = functionAppResource.identity.principalId

output stagingFunctionAppName string = functionAppStagingSlotResource.name
output stagingTenantId string = functionAppStagingSlotResource.identity.tenantId
output stagingPrincipalId string = functionAppStagingSlotResource.identity.principalId

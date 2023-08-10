param storageAccount object
param resourceGroup object
param functionAppUKSPrincipalIds object
param functionAppUKWPrincipalIds object
param tags object

resource storageBlobDataContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccount.name
  location: resourceGroup.location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  tags: tags
}

resource blobServicesResource 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  parent: storageAccountResource
  name: 'default'
}

resource containerResourceCapabilities 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  parent: blobServicesResource
  name: 'capabilities'
  properties: {
    publicAccess: 'None'
  }
}

resource containeResourceWatermarks 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  parent: blobServicesResource
  name: 'orders'
  properties: {
    publicAccess: 'None'
  }
}

resource roleAssignmentBlobfunctionAppUKS 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppUKSPrincipalIds.functionApp, storageBlobDataContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalId: functionAppUKSPrincipalIds.functionApp
  }
}

resource roleAssignmentBlobfunctionAppUKSSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppUKSPrincipalIds.functionAppSlot, storageBlobDataContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalId: functionAppUKSPrincipalIds.functionAppSlot
  }
}

resource roleAssignmentBlobfunctionAppUKW 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppUKWPrincipalIds.functionApp, storageBlobDataContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalId: functionAppUKWPrincipalIds.functionApp
  }
}

resource roleAssignmentBlobfunctionAppUKWSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppUKWPrincipalIds.functionAppSlot, storageBlobDataContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinition.id
    principalId: functionAppUKWPrincipalIds.functionAppSlot
  }
}

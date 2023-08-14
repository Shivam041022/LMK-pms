targetScope = 'subscription'

param resourceGroupUKSParam object
param resourceGroupUKWParam object
// param logAnalyticsParam object
// param applicationInsightsParam object
// param functionAppUKSParam object
// param functionAppUKWParam object
// param storageAccountParam object
// param keyVaultParam object

param tagsParam object = {}

var serviceName = 'Quill'

module resourceGroupUKS 'Modules/resource-group.bicep' = {
  name: '${serviceName}--resource-group-uks'
  scope: subscription()
  params: {
    resourceGroup: resourceGroupUKSParam
    tags: tagsParam
  }
}

module resourceGroupUKW 'Modules/resource-group.bicep' = {
  name: '${serviceName}--resource-group-ukw'
  scope: subscription()
  params: {
    resourceGroup: resourceGroupUKWParam
    tags: tagsParam
  }
}

// module logAnalytics 'Modules/log-analytics.bicep' = {
//   scope: resourceGroup(resourceGroupUKSParam.name)
//   dependsOn: [
//     resourceGroupUKS
//   ]
//   name: '${serviceName}--log-analytics'
//   params: {
//     logAnalytics: logAnalyticsParam
//     location: resourceGroupUKSParam.location
//     tags: tagsParam
//   }
// }

// module applicationInsights 'Modules/application-insights.bicep' = {
//   scope: resourceGroup(resourceGroupUKSParam.name)
//   dependsOn: [
//     resourceGroupUKS
//     logAnalytics
//   ]
//   name: '${serviceName}--application-insights'
//   params: {
//     applicationInsights: applicationInsightsParam
//     logAnalytics: logAnalyticsParam
//     location: resourceGroupUKSParam.location
//     tags: tagsParam
//   }
// }

// module functionAppUKS 'Modules/function-app.bicep' = {
//   scope: resourceGroup(resourceGroupUKSParam.name)
//   dependsOn: [
//     resourceGroupUKS
//     logAnalytics
//   ]
//   name: '${serviceName}--function-app-uks'
//   params: {
//     functionApp: functionAppUKSParam
//     logAnalytics: logAnalyticsParam
//     location: resourceGroupUKSParam.location
//     tags: tagsParam
//   }
// }

// module functionAppUKW 'Modules/function-app.bicep' = {
//   scope: resourceGroup(resourceGroupUKWParam.name)
//   dependsOn: [
//     resourceGroupUKW
//     logAnalytics
//   ]
//   name: '${serviceName}--function-app-ukw'
//   params: {
//     functionApp: functionAppUKWParam
//     logAnalytics: logAnalyticsParam
//     location: resourceGroupUKWParam.location
//     tags: tagsParam
//   }
// }

// module storageAccount 'Modules/storage-account.bicep' = {
//   scope: resourceGroup(resourceGroupUKSParam.name)
//   dependsOn: [
//     resourceGroupUKS
//     functionAppUKS
//     functionAppUKW
//   ]
//   name: '${serviceName}--storage-account'
//   params: {
//     storageAccount: storageAccountParam
//     resourceGroup: resourceGroupUKSParam
//     functionAppUKSPrincipalIds: functionAppUKS.outputs.principalIds
//     functionAppUKWPrincipalIds: functionAppUKW.outputs.principalIds
//     tags: tagsParam
//   }


// }

// module keyVault 'Modules/key-vault.bicep' = {
//   scope: resourceGroup(resourceGroupUKSParam.name)
//   dependsOn: [
//     resourceGroupUKS
//     functionAppUKS
//     functionAppUKW
//   ]
//   name: '${serviceName}--key-vault'
//   params: {
//     keyVault: keyVaultParam
//     resourceGroup: resourceGroupUKSParam
//     functionAppUKSPrincipalIds: functionAppUKS.outputs.principalIds
//     functionAppUKWPrincipalIds: functionAppUKW.outputs.principalIds
//     tags: tagsParam
//   }
// }

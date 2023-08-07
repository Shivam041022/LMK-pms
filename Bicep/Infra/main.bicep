//targetScope = 'subscription'

param resourceGroupUKSParam object
param tagsParam object = {}

var serviceName = 'order-request-service'
module resourceGroupUKS 'Modules/resource-group.bicep' = {
  name: '${serviceName}-ResourceGroupUks'
  scope: subscription()
  params: {
    resourceGroup: resourceGroupUKSParam
    tags: tagsParam
  }
}

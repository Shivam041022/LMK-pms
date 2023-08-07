// targetScope='subscription'

param resourceGroup object
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroup.name
  location: resourceGroup.location
  tags: tags
}

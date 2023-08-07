param location string = resourceGroup().location
param rgName string = 'MyResourceGroup'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

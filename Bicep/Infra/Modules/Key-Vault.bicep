param keyVault object
param resourceGroup object
param functionAppUKSPrincipalIds object
param functionAppUKWPrincipalIds object
param tags object

resource keyVaultSecretsOfficerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
}

resource keyVaultSecretsUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}

resource keyVaultResource 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVault.name
  location: resourceGroup.location
  properties: {
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
  tags: tags
}


resource roleAssignmentDevopsServicePrincipal 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, keyVault.devopsServicePrincipalId, keyVaultSecretsOfficerRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsOfficerRoleDefinition.id
    principalId: keyVault.devopsServicePrincipalId
  }
}

resource roleAssignmentFunctionAppExternalUKS 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppUKSPrincipalIds.functionApp,  keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppUKSPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKSSlot 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppUKSPrincipalIds.functionAppSlot,  keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId:keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppUKSPrincipalIds.functionAppSlot
  }
}

resource roleAssignmentFunctionAppExternalUKW 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppUKWPrincipalIds.functionApp,  keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppUKWPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKWSlot 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppUKWPrincipalIds.functionAppSlot,  keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppUKWPrincipalIds.functionAppSlot
  }
}

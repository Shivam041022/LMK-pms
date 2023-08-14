param applicationInsights object
param functionApp object
param functionAppSettings object
param tags object

resource functionAppSlotResource 'Microsoft.Web/sites/slots@2021-02-01' existing = {
  name: format('{0}/{1}', functionApp.name, 'staging')
}

resource applicationInsightsResource 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsights.name
  scope: resourceGroup(applicationInsights.resourceGroup)
}

resource functionAppName_Staging_appsettings 'Microsoft.Web/sites/slots/config@2019-08-01' = {
  parent: functionAppSlotResource
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: reference(applicationInsightsResource.id, '2015-05-01').InstrumentationKey
    AzureFunctionsWebHost__hostid: functionAppSettings.AzureFunctionsWebHost__hostid
    AzureWebJobsSecretStorageType: 'Files'
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${functionApp.storageAccount.name};AccountKey=${listkeys(resourceId('Microsoft.Storage/storageAccounts', functionApp.storageAccount.name), '2019-04-01').keys[0].value};'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${functionApp.storageAccount.name};AccountKey=${listkeys(resourceId('Microsoft.Storage/storageAccounts', functionApp.storageAccount.name), '2019-04-01').keys[0].value};'
    WEBSITE_CONTENTSHARE: functionAppSettings.WEBSITE_CONTENTSHARE
    WEBSITE_RUN_FROM_PACKAGE: '1'
    WEBSITE_OVERRIDE_STICKY_EXTENSION_VERSIONS: '0'
    Environment: tags.environment
    Version: tags.version
    Orderv2ServiceTokenIssuer: functionAppSettings.orderv2ServiceTokenIssuer
    Orderv2ServiceUrl: functionAppSettings.orderv2ServiceUrl
    ProductServiceUrl:  functionAppSettings.productServiceUrl
    ProductRoutingHeaderKeyName: functionAppSettings.productRoutingHeaderKeyName
    HerokuApiBaseUrl:  functionAppSettings.herokuApiBaseUrl
    HerokuApiHeaderKeyName: functionAppSettings.herokuApiHeaderKeyName
    AccountServiceTokenIssuer: functionAppSettings.accountServiceTokenIssuer
    AccountServiceUrl: functionAppSettings.accountServiceUrl
    XifSearchFlowOrderInitializeLogicAppUrl: functionAppSettings.xifSearchFlowOrderInitializeLogicAppUrl
    XifSearchFlowSandboxOrderInitializeLogicAppUrl: functionAppSettings.xifSearchFlowSandboxOrderInitializeLogicAppUrl
    XifVerifyBasicAuthFunctionUrl: functionAppSettings.xifVerifyBasicAuthFunctionUrl
    ApplicationId: functionAppSettings.ApplicationId
    InitializeOrderBlobContainerName: functionAppSettings.InitializeOrderBlobContainerName
    SPOOBlobEndpoint: functionAppSettings.SPOOBlobEndpoint 
    IsEventServiceEnable: functionAppSettings.isEventServiceEnable
    ServiceBus__NamespaceUrl: functionAppSettings.serviceBusNamespaceUrl
    EventValidator__NewtonsoftSchemaKey: functionAppSettings.newtonsoftSchemaKey
    EventValidator__SchemaServiceUrl: functionAppSettings.schemaServiceUrl
    EventValidator__SchemaServiceAppIdUri: functionAppSettings.schemaServiceAppIdUri
    DocumentServiceUrl: functionAppSettings.documentServiceUrl
    DocumentServiceTokenIssuer: functionAppSettings.documentServiceTokenIssuer
    ProductDefinitionServiceUrl: functionAppSettings.productDefinitionServiceUrl
    ProductDefinitionServiceTokenIssuer: functionAppSettings.productDefinitionServiceTokenIssuer
    PromapBaseUri:  functionAppSettings.promapBaseUri
    KeyVault: functionAppSettings.keyVault
    Region: functionAppSettings.region
  }
}

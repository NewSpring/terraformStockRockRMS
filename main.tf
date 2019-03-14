module "resourceGroup" {
  source            = "git::https://github.com/newspring/terraformModules.git//azure/resourceGroup?ref=v0.0.1"
  location          = var.location
  resourceGroupName = var.resourceGroupName
  tags              = var.tags
}

module "sqlServer" {
  source                   = "git::https://github.com/newspring/terraformModules.git//azure/sqlServer?ref=v0.0.1"
  sqlServerName            = var.sqlServerName
  resourceGroupName        = module.resourceGroup.groupName
  location                 = var.location
  sqlAdministratorLogin    = var.sqlAdministratorLogin
  sqlAdministratorPassword = var.sqlAdministratorPassword
  tags                     = var.tags
}

module "sqlDatabase" {
  source                           = "git::https://github.com/newspring/terraformModules.git//azure/sqlDatabase?ref=v0.0.1"
  sqlDatabaseName                  = var.sqlDatabaseName
  resourceGroupName                = module.resourceGroup.groupName
  location                         = var.location
  sqlEdition                       = var.sqlEdition
  sqlCollation                     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  sqlCreateMode                    = var.sqlCreateMode
  sqlRequestedServiceObjectiveName = var.sqlRequestedServiceObjectiveName
  sqlServerName                    = module.sqlServer.sqlServerName
  tags                             = var.tags
}

module "sqlFirewall" {
  source            = "git::https://github.com/newspring/terraformModules.git//azure/sqlFirewall?ref=v0.0.1"
  firewallRuleName  = var.firewallRuleName
  resourceGroupName = module.resourceGroup.groupName
  sqlServerName     = module.sqlServer.sqlServerName
  startIpAddress    = var.startIpAddress
  endIpAddress      = var.endIpAddress

}
module "appServicePlan" {
  source                = "git::https://github.com/newspring/terraformModules.git//azure/appServicePlan?ref=v0.0.1"
  appServicePlanName    = var.appServicePlanName
  location              = var.location
  resourceGroupName     = module.resourceGroup.groupName
  appServicePlanSkuTier = var.appServicePlanSkuTier
  appServicePlanSkuSize = var.appServicePlanSkuSize
  tags                  = var.tags
}

module "appService" {
  source            = "git::https://github.com/newspring/terraformModules.git//azure/appService?ref=v0.0.1"
  appServiceName    = var.appServiceName
  location          = var.location
  resourceGroupName = var.resourceGroupName
  appServicePlanId  = module.appServicePlan.servicePlanId
  tags              = var.tags

  siteConfig = [
    {
      alwaysOn               = "true"
      dotnetFrameworkVersion = "v4.0"
      ftpsState              = "Disabled"
      http2Enabled           = "true"
      websocketsEnabled      = "true"
    },
  ]

  connectionString = [
    {
      connectionStringName  = "stockrockrms"
      connectionStringType  = "SQLAzure"
      connectionStringValue = ""
    },
  ]
}

resource "null_resource" "downloadRockRMS" {
  provisioner "local-exec" {
    command = "curl -L http://storage.rockrms.com/install/installer/rockrms-install.zip --output /tmp/rockrms-install.zip"
  }
}

resource "null_resource" "uploadRockRMS" {
  provisioner "local-exec" {
    command = "az webapp deployment source config-zip --resource-group ${module.resourceGroup.groupName} --name ${module.appService.appServiceName} --src /tmp/rockrms-install.zip"
  }
}

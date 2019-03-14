#Shared Variables

variable "resourceGroupName" {
}

variable "location" {
}

variable "tags" {
  type = map(string)
}


#sqlServer Variables

variable "sqlServerName" {
}

variable "sqlAdministratorLogin" {
}

variable "sqlAdministratorPassword" {
}

#sqlDatabase Variables

variable "sqlDatabaseName" {
}

variable "sqlEdition" {
}

variable "sqlCreateMode" {
}

variable "sqlRequestedServiceObjectiveName" {
}

#sqlFirewall Variables

variable "firewallRuleName" {
}

variable "startIpAddress" {
}

variable "endIpAddress" {
}

#appServicePlan Variables

variable "appServicePlanName" {
}

variable "appServicePlanSkuTier" {
}

variable "appServicePlanSkuSize" {
}

#appService Variables

variable "appServiceName" {
}

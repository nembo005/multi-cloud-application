data "azurerm_resource_group" "udacity" {
  name     = "Regroup_5em6I5PI4lzo"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-nemboazure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/nembo009/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-nembo-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-nembo-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######

resource "azurerm_mssql_server" "udacity_app" {
  name                         = "udacity-nembo-azure-sql"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "AdminMj"
  administrator_login_password = "R3s0urc3!MSSQL#2023"
}

 resource "azurerm_service_plan" "udacity" {
  name                = "udacity-nembo-app-service-plan"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name

  sku_name = "B1"
  os_type  = "Linux"

  tags = {
    environment = "udacity"
  }
}

resource "azurerm_linux_web_app" "udacity" {
  name                = "udacity-nembo-azure-dotnet-app"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  service_plan_id     = azurerm_service_plan.udacity.id

  site_config {
    always_on = true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "linux_fx_version" = "DOTNETCORE|5.0"
  }
}

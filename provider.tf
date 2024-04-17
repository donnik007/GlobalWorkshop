terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.98.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" { 
 features {} 
 subscription_id = "839cc4ef-d5b1-4e64-980b-42ae4d382d1d"
} 
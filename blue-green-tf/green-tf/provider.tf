terraform {
  backend "local" {
    path="/tmp/tfstates/v2/terraform.tfstate"
  }
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
      version = "1.0.1"
    }
  }
}

provider "citrixadc" {
  endpoint = "http://20.0.0.4"
  username = "nsroot"
  password = "nsroot@12345"
}

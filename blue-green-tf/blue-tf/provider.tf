terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
      version = "1.0.1"
    }
  }
}

provider "citrixadc" {
  endpoint = "http://20.0.0.4"
  username = var.username
  password = var.password
}

variable "location" { 
    type = string
default = "eastus" 
}
variable "rg_name" { 
    type = string 
default = "demo-rg" 
}

# Backend variables
variable "backend_rg_name" { 
    type = string 
default = "tfstate-rg" 
}
variable "backend_sa_name" { type = string }   # Must be globally unique
variable "backend_container_name" { 
    type = string 
default = "tfstate" 
}

# VNET / Subnet
variable "vnet_name" { 
    type = string 
default = "demo-vnet" 
}
variable "vnet_address" { 
    type = string 
    default = "10.0.0.0/16" 
    }
variable "subnet_name" { 
    type = string 
    default = "demo-subnet" 
    }
variable "subnet_address" { 
    type = string 
    default = "10.0.1.0/24" 
    }

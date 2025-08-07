terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.7"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@<UNRAID_IP_ADDRESS>/system?sshauth=privkey&keyfile=<PATH_TO_YOUR_PRIVATE_KEY>&no_verify=1"
}
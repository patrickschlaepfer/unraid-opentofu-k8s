# Generate random IDs for each item in a map or list
resource "libvirt_pool" "isos" {
    name = "isos"
    type = "dir"
    target {
        path = var.isos_path
    }
}

resource "random_id" "id" {
    count = length(var.instances)
    
    byte_length = 4
}

# Create a lookup map to get the random ID for each instance key
locals {
  random_id_map = { for idx, id in random_id.id : keys(var.instances)[idx] => id }
}

# Create cloud-init configuration files using template_file
data "template_file" "cloud_init_config" {
    for_each = var.instances

    template = file("${path.module}/cloud_user_data.tftpl")
    vars = {
        vm_name        = each.value.name
        user_name      = each.value.user_name
        ssh_public_key = local.ssh_public_key
    }
}

data "template_file" "network_config" {
    for_each = var.instances

    template = file("${path.module}/cloud_network_config.tftpl")

    vars = {
        ipv4 = each.value.ipv4
    }
}

# Create a libvirt_pool for domains (disk images)
resource "libvirt_pool" "domains" {
    name = "domains"
    type = "dir"
    target {
        path = var.domains_path
    }
}


# Create a libvirt_cloudinit_disk to create cloud-init ISOs
resource "libvirt_cloudinit_disk" "cloud_init" {
    for_each = var.instances

    name           = "${local.random_id_map[each.key].id}_cloud-init.iso"
    user_data      = data.template_file.cloud_init_config[each.key].rendered
    network_config = data.template_file.network_config[each.key].rendered
    pool           = libvirt_pool.isos.name
  
}

resource "libvirt_domain" "qemu-vm" {
    for_each = var.instances
    
    name   = each.value.name
    memory = each.value.memory
    vcpu   = each.value.cores
    autostart  = true
    qemu_agent = true

    cloudinit = libvirt_cloudinit_disk.cloud_init[each.key].id

    network_interface {
        bridge         = var.network_interface
        wait_for_lease = true
    }

    disk {
        volume_id = libvirt_volume.vm_volume[each.key].id
    }

    cpu {
        mode = "host-passthrough"
    }

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    graphics {
        type        = "spice"
        listen_type = "address"
        autoport    = true
    }
}

# Create virtual machine volumes in the domains pool
resource "libvirt_volume" "vm_image" {
    for_each   = var.instances

    name       = "${each.key}_image"
    pool       = libvirt_pool.isos.name
    source     = var.source_image
}

# Create virtual machine volumes in the domains pool
resource "libvirt_volume" "vm_volume" {
    for_each   = var.instances

    name           = "${each.key}_disk"
    pool           = libvirt_pool.domains.name
    base_volume_id = libvirt_volume.vm_image[each.key].id
    size           = each.value.disk_size_gb * 1024 * 1024 * 1024 # Size in bytes (GB * 1024^3)

}

resource "libvirt_network" "vm" {
  name      = "vm"
  mode      = "bridge"
  bridge    = var.network_interface
  addresses = [var.network_subnet]
  autostart = true
}

variable "network_subnet" {
    description = "Network subnet"
    type        = string
    default     = "10.3.1.0/24"
}

variable "network_interface" {
    description = "Network interface"
    type        = string
    default     = "br0"
}

variable "source_image" {
    description = "Base cloud image"
    type        = string
    default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
}

variable "isos_path" {
    description = "Path to ISOS"
    type        = string
    default     = "/mnt/data/isos/tofu"
}

variable "domains_path" {
    description = "Path to domains"
    type        = string
    default     = "/mnt/special/domains/tofu"
}

variable "ssh_public_key" {
  default     = "~/.ssh/id_ed25519.pub"
  type        = string
  description = "Path to your public key"
}

locals {
  ssh_public_key = file(var.ssh_public_key)
}

variable "instances" {
    type = map(object({
        name         = string
        cores        = number
        memory       = number
        user_name    = string
        ipv4         = string
        disk_size_gb = number
    }))
}
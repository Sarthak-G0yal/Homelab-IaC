terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name   = var.node_name
  vm_id       = var.vm_id
  name        = var.hostname
  description = "Managed by Terraform"
  tags        = var.tags

  on_boot = var.start_on_boot
  started = var.started

  agent {
    enabled = var.qemu_agent_enabled
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.iso_file_id
    interface    = "virtio0"
    size         = var.disk_size_gb
  }

  dynamic "disk" {
    for_each = var.extra_disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size
      file_format  = disk.value.file_format
    }
  }

  network_device {
    bridge = var.bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.datastore_id

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      keys     = var.ssh_public_keys
      password = var.root_password
      username = var.username
    }
  }
}

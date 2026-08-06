locals {
  lxc_template_url = coalesce(
    var.platform.template_url,
    "https://download.proxmox.com/images/system/${var.platform.template_filename}"
  )
}
resource "proxmox_virtual_environment_download_file" "image" {
  content_type = var.content_type
  datastore_id = var.disk_image_storage
  node_name    = var.node_name

  url       = var.image_url
  file_name = var.image_file_name
}

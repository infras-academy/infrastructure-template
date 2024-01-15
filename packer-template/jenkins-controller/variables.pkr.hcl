#Authenticate to Vcenter
variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}
variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = env("VCENTER_USERNAME")
  sensitive = true
}
variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = env("VCENTER_PASSWORD")
  sensitive = true
}
variable "vcenter_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}
variable "vcenter_host" {
  type    = string
  description = "Host name"
  default = ""
}
variable "vcenter_folder" {
  type    = string
  description = "Host name"
  default = ""
}
variable "vcenter_datastore" {
  type    = string
  description = "Datastore name"
  default = ""
}
// variable "vcenter_datacenter" {
//   type    = string
//   description = "vCenter URL."
//   default = ""
// }
variable "vm_name" {
  type    = string
  description = "The VM name"
  default = ""
}

variable "template_name" {
  type    = string
  description = "The template name"
  default = ""
}





variable "communicator" {
  type    = string
  description = "The template name"
  default = "ssh"
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = env("SSH_USERNAME")
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = env("SSH_PASSWORD")
  sensitive = true
}
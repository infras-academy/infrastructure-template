#Authenticate to Vcenter

# Basic config for datacenter, datastore, host and folder
variable "vcenter_datacenter" {
  type    = string
  description = "vCenter datacenter."
  default = "datacenter1"
}
variable "vcenter_datastore" {
  type    = string
  description = "Datastore name"
  default = "datastore2-hdd"
}
variable "vcenter_host" {
  type    = string
  description = "Host name"
  default = "192.168.1.201"
}
variable "vcenter_folder" {
  type    = string
  description = "VM Network"
  default = "VMs-template"
}

// variable "vcenter_datacenter" {
//   type    = string
//   description = "vCenter URL."
//   default = ""
// }
variable "vm_name" {
  type    = string
  description = "The VM name"
}

variable "template_name" {
  type    = string
  description = "The template name"
}

variable "communicator" {
  type    = string
  description = "The template name"
  default = "ssh"
}

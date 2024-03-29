#Authenticate to Vcenter

# Basic config for datacenter, datastore, host and folder
variable "vcenter_datacenter" {
  type    = string
  description = "vCenter URL."
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

variable "vm_name" {
  type    = string
  description = "The VM name"
  default = "jenkins-controller-base-template"
}

variable "template_name" {
  type    = string
  description = "The template name"
  default = "ubuntu-20.04-base-template"
}

variable "communicator" {
  type    = string
  description = "The template name"
  default = "ssh"
}

variable "jenkins_version" {
  type = string
  description = "Jenkins controller version to install"
#  default = "2.426.1"
}
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
  default = ""
}
variable "tools_upgrade_policy" {
  type    = bool
  default = true
}
variable "remove_cdrom" {
  type    = bool
  default = true
}
variable "vm_guest_os_type" {
  type    = string
  description = "Guest OS name"
  default = "ubuntu64Guest"
}

# The VM config
variable "vm_name" {
  type    = string
  description = "The VM name"
  default = "ubuntu-20.04-base-template"
}
variable "vm_cpu_sockets" {
  type = number
  description = "The number of virtual CPUs sockets."
  default = 2
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
  default = 2
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
  default = 4096
}
variable "vm_cdrom_type" {
  type    = string
  description = "The virtual machine CD-ROM type."
  default = "ide"
}
variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
  default = ["pvscsi"]
}

# Storage, network
variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
  default = 30720
  //30GiB
}

variable "vcenter_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = "VM Network"
}
variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  default = "vmxnet3"
}
variable "iso_paths" {
  type    = list(string)
  description = "The path on the source vSphere datastore for ISO images."
  default = ["[datastore2-hdd] vm-iso/ubuntu-20.04.5-live-server-amd64.iso"]
}
#variable "iso_checksum" {
#  type    = string
#  description = "The SHA-512 checkcum of the ISO image."
#  default = ""
#}
# HTTP Endpoint
variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = "http"
}
variable "vm_boot_order" {
  type    = string
  description = "Boot order."
  default = "disk,cdrom"
}
variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  default = "2s"
}

#variable "ssh_username" {
#  type    = string
#  description = "The username to use to authenticate over SSH."
#  default = env("SSH_USERNAME")
#  sensitive = true
#}
#
#variable "ssh_password" {
#  type    = string
#  description = "The plaintext password to use to authenticate over SSH."
#  default = env("SSH_PASSWORD")
#  sensitive = true
#}

# ISO Objects



// variable iso_file{
//   type = string
//   description = "The file name of the guest operating system ISO image installation media."
//   # https://releases.ubuntu.com/20.04/ubuntu-20.04.1-live-server-amd64.iso
//   default = ""
// }





// # Virtual Machine Settings

// variable "vm_guest_os_family" {
//   type    = string
//   description = "The guest operating system family."
//   default = ""
// }

// variable "vm_guest_os_vendor" {
//   type    = string
//   description = "The guest operating system vendor."
//   default = ""
// }

// variable "vm_guest_os_member" {
//   type    = string
//   description = "The guest operating system member."
//   default = ""
// }

// variable "vm_guest_os_version" {
//   type    = string
//   description = "The guest operating system version."
//   default = ""
// }



// variable "vm_firmware" {
//   type    = string
//   description = "The virtual machine firmware. (e.g. 'bios' or 'efi')"
//   default = ""
// }











#variable "shell_scripts" {
#  type = list(string)
#  description = "A list of scripts."
#  default = []
#}

packer {
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    git = {
      version = ">= 0.5.0"
      source  = "github.com/ethanmdavidson/git"
    }
  }
}

data "git-repository" "cwd" {}

locals {
  build_time = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = substr(local.build_time, 0, 10)
  onMain = data.git-repository.cwd.head == "main"

  vcenter_server = "vcenter.chuhuynh.local"
  vcenter_username = vault("/kv/data/vcenter", "user")
  vcenter_password = vault("/kv/data/vcenter", "password")
  ssh_username = vault("/kv/data/vcenter", "ssh_username")
  ssh_password = vault("/kv/data/vcenter", "ssh_password")
  insecure_connection = true
  vm_name = local.onMain ? "${var.vm_name}-${local.build_version}" : "${var.vm_name}-${local.build_version}-SNAPSHOT"

  ssh_port = 22
  ssh_timeout = "30m"

}

source "vsphere-iso" "ubuntu-server-base" {

  #Authenticate to Vcenter
  vcenter_server = local.vcenter_server
  username = local.vcenter_username
  password = local.vcenter_password
  insecure_connection = local.insecure_connection
  
  #Basic configuration for datacenter, datastore, host, folder
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  host = var.vcenter_host
  folder = var.vcenter_folder
  tools_upgrade_policy = var.tools_upgrade_policy
  remove_cdrom = var.remove_cdrom

  #The VM itself config
  vm_name = local.vm_name
  CPUs = var.vm_cpu_sockets
  cpu_cores = var.vm_cpu_cores
  RAM = var.vm_mem_size
  cdrom_type = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  guest_os_type = var.vm_guest_os_type


  storage {
    disk_size = var.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = true
  }
  network_adapters {
    network = var.vcenter_network
    network_card = var.vm_network_card
  }
  iso_paths = var.iso_paths
#  iso_checksum = "sha512:var.iso_checksum"
  http_directory = var.http_directory
  boot_order = var.vm_boot_order
  boot_wait = var.vm_boot_wait
  #add a <wait300> at the end of the boot_command to fix packer not detecting ip after restarting vm
  boot_command = [
    "<esc><esc><esc>",
    "<enter><wait>",
    "/casper/vmlinuz ",
    "root=/dev/sr0 ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter>",
    "<wait300>"
  ]
  ip_wait_timeout = "20m"
  ssh_username = local.ssh_username
  ssh_password = local.ssh_password
  ssh_port = local.ssh_port
  ssh_timeout = local.ssh_timeout
  ssh_handshake_attempts = "100000"
  shutdown_command = "echo '${local.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "15m"

  #This is important to convert to a template in Vcenter
  convert_to_template = true
  notes = "Built by HashiCorp Packer on ${local.build_time}."
}

build {
  sources = ["source.vsphere-iso.ubuntu-server-base"]
  // provisioner "shell" {
  //   execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
  //   environment_vars = [
  //     "BUILD_USERNAME=${var.ssh_username}",
  //   ]
  //   scripts = var.shell_scripts
  //   expect_disconnect = true
  // }
  provisioner "ansible" {
    user          = local.ssh_username
    playbook_file = "${path.cwd}/../../ansible/playbooks/ubuntu-20.04-base.yml"
    roles_path    = "${path.cwd}/../../ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/../../ansible/ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false",
      "--extra-vars", "BUILD_USERNAME=${local.ssh_username}"
    ]
  }

}
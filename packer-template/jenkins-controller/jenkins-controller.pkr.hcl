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
  insecure_connection = true

  ssh_username = vault("/kv/data/vcenter", "ssh_username")
  ssh_password = vault("/kv/data/vcenter", "ssh_password")
  vm_name = local.onMain ? "${var.vm_name}-${local.build_version}" : "${var.vm_name}-${local.build_version}-SNAPSHOT"

  ssh_port = 22
  ssh_timeout = "30m"

}

source "vsphere-clone" "jenkins-controller" {
  vcenter_server      = local.vcenter_server
  username            = local.vcenter_username
  password            = local.vcenter_password
  insecure_connection = local.insecure_connection

  host                = var.vcenter_host
  folder              = var.vcenter_folder
  datastore           = var.vcenter_datastore
  vm_name             = local.vm_name
  template            = var.template_name
  communicator        = var.communicator

  ssh_username        = local.ssh_username
  ssh_password        = local.ssh_password
  convert_to_template = true
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.vsphere-clone.jenkins-controller"]
  provisioner "ansible" {
    user          = local.ssh_username
    playbook_file = "${path.cwd}/../../ansible/playbooks/cicd/jenkins-controller.yml"
    roles_path    = "${path.cwd}/../../ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/../../ansible/ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false",
      "--extra-vars", "JENKINS_VERSION=${var.jenkins_version}"
    ]
  }
 }
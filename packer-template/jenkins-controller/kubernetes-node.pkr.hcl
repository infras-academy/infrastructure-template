source "vsphere-clone" "k8s" {
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_insecure_connection
  host                = var.vcenter_host
  folder                = var.vcenter_folder
  datastore           = var.vcenter_datastore
  vm_name             = var.vm_name
  template            = var.template_name
  communicator        = var.communicator
  ssh_username        = var.ssh_username
  ssh_password        = var.ssh_password
  convert_to_template = true
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.vsphere-clone.k8s"]
  provisioner "ansible" {
    user          = var.ssh_username
    playbook_file = "${path.cwd}/../../ansible/kubernetes-node.yml"
    roles_path    = "${path.cwd}/../../ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/../../ansible/ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false"
    ]
  }
 }
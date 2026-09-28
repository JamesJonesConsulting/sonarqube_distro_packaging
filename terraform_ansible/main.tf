terraform {
  required_providers {
    ansible = {
      version = "~> 1.4.0"
      source  = "ansible/ansible"
    }
  }
}

# data "ansible_inventory" "myinventory" {
#   group {
#     name = "webservers"

#     host {
#       name = "web1.example.com"
#     }
#   }
# }

# action "ansible_playbook_run" "with_inventories" {
#   config {
#     playbooks   = ["${path.module}/playbook.yml"]
#     inventories = [data.ansible_inventory.myinventory.json]

#     extra_vars = {
#       var_a = "Some variable"
#       var_b = "Another variable"
#     }
#   }
# }

action "ansible_playbook_run" "with_inventory_files" {
  config {
    playbooks       = ["../deploy/deploy.yml"]
    inventory_files = ["/home/jam/ymdllc/ansible_collections/ymdllc/inventory/inventory/jjones/home/hosts"]

    private_key_file = "/home/jam/.ssh/id_rsa"
    vault_password_file = "/home/jam/.ssh/ansible-vault"
    become = true
    ansible_playbook_binary = "/usr/bin/ansible-playbook"
    extra_vars = {
      target_group = "sonarqube"
    }

  }
}

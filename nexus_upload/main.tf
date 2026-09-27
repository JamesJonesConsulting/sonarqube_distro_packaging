terraform {
  backend "http" {
    address     = "https://nexus.jamesjonesconsulting.com/repository/yum-hosted-arch"
    lock_address = "https://nexus.jamesjonesconsulting.com/repository/yum-hosted-arch"
    unlock_address = "https://nexus.jamesjonesconsulting.com/repository/yum-hosted-arch"
  }
}

data "terraform_remote_state" "foo" {
  backend = "http"
  config = {
    address = "https://nexus.jamesjonesconsulting.com/repository/yum-hosted-arch"
  }
}

# (C) Copyright 2021-2024 Hewlett Packard Enterprise Development LP

#  Set-up for terraform
terraform {
  required_providers {
    hpegl = {
      source = "HPE/hpegl"
      version = "0.4.10"
    }
  }
}

provider "hpegl" {
  vmaas {
    location   = var.location
    space_name = var.space
  }
}

data "hpegl_vmaas_cloud" "cloud" {
  name = var.cloud
}

data "hpegl_vmaas_datastore" "c_3par" {
  cloud_id = data.hpegl_vmaas_cloud.cloud.id
  name     = var.datastore
}

data "hpegl_vmaas_group" "terraform_group" {
  name = var.group
}

data "hpegl_vmaas_resource_pool" "cl_resource_pool" {
  cloud_id = data.hpegl_vmaas_cloud.cloud.id
  name     = var.resource_pool
}

data "hpegl_vmaas_layout" "vmware" {
  name               = var.layout
  instance_type_code = var.instance_type
}

data "hpegl_vmaas_plan" "g1_small" {
  name = var.service_plan
}

data "hpegl_vmaas_environment" "env" {
  name = var.environment
}

data "hpegl_vmaas_template" "ubuntu" {
  name = var.template
}

data "hpegl_vmaas_cloud_folder" "compute_folder" {
  cloud_id = data.hpegl_vmaas_cloud.cloud.id
  name     = var.compute_folder
}

data "hpegl_vmaas_network" "tf_network" {
  name = var.network
}

resource "random_integer" "random" {
  min = 1
  max = 50000
}

resource "hpegl_vmaas_instance" "demo_vm" {
  count              = 1
  name               = "${var.instance_name}-${random_integer.random.result}-${count.index}"
  cloud_id           = data.hpegl_vmaas_cloud.cloud.id
  group_id           = data.hpegl_vmaas_group.terraform_group.id
  layout_id          = data.hpegl_vmaas_layout.vmware.id
  plan_id            = data.hpegl_vmaas_plan.g1_small.id
  instance_type_code = data.hpegl_vmaas_layout.vmware.instance_type_code
  network {
    id = data.hpegl_vmaas_network.tf_network.id
  }
  environment_code = data.hpegl_vmaas_environment.env.code
  volume {
    name         = "root_vol"
    size         = 30
    datastore_id = data.hpegl_vmaas_datastore.c_3par.id
    root         = true
  }
  labels = ["demo_vm"]
  tags = {
    purpose = "demo"
  }
  hostname = "${var.instance_name}-${random_integer.random.result}-${count.index}"
  config {
    resource_pool_id = data.hpegl_vmaas_resource_pool.cl_resource_pool.id
    template_id      = data.hpegl_vmaas_template.ubuntu.id
    no_agent         = false
    asset_tag        = "vm_tag"
    folder_code      = data.hpegl_vmaas_cloud_folder.compute_folder.code
    create_user      = true
  }
}
## VM Provisioning using TF code

1. Run terraform init to initialize the HPEGL Provider
2. Run terraform plan command to validate everything
   `terraform plan -var-file=./variables_tenant.tfvars`
3. Run terraform apply to provision
   `terraform apply -var-file=./variables_tenant.tfvars`
4. Verify that Virtual Machine and Virtual Network are provisioned successfully.

## Deployment details

### terraform init

```sh
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hpe/hpegl versions matching "0.4.10"...
- Finding latest version of hashicorp/random...
- Installing hpe/hpegl v0.4.10...
- Installed hpe/hpegl v0.4.10 (signed by a HashiCorp partner, key ID D1F277A1AC66CE3D)
- Installing hashicorp/random v3.6.3...
- Installed hashicorp/random v3.6.3 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### terraform apply

```sh
$ terraform plan --var-file=variables_tenant.tfvars
data.hpegl_vmaas_network.tf_network: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_plan.g1_small: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_environment.env: Reading...
data.hpegl_vmaas_template.ubuntu: Reading...
data.hpegl_vmaas_group.terraform_group: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [10s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [10s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [20s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [20s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [20s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [30s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [30s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [30s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [30s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [30s elapsed]
data.hpegl_vmaas_network.tf_network: Read complete after 32s [id=14]
data.hpegl_vmaas_layout.vmware: Read complete after 32s [id=933]
data.hpegl_vmaas_cloud.cloud: Read complete after 32s [id=1]
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 1s [id=3]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 1s [id=6]
data.hpegl_vmaas_environment.env: Read complete after 33s [id=1]
data.hpegl_vmaas_template.ubuntu: Read complete after 33s [id=960]
data.hpegl_vmaas_plan.g1_small: Read complete after 33s [id=407]
data.hpegl_vmaas_group.terraform_group: Read complete after 34s [id=17]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hpegl_vmaas_instance.demo_vm[0] will be created
  + resource "hpegl_vmaas_instance" "demo_vm" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + environment_code   = "dev"
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "Ubuntu-vm"
      + labels             = [
          + "demo_vm",
        ]
      + layout_id          = 933
      + name               = (known after apply)
      + plan_id            = 407
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "purpose" = "demo"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 960
        }

      + network {
          + id          = 14
          + internal_id = (known after apply)
          + is_primary  = (known after apply)
          + name        = (known after apply)
        }

      + volume {
          + datastore_id = "1"
          + id           = (known after apply)
          + name         = "root_vol"
          + root         = true
          + size         = 30
        }
    }

  # random_integer.random will be created
  + resource "random_integer" "random" {
      + id     = (known after apply)
      + max    = 50000
      + min    = 1
      + result = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

### terraform apply

```sh
$ terraform apply --var-file=variables_tenant.tfvars
data.hpegl_vmaas_environment.env: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_plan.g1_small: Reading...
data.hpegl_vmaas_template.ubuntu: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_network.tf_network: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_environment.env: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [10s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [10s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [10s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [20s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [20s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [20s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [30s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [30s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [30s elapsed]
data.hpegl_vmaas_template.ubuntu: Read complete after 33s [id=960]
data.hpegl_vmaas_group.terraform_group: Read complete after 33s [id=17]
data.hpegl_vmaas_plan.g1_small: Read complete after 33s [id=407]
data.hpegl_vmaas_network.tf_network: Read complete after 33s [id=14]
data.hpegl_vmaas_layout.vmware: Read complete after 33s [id=933]
data.hpegl_vmaas_environment.env: Read complete after 34s [id=1]
data.hpegl_vmaas_cloud.cloud: Read complete after 34s [id=1]
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 0s [id=3]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hpegl_vmaas_instance.demo_vm[0] will be created
  + resource "hpegl_vmaas_instance" "demo_vm" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + environment_code   = "dev"
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "Ubuntu-vm"
      + labels             = [
          + "demo_vm",
        ]
      + layout_id          = 933
      + name               = (known after apply)
      + plan_id            = 407
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "purpose" = "demo"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 960
        }

      + network {
          + id          = 14
          + internal_id = (known after apply)
          + is_primary  = (known after apply)
          + name        = (known after apply)
        }

      + volume {
          + datastore_id = "1"
          + id           = (known after apply)
          + name         = "root_vol"
          + root         = true
          + size         = 30
        }
    }

  # random_integer.random will be created
  + resource "random_integer" "random" {
      + id     = (known after apply)
      + max    = 50000
      + min    = 1
      + result = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_integer.random: Creating...
random_integer.random: Creation complete after 0s [id=8431]
hpegl_vmaas_instance.demo_vm[0]: Creating...
hpegl_vmaas_instance.demo_vm[0]: Still creating... [10s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [20s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [30s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [40s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [50s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m20s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m30s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m40s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [1m50s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still creating... [2m0s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Creation complete after 2m9s [id=609]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

### terraform destroy

```sh
$ terraform destroy --var-file=variables_tenant.tfvars
random_integer.random: Refreshing state... [id=47879]
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_environment.env: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_plan.g1_small: Reading...
data.hpegl_vmaas_template.ubuntu: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_network.tf_network: Reading...
data.hpegl_vmaas_group.terraform_group: Still reading... [10s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [10s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [10s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [20s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [20s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [20s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_plan.g1_small: Still reading... [30s elapsed]
data.hpegl_vmaas_environment.env: Still reading... [30s elapsed]
data.hpegl_vmaas_template.ubuntu: Still reading... [30s elapsed]
data.hpegl_vmaas_network.tf_network: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_environment.env: Read complete after 34s [id=1]
data.hpegl_vmaas_network.tf_network: Read complete after 34s [id=14]
data.hpegl_vmaas_template.ubuntu: Read complete after 34s [id=960]
data.hpegl_vmaas_cloud.cloud: Read complete after 34s [id=1]
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_plan.g1_small: Read complete after 34s [id=407]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 1s [id=3]
data.hpegl_vmaas_layout.vmware: Read complete after 35s [id=933]
data.hpegl_vmaas_group.terraform_group: Read complete after 35s [id=17]
hpegl_vmaas_instance.demo_vm[0]: Refreshing state... [id=627]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # hpegl_vmaas_instance.demo_vm[0] will be destroyed
  - resource "hpegl_vmaas_instance" "demo_vm" {
      - cloud_id           = 1 -> null
      - containers         = [
          - {
              - container_type = [
                  - {
                      - name = "Ubuntu-20"
                    },
                ]
              - external_fqdn  = "greenboat-vm107-vm-47879-0.localdomain"
              - hostname       = "greenboat-vm107-vm-47879-0"
              - id             = 655
              - ip             = "172.20.20.19"
              - max_cores      = 1
              - max_memory     = 4294967296
              - max_storage    = 32212254720
              - name           = "Greenboat VM107 VM-47879-0_655"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-12T08:39:17Z"
                      - id                  = 665
                      - last_updated        = "2024-11-12T08:47:48Z"
                      - owner               = [
                          - {
                              - username = "ng-vmaas-api"
                            },
                        ]
                      - platform            = "ubuntu"
                      - platform_version    = "20.04"
                      - server_os           = [
                          - {
                              - name = "ubuntu 64-bit"
                            },
                        ]
                      - ssh_host            = "172.20.20.11"
                      - ssh_port            = 22
                      - visibility          = "private"
                    },
                ]
            },
        ] -> null
      - environment_code   = "dev" -> null
      - group_id           = 17 -> null
      - history            = [
          - {
              - account_id   = 2
              - created_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
              - date_created = "2024-11-12T08:40:47Z"
              - display_name = "Greenboat VM107 VM-47879-0"
              - duration     = 747
              - end_date     = "2024-11-12T08:40:48Z"
              - id           = 3736
              - instance_id  = 627
              - last_updated = "2024-11-12T08:40:48Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - reason       = ""
              - start_date   = "2024-11-12T08:40:47Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "90272d02-e290-4920-b554-7dde850b5744"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
            },
          - {
              - account_id   = 2
              - created_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
              - date_created = "2024-11-12T08:39:17Z"
              - display_name = "Greenboat VM107 VM-47879-0"
              - duration     = 90170
              - end_date     = "2024-11-12T08:40:47Z"
              - id           = 3735
              - instance_id  = 627
              - last_updated = "2024-11-12T08:40:47Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - reason       = ""
              - start_date   = "2024-11-12T08:39:17Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "a87cef05-30c2-458b-8d7b-9e6227a7d7ef"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
            },
        ] -> null
      - hostname           = "Greenboat VM107 VM-47879-0" -> null
      - id                 = "627" -> null
      - instance_type_code = "Ubuntu-vm" -> null
      - labels             = [
          - "demo_vm",
        ] -> null
      - layout_id          = 933 -> null
      - name               = "Greenboat VM107 VM-47879-0" -> null
      - plan_id            = 407 -> null
      - server_id          = 665 -> null
      - status             = "running" -> null
      - tags               = {
          - "purpose" = "demo"
        } -> null

      - config {
          - asset_tag        = "vm_tag" -> null
          - create_user      = true -> null
          - folder_code      = "group-v40" -> null
          - no_agent         = false -> null
          - resource_pool_id = 3 -> null
          - template_id      = 960 -> null
        }

      - network {
          - id           = 14 -> null
          - interface_id = 0 -> null
          - internal_id  = 832 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2215:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 933 -> null
          - name         = "root_vol" -> null
          - root         = true -> null
          - size         = 30 -> null
          - storage_type = 1 -> null
        }
    }

  # random_integer.random will be destroyed
  - resource "random_integer" "random" {
      - id     = "47879" -> null
      - max    = 50000 -> null
      - min    = 1 -> null
      - result = 47879 -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

hpegl_vmaas_instance.demo_vm[0]: Destroying... [id=627]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 10s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 20s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 30s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 40s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 50s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Still destroying... [id=627, 1m0s elapsed]
hpegl_vmaas_instance.demo_vm[0]: Destruction complete after 1m5s
random_integer.random: Destroying... [id=47879]
random_integer.random: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
```

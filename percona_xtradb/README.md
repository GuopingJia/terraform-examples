#Copyright 2021-2024 Hewlett Packard Enterprise Development LP

# Percona XtraDB cluster

Percona XtraDB Cluster (PXC) is a high availability, open-source, MySQL clustering solution that helps enterprises minimize unexpected downtime and data loss, reduce costs, and improve the performance and scalability of your database environments

This readme is intended to capture the steps to spin up a database in VMaaS on-demand.

## Percona XtraDB cluster in VMaaS

The following steps bring up 3-node PerconaDB XtraDB cluster in HPE GreenLake for Private Cloud Enterprise.

- Prerequisites
    ```sh
    1. CentOS 7.x virtual image in GLPC
    2. An API client to authenticate with HPE GreenLake
    ```
- Install Terraform
    ```sh
    https://learn.hashicorp.com/tutorials/terraform/install-cli (>=v0.13)
    ```
- Download Ansible
    ```sh
    https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
    ```
- Install HPE GreenLake Terraform provider
    ```sh
    bash <(curl -sL https://raw.githubusercontent.com/HewlettPackard/terraform-provider-hpegl/main/tools/install-hpegl-provider.sh)
    ```
- Clone the repository
    ```sh
    git clone https://github.com/guopingjia/terraform-examples.git
    cd terraform-examples/percona_xtradb/ 
    ```
- Update the variables.tf
- Export the environment variables
    ```sh
    #### API Client Credentials
    export HPEGL_TENANT_ID=< tenant-id >
    export HPEGL_USER_ID=< service client id >
    export HPEGL_USER_SECRET=< service client secret >
    export HPEGL_IAM_SERVICE_URL=< the "issuer" URL for the service client  >
 
    #### TF VARS
    export TF_VAR_vm_password=<Remote host password>
    export TF_VAR_vm_username=<Reomte host username>
    export TF_VAR_percona_root_password=<PerconaDB root password>
    export TF_VAR_sst_password=<PerconaDB sst password>
    export TF_VAR_sst_user=<PerconaDB sst username>
    ```
- Run Terraform plan and apply
    ```sh
    terraform init
    terraform plan
    terraform apply
    terraform show
    terraform destroy
    ```

## Verifying Replication

Use the following procedure to verify replication by creating a new database on the second node, creating a table for that database on the third node, and adding some records to the table on the first node.

- Create a new database on the second node
    ```sh
    mysql@pxc2> CREATE DATABASE percona;
    Query OK, 1 row affected (0.01 sec)
    ```
- Create a table on the third node
    ```sh
    mysql@pxc3> USE percona;
    Database changed
    
    mysql@pxc3> CREATE TABLE example (node_id INT PRIMARY KEY, node_name VARCHAR(30));
    Query OK, 0 rows affected (0.05 sec)
    ```
- Insert records on the first node
    ```sh
    mysql@pxc1> INSERT INTO percona.example VALUES (1, 'percona1');
    Query OK, 1 row affected (0.02 sec)
    ```
- Retrieve rows from the table on the second node
    ```sh
    mysql@pxc2> SELECT * FROM percona.example;
    +---------+-----------+
    | node_id | node_name |
    +---------+-----------+
    |       1 | percona1  |
    +---------+-----------+
    1 row in set (0.00 sec)
    ```
## Outputs of Terraform run

### terraform init

```sh
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/null...
- Finding hpe/hpegl versions matching ">= 0.3.0"...
- Installing hpe/hpegl v0.4.14...
- Installed hpe/hpegl v0.4.14 (signed by a HashiCorp partner, key ID D1F277A1AC66CE3D)
- Installing hashicorp/random v3.6.3...
- Installed hashicorp/random v3.6.3 (signed by HashiCorp)
- Installing hashicorp/null v3.2.3...
- Installed hashicorp/null v3.2.3 (signed by HashiCorp)
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

### terraform plan

```sh
$ terraform plan
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_layout.vmware: Read complete after 0s [id=113]
data.hpegl_vmaas_cloud.cloud: Read complete after 0s [id=1]
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_plan.g1_large: Read complete after 0s [id=408]
data.hpegl_vmaas_network.network: Read complete after 0s [id=14]
data.hpegl_vmaas_group.terraform_group: Read complete after 0s [id=17]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 0s [id=3]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]
data.hpegl_vmaas_template.vanilla: Read complete after 1s [id=961]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hpegl_vmaas_instance.boot_node will be created
  + resource "hpegl_vmaas_instance" "boot_node" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # hpegl_vmaas_instance.node1 will be created
  + resource "hpegl_vmaas_instance" "node1" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # hpegl_vmaas_instance.node2 will be created
  + resource "hpegl_vmaas_instance" "node2" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # null_resource.DeployPersona will be created
  + resource "null_resource" "DeployPersona" {
      + id = (known after apply)
    }

  # random_integer.random will be created
  + resource "random_integer" "random" {
      + id     = (known after apply)
      + max    = 50000
      + min    = 1
      + result = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + boot_node_ip = [
      + (known after apply),
    ]
  + node1_ip     = [
      + (known after apply),
    ]
  + node2_ip     = [
      + (known after apply),
    ]

────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take
exactly these actions if you run "terraform apply" now.
```

### terraform apply

```sh
$ terraform apply
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_template.vanilla: Read complete after 0s [id=961]
data.hpegl_vmaas_cloud.cloud: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_plan.g1_large: Read complete after 0s [id=408]
data.hpegl_vmaas_network.network: Read complete after 0s [id=14]
data.hpegl_vmaas_layout.vmware: Read complete after 0s [id=113]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 1s [id=3]
data.hpegl_vmaas_group.terraform_group: Read complete after 1s [id=17]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hpegl_vmaas_instance.boot_node will be created
  + resource "hpegl_vmaas_instance" "boot_node" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # hpegl_vmaas_instance.node1 will be created
  + resource "hpegl_vmaas_instance" "node1" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # hpegl_vmaas_instance.node2 will be created
  + resource "hpegl_vmaas_instance" "node2" {
      + cloud_id           = 1
      + containers         = (known after apply)
      + group_id           = 17
      + history            = (known after apply)
      + hostname           = (known after apply)
      + id                 = (known after apply)
      + instance_type_code = "vmware"
      + labels             = [
          + "DBaaS",
        ]
      + layout_id          = 113
      + name               = (known after apply)
      + plan_id            = 408
      + server_id          = (known after apply)
      + status             = (known after apply)
      + tags               = {
          + "Environment" = "Development"
        }

      + config {
          + asset_tag        = "vm_tag"
          + create_user      = true
          + folder_code      = "group-v40"
          + no_agent         = false
          + resource_pool_id = 3
          + template_id      = 961
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
          + size         = 50
        }
    }

  # null_resource.DeployPersona will be created
  + resource "null_resource" "DeployPersona" {
      + id = (known after apply)
    }

  # random_integer.random will be created
  + resource "random_integer" "random" {
      + id     = (known after apply)
      + max    = 50000
      + min    = 1
      + result = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + boot_node_ip = [
      + (known after apply),
    ]
  + node1_ip     = [
      + (known after apply),
    ]
  + node2_ip     = [
      + (known after apply),
    ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_integer.random: Creating...
random_integer.random: Creation complete after 0s [id=32073]
hpegl_vmaas_instance.boot_node: Creating...
hpegl_vmaas_instance.node2: Creating...
hpegl_vmaas_instance.node1: Creating...
hpegl_vmaas_instance.node2: Still creating... [10s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [10s elapsed]
hpegl_vmaas_instance.node1: Still creating... [10s elapsed]
hpegl_vmaas_instance.node2: Still creating... [20s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [20s elapsed]
hpegl_vmaas_instance.node1: Still creating... [20s elapsed]
hpegl_vmaas_instance.node2: Still creating... [30s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [30s elapsed]
hpegl_vmaas_instance.node1: Still creating... [30s elapsed]
hpegl_vmaas_instance.node2: Still creating... [40s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [40s elapsed]
hpegl_vmaas_instance.node1: Still creating... [40s elapsed]
hpegl_vmaas_instance.node2: Still creating... [50s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [50s elapsed]
hpegl_vmaas_instance.node1: Still creating... [50s elapsed]
hpegl_vmaas_instance.node2: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.node2: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.node1: Creation complete after 1m18s [id=658]
hpegl_vmaas_instance.boot_node: Creation complete after 1m18s [id=657]
hpegl_vmaas_instance.node2: Creation complete after 1m18s [id=656]
null_resource.DeployPersona: Creating...
null_resource.DeployPersona: Provisioning with 'local-exec'...
null_resource.DeployPersona (local-exec): Executing: ["/bin/sh" "-c" "    # Remove host entry from known_hosts if exists\n    ssh-keyscan -H 172.20.20.17 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.17\n    ssh-keyscan -H 172.20.20.18 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.18\n    ssh-keyscan -H 172.20.20.16 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.16\n    # Add sleep for the infrastructure to be ready before running the playbook\n    sleep 120\n    echo \"Trigger ansible playbook to bring-up perconaDB boot node\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.17' -e 'NODE1_IP=172.20.20.18' -e 'NODE2_IP=172.20.20.16' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.17,' percona_boot_node.yml\n    echo \"Trigger ansible playbook to bring-up node1\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.17' -e 'NODE1_IP=172.20.20.18' -e 'NODE2_IP=172.20.20.16' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.18,' percona_node.yml\n    echo \"Trigger ansible playbook to bring-up node2\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.17' -e 'NODE1_IP=172.20.20.18' -e 'NODE2_IP=172.20.20.16' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.16,' percona_node.yml\n"]
null_resource.DeployPersona (local-exec): # 172.20.20.17:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.17:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.17:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.17:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.17:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.17 found: line 4
null_resource.DeployPersona (local-exec): # Host 172.20.20.17 found: line 5
null_resource.DeployPersona (local-exec): # Host 172.20.20.17 found: line 6
null_resource.DeployPersona (local-exec): /home/pce-trial/.ssh/known_hosts updated.
null_resource.DeployPersona (local-exec): Original contents retained as /home/pce-trial/.ssh/known_hosts.old
null_resource.DeployPersona (local-exec): # 172.20.20.18:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.18:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.18:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.18:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.18:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.18 found: line 4
null_resource.DeployPersona (local-exec): # Host 172.20.20.18 found: line 5
null_resource.DeployPersona (local-exec): # Host 172.20.20.18 found: line 6
null_resource.DeployPersona (local-exec): /home/pce-trial/.ssh/known_hosts updated.
null_resource.DeployPersona (local-exec): Original contents retained as /home/pce-trial/.ssh/known_hosts.old
null_resource.DeployPersona (local-exec): # 172.20.20.16:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.16:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.16:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.16:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.16:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.16 found: line 4
null_resource.DeployPersona (local-exec): # Host 172.20.20.16 found: line 5
null_resource.DeployPersona (local-exec): # Host 172.20.20.16 found: line 6
null_resource.DeployPersona (local-exec): /home/pce-trial/.ssh/known_hosts updated.
null_resource.DeployPersona (local-exec): Original contents retained as /home/pce-trial/.ssh/known_hosts.old
null_resource.DeployPersona: Still creating... [10s elapsed]
null_resource.DeployPersona: Still creating... [20s elapsed]
null_resource.DeployPersona: Still creating... [30s elapsed]
null_resource.DeployPersona: Still creating... [40s elapsed]
null_resource.DeployPersona: Still creating... [50s elapsed]
null_resource.DeployPersona: Still creating... [1m0s elapsed]
null_resource.DeployPersona: Still creating... [1m10s elapsed]
null_resource.DeployPersona: Still creating... [1m20s elapsed]
null_resource.DeployPersona: Still creating... [1m30s elapsed]
null_resource.DeployPersona: Still creating... [1m40s elapsed]
null_resource.DeployPersona: Still creating... [1m50s elapsed]
null_resource.DeployPersona: Still creating... [2m0s elapsed]
null_resource.DeployPersona (local-exec): Trigger ansible playbook to bring-up perconaDB boot node
null_resource.DeployPersona (local-exec): [DEPRECATION WARNING]: "include" is deprecated, use include_tasks/import_tasks
null_resource.DeployPersona (local-exec): instead. This feature will be removed in version 2.16. Deprecation warnings can
null_resource.DeployPersona (local-exec):  be disabled by setting deprecation_warnings=False in ansible.cfg.

null_resource.DeployPersona (local-exec): PLAY [Install Percona BootNode] ************************************************

null_resource.DeployPersona (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Replace CentOS-Base.repo] ************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : yum-clean-all] ***********************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Percona repository] **********************************
null_resource.DeployPersona: Still creating... [2m10s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Enable original release] *************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Enable tools release] ****************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Percona-XtraDB cluster] ******************************
null_resource.DeployPersona: Still creating... [2m20s elapsed]
null_resource.DeployPersona: Still creating... [2m30s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Python MYSQL module] *********************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Detect and properly set root password] ***********************
null_resource.DeployPersona (local-exec): ok: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start Percona-XtraDB Service] ********************************
null_resource.DeployPersona: Still creating... [2m40s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start firewalld] *********************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : insert firewalld rule] ***************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17] => (item=3306)
null_resource.DeployPersona (local-exec): changed: [172.20.20.17] => (item=4444)
null_resource.DeployPersona (local-exec): changed: [172.20.20.17] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.17] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.17] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [boot_node : shell] *******************************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Set new password from temporary password] ********************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Copy my.cnf] *************************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Stop Percona-XtraDB Service] *********************************
null_resource.DeployPersona: Still creating... [2m50s elapsed]
null_resource.DeployPersona: Still creating... [3m0s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create the wsrep conf file] **********************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start Percona-XtraDB Bootstrap Service] **********************
null_resource.DeployPersona: Still creating... [3m10s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create database user with password and all database privileges and 'WITH GRANT OPTION'] ***
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create database user with password and all database privileges and 'WITH GRANT OPTION'] ***
null_resource.DeployPersona (local-exec): changed: [172.20.20.17]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.17               : ok=20   changed=17   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona (local-exec): Trigger ansible playbook to bring-up node1
null_resource.DeployPersona (local-exec): [DEPRECATION WARNING]: "include" is deprecated, use include_tasks/import_tasks
null_resource.DeployPersona (local-exec): instead. This feature will be removed in version 2.16. Deprecation warnings can
null_resource.DeployPersona (local-exec):  be disabled by setting deprecation_warnings=False in ansible.cfg.

null_resource.DeployPersona (local-exec): PLAY [Install Percona BootNode] ************************************************

null_resource.DeployPersona (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Replace CentOS-Base.repo] *****************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : yum-clean-all] ****************************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona repository] ***************************************
null_resource.DeployPersona: Still creating... [3m20s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Enable original release] ******************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Enable tools release] *********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona-XtraDB cluster] ***********************************
null_resource.DeployPersona: Still creating... [3m30s elapsed]
null_resource.DeployPersona: Still creating... [3m40s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Install Python MYSQL module] **************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Enable Percona-XtraDB Service] ************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Start firewalld] **************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : insert firewalld rule] ********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18] => (item=3306)
null_resource.DeployPersona: Still creating... [3m50s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.18] => (item=4444)
null_resource.DeployPersona (local-exec): changed: [172.20.20.18] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.18] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.18] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [node : Create the wsrep conf file] ***************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): TASK [node : Start Percona-XtraDB Service] *************************************
null_resource.DeployPersona: Still creating... [4m0s elapsed]
null_resource.DeployPersona: Still creating... [4m10s elapsed]
null_resource.DeployPersona: Still creating... [4m20s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.18]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.18               : ok=13   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona (local-exec): Trigger ansible playbook to bring-up node2
null_resource.DeployPersona (local-exec): [DEPRECATION WARNING]: "include" is deprecated, use include_tasks/import_tasks
null_resource.DeployPersona (local-exec): instead. This feature will be removed in version 2.16. Deprecation warnings can
null_resource.DeployPersona (local-exec):  be disabled by setting deprecation_warnings=False in ansible.cfg.

null_resource.DeployPersona (local-exec): PLAY [Install Percona BootNode] ************************************************

null_resource.DeployPersona (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Replace CentOS-Base.repo] *****************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : yum-clean-all] ****************************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona repository] ***************************************
null_resource.DeployPersona: Still creating... [4m30s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Enable original release] ******************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Enable tools release] *********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona-XtraDB cluster] ***********************************
null_resource.DeployPersona: Still creating... [4m40s elapsed]
null_resource.DeployPersona: Still creating... [4m50s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Install Python MYSQL module] **************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Enable Percona-XtraDB Service] ************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Start firewalld] **************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : insert firewalld rule] ********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.16] => (item=3306)
null_resource.DeployPersona (local-exec): changed: [172.20.20.16] => (item=4444)
null_resource.DeployPersona (local-exec): changed: [172.20.20.16] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.16] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.16] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [node : Create the wsrep conf file] ***************************************
null_resource.DeployPersona: Still creating... [5m0s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): TASK [node : Start Percona-XtraDB Service] *************************************
null_resource.DeployPersona: Still creating... [5m10s elapsed]
null_resource.DeployPersona: Still creating... [5m20s elapsed]
null_resource.DeployPersona: Still creating... [5m30s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.16]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.16               : ok=13   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona: Creation complete after 5m32s [id=4827985361085728567]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

boot_node_ip = [
  "172.20.20.17",
]
node1_ip = [
  "172.20.20.18",
]
node2_ip = [
  "172.20.20.16",
]
```

### terraform show

```sh
$ terraform show
# data.hpegl_vmaas_cloud.cloud:
data "hpegl_vmaas_cloud" "cloud" {
    id   = "1"
    name = "HPE GreenLake VMaaS Cloud-Trial2"
}

# data.hpegl_vmaas_cloud_folder.compute_folder:
data "hpegl_vmaas_cloud_folder" "compute_folder" {
    cloud_id = "1"
    code     = "group-v40"
    id       = "6"
    name     = "ComputeFolder"
}

# data.hpegl_vmaas_datastore.c_3par:
data "hpegl_vmaas_datastore" "c_3par" {
    cloud_id = "1"
    id       = "1"
    name     = "toro-gl1-trial2-Vol1"
}

# data.hpegl_vmaas_group.terraform_group:
data "hpegl_vmaas_group" "terraform_group" {
    id   = "17"
    name = "Department B Group"
}

# data.hpegl_vmaas_layout.vmware:
data "hpegl_vmaas_layout" "vmware" {
    id                 = "113"
    instance_type_code = "vmware"
    name               = "Vmware VM"
}

# data.hpegl_vmaas_network.network:
data "hpegl_vmaas_network" "network" {
    id   = "14"
    name = "Green-Net"
}

# data.hpegl_vmaas_plan.g1_large:
data "hpegl_vmaas_plan" "g1_large" {
    id   = "408"
    name = "G1-Medium"
}

# data.hpegl_vmaas_resource_pool.cl_resource_pool:
data "hpegl_vmaas_resource_pool" "cl_resource_pool" {
    cloud_id = "1"
    id       = "3"
    name     = "ComputeResourcePool"
}

# data.hpegl_vmaas_template.vanilla:
data "hpegl_vmaas_template" "vanilla" {
    id   = "961"
    name = "vanilla-centos-7-x86_64-18062020"
}

# hpegl_vmaas_instance.boot_node:
resource "hpegl_vmaas_instance" "boot_node" {
    cloud_id           = 1
    containers         = [
        {
            container_type = [
                {
                    name = "VMware"
                },
            ]
            external_fqdn  = "Greenboat PerconaDB-32073.localdomain"
            hostname       = "Greenboat PerconaDB-32073"
            id             = 684
            ip             = "172.20.20.17"
            max_cores      = 2
            name           = "Greenboat PerconaDB-boot-32073_684"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-14T19:56:11Z"
                    id                  = 694
                    last_updated        = "2024-11-14T19:57:25Z"
                    owner               = [
                        {
                            username = "ng-vmaas-api"
                        },
                    ]
                    platform            = "centos"
                    platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                    server_os           = [
                        {
                            name = "centOS 7 64-bit"
                        },
                    ]
                    ssh_host            = "172.20.20.17"
                    ssh_port            = 22
                    visibility          = "private"
                },
            ]
        },
    ]
    group_id           = 17
    history            = [
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:57:24Z"
            display_name = "Greenboat PerconaDB-boot-32073"
            duration     = 238
            end_date     = "2024-11-14T19:57:24Z"
            id           = 3874
            instance_id  = 657
            last_updated = "2024-11-14T19:57:24Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:57:24Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "0dc51872-4da5-4608-ae21-7ecda24e0349"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:56:12Z"
            display_name = "Greenboat PerconaDB-boot-32073"
            duration     = 71707
            end_date     = "2024-11-14T19:57:24Z"
            id           = 3870
            instance_id  = 657
            last_updated = "2024-11-14T19:57:24Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:56:12Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "13e6c14d-cf5a-4e32-9803-b6c2a94d8bfa"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-32073"
    id                 = "657"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-boot-32073"
    plan_id            = 408
    server_id          = 694
    status             = "running"
    tags               = {
        "Environment" = "Development"
    }

    config {
        asset_tag        = "vm_tag"
        create_user      = true
        folder_code      = "group-v40"
        no_agent         = false
        resource_pool_id = 3
        template_id      = 961
    }

    network {
        id           = 14
        interface_id = 0
        internal_id  = 862
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2305:0:6:0"
        datastore_id = "1"
        id           = 963
        name         = "root_vol"
        root         = true
        size         = 50
        storage_type = 1
    }
}

# hpegl_vmaas_instance.node1:
resource "hpegl_vmaas_instance" "node1" {
    cloud_id           = 1
    containers         = [
        {
            container_type = [
                {
                    name = "VMware"
                },
            ]
            external_fqdn  = "Greenboat PerconaDB-32073.localdomain"
            hostname       = "Greenboat PerconaDB-32073"
            id             = 685
            ip             = "172.20.20.18"
            max_cores      = 2
            name           = "Greenboat PerconaDB-node1-32073_685"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-14T19:56:11Z"
                    id                  = 695
                    last_updated        = "2024-11-14T19:57:23Z"
                    owner               = [
                        {
                            username = "ng-vmaas-api"
                        },
                    ]
                    platform            = "centos"
                    platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                    server_os           = [
                        {
                            name = "centOS 7 64-bit"
                        },
                    ]
                    ssh_host            = "172.20.20.18"
                    ssh_port            = 22
                    visibility          = "private"
                },
            ]
        },
    ]
    group_id           = 17
    history            = [
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:57:22Z"
            display_name = "Greenboat PerconaDB-node1-32073"
            duration     = 466
            end_date     = "2024-11-14T19:57:22Z"
            id           = 3872
            instance_id  = 658
            last_updated = "2024-11-14T19:57:22Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:57:22Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "9b5a7048-ea43-47f4-ab73-b5a75376ecbb"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:56:12Z"
            display_name = "Greenboat PerconaDB-node1-32073"
            duration     = 69987
            end_date     = "2024-11-14T19:57:22Z"
            id           = 3871
            instance_id  = 658
            last_updated = "2024-11-14T19:57:22Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:56:12Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "38cbe2da-4a3a-4ab8-bf1c-3f66a9859206"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-32073"
    id                 = "658"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-node1-32073"
    plan_id            = 408
    server_id          = 695
    status             = "running"
    tags               = {
        "Environment" = "Development"
    }

    config {
        asset_tag        = "vm_tag"
        create_user      = true
        folder_code      = "group-v40"
        no_agent         = false
        resource_pool_id = 3
        template_id      = 961
    }

    network {
        id           = 14
        interface_id = 0
        internal_id  = 863
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2308:0:6:0"
        datastore_id = "1"
        id           = 964
        name         = "root_vol"
        root         = true
        size         = 50
        storage_type = 1
    }
}

# hpegl_vmaas_instance.node2:
resource "hpegl_vmaas_instance" "node2" {
    cloud_id           = 1
    containers         = [
        {
            container_type = [
                {
                    name = "VMware"
                },
            ]
            external_fqdn  = "Greenboat PerconaDB-32073.localdomain"
            hostname       = "Greenboat PerconaDB-32073"
            id             = 683
            ip             = "172.20.20.16"
            max_cores      = 2
            name           = "Greenboat PerconaDB-node2-32073_683"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-14T19:56:11Z"
                    id                  = 693
                    last_updated        = "2024-11-14T19:57:24Z"
                    owner               = [
                        {
                            username = "ng-vmaas-api"
                        },
                    ]
                    platform            = "centos"
                    platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                    server_os           = [
                        {
                            name = "centOS 7 64-bit"
                        },
                    ]
                    ssh_host            = "172.20.20.16"
                    ssh_port            = 22
                    visibility          = "private"
                },
            ]
        },
    ]
    group_id           = 17
    history            = [
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:57:23Z"
            display_name = "Greenboat PerconaDB-node2-32073"
            duration     = 946
            end_date     = "2024-11-14T19:57:24Z"
            id           = 3873
            instance_id  = 656
            last_updated = "2024-11-14T19:57:24Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:57:23Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "bcd9558e-e22b-498e-b8b9-9aebc99b0ac1"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
        {
            account_id   = 2
            created_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
            date_created = "2024-11-14T19:56:12Z"
            display_name = "Greenboat PerconaDB-node2-32073"
            duration     = 71074
            end_date     = "2024-11-14T19:57:23Z"
            id           = 3869
            instance_id  = 656
            last_updated = "2024-11-14T19:57:23Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-14T19:56:12Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "d0d94442-e271-49ef-9161-a525e463f257"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-32073"
    id                 = "656"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-node2-32073"
    plan_id            = 408
    server_id          = 693
    status             = "running"
    tags               = {
        "Environment" = "Development"
    }

    config {
        asset_tag        = "vm_tag"
        create_user      = true
        folder_code      = "group-v40"
        no_agent         = false
        resource_pool_id = 3
        template_id      = 961
    }

    network {
        id           = 14
        interface_id = 0
        internal_id  = 861
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2302:0:6:0"
        datastore_id = "1"
        id           = 962
        name         = "root_vol"
        root         = true
        size         = 50
        storage_type = 1
    }
}

# null_resource.DeployPersona:
resource "null_resource" "DeployPersona" {
    id = "4827985361085728567"
}

# random_integer.random:
resource "random_integer" "random" {
    id     = "32073"
    max    = 50000
    min    = 1
    result = 32073
}


Outputs:

boot_node_ip = [
    "172.20.20.17",
]
node1_ip = [
    "172.20.20.18",
]
node2_ip = [
    "172.20.20.16",
]
```

### terraform destroy

```sh
$ terraform destroy
random_integer.random: Refreshing state... [id=32073]
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_cloud.cloud: Read complete after 0s [id=1]
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_layout.vmware: Read complete after 0s [id=113]
data.hpegl_vmaas_template.vanilla: Read complete after 0s [id=961]
data.hpegl_vmaas_network.network: Read complete after 0s [id=14]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 1s [id=6]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 1s [id=3]
data.hpegl_vmaas_plan.g1_large: Read complete after 1s [id=408]
data.hpegl_vmaas_group.terraform_group: Read complete after 1s [id=17]
hpegl_vmaas_instance.boot_node: Refreshing state... [id=657]
hpegl_vmaas_instance.node1: Refreshing state... [id=658]
hpegl_vmaas_instance.node2: Refreshing state... [id=656]
null_resource.DeployPersona: Refreshing state... [id=4827985361085728567]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # hpegl_vmaas_instance.boot_node will be destroyed
  - resource "hpegl_vmaas_instance" "boot_node" {
      - cloud_id           = 1 -> null
      - containers         = [
          - {
              - container_type = [
                  - {
                      - name = "VMware"
                    },
                ]
              - external_fqdn  = "Greenboat PerconaDB-32073.localdomain"
              - hostname       = "Greenboat PerconaDB-32073"
              - id             = 684
              - ip             = "172.20.20.17"
              - max_cores      = 2
              - name           = "Greenboat PerconaDB-boot-32073_684"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-14T19:56:11Z"
                      - id                  = 694
                      - last_updated        = "2024-11-15T17:56:29Z"
                      - owner               = [
                          - {
                              - username = "ng-vmaas-api"
                            },
                        ]
                      - platform            = "centos"
                      - platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                      - server_os           = [
                          - {
                              - name = "centOS 7 64-bit"
                            },
                        ]
                      - ssh_host            = "172.20.20.17"
                      - ssh_port            = 22
                      - visibility          = "private"
                    },
                ]
            },
        ] -> null
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
              - date_created = "2024-11-14T19:57:24Z"
              - display_name = "Greenboat PerconaDB-boot-32073"
              - duration     = 238
              - end_date     = "2024-11-14T19:57:24Z"
              - id           = 3874
              - instance_id  = 657
              - last_updated = "2024-11-14T19:57:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:57:24Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "0dc51872-4da5-4608-ae21-7ecda24e0349"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
          - {
              - account_id   = 2
              - created_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
              - date_created = "2024-11-14T19:56:12Z"
              - display_name = "Greenboat PerconaDB-boot-32073"
              - duration     = 71707
              - end_date     = "2024-11-14T19:57:24Z"
              - id           = 3870
              - instance_id  = 657
              - last_updated = "2024-11-14T19:57:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:56:12Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "13e6c14d-cf5a-4e32-9803-b6c2a94d8bfa"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-32073" -> null
      - id                 = "657" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-boot-32073" -> null
      - plan_id            = 408 -> null
      - server_id          = 694 -> null
      - status             = "running" -> null
      - tags               = {
          - "Environment" = "Development"
        } -> null

      - config {
          - asset_tag        = "vm_tag" -> null
          - create_user      = true -> null
          - folder_code      = "group-v40" -> null
          - no_agent         = false -> null
          - resource_pool_id = 3 -> null
          - template_id      = 961 -> null
        }

      - network {
          - id           = 14 -> null
          - interface_id = 0 -> null
          - internal_id  = 862 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2305:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 963 -> null
          - name         = "root_vol" -> null
          - root         = true -> null
          - size         = 50 -> null
          - storage_type = 1 -> null
        }
    }

  # hpegl_vmaas_instance.node1 will be destroyed
  - resource "hpegl_vmaas_instance" "node1" {
      - cloud_id           = 1 -> null
      - containers         = [
          - {
              - container_type = [
                  - {
                      - name = "VMware"
                    },
                ]
              - external_fqdn  = "greenboatperconadb-32073.localdomain"
              - hostname       = "greenboatperconadb-32073"
              - id             = 685
              - ip             = "172.20.20.18"
              - max_cores      = 2
              - name           = "Greenboat PerconaDB-node1-32073_685"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-14T19:56:11Z"
                      - id                  = 695
                      - last_updated        = "2024-11-15T17:56:27Z"
                      - owner               = [
                          - {
                              - username = "ng-vmaas-api"
                            },
                        ]
                      - platform            = "centos"
                      - platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                      - server_os           = [
                          - {
                              - name = "centOS 7 64-bit"
                            },
                        ]
                      - ssh_host            = "172.20.20.18"
                      - ssh_port            = 22
                      - visibility          = "private"
                    },
                ]
            },
        ] -> null
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
              - date_created = "2024-11-14T19:57:22Z"
              - display_name = "Greenboat PerconaDB-node1-32073"
              - duration     = 466
              - end_date     = "2024-11-14T19:57:22Z"
              - id           = 3872
              - instance_id  = 658
              - last_updated = "2024-11-14T19:57:22Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:57:22Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "9b5a7048-ea43-47f4-ab73-b5a75376ecbb"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
          - {
              - account_id   = 2
              - created_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
              - date_created = "2024-11-14T19:56:12Z"
              - display_name = "Greenboat PerconaDB-node1-32073"
              - duration     = 69987
              - end_date     = "2024-11-14T19:57:22Z"
              - id           = 3871
              - instance_id  = 658
              - last_updated = "2024-11-14T19:57:22Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:56:12Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "38cbe2da-4a3a-4ab8-bf1c-3f66a9859206"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-32073" -> null
      - id                 = "658" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-node1-32073" -> null
      - plan_id            = 408 -> null
      - server_id          = 695 -> null
      - status             = "running" -> null
      - tags               = {
          - "Environment" = "Development"
        } -> null

      - config {
          - asset_tag        = "vm_tag" -> null
          - create_user      = true -> null
          - folder_code      = "group-v40" -> null
          - no_agent         = false -> null
          - resource_pool_id = 3 -> null
          - template_id      = 961 -> null
        }

      - network {
          - id           = 14 -> null
          - interface_id = 0 -> null
          - internal_id  = 863 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2308:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 964 -> null
          - name         = "root_vol" -> null
          - root         = true -> null
          - size         = 50 -> null
          - storage_type = 1 -> null
        }
    }

  # hpegl_vmaas_instance.node2 will be destroyed
  - resource "hpegl_vmaas_instance" "node2" {
      - cloud_id           = 1 -> null
      - containers         = [
          - {
              - container_type = [
                  - {
                      - name = "VMware"
                    },
                ]
              - external_fqdn  = "Greenboat PerconaDB-32073.localdomain"
              - hostname       = "Greenboat PerconaDB-32073"
              - id             = 683
              - ip             = "172.20.20.16"
              - max_cores      = 2
              - name           = "Greenboat PerconaDB-node2-32073_683"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-14T19:56:11Z"
                      - id                  = 693
                      - last_updated        = "2024-11-15T17:56:33Z"
                      - owner               = [
                          - {
                              - username = "ng-vmaas-api"
                            },
                        ]
                      - platform            = "centos"
                      - platform_version    = "3.10.0-1127.10.1.el7.x86_64"
                      - server_os           = [
                          - {
                              - name = "centOS 7 64-bit"
                            },
                        ]
                      - ssh_host            = "172.20.20.16"
                      - ssh_port            = 22
                      - visibility          = "private"
                    },
                ]
            },
        ] -> null
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
              - date_created = "2024-11-14T19:57:23Z"
              - display_name = "Greenboat PerconaDB-node2-32073"
              - duration     = 946
              - end_date     = "2024-11-14T19:57:24Z"
              - id           = 3873
              - instance_id  = 656
              - last_updated = "2024-11-14T19:57:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:57:23Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "bcd9558e-e22b-498e-b8b9-9aebc99b0ac1"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
          - {
              - account_id   = 2
              - created_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
              - date_created = "2024-11-14T19:56:12Z"
              - display_name = "Greenboat PerconaDB-node2-32073"
              - duration     = 71074
              - end_date     = "2024-11-14T19:57:23Z"
              - id           = 3869
              - instance_id  = 656
              - last_updated = "2024-11-14T19:57:23Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-14T19:56:12Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "d0d94442-e271-49ef-9161-a525e463f257"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-32073" -> null
      - id                 = "656" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-node2-32073" -> null
      - plan_id            = 408 -> null
      - server_id          = 693 -> null
      - status             = "running" -> null
      - tags               = {
          - "Environment" = "Development"
        } -> null

      - config {
          - asset_tag        = "vm_tag" -> null
          - create_user      = true -> null
          - folder_code      = "group-v40" -> null
          - no_agent         = false -> null
          - resource_pool_id = 3 -> null
          - template_id      = 961 -> null
        }

      - network {
          - id           = 14 -> null
          - interface_id = 0 -> null
          - internal_id  = 861 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2302:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 962 -> null
          - name         = "root_vol" -> null
          - root         = true -> null
          - size         = 50 -> null
          - storage_type = 1 -> null
        }
    }

  # null_resource.DeployPersona will be destroyed
  - resource "null_resource" "DeployPersona" {
      - id = "4827985361085728567" -> null
    }

  # random_integer.random will be destroyed
  - resource "random_integer" "random" {
      - id     = "32073" -> null
      - max    = 50000 -> null
      - min    = 1 -> null
      - result = 32073 -> null
    }

Plan: 0 to add, 0 to change, 5 to destroy.

Changes to Outputs:
  - boot_node_ip = [
      - "172.20.20.17",
    ] -> null
  - node1_ip     = [
      - "172.20.20.18",
    ] -> null
  - node2_ip     = [
      - "172.20.20.16",
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.DeployPersona: Destroying... [id=4827985361085728567]
null_resource.DeployPersona: Destruction complete after 0s
hpegl_vmaas_instance.node2: Destroying... [id=656]
hpegl_vmaas_instance.node1: Destroying... [id=658]
hpegl_vmaas_instance.boot_node: Destroying... [id=657]
hpegl_vmaas_instance.node2: Still destroying... [id=656, 10s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=657, 10s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=658, 10s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=656, 20s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=657, 20s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=658, 20s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=656, 30s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=657, 30s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=658, 30s elapsed]
hpegl_vmaas_instance.node2: Destruction complete after 31s
hpegl_vmaas_instance.node1: Destruction complete after 31s
hpegl_vmaas_instance.boot_node: Still destroying... [id=657, 40s elapsed]
hpegl_vmaas_instance.boot_node: Destruction complete after 47s
random_integer.random: Destroying... [id=32073]
random_integer.random: Destruction complete after 0s

Destroy complete! Resources: 5 destroyed.
```

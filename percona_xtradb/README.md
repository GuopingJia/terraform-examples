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
- Finding hpe/hpegl versions matching "0.4.10"...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/null...
- Installing hashicorp/null v3.2.3...
- Installed hashicorp/null v3.2.3 (signed by HashiCorp)
- Installing hpe/hpegl v0.4.10...
- Installed hpe/hpegl v0.4.10 (signed by a HashiCorp partner, key ID D1F277A1AC66CE3D)
- Installing hashicorp/random v3.6.3...
- Installed hashicorp/random v3.6.3 (signed by HashiCorp)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository so that Terraform can guarantee to make the same selections by default when you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see any changes that are required for your infrastructure. All Terraform commands should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other commands will detect it and remind you to do so if necessary.
    ```

### terraform plan

    ```sh
$ terraform plan
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_group.terraform_group: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [10s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_network.network: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [20s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [20s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [20s elapsed]
data.hpegl_vmaas_network.network: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [30s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [30s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [30s elapsed]
data.hpegl_vmaas_network.network: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Read complete after 32s [id=1]
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_datastore.c_3par: Read complete after 1s [id=1]
data.hpegl_vmaas_group.terraform_group: Read complete after 33s [id=17]
data.hpegl_vmaas_plan.g1_large: Read complete after 33s [id=408]
data.hpegl_vmaas_template.vanilla: Read complete after 33s [id=961]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 2s [id=6]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 2s [id=3]
data.hpegl_vmaas_network.network: Read complete after 34s [id=14]
data.hpegl_vmaas_layout.vmware: Read complete after 34s [id=113]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
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

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    ```

### terraform apply

    ```sh
$ terraform apply
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_group.terraform_group: Read complete after 2s [id=17]
data.hpegl_vmaas_plan.g1_large: Read complete after 2s [id=408]
data.hpegl_vmaas_template.vanilla: Read complete after 2s [id=961]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_network.network: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_network.network: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_network.network: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Read complete after 32s [id=113]
data.hpegl_vmaas_network.network: Read complete after 33s [id=14]
data.hpegl_vmaas_cloud.cloud: Read complete after 33s [id=1]
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 0s [id=3]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
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
random_integer.random: Creation complete after 0s [id=35470]
hpegl_vmaas_instance.node1: Creating...
hpegl_vmaas_instance.boot_node: Creating...
hpegl_vmaas_instance.node2: Creating...
hpegl_vmaas_instance.node1: Still creating... [10s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [10s elapsed]
hpegl_vmaas_instance.node2: Still creating... [10s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [20s elapsed]
hpegl_vmaas_instance.node1: Still creating... [20s elapsed]
hpegl_vmaas_instance.node2: Still creating... [20s elapsed]
hpegl_vmaas_instance.node1: Still creating... [30s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [30s elapsed]
hpegl_vmaas_instance.node2: Still creating... [30s elapsed]
hpegl_vmaas_instance.node1: Still creating... [40s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [40s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [50s elapsed]
hpegl_vmaas_instance.node1: Still creating... [50s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m0s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m10s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m20s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m20s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m30s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m30s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m40s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m40s elapsed]
hpegl_vmaas_instance.boot_node: Still creating... [1m50s elapsed]
hpegl_vmaas_instance.node1: Still creating... [1m50s elapsed]
hpegl_vmaas_instance.boot_node: Creation complete after 1m52s [id=639]
hpegl_vmaas_instance.node1: Still creating... [2m0s elapsed]
…
…
…
null_resource.DeployPersona: Provisioning with 'local-exec'...
null_resource.DeployPersona (local-exec): Executing: ["/bin/sh" "-c" "    # Remove host entry from known_hosts if exists\n    ssh-keyscan -H 172.20.20.27 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.27\n    ssh-keyscan -H 172.20.20.21 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.21\n    ssh-keyscan -H 172.20.20.28 >> ~/.ssh/known_hosts\n    ssh-keygen -R 172.20.20.28\n    # Add sleep for the infrastructure to be ready before running the playbook\n    sleep 120\n    echo \"Trigger ansible playbook to bring-up perconaDB boot node\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.27' -e 'NODE1_IP=172.20.20.21' -e 'NODE2_IP=172.20.20.28' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.27,' percona_boot_node.yml\n    echo \"Trigger ansible playbook to bring-up node1\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.27' -e 'NODE1_IP=172.20.20.21' -e 'NODE2_IP=172.20.20.28' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.21,' percona_node.yml\n    echo \"Trigger ansible playbook to bring-up node2\"\n    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -e 'SST_USER=percona_user' -e 'SST_PASSWORD=Password@123' -e 'BOOT_NODE_IP=172.20.20.27' -e 'NODE1_IP=172.20.20.21' -e 'NODE2_IP=172.20.20.28' -e 'ansible_user=pce-trial' -e 'ansible_ssh_pass=trial@tr2' -e 'ansible_sudo_pass=trial@tr2'  -e 'MYSQL_ROOT_PASSWORD=Password@123' -i '172.20.20.28,' percona_node.yml\n"]
null_resource.DeployPersona (local-exec): # 172.20.20.27:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.27:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.27:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.27:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.27:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.27 found: line 1
null_resource.DeployPersona (local-exec): # Host 172.20.20.27 found: line 4
null_resource.DeployPersona (local-exec): # Host 172.20.20.27 found: line 5
null_resource.DeployPersona (local-exec): # Host 172.20.20.27 found: line 6
null_resource.DeployPersona (local-exec): /home/pce-trial/.ssh/known_hosts updated.
null_resource.DeployPersona (local-exec): Original contents retained as /home/pce-trial/.ssh/known_hosts.old
null_resource.DeployPersona (local-exec): # 172.20.20.21:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.21:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.21:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.21:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.21:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.21 found: line 1
null_resource.DeployPersona (local-exec): # Host 172.20.20.21 found: line 3
null_resource.DeployPersona (local-exec): # Host 172.20.20.21 found: line 4
null_resource.DeployPersona (local-exec): # Host 172.20.20.21 found: line 5
null_resource.DeployPersona (local-exec): /home/pce-trial/.ssh/known_hosts updated.
null_resource.DeployPersona (local-exec): Original contents retained as /home/pce-trial/.ssh/known_hosts.old
null_resource.DeployPersona (local-exec): # 172.20.20.28:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.28:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.28:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.28:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # 172.20.20.28:22 SSH-2.0-OpenSSH_7.4
null_resource.DeployPersona (local-exec): # Host 172.20.20.28 found: line 1
null_resource.DeployPersona (local-exec): # Host 172.20.20.28 found: line 2
null_resource.DeployPersona (local-exec): # Host 172.20.20.28 found: line 3
null_resource.DeployPersona (local-exec): # Host 172.20.20.28 found: line 4
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
null_resource.DeployPersona (local-exec): ok: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Replace CentOS-Base.repo] ************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : yum-clean-all] ***********************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Percona repository] **********************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Enable original release] *************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Enable tools release] ****************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Percona-XtraDB cluster] ******************************
null_resource.DeployPersona: Still creating... [2m10s elapsed]
null_resource.DeployPersona: Still creating... [2m20s elapsed]
null_resource.DeployPersona: Still creating... [2m30s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Install Python MYSQL module] *********************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Detect and properly set root password] ***********************
null_resource.DeployPersona (local-exec): ok: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start Percona-XtraDB Service] ********************************
null_resource.DeployPersona: Still creating... [2m40s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start firewalld] *********************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : insert firewalld rule] ***************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27] => (item=3306)
null_resource.DeployPersona (local-exec): changed: [172.20.20.27] => (item=4444)
null_resource.DeployPersona (local-exec): changed: [172.20.20.27] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.27] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.27] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [boot_node : shell] *******************************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Set new password from temporary password] ********************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Copy my.cnf] *************************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Stop Percona-XtraDB Service] *********************************
null_resource.DeployPersona: Still creating... [2m50s elapsed]
null_resource.DeployPersona: Still creating... [3m0s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create the wsrep conf file] **********************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Start Percona-XtraDB Bootstrap Service] **********************
null_resource.DeployPersona: Still creating... [3m10s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create database user with password and all database privileges and 'WITH GRANT OPTION'] ***
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): TASK [boot_node : Create database user with password and all database privileges and 'WITH GRANT OPTION'] ***
null_resource.DeployPersona (local-exec): changed: [172.20.20.27]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.27               : ok=20   changed=15   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona (local-exec): Trigger ansible playbook to bring-up node1
null_resource.DeployPersona (local-exec): [DEPRECATION WARNING]: "include" is deprecated, use include_tasks/import_tasks
null_resource.DeployPersona (local-exec): instead. This feature will be removed in version 2.16. Deprecation warnings can
null_resource.DeployPersona (local-exec):  be disabled by setting deprecation_warnings=False in ansible.cfg.

null_resource.DeployPersona (local-exec): PLAY [Install Percona BootNode] ************************************************

null_resource.DeployPersona (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Replace CentOS-Base.repo] *****************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : yum-clean-all] ****************************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona repository] ***************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Enable original release] ******************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Enable tools release] *********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona-XtraDB cluster] ***********************************
null_resource.DeployPersona: Still creating... [3m20s elapsed]
null_resource.DeployPersona: Still creating... [3m30s elapsed]
null_resource.DeployPersona: Still creating... [3m40s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Install Python MYSQL module] **************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Enable Percona-XtraDB Service] ************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Start firewalld] **************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : insert firewalld rule] ********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.21] => (item=3306)
null_resource.DeployPersona (local-exec): changed: [172.20.20.21] => (item=4444)
null_resource.DeployPersona (local-exec): changed: [172.20.20.21] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.21] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.21] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [node : Create the wsrep conf file] ***************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): TASK [node : Start Percona-XtraDB Service] *************************************
null_resource.DeployPersona: Still creating... [3m50s elapsed]
null_resource.DeployPersona: Still creating... [4m0s elapsed]
null_resource.DeployPersona: Still creating... [4m10s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.21]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.21               : ok=13   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona (local-exec): Trigger ansible playbook to bring-up node2
null_resource.DeployPersona (local-exec): [DEPRECATION WARNING]: "include" is deprecated, use include_tasks/import_tasks
null_resource.DeployPersona (local-exec): instead. This feature will be removed in version 2.16. Deprecation warnings can
null_resource.DeployPersona (local-exec):  be disabled by setting deprecation_warnings=False in ansible.cfg.

null_resource.DeployPersona (local-exec): PLAY [Install Percona BootNode] ************************************************

null_resource.DeployPersona (local-exec): TASK [Gathering Facts] *********************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Replace CentOS-Base.repo] *****************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : yum-clean-all] ****************************************************
null_resource.DeployPersona (local-exec): [WARNING]: Consider using the yum module rather than running 'yum'.  If you
null_resource.DeployPersona (local-exec): need to use 'yum' because the yum module is insufficient you can add 'warn:
null_resource.DeployPersona (local-exec): false' to this command task or set 'command_warnings=False' in the defaults
null_resource.DeployPersona (local-exec): section of ansible.cfg to get rid of this message.
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona repository] ***************************************
null_resource.DeployPersona: Still creating... [4m20s elapsed]
null_resource.DeployPersona (local-exec): ok: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Enable original release] ******************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Enable tools release] *********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Install Percona-XtraDB cluster] ***********************************
null_resource.DeployPersona: Still creating... [4m30s elapsed]
null_resource.DeployPersona: Still creating... [4m40s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Install Python MYSQL module] **************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Enable Percona-XtraDB Service] ************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Start firewalld] **************************************************
null_resource.DeployPersona (local-exec): ok: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : insert firewalld rule] ********************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.28] => (item=3306)
null_resource.DeployPersona (local-exec): changed: [172.20.20.28] => (item=4444)
null_resource.DeployPersona: Still creating... [4m50s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.28] => (item=4567)
null_resource.DeployPersona (local-exec): changed: [172.20.20.28] => (item=4568)
null_resource.DeployPersona (local-exec): changed: [172.20.20.28] => (item=9200)

null_resource.DeployPersona (local-exec): TASK [node : Create the wsrep conf file] ***************************************
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): TASK [node : Start Percona-XtraDB Service] *************************************
null_resource.DeployPersona: Still creating... [5m0s elapsed]
null_resource.DeployPersona: Still creating... [5m10s elapsed]
null_resource.DeployPersona: Still creating... [5m20s elapsed]
null_resource.DeployPersona (local-exec): changed: [172.20.20.28]

null_resource.DeployPersona (local-exec): PLAY RECAP *********************************************************************
null_resource.DeployPersona (local-exec): 172.20.20.28               : ok=13   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

null_resource.DeployPersona: Creation complete after 5m22s [id=4220647135004058242]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

boot_node_ip = [
  "172.20.20.27",
]
node1_ip = [
  "172.20.20.21",
]
node2_ip = [
  "172.20.20.28",
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
            external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
            hostname       = "Greenboat PerconaDB-2283"
            id             = 670
            ip             = "172.20.20.27"
            max_cores      = 2
            max_memory     = 8589934592
            max_storage    = 53687091200
            name           = "Greenboat PerconaDB-boot-2283_670"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-13T09:41:03Z"
                    id                  = 680
                    last_updated        = "2024-11-13T19:27:13Z"
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
                    ssh_host            = "172.20.20.27"
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
            date_created = "2024-11-13T09:42:24Z"
            display_name = "Greenboat PerconaDB-boot-2283"
            duration     = 473
            end_date     = "2024-11-13T09:42:24Z"
            id           = 3786
            instance_id  = 643
            last_updated = "2024-11-13T09:42:24Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:42:24Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "4d8b987c-b50a-44ef-b1bc-701ca35e54ce"
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
            date_created = "2024-11-13T09:41:03Z"
            display_name = "Greenboat PerconaDB-boot-2283"
            duration     = 81235
            end_date     = "2024-11-13T09:42:24Z"
            id           = 3783
            instance_id  = 643
            last_updated = "2024-11-13T09:42:24Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:41:03Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "929665cf-dd4c-4bfc-b116-ff720c13bd0c"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-2283"
    id                 = "643"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-boot-2283"
    plan_id            = 408
    server_id          = 680
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
        internal_id  = 848
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2263:0:6:0"
        datastore_id = "1"
        id           = 949
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
            external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
            hostname       = "Greenboat PerconaDB-2283"
            id             = 668
            ip             = "172.20.20.21"
            max_cores      = 2
            max_memory     = 8589934592
            max_storage    = 53687091200
            name           = "Greenboat PerconaDB-node1-2283_668"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-13T09:41:03Z"
                    id                  = 678
                    last_updated        = "2024-11-13T19:27:17Z"
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
                    ssh_host            = "172.20.20.21"
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
            date_created = "2024-11-13T09:42:19Z"
            display_name = "Greenboat PerconaDB-node1-2283"
            duration     = 250
            end_date     = "2024-11-13T09:42:19Z"
            id           = 3784
            instance_id  = 641
            last_updated = "2024-11-13T09:42:19Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:42:19Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "7c4a3a6e-245f-40c3-bbcc-2999568cc798"
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
            date_created = "2024-11-13T09:41:03Z"
            display_name = "Greenboat PerconaDB-node1-2283"
            duration     = 75579
            end_date     = "2024-11-13T09:42:19Z"
            id           = 3781
            instance_id  = 641
            last_updated = "2024-11-13T09:42:19Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:41:03Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "b8d49323-1df0-4ea1-97a7-fb1784ea58ed"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-2283"
    id                 = "641"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-node1-2283"
    plan_id            = 408
    server_id          = 678
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
        internal_id  = 846
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2259:0:6:0"
        datastore_id = "1"
        id           = 947
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
            external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
            hostname       = "Greenboat PerconaDB-2283"
            id             = 669
            ip             = "172.20.20.28"
            max_cores      = 2
            max_memory     = 8589934592
            max_storage    = 53687091200
            name           = "Greenboat PerconaDB-node2-2283_669"
            server         = [
                {
                    compute_server_type = [
                        {
                            external_delete = true
                            managed         = true
                            name            = "VMware Linux VM"
                        },
                    ]
                    date_created        = "2024-11-13T09:41:03Z"
                    id                  = 679
                    last_updated        = "2024-11-13T19:27:17Z"
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
                    ssh_host            = "172.20.20.28"
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
            date_created = "2024-11-13T09:42:24Z"
            display_name = "Greenboat PerconaDB-node2-2283"
            duration     = 570
            end_date     = "2024-11-13T09:42:25Z"
            id           = 3785
            instance_id  = 642
            last_updated = "2024-11-13T09:42:25Z"
            percent      = 100
            process_type = [
                {
                    code = "postProvisionContainer"
                    name = "Post-Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:42:24Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "b473057a-1acc-4643-ac1f-ecfd58ff5f91"
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
            date_created = "2024-11-13T09:41:03Z"
            display_name = "Greenboat PerconaDB-node2-2283"
            duration     = 80993
            end_date     = "2024-11-13T09:42:24Z"
            id           = 3782
            instance_id  = 642
            last_updated = "2024-11-13T09:42:24Z"
            percent      = 100
            process_type = [
                {
                    code = "provision"
                    name = "Provision"
                },
            ]
            reason       = null
            start_date   = "2024-11-13T09:41:03Z"
            status       = "complete"
            status_eta   = 0
            unique_id    = "4f1d0824-c4e1-436a-b292-961b47ecb6d3"
            updated_by   = [
                {
                    display_name = "ng-vmaas-api"
                    username     = "ng-vmaas-api"
                },
            ]
        },
    ]
    hostname           = "Greenboat PerconaDB-2283"
    id                 = "642"
    instance_type_code = "vmware"
    labels             = [
        "DBaaS",
    ]
    layout_id          = 113
    name               = "Greenboat PerconaDB-node2-2283"
    plan_id            = 408
    server_id          = 679
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
        internal_id  = 847
        is_primary   = true
        name         = "eth0"
    }

    volume {
        controller   = "2261:0:6:0"
        datastore_id = "1"
        id           = 948
        name         = "root_vol"
        root         = true
        size         = 50
        storage_type = 1
    }
}

# null_resource.DeployPersona:
resource "null_resource" "DeployPersona" {
    id = "4220647135004058242"
}

# random_integer.random:
resource "random_integer" "random" {
    id     = "2283"
    max    = 50000
    min    = 1
    result = 2283
}


Outputs:

boot_node_ip = [
    "172.20.20.27",
]
node1_ip = [
    "172.20.20.21",
]
node2_ip = [
    "172.20.20.28",
]
    ```

### terraform destroy

    ```sh
$ terraform destroy
random_integer.random: Refreshing state... [id=2283]
data.hpegl_vmaas_network.network: Reading...
data.hpegl_vmaas_group.terraform_group: Reading...
data.hpegl_vmaas_plan.g1_large: Reading...
data.hpegl_vmaas_cloud.cloud: Reading...
data.hpegl_vmaas_template.vanilla: Reading...
data.hpegl_vmaas_layout.vmware: Reading...
data.hpegl_vmaas_network.network: Still reading... [10s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [10s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [10s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [10s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [10s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [10s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [20s elapsed]
data.hpegl_vmaas_network.network: Still reading... [20s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [20s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [20s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [20s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [20s elapsed]
data.hpegl_vmaas_group.terraform_group: Still reading... [30s elapsed]
data.hpegl_vmaas_network.network: Still reading... [30s elapsed]
data.hpegl_vmaas_cloud.cloud: Still reading... [30s elapsed]
data.hpegl_vmaas_plan.g1_large: Still reading... [30s elapsed]
data.hpegl_vmaas_layout.vmware: Still reading... [30s elapsed]
data.hpegl_vmaas_template.vanilla: Still reading... [30s elapsed]
data.hpegl_vmaas_network.network: Read complete after 33s [id=14]
data.hpegl_vmaas_template.vanilla: Read complete after 33s [id=961]
data.hpegl_vmaas_group.terraform_group: Read complete after 33s [id=17]
data.hpegl_vmaas_plan.g1_large: Read complete after 34s [id=408]
data.hpegl_vmaas_cloud.cloud: Read complete after 34s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Reading...
data.hpegl_vmaas_datastore.c_3par: Reading...
data.hpegl_vmaas_cloud_folder.compute_folder: Reading...
data.hpegl_vmaas_datastore.c_3par: Read complete after 0s [id=1]
data.hpegl_vmaas_resource_pool.cl_resource_pool: Read complete after 0s [id=3]
data.hpegl_vmaas_cloud_folder.compute_folder: Read complete after 0s [id=6]
data.hpegl_vmaas_layout.vmware: Read complete after 34s [id=113]
hpegl_vmaas_instance.boot_node: Refreshing state... [id=643]
hpegl_vmaas_instance.node2: Refreshing state... [id=642]
hpegl_vmaas_instance.node1: Refreshing state... [id=641]
null_resource.DeployPersona: Refreshing state... [id=4220647135004058242]

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
              - external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
              - hostname       = "Greenboat PerconaDB-2283"
              - id             = 670
              - ip             = "172.20.20.27"
              - max_cores      = 2
              - max_memory     = 8589934592
              - max_storage    = 53687091200
              - name           = "Greenboat PerconaDB-boot-2283_670"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-13T09:41:03Z"
                      - id                  = 680
                      - last_updated        = "2024-11-14T10:32:20Z"
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
                      - ssh_host            = "172.20.20.27"
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
              - date_created = "2024-11-13T09:42:24Z"
              - display_name = "Greenboat PerconaDB-boot-2283"
              - duration     = 473
              - end_date     = "2024-11-13T09:42:24Z"
              - id           = 3786
              - instance_id  = 643
              - last_updated = "2024-11-13T09:42:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:42:24Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "4d8b987c-b50a-44ef-b1bc-701ca35e54ce"
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
              - date_created = "2024-11-13T09:41:03Z"
              - display_name = "Greenboat PerconaDB-boot-2283"
              - duration     = 81235
              - end_date     = "2024-11-13T09:42:24Z"
              - id           = 3783
              - instance_id  = 643
              - last_updated = "2024-11-13T09:42:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:41:03Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "929665cf-dd4c-4bfc-b116-ff720c13bd0c"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-2283" -> null
      - id                 = "643" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-boot-2283" -> null
      - plan_id            = 408 -> null
      - server_id          = 680 -> null
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
          - internal_id  = 848 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2263:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 949 -> null
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
              - external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
              - hostname       = "Greenboat PerconaDB-2283"
              - id             = 668
              - ip             = "172.20.20.21"
              - max_cores      = 2
              - max_memory     = 8589934592
              - max_storage    = 53687091200
              - name           = "Greenboat PerconaDB-node1-2283_668"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-13T09:41:03Z"
                      - id                  = 678
                      - last_updated        = "2024-11-14T10:32:19Z"
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
                      - ssh_host            = "172.20.20.21"
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
              - date_created = "2024-11-13T09:42:19Z"
              - display_name = "Greenboat PerconaDB-node1-2283"
              - duration     = 250
              - end_date     = "2024-11-13T09:42:19Z"
              - id           = 3784
              - instance_id  = 641
              - last_updated = "2024-11-13T09:42:19Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:42:19Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "7c4a3a6e-245f-40c3-bbcc-2999568cc798"
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
              - date_created = "2024-11-13T09:41:03Z"
              - display_name = "Greenboat PerconaDB-node1-2283"
              - duration     = 75579
              - end_date     = "2024-11-13T09:42:19Z"
              - id           = 3781
              - instance_id  = 641
              - last_updated = "2024-11-13T09:42:19Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:41:03Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "b8d49323-1df0-4ea1-97a7-fb1784ea58ed"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-2283" -> null
      - id                 = "641" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-node1-2283" -> null
      - plan_id            = 408 -> null
      - server_id          = 678 -> null
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
          - internal_id  = 846 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2259:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 947 -> null
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
              - external_fqdn  = "Greenboat PerconaDB-2283.localdomain"
              - hostname       = "Greenboat PerconaDB-2283"
              - id             = 669
              - ip             = "172.20.20.28"
              - max_cores      = 2
              - max_memory     = 8589934592
              - max_storage    = 53687091200
              - name           = "Greenboat PerconaDB-node2-2283_669"
              - server         = [
                  - {
                      - compute_server_type = [
                          - {
                              - external_delete = true
                              - managed         = true
                              - name            = "VMware Linux VM"
                            },
                        ]
                      - date_created        = "2024-11-13T09:41:03Z"
                      - id                  = 679
                      - last_updated        = "2024-11-14T10:32:20Z"
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
                      - ssh_host            = "172.20.20.28"
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
              - date_created = "2024-11-13T09:42:24Z"
              - display_name = "Greenboat PerconaDB-node2-2283"
              - duration     = 570
              - end_date     = "2024-11-13T09:42:25Z"
              - id           = 3785
              - instance_id  = 642
              - last_updated = "2024-11-13T09:42:25Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "postProvisionContainer"
                      - name = "Post-Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:42:24Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "b473057a-1acc-4643-ac1f-ecfd58ff5f91"
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
              - date_created = "2024-11-13T09:41:03Z"
              - display_name = "Greenboat PerconaDB-node2-2283"
              - duration     = 80993
              - end_date     = "2024-11-13T09:42:24Z"
              - id           = 3782
              - instance_id  = 642
              - last_updated = "2024-11-13T09:42:24Z"
              - percent      = 100
              - process_type = [
                  - {
                      - code = "provision"
                      - name = "Provision"
                    },
                ]
              - start_date   = "2024-11-13T09:41:03Z"
              - status       = "complete"
              - status_eta   = 0
              - unique_id    = "4f1d0824-c4e1-436a-b292-961b47ecb6d3"
              - updated_by   = [
                  - {
                      - display_name = "ng-vmaas-api"
                      - username     = "ng-vmaas-api"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - hostname           = "Greenboat PerconaDB-2283" -> null
      - id                 = "642" -> null
      - instance_type_code = "vmware" -> null
      - labels             = [
          - "DBaaS",
        ] -> null
      - layout_id          = 113 -> null
      - name               = "Greenboat PerconaDB-node2-2283" -> null
      - plan_id            = 408 -> null
      - server_id          = 679 -> null
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
          - internal_id  = 847 -> null
          - is_primary   = true -> null
          - name         = "eth0" -> null
        }

      - volume {
          - controller   = "2261:0:6:0" -> null
          - datastore_id = "1" -> null
          - id           = 948 -> null
          - name         = "root_vol" -> null
          - root         = true -> null
          - size         = 50 -> null
          - storage_type = 1 -> null
        }
    }

  # null_resource.DeployPersona will be destroyed
  - resource "null_resource" "DeployPersona" {
      - id = "4220647135004058242" -> null
    }

  # random_integer.random will be destroyed
  - resource "random_integer" "random" {
      - id     = "2283" -> null
      - max    = 50000 -> null
      - min    = 1 -> null
      - result = 2283 -> null
    }

Plan: 0 to add, 0 to change, 5 to destroy.

Changes to Outputs:
  - boot_node_ip = [
      - "172.20.20.27",
    ] -> null
  - node1_ip     = [
      - "172.20.20.21",
    ] -> null
  - node2_ip     = [
      - "172.20.20.28",
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.DeployPersona: Destroying... [id=4220647135004058242]
null_resource.DeployPersona: Destruction complete after 0s
hpegl_vmaas_instance.node2: Destroying... [id=642]
hpegl_vmaas_instance.boot_node: Destroying... [id=643]
hpegl_vmaas_instance.node1: Destroying... [id=641]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 10s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 10s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 10s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 20s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 20s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 20s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 30s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 30s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 30s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 40s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 40s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 40s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 50s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 50s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 50s elapsed]
hpegl_vmaas_instance.boot_node: Still destroying... [id=643, 1m0s elapsed]
hpegl_vmaas_instance.node2: Still destroying... [id=642, 1m0s elapsed]
hpegl_vmaas_instance.node1: Still destroying... [id=641, 1m0s elapsed]
hpegl_vmaas_instance.boot_node: Destruction complete after 1m3s
hpegl_vmaas_instance.node1: Destruction complete after 1m4s
hpegl_vmaas_instance.node2: Still destroying... [id=642, 1m10s elapsed]
hpegl_vmaas_instance.node2: Destruction complete after 1m18s
random_integer.random: Destroying... [id=2283]
random_integer.random: Destruction complete after 0s

Destroy complete! Resources: 5 destroyed.
    ```

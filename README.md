# ansible-hetzner-cloud-volume-sshfs
This repository contains a `bash` script that creates/destroys a setup at Hetzner Cloud via the `hcloud` cli interface and an Ansible playbook to provision Hetzner Cloud Servers with a Hetzner Cloud Volume that is mounted on multiple servers via `sshfs` over the Hetzner Cloud Network. A tutorial will be submitted to the [Hetzner Online Community](https://community.hetzner.com/tutorials).

## Dependencies

- [Hetzner Cloud CLI](https://github.com/hetznercloud/cli)
- [Hetzner Cloud Python](https://github.com/hetznercloud/hcloud-python)
- [Ansible](https://docs.ansible.com/)

### Installation on macOS

```bash
brew install hcloud
brew install ansible
```

At times of writing this installs the following software versions.

- `hcloud` version 1.17.0
- `ansible` 2.9.10
- hcloud-python 1.8.1

### Other Operating Systems

We refer to the [hcloud/cli README](https://github.com/hetznercloud/cli#third-party-packages) and [Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for installation instructions on other operating systems.

## Initial configuration 

### For `hcloud`

If you haven't already, first create a project `<myproject>` in your [Hetzner Cloud Console](https://console.hetzner.cloud/) and generate an API token via Security > API Tokens > Generate API Token. Next, open up a terminal and execute the following.

```bash
source <(hcloud completion bash)   # if you want command completion - trust me, you do!
hcloud context create myproject
hcloud context list
hcloud context activate myproject  # only if it isn't active just yet
```

Also see [hcloud README/Getting Started](https://github.com/hetznercloud/cli#getting-started). Note that `hcloud context create` stores the API token in `~/.config/hcloud/cli.toml`. This confused me at first because the [hcloud/cli README](https://github.com/hetznercloud/cli#configure-hcloud-using-environment-variables) suggests that the context and token are taken from the environment variable `HCLOUD_CONTEXT` and `HCLOUD_TOKEN`, respectively. However, the shell variables seem to be ignored in favour of  `~/.config/hcloud/cli.toml`.


### For `ansible`

- Create a virtualenv: 

    ```bash
    virtualenv --python=python3 .venv 
    source .venv/bin/activate
    pip install ansible hcloud
    ```

- Add the following to `~/.secrets/ansible-vault-pass`
    
    ```bash
    SuperSecretAnsibleVaultPassword
    ```

- Execute the command `ansible-vault create inventory/group_vars/all/vault.yml`, and add the following:
    ```bash
    user_password: SuperSecretDebianUserPassword
    ```


## Usage

- Create the setup at Hetzner Cloud: `./create.sh -c`
- Run the playbook: `ansible-playbook provision.yml`
- Connect to server: `ssh root@$(hcloud server ip server1) -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no`
- Destroy the setup at Hetzner Cloud: `./create.sh -d`

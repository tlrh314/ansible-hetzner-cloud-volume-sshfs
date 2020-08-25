# ansible-hetzner-cloud-volume-sshfs
This repository contains a `bash` script that creates/destroys a setup at Hetzner Cloud via the `hcloud` cli interface and an Ansible playbook to provision Hetzner Cloud Servers with a Hetzner Cloud Volume that is mounted on multiple servers via `sshfs` over the Hetzner Cloud Network. A tutorial for the [Hetzner Online Community](https://community.hetzner.com/tutorials) has been [submitted](https://github.com/hetzneronline/community-content/pull/250).

![](https://github.com/tlrh314/ansible-hetzner-cloud-volume-sshfs/raw/master/sshfs_tutorial.gif)

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

- `hcloud` version 1.18.0
- `ansible` 2.9.10
- hcloud-python 1.9.1

### Other Operating Systems

We refer to the [hcloud/cli README](https://github.com/hetznercloud/cli#third-party-packages) and [Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for installation instructions on other operating systems.

## Initial configuration 

### For `hcloud`

If you haven't already, first create a project `<myproject>` in your [Hetzner Cloud Console](https://console.hetzner.cloud/) and generate an API token via Security > API Tokens > Generate API Token. Next, open up a terminal and execute the following.

```bash
source <(hcloud completion bash)   # if you want command completion - trust me, you do!
hcloud context create myproject
hcloud context list
hcloud context use myproject  # only if it isn't active just yet
hcloud context active  # should be myproject
```

Also see [hcloud README/Getting Started](https://github.com/hetznercloud/cli#getting-started). Note that `hcloud context create` stores the API token in `~/.config/hcloud/cli.toml`. 


### For `ansible`

- Create a virtualenv: 

    ```bash
    virtualenv --python=python3 .venv 
    source .venv/bin/activate
    pip install ansible hcloud
    ```

- We need to export the following shell variables for the Ansible hcloud plugin to automatically get the servers to provision from the `hcloud` cli interface.
    ```bash
    export HCLOUD_CONTEXT=myproject
    export HCLOUD_TOKEN=mytoken
    ```


## Usage

- Create the setup at Hetzner Cloud: `./create.sh -c`
- Run the playbook: `ansible-playbook provision.yml`
- Connect to server1: `ssh root@$(hcloud server ip server1) -i ~/.ssh/hcloud_sshfs_rsa -o StrictHostKeyChecking=no`
- Connect to server2: `ssh root@$(hcloud server ip server2) -i ~/.ssh/hcloud_sshfs_rsa -o StrictHostKeyChecking=no`
- Destroy the setup at Hetzner Cloud: `./create.sh -d`


## References
Part of the Ansible roles have been gleaned from Vito Botta's [ansible-bootstrap-role](https://github.com/vitobotta/ansible-bootstrap-role), specifically `Update system` and `Install essential packages` (though the latter is extensively modified).

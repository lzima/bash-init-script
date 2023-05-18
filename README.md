# Init script for setup your laptop

Script that installs the necessary programs and commands

## Run script

Before you'll run script change values in `.env.git` to your name and company email.
```bash
# during first run you can be asked for password
bash setup.sh
```

Why bash? Because it's default shell in Mac OS and Linux.

## Packages

Installing following packages/programs

```bash
iterm2
zsh
xcode-select
git
ssh
rancher
rancher-cli
lens
docker
docker-compose
kubernetes-cli
helm
ansible
terraform
teleport
htop
azure-cli
tfsec
terraform-docs
asdf
go-task
gnutls
gnu-sed
grep
jq
yq
```

#### Additional

Generating ssh keys and setup git config

## Support

Now supporting just Mac OS, byt it's ready to add another platforms.

# TODO

- [ ] Add support for Linux
- [ ] Add support for Windows
- [ ] Add support for WSL
- [ ] Variable contains list of packages to install
- [ ] Add support for install different programs per role

# Init script for setup your laptop

Script that installs the necessary programs and commands

## Run

### From repo directory

Before you'll run script change values in `.env.git` to your name and company email.
```bash
# during first run you can be asked for password
bash setup.sh
```
### One line command in terminal
In following code we can see three variables:

- `FIRST_NAME`
- `SECOND_NAME`
- `EMAIL`

Change these variables and run following command
```bash 
bash -c "FIRST_NAME=CHANGE_ME; SECOND_NAME=CHANGE_ME; EMAIL=CHANGE_ME@cmgx.io $(curl -fsSL https://raw.githubusercontent.com/lzima/bash-init-script/main/setup.sh)"
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
ncdu
yamllint
gh
```

#### Additional

Generating ssh keys and setup git config


## Clone all repos

Script clones all repos in your github organization. You can change organization name in `.env.git` file.

Script will clone all repos to current directory

### Login to your github account from terminal

```bash 
gh auth login
```

#### One line command in terminal
```bash
bash -c "GH_ORG=CHANGE_ME; $(curl -fsSL https://raw.githubusercontent.com/lzima/bash-init-script/main/clone-all-repos.sh)"
```

## Support

Now supporting just Mac OS, byt it's ready to add another platforms.

# TODO

- [ ] Add support for Linux
- [ ] Add support for Windows
- [ ] Add support for WSL
- [ ] Variable contains list of packages to install
- [ ] Add support for install different programs per role

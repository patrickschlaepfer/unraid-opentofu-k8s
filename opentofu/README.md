# OpenTofu Part

This is highly inspired by the work of mcreekmore, and the project
you will find here: https://github.com/mcreekmore/unraid-terraform.git

It is not an introduction to OpenTofu. In order to deploy
just do

## Setup the environment

Create a `.env` file

Add the `LIBVIRT_DEFAULT_URI` which points to your unraid server, like

    LIBVIRT_DEFAULT_URI="qemu+ssh://<UNRAID_USER>@<UNRAID_IP>/system?sshauth=privkey&keyfile=<PATH_TO_YOUR_PRIVATE_KEY>&no_verify=1"



## Setup up the VMs

At the ond of `qemu-vm` add as many VMs you would like to have.
Adjust the parameters to your need.

Go through all other files, and change the setting to your needs.
I will try to put all the variables at the end.

The VMs will be setup by `cloudinit`, and they are based on Ubuntu.

## Rollout the VMs

Initialize to project

    $ tofu init

Run the plan

    $ tofu plan

Check to plan, if it makes sense to you

    $ tofu apply

## Destry to VMs

To delete all the VMs created by opentofu, use

    $ tofu destroy
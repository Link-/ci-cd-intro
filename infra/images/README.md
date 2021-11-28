# Packer

This packer file will build an Ubuntu Server 20.04 LTS AWS AMI with the following installed:

- Nginx
- Node 14.x
  - pm2

## Setup

Build the AMI:

```sh
packer build .

...
Build 'amazon-ebs.webserver' finished after 3 minutes 49 seconds.

==> Wait completed after 3 minutes 49 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.webserver: AMIs were created:
eu-west-1: ami-0cabd94003825d35d
```

**Copy this AMI id we will use it in our terraform template.**

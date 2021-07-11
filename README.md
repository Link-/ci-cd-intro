# ci-cd-intro
Intro to CI/CD 💻 ☁️

TLDR; This repository is a sample project demonstrating a basic continuous integration (CI) / continuous deployment (CD) setup. Used as part of an episode of Hadith Tech (In Arabic). The episode is available here: https://www.youtube.com/watch?v=CYj3eoQu1FM

## Project structure

```sh
.
├── README.md
├── infra
│   ├── images
│   │   ├── README.md
│   │   ├── img.pkr.hcl
│   │   └── setup.sh
│   └── instances
│       ├── .terraform
│       ├── .terraform.lock.hcl
│       ├── main.tf
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       ├── terraform.tfvars
│       └── terraform.tfvars.example
└── web
    ├── app.js
    ├── bin
    │   └── www
    ├── package-lock.json
    ├── package.json
    ├── public
    │   ├── images
    │   ├── javascripts
    │   └── stylesheets
    ├── routes
    │   ├── index.js
    │   └── users.js
    ├── tests
    │   ├── app.test.js
    │   └── routes.test.js
    └── views
        ├── error.jade
        ├── index.jade
        └── layout.jade

13 directories, 21 files
```

- `infra/images`: contains [Packer](https://learn.hashicorp.com/packer) template to build our [AWS EC2 AMI](https://aws.amazon.com/ec2/)
- `infra/instances`: contains our [Terraform](https://learn.hashicorp.com/terraform) templates to setup our `staging` and `production` EC2 instances
- `web`: contains our simple [Express](https://expressjs.com/) web application 

## Setup

### 0. Pre-requisites

- [aws-cli](https://aws.amazon.com/cli/)
- [Terraform 0.15.x+](https://www.terraform.io/)
- [Packer](https://www.packer.io/)
- [Node.js 14.x](https://nodejs.org/en/)

Clone this repository and follow the instructions below:

### 1. Build the AWS EC2 AMI

```sh
$ cd infra/images
$ packer build .
```

Once the AMI has been built you should be able to see in your AWS console as such:
![1B7DD86D-AFF4-42E2-AB90-BB8B4618DEA9](https://user-images.githubusercontent.com/568794/125193943-5cabf880-e24f-11eb-9f81-b5e6e27747fa.png)

### 2. Create a RSA keys to use for accessing the instances

You need to create 2 keys, 1 for staging and 1 for production with this command:

```sh
ssh-keygen -t rsa -b 4096 -C "ubuntu"
```

### 3. Spin up your EC2 instances from the AMI we built

```sh
$ cd infra/instances

# Setup the terraform.tfvars files from the example
cp terraform.tfvars.example terraform.tfvars

# Open the terraform.tfvars for editing and replace the placeholders with the proper values <>
File: terraform.tfvars
───────┼────────────────────────────────────────────────────────────────────────────────────
   1   │ base_ami_id                = "<ENTER AMI ID FROM PREVIOUS STEP>"
   2   │ staging_public_key_path    = "<PATH TO STAGING PUBLIC KEY TO USE>"
   3   │ production_public_key_path = "<PATH TO PRODUCTION PUBLIC KEY TO USE>"

$ terraform init
$ terraform plan
$ terraform apply

...
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

production_dns = "ec2-----redacted------.eu-west-1.compute.amazonaws.com"
staging_dns = "ec2-----redacted--------.eu-west-1.compute.amazonaws.com"
```

If all goes well, you should see your instances in the console as such:
![3454454B-43DC-4562-807D-BC52AF03E718](https://user-images.githubusercontent.com/568794/125194034-c5937080-e24f-11eb-8edb-f6743e30b183.png)

### 4. Configure your GitHub repository to run the workflows


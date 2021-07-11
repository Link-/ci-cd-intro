# Intro to CI/CD 💻 ☁️

> TLDR; This repository is a sample project demonstrating a basic continuous integration (CI) / continuous deployment (CD) setup. Used as part of an episode of Hadith Tech (In Arabic). 

The episode is available here: https://www.youtube.com/watch?v=CYj3eoQu1FM

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

⚠️ _Do not follow these instructions blindly. Please take the time to review the steps and adapt them to your environment._

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
$ ssh-keygen -t rsa -b 4096 -C "ubuntu"
```

### 3. Spin up your EC2 instances from the AMI we built

```sh
$ cd infra/instances

# Setup the terraform.tfvars files from the example
$ cp terraform.tfvars.example terraform.tfvars

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

1. Navigate to the `Settings` in your repository then to `Environments`
    ![37EE1AFF-BDBC-405E-8D43-672E09CA87D5](https://user-images.githubusercontent.com/568794/125194173-86195400-e250-11eb-89dd-e52cdf867c74.png)

1. Add a new environment and call it `staging` (or anything else you like)
    ![F1BC0A94-3BB5-4409-B057-6E6FC241C78A](https://user-images.githubusercontent.com/568794/125194219-9d584180-e250-11eb-9495-e2a30ddee5c5.png)

1. Enable required reviewers and add your secrets
    ![085BF9C1-552E-46C5-91D0-687A9634A885](https://user-images.githubusercontent.com/568794/125194260-b9f47980-e250-11eb-9e10-c603a3ee8232.png)

1. Enable branch protection on the `main` branch
    ![2E8B02F5-CD8E-40C1-B03C-5FD7074C1C77](https://user-images.githubusercontent.com/568794/125194325-15266c00-e251-11eb-9c39-f9b847971dae.png)
    ![955A1F29-D628-46C4-86A4-8F614A712CFF](https://user-images.githubusercontent.com/568794/125194345-266f7880-e251-11eb-8055-4d0d392b6f2a.png)

### 5. Test your setup

1. Create a new branch from the `main` branch and make some changes to the app
1. Push the new branch to GitHub 
1. Watch the CI workflow being triggered 
1. Troubleshoot issues as they rise

## LICENSE

[Copyright (c) 2021 Bassem Dghaidi (@Link-)](LICENSE)

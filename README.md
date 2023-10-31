# Intro to CI/CD 💻 ☁️

> TLDR; This repository is a sample project demonstrating a basic continuous integration (CI) / continuous deployment (CD) setup. This project is in READ ONLY mode.

:warning: **Fork this repository in order to use it!** If you're following along the videos and trying to run the workflows here, they will not work.

### Course attachement

> This repository is best consumed while or after following the course attachment 👇

<a href="https://www.youtube.com/playlist?list=PLArH6NjfKsUhvGHrpag7SuPumMzQRhUKY" target="_blank"><img src="./images/course_banner.png" /></a>

## Project structure

```sh
# You can generate this tree with:
# $ tree -a -I '.git|assets|.github|venv|node_modules|images|.DS_Store|*.tfvars|.terraform'
.
├── .gitignore
├── CODEOWNERS
├── LICENSE
├── README.md
├── infra
│   ├── README.md
│   └── instances
│       ├── production
│       │   ├── .terraform.lock.hcl
│       │   ├── main.tf
│       │   └── terraform.auto.tfvars.example
│       └── staging
│           ├── .terraform.lock.hcl
│           ├── create_staging_resource.sh
│           ├── extra_staging.tf.example
│           ├── main.tf
│           └── terraform.tfvars.auto.example
└── web
    ├── README.md
    ├── app.js
    ├── bin
    │   └── www
    ├── package-lock.json
    ├── package.json
    ├── public
    │   ├── javascripts
    │   └── stylesheets
    │       └── style.css
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

12 directories, 26 files
```

- `infra/images`: contains [Packer](https://learn.hashicorp.com/packer) template to build our [AWS EC2 AMI](https://aws.amazon.com/ec2/)
- `infra/instances`: contains our [Terraform](https://learn.hashicorp.com/terraform) templates to setup our `staging` and `production` EC2 instances
- `web`: contains our simple [Express](https://expressjs.com/) web application

## Setup

### Configure your GitHub repository to run the workflows

<details>
    <summary>Click to expand</summary>

1. Navigate to the `Settings` in your repository then to `Environments`
    ![37EE1AFF-BDBC-405E-8D43-672E09CA87D5](https://user-images.githubusercontent.com/568794/125194173-86195400-e250-11eb-89dd-e52cdf867c74.png)

1. Add a new environment and call it `staging` (or anything else you like)
    ![F1BC0A94-3BB5-4409-B057-6E6FC241C78A](https://user-images.githubusercontent.com/568794/125194219-9d584180-e250-11eb-9495-e2a30ddee5c5.png)

1. Enable required reviewers and add your secrets
    ![085BF9C1-552E-46C5-91D0-687A9634A885](https://user-images.githubusercontent.com/568794/125194260-b9f47980-e250-11eb-9e10-c603a3ee8232.png)

1. Enable branch protection on the `main` branch
    ![2E8B02F5-CD8E-40C1-B03C-5FD7074C1C77](https://user-images.githubusercontent.com/568794/125194325-15266c00-e251-11eb-9c39-f9b847971dae.png)
    ![955A1F29-D628-46C4-86A4-8F614A712CFF](https://user-images.githubusercontent.com/568794/125194345-266f7880-e251-11eb-8055-4d0d392b6f2a.png)

</details>

### Test your setup

1. Create a new branch from the `main` branch and make some changes to the app
1. Push the new branch to GitHub
1. Watch the CI workflow being triggered
1. Troubleshoot issues as they rise

## LICENSE

[Copyright (c) 2021 Bassem Dghaidi (@Link-)](LICENSE)

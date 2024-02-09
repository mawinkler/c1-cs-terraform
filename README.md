# Terraform Example for Container Security

> ***IMPORTANT:*** This example is now built in to [Playground One](https://github.com/mawinkler/playground-one) and not maintained anymore. Playground One supports the Vision One Container Security life-cycle orchestrated by Terraform.

## Introduction

This repository provides infrastructure-as-code examples to automate the live-cycle of Trend Micro Container Security.

## Getting Started

1. Clone the repository.

```sh
git clone https://github.com/mawinkler/c1-cs-terraform.git
```

1. Navigate to the directory.

```sh
cd c1-cs-terraform
```

2. Duplicate the `terraform.tfvars.sample` file to `terraform.tfvars` in the directory.

```sh
cp terraform.tfvars.sample terraform.tfvars
```

3. Open the `terraform.tfvars` file and update the variable `api_key` and `cluster_policy` as defined in Cloud One.

4. Adapt the `variables.tf` file to your requirements

5. Initialize the current directory and the required Terraform provider for Container Security.

```sh
terraform init
```

6. Create a Terraform plan and save the output to a file.

```sh
terraform plan -out=tfplan
```

6. Apply the Terraform plan.

```sh
terraform apply tfplan
```

To delete the Container Security deployment and remove the cluster object in Cloud One run

```sh
terraform destroy
```

## Support

This is an Open Source community project. Project contributors may be able to help, depending on their time and availability. Please be specific about what you're trying to do, your system, and steps to reproduce the problem.

For bug reports or feature requests, please [open an issue](../../issues). You are welcome to [contribute](#contribute).

Official support from Trend Micro is not available. Individual contributors may be Trend Micro employees, but are not official support.

## Contribute

I do accept contributions from the community. To submit changes:

1. Fork this repository.
1. Create a new feature branch.
1. Make your changes.
1. Submit a pull request with an explanation of your changes or additions.

I will review and work with you to release the code.

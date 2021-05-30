## Setting up Local Environment

### Install Terraform

- Choose [Installation method](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) according to your OS type.

### Configure AWS CLI

- Install aws-cli 
    ```shell
    sudo apt-get install awscli
    ```
- Download AWS credentials (Access key & secret key CSV) for your IAM user.
- Configure your AWS profile in terminal
    ```console
    $ aws configure
    AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
    AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    Default region name [None]: ap-south-1
    Default output format [None]: json
    ```
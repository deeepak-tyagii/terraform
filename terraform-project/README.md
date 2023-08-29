
# Count Visits Website Project 

- Created a static Website which count the users visits tracking the time.







## Workflow

- Create a private VPC
- Create public and private subnets
- Create Internet and NAT Gateways
- Create the public and private route tables
- Associate the subnets with route tables
- Create the routes for subnets using Internet and NAT Gateways
- Create the security group inside the newly created VPC
- Create the EC2 Instance inside one of the public subnets



## Environment Variables

To run this project, you will need to add the AWS Credentials as the environment variables to your system - 

`export AWS_ACCESS_KEY_ID="<YOUR ACCESS KEY>"`

`export AWS_SECRET_ACCESS_KEY="<YOUR SECRET KEY>"`

**Or run below command and provide your aws creds-** 

- You need to first install the aws cli on your system

```
aws configure
```



## Deployment

The first step to using Terraform is initializing the working directory. In your shell session, type the
following command:

```bash
  terraform init
```

 Now, Check what all resources we're going to create- 

```bash
  terraform plan
```

 We're now ready to deploy this infra on AWS
```bash
  terraform apply -auto-approve
```

 Once, you're done. Destroy all the resources by running
```
  terraform destroy 
```

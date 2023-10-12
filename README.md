# Terraform Nextcloud All-in-One @ AWS

This project uses Terraform to deploy and manage Nextcloud All-in-One([Link](https://hub.docker.com/r/nextcloud/all-in-one)) on Amazon Web Services (AWS).

![Architecture](/media/overview.png)


## What this Terraform script does
This Terraform will do the following automatically:

1. VPC: Creates a custom Virtual Private Cloud (VPC) for the Nextcloud installation.
2. Subnets: Defines a public subnet within the VPC for the EC2 instance.
3. Internet Gateway: Attaches an internet gateway to the VPC for internet access.
4. Route Table: Configures a route table to enable communication between the internet gateway and the EC2 instance.
5. Security Group: Creates a security group to control inbound and outbound traffic to the EC2 instance.
6. EC2 Instance: Launches an EC2 instance using the specified AMI, instance type, and security group.
7. Elastic IP: Allocates an Elastic IP address and associates it with the EC2 instance.
8. Route 53: Associates a DNS record with the Elastic IP to provide a user-friendly domain for accessing Nextcloud.
9. S3 Bucket: Creates an S3 bucket to store Nextcloud artifacts.

## Project Structure
The project is organized as follows:

```bash
.
├── main.tf
├── variables.tf
├── locals.tf
├── ec2.tf
├── vpc.tf
├── route53.tf
├── s3.tf
└── outputs.tf
```
- `main.tf`: The main Terraform configuration file that sets up the AWS provider and backend configuration.
- `variables.tf`: Defines the variables used in the Terraform script.
- `locals.tf`: Defines local variables, including tags for AWS resources.
- `ec2.tf`: Configures an EC2 instance to host Nextcloud.
- `vpc.tf`: Sets up a Virtual Private Cloud (VPC) with subnets and an internet gateway for networking.
- `route53.tf`: Creates a Route 53 DNS record for accessing the Nextcloud instance.
- `s3.tf`: Creates an S3 bucket to store artifacts.
- `outputs.tf`: Defines the outputs of the Terraform script, providing information about the deployed resources.
- `docker.sh`: Docker run script for Nextcloud AIO

#### docker.sh

```bash
#!/bin/bash
sudo docker run \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart always \
--publish 80:80 \
--publish 8080:8080 \
--publish 8443:8443 \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest
```

## Deployment

### Create S3 State Bucket (has to be unique)

* Create an S3 bucket for storing a Terraform state. This step is not strictly necessary if you choose to keep the state locally

```bash
export TF_STATE_BUCKET=<bucketname>
aws s3 mb s3://$TF_STATE_BUCKET
aws s3api put-bucket-versioning --bucket $TF_STATE_BUCKET --versioning-configuration Status=Enbled
aws s3api put-public-access-block \
    --bucket $TF_STATE_BUCKET \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

### Run Terraform 

Run the following command to create all the required resources.

```bash
terraform init \
  -backend-config="bucket=gfl-nextcloud-state"
export TF_VAR_hosted_zone=dev.mydomain.cloud
export TF_VAR_dns_record_name=share
export TF_VAR_domain=dev.mydomain.cloud
terraform plan
terraform apply
```

After the deployment is complete, your Nextcloud instance will be accessible through the DNS record associated with the Elastic IP. You can find the DNS record URL in the output of the Terraform apply command.

 ### Logs

- Apache ([Logs](http://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-apache))
- Database ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-database))
- Nextcloud ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-nextcloud))
- Notify Push ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-notify-push))
- Redis ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-redis))
- Collabora ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-collabora))
- Talk ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-talk))
- Imaginary ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-imaginary))
- Fulltextsearch ([Logs](https://dev.mydomain.cloud:8080/api/docker/logs?id=nextcloud-aio-fulltextsearch))

`share.dev.mydomain.cloud` has to be replaced by the elastic IP if errors like NET::ERR_CERT_AUTHORITY_INVALID occur.

#### Additional Considerations / Todos

##### 1. Scaling with Auto Scaling Group (ASG)
To enhance the resilience and scalability of the Nextcloud deployment, we should consider incorporating an Auto Scaling Group (ASG) into the Terraform script. With an ASG, we can automatically spin up additional EC2 instances based on predefined scaling policies and metrics such as CPU utilization or network traffic. This ensures that the Nextcloud infrastructure can handle increased workload and provides improved availability.

##### 2. Data Storage Integration with S3 or EFS
To enhance data security and resilience, we may want to consider integrating Nextcloud with Amazon S3 or Amazon EFS (Elastic File System). 

- Integration with **Amazon S3**: Nextcloud supports external storage solutions like S3 for storing files and objects. By using S3 as a primary storage backend, we can benefit from its durability, scalability, and built-in data protection features like versioning and cross-region replication.

- Integration with **Amazon EFS**: Alternatively, we can integrate Nextcloud with Amazon EFS, which provides a managed file system that can be mounted on multiple EC2 instances simultaneously. This allows for shared access and simplifies data management across multiple Nextcloud deployment. EFS also provides built-in redundancy and durability to protect our data.

Integrating either S3 or EFS with Nextcloud will help us ensure data security, durability, and ease of management for our Nextcloud instance.
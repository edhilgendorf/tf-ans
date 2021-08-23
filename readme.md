
# Table of Contents

1.  [Conventions](#org3555ac6)
2.  [Install Terraform](#org097dc17):terraform:install:
3.  [Install Packer](#org770a190):packer:install:
4.  [Configure AWS](#org72af316):aws:
    1.  [Setup AWS CLI](#org59ad502):cli:install:
    2.  [Create IAM User and Policies](#org09b9d9d):iam:
5.  [Configure Terraform Cloud](#org348f130)
    1.  [Setup Terraform Cloud State](#orgc815ab7)
6.  [Create Infrastructure with Terraform](#org8e5ade1):terraform:iac:
    1.  [Create variables](#orge04b56b):variables:
    2.  [Create a network](#org8913920):network:
    3.  [Create Instances](#orgb744f26)



<a id="org3555ac6"></a>

# Conventions

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">type</th>
<th scope="col" class="org-left">example</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">custom input</td>
<td class="org-left">&lt;your<sub>input</sub>&gt;</td>
</tr>
</tbody>
</table>


<a id="org097dc17"></a>

# Install Terraform     :terraform:install:

<https://www.terraform.io/downloads.html>


<a id="org770a190"></a>

# Install Packer     :packer:install:

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install packer


<a id="org72af316"></a>

# Configure AWS     :aws:

-   Register account: <https://portal.aws.amazon.com/gp/aws/developer/registration/index.html>


<a id="org59ad502"></a>

## Setup AWS CLI     :cli:install:

-   <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html>


<a id="org09b9d9d"></a>

## Create IAM User and Policies     :iam:

-   IAM: <https://console.aws.amazon.com/iam/home>
-   Polcies: <https://console.aws.amazon.com/iamv2/home?#/policiesC>
-   IAM User: <https://console.aws.amazon.com/iam/home#/users$new?step=details>
    -   programmatic (non-console)
    -   attach existing policy
-   Add user to `/.aws/credentials` as a profile:
    
        [default]
        aws_access_key=<your_key>
        aws_secret_access_key=<your_key>
        
        [tf_user]
        aws_access_key=<your_key>
        aws_secret_access_key=<your_key>
-   Add root user as default, or create IAM admin:
    <https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials$access_key>


### attach a base policy     :policy:

<./policies/base.json>


<a id="org348f130"></a>

# Configure Terraform Cloud

-   Regsiter account: <https://app.terraform.io/signup/account?utm_source=terraform_io&utm_content=terraform_cloud_top_nav>


<a id="orgc815ab7"></a>

## Setup Terraform Cloud State

-   Create an organization
-   Create a Workspace from VCS Repository, ex: <https://github.com>
-   Create a token and save in `~/.terraform.d/credentials.tfrc.json`
    -   <https://app.terraform.io/app/settings/tokens>
-   Create Terraform Backend config locally:
    
        terraform {
          backend "remote" {
            organization = "<your_org>"
            workspaces {
              name ="<your_workspace>"
            }
          }
        }
-   Add access keys to Terraform Cloud
    -   <https://app.terraform.io/app/><organization>/workspaces/<workspace>/variables
-   Initialize your environment `terraform init`
-   Configure Terraform Cloud to plan and apply upon check-in
    -   <https://app.terraform.io/app/><your<sub>org</sub>>/workspaces/<your<sub>workspace</sub>>/settings/general


<a id="org8e5ade1"></a>

# Create Infrastructure with Terraform     :terraform:iac:


<a id="orge04b56b"></a>

## Create variables     :variables:

-   Input variables serve as parameters for a Terraform module, allowing aspects of the module to be customized without altering the module&rsquo;s own source code, and allowing modules to be shared between different configurations.
    -   <https://www.terraform.io/docs/language/values/variables.html>
-   <./variables.tf>
    -   profile and default user
    -   two regions
        -   a master region
        -   a worker region


<a id="org8913920"></a>

## Create a network     :network:


<a id="org2b6afdf"></a>

### Create VPCs     :vpc:

-   A virtual network dedicated to your AWS account.
    -   <https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html>
-   <./network.tf>
    -   VPCs
        -   vpc<sub>master</sub>
        -   vpc<sub>master</sub><sub>oregon</sub>


### Create IGWs     :igw:

-   An internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet.
    -   <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html>
-   <./network.tf>
    -   create an internet gateway in each VPC, which reside in different availability zones (us-east-1 and us-west-2)


### Provide Data     :data:

-   Data sources allow Terraform use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.
    -   <https://www.terraform.io/docs/language/data-sources/index.html>
-   <./network.tf>
    -   get `aws_availability_zones` that are in `state: available`


<a id="org018557f"></a>

### Create Subnets in our VPCs     :subnet:

-   When you create a VPC, you must specify a range of IPv4 addresses for the VPC in the form of a Classless Inter-Domain Routing (CIDR) block; for example, 10.0.0.0/16. This is the primary CIDR block for your VPC. For more information about CIDR notation, see RFC 4632.
    -   <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html>
-   <./network.tf>
    -   two subnets in the master VPC defined in [Create VPCs](#org2b6afdf).
        -   `10.0.1.0/24`
        -   `10.0.2.0/24`
    -   one subnet in the worker VPC defined in  [Create VPCs](#org2b6afdf).
        -   `192.168.1.0/24`


<a id="orgf667ace"></a>

### Create Peering between VPCs     :peering:

-   A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses.
    -   <https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html>
-   <./network.tf>
    -   Create a peering connection request from the master VPC.
    -   Create a peering connection acceptor from the worker VPC.


### Create Routing in and between VPCs     :route:vpc:

-   A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
    -   <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html>
-   <./network.tf>
    -   create a routing table for the master VPC
        -   to internet via `aws_internet_gateway.igw.id`
        -   to the worker VPC Peering Connection created in:  [Create Peering between VPCs](#orgf667ace)
    -   replace default route of the master VPC with the routing table created above
    -   create routing table for worker VPC
        -   to internet via `aws_internet_gateway.igw.id`
        -   to the master VPC Peering Connection created in:  [Create Peering between VPCs](#orgf667ace)
    -   replace default route of the worker VPC with the routing table created above


### Create Security Groups     :security_groups:

-   A security group acts as a virtual firewall for your instance to control inbound and outbound traffic.
    -   <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html>
-   <./security_groups.tf>
    -   create a SG for the: [Create an ALB](#org501eb05)
        -   allow in from 80/443 web ports.
        -   allow out anywhere for ephemeral ports.
    -   create a security group for Jenkins in VPC Master
        -   allow in from 80/443 web ports.
        -   allow out anywhere for ephemeral ports.
        -   allow ssh from port 22 from our home IP
        -   allow in from us-west-2 (worker) subnet created in  [Create Subnets in our VPCs](#org018557f)
    -   create a security group for Jenkins in VPC worker
        -   allow in from 80/443 web ports.
        -   allow out anywhere for ephemeral ports.
        -   allow ssh from port 22 from our home IP
        -   allow in from us-east-1 (master) subnet created in  [Create Subnets in our VPCs](#org018557f)


<a id="org501eb05"></a>

### Create an ALB     :alb:


<a id="orgb744f26"></a>

## Create Instances


### Configure AMIs     :ami:vm:

-   An Amazon Machine Image (AMI) provides the information required to launch an instance.
    -   <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html>
-   <./instances.tf>
    -   data
        -   get the AMI names for the latest Amazon Linux AMI


### Configure SSH keypairs for AMI VMs     :keypair:

-   A key pair, consisting of a public key and a private key, is a set of security credentials that you use to prove your identity when connecting to an Amazon EC2 instance. Amazon EC2 stores the public key on your instance, and you store the private key. For Linux instances, the private key allows you to securely SSH into your instance. Anyone who possesses your private key can connect to your instances, so it&rsquo;s important that you store your private key in a secure place.
    -   <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html>
-   <./instances.tf>
    -   create keypairs for each region


### Bootstrap EC2 Instances with Packer and Ansible     :ansible:ec2:


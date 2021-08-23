
# Table of Contents

1.  [Conventions](#org71a2edf)
2.  [Install Terraform](#org431cd93):terraform:install:
3.  [Configure AWS](#org099d5ce):aws:
    1.  [Setup AWS CLI](#org2458544):cli:install:
    2.  [Create IAM User and Policies](#org4dbe89b):iam:
4.  [Configure Terraform Cloud](#org46a96f4)
    1.  [Setup Terraform Cloud State](#org6ec51d3)
5.  [Create Infrastructure with Terraform](#org8454b76):terraform:iac:
    1.  [Create variables](#org929becc):variables:
    2.  [Create a network](#org0d42259):network:



<a id="org71a2edf"></a>

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


<a id="org431cd93"></a>

# Install Terraform     :terraform:install:

<https://www.terraform.io/downloads.html>


<a id="org099d5ce"></a>

# Configure AWS     :aws:

-   Register account: <https://portal.aws.amazon.com/gp/aws/developer/registration/index.html>


<a id="org2458544"></a>

## Setup AWS CLI     :cli:install:

-   <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html>


<a id="org4dbe89b"></a>

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


<a id="org46a96f4"></a>

# Configure Terraform Cloud

-   Regsiter account: <https://app.terraform.io/signup/account?utm_source=terraform_io&utm_content=terraform_cloud_top_nav>


<a id="org6ec51d3"></a>

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


<a id="org8454b76"></a>

# Create Infrastructure with Terraform     :terraform:iac:


<a id="org929becc"></a>

## Create variables     :variables:

-   Input variables serve as parameters for a Terraform module, allowing aspects of the module to be customized without altering the module&rsquo;s own source code, and allowing modules to be shared between different configurations.
    -   <https://www.terraform.io/docs/language/values/variables.html>
-   <./variables.tf>
    -   profile and default user
    -   two regions
        -   a master region
        -   a worker region


<a id="org0d42259"></a>

## Create a network     :network:


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


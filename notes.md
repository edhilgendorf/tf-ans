
# Table of Contents

1.  [Install Terraform](#orgdfe9e06)
2.  [Configure AWS](#orgc279191)
    1.  [Create IAM User and Policies](#org02f4bb6)
        1.  [base policy](#orgfc00e47)



<a id="orgdfe9e06"></a>

# Install Terraform

<https://www.terraform.io/downloads.html>


<a id="orgc279191"></a>

# Configure AWS

-   Register account: <https://portal.aws.amazon.com/gp/aws/developer/registration/index.html>


<a id="org02f4bb6"></a>

## Create IAM User and Policies

-   IAM: <https://console.aws.amazon.com/iam/home>
-   Polcies: <https://console.aws.amazon.com/iamv2/home?#/policies>
-   IAM User: <https://console.aws.amazon.com/iam/home#/users$new?step=details>
    -   programmatic (non-console)
    -   attach existing policy
-   Add user to `/.aws/credentials` as a profile:
    
        [tf_user]
        aws_access_key=XXX
        aws_secret_access_key=XXX
-   Add root user as default, or create IAM admin:
    <https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials$access_key>


<a id="orgfc00e47"></a>

### base policy

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "CustomPolicyForACGAWSTFCourse",
          "Action": [
            "ec2:Describe*",
            "ec2:Get*",
            "ec2:AcceptVpcPeeringConnection",
            "ec2:AttachInternetGateway",
            "ec2:AssociateRouteTable",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateInternetGateway",
            "ec2:CreateNetworkAcl",
            "ec2:CreateNetworkAclEntry",
            "ec2:CreateRoute",
            "ec2:CreateRouteTable",
            "ec2:CreateSecurityGroup",
            "ec2:CreateSubnet",
            "ec2:CreateTags",
            "ec2:CreateVpc",
            "ec2:CreateVpcPeeringConnection",
            "ec2:DeleteNetworkAcl",
            "ec2:DeleteNetworkAclEntry",
            "ec2:DeleteRoute",
            "ec2:DeleteRouteTable",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteSubnet",
            "ec2:DeleteTags",
            "ec2:DeleteVpc",
            "ec2:DeleteVpcPeeringConnection",
            "ec2:DetachInternetGateway",
            "ec2:DisassociateRouteTable",
            "ec2:DisassociateSubnetCidrBlock",
            "ec2:CreateKeyPair",
            "ec2:DeleteKeyPair",
            "ec2:DeleteInternetGateway",
            "ec2:ImportKeyPair",
            "ec2:ModifySubnetAttribute",
            "ec2:ModifyVpcAttribute",
            "ec2:ModifyVpcPeeringConnectionOptions",
            "ec2:RejectVpcPeeringConnection",
            "ec2:ReplaceNetworkAclAssociation",
            "ec2:ReplaceNetworkAclEntry",
            "ec2:ReplaceRoute",
            "ec2:ReplaceRouteTableAssociation",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
            "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
            "acm:*",
            "elasticloadbalancing:AddListenerCertificates",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateRule",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeleteRule",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:DescribeListenerCertificates",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeSSLPolicies",
            "elasticloadbalancing:DescribeTags",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:ModifyRule",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:RemoveListenerCertificates",
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:SetSecurityGroups",
            "elasticloadbalancing:SetSubnets",
            "route53:Get*",
            "route53:List*",
            "route53:ChangeResourceRecordSets",
            "ssm:Describe*",
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath",
            "s3:CreateBucket",
            "s3:DeleteBucket",
            "s3:DeleteObject",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:HeadBucket",
            "s3:ListBucket",
            "s3:PutObject"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }


# Terraform-project
Terraform-project with Tooplate templates

<img src="https://user-images.githubusercontent.com/96655654/201022539-7c73619a-4542-483f-a6b6-484a0442274c.png" width=50% height=50%>

The project use Terraform IAC to launch a Tempalte that i took form Tooplate website.Above is the web output of the project.

The project create's Twelve plus resoures as mentioned in the instance.tf file 
# Instance.tf 
   This file Has the Vpc,subnet,RouteTabble,Internetgateway,Instance and much more
# Backend.tf
   This file is used to maintain the terraform state in a centralized location when you are working in a team.I have used S3 bucked as storage .You can create one and use those credentials.
# var.tf
   This file helps you to set variables for your instance.tf file insted of giving directly to the instance.tf file all the vaiables are moved to var.tf.So the template can be used for diffrent environment.
# Web.sh
  This is the script to install the server and launching the Tooplate webpage . You can automate based on your preference.
  
# Steps to create this Environment
     # Prerequisites
        1} Terraform{prerequisites} should be Installed in your windows or linux based on the OS.
        2} create IAM role with required permission.
        3} Install aws-cli and use aws-configure, pass the credendials Access-token and secret-key.
     # Commands
        *Terraform init - The terraform init command initializes a working directory containing configuration files and installs plugins for required providers.
        *Terraform plan - The terraform plan command lets you to preview the actions Terraform would take to modify your infrastructure, or save a speculative plan      
        which you can apply later
        * Terraform Apply will create resources and It will through you Output with Public-ip and privete-ip
        * Use the publicIp to view the website.
        
  

# Setting Up an Example

## Checklist
- Create a workspace in TF Cloud. Use the prefix `example-*` to follow the expected convention for authentication.
- Make sure to add the variables for OIDC authentication.
- 

## Create infrastructure workspace
Now, navigate to Terraform Cloud in your web browser, and select your organization.

Create a new workspace in your default project by selecting New > Workspace on the Projects & workspaces page. Configure it with the following settings.

Select Version control workflow.
Choose the learn-terraform-dynamic-credentials GitHub repository that you created earlier in this tutorial. If you have not yet connected your GitHub account to Terraform Cloud, follow the prompts to do so. Refer to the Use VCS-Driven Workflow tutorial for detailed instructions.
On the Configure settings step, expand the Advanced options interface, and set the Terraform Working Directory to the appropriate one for your cloud provider.
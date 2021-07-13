**How-to for infrastructure deployment: Single-regional cluster**

0. You need to be authorized in GCP to deploy the infrastructure.
   All **preconfiguration steps** could be done with GCP account with owner role
   or with roles/iam.serviceAccountAdmin assigned.
   All steps related to the infrastructure deployment should be done
   with GCP service account (SA) with all appropriate roles assigned.
   
   Login into your GCP account with owner role or with
   roles/iam.serviceAccountAdmin assigned:
   
    `gcloud auth login`
   
1. Next please create GCP SA in a way you prefer:
   https://cloud.google.com/iam/docs/creating-managing-service-accounts
   Then create and download the SA json key for the newly created SA:
   https://cloud.google.com/iam/docs/creating-managing-service-account-keys

2. Pull the repo from github:
   https://github.com/n0mik0s/gke/tree/sr-gke
   cd to the repo dir.
   
   *All steps to be done assumed that you are in the repo root dir.

3. Execute following bash script to assignee all needed roles to the newly
   created GCP SA:
   
   `bash ./scripts/sa_roles_binding.sh -sa SA -p PROJECT_ID`
   
4. Activate and switch to the GCP SA to perform next steps:
   
   `gcloud auth activate-service-account  SA_FULL_NAME --key-file=PATH_TO_FILE`
   
5. Create new multi-regional bucket (or use already created) and change the
   storage bucket name in the backend.tf file to the newly created bucket:
   
   `terraform {
     backend "gcs" {
       bucket = BUCKET_NAME
       prefix = "state"
     }
   }`
   
    Edit your tfvars file by changing the gcp_project_id variable
   
6. Issue `terraform init` command to initialize terraform.

7. Create new workspace for terraform:
   
   `terraform workspace new WS_NAME`
   
8. Create ssl key and cert files and put them under certs dir in the gke root dir

9. Export all sensitive env variables:
   
   `export TF_VAR_ping_devops_user_plain=...`
   
   `export TF_VAR_ping_devops_key_encrypted=ENCRYPTED_KEY`
   
   `export TF_VAR_ping_devops_user_encrypted=ENCRYPTED_USER`

10. Do terraform plan to test your terraform code:
    
   `terraform plan -var-file=./config/YOUR_TFVARS_FILE`
    
11. Do terraform apply to apply your GCP infrastructure:
    
   `terraform apply -var-file=./config/YOUR_TFVARS_FILE`
    
12. To destroy your GCP infrastructure:
    
   `terraform destroy -var-file=./config/YOUR_TFVARS_FILE`
    
    *But firstly you need to delete all namespaces terraform resources from
    the terraform state. For example:
    
    `terraform state rm \
    module.k8s-gke-1[0].kubernetes_namespace.k8s_namespace[\"gke-1\"] \
    module.k8s-gke-1[0].kubernetes_namespace.k8s_namespace[\"gke-2\"]`
    
    `terraform state rm \
    module.k8s-gke-2[0].kubernetes_namespace.k8s_namespace[\"gke-1\"] \
    module.k8s-gke-2[0].kubernetes_namespace.k8s_namespace[\"gke-2\"]`
    
   Then you MUST delete all resources that were not provisioned via
   your terraform code but set as dependencies for all resources
   in your terraform state
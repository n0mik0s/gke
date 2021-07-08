#!/bin/sh

SERVICE_ACCOUNT_ID=terraform
PROJECT_ID=mythic-courier-319108
IAM_ROLES=(
	"roles/compute.admin"
	"roles/container.admin"
	"roles/dns.admin"
	"roles/iam.serviceAccountAdmin"
	"roles/iam.workloadIdentityPoolAdmin"
	"roles/networkmanagement.admin"
	"roles/privateca.admin"
	"roles/storage.objectAdmin"
	"roles/gkehub.admin"
  "roles/gkemulticloud.admin"
  "roles/resourcemanager.projectIamAdmin"
)

for ROLE in "${IAM_ROLES[@]}"
do
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com" \
    --role=$ROLE
done
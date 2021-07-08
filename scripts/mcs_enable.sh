#!/bin/sh

PROJECT_ID=$1
GKE_1_name=$2
GKE_1_zone=$3
GKE_2_name=$4
GKE_2_zone=$5

gcloud container hub memberships register $GKE_1_name \
   --gke-cluster $GKE_1_zone/$GKE_1_name \
   --enable-workload-identity
gcloud container hub memberships register $GKE_2_name \
   --gke-cluster $GKE_2_zone/$GKE_2_name \
   --enable-workload-identity

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[gke-mcs/gke-mcs-importer]" \
    --role "roles/compute.networkViewer"
#!/bin/sh

PROJECT_ID=$1
GKE_1_name=$2
GKE_1_zone=$3
GKE_2_name=$4
GKE_2_zone=$5

gcloud container hub memberships unregister $GKE_1_name \
   --gke-cluster $GKE_1_zone/$GKE_1_name
gcloud container hub memberships unregister $GKE_2_name \
   --gke-cluster $GKE_2_zone/$GKE_2_name

#gcloud services disable trafficdirector.googleapis.com --project $PROJECT_ID
#gcloud services disable multiclusterservicediscovery.googleapis.com --project $PROJECT_ID
#gcloud alpha container hub multi-cluster-services disable --project $PROJECT_ID
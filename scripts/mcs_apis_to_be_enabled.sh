#!/bin/sh

PROJECT_ID=$1

# APIs for MCS:
gcloud services enable gkehub.googleapis.com --project $PROJECT_ID
gcloud services enable trafficdirector.googleapis.com --project $PROJECT_ID
gcloud services enable multiclusterservicediscovery.googleapis.com --project $PROJECT_ID
gcloud alpha container hub multi-cluster-services enable --project $PROJECT_ID
#!/bin/bash -e

run() {
    echo ""
    echo "Running: $1"
    echo ""
    eval $1
    if [ $? -ne 0 ]; then
        echo "Error executing command: $1"
        exit 1
    fi
}

if [ "$#" -eq 1 ]; then
    PROJECT_ID=$1
else
    run "gcloud projects list"

    echo ""
    echo "This script will deploy a Service Account & Permissions for Nadrama."
    echo "Please enter a Project ID from the above list (or Ctrl-C to exit):"
    read PROJECT_ID
fi

run "gcloud config set project $PROJECT_ID"

current_project_output=$(gcloud config get project)
current_project=$(echo "$current_project_output" | grep -v '^$' | tail -n1)
if [[ "$current_project" != "$PROJECT_ID" ]]; then
    echo ""
    echo "The current project was not set to $PROJECT_ID. Exiting."
    exit 1
fi

run "gcloud services enable compute.googleapis.com"
run "gcloud services enable cloudresourcemanager.googleapis.com"

sa_exists=$(gcloud iam service-accounts list --filter="email:nadrama-service-account@*" --project=$PROJECT_ID 2>&1)
if echo "$sa_exists" | grep -q "Listed 0 items."; then
    run "gcloud iam service-accounts create nadrama-service-account \
        --display-name=Nadrama \
        --project=$PROJECT_ID"
fi

run "gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:nadrama-service-account@$PROJECT_ID.iam.gserviceaccount.com \
    --role='roles/compute.admin'"

run "gcloud iam service-accounts add-iam-policy-binding \
    nadrama-service-account@$PROJECT_ID.iam.gserviceaccount.com \
    --member='serviceAccount:nadrama@nadrama.iam.gserviceaccount.com' \
    --role='roles/iam.serviceAccountTokenCreator' \
    --project=$PROJECT_ID"

echo ""
echo "All Done! You can now type 'exit', hit Enter/Return, then close this browser tab/window and return to Nadrama to continue the GCP setup process."

# utility-scripts








## Guide
# I. GCP
## I. 1 Find a gcp project id by project number
```
./gcp/find_proj_id.sh  <gcp_project_number>

❯ ./gcp/find_proj_id.sh 22386224304
{
  "projectNumber": "22386224304",
  "projectId": "playground"
}

```
## I. 2 Check Cloud NAT allocated port per IP to check whether port is lacking
```
./gcp/nat_allocated_ports.sh <gcp_project_id>
playground
     131.24.15.12 63872
     132.25.16.12 62144
     133.26.17.12 60096
Explaination: Each NAT IP address on a Cloud NAT gateway offers 64,512 TCP source ports and 64,512 UDP source ports. As the output return, the port will run out of.
```

## I. 3 Get a gcp project ID from GCS bucket name
```
./gcp/find_project_of_bucket.sh <Organization_ID> <bucketname>
❯ ./gcp/find_project_of_bucket.sh 113211822312 cdn-iam.tech.net
Bucket: cdn-iam.tech.net
projectNumber: 22386224304
{
  "projectNumber": "22386224304",
  "projectId": "playground"
}
```

## I. 4 Get unused disk from a specific gcp project id
```
./gcp/list_unused_disk.sh <gcp_project_id>
❯ ./gcp/list_unused_disk.sh playground
kubeflow-cep-recommendation-jobs-volume 300             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
kubeflow-evoucher-recommendation-jobs-volume    200             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
kubeflow-p17s-fbt-jobs-volume   200             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
kubeflow-p17s-restock-jobs-volume       500             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
kubeflow-p17s-similar-jobs-volume       200             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
kubeflow-semantic-layer-jobs-volume     200             https://www.googleapis.com/compute/v1/projects/playground/regions/asia-east1
```


# II K8S
## II. 1 Switch k8s context to specific context
```
./k8s/k8s_context.sh <key_word>
❯ ./k8s/k8s_context.sh gami
gke_playground-gamification-nonprod_asia-east1_main-1:  1
gke_playground-gamification-prod_asia-east1_main:  2

select a line number:
1
You've done with:
1
switch context [gke_playground-gamification-nonprod_asia-east1_main-1]
Switched to context "gke_playground-gamification-nonprod_asia-east1_main-1".
```
## II. 2 Get Current k8s Endpoint IP
```
./k8s/k8s_context_ip.sh
Usage: k8s_context_ip.sh  [key_word_1] [key_word_2]
Switch Context
{
  "name": "gke_playground-gamification-nonprod_asia-east1_main-1",
  "cluster": {
    "server": "https://192.168.255.2",
    "certificate-authority-data": "DATA+OMITTED"
  }
}
```
## II. 3 List static pods
```
./k8s/list_static_pods.sh
```

## II. 4 List top pods resource usage and requests  
```
- List pod usage and sort by memory
- List total resource usage 
- List total resource request
- List top 15 resource request in CPU
- List top 15 resource request in RAM

bash ./k8s/toppod.sh

```
# III. Terraform
## III. 1 Terraform plan with multiple file
```

./terraform/tf_plan_file.sh  iam.tf apis.tf

tfp \
    -target google_project_iam_member.group_owner \
    -target google_project_service.apis \
    -target google_project_iam_custom_role.bigquery-transfers-update \
    -target google_project_iam_member.dataproc-bigquery-job-user \
    -target google_project_iam_member.dataproc-bigquery-read-session-user \
    -target google_project_iam_member.dataproc_spark_roles \
    -target google_project_iam_member.default-sa_cloudtrace \
    -target google_project_iam_member.gami_repo_writer \
    -target google_project_iam_member.gami_yir_reader \
    -target google_project_iam_member.gami_yir_writer \
    -target google_project_iam_member.gcp_project_roles \
    -target google_project_iam_member.group-devops_roles \
    -target google_project_iam_member.group_gamification-devops_roles \
    -target google_project_iam_member.group_gamification_roles
.....
```


## III. 2 Terraform apply with multiple file
```

./terraform/tf_apply_file.sh  iam.tf apis.tf

tfa \
    -target google_project_iam_member.group_owner \
    -target google_project_service.apis \
    -target google_project_iam_custom_role.bigquery-transfers-update \
    -target google_project_iam_member.dataproc-bigquery-job-user \
    -target google_project_iam_member.dataproc-bigquery-read-session-user \
    -target google_project_iam_member.dataproc_spark_roles \
    -target google_project_iam_member.default-sa_cloudtrace \
    -target google_project_iam_member.gami_repo_writer \
    -target google_project_iam_member.gami_yir_reader \
    -target google_project_iam_member.gami_yir_writer \
    -target google_project_iam_member.gcp_project_roles \
    -target google_project_iam_member.group-devops_roles \
    -target google_project_iam_member.group_gamification-devops_roles \
    -target google_project_iam_member.group_gamification_roles
.....
```
## III. 3 Terraform apply from clipboard
```
Copy block of code in terraform file and run
./terraform/tf_apply_clipboard.sh
tfa \
    -target google_service_account.gami-nonprod-alert-reader \
    -target google_storage_bucket_iam_member.devops_bucket_roles
```

## III. 4 Terraform plan from clipboard
```
Copy block of code in terraform file and run
./terraform/tf_plan_clipboard.sh
tfp \
    -target google_service_account.gami-nonprod-alert-reader \
    -target google_storage_bucket_iam_member.devops_bucket_roles
```
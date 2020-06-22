# CLOUD RESUME CHALLENGE

## METHODOLOGY 

Uses an Infrastructure As Code methodology based on principles from https://12factor.net. 

#### I. Codebase

Hosted in github as a monolith 

#### II. Dependencies 

Dependencies explicitely declared via Dockerfile and requirements.txt pip file. 

#### III. Config 

Configuration stored via Kubernetes ConfigMaps, Kubernetes Environment Variables, Kubernetes Secrets, and GitHub Secrets.

#### IV. Backing services 

Uses sqlite on PersistentStorage, with PersistentStorage as attached resource. Docker image with sqlite storage can be pulled in and ran from anywhere. 

#### V. Build, release, run 

Build stage is done via GitHub Actions, run stage is done via ArgoCD. The release stage is a manual process done by incrementing build release to number noted in build stage ("Set docker version"). 

#### VI. Processes 

Processes are executed as stateles Docker Containers within Kubernetes. 

#### VII. Port binding 

Adapted hit-counter app to use port binding by gunicorn for a production ready WSGI web server. 

#### VIII. Concurrency

Processes are scaled out within Kubernetes using methodologies such as StatefulSets and ReplicaSets. The application runs on a 3 node cluster spanning multiple instances. Docker is used to manage processes runtime. 

#### IX. Disposability 

All containers can be killed and will re-spawn immediately based on deployment specs. Deployments and all resources can be manually deleted and will respawn after an ArgoCD sync as long as the app itself has not been deleted from ArgoCD, or had its manifest modified to persist changes. 

##### X. Dev/prod Parity 

This environment creates one "resume" GKE cluster for cost savings, and then all manifests are sorted into two environments on the cluster: stage, prod. These environments are separated out by namespace, and then by git branch on GitHub. Ingress hosts are given the name $SERVICE-stage.example.com, and then $SERVICE.example.com, except for the apex (root) domain, which is the resume service accessed at "example.com." 

##### XI. Logs

Logs are treated as live streams to standard out and viewable within ArgoCD. 

#### XII. Admin processes 

Processes such as those related to importing dashboards in grafana are treated as one-off processes. 

## HIT-COUNTER

Existing solution was used and converted to work with kubernetes.

https://github.com/brentvollebregt/hit-counter

Adapted solution to work with gunicorn for a production ready deployment. 

Changed DATABASE_FILENAME in config.py to './db/data.db' and added PersistentVolumeClaim for persistent storage

## MONITORING


https://github.com/do-community/doks-monitoring/tree/master/manifest (grafana dashboards don't work)

https://github.com/giantswarm/prometheus.git 

For combination prometheus, grafana, and alert manager metrics and reporting. Login to grafana with the following:

``` 
kubectl port-forward --namespace monitoring service/grafana 3000:8080
```

## SECURITY 

All domains hosted with CloudFlare, which provides SSL and DDOS protection for free by default. GitHub Actions using encrypted ansible-vault secret to manage access to GCP. Changed "- --interval=30s" to "- --interval=300s" in external-dns args in order to work with CloudFlare. GitHub Secrets:

ARGOCD_ADMIN => argocd admin pass
CLOUDFLARE_API_TOKEN => CloudFlare API TOKEN not Key
CLOUDFLARE_EMAIL => CloudFlare Email
GCP_PROJECT => GCP project
GCP_STORAGE => GCP bucket
GITHUBTOKEN => GitHub Personal Access Token
GRAFANA_ADMIN => Grafana secret
SERVICE_ACCOUNT => Password to decrypt your encrypted serviceaccount credentials 

## INFRASTRUCTURE AS CODE (IaC) 

## **CICD**

GitHub Actions: Implement CICD workflow with terraform

https://github.com/rewindio/terraform-rewindio-example/blob/master/.github/workflows/tf-plan.yml

      
```
export PROJECT_ID=foo
export IAM_ACCOUNT=foo
export IAM_USER=terraform 
export STORAGE_BUCKET=badamsresume

gcloud iam service-accounts create terraform\
    --description="$IAM_USER" \
    --display-name="$IAM_USER"
      
      
gcloud projects add-iam-policy-binding badamscka\
    --member=serviceAccount:terraform@$PROJECT_ID.iam.gserviceaccount.com --role=roles/owner
      
gcloud iam service-accounts keys create serviceaccount.json --iam-account=terraform@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT \
    --member=serviceAccount:$IAM_ACCOUNT\
    --role=roles/storage.admin

pip3 install ansible-vault

ansible-vault encrypt serviceaccount.json

GitHub Repo Settings -> Secrets -> Create secret with above password 

gsutil mb gs://$STORAGE_BUCKET/

terraform workspace new staging                                   

gcloud container clusters get-credentials resume --region us-west1

```      

## **TERRAFORM** 

Used to create Kubernetes Cluster in GCP: 

https://github.com/terraform-google-modules/terraform-google-kubernetes-engine


## **LINKS**

https://12factor.net

https://github.com/giantswarm/prometheus.git

https://github.com/do-community/doks-monitoring/tree/master/manifest

https://github.com/rewindio/terraform-rewindio-example/blob/master/.github/workflows/tf-plan.yml

https://github.com/terraform-google-modules/terraform-google-kubernetes-engine


https://github.com/autotune/gke-tf-demo


https://atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow

https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster 
https://argoproj.github.io/argo-cd/

https://www.pdftohtml.net/

https://cloud.google.com/kubernetes-engine

https://mendoza.io/how-to-run-ghost-in-kubernetes/

https://github.com/autotune/hit-counter (develop branch)

https://github.com/brentvollebregt/hit-counter

https://cert-manager.io/docs/tutorials/acme/ingress/

https://macdown.uranusjr.com

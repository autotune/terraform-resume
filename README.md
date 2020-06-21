# CLOUD RESUME CHALLENGE

## METHODOLOGY 

Uses an Infrastructure As Code methodology based on principles from https://12factor.net 

## HIT-COUNTER

Existing solution was used and converted to work with kubernetes.

https://github.com/brentvollebregt/hit-counter

Adapted solution to work with gunicorn for a production ready deployment. 

Changed DATABASE_FILENAME in config.py to './db/data.db' and added PersistentVolumeClaim for persistent storage

## MONITORING


https://github.com/do-community/doks-monitoring/tree/master/manifest

For combination prometheus, grafana, and alert manager metrics and reporting. 

## SECURITY 

All domains hosted with CloudFlare, which provides SSL and DDOS protection for free by default. GitHub Actions using encrypted ansible-vault secret to manage access to GCP. Changed "- --interval=30s" to "- --interval=300s" in external-dns args in order to work with CloudFlare.

## INFRASTRUCTURE AS CODE (IaC) 

## **CICD**

GitHub Actions: Implement CICD workflow with terraform

https://github.com/rewindio/terraform-rewindio-example/blob/master/.github/workflows/tf-plan.yml

      
```
export PROJECT_ID=foo
export IAM_ACCOUNT=foo
export IAM_USER=terraform 

gcloud iam service-accounts create terraform\
    --description="$IAM_USER" \
    --display-name="$IAM_USER"
      
      
gcloud projects add-iam-policy-binding badamscka\
    --member=serviceAccount:terraform@$PROJECT_ID.iam.gserviceaccount.com --role=roles/owner
      
gcloud iam service-accounts keys create serviceaccount.json --iam-account=terraform@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding badamscka\
    --member=serviceAccount:terraform\
    --role=roles/storage.admin

pip3 install ansible-vault

ansible-vault encrypt serviceaccount.json

GitHub Repo Settings -> Secrets -> Create secret with above password 

gsutil mb gs://badamsresume/

terraform workspace new staging                                   

gcloud container clusters get-credentials resume --region us-west1

kubectl create namespace argocd





kubectl get svc -nargocd|grep LoadBalancer => update argocd.example.com in cloudflare with ELB IP

brew install cloudflare/cloudflare/cloudflared


    
```      
      
ArgoCD - Impliment CICD workflow with Kubernetes. 

```argocd app create resume --repo https://github.com/autotune/kubernetes --path resume --dest-server https://kubernetes.default.svc --dest-namespace default```

## **TERRAFORM** 

Used to create Kubernetes Cluster in GCP: 

https://github.com/terraform-google-modules/terraform-google-kubernetes-engine


## **LINKS**

https://12factor.net

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

https://mendoza.io/how-to-run-ghost-in-kubernetes/

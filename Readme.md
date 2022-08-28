# EasyNotes Application

Deploy a Restful CRUD API for a simple Note-Taking application on AWS EKS using Terraform.

## Directory Structure
`**kube-deployment-files**` contains the Kubernetes deployment yml files  
`**kustomize**` contains the Kustomize files. This is just for the demo purpose.  
`**node-easy-notes-app**` contains the Note-Taking application files and Dockerfile. The app file is changed a little to support MongoDB URL variable.  
`**terraform-eks-cluster**` contains the terraform files to create EKS cluster.  
`**terraform-resources**` contains the terraform files to create Kubernetes resources.      

## Prerequisites
For this tutorial, you will need:
* an AWS account  
* the Kubernetes CLI, also known as kubectl  
* Terraform version >= v1.2.0  

## Steps to Setup

1. Create EKS cluster, by default it will create cluster in us-east-1 region. Change the region by passing <region> env variable. Other var can also be updated see variables.tf inside terraform-eks-cluster directory.

```
cd terraform-eks-cluster
terraform init
terraform apply
``` 

2. Authenticate kubectl to eks cluster.

```
cd terraform-eks-cluster
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

3. Deploy the calico network plugin once cluster is ready.

```
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml
```

4. If resource deployment through Kubernetes deployment yml files is in question, then:

```
cd kube-deployment-files
kubectl apply -f db.yaml
kubectl apply -f node.yaml
kubectl apply -f db-network-policy.yaml
```

Note: The docker image is already built and pushed to public repo, however if new docker image building is required then:

```
cd node-easy-notes-app
docker build -t <tag> .
sed -i "s|zahid401/node-easy-notes:latest|<your-image>|" kube-deployment-files/node.yaml
```

Note: Push the image to public repo.

5. If resource deployment through terraform files is in question, then:

```
cd terraform-resources
terraform init
terraform apply
```

Note: by default it will fetch the cluster metadata from cluster hosted in us-east-1 region. Change the region by passing <region> env variable. Other var can also be updated see variables.tf inside terraform-resources directory.
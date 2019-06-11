
//
// GCP needs auth creds to manager clusters
// Two ways of doing so:
// 
// gcloud auth application-default login
// This will use your gcp login itself to manage clusters
// Its a bad idea. Use service accounts instead
// 
// OR
// 
// Create service account via GCP console
// Then create a key for that service account
// Download it and then set the env var accordingly
// export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account/key.json
//
// At the end of the run, the following command should be printed
// gcloud container clusters get-credentials terraform-k8s-243400-cluster --zone us-east1-b --project terraform-k8s-243400
// Use the above to let kubectkl point to GCP cluster instead of local
//
// To verify, kubectl is good:
//
// vaibhav$ kubectl get pods
//      Unable to connect to the server: dial tcp 192.168.99.100:8443: connect: host is down
//
// vaibhav$ gcloud container clusters get-credentials terraform-k8s-243400-cluster --zone us-east1-b --project terraform-k8s-243400
//      Fetching cluster endpoint and auth data.
//      kubeconfig entry generated for terraform-k8s-243400-cluster.
//
// vaibhav$ kubectl get pods (No pods were created so nothing came back)
//      No resources found.
//
// vaibhav$ kubectl get nodes (We have the 3 nodes that we created via terraform)
//      NAME                                                  STATUS   ROLES    AGE   VERSION
//      gke-terraform-k8s-24-terraform-k8s-24-abea7189-7w6g   Ready    <none>   44m   v1.12.8-gke.6
//      gke-terraform-k8s-24-terraform-k8s-24-d36c2738-6sj4   Ready    <none>   43m   v1.12.8-gke.6
//      gke-terraform-k8s-24-terraform-k8s-24-f1fd0342-1szh   Ready    <none>   43m   v1.12.8-gke.6
//

module "kubernetes" {
 
  source = "./kubernetes"
  region = "us-east1"

  project_name_map = {
    default = "terraform-k8s-243400"
  }
}

output "connection-command" {
  value = "${module.kubernetes.connect-string}"
}
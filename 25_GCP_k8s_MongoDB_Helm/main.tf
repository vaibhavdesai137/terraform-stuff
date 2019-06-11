
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
// Use the cmd below to let kubectkl point to GCP cluster instead of local
// gcloud container clusters get-credentials terraform-k8s-243400-cluster --zone us-east1-b --project terraform-k8s-243400
//

// leave blank (helm will point to whatever kubectl is pointing to)
provider "helm" {}

// Whole lot of other configs available but this is bare minimum
resource "helm_release" "mongodb" {

  name  = "mongodb"
  chart = "stable/mongodb-replicaset"

  set {
    name  = "auth.adminUser"
    value = "foobaruser"
  }

  set {
    name  = "auth.adminPassword"
    value = "foobarpassword"
  }
}
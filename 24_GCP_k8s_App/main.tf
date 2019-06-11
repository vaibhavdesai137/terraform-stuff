
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

provider "google" {
  project = "${var.project_name_map[terraform.workspace]}"
  region  = "${var.region}"
  version = "2.5.0"
}
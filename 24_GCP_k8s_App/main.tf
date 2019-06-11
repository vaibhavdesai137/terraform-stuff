
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
// Once everything is executed, we should see the LB IP on the terminal
// Also, we should see 1 nginx-pod running as 3 replicas (Workloads tab on GCP console)
// And a service created (Services tab on GCP console)
// 
// vaibhav$
//        lb_ip = 35.237.245.80
// 
// Hitting that endpoint should fetch the default nginx page
//
// Use the cmd below to let kubectkl point to GCP cluster instead of local
// gcloud container clusters get-credentials terraform-k8s-243400-cluster --zone us-east1-b --project terraform-k8s-243400
//

// leave blank to pickup config from kubectl config of local system (or wherever kubectl is pointing to)
provider kubernetes {
  
}

resource "kubernetes_deployment" "nginx-deployment" {
  
  metadata {
    name = "nginx-deployment"
  }

  spec {
    
    replicas = 3

    selector {
      match_labels = {
        component = "nginx-pod"
      }
    }

    template {

      metadata {
        labels = {
          component = "nginx-pod"
        }
      }

      spec {
        container {
          
          image = "nginx"
          name  = "nginx-container"

          resources {
            requests {
              memory = "256Mi"
              cpu    = "100m"
            }
            limits {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "80"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "80"
            }

            initial_delay_seconds = 120
            period_seconds        = 15
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-service" {
  
  metadata {
    name = "nginx-service"
  }

  spec {
    
    // Tell the service it needs to poiunt to nginx-pod
    selector = {
      component = "nginx-pod"
    }

    session_affinity = "ClientIP"

    port {
      port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = "${kubernetes_service.nginx-service.load_balancer_ingress.0.ip}"
}

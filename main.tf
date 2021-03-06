provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cf_email
  api_key = var.cf_api_key
}


module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.3"

  project_id   = "badamscka"
  network_name = "resume"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "gke"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]

  secondary_ranges = {
    gke = [
      {
        range_name    = "gke-pods-01"
        ip_cidr_range = "10.44.0.0/14"
      },

      {
        range_name    = "gke-services-01"
        ip_cidr_range = "10.0.16.0/20"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "badamscka"
  name                       = "resume"
  region                     = "us-west1"
  zones                      = ["us-west1-a", "us-west1-b", "us-west1-c"]
  network                    = "${module.vpc.network_name}"
  subnetwork                 = "${module.vpc.subnets_names[0]}"
  ip_range_pods              = "gke-pods-01"
  ip_range_services          = "gke-services-01"
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true
  monitoring_service         = "monitoring.googleapis.com/kubernetes"

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "terraform@badamscka.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

provider "kubernetes" {
  config_context_cluster = "${module.gke.name}"
}

resource "google_container_cluster" "primary" {
  count             = length(var.cluster)
  name              = lookup(var.cluster[count.index], "name", "")
  description       = lookup(var.cluster[count.index], "description", "")
  location          = lookup(var.cluster[count.index], "location", "")
  cluster_ipv4_cidr = lookup(var.cluster[count.index], "cluster_ipv4_cidr", "")
  subnetwork           = lookup(var.cluster[count.index], "subnetwork", "")
  remove_default_node_pool = lookup(var.cluster[count.index], "remove_default_node_pool", "")
  initial_node_count = lookup(var.cluster[count.index], "initial_node_count", "")

  private_cluster_config {
    enable_private_endpoint = lookup(var.cluster[count.index], "enable_private_endpoint", "")
    enable_private_nodes    = lookup(var.cluster[count.index], "enable_private_nodes", "")
    master_ipv4_cidr_block  = lookup(var.cluster[count.index], "master_ipv4_cidr_block", "")
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
 
  addons_config {
    http_load_balancing {
      disabled = lookup(var.cluster[count.index], "http_load_balancing", "")
    }

    horizontal_pod_autoscaling {
      disabled = lookup(var.cluster[count.index], "horizontal_pod_autoscaling", "")
    }

    kubernetes_dashboard {
      disabled = lookup(var.cluster[count.index], "kubernetes_dashboard", "")
    }

    network_policy_config {
      disabled = lookup(var.cluster[count.index], "network_policy_config", "")
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = lookup(var.cluster[count.index], "cluster_secondary_range_name", "")
    services_secondary_range_name = lookup(var.cluster[count.index], "services_secondary_range_name", "")
  }
}

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

resource "google_container_node_pool" "primary_preemptible_nodes" {
  count    = length(var.node_pools)
  name       = var.node_pools[count.index]["name"]
  location   = lookup(var.node_pools[count.index], "location", "")
  cluster    = "${google_container_cluster.primary.name}"
  node_count = lookup(var.node_pools[count.index], "node_count", "")
  image_type         = lookup(var.node_pools[count.index], "image_type", "COS")
  node_config {
    preemptible  = true
    machine_type = lookup(var.node_pools[count.index], "machine_type", "")

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
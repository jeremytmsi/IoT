terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }

    jsonnet = {
      source = "alxrem/jsonnet"
    }
  }
}

# On définit le provider pour Grafana
provider "grafana" {
  # L'URL est à remplacer selon votre besoin
  url  = "http://192.168.141.91:3000"
  auth = "${var.grafana_api_token}"
}

provider "jsonnet" {
  jsonnet_path = join(":", ["${path.module}/jsonnet", "${path.module}/jsonnet/grafonnet-lib", "${path.module}/vendor"])
}

data "jsonnet_file" "dashboard" {
    source = "${path.module}/dashboards/grafana.jsonnet"
}

# On importe le dashboard dans Grafana
resource "grafana_dashboard" "grafana" {
  config_json = data.jsonnet_file.dashboard.rendered
}
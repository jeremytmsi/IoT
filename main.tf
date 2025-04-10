terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }
  }
}

# On définit le provider pour Grafana
provider "grafana" {
  url  = "http://192.168.141.91:3000"
  auth = "${var.grafana_api_token}"
}

# On importe le dashboard dans Grafana
resource "grafana_dashboard" "grafana" {
  config_json = file("${path.module}/dashboards/grafana.json")
}
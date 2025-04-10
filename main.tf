terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }
  }
}

provider "grafana" {
  url  = "http://localhost:3000"
  auth = "${var.grafana_api_token}"
}

resource "grafana_dashboard" "grafana" {
  config_json = file("${path.module}/dashboards/grafana.json")
}
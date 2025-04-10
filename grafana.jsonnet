local grafana = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local dashboard = grafana.dashboard;
local gauge = grafana.panel.gauge;
local timeSeries = grafana.panel.timeSeries;

dashboard.new("IoT")
+ dashboard.withRefresh('10s')
+ dashboard.withPanels([
    gauge.new("Setpoint")
    + gauge.panelOptions.withTitle("Setpoint")
    + gauge.datasource.withType("influxdb")
    + gauge.datasource.withUid("_uAwS2THz")
    + gauge.queryOptions.withTargets([
       
    ]),

    gauge.new("Temperature")
    + gauge.panelOptions.withTitle("Temperature")
    + gauge.datasource.withType("influxdb")
    + gauge.datasource.withUid("_uAwS2THz"),

    timeSeries.new("Graphe")
    + timeSeries.panelOptions.withTitle("Graphe")
    + timeSeries.datasource.withType("influxdb")
    + timeSeries.datasource.withUid("_uAwS2THz")
])
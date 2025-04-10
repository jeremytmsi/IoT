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
       {
            datasource: {
                "type": "influxdb",
                "uid": "_uAwS2THz",
            },
            query: "from(bucket: \"iot-platform\")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")\n  |> filter(fn: (r) => r[\"_field\"] == \"setpoint\")",
            refId: "A"
        },
    ]),

    gauge.new("Temperature")
    + gauge.panelOptions.withTitle("Temperature")
    + gauge.datasource.withType("influxdb")
    + gauge.datasource.withUid("_uAwS2THz")
    + gauge.queryOptions.withTargets([
        {
            datasource: {
                "type": "influxdb",
                "uid": "_uAwS2THz",
            },
            query: "from(bucket: \"iot-platform\")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")\n  |> filter(fn: (r) => r[\"_field\"] == \"temperature\")",
            refId: "A"
        }
    ]),

    timeSeries.new("Graphe")
    + timeSeries.panelOptions.withTitle("Graphe")
    + timeSeries.datasource.withType("influxdb")
    + timeSeries.datasource.withUid("_uAwS2THz")
    + timeSeries.queryOptions.withTargets([
        {
            datasource: {
                "type": "influxdb",
                "uid": "_uAwS2THz"
            },
            query: "from(bucket: \"iot-platform\")\r\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\r\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")",
            refId: "A"
        }
    ])
])
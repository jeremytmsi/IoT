local grafana = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local dashboard = grafana.dashboard;
local gauge = grafana.panel.gauge;
local timeSeries = grafana.panel.timeSeries;
local influxdb_uid = "_uAwS2THz";

local var = grafana.dashboard.variable;

local salles = var.custom.new('salles', ['8d120','8d121']);
local devices = var.custom.new("devices",['8d120-1','8d120-2','8d121-1','8d121-2']);

# On crée un nouveau dashboard
dashboard.new("IoT")
+ dashboard.withVariables([
    salles,
    devices
])
+ dashboard.withRefresh('10s')
+ dashboard.withPanels([

    # On définit le panel pour afficher la consigne
    gauge.new("Setpoint")
    + gauge.panelOptions.withTitle("Setpoint")
    + gauge.datasource.withType("influxdb")
    + gauge.datasource.withUid(influxdb_uid)
    + gauge.queryOptions.withTargets([
       {
            datasource: {
                "type": "influxdb",
                "uid": influxdb_uid,
            },
            query: "from(bucket: \"iot-platform\")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")\n  |> filter(fn: (r) => r[\"salle\"] == \"${salles}\")\n  |> filter(fn: (r) => r[\"capteur\"] == \"${devices}\")\n  |> filter(fn: (r) => r[\"_field\"] == \"setpoint\")",
            refId: "A"
        },
    ])
    + gauge.panelOptions.withGridPos(5, 12, 0, 0),

    # On définit le panel pour afficher la température du capteur
    gauge.new("Temperature")
    + gauge.panelOptions.withTitle("Temperature")
    + gauge.datasource.withType("influxdb")
    + gauge.datasource.withUid(influxdb_uid)
    + gauge.queryOptions.withTargets([
        {
            datasource: {
                "type": "influxdb",
                "uid": influxdb_uid,
            },
            query: "from(bucket: \"iot-platform\")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")\n  |> filter(fn: (r) => r[\"salle\"] == \"${salles}\")\n  |> filter(fn: (r) => r[\"capteur\"] == \"${devices}\")\n  |> filter(fn: (r) => r[\"_field\"] == \"temperature\")",
            refId: "A"
        }
    ])
    + gauge.panelOptions.withGridPos(5, 12, 12, 0),

    # On définit le graphe
    timeSeries.new("Graphe")
    + timeSeries.panelOptions.withTitle("Graphe")
    + timeSeries.datasource.withType("influxdb")
    + timeSeries.datasource.withUid(influxdb_uid)
    + timeSeries.queryOptions.withTargets([
        {
            datasource: {
                "type": "influxdb",
                "uid": influxdb_uid
            },
            query: "from(bucket: \"iot-platform\")\r\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\r\n  |> filter(fn: (r) => r[\"_measurement\"] == \"msg.payload\")\r\n  |> filter(fn: (r) => r[\"salle\"] == \"${salles}\")\r\n  |> filter(fn: (r) => r[\"capteur\"] == \"${devices}\")",
            refId: "A"
        }
    ])
    + timeSeries.panelOptions.withGridPos(7, 24, 0, 5)
])
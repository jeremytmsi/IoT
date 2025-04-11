local grafana = import 'lib/grafonnet/grafonnet/main.libsonnet';

local dashboard = grafana.dashboard;
local gauge = grafana.panel.gauge;
local timeSeries = grafana.panel.timeSeries;
local influxdb_uid = "_uAwS2THz";

local var = grafana.dashboard.variable;

local salles = var.custom.new('salles', ['8d120', '8d121']);

local devices = var.query.new(
  name='devices',
  datasource=influxdb_uid,
  query='from(bucket: "iot-platform") |> range(start: -1h) |> filter(fn: (r) => r["salle"] == "${salles}") |> keep(columns: ["capteur"]) |> distinct(column: "capteur") |> sort()'
) + var.query.withRefresh('onTimeRangeChanged');

dashboard.new("IoT")
+ dashboard.withVariables([
    salles,
    devices
])
+ dashboard.withRefresh('10s')
+ dashboard.withPanels([

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
            query: 'from(bucket: "iot-platform")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r["_measurement"] == "msg.payload")\n  |> filter(fn: (r) => r["salle"] == "${salles}")\n  |> filter(fn: (r) => r["capteur"] == "${devices}")\n  |> filter(fn: (r) => r["_field"] == "setpoint")',
            refId: "A"
        },
    ])
    + gauge.panelOptions.withGridPos(5, 12, 0, 0),

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
            query: 'from(bucket: "iot-platform")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r["_measurement"] == "msg.payload")\n  |> filter(fn: (r) => r["salle"] == "${salles}")\n  |> filter(fn: (r) => r["capteur"] == "${devices}")\n  |> filter(fn: (r) => r["_field"] == "temperature")',
            refId: "A"
        }
    ])
    + gauge.panelOptions.withGridPos(5, 12, 12, 0),

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
            query: 'from(bucket: "iot-platform")\n  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)\n  |> filter(fn: (r) => r["_measurement"] == "msg.payload")\n  |> filter(fn: (r) => r["salle"] == "${salles}")\n  |> filter(fn: (r) => r["capteur"] == "${devices}")',
            refId: "A"
        }
    ])
    + timeSeries.panelOptions.withGridPos(7, 24, 0, 5)
    + timeSeries.withFieldConfig({
        defaults: {
          color: {
            mode: 'palette-classic'
          }
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: '8d120-1'
            },
            properties: [
              {
                id: 'color',
                value: 'red'
              }
            ]
          },
          {
            matcher: {
              id: 'byName',
              options: '8d120-2'
            },
            properties: [
              {
                id: 'color',
                value: 'green'
              }
            ]
          }
        ]
    })
])

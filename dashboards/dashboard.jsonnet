// dashboard.jsonnet
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local volumes = [
  'Rust_1',
  'Archive A',
  'Archive B',
];

local stdLabels = 'job="integrations/macos-node", instance="trevor"';

local fmt = std.format;

local promTarget = function(query)
  g.query.prometheus.new(
    'grafanacloud-joshhunt-prom',
    query,
  );

g.dashboard.new('My Dashboard')
+ g.dashboard.withUid('fee2tmtv6ncaod')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withPanels(

  g.util.grid.makeGrid(
    std.map(
      function(volume)
        g.panel.timeSeries.new('Volume ' + volume + ' Usage')
        + g.panel.timeSeries.queryOptions.withTargets([
          promTarget(
            fmt('node_filesystem_size_bytes{%s, mountpoint="/Volumes/%s"} - node_filesystem_avail_bytes{%s, mountpoint="/Volumes/%s"}', [stdLabels, volume, stdLabels, volume]),
          ),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8)
      ,
      volumes
    )
  )

)

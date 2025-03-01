local queries = import './queries.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local volumes = [
  'Rust_1',
  'Archive A',
  'Archive B',
];

g.dashboard.new('Mini monitoring')
+ g.dashboard.withUid('fee2tmtv6ncaod')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.time.withFrom('now-7d')
+ g.dashboard.time.withTo('now')
+ g.dashboard.withPanels(
  g.util.grid.makeGrid(
    std.map(
      function(volume)
        g.panel.timeSeries.new('Volume ' + volume + ' Usage')
        + g.panel.timeSeries.queryOptions.withTargets([
          queries.usedDiskSpace(volume),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
      ,
      volumes
    )
  )

)

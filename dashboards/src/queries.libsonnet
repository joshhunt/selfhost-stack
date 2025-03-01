local datasources = import './datasources.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local stdLabels = 'job="integrations/macos-node", instance="trevor"';

{
  usedDiskSpace: function(volume)
    g.query.prometheus.new(
      datasources.prom,
      std.format(
        |||
          node_filesystem_size_bytes{%s, mountpoint="/Volumes/%s"}
          - node_filesystem_avail_bytes{%s, mountpoint="/Volumes/%s"}
        |||, [
          stdLabels,
          volume,
          stdLabels,
          volume,
        ]
      )
    ),
}

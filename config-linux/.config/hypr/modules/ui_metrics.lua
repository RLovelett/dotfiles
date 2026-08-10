local config_home = assert(os.getenv("XDG_CONFIG_HOME"), "XDG_CONFIG_HOME must be set")
local metric_tokens_path = config_home .. "/quickshell/signal-rail/theme/MetricTokens.qml"
local metric_tokens_file = assert(io.open(metric_tokens_path, "r"), "cannot read shared UI metrics: " .. metric_tokens_path)
local metric_tokens = metric_tokens_file:read("*a")
metric_tokens_file:close()

local edge_gap = tonumber(metric_tokens:match("readonly%s+property%s+int%s+edgeGap:%s*(%d+)"))
assert(edge_gap ~= nil, "MetricTokens.qml must define edgeGap as a non-negative integer literal")

return {
  edge_gap = edge_gap,
}

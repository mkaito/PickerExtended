data:extend{
    {
        type = "string-setting",
        name = "picker-no-blueprint-inv",
        setting_type = "runtime-per-user",
        default_value = "none",
        allowed_values = {"none", "main", "all"},
        order = "picker-z[zapper]-a",
    },
    {
        type = "string-setting",
        name = "picker-no-deconstruction-planner-inv",
        setting_type = "runtime-per-user",
        default_value = "none",
        allowed_values = {"none", "main", "all"},
        order = "picker-z[zapper]-b",
    },
    {
        type = "string-setting",
        name = "picker-no-other-planner-inv",
        setting_type = "runtime-per-user",
        default_value = "none",
        allowed_values = {"none", "main", "all"},
        order = "picker-z[zapper]-c",
    },
    {
        type = "string-setting",
        name = "picker-item-zapper",
        setting_type = "runtime-per-user",
        default_value = "blueprint blueprint-book deconstruction-planner zone-planner unit-remote-control",
        allow_blank = true,
        order = "picker-z[zapper]-z",
    },
    {
        type = "bool-setting",
        name = "picker-item-zapper-all",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "picker-z[zapper]-y",
    },
    {
        type = "bool-setting",
        name = "picker-hide-minimap",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-b[minimap]-a",
    },
    {
        type = "bool-setting",
        name = "picker-itemcount",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-b[itemcount]-a",
    },
    {
        type = "bool-setting",
        name = "picker-auto-sort-inventory",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "picker-b[sortinventory]-a",
    },
    {
        type = "bool-setting",
        name = "picker-search-light",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-b[lights]-a",
    },
    {
        type = "bool-setting",
        name = "picker-find-orphans",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-b[find-orphans]-a",
    },
    {
        type = "string-setting",
        name = "picker-quick-ug-mode",
        setting_type = "runtime-per-user",
        default_value = "safe",
        allowed_values = {"off", "safe", "medium", "aggresive"},
        order = "picker-c[quick-ug]-b",
    },
    {
        type = "double-setting",
        name = "picker-player-paste-modifier",
        setting_type = "runtime-per-user",
        default_value = 1,
        minimum_value = .1,
        maximum_value = 1000,
        order = "picker-x[paste-modifier]-a",
    },
    {
        type = "bool-setting",
        name = "picker-alt-mode-default",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-d[alt-mode]-a",
    },
    {
        type = "bool-setting",
        name = "picker-auto-manual-train",
        setting_type = "runtime-per-user",
        default_value = true,
        order = "picker-e[automatic-trains]-a",
    },
}
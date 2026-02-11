name = "每日食谱"
description = "每天中午发布每日食谱，今天要吃什么？选中这些食谱会有额外加成。"
author = "橙小幸"
version = "1.0"

forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "recipe_count",
        label = "每日食谱数量",
        options = {
            {description = "1个", data = 1},
            {description = "2个", data = 2},
            {description = "3个", data = 3},
            {description = "4个", data = 4},
            {description = "5个", data = 5},
        },
        default = 3,
    },
    {
        name = "bonus_multiplier",
        label = "加成倍数",
        options = {
            {description = "1.2倍", data = 1.2},
            {description = "1.5倍", data = 1.5},
            {description = "2.0倍", data = 2.0},
            {description = "2.5倍", data = 2.5},
        },
        default = 1.5,
    },
    {
        name = "announce_text",
        label = "公告文字",
        options = {
            {description = "今日推荐", data = "今日推荐"},
            {description = "每日特餐", data = "每日特餐"},
            {description = "今日菜单", data = "今日菜单"},
            {description = "厨师推荐", data = "厨师推荐"},
        },
        default = "今日推荐",
    },
    {
        name = "extra_buff",
        label = "额外Buff",
        options = {
            {description = "无", data = "none"},
            {description = "加速", data = "speed"},
            {description = "发光", data = "light"},
            {description = "吸血", data = "lifesteal"},
        },
        default = "none",
    },
    {
        name = "buff_duration",
        label = "Buff持续时间",
        options = {
            {description = "30秒", data = 30},
            {description = "60秒", data = 60},
            {description = "120秒", data = 120},
            {description = "180秒", data = 180},
        },
        default = 60,
    },
}

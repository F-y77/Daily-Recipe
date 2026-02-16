local MOD_VERSION = "1.1.0"

name = "每日食谱"
description = [[
每天白天发布每日食谱，今天要吃什么？

版本: ]]..MOD_VERSION..[[

选中这些食谱会有额外加成
支持原版和MOD食谱
可自定义加成倍数和额外Buff
推荐开荒使用
]]

author = "橙小幸"
version = MOD_VERSION

forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"daily_recipe", "每日食谱", "橙小幸"}

local function Title(title)
    return {
        name = title,
        hover = "",
        options = {{description = "", data = 0}},
        default = 0,
    }
end

configuration_options = {
    Title("========== 基础设置 =========="),
    
    {
        name = "recipe_count",
        label = "每日食谱数量",
        hover = "每天推荐的食谱数量",
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
        hover = "食用今日食谱的属性加成倍数",
        options = {
            {description = "1.2倍", data = 1.2},
            {description = "1.5倍", data = 1.5},
            {description = "2.0倍", data = 2.0},
            {description = "2.5倍", data = 2.5},
            {description = "3.0倍", data = 3.0},
        },
        default = 1.5,
    },
    
    Title(""),
    Title("========== 播报样式 =========="),
    
    {
        name = "announce_text",
        label = "公告文字",
        hover = "选择食谱公告的标题文字",
        options = {
            {description = "今日推荐", data = "今日推荐"},
            {description = "每日特餐", data = "每日特餐"},
            {description = "今日菜单", data = "今日菜单"},
            {description = "厨师推荐", data = "厨师推荐"},
        },
        default = "今日推荐",
    },
    
    Title(""),
    Title("========== 额外效果 =========="),
    
    {
        name = "extra_buff",
        label = "额外Buff",
        hover = "食用今日食谱获得的额外增益效果",
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
        hover = "额外Buff效果的持续时间（秒）",
        options = {
            {description = "30秒", data = 30},
            {description = "60秒", data = 60},
            {description = "120秒", data = 120},
            {description = "180秒", data = 180},
            {description = "300秒", data = 300},
        },
        default = 60,
    },
    
    Title(""),
    Title("========== 模组信息 =========="),
    Title("版本: "..MOD_VERSION.." | 支持MOD食谱"),
    Title("加成: 生命/饥饿/理智"),
    Title("Buff: 加速/发光/吸血"),
    Title("作者：橙小幸"),
    Title("Q群:1042944194 欢迎联机交流。"),
    Title("感谢您的大力支持！")
}

local MOD_VERSION = "1.2.0"

local function GetLanguage()
    return locale ~= nil and locale or "zh"
end

local is_chinese = GetLanguage():find("zh") ~= nil

name = is_chinese and "每日食谱" or "Daily Recipe"
description = is_chinese and [[
每天白天发布每日食谱，今天要吃什么？

版本: ]]..MOD_VERSION..[[

选中这些食谱会有额外加成
支持原版和MOD食谱
可自定义加成倍数和额外Buff
推荐开荒使用
]] or [[
Daily recipe announcements during daytime. What to eat today?

Version: ]]..MOD_VERSION..[[

Bonus effects for consuming recommended recipes
Supports vanilla and modded recipes
Customizable bonus multipliers and extra buffs
Recommended for early game
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

local config_labels = {
    basic_settings = is_chinese and "========== 基础设置 ==========" or "========== Basic Settings ==========",
    recipe_count = is_chinese and "每日食谱数量" or "Daily Recipe Count",
    recipe_count_hover = is_chinese and "每天推荐的食谱数量" or "Number of recipes recommended per day",
    recipes = function(n) return is_chinese and n.."个" or n.." recipes" end,
    
    bonus_multiplier = is_chinese and "加成倍数" or "Bonus Multiplier",
    bonus_multiplier_hover = is_chinese and "食用今日食谱的属性加成倍数" or "Attribute bonus multiplier for consuming daily recipes",
    multiplier = function(n) return is_chinese and n.."倍" or n.."x" end,
    
    broadcast_style = is_chinese and "========== 播报样式 ==========" or "========== Broadcast Style ==========",
    language = is_chinese and "语言" or "Language",
    language_hover = is_chinese and "选择公告播报的语言" or "Select announcement language",
    chinese = is_chinese and "中文" or "Chinese",
    english = is_chinese and "English" or "English",
    
    announce_text = is_chinese and "公告文字" or "Announcement Text",
    announce_text_hover = is_chinese and "选择食谱公告的标题文字" or "Select announcement title text",
    today_special = is_chinese and "今日推荐" or "Today's Special",
    daily_menu = is_chinese and "每日特餐" or "Daily Menu",
    today_menu = is_chinese and "今日菜单" or "Today's Menu",
    chef_choice = is_chinese and "厨师推荐" or "Chef's Choice",
    
    extra_effects = is_chinese and "========== 额外效果 ==========" or "========== Extra Effects ==========",
    extra_buff = is_chinese and "额外Buff" or "Extra Buff",
    extra_buff_hover = is_chinese and "食用今日食谱获得的额外增益效果" or "Extra buff effect from consuming daily recipes",
    buff_none = is_chinese and "无" or "None",
    buff_speed = is_chinese and "加速" or "Speed",
    buff_light = is_chinese and "发光" or "Light",
    buff_lifesteal = is_chinese and "吸血" or "Lifesteal",
    
    buff_duration = is_chinese and "Buff持续时间" or "Buff Duration",
    buff_duration_hover = is_chinese and "额外Buff效果的持续时间（秒）" or "Duration of extra buff effect (seconds)",
    seconds = function(n) return is_chinese and n.."秒" or n.."s" end,
    
    mod_info = is_chinese and "========== 模组信息 ==========" or "========== Mod Info ==========",
    version_info = is_chinese and "版本: "..MOD_VERSION.." | 支持MOD食谱" or "Version: "..MOD_VERSION.." | Supports Mod Recipes",
    bonus_info = is_chinese and "加成: 生命/饥饿/理智" or "Bonus: Health/Hunger/Sanity",
    buff_info = is_chinese and "Buff: 加速/发光/吸血" or "Buff: Speed/Light/Lifesteal",
    author_info = is_chinese and "作者：橙小幸" or "Author: Orange Xiaoxing",
    qq_group = is_chinese and "Q群:1042944194 欢迎联机交流。" or "QQ Group: 1042944194",
    thanks = is_chinese and "感谢您的大力支持！" or "Thank you for your support!",
}

configuration_options = {
    Title(config_labels.basic_settings),
    
    {
        name = "recipe_count",
        label = config_labels.recipe_count,
        hover = config_labels.recipe_count_hover,
        options = {
            {description = config_labels.recipes(1), data = 1},
            {description = config_labels.recipes(2), data = 2},
            {description = config_labels.recipes(3), data = 3},
            {description = config_labels.recipes(4), data = 4},
            {description = config_labels.recipes(5), data = 5},
        },
        default = 3,
    },
    
    {
        name = "bonus_multiplier",
        label = config_labels.bonus_multiplier,
        hover = config_labels.bonus_multiplier_hover,
        options = {
            {description = config_labels.multiplier(1.2), data = 1.2},
            {description = config_labels.multiplier(1.5), data = 1.5},
            {description = config_labels.multiplier(2.0), data = 2.0},
            {description = config_labels.multiplier(2.5), data = 2.5},
            {description = config_labels.multiplier(3.0), data = 3.0},
        },
        default = 1.5,
    },
    
    Title(""),
    Title(config_labels.broadcast_style),
    
    {
        name = "language",
        label = config_labels.language,
        hover = config_labels.language_hover,
        options = {
            {description = config_labels.chinese, data = "chinese"},
            {description = config_labels.english, data = "english"},
        },
        default = "chinese",
    },
    
    {
        name = "announce_text",
        label = config_labels.announce_text,
        hover = config_labels.announce_text_hover,
        options = {
            {description = config_labels.today_special, data = "今日推荐"},
            {description = config_labels.daily_menu, data = "每日特餐"},
            {description = config_labels.today_menu, data = "今日菜单"},
            {description = config_labels.chef_choice, data = "厨师推荐"},
        },
        default = "今日推荐",
    },
    
    Title(""),
    Title(config_labels.extra_effects),
    
    {
        name = "extra_buff",
        label = config_labels.extra_buff,
        hover = config_labels.extra_buff_hover,
        options = {
            {description = config_labels.buff_none, data = "none"},
            {description = config_labels.buff_speed, data = "speed"},
            {description = config_labels.buff_light, data = "light"},
            {description = config_labels.buff_lifesteal, data = "lifesteal"},
        },
        default = "none",
    },
    
    {
        name = "buff_duration",
        label = config_labels.buff_duration,
        hover = config_labels.buff_duration_hover,
        options = {
            {description = config_labels.seconds(30), data = 30},
            {description = config_labels.seconds(60), data = 60},
            {description = config_labels.seconds(120), data = 120},
            {description = config_labels.seconds(180), data = 180},
            {description = config_labels.seconds(300), data = 300},
        },
        default = 60,
    },
    
    Title(""),
    Title(config_labels.mod_info),
    Title(config_labels.version_info),
    Title(config_labels.bonus_info),
    Title(config_labels.buff_info),
    Title(config_labels.author_info),
    Title(config_labels.qq_group),
    Title(config_labels.thanks)
}

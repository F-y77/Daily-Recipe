GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local RECIPE_COUNT = GetModConfigData("recipe_count") or 3
local BONUS_MULTIPLIER = GetModConfigData("bonus_multiplier") or 1.5
local LANGUAGE = GetModConfigData("language") or "chinese"
local ANNOUNCE_TEXT = GetModConfigData("announce_text") or "今日推荐"
local EXTRA_BUFF = GetModConfigData("extra_buff") or "none"
local BUFF_DURATION = GetModConfigData("buff_duration") or 60

local daily_recipes = {}
local last_day = -1

local ANNOUNCE_TEXT_EN = {
    ["今日推荐"] = "Today's Special",
    ["每日特餐"] = "Daily Menu",
    ["今日菜单"] = "Today's Menu",
    ["厨师推荐"] = "Chef's Choice",
}

local function GetAllFoodRecipes()
    local foods = {}
    for k, v in pairs(AllRecipes) do
        if v.product then
            local prefab = Prefabs[v.product]
            if prefab then
                local components = prefab.components or {}
                if components.edible or v.foodtype then
                    table.insert(foods, v.product)
                end
            end
        end
    end
    
    if #foods == 0 then
        foods = {
            "meatballs", "bonestew", "baconeggs", "butterflymuffin",
            "dragonpie", "fishsticks", "fishtacos", "frogglebunwich",
            "fruitmedley", "honeynuggets", "honeyham", "kabobs",
            "mandrakesoup", "mashedpotatoes", "monsterlasagna", "perogies",
            "powcake", "pumpkincookie", "ratatouille", "stuffedeggplant",
            "taffy", "turkeydinner", "unagi", "waffles", "wetgoop"
        }
    end
    
    return foods
end

local function SelectDailyRecipes()
    daily_recipes = {}
    local all_foods = GetAllFoodRecipes()
    
    if #all_foods > 0 then
        local count = math.min(RECIPE_COUNT, #all_foods)
        local available = {}
        for i = 1, #all_foods do
            table.insert(available, i)
        end
        
        for i = 1, count do
            if #available > 0 then
                local index = math.random(1, #available)
                table.insert(daily_recipes, all_foods[available[index]])
                table.remove(available, index)
            end
        end
    end
    
    return daily_recipes
end

local function AnnounceRecipes()
    local recipe_names = {}
    for _, food in ipairs(daily_recipes) do
        local name = STRINGS.NAMES[string.upper(food)] or food
        table.insert(recipe_names, name)
    end
    
    if LANGUAGE == "english" then
        TheNet:Announce("============== Daily Recipe ==============")
        TheWorld:DoTaskInTime(1, function()
            local announce_text_en = ANNOUNCE_TEXT_EN[ANNOUNCE_TEXT] or "Today's Special"
            TheNet:Announce("[" .. announce_text_en .. "] " .. table.concat(recipe_names, ", "))
        end)
        TheWorld:DoTaskInTime(2, function()
            TheNet:Announce("Consume for extra bonuses!")
        end)
        TheWorld:DoTaskInTime(3, function()
            TheNet:Announce("==========================================")
        end)
    else
        TheNet:Announce("============== 今日食谱 ==============")
        TheWorld:DoTaskInTime(1, function()
            TheNet:Announce("【" .. ANNOUNCE_TEXT .. "】" .. table.concat(recipe_names, "、"))
        end)
        TheWorld:DoTaskInTime(2, function()
            TheNet:Announce("食用可获得额外加成！")
        end)
        TheWorld:DoTaskInTime(3, function()
            TheNet:Announce("======================================")
        end)
    end
end

local function CheckDailyNews()
    if not TheWorld.ismastersim then return end
    
    local current_day = TheWorld.state.cycles
    if current_day ~= last_day and TheWorld.state.isday then
        last_day = current_day
        math.randomseed(current_day)
        SelectDailyRecipes()
        
        TheWorld:DoTaskInTime(3, function()
            AnnounceRecipes()
        end)
    end
end

local function ApplyExtraBuff(inst)
    if EXTRA_BUFF == "speed" then
        if inst.components.locomotor then
            local old_speed = inst.components.locomotor:GetExternalSpeedMultiplier()
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "daily_recipe_buff", 1.3)
            inst:DoTaskInTime(BUFF_DURATION, function()
                inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "daily_recipe_buff")
            end)
        end
    elseif EXTRA_BUFF == "light" then
        if not inst.components.lighttweener then
            inst:AddComponent("lighttweener")
        end
        local light = inst.entity:AddLight()
        light:SetFalloff(0.7)
        light:SetIntensity(0.5)
        light:SetRadius(3)
        light:SetColour(255/255, 255/255, 180/255)
        light:Enable(true)
        inst:DoTaskInTime(BUFF_DURATION, function()
            if light then
                light:Enable(false)
            end
        end)
    elseif EXTRA_BUFF == "lifesteal" then
        inst.daily_recipe_lifesteal = true
        inst:DoTaskInTime(BUFF_DURATION, function()
            inst.daily_recipe_lifesteal = false
        end)
    end
end

AddComponentPostInit("combat", function(self)
    local old_DoAttack = self.DoAttack
    
    self.DoAttack = function(self, target, ...)
        local result = old_DoAttack(self, target, ...)
        
        if self.inst.daily_recipe_lifesteal and target and target.components.health then
            local damage = self.defaultdamage or 0
            local heal = damage * 0.2
            if self.inst.components.health then
                self.inst.components.health:DoDelta(heal)
            end
        end
        
        return result
    end
end)

local function IsDailyRecipe(food_name)
    for _, v in ipairs(daily_recipes) do
        if v == food_name then
            return true
        end
    end
    return false
end

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end
    
    inst:DoPeriodicTask(30, CheckDailyNews)
    inst:DoTaskInTime(5, CheckDailyNews)
end)

AddComponentPostInit("eater", function(self)
    local old_eat = self.Eat
    
    self.Eat = function(self, food, ...)
        local result = old_eat(self, food, ...)
        
        if result and food and food.prefab then
            if IsDailyRecipe(food.prefab) then
                if self.inst.components.health then
                    local health_delta = food.components.edible.healthvalue * (BONUS_MULTIPLIER - 1)
                    self.inst.components.health:DoDelta(health_delta)
                end
                
                if self.inst.components.hunger then
                    local hunger_delta = food.components.edible.hungervalue * (BONUS_MULTIPLIER - 1)
                    self.inst.components.hunger:DoDelta(hunger_delta)
                end
                
                if self.inst.components.sanity then
                    local sanity_delta = food.components.edible.sanityvalue * (BONUS_MULTIPLIER - 1)
                    self.inst.components.sanity:DoDelta(sanity_delta)
                end
                
                ApplyExtraBuff(self.inst)
                
                if self.inst.components.talker then
                    if LANGUAGE == "english" then
                        self.inst.components.talker:Say("Daily Special!")
                    else
                        self.inst.components.talker:Say("今日特餐！")
                    end
                end
            end
        end
        
        return result
    end
end)

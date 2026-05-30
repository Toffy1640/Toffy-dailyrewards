local QBCore = nil
local usedCodes = {}
local usedCodesFile = "server/used_codes.json"


CreateThread(function()
    if Config.Framework == "qbcore" then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == "qbx" then
        
    else
        print("^1[toffy-dailyrewards] ERROR: Invalid framework configured in config/config.lua!^7")
    end
    

    LoadUsedCodes()
    

    RegisterAdminCommands()
end)


local function GetPlayer(src)
    if Config.Framework == "qbcore" then
        return QBCore.Functions.GetPlayer(src)
    elseif Config.Framework == "qbx" then
        return exports.qbx_core:GetPlayer(src)
    end
    return nil
end


local function Lang(key, ...)
    local lang = Config.Language or "tr"
    local str = Locales[lang] and Locales[lang][key] or key
    if ... then
        return string.format(str, ...)
    end
    return str
end

local function Notify(src, text, type, duration)
    duration = duration or 5000
    if Config.Framework == "qbcore" then
        TriggerClientEvent('QBCore:Notify', src, text, type, duration)
    elseif Config.Framework == "qbx" then
        exports.qbx_core:Notify(src, text, type, duration)
    end
end

local function AddMoney(src, cashType, amount)
    local player = GetPlayer(src)
    if not player then return false end
    
    if Config.Framework == "qbcore" then
        return player.Functions.AddMoney(cashType, amount, "toffy-dailyrewards")
    elseif Config.Framework == "qbx" then
        return player.Functions.AddMoney(cashType, amount, "toffy-dailyrewards")
    end
    return false
end

local function AddItem(src, item, amount)
    local player = GetPlayer(src)
    if not player then return false end
    
    if Config.Inventory == "ox" then
        return exports.ox_inventory:AddItem(src, item, amount)
    else
        -- Standard qb-inventory or fallback
        if player.Functions.AddItem(item, amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item] or {name = item, label = item}, 'add')
            return true
        end
    end
    return false
end


local function GetRewardsMetadata(src)
    local player = GetPlayer(src)
    if not player then return nil end
    
    local meta = nil
    if Config.Framework == "qbcore" then
        meta = player.PlayerData.metadata["dailyrewards"]
    elseif Config.Framework == "qbx" then
        meta = player.PlayerData.metadata["dailyrewards"]
    end
    

    if not meta or type(meta) ~= "table" then
        meta = {
            lastClaim = 0,
            streak = 0,
            isPremium = false,
            claimsNormal = {},
            claimsPremium = {}
        }
        player.Functions.SetMetaData("dailyrewards", meta)
    end
    
  
    if meta.lastClaim == nil then meta.lastClaim = 0 end
    if meta.streak == nil then meta.streak = 0 end
    if meta.isPremium == nil then meta.isPremium = false end
    

    if meta.claimsNormal == nil or type(meta.claimsNormal) ~= "table" then 
        meta.claimsNormal = {} 

        for i = 1, meta.streak do
            meta.claimsNormal[tostring(i)] = true
        end
    end
    
    if meta.claimsPremium == nil or type(meta.claimsPremium) ~= "table" then 
        meta.claimsPremium = {} 
       
        if meta.isPremium then
            for i = 1, meta.streak do
                meta.claimsPremium[tostring(i)] = true
            end
        end
    end
    
    return meta
end

local function SaveRewardsMetadata(src, data)
    local player = GetPlayer(src)
    if not player then return end
    player.Functions.SetMetaData("dailyrewards", data)
end


function LoadUsedCodes()
    local content = LoadResourceFile(GetCurrentResourceName(), usedCodesFile)
    if content then
        local data = json.decode(content)
        if data then
            usedCodes = data
            return
        end
    end
    usedCodes = {}
    SaveResourceFile(GetCurrentResourceName(), usedCodesFile, json.encode(usedCodes, { indent = true }), -1)
end

function SaveUsedCodes()
    SaveResourceFile(GetCurrentResourceName(), usedCodesFile, json.encode(usedCodes, { indent = true }), -1)
end

local function IsCodeRedeemed(citizenid, code)
    if not usedCodes[citizenid] then return false end
    return usedCodes[citizenid][code] == true
end

local function MarkCodeAsRedeemed(citizenid, code)
    if not usedCodes[citizenid] then
        usedCodes[citizenid] = {}
    end
    usedCodes[citizenid][code] = true
    SaveUsedCodes()
end



local function GetRewardStatusData(src)
    local player = GetPlayer(src)
    if not player then return nil end
    
    local meta = GetRewardsMetadata(src)
    if not meta then return nil end
    
    local now = os.time()
    local timePassed = now - meta.lastClaim
    local canClaim = false
    

    if meta.lastClaim == 0 or timePassed >= Config.Cooldown then
        canClaim = true
    end
    

    local currentDay = meta.streak + 1
    
   
    if meta.lastClaim > 0 and timePassed > Config.StreakExpiry then
        meta.streak = 0
        currentDay = 1
        meta.claimsNormal = {}
        meta.claimsPremium = {}
        SaveRewardsMetadata(src, meta)
    end
    

    if currentDay > 30 then
        meta.streak = 0
        currentDay = 1
        meta.claimsNormal = {}
        meta.claimsPremium = {}
        SaveRewardsMetadata(src, meta)
    end
    

    local charName = "Bilinmeyen Oyuncu"
    if player.PlayerData and player.PlayerData.charinfo then
        charName = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    end
    
    return {
        streak = meta.streak,
        lastClaim = meta.lastClaim,
        isPremium = meta.isPremium,
        canClaim = canClaim,
        currentDay = currentDay,
        timePassed = timePassed,
        cooldown = Config.Cooldown,
        nextClaimTime = meta.lastClaim + Config.Cooldown,
        playerName = charName,
        imagePath = Config.InventoryImagePath,
        defaultLang = Config.Language or "tr",
        claimsNormal = meta.claimsNormal,
        claimsPremium = meta.claimsPremium
    }
end

RegisterNetEvent('toffy_dailyrewards:server:getRewardsStatus', function()
    local src = source
    local status = GetRewardStatusData(src)
    if status then
        TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', src, status)
    end
end)


RegisterNetEvent('toffy_dailyrewards:server:claimReward', function(data)
    local src = source
    local player = GetPlayer(src)
    if not player then return end
    
    local status = GetRewardStatusData(src)
    if not status then return end
    
    local meta = GetRewardsMetadata(src)
    if not meta then return end
    

    if data and data.day then
        local claimDay = tonumber(data.day)
        
        if not status.isPremium then
            Notify(src, Lang("already_premium"), "error")
            return
        end
        
        if claimDay > status.streak then
            Notify(src, Lang("no_reward"), "error")
            return
        end
        
        if meta.claimsPremium[tostring(claimDay)] == true then
            Notify(src, "Bu premium ödülünü zaten almışsınız!", "error")
            return
        end
        
        local dayConfig = Config.Rewards[claimDay]
        if not dayConfig or not dayConfig.premium then
            Notify(src, Lang("no_reward"), "error")
            return
        end
        
        local reward = dayConfig.premium
        local success = false
        if reward.isCash then
            success = AddMoney(src, "cash", reward.amount)
        else
            success = AddItem(src, reward.item, reward.amount)
        end
        
        if not success then
            Notify(src, Lang("inv_full"), "error")
            return
        end
        

        meta.claimsPremium[tostring(claimDay)] = true
        SaveRewardsMetadata(src, meta)
        

        local newStatus = GetRewardStatusData(src)
        TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', src, newStatus)
        Notify(src, string.format("Kaçırdığın Gün %d PREMIUM ödülünü (%s x%d) başarıyla topladın!", claimDay, reward.label, reward.amount), "success", 6000)
        return
    end
    

    if not status.canClaim then
        local hoursLeft = math.ceil((status.nextClaimTime - os.time()) / 3600)
        Notify(src, Lang("cooldown_wait", hoursLeft), "error")
        return
    end
    
    local claimDay = status.currentDay
    local dayConfig = Config.Rewards[claimDay]
    
    if not dayConfig then
        Notify(src, Lang("config_error"), "error")
        return
    end
    

    local normalReward = dayConfig.normal
    local success = false
    if normalReward.isCash then
        success = AddMoney(src, "cash", normalReward.amount)
    else
        success = AddItem(src, normalReward.item, normalReward.amount)
    end
    
    if not success then
        Notify(src, Lang("inv_full"), "error")
        return
    end
    

    meta.claimsNormal[tostring(claimDay)] = true
    

    local isPremiumClaim = false
    if status.isPremium and dayConfig.premium then
        local premiumReward = dayConfig.premium
        local pSuccess = false
        if premiumReward.isCash then
            pSuccess = AddMoney(src, "cash", premiumReward.amount)
        else
            pSuccess = AddItem(src, premiumReward.item, premiumReward.amount)
        end
        
        if pSuccess then
            meta.claimsPremium[tostring(claimDay)] = true
            isPremiumClaim = true
        end
    end
    

    meta.streak = claimDay
    meta.lastClaim = os.time()
    SaveRewardsMetadata(src, meta)
    

    local newStatus = GetRewardStatusData(src)
    TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', src, newStatus)
    
    if isPremiumClaim then
        Notify(src, Lang("claim_premium", claimDay, dayConfig.premium.label, dayConfig.premium.amount), "success", 6000)
    else
        Notify(src, Lang("claim_normal", claimDay, normalReward.label, normalReward.amount), "success", 5000)
    end
end)


RegisterNetEvent('toffy_dailyrewards:server:redeemCode', function(code)
    local src = source
    local player = GetPlayer(src)
    if not player then return end
    
    local citizenid = player.PlayerData.citizenid
    if not code or code == "" then
        Notify(src, Lang("invalid_code"), "error")
        return
    end
    
    local cleanCode = string.upper(code)
    

    if not Config.RedeemCodes[cleanCode] then
        TriggerClientEvent('toffy_dailyrewards:client:redeemResult', src, false, Lang("invalid_code"))
        Notify(src, Lang("invalid_code"), "error")
        return
    end
    

    if IsCodeRedeemed(citizenid, cleanCode) then
        TriggerClientEvent('toffy_dailyrewards:client:redeemResult', src, false, Lang("already_redeemed"))
        Notify(src, Lang("already_redeemed"), "error")
        return
    end
    

    local meta = GetRewardsMetadata(src)
    if meta.isPremium then
        TriggerClientEvent('toffy_dailyrewards:client:redeemResult', src, false, Lang("already_premium"))
        Notify(src, Lang("already_premium"), "inform")
        return
    end
    
    meta.isPremium = true
    SaveRewardsMetadata(src, meta)
    

    MarkCodeAsRedeemed(citizenid, cleanCode)
    

    local newStatus = GetRewardStatusData(src)
    TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', src, newStatus)
    TriggerClientEvent('toffy_dailyrewards:client:redeemResult', src, true, Lang("redeem_success"))
    
    Notify(src, Lang("premium_info"), "success", 7000)
end)


local function IsAdmin(src)

    if IsPlayerAceAllowed(src, "admin") then
        return true
    end
    
    -- Check Qbox / QB-Core framework groups ('admin' or 'god')
    if Config.Framework == "qbcore" then
        if QBCore and QBCore.Functions and QBCore.Functions.HasPermission then
            if QBCore.Functions.HasPermission(src, "admin") or QBCore.Functions.HasPermission(src, "god") then
                return true
            end
        end
    elseif Config.Framework == "qbx" then
        if exports.qbx_core:HasPermission(src, 'admin') or exports.qbx_core:HasPermission(src, 'god') then
            return true
        end
    end
    

    if IsPlayerAceAllowed(src, "command") then
        return true
    end

    return false
end


function RegisterAdminCommands()

    RegisterCommand("resetdaily", function(source, args, rawCommand)
        local src = source
        if src > 0 and not IsAdmin(src) then
            Notify(src, "Bu komutu kullanmak için yetkiniz yok!", "error")
            return
        end
        
        local targetId = src
        if args[1] and tonumber(args[1]) then
            targetId = tonumber(args[1])
        end
        
        local player = GetPlayer(targetId)
        if not player then
            if src > 0 then Notify(src, "Geçersiz oyuncu ID'si!", "error") end
            return
        end
        
        local meta = GetRewardsMetadata(targetId)
        if meta then
            meta.lastClaim = 0
            SaveRewardsMetadata(targetId, meta)
            
            local newStatus = GetRewardStatusData(targetId)
            TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', targetId, newStatus)
            
            if src > 0 then
                Notify(src, string.format("%s için günlük ödül süresi sıfırlandı!", GetPlayerName(targetId)), "success")
            end
        end
    end, false)

    -- Set Current Reward Day
    RegisterCommand("setday", function(source, args, rawCommand)
        local src = source
        if src > 0 and not IsAdmin(src) then
            Notify(src, "Bu komutu kullanmak için yetkiniz yok!", "error")
            return
        end
        
        local dayNum = tonumber(args[1])
        if not dayNum or dayNum < 1 or dayNum > 30 then
            if src > 0 then Notify(src, "Geçersiz gün! 1 ile 30 arasında bir gün girmelisiniz. Örn: /setday 5", "error") end
            return
        end
        
        local targetId = src
        if args[2] and tonumber(args[2]) then
            targetId = tonumber(args[2])
        end
        
        local player = GetPlayer(targetId)
        if not player then
            if src > 0 then Notify(src, "Geçersiz oyuncu ID'si!", "error") end
            return
        end
        
        local meta = GetRewardsMetadata(targetId)
        if meta then
            meta.streak = dayNum - 1
            meta.lastClaim = 0
            

            meta.claimsNormal = {}
            meta.claimsPremium = {}
            for i = 1, dayNum - 1 do
                meta.claimsNormal[tostring(i)] = true
                if meta.isPremium then
                    meta.claimsPremium[tostring(i)] = true
                end
            end
            
            SaveRewardsMetadata(targetId, meta)
            
            local newStatus = GetRewardStatusData(targetId)
            TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', targetId, newStatus)
            
            if src > 0 then
                Notify(src, string.format("%s için gün %d olarak ayarlandı!", GetPlayerName(targetId), dayNum), "success")
            end
        end
    end, false)


    RegisterCommand("resetpremium", function(source, args, rawCommand)
        local src = source
        if src > 0 and not IsAdmin(src) then
            Notify(src, "Bu komutu kullanmak için yetkiniz yok!", "error")
            return
        end
        
        local targetId = src
        if args[1] and tonumber(args[1]) then
            targetId = tonumber(args[1])
        end
        
        local player = GetPlayer(targetId)
        if not player then
            if src > 0 then Notify(src, "Geçersiz oyuncu ID'si!", "error") end
            return
        end
        
        local meta = GetRewardsMetadata(targetId)
        if meta then
            meta.isPremium = false
            meta.claimsPremium = {}
            SaveRewardsMetadata(targetId, meta)
            

            local citizenid = player.PlayerData.citizenid
            if usedCodes[citizenid] then
                usedCodes[citizenid] = nil
                SaveUsedCodes()
            end
            
            local newStatus = GetRewardStatusData(targetId)
            TriggerClientEvent('toffy_dailyrewards:client:sendRewardsStatus', targetId, newStatus)
            
            if src > 0 then
                Notify(src, string.format("%s için premium üyeliği sıfırlandı!", GetPlayerName(targetId)), "success")
            end
        end
    end, false)
end

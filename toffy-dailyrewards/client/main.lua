local showMenu = false


local function ToggleNUI(state)
    showMenu = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = "toggleMenu",
        status = state
    })
    
    if state then
       
        TriggerServerEvent('toffy_dailyrewards:server:getRewardsStatus')
    end
end


RegisterCommand(Config.OpenCommand, function()
    ToggleNUI(not showMenu)
end, false)


if Config.OpenKey then
    RegisterKeyMapping(Config.OpenCommand, 'Open Daily Rewards Menu', 'keyboard', Config.OpenKey)
end


RegisterNUICallback('close', function(data, cb)
    ToggleNUI(false)
    cb('ok')
end)

RegisterNUICallback('claimReward', function(data, cb)
    TriggerServerEvent('toffy_dailyrewards:server:claimReward', data)
    cb('ok')
end)

RegisterNUICallback('redeemCode', function(data, cb)
    if data and data.code then
        TriggerServerEvent('toffy_dailyrewards:server:redeemCode', data.code)
    end
    cb('ok')
end)


RegisterNetEvent('toffy_dailyrewards:client:sendRewardsStatus', function(status)
    SendNUIMessage({
        action = "updateStatus",
        status = status,
        rewardsConfig = Config.Rewards,
        locales = Locales,
        theme = Config.Theme  -- Theme colors from config
    })
end)

RegisterNetEvent('toffy_dailyrewards:client:redeemResult', function(success, message)
    SendNUIMessage({
        action = "redeemResult",
        success = success,
        message = message
    })
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if showMenu then
            ToggleNUI(false)
        end
    end
end)

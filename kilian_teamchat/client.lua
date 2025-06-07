ESX = exports['es_extended']:getSharedObject()

local playerGroup = ""

-- When the player spawns, request their permission group from the server
AddEventHandler('playerSpawned', function()
    TriggerServerEvent("kilian_teamchat:getGroup")
end)

-- Receive and store the group from the server
RegisterNetEvent("kilian_teamchat:setGroup")
AddEventHandler("kilian_teamchat:setGroup", function(group)
    playerGroup = group
end)

-- Listen for new team chat messages from the server
RegisterNetEvent("kilian_teamchat:notify")
AddEventHandler("kilian_teamchat:notify", function(message, steamName, playerId)
    -- Only show message if player is part of allowed staff groups
    if playerGroup == "leitung" or playerGroup == "suadmin" or playerGroup == "admin" or playerGroup == "dev" or playerGroup == "lead" or playerGroup == "mod" then
        -- Display notification with Steam name and player ID
        TriggerEvent("notifications", "#85deff", "Servername - kilian_teamchat", steamName .. " [" .. playerId .. "]: " .. message, 12000)
    end
end)

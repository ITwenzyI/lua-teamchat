ESX = exports['es_extended']:getSharedObject()

-- Your Discord webhook URL
local discordWebhook = "https://discord.com/api/webhooks/"

-- Register /tc command (Team Chat)
RegisterCommand("tc", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Permission check based on ESX group
    if xPlayer.getGroup() == "leitung" or xPlayer.getGroup() == "suadmin" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "dev" or xPlayer.getGroup() == "lead" or xPlayer.getGroup() == "mod" then
        local message = table.concat(args, " ")
        local steamName = GetPlayerName(source)
        local playerId = source
        local group = xPlayer.getGroup()
        local time = os.date("%d.%m.%Y - %H:%M:%S")

        -- Send message to all team members
        TriggerClientEvent("kilian_teamchat:notify", -1, message, steamName, playerId)

        -- Log message to Discord
        local discordMessage = {
            embeds = {{
                title = "💬 New kilian_teamchat Message",
                color = 16753920,
                fields = {
                    { name = "👤 Steam Name", value = steamName, inline = true },
                    { name = "🛡️ Group", value = group, inline = true },
                    { name = "🕒 Time", value = time, inline = true },
                    { name = "✉️ Message", value = "```" .. message .. "```", inline = false }
                },
                footer = {
                    text = "kilian_teamchat Logger",
                },
            }}
        }

        PerformHttpRequest(discordWebhook, function(err, text, headers) end, "POST", json.encode(discordMessage), { ["Content-Type"] = "application/json" })

    else
        TriggerClientEvent('esx:showNotification', source, "❌ You do not have permission to use this command.")
    end
end, false)

-- Send group information to client
RegisterNetEvent("kilian_teamchat:getGroup")
AddEventHandler("kilian_teamchat:getGroup", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("kilian_teamchat:setGroup", source, xPlayer.getGroup())
end)

local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem(Config.Item, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		TriggerClientEvent('rz-dart:start', source)
    end
end)

QBCore.Functions.CreateCallback('rz-dart:textname', function(playerId, data) -- super
    local Player = QBCore.Functions.GetPlayer(playerId)
    
    data({
        first = Player.PlayerData.charinfo.firstname,
        last = Player.PlayerData.charinfo.lastname
    })
end)

RegisterServerEvent('rz-dart:text')
AddEventHandler('rz-dart:text', function(text, name)
    TriggerClientEvent('rz-dart:text', -1, text, source, name)
end)
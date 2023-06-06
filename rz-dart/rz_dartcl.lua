local QBCore = exports['qb-core']:GetCoreObject()
local pedDisplaying = {}

RegisterNetEvent('rz-dart', function(source, args)
    local maxnumber = 1
    local randomnumber = 1

    maxnumber = Config.MaxNumber
    randomnumber = math.random(1, maxnumber)
    local text = Config.Langs[Config.Lang].numberhit ..randomnumber..""

    QBCore.Functions.Progressbar("dart", Config.Langs[Config.Lang].dartready, Config.FirstProgressbar, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mini@darts',
        anim = 'throw_idle_a',
    }, {
        model = "prop_dart_1",
    }, {}, function()
        QBCore.Functions.Progressbar("dart2", Config.Langs[Config.Lang].dartready2, Config.SecondProgressbar, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mini@darts',
            anim = 'throw_underlay',
        }, {
            model = "prop_dart_1",
        }, {}, function() -- Done
            QBCore.Functions.TriggerCallback('rz-dart:textname', function(name)
                local name =  '' .. name.first ..' '..  name.last .. ''
                TriggerServerEvent('rz-dart:text', text, name)
            end)
            ClearPedTasks(PlayerPedId())
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
        end)
    end, function()
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('rz-dart:start', function(source, args)
    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), Config.PropDistance, GetHashKey("prop_dart_bd_cab_01", "prop_dart_bd_01"))
    if DoesEntityExist(obj) then
        TriggerEvent('rz-dart')
    else
        QBCore.Functions.Notify(Config.Langs[Config.Lang].darterror, "primary")
    end
end)

RegisterNetEvent('rz-dart:text')
AddEventHandler('rz-dart:text', function(text, serverId, name)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        DisplayDart(ped, text, name)
    end
end)

function DisplayDart(ped, text, name)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= Config.Distance then
        if dist <= Config.Distance then
            if Config.Chat then
                TriggerEvent('chat:addMessage', {
                    color = {0, 0, 0, 0.8},
                    multiline = true,
                    args = {name, text}
                })
            end
        end

        if Config.DrawText then

            pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

            -- Timer
            local display = true

            Citizen.CreateThread(function()
                Wait(7000)
                display = false
            end)

            -- Display
            local offset = pedDisplaying[ped] * 0.1
            while display do
                if HasEntityClearLosToEntity(playerPed, ped, 17) then
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    z = z + offset
                    DrawText3D(vector3(x, y, z -0.08), ''..text..'')

                end
                Wait(0)
            end

            pedDisplaying[ped] = pedDisplaying[ped] - 1
        end
    end
end

function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(0, 0, 0, 0.8)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 255, 218, 217, 150)
    ClearDrawOrigin()
end
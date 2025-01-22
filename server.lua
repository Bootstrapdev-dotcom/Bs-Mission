-- server.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Server:AddItem')
AddEventHandler('QBCore:Server:AddItem', function(item, count)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, count)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)

RegisterNetEvent('QBCore:Server:AddMoney')
AddEventHandler('QBCore:Server:AddMoney', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney(type, amount)
end)

RegisterNetEvent('QBCore:Server:RemoveMoney')
AddEventHandler('QBCore:Server:RemoveMoney', function(type, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney(type, amount)
end)

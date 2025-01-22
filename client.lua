local QBCore = exports['qb-core']:GetCoreObject()
local missionGuards = {}
local playerPed = GetPlayerPed(-1)
local playerRelGroup = GetPedRelationshipGroupHash(playerPed)
local allGuardsDead = false
local jobInProgress = false
local guardsLooted = 0
local notifiedAllGuardsDead = false
local spawnedVehicle = nil

CreateThread(function()
    local pedModel = Config.JobPedModel
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    local jobPed = CreatePed(4, pedModel, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, Config.PedLocation.w, false, true)
    SetEntityInvincible(jobPed, true)
    SetBlockingOfNonTemporaryEvents(jobPed, true)
    
    exports['qb-target']:AddTargetEntity(jobPed, {
        options = {
            {
                type = "client",
                event = "startJob",
                icon = "fas fa-briefcase",
                label = "Start Job",
                canInteract = function()
                    return not jobInProgress
                end,
            },
            {
                type = "client",
                event = "stopJob",
                icon = "fas fa-times",
                label = "Stop Job (2500 Bank)",
                canInteract = function()
                    return jobInProgress
                end,
            },
            {
                type = "client",
                event = "spawnCar",
                icon = "fas fa-car",
                label = "Spawn Glendale (1000 Bank)",
                canInteract = function()
                    return jobInProgress and not spawnedVehicle
                end,
            },
        },
        distance = 2.5,
    })
end)

RegisterNetEvent('startJob')
AddEventHandler('startJob', function()
    QBCore.Functions.Notify("Job started!", "success")
    SetNewWaypoint(Config.Waypoint1.x, Config.Waypoint1.y)
    jobInProgress = true
    allGuardsDead = false
    guardsLooted = 0
    notifiedAllGuardsDead = false
    missionGuards = {} -- Reset mission guards

    CreateThread(function()
        local guardModel = Config.GuardModel
        RequestModel(guardModel)
        while not HasModelLoaded(guardModel) do
            Wait(1)
        end
        local guardRelGroup = AddRelationshipGroup("MissionGuards")
        SetRelationshipBetweenGroups(0, guardRelGroup, guardRelGroup) -- Neutral to each other
        
        for _, loc in ipairs(Config.GuardLocations) do
            local guard = CreatePed(4, guardModel, loc.x, loc.y, loc.z, loc.w, true, true)
            table.insert(missionGuards, guard)
            GiveWeaponToPed(guard, Config.GuardWeapon, 250, false, true)
            SetPedArmour(guard, Config.GuardArmour)
            SetEntityHealth(guard, Config.GuardHealth)

            -- Set relationships and combat behavior
            SetPedRelationshipGroupHash(guard, guardRelGroup)
            SetRelationshipBetweenGroups(5, guardRelGroup, playerRelGroup) -- Hate relationship
            
            -- Make guards aggressive
            SetPedCombatAttributes(guard, 46, true) -- Always fight to the death
            SetPedCombatAttributes(guard, 0, true) -- Can use cover
            SetPedCombatAttributes(guard, 5, true) -- Can switch to weapon
            SetPedCombatMovement(guard, 2) -- Offensive
            SetPedCombatRange(guard, 2) -- Medium range
            SetPedAlertness(guard, 3) -- Maximum alertness
            SetPedSeeingRange(guard, 100.0) -- Seeing range
            TaskCombatPed(guard, playerPed, 0, 16) -- Attack player
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(1000)
        if jobInProgress then
            allGuardsDead = true
            for _, guard in ipairs(missionGuards) do
                if not IsPedDeadOrDying(guard, true) then
                    allGuardsDead = false
                    break
                end
            end
            if allGuardsDead and not notifiedAllGuardsDead then
                QBCore.Functions.Notify("All guards are dead! You can now loot the guards.", "success")
                notifiedAllGuardsDead = true
                
                -- Add qb-target options for looting dead guards
                for _, guard in ipairs(missionGuards) do
                    exports['qb-target']:AddTargetEntity(guard, {
                        options = {
                            {
                                type = "client",
                                event = "lootGuard",
                                icon = "fas fa-box",
                                label = "Loot Guard",
                            },
                        },
                        distance = 2.5,
                    })
                end
            end
        end
    end
end)

RegisterNetEvent('stopJob')
AddEventHandler('stopJob', function()
    local player = QBCore.Functions.GetPlayerData()
    if player.money['bank'] >= 2500 then
        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', 2500)
        jobInProgress = false
        allGuardsDead = false
        QBCore.Functions.Notify("Job stopped. 2500 Bank deducted.", "error")
        
        -- Remove guards if any are spawned
        for _, guard in ipairs(missionGuards) do
            DeleteEntity(guard)
        end
        missionGuards = {}

        -- Remove spawned vehicle
        if spawnedVehicle then
            DeleteEntity(spawnedVehicle)
            spawnedVehicle = nil
        end
    else
        QBCore.Functions.Notify("Not enough bank money to stop the job!", "error")
    end
end)

RegisterNetEvent('spawnCar')
AddEventHandler('spawnCar', function()
    local player = QBCore.Functions.GetPlayerData()
    if player.money['bank'] >= 1000 then
        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', 1000)
        QBCore.Functions.Notify("Car spawned. 1000 Bank deducted.", "success")
        
        -- Spawn the vehicle
        local vehicleModel = `glendale`
        RequestModel(vehicleModel)
        while not HasModelLoaded(vehicleModel) do
            Wait(1)
        end
        local spawnCoords = Config.VehicleSpawnLocation
        spawnedVehicle = CreateVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
        SetPedIntoVehicle(playerPed, spawnedVehicle, -1)

        -- Give the player keys to the vehicle
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(spawnedVehicle))
    else
        QBCore.Functions.Notify("Not enough bank money to spawn the car!", "error")
    end
end)

RegisterNetEvent('lootGuard')
AddEventHandler('lootGuard', function(data)
    if not allGuardsDead then
        QBCore.Functions.Notify("You can loot the guards only after all of them are dead!", "error")
        return
    end

    local ped = data.entity
    local isMissionGuard = false
    for index, guard in ipairs(missionGuards) do
        if ped == guard then
            isMissionGuard = true
            table.remove(missionGuards, index) -- Remove from missionGuards table
            break
        end
    end

    if isMissionGuard then
        -- Guaranteed item
        TriggerServerEvent('QBCore:Server:AddItem', Config.GuaranteedItem, Config.GuaranteedItemCount)
        QBCore.Functions.Notify("You received a guaranteed item!", "success")

        -- Chance-based item
        local rewardChance = math.random(1, 100)
        if rewardChance <= Config.RewardChance then
            TriggerServerEvent('QBCore:Server:AddItem', Config.RewardItem, 1)
            QBCore.Functions.Notify("You received an additional item!", "success")
        else
            QBCore.Functions.Notify("No additional items found.", "error")
        end

        -- Remove the looted guard
        DeleteEntity(ped)
        guardsLooted = guardsLooted + 1

        -- Check if all guards have been looted
        if guardsLooted == #Config.GuardLocations then
            QBCore.Functions.Notify("All guards looted! Proceed to the final waypoint for payout.", "success")
            SetNewWaypoint(Config.SecondPedLocation.x, Config.SecondPedLocation.y)
        end
    else
        QBCore.Functions.Notify("You can't loot this guard.", "error")
    end
end)

RegisterNetEvent('completeJob')
AddEventHandler('completeJob', function()
    if allGuardsDead and jobInProgress then
        QBCore.Functions.Notify("Job completed! Collect your payout.", "success")
        SetNewWaypoint(Config.SecondPedLocation.x, Config.SecondPedLocation.y)
        jobInProgress = false

        -- Remove spawned vehicle
        if spawnedVehicle then
            DeleteEntity(spawnedVehicle)
            spawnedVehicle = nil
        end
    else
        QBCore.Functions.Notify("Complete the job first!", "error")
    end
end)
CreateThread(function()
    local pedModel = Config.JobPedModel
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    local finishPed = CreatePed(4, pedModel, Config.SecondPedLocation.x, Config.SecondPedLocation.y, Config.SecondPedLocation.z, Config.SecondPedLocation.w, false, true)
    SetEntityInvincible(finishPed, true)
    SetBlockingOfNonTemporaryEvents(finishPed, true)
    
    exports['qb-target']:AddTargetEntity(finishPed, {
        options = {
            {
                type = "client",
                event = "collectPayout",
                icon = "fas fa-dollar-sign",
                label = "Collect Payout",
            },
        },
        distance = 2.5,
    })
end)

RegisterNetEvent('collectPayout')
AddEventHandler('collectPayout', function()
    if allGuardsDead then
        TriggerServerEvent('QBCore:Server:AddMoney', 'cash', Config.Payout)
        QBCore.Functions.Notify("You received your payout!", "success")
        allGuardsDead = false

        -- Remove spawned vehicle
        if spawnedVehicle then
            DeleteEntity(spawnedVehicle)
            spawnedVehicle = nil
        end
    else
        QBCore.Functions.Notify("Complete the job first!", "error")
    end
end)
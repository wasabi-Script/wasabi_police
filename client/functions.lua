-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

createBlip = function(coords, sprite, color, text, scale, flash)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName(text.blip)
	EndTextCommandSetBlipName(text.blip)
    if flash then
		SetBlipFlashes(blip, true)
	end
end

local firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

openOutfits = function(station)
	local data = Config.Locations[station].cloakroom.uniforms
	local Options = {
		{
			title = Strings.civilian_wear,
			description = '',
			arrow = false,
			event = 'wasabi_police:changeClothes',
			args = 'civ_wear'
		}
	}
	for i=1, #data do
		Options[#Options + 1] = {
			title = data[i].label,
			description = '',
			arrow = false,
			event = 'wasabi_police:changeClothes',
			args = {male = data[i].male, female = data[i].female}
		}
	end
	lib.registerContext({
		id = 'pd_cloakroom',
		title = Strings.cloakroom,
		options = Options
	})
	lib.showContext('pd_cloakroom')
end

exports('openOutfits', openOutfits)

escortPlayer = function(targetId)
    local targetCuffed = lib.callback.await('wasabi_police:isCuffed', 100, targetId)
    if targetCuffed then
        TriggerServerEvent('wasabi_police:escortPlayer', targetId)
    else
        TriggerEvent('wasabi_police:notify', Strings.not_restrained, Strings.not_restrained_desc, 'error')
    end
end

exports('escortPlayer', escortPlayer)

handcuffPlayer = function(targetId)
    if not hasJob then return end
    if deathCheck(targetId) then
        TriggerEvent('wasabi_police:notify', Strings.unconcious, Strings.unconcious_desc, 'error')
    else
        TriggerServerEvent('wasabi_police:handcuffPlayer', targetId)
    end
end

local startCuffTimer = function()
    if Config.handcuff.timer and cuffTimer.active then
        ESX.ClearTimeout(cuffTimer.timer)
    end
    cuffTimer.active = true
    cuffTimer.timer = ESX.SetTimeout(Config.handcuff.timer,function()
        TriggerEvent('wasabi_police:uncuff')
    end)
end

handcuffed = function()
    isCuffed = true
    TriggerServerEvent('wasabi_police:setCuff', true)
    lib.requestAnimDict('mp_arresting', 100)
    TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(cache.ped, true)
    DisablePlayerFiring(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    SetPedCanPlayGestureAnims(cache.ped, false)
    FreezeEntityPosition(cache.ped, true)
    DisplayRadar(false)
    if Config.handcuff.timer then
        if cuffTimer.active then
            ESX.ClearTimeout(cuffTimer.timer)
        end
        startCuffTimer()
    end
end

uncuffed = function()
    if not isCuffed then return end
    isCuffed = false
    TriggerServerEvent('wasabi_police:setCuff', false)
    SetEnableHandcuffs(cache.ped, false)
    DisablePlayerFiring(cache.ped, false)
    SetPedCanPlayGestureAnims(cache.ped, true)
    FreezeEntityPosition(cache.ped, false)
    DisplayRadar(true)
    if Config.handcuff.timer and cuffTimer.active then
        ESX.ClearTimeout(cuffTimer.timer)
    end
    Wait(250) -- Only in fivem ;)
    ClearPedTasks(cache.ped)
    ClearPedSecondaryTask(cache.ped)
    if cuffProp and DoesEntityExist(cuffProp) then
        SetEntityAsMissionEntity(cuffProp, true, true)
        DetachEntity(cuffProp)
        DeleteObject(cuffProp)
        cuffProp = nil
    end
end

manageId = function(data)
    local targetId, license = data.targetId, data.license
    lib.registerContext({
        id = 'pd_manage_id',
        title = (license.label or firstToUpper(tostring(license.type))),
        options = {
            {
                title = Strings.go_back,
                description = '',
                icon = '',
                arrow = false,
                event = 'wasabi_police:checkId',
                args = targetId
            },
            {
                title = Strings.revoke_license,
                description = '',
                icon = '',
                arrow = false,
                event = 'wasabi_police:revokeLicense',
                args = {targetId = targetId, license = license.type}
            },

        }
    })
    lib.showContext('pd_manage_id')
end

openLicenseMenu = function(data)
    local targetId, licenses = data.targetId, data.licenses
    local Options = {
        {
            title = Strings.go_back,
            description = '',
            icon = '',
            arrow = false,
            event = 'wasabi_police:checkId',
            args = targetId
        }
    }
    for i=1, #licenses do
        Options[#Options + 1] = {
            title = (licenses[i].label or firstToUpper(tostring(licenses[i].type))),
            description = '',
            icon = '',
            arrow = true,
            event = 'wasabi_police:manageId',
            args = {targetId = targetId, license = licenses[i]}
        }
    end
    lib.registerContext({
        id = 'pd_license_check',
        title = Strings.licenses,
        options = Options
    })
    lib.showContext('pd_license_check')
end

checkPlayerId = function(targetId)
    ESX.TriggerServerCallback('wasabi_police:checkPlayerId', function(data) 
        local Options = {
            {
                title = Strings.go_back,
                description = '',
                icon = '',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            },
            {
                title = Strings.name,
                description = data.name,
                icon = 'id-badge',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            },
            {
                title = Strings.job,
                description = data.job,
                icon = 'briefcase',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            },
            {
                title = Strings.job_position,
                description = data.position,
                icon = 'briefcase',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            }
        }
        if Config.esxIdentity then
            Options[#Options + 1] = {
                title = Strings.dob,
                description = data.dob,
                icon = 'cake-candles',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            }
            Options[#Options + 1] = {
                title = Strings.sex,
                description = data.sex,
                icon = 'venus-mars',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            }
        end
        if data.drunk then
            Options[#Options + 1] = {
                title = Strings.bac,
                description = data.drunk,
                icon = 'champagne-glasses',
                arrow = false,
                event = 'wasabi_police:pdJobMenu', 
            }
        end
        if not data.licenses or #data.licenses < 1 then
            Options[#Options + 1] = {
                title = Strings.licenses,
                description = Strings.no_licenses,
                icon = 'id-card',
                arrow = true,
                event = 'wasabi_police:pdJobMenu',
            }
        else
            Options[#Options + 1] = {
                title = Strings.licenses,
                description = Strings.total_licenses..' '..#data.licenses,
                icon = 'id-card',
                arrow = true,
                event = 'wasabi_police:licenseMenu',
                args = {licenses = data.licenses, targetId = targetId}
            }
        end
        lib.registerContext({
            id = 'pd_id_check',
            title = Strings.id_result_menu,
            options = Options
        })
        lib.showContext('pd_id_check')
    end, targetId)
end

vehicleInfoMenu = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local data = ESX.Game.GetVehicleProperties(vehicle)
        local ownerData = lib.callback.await('wasabi_police:getVehicleOwner', 100, data.plate)
        local Options = {
            {
                title = Strings.go_back,
                description = '',
                arrow = false,
                event = 'wasabi_police:vehicleInteractions',
            },
            {
                title = Strings.plate,
                description = data.plate,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        }
        if ownerData then
            Options[#Options + 1] = {
                title = Strings.owner,
                description = ownerData,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        else
            Options[#Options + 1] = {
                title = Strings.possibly_stolen,
                description = Strings.possibly_stolen_desc,
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            }
        end
        lib.registerContext({
            id = 'pd_veh_info_menu',
            title = Strings.vehicle_interactions,
            options = Options,
        })
        lib.showContext('pd_veh_info_menu')
    end
end

lockpickVehicle = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local playerCoords = GetEntityCoords(cache.ped)
        local targetCoords = GetEntityCoords(vehicle)
        local dist = #(playerCoords - targetCoords)
        if dist < 2.5 then
            TaskTurnPedToFaceCoord(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, 2000)
            Wait(2000)
            if lib.progressCircle({
                duration = 7500,
                position = 'bottom',
                label = Strings.lockpick_progress,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    scenario = 'PROP_HUMAN_PARKING_METER',
                },
            }) then
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                TriggerEvent('wasabi_police:notify', Strings.lockpicked, Strings.lockpicked_desc, 'success')
            else
                TriggerEvent('wasabi_police:notify', Strings.cancelled, Strings.cancelled_desc, 'error')
            end
        else
            TriggerEvent('wasabi_police:notify', Strings.too_far, Strings.too_far_desc, 'error')
        end
    end
end

impoundVehicle = function(vehicle)
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.vehicle_not_found, Strings.vehicle_not_found_desc, 'error')
    else
        local playerCoords = GetEntityCoords(cache.ped)
        local targetCoords = GetEntityCoords(vehicle)
        local dist = #(playerCoords - targetCoords)
        if dist < 2.5 then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver == 0 then
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                TaskTurnPedToFaceCoord(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, 2000)
                Wait(2000)
                if lib.progressCircle({
                    duration = 7500,
                    position = 'bottom',
                    label = Strings.impounding_progress,
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                    anim = {
                        scenario = 'PROP_HUMAN_PARKING_METER',
                    },
                }) then
                    impoundSuccessful(vehicle)
                else
                    TriggerEvent('wasabi_police:notify', Strings.cancelled, Strings.cancelled_desc, 'error')
                end
            else
                TriggerEvent('wasabi_police:notify', Strings.driver_in_car, Strings.driver_in_car_desc, 'error')
            end
        else
            TriggerEvent('wasabi_police:notify', Strings.too_far, Strings.too_far_desc, 'error')
        end
    end
end

vehicleInteractionMenu = function()
    lib.registerContext({
        id = 'pd_veh_menu',
        title = Strings.vehicle_interactions,
        options = {
            {
                title = Strings.go_back,
                description = '',
                arrow = false,
                event = 'wasabi_police:pdJobMenu',
            },
            {
                title = Strings.vehicle_information,
                description = Strings.vehicle_information_desc,
                icon = 'magnifying-glass',
                arrow = false,
                event = 'wasabi_police:vehicleInfo',
            },
            {
                title = Strings.lockpick_vehicle,
                description = Strings.locakpick_vehicle_desc,
                icon = 'lock-open',
                arrow = false,
                event = 'wasabi_police:lockpickVehicle',
            },
            {
                title = Strings.impound_vehicle,
                description = Strings.impound_vehicle_desc,
                icon = 'reply',
                arrow = false,
                event = 'wasabi_police:impoundVehicle',
            },
            --

        }
    })
    lib.showContext('pd_veh_menu')
end

placeObjectsMenu = function()
    local options = {
        {
            title = Strings.go_back,
            description = '',
            arrow = false,
            event = 'wasabi_police:pdJobMenu',
        },
    }
    for i=1, #Config.Props do 
        local data = Config.Props[i]
        local add = true
        if (data.groups) then 
            local rank = data.groups[ESX.PlayerData.job.name]
            if not (rank and ESX.PlayerData.job.grade >= rank) then 
                add = false
            end
        end
        if (add) then 
            data.arrow = false
            data.event = "wasabi_police:spawnProp"
            data.args = i

            options[#options + 1] = data
        end
    end
    lib.registerContext({
        id = 'pd_object_menu',
        title = Strings.vehicle_interactions,
        options = options
    })
    lib.showContext('pd_object_menu')
end

armouryMenu = function(station)
    local data = Config.Locations[station].armoury
    local allow = false
    local aData
    if data.jobLock then
        if data.jobLock == ESX.PlayerData.job.name then
            allow = true
        end
    else
        allow = true
    end
    if allow then
        if ESX.PlayerData.job.grade > #data.weapons then
            aData = data.weapons[#data.weapons]
        elseif not data.weapons[ESX.PlayerData.job.grade] then
            print('[wasabi_police] : ARMORY NOT SET UP PROPERLY FOR GRADE: '..ESX.PlayerData.job.grade)
        else
            aData = data.weapons[ESX.PlayerData.job.grade]
        end
        local Options = {}
        for k,v in pairs(aData) do
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                arrow = false,
                event = 'wasabi_police:purchaseArmoury',
                args = { id = station, grade = ESX.PlayerData.job.grade, itemId = k, multiple = false }
            }
            if v.price then
                Options[#Options].description = Strings.currency..addCommas(v.price)
            end
            if v.multiple then
                Options[#Options].args.multiple = true
            end
        end
        lib.registerContext({
            id = 'pd_armoury',
            title = Strings.armoury_menu,
            options = Options
        })
        lib.showContext('pd_armoury')
    else
        TriggerEvent('wasabi_police:notify', Strings.no_permission, Strings.no_access_desc, 'error')
    end
end

openVehicleMenu = function(station)
    if not hasJob then return end
    local data
    local grade
    if ESX.PlayerData.job.grade > #Config.Locations[station].vehicles.options then
        grade = #Config.Locations[station].vehicles.options
        data = Config.Locations[station].vehicles.options[#Config.Locations[station].vehicles.options]
    elseif not Config.Locations[station].vehicles.options[ESX.PlayerData.job.grade] then
        print('[wasabi_police] : Police garage not set up properly for job grade: '..ESX.PlayerData.job.grade)
        return
    else
        grade = ESX.PlayerData.job.grade
        data = Config.Locations[station].vehicles.options[ESX.PlayerData.job.grade]
    end
    local Options = {}
    for k,v in pairs(data) do
        if v.category == 'land' then
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                icon = 'car',
                arrow = true,
                event = 'wasabi_police:spawnVehicle',
                args = { station = station, model = k, grade = grade }
            }
        elseif v.category == 'air' then
            Options[#Options + 1] = {
                title = v.label,
                description = '',
                icon = 'helicopter',
                arrow = true,
                event = 'wasabi_police:spawnVehicle',
                args = { station = station, model = k, grade = grade, category = v.category }
            }
        end
    end
    lib.registerContext({
        id = 'pd_garage_menu',
        title = Strings.police_garage,
        onExit = function()
            inMenu = false
        end,
        options = Options
    })
    lib.showContext('pd_garage_menu')
end

local lastTackle = 0
attemptTackle = function()
    if not IsPedSprinting(cache.ped) then return end
    local player, dist = ESX.Game.GetClosestPlayer()
    if dist ~= -1 and dist < 2.01 and not isBusy and not IsPedInAnyVehicle(cache.ped) and not IsPedInAnyVehicle(GetPlayerPed(player)) and GetGameTimer() - lastTackle > 7 * 1000 then
        if Config.tackle.policeOnly then
            if hasJob then
                lastTackle = GetGameTimer()
                TriggerServerEvent('wasabi_police:attemptTackle', GetPlayerServerId(player))
            end
        else
            lastTackle = GetGameTimer()
            TriggerServerEvent('wasabi_police:attemptTackle', GetPlayerServerId(player))
        end
    end
end

getTackled = function(targetId)
    isBusy = true
    local target = GetPlayerPed(GetPlayerFromServerId(targetId))
    lib.requestAnimDict('missmic2ig_11', 100)
    AttachEntityToEntity(cache.ped, target, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
    TaskPlayAnim(cache.ped, 'missmic2ig_11', 'mic_2_ig_11_intro_p_one', 8.0, -8.0, 3000, 0, 0, false, false, false)
    Wait(3000)
    DetachEntity(cache.ped, true, false)
    SetPedToRagdoll(cache.ped, 1000, 1000, 0, 0, 0, 0)
    isRagdoll = true
    Wait(3000)
    isRagdoll = false
    isBusy = false
    RemoveAnimDict('missmic2ig_11')
end

tacklePlayer = function()
    isBusy = true
    lib.requestAnimDict('missmic2ig_11', 100)
    TaskPlayAnim(cache.ped, 'missmic2ig_11', 'mic_2_ig_11_intro_goon', 8.0, -8.0, 3000, 0, 0, false, false, false)
    Wait(3000)
    isBusy = false
    RemoveAnimDict('missmic2ig_11')
end

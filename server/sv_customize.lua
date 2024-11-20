-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

--Custom ESX export? Edit here
ESX = exports["es_extended"]:getSharedObject()

-- Customize the way it pulls user identification info?
ESX.RegisterServerCallback('wasabi_police:checkPlayerId', function(source, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    local data = {
        name = xPlayer.getName(),
        job = xPlayer.job.label,
        position = xPlayer.job.grade_label,
    }
    if Config.esxIdentity then
        data.dob = xPlayer.get('dateofbirth')
        if xPlayer.get('sex') == 'm' then data.sex = 'Male' else data.sex = 'Female' end
    end
    TriggerEvent('esx_status:getStatus', targetId, 'drunk', function(status)
        if status then
            data.drunk = ESX.Math.Round(status.percent)
        end
    end)
    if Config.esxLicense then
        TriggerEvent('esx_license:getLicenses', targetId, function(licenses)
            data.licenses = licenses
            cb(data)
        end)
    else
        cb(data)
    end
end)
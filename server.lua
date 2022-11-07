-- Copyright 2022, The Illusion Squid, All rights reserved.
local Encryptions = {}
local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock())
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

RegisterCommand("speedtest", function(source, args, rawCommand)
    Encryptions[source] = randomString(16)
    TriggerClientEvent("tis-vehspeeds:client:DoSpeedTest", source, Encryptions[source], args[1])
    print("afioreoai")
end, true)

RegisterCommand("speedtestlist", function(source, args, rawCommand)
    Encryptions[source] = randomString(16)
    TriggerClientEvent("tis-vehspeeds:client:DoSpeedTestList", source, Encryptions[source])
end, true)

RegisterCommand("speedtarget", function(source, args, rawCommand)
    Encryptions[source] = randomString(16)
    TriggerClientEvent("tis-vehspeeds:client:DoSpeedTarget", source, Encryptions[source], args[1], tonumber(args[2]))
    print("afioreoai")
end, true)

RegisterServerEvent("tis-vehspeeds:server:SaveVehicleSpecs")
AddEventHandler("tis-vehspeeds:server:SaveVehicleSpecs", function (encrypt, data)
    if Encryptions[source] ~= encrypt then
        DropPlayer(source, "Kindly stop trying a cheap hack - Squid")
    end

    MySQL.Async.insert('INSERT INTO vehicle_specs (model_hash, model_name, model_class, version, zero_sixty, zero_hundered, quarter_mile, quarter_mile_speed, half_mile, half_mile_speed, mile, mile_speed, max_speed) VALUES (:model_hash, :model_name, :model_class, :version, :zero_sixty, :zero_hundered, :quarter_mile, :quarter_mile_speed, :half_mile, :half_mile_speed, :mile, :mile_speed, :max_speed) ON DUPLICATE KEY UPDATE model_name = :model_name, model_class = :model_class, version = :version, zero_sixty = :zero_sixty, zero_hundered = :zero_hundered, quarter_mile = :quarter_mile, quarter_mile_speed = :quarter_mile_speed, half_mile = :half_mile, half_mile_speed = :half_mile_speed, mile = :mile, mile_speed = :mile_speed, max_speed = :max_speed', {
        model_hash = data.model,
        model_name = data.model_name,
        model_class = data.model_class,
        version = Config.Version,
        zero_sixty = data.zero_sixty,
        zero_hundered = data.zero_hundered,
        quarter_mile = data.quarter_mile,
        quarter_mile_speed = data.quarter_mile_speed,
        half_mile = data.half_mile,
        half_mile_speed = data.half_mile_speed,
        mile = data.mile,
        mile_speed = data.mile_speed,
        max_speed = data.max_speed
    })
end)

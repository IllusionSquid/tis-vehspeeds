-- Copyright 2022, The Illusion Squid, All rights reserved.

-- "Constant" info
local vehicle = nil
local vehHash = nil
local topspeedGTA = nil
local isBike = nil

local InSpeedTest = false

local Tracks = {}

-- Performance locals
local floor = math.floor

local setConstants = function ()
    topspeedGTA = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    vehHash = GetEntityModel(vehicle)
end

local resetVehicle = function ()
    vehicle = nil
    topspeedGTA = nil
    vehHash = nil
    isBike = nil
end

-- Getting vehicle info
Citizen.CreateThread(function ()
    while true do
        local ped = PlayerPedId()
        local posibleVehicle = GetVehiclePedIsIn(ped, false)

        -- Check if the player is in a vehicle
        if posibleVehicle == vehicle then
            -- The player hasn't changed vehicle
        elseif posibleVehicle == 0 then
            -- The Player is on foot
            if vehicle ~= nil then
                -- Resetting the old vehicle
                resetVehicle()
            end
        else
            -- Check if the player is the driver
            if GetPedInVehicleSeat(posibleVehicle,-1) == ped then
                -- Apply only to cars and bikes
                local model = GetEntityModel(posibleVehicle)
                isBike = IsThisModelABike(model) -- This will later be used for key logic in going in reverse
                if IsThisModelACar(model) or IsThisModelAQuadbike(model) or isBike then
                    print(posibleVehicle)
                    vehicle = posibleVehicle
                    setConstants()
                    Citizen.Wait(400) -- No need to trigger this twice on accident
                end
            end
        end
        Citizen.Wait(100)
    end
end)

function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return floor((value * power) + 0.5) / (power)
	else
		return floor(value + 0.5)
	end
end

function ReqMod(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

local prepSpeedTest = function (model)
    TriggerEvent("QBCore:Command:DeleteVehicle")
    resetVehicle()
    TriggerEvent("QBCore:Command:SpawnVehicle", model)
    while vehicle == nil do
        Citizen.Wait(0)
    end
    
end

local createTrack = function ()
    ReqMod(Config.SpeedTest.TrackObject)
    for i = 0, 19, 1 do
        local track = CreateObject(Config.SpeedTest.TrackObject, Config.SpeedTest.TrackPos + vector3(0, i * 90, 0), true)
        -- SetEntityRotation(track, 0, 0, 45)
        table.insert(Tracks, track)
    end
end

local removeTrack = function ()
    for k, track in pairs(Tracks) do
        DeleteObject(track)
        Tracks[k] = nil
    end
end

function DoSpeedTest(encr)
    if vehicle ~= nil then
        SetEntityStartPos()

        local StartPos = GetEntityCoords(vehicle)
        local StartTime = GetNetworkTimeAccurate()

        InSpeedTest = true
        -- Press gas
        Citizen.CreateThread(function ()
            while InSpeedTest do
                SetControlNormal(0, 71, 1.0)
                Citizen.Wait(0)
            end
        end)

        -- Data gathering
        Citizen.CreateThread(function ()
            local data = {
                model = vehHash,
                model_name = GetDisplayNameFromVehicleModel(vehHash):lower(),
                model_class = GetVehicleClass(vehicle),
                zero_sixty = nil,
                zero_hundered = nil,
                quarter_mile = nil,
                quarter_mile_speed = nil,
                half_mile = nil,
                half_mile_speed = nil,
                max_speed = Round((topspeedGTA * 0.8), 2),

            }

            while InSpeedTest do
                local pos = GetEntityCoords(vehicle)
                local dist = GetDistanceBetweenCoords(pos, StartPos)
                local speed = GetEntitySpeed(vehicle) * 2.236936

                if data.zero_sixty == nil and speed >= 60 then
                    data.zero_sixty = (GetNetworkTimeAccurate() - StartTime) / 1000
                    print(string.format("0-60: %0.2f sec.", data.zero_sixty))
                end

                if data.zero_hundered == nil and speed >= 100 then
                    data.zero_hundered = (GetNetworkTimeAccurate() - StartTime) / 1000
                    print(string.format("0-100: %0.2f sec.", data.zero_hundered))
                end

                if data.quarter_mile == nil and dist >= 402.336 then
                    data.quarter_mile = (GetNetworkTimeAccurate() - StartTime) / 1000
                    data.quarter_mile_speed = Round(speed, 2)
                    print(string.format("1/4 Mile: %0.2f sec.\n1/4 Speed: %0.2f MPH", data.quarter_mile, data.quarter_mile_speed))
                end

                if data.half_mile == nil and dist >= 804.672 then
                    data.half_mile_speed = Round(speed, 2)
                    data.half_mile = (GetNetworkTimeAccurate() - StartTime) / 1000
                    print(string.format("1/2 Mile: %0.2f sec.\n1/2 Speed: %0.2f MPH", data.half_mile, data.half_mile_speed))

                end

                if dist >= 1609.344 then
                    data.mile_speed = Round(speed, 2)
                    data.mile = (GetNetworkTimeAccurate() - StartTime) / 1000
                    print(string.format("1 Mile: %0.2f sec.\n1 Speed: %0.2f MPH\nTheoratical Max Speed: %0.2f", data.mile, data.mile_speed, data.max_speed))

                    if encr ~= nil then
                        TriggerServerEvent("tis-vehspeeds:server:SaveVehicleSpecs", encr, data)
                    end

                    -- Stop the vehicle
                    FreezeEntityPosition(vehicle, true)
                    FreezeEntityPosition(vehicle, false)

                    -- Turn off speed test
                    InSpeedTest = false
                    return
                end
                Citizen.Wait(0)
            end
        end)
        print("Doing speedtest for "..GetDisplayNameFromVehicleModel(vehHash))
    else
        print("Must be in a proper vehicle")
    end
end

-- Calculate a new InitialDriveForce based on our last result and previous acceleration
function GetNewIDF(target, lastResult, currentAcceleration, previousAcceleration)
    if target - lastResult < -0.05 then -- Too slow
        print("too slow", lastResult, currentAcceleration, previousAcceleration)
        if previousAcceleration ~= nil then
            if previousAcceleration < currentAcceleration then
                return currentAcceleration + currentAcceleration - previousAcceleration
            else
                return currentAcceleration + (previousAcceleration - currentAcceleration) / 2
            end
        else
            return currentAcceleration * 2
        end
    elseif target - lastResult > 0.05 then -- Too fast
        print("too fast", lastResult, currentAcceleration, previousAcceleration)
        if previousAcceleration ~= nil then
            if previousAcceleration < currentAcceleration then
                return currentAcceleration - (currentAcceleration - previousAcceleration) / 2
            else
                local difference = (previousAcceleration - currentAcceleration)
                if difference <= 0 then
                    return currentAcceleration / 2
                else
                    return currentAcceleration - difference
                end
            end
        else
            return currentAcceleration / 2
        end
    else -- Within margin
        return currentAcceleration
    end
end

function SetEntityStartPos()
    SetEntityCoords(vehicle, Config.SpeedTest.TrackPos + vector3(0, 0, 105))
    SetEntityHeading(vehicle, 0)

    Citizen.Wait(1500) -- Needed for vehicle to land
end

function TargetIteration(target, lastResult, currentAcceleration, previousAcceleration)
    SetEntityStartPos()

    -- Set new IDF if this is not the first time
    if lastResult ~= nil then
        local newAcceleration = GetNewIDF(target, lastResult, currentAcceleration, previousAcceleration)
        if newAcceleration == currentAcceleration then
            print(string.format("0-60: %0.2f sec.", lastResult))
            return currentAcceleration
        end

        local engineup = GetVehicleMod(vehicle,11)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", newAcceleration)
        ModifyVehicleTopSpeed(vehicle, 1)
        SetVehicleMod(vehicle,11,engineup,false) -- Needed for changes to take affect

        previousAcceleration = currentAcceleration
        currentAcceleration = newAcceleration
    end

    print(currentAcceleration)

    -- local StartPos = GetEntityCoords(vehicle)
    local StartTime = GetNetworkTimeAccurate()

    local inIteration = true
    Citizen.CreateThread(function ()
        while inIteration do
            SetControlNormal(0, 71, 1.0)
            Citizen.Wait(0)
        end
    end)

    while inIteration do
        local speed = GetEntitySpeed(vehicle) * 2.236936

        if speed >= 60 then
            local result = (GetNetworkTimeAccurate() - StartTime) / 1000

            -- Stop the vehicle
            FreezeEntityPosition(vehicle, true)
            FreezeEntityPosition(vehicle, false)

            inIteration = false
            return TargetIteration(target, result, currentAcceleration, previousAcceleration)
        end
        Citizen.Wait(0)
    end
end

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTest")
AddEventHandler("tis-vehspeeds:client:DoSpeedTest", function (encr, model)
    createTrack()
    -- SetEntityCoords(GetPlayerPed(-1), Config.SpeedTest.TrackPos + vector3(0, 0, 100))
    prepSpeedTest(model)
    DoSpeedTest(encr)
    while InSpeedTest do
        Citizen.Wait(100)
    end
    removeTrack()
end)

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTarget")
AddEventHandler("tis-vehspeeds:client:DoSpeedTarget", function (encr, model, target)
    createTrack()
    -- SetEntityCoords(GetPlayerPed(-1), Config.SpeedTest.TrackPos + vector3(0, 0, 100))
    prepSpeedTest(model)
    print(target)

    local currentAcceleration = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    local newAcceleration = TargetIteration(target, nil, currentAcceleration, nil)
    print(newAcceleration)
    removeTrack()
end)

AddEventHandler("onResourceStop", function(r)
	if r == GetCurrentResourceName() then
        removeTrack()
	end
end)

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTestList")
AddEventHandler("tis-vehspeeds:client:DoSpeedTestList", function (encr)
    createTrack()
    for k, v in ipairs(Config.SpeedTest.Vehicles) do
        print(v)
        prepSpeedTest(v)
        DoSpeedTest(encr)
        while InSpeedTest do
            Citizen.Wait(100)
        end
    end

    removeTrack()
end)
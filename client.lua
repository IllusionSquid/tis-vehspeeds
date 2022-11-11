--[[
    tis-vehspeeds
    Copyright (C) 2022 IllusionSquid

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local Tracks = {}

-- Performance locals
local floor = math.floor

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
    -- resetVehicle()
    TriggerEvent("QBCore:Command:SpawnVehicle", model)
    local x = 0
    while GetVehiclePedIsIn(PlayerPedId(), false) == 0 do
        Citizen.Wait(100)
        x = x + 1
        if x > 200 then
            return 0
        end
    end
    return GetVehiclePedIsIn(PlayerPedId(), false)
end

local createTrack = function ()
    ReqMod(Config.SpeedTest.TrackObject)
    for i = 0, 19, 1 do
        local track = CreateObject(Config.SpeedTest.TrackObject, Config.SpeedTest.TrackPos + vector3(0, i * 90, 0), true)
        table.insert(Tracks, track)
    end
end

local removeTrack = function ()
    for k, track in pairs(Tracks) do
        DeleteObject(track)
        Tracks[k] = nil
    end
end

function SetEntityStartPos(vehicle)
    SetEntityCoords(vehicle, Config.SpeedTest.TrackPos + vector3(0, 0, 105))
    SetEntityHeading(vehicle, 0)

    Citizen.Wait(1500) -- Needed for vehicle to land
end

function DoSpeedTest(vehicle, encr)
    SetEntityStartPos(vehicle)
    local vehHash = GetEntityModel(vehicle)
    local StartPos = GetEntityCoords(vehicle)
    local StartTime = GetNetworkTimeAccurate()

    print("Doing speedtest for "..GetDisplayNameFromVehicleModel(vehHash))
    local inSpeedTest = true
    -- Press gas
    Citizen.CreateThread(function ()
        while inSpeedTest do
            SetControlNormal(0, 71, 1.0)
            Citizen.Wait(0)
        end
    end)

        -- Data gathering
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
        max_speed = Round((GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel") * 0.82), 2),

    }

    while inSpeedTest do
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
            inSpeedTest = false
            return data.zero_sixty
        end
        Citizen.Wait(0)
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
                if currentAcceleration - difference <= 0 then
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

function TargetIteration(vehicle, target, lastResult, currentAcceleration, previousAcceleration)
    SetEntityStartPos(vehicle)

    -- Set new IDF if this is not the first time
    if lastResult ~= nil then
        local newAcceleration = GetNewIDF(target, lastResult, currentAcceleration, previousAcceleration)
        if newAcceleration == currentAcceleration then
            print(string.format("0-60: %0.2f sec.", lastResult))
            return currentAcceleration
        end

        local engineup = GetVehicleMod(vehicle, 11)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", newAcceleration)
        ModifyVehicleTopSpeed(vehicle, 1)
        SetVehicleMod(vehicle, 11, engineup, false) -- Needed for changes to take affect

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
            return TargetIteration(vehicle, target, result, currentAcceleration, previousAcceleration)
        end
        Citizen.Wait(0)
    end
end

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTest")
AddEventHandler("tis-vehspeeds:client:DoSpeedTest", function (encr, model)
    local pos = GetEntityCoords(PlayerPedId())
    createTrack()
    local vehicle = prepSpeedTest(model)
    if vehicle == 0 then
        removeTrack()
        return
    end
    local result = DoSpeedTest(vehicle, encr)
    SetEntityCoords(vehicle, pos)
    removeTrack()
end)

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTarget")
AddEventHandler("tis-vehspeeds:client:DoSpeedTarget", function (encr, model, target)
    local pos = GetEntityCoords(PlayerPedId())
    createTrack()
    local vehicle = prepSpeedTest(model)
    if vehicle == 0 then
        removeTrack()
        return
    end
    print(target)

    local currentAcceleration = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    local newAcceleration = TargetIteration(vehicle, target, nil, currentAcceleration, nil)
    print(newAcceleration)
    SendNUIMessage({
        copy = newAcceleration
    })
    SetEntityCoords(vehicle, pos)
    removeTrack()
end)

AddEventHandler("onResourceStop", function(r)
	if r == GetCurrentResourceName() then
        removeTrack()
	end
end)

RegisterNetEvent("tis-vehspeeds:client:DoSpeedTestList")
AddEventHandler("tis-vehspeeds:client:DoSpeedTestList", function (encr)
    local pos = GetEntityCoords(PlayerPedId())
    createTrack()
    local vehicle = nil
    for _, v in ipairs(Config.SpeedTest.Vehicles) do
        print(v)
        vehicle = prepSpeedTest(v)
        if vehicle == 0 then
            removeTrack()
            return
        end
        local result = DoSpeedTest(vehicle, encr)
    end

    SetEntityCoords(vehicle, pos)
    removeTrack()
end)
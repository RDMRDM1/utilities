-- Keybind to open/close menu (0x2E = DELETE)
MachoMenuSetKeybind(WindowHandle, 0x2E)

-- Menu size and position
local MenuSize = vec2(800, 400)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Section coords
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create main window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)

-- Sections
SectionOne = MachoMenuGroup(MenuWindow, "Util.lua", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
SectionTwo = MachoMenuGroup(MenuWindow, "Options", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
SectionThree = MachoMenuGroup(MenuWindow, "Extras", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

-----------------------------------------------------------------
-- RESET FUNCTION (clears Section 2 and 3 when switching category)
-----------------------------------------------------------------
local function ClearSection(section)
    MachoMenuClear(section)
end

-----------------------------------------------------------------
-- SELF OPTIONS
-----------------------------------------------------------------
local function LoadSelfOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    -- GODMODE
    MachoMenuCheckbox(SectionTwo, "Godmode",
        function()
            Citizen.CreateThread(function()
                while true do
                    SetEntityInvincible(PlayerPedId(), true)
                    Citizen.Wait(0)
                end
            end)
        end,
        function()
            SetEntityInvincible(PlayerPedId(), false)
        end
    )

    -- INFINITE STAMINA
    MachoMenuCheckbox(SectionTwo, "Infinite Stamina",
        function()
            Citizen.CreateThread(function()
                while true do
                    RestorePlayerStamina(PlayerId(), 1.0)
                    Citizen.Wait(0)
                end
            end)
        end,
        function() end
    )

    -- NOCLIP
    MachoMenuCheckbox(SectionTwo, "NoClip",
        function()
            Citizen.CreateThread(function()
                local ped = PlayerPedId()
                while true do
                    if not IsControlPressed(0, 21) then break end -- hold SHIFT to stay in noclip
                    local coords = GetEntityCoords(ped)
                    SetEntityInvincible(ped, true)
                    SetEntityVisible(ped, false, false)
                    SetEntityCollision(ped, false, false)

                    if IsControlPressed(0, 32) then -- W
                        coords = coords + (GetEntityForwardVector(ped) * 1.0)
                    end
                    if IsControlPressed(0, 33) then -- S
                        coords = coords - (GetEntityForwardVector(ped) * 1.0)
                    end
                    if IsControlPressed(0, 34) then -- A
                        coords = coords - (GetEntityRightVector(ped) * 1.0)
                    end
                    if IsControlPressed(0, 35) then -- D
                        coords = coords + (GetEntityRightVector(ped) * 1.0)
                    end

                    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true, true, true)
                    Citizen.Wait(0)
                end
            end)
        end,
        function()
            local ped = PlayerPedId()
            SetEntityInvincible(ped, false)
            SetEntityVisible(ped, true, false)
            SetEntityCollision(ped, true, true)
        end
    )

    -- REVIVE
    MachoMenuButton(SectionThree, "Revive", function()
        local ped = PlayerPedId()
        ResurrectPed(ped)
        SetEntityHealth(ped, 200)
        ClearPedTasksImmediately(ped)
    end)

    -- SUICIDE
    MachoMenuButton(SectionThree, "Suicide", function()
        SetEntityHealth(PlayerPedId(), 0)
    end)
end

-----------------------------------------------------------------
-- TELEPORT OPTIONS
-----------------------------------------------------------------
local function LoadTeleportOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    MachoMenuButton(SectionTwo, "TP to Waypoint", function()
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 1.0, false, false, false, false)
        end
    end)

    MachoMenuInputbox(SectionThree, "TP to Coords", "x,y,z")
    MachoMenuButton(SectionThree, "Go!", function()
        local input = MachoMenuGetInputbox(SectionThree)
        local x,y,z = string.match(input, "([^,]+),([^,]+),([^,]+)")
        SetEntityCoords(PlayerPedId(), tonumber(x), tonumber(y), tonumber(z) + 1.0, false, false, false, false)
    end)
end

-----------------------------------------------------------------
-- VEHICLE OPTIONS
-----------------------------------------------------------------
local function LoadVehicleOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    MachoMenuButton(SectionTwo, "Spawn Adder", function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = CreateVehicle(`adder`, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
    end)

    MachoMenuButton(SectionTwo, "Repair Vehicle", function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then SetVehicleFixed(veh) end
    end)

    MachoMenuButton(SectionThree, "Delete Vehicle", function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then DeleteEntity(veh) end
    end)

    MachoMenuButton(SectionThree, "Max Upgrades", function()
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then
            SetVehicleModKit(veh, 0)
            for i = 0, 50 do
                SetVehicleMod(veh, i, GetNumVehicleMods(veh, i)-1, false)
            end
        end
    end)
end

-----------------------------------------------------------------
-- EVENTS OPTIONS
-----------------------------------------------------------------
local function LoadEventsOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    MachoMenuButton(SectionTwo, "Set Weather: Clear", function() SetWeatherTypeNowPersist("CLEAR") end)
    MachoMenuButton(SectionTwo, "Set Weather: Rain", function() SetWeatherTypeNowPersist("RAIN") end)
    MachoMenuButton(SectionTwo, "Set Weather: Snow", function() SetWeatherTypeNowPersist("XMAS") end)

    MachoMenuSlider(SectionThree, "Time of Day", 12, 0, 23, "h", 0, function(val)
        NetworkOverrideClockTime(val, 0, 0)
    end)
end

-----------------------------------------------------------------
-- SPAWNER OPTIONS
-----------------------------------------------------------------
local function LoadSpawnerOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    MachoMenuButton(SectionTwo, "Give Pistol", function()
        GiveWeaponToPed(PlayerPedId(), `WEAPON_PISTOL`, 250, false, true)
    end)

    MachoMenuButton(SectionTwo, "Give AR", function()
        GiveWeaponToPed(PlayerPedId(), `WEAPON_CARBINERIFLE`, 250, false, true)
    end)

    MachoMenuButton(SectionThree, "Spawn NPC", function()
        local coords = GetEntityCoords(PlayerPedId())
        CreatePed(4, `a_m_m_business_01`, coords.x+2, coords.y, coords.z, 0.0, true, true)
    end)

    MachoMenuButton(SectionThree, "Spawn Prop (Cone)", function()
        local coords = GetEntityCoords(PlayerPedId())
        CreateObject(`prop_roadcone02a`, coords.x+1, coords.y, coords.z, true, true, true)
    end)
end

-----------------------------------------------------------------
-- TROLL OPTIONS
-----------------------------------------------------------------
local function LoadTrollOptions()
    ClearSection(SectionTwo)
    ClearSection(SectionThree)

    MachoMenuButton(SectionTwo, "Ragdoll Self", function()
        SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, true, true, false)
    end)

    MachoMenuButton(SectionTwo, "Explode Self", function()
        local coords = GetEntityCoords(PlayerPedId())
        AddExplosion(coords.x, coords.y, coords.z, 2, 10.0, true, false, 1.0)
    end)

    MachoMenuButton(SectionThree, "Fake Freeze", function()
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(5000)
        FreezeEntityPosition(PlayerPedId(), false)
    end)

    MachoMenuButton(SectionThree, "Black Screen", function()
        DoScreenFadeOut(2000)
        Citizen.Wait(3000)
        DoScreenFadeIn(2000)
    end)
end

---------------------------------------------------
-- SECTION 1 BUTTONS (Navigation)
---------------------------------------------------
MachoMenuButton(SectionOne, "Self", function() LoadSelfOptions() end)
MachoMenuButton(SectionOne, "Teleport", function() LoadTeleportOptions() end)
MachoMenuButton(SectionOne, "Vehicle", function() LoadVehicleOptions() end)
MachoMenuButton(SectionOne, "Events", function() LoadEventsOptions() end)
MachoMenuButton(SectionOne, "Spawner", function() LoadSpawnerOptions() end)
MachoMenuButton(SectionOne, "Troll", function() LoadTrollOptions() end)
MachoMenuButton(SectionOne, "Close", function() MachoMenuDestroy(MenuWindow) end)

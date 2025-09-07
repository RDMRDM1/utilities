local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(300, 50)
local SidebarWidth = 140
local PanelGap = 12
local PanelWidth = (MenuSize.x - SidebarWidth - PanelGap) / 2
local MenuTopPadding = 20

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 0, 0) -- Red accent

local SidebarGroup = MachoMenuGroup(MenuWindow, "Sidebar", 0, 0, SidebarWidth, MenuSize.y)
local LeftPanel = MachoMenuGroup(MenuWindow, "LeftPanel", SidebarWidth + PanelGap, MenuTopPadding, SidebarWidth + PanelGap + PanelWidth, MenuSize.y)
local RightPanel = MachoMenuGroup(MenuWindow, "RightPanel", SidebarWidth + PanelGap + PanelWidth + PanelGap, MenuTopPadding, MenuSize.x, MenuSize.y)

local playerPed = PlayerPedId()
local playerId = PlayerId()

local tabs = {"Self", "Server", "Teleport", "Weapon", "Vehicle", "Animations", "Triggers", "Settings"}
local selectedTab = 1

local isNoClipActive = false

-- Register NoClip toggle key "U"
RegisterCommand("toggleNoClip", function()
    isNoClipActive = not isNoClipActive
    TriggerEvent("macho:EnableNoClip", isNoClipActive)
end, false)
RegisterKeyMapping("toggleNoClip", "Toggle NoClip", "keyboard", "U")

RegisterNetEvent("macho:EnableNoClip")
AddEventHandler("macho:EnableNoClip", function(enabled)
    isNoClipActive = enabled
    -- Implement your noclip logic here (free flight, disable collisions, etc)
    print("NoClip toggled: " .. tostring(enabled))
end)

local function clearPanels()
    -- Remove items from LeftPanel and RightPanel before repopulating (depends on Macho API)
end

local function selectTab(index)
    selectedTab = index
    clearPanels()

    if index == 1 then
        MachoMenuText(LeftPanel, "Self Tab")
        MachoMenuCheckbox(LeftPanel, "Godmode",
            function() SetEntityInvincible(playerPed, true) SetPlayerInvincible(playerId, true) end,
            function() SetEntityInvincible(playerPed, false) SetPlayerInvincible(playerId, false) end)
        MachoMenuCheckbox(LeftPanel, "Invisibility",
            function() SetEntityVisible(playerPed, false, false) end,
            function() SetEntityVisible(playerPed, true, false) end)
        MachoMenuCheckbox(LeftPanel, "No Ragdoll",
            function() SetPedCanRagdoll(playerPed, false) end,
            function() SetPedCanRagdoll(playerPed, true) end)
        MachoMenuCheckbox(LeftPanel, "Infinite Stamina",
            function() SetPlayerUnlimitedStamina(playerId, true) end,
            function() SetPlayerUnlimitedStamina(playerId, false) end)
        MachoMenuCheckbox(LeftPanel, "Tiny Ped",
            function() SetEntityScale(playerPed, 0.5) end,
            function() SetEntityScale(playerPed, 1.0) end)
        MachoMenuCheckbox(LeftPanel, "No Clip",
            function() TriggerEvent("macho:EnableNoClip", true) end,
            function() TriggerEvent("macho:EnableNoClip", false) end)
        MachoMenuCheckbox(LeftPanel, "Free Camera",
            function() TriggerEvent("macho:EnableFreeCam", true) end,
            function() TriggerEvent("macho:EnableFreeCam", false) end)
        MachoMenuCheckbox(LeftPanel, "Super Jump", function() SetSuperJumpThisFrame(playerId) end, function() end)
        MachoMenuCheckbox(LeftPanel, "Super Punch",
            function() TriggerEvent("macho:EnableSuperPunch", true) end,
            function() TriggerEvent("macho:EnableSuperPunch", false) end)
        MachoMenuCheckbox(LeftPanel, "Force Third Person",
            function() SetFollowPedCamViewMode(1) end,
            function() SetFollowPedCamViewMode(0) end)
        MachoMenuCheckbox(LeftPanel, "Force Driveby",
            function() SetPlayerCanDoDriveBy(playerId, true) end,
            function() SetPlayerCanDoDriveBy(playerId, false) end)
        MachoMenuCheckbox(LeftPanel, "Anti-Headshot",
            function() TriggerEvent("macho:AntiHeadshotEnable", true) end,
            function() TriggerEvent("macho:AntiHeadshotEnable", false) end)
        MachoMenuCheckbox(LeftPanel, "Anti-Freeze",
            function() TriggerEvent("macho:AntiFreezeEnable", true) end,
            function() TriggerEvent("macho:AntiFreezeEnable", false) end)
        MachoMenuCheckbox(LeftPanel, "Anti-Blackscreen",
            function() TriggerEvent("macho:AntiBlackScreenEnable", true) end,
            function() TriggerEvent("macho:AntiBlackScreenEnable", false) end)

        MachoMenuText(RightPanel, "Misc")
        local modelInput = MachoMenuInputbox(RightPanel, "Model Changer", "Enter model name")
        MachoMenuButton(RightPanel, "Change Model", function()
            local model = MachoMenuGetInputbox(modelInput)
            if IsModelValid(GetHashKey(model)) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
                SetPlayerModel(playerId, GetHashKey(model))
                SetModelAsNoLongerNeeded(GetHashKey(model))
            end
        end)
        MachoMenuButton(RightPanel, "Max Health/Armor", function()
            SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
            SetPedArmour(playerPed, 100)
        end)
        MachoMenuButton(RightPanel, "Revive", function()
            NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), true, true, false)
            ClearPedTasksImmediately(playerPed)
        end)
        MachoMenuButton(RightPanel, "Suicide", function()
            SetEntityHealth(playerPed, 0)
        end)
        MachoMenuButton(RightPanel, "Clear Task", function()
            ClearPedTasksImmediately(playerPed)
        end)
        MachoMenuButton(RightPanel, "Clear Vision", function()
            ClearTimecycleModifier()
        end)
        MachoMenuButton(RightPanel, "Randomize Outfit", function()
            TriggerEvent("macho:RandomizeOutfit")
        end)

    elseif index == 2 then -- Server tab
        MachoMenuText(LeftPanel, "Server Controls")
        -- These will need server-side support or natives that affect other players
        MachoMenuButton(LeftPanel, "Kill Player", function() TriggerEvent("macho:serverKillPlayer") end)
        MachoMenuButton(LeftPanel, "Taze Player", function() TriggerEvent("macho:serverTazePlayer") end)
        MachoMenuButton(LeftPanel, "Explode Player", function() TriggerEvent("macho:serverExplodePlayer") end)
        MachoMenuButton(LeftPanel, "Teleport To Player", function() TriggerEvent("macho:serverTeleportToPlayer") end)
        MachoMenuButton(LeftPanel, "Kick From Vehicle", function() TriggerEvent("macho:serverKickFromVehicle") end)
        MachoMenuButton(LeftPanel, "Freeze Player", function() TriggerEvent("macho:serverFreezePlayer") end)
        MachoMenuButton(LeftPanel, "Glitch Player", function() TriggerEvent("macho:serverGlitchPlayer") end)
        MachoMenuButton(LeftPanel, "Limbo Player", function() TriggerEvent("macho:serverLimboPlayer") end)
        MachoMenuButton(LeftPanel, "Copy Appearance", function() TriggerEvent("macho:serverCopyAppearance") end)
        MachoMenuButton(LeftPanel, "Spectate Player", function() TriggerEvent("macho:serverSpectatePlayer") end)
        MachoMenuButton(LeftPanel, "Crash Nearby", function() TriggerEvent("macho:serverCrashNearby") end)
        MachoMenuButton(LeftPanel, "Explode All Players", function() TriggerEvent("macho:serverExplodeAllPlayers") end)
        MachoMenuButton(LeftPanel, "Explode All Vehicles", function() TriggerEvent("macho:serverExplodeAllVehicles") end)
        MachoMenuButton(LeftPanel, "Delete All Vehicles", function() TriggerEvent("macho:serverDeleteAllVehicles") end)
        MachoMenuButton(LeftPanel, "Delete All Peds", function() TriggerEvent("macho:serverDeleteAllPeds") end)
        MachoMenuButton(LeftPanel, "Delete All Objects", function() TriggerEvent("macho:serverDeleteAllObjects") end)
        MachoMenuButton(LeftPanel, "Kill All", function() TriggerEvent("macho:serverKillAll") end)
        MachoMenuButton(LeftPanel, "Permanent Kill All", function() TriggerEvent("macho:serverPermanentKillAll") end)

    elseif index == 3 then -- Teleport tab
        MachoMenuText(LeftPanel, "Teleport Options")

        local coordsInput = MachoMenuInputbox(LeftPanel, "Teleport Coords", "x,y,z")
        MachoMenuButton(LeftPanel, "Teleport To Coords", function()
            local coords = MachoMenuGetInputbox(coordsInput)
            local x,y,z = coords:match("([^,]+),([^,]+),([^,]+)")
            if x and y and z then
                SetEntityCoords(playerPed, tonumber(x), tonumber(y), tonumber(z), false, false, false, true)
            else
                print("Invalid coords entered")
            end
        end)
        MachoMenuButton(LeftPanel, "Teleport To Waypoint", function()
            local blip = GetFirstBlipInfoId(8)
            if DoesBlipExist(blip) then
                local x,y,z = table.unpack(GetBlipInfoIdCoord(blip))
                SetEntityCoords(playerPed, x, y, z, false, false, false, true)
            else
                print("No waypoint set")
            end
        end)

        local presetLocations = {
            {label="FIB Building", coords=vector3(135.0, -761.0, 46.0)},
            {label="Mission Row PD", coords=vector3(436.0, -982.0, 30.6)},
            {label="Pillbox Hospital", coords=vector3(310.0, -592.0, 43.3)},
            {label="Del Perro Pier", coords=vector3(-1707.1, -1036.9, 13.1)},
            {label="Grove Street", coords=vector3(-34.0, -1448.0, 30.6)},
            {label="Legion Square", coords=vector3(269.9, -1343.6, 23.3)},
            {label="LS Customs", coords=vector3(-347.3, -133.6, 39.0)},
            {label="Maze Bank", coords=vector3(-75.0, -818.2, 326.1)},
            {label="Mirror Park", coords=vector3(1183.3, -326.4, 69.2)},
            {label="Vespucci Beach", coords=vector3(-1154.4, -1511.1, 9.6)},
            {label="Vinewood", coords=vector3(1194.9, 2733.6, 38.0)},
            {label="Sandy Shores", coords=vector3(1850.4, 3683.0, 34.2)},
        }

        for _, loc in ipairs(presetLocations) do
            MachoMenuButton(LeftPanel, "Teleport To: "..loc.label, function()
                SetEntityCoords(playerPed, loc.coords.x, loc.coords.y, loc.coords.z, false, false, false, true)
            end)
        end

        MachoMenuButton(LeftPanel, "Print Current Coords", function()
            local coords = GetEntityCoords(playerPed)
            print(("Coords: %.2f, %.2f, %.2f"):format(coords.x, coords.y, coords.z))
        end)

    elseif index == 4 then -- Weapon tab
        MachoMenuText(LeftPanel, "Weapon Options")
        local weaponInfiniteAmmo = false
        MachoMenuCheckbox(LeftPanel, "Infinite Ammo", function() weaponInfiniteAmmo = true end, function() weaponInfiniteAmmo = false end)
        MachoMenuCheckbox(LeftPanel, "Explosive Ammo", 
            function() TriggerEvent("macho:ExplosiveAmmoEnable", true) end,
            function() TriggerEvent("macho:ExplosiveAmmoEnable", false) end)
        MachoMenuCheckbox(LeftPanel, "One shot Kill", function() TriggerEvent("macho:OneShotKillEnable", true) end, function() TriggerEvent("macho:OneShotKillEnable", false) end)

        local aimingStyleDropdown = MachoMenuDropDown(LeftPanel, "Change Aiming Style",
            function(index) TriggerEvent("macho:ChangeAimingStyle", index) end,
            "Default", "Gangster", "Wild", "Red Neck")

        local weaponSpawnerInput = MachoMenuInputbox(RightPanel, "Weapon Spawner", "Enter weapon name")
        MachoMenuButton(RightPanel, "Spawn Weapon", function()
            local wepName = MachoMenuGetInputbox(weaponSpawnerInput)
            if IsWeaponValid(GetHashKey(wepName)) then
                GiveWeaponToPed(playerPed, GetHashKey(wepName), 9999, false, false)
            else
                print("Invalid weapon")
            end
        end)

    elseif index == 5 then -- Vehicle tab
        MachoMenuText(LeftPanel, "Vehicle Options")
        MachoMenuCheckbox(LeftPanel, "Vehicle Godmode",
            function() TriggerEvent("macho:VehicleGodmodeToggle", true) end,
            function() TriggerEvent("macho:VehicleGodmodeToggle", false) end)
        MachoMenuCheckbox(LeftPanel, "Force Vehicle Engine", function() --trigger event here end, function() --disable event end)
        MachoMenuCheckbox(LeftPanel, "Vehicle Auto Repair", function() --trigger event here end, function() --disable event end)
        MachoMenuCheckbox(LeftPanel, "Freeze Vehicle", function() --trigger event here end, function() --disable event end)
        MachoMenuCheckbox(LeftPanel, "Vehicle Hop", function() --trigger event here end, function() --disable event end)
        MachoMenuCheckbox(LeftPanel, "Rainbow Vehicle",
            function() TriggerEvent("macho:RainbowVehicle", true) end,
            function() TriggerEvent("macho:RainbowVehicle", false) end)
        MachoMenuCheckbox(LeftPanel, "Drift Mode", function() --trigger event here end, function() --disable event end)
        MachoMenuCheckbox(LeftPanel, "Easy Handling", function() --trigger event here end, function() --disable event end)
        MachoMenuButton(LeftPanel, "Shift Boost", function() --trigger event here end)
        MachoMenuButton(LeftPanel, "Instant Breaking", function() --trigger event here end)
        MachoMenuCheckbox(LeftPanel, "Unlimited Fuel", function() --trigger event here end, function() --disable event end)

        local licensePlateInput = MachoMenuInputbox(RightPanel, "License Plate Changer", "New Plate Text")
        MachoMenuInputbox(RightPanel, "Vehicle Spawner", "Enter vehicle model")
        MachoMenuButton(RightPanel, "Spawn Vehicle", function()
            local model = MachoMenuGetInputbox(licensePlateInput)
            if IsModelValid(GetHashKey(model)) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
                local pos = GetEntityCoords(playerPed)
                local vehicle = CreateVehicle(GetHashKey(model), pos.x + 3, pos.y + 3, pos.z, GetEntityHeading(playerPed), true, false)
                SetPedIntoVehicle(playerPed, vehicle, -1)
                SetVehicleNumberPlateText(vehicle, MachoMenuGetInputbox(licensePlateInput))
                SetModelAsNoLongerNeeded(GetHashKey(model))
            else
                print("Invalid vehicle model")
            end
        end)

        MachoMenuButton(RightPanel, "Repair Vehicle", function() --repair vehicle native end)
        MachoMenuButton(RightPanel, "Flip Vehicle", function() --flip vehicle native end)
        MachoMenuButton(RightPanel, "Clean Vehicle", function() --clean vehicle native end)
        MachoMenuButton(RightPanel, "Delete Vehicle", function() --delete vehicle native end)
        MachoMenuButton(RightPanel, "Toggle Vehicle Engine", function() --toggle engine native end)
        MachoMenuButton(RightPanel, "Max Vehicle Upgrades", function() --max upgrades native end)
        MachoMenuButton(RightPanel, "Unlock Closest Vehicle", function() --unlock native end)
        MachoMenuButton(RightPanel, "Lock Closest Vehicle", function() --lock native end)

    elseif index == 6 then -- Animations tab
        MachoMenuText(LeftPanel, "Animations")
        MachoMenuButton(LeftPanel, "Twerk On Them", function() TriggerEvent("macho:PlayAnim", "twerk") end)
        MachoMenuButton(LeftPanel, "Give Them Backshots", function() TriggerEvent("macho:PlayAnim", "backshots") end)
        MachoMenuButton(LeftPanel, "Wank On Them", function() TriggerEvent("macho:PlayAnim", "wank") end)
        -- more animations buttons...

    elseif index == 7 then -- Triggers tab
        MachoMenuText(LeftPanel, "Triggers")
        MachoMenuInputbox(LeftPanel, "Item Spawner", "Enter item")
        MachoMenuInputbox(LeftPanel, "Money Spawner", "Enter amount")
        MachoMenuInputbox(LeftPanel, "Custom Safe Triggers", "Enter trigger")
        MachoMenuButton(LeftPanel, "Force Rob", function() TriggerEvent("macho:ForceRob") end)

    elseif index == 8 then -- Settings tab
        MachoMenuText(LeftPanel, "Settings")
        local accentInput = MachoMenuInputbox(LeftPanel, "Accent Changer", "R,G,B")
        MachoMenuButton(LeftPanel, "Change Accent", function()
            local rgbStr = MachoMenuGetInputbox(accentInput)
            local r,g,b = rgbStr:match("(%d+),(%d+),(%d+)")
            if r and g and b then
                MachoMenuSetAccent(MenuWindow, tonumber(r), tonumber(g), tonumber(b))
            else
                print("Invalid RGB input")
            end
        end)
        MachoMenuButton(LeftPanel, "Unload Menu", function() MachoMenuDestroy(MenuWindow) end)
        MachoMenuButton(LeftPanel, "Anti-Cheat Checker", function() TriggerEvent("macho:AntiCheatCheck") end)
        MachoMenuButton(LeftPanel, "Framework Checker", function() TriggerEvent("macho:FrameworkCheck") end)
    end
end

for i, tabName in ipairs(tabs) do
    MachoMenuButton(SidebarGroup, tabName, function()
        selectTab(i)
    end)
end

selectTab(selectedTab)

MachoMenuButton(SidebarGroup, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

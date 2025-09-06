-- Full MachoMenu Multi-Tab Menu
-- Place in client side script (e.g. client.lua). Implement server handlers separately for server actions.

-- Window size / position
local MenuSize = vec2(800, 520)
local MenuStartCoords = vec2(300, 120)
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- Left nav area (small column) and right content area
local NavX1, NavY1, NavX2, NavY2 = 10, 40, 190, MenuSize.y - 10
local ContentX1, ContentY1, ContentX2, ContentY2 = 200, 40, MenuSize.x - 10, MenuSize.y - 10

-- Create navigation group
NavGroup = MachoMenuGroup(MenuWindow, "Menu", NavX1, NavY1, NavX2, NavY2)

-- Create content groups (one per tab). Start all hidden except Self.
SelfGroup      = MachoMenuGroup(MenuWindow, "Self", ContentX1, ContentY1, ContentX2, ContentY2)
ServerGroup    = MachoMenuGroup(MenuWindow, "Server", ContentX1, ContentY1, ContentX2, ContentY2)
TeleportGroup  = MachoMenuGroup(MenuWindow, "Teleport", ContentX1, ContentY1, ContentX2, ContentY2)
WeaponGroup    = MachoMenuGroup(MenuWindow, "Weapon", ContentX1, ContentY1, ContentX2, ContentY2)
VehicleGroup   = MachoMenuGroup(MenuWindow, "Vehicle", ContentX1, ContentY1, ContentX2, ContentY2)
AnimationsGroup= MachoMenuGroup(MenuWindow, "Animations", ContentX1, ContentY1, ContentX2, ContentY2)
TriggersGroup  = MachoMenuGroup(MenuWindow, "Triggers", ContentX1, ContentY1, ContentX2, ContentY2)
SettingsGroup  = MachoMenuGroup(MenuWindow, "Settings", ContentX1, ContentY1, ContentX2, ContentY2)

-- Helper to hide all content groups
local function hideAllContent()
    MachoMenuSetVisible(SelfGroup, false)
    MachoMenuSetVisible(ServerGroup, false)
    MachoMenuSetVisible(TeleportGroup, false)
    MachoMenuSetVisible(WeaponGroup, false)
    MachoMenuSetVisible(VehicleGroup, false)
    MachoMenuSetVisible(AnimationsGroup, false)
    MachoMenuSetVisible(TriggersGroup, false)
    MachoMenuSetVisible(SettingsGroup, false)
end

-- Show Self by default
hideAllContent()
MachoMenuSetVisible(SelfGroup, true)

-- NAV BUTTONS (left side)
MachoMenuButton(NavGroup, "Self", function()
    hideAllContent()
    MachoMenuSetVisible(SelfGroup, true)
end)

MachoMenuButton(NavGroup, "Server", function()
    hideAllContent()
    MachoMenuSetVisible(ServerGroup, true)
end)

MachoMenuButton(NavGroup, "Teleport", function()
    hideAllContent()
    MachoMenuSetVisible(TeleportGroup, true)
end)

MachoMenuButton(NavGroup, "Weapon", function()
    hideAllContent()
    MachoMenuSetVisible(WeaponGroup, true)
end)

MachoMenuButton(NavGroup, "Vehicle", function()
    hideAllContent()
    MachoMenuSetVisible(VehicleGroup, true)
end)

MachoMenuButton(NavGroup, "Animations", function()
    hideAllContent()
    MachoMenuSetVisible(AnimationsGroup, true)
end)

MachoMenuButton(NavGroup, "Triggers", function()
    hideAllContent()
    MachoMenuSetVisible(TriggersGroup, true)
end)

MachoMenuButton(NavGroup, "Settings", function()
    hideAllContent()
    MachoMenuSetVisible(SettingsGroup, true)
end)

MachoMenuButton(NavGroup, "Unload Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

------------------------------------------------------------------------
-- SELF TAB (client toggles / stubs)
------------------------------------------------------------------------
local godmodeEnabled = false
MachoMenuButton(SelfGroup, "Godmode", function()
    godmodeEnabled = not godmodeEnabled
    SetEntityInvincible(PlayerPedId(), godmodeEnabled)
end)

local invisible = false
MachoMenuButton(SelfGroup, "Invisibility", function()
    invisible = not invisible
    SetEntityVisible(PlayerPedId(), not invisible) -- note: inverted on this API; adjust if needed
end)

MachoMenuButton(SelfGroup, "No Ragdoll", function()
    SetPedCanRagdoll(PlayerPedId(), false)
end)

-- Simple infinite stamina thread: toggles the thread each press
local staminaThread = nil
MachoMenuButton(SelfGroup, "Infinite Stamina", function()
    if staminaThread then
        -- stop by setting to nil (not perfect; you can implement a proper toggle flag)
        staminaThread = nil
    else
        staminaThread = true
        Citizen.CreateThread(function()
            while staminaThread do
                RestorePlayerStamina(PlayerId(), 1.0)
                Citizen.Wait(1000)
            end
        end)
    end
end)

MachoMenuButton(SelfGroup, "Tiny Ped", function()
    -- stub: send server event to change scale or use SetPlayerModel/SetEntityScale (implement as needed)
    TriggerServerEvent("menu:server:tinyPed")
end)

MachoMenuButton(SelfGroup, "No Clip", function()
    -- stub: no-clip usually requires continuous movement handling; implement client logic here
    TriggerEvent("menu:client:toggleNoClip")
end)

MachoMenuButton(SelfGroup, "Free Camera", function()
    TriggerEvent("menu:client:toggleFreeCam")
end)

MachoMenuButton(SelfGroup, "Super Jump", function()
    TriggerEvent("menu:client:superJumpToggle")
end)

MachoMenuButton(SelfGroup, "Super Punch", function()
    TriggerEvent("menu:client:superPunchToggle")
end)

MachoMenuButton(SelfGroup, "Force Third Person", function()
    -- toggle third person (game-specific)
    TriggerEvent("menu:client:forceThirdPerson")
end)

MachoMenuButton(SelfGroup, "Force Driveby", function()
    TriggerEvent("menu:client:forceDriveby")
end)

MachoMenuButton(SelfGroup, "Anti-Headshot", function()
    -- stub
    TriggerEvent("menu:client:antiHeadshotToggle")
end)

MachoMenuButton(SelfGroup, "Anti-Freeze", function()
    TriggerEvent("menu:client:antiFreezeToggle")
end)

MachoMenuButton(SelfGroup, "Anti-Blackscreen", function()
    TriggerEvent("menu:client:antiBlackScreenToggle")
end)

MachoMenuButton(SelfGroup, "Max Health / Armor", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
end)

MachoMenuButton(SelfGroup, "Revive / Suicide", function()
    -- simple toggle: Revive if dead, otherwise suicide
    if IsEntityDead(PlayerPedId()) then
        ResurrectPed(PlayerPedId())
        ClearPedTasksImmediately(PlayerPedId())
    else
        SetEntityHealth(PlayerPedId(), 0)
    end
end)

MachoMenuButton(SelfGroup, "Clear Task / Clear Vision", function()
    ClearPedTasksImmediately(PlayerPedId())
    ClearTimecycleModifier()
    SetTransitionTimecycleModifier("")
end)

MachoMenuButton(SelfGroup, "Randomize Outfit", function()
    TriggerServerEvent("menu:server:randomizeOutfit")
end)

MachoMenuButton(SelfGroup, "Model Changer", function()
    -- open a simple inputbox or call server; stub uses event
    TriggerEvent("menu:client:openModelChanger")
end)

------------------------------------------------------------------------
-- SERVER TAB (these are mostly server-triggered actions)
------------------------------------------------------------------------
MachoMenuButton(ServerGroup, "Kill / Taze / Explode Player", function()
    TriggerServerEvent("menu:server:killOrTazeOrExplodeTarget")
end)

MachoMenuButton(ServerGroup, "Teleport To Player", function()
    TriggerServerEvent("menu:server:teleportToPlayer")
end)

MachoMenuButton(ServerGroup, "Kick From Vehicle", function()
    TriggerServerEvent("menu:server:kickFromVehicle")
end)

MachoMenuButton(ServerGroup, "Freeze Player", function()
    TriggerServerEvent("menu:server:freezePlayer")
end)

MachoMenuButton(ServerGroup, "Glitch Player", function()
    TriggerServerEvent("menu:server:glitchPlayer")
end)

MachoMenuButton(ServerGroup, "Limbo Player", function()
    TriggerServerEvent("menu:server:limboPlayer")
end)

MachoMenuButton(ServerGroup, "Copy Appearance", function()
    TriggerServerEvent("menu:server:copyAppearance")
end)

MachoMenuButton(ServerGroup, "Spectate Player", function()
    TriggerServerEvent("menu:server:spectatePlayer")
end)

MachoMenuButton(ServerGroup, "Crash Nearby", function()
    TriggerServerEvent("menu:server:crashNearby")
end)

MachoMenuButton(ServerGroup, "Explode All Players", function()
    TriggerServerEvent("menu:server:explodeAllPlayers")
end)

MachoMenuButton(ServerGroup, "Explode All Vehicles", function()
    TriggerServerEvent("menu:server:explodeAllVehicles")
end)

MachoMenuButton(ServerGroup, "Delete All Vehicles", function()
    TriggerServerEvent("menu:server:deleteAllVehicles")
end)

MachoMenuButton(ServerGroup, "Delete All Peds", function()
    TriggerServerEvent("menu:server:deleteAllPeds")
end)

MachoMenuButton(ServerGroup, "Delete All Objects", function()
    TriggerServerEvent("menu:server:deleteAllObjects")
end)

MachoMenuButton(ServerGroup, "Kill All / Permanent Kill All", function()
    TriggerServerEvent("menu:server:killAllPlayers")
end)

------------------------------------------------------------------------
-- TELEPORT TAB
------------------------------------------------------------------------
MachoMenuButton(TeleportGroup, "Teleport To Coords / Waypoint", function()
    TriggerEvent("menu:client:teleportToWaypointOrCoords")
end)

-- Preset locations: just trigger server/client handlers with name
local presets = {
    "FIB Building","Mission Row PD","Pillbox Hospital","Del Perro Pier","Grove Street",
    "Legion Square","LS Customs","Maze Bank","Mirror Park","Vespucci Beach",
    "Vinewood","Sandy Shores"
}
for _, name in ipairs(presets) do
    MachoMenuButton(TeleportGroup, name, function()
        TriggerEvent("menu:client:teleportPreset", name)
    end)
end

MachoMenuButton(TeleportGroup, "Print Current Coords", function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    print(("Current coords: %.3f, %.3f, %.3f"):format(coords.x, coords.y, coords.z))
end)

------------------------------------------------------------------------
-- WEAPON TAB
------------------------------------------------------------------------
MachoMenuButton(WeaponGroup, "Infinite Ammo", function()
    TriggerEvent("menu:client:toggleInfiniteAmmo")
end)

MachoMenuButton(WeaponGroup, "Explosive Ammo", function()
    TriggerEvent("menu:client:toggleExplosiveAmmo")
end)

MachoMenuButton(WeaponGroup, "One shot Kill", function()
    TriggerEvent("menu:client:toggleOneShotKill")
end)

MachoMenuButton(WeaponGroup, "Change Aiming Style (Default)", function()
    TriggerEvent("menu:client:changeAimingStyle", "Default")
end)
MachoMenuButton(WeaponGroup, "Change Aiming Style (Gangster)", function()
    TriggerEvent("menu:client:changeAimingStyle", "Gangster")
end)
MachoMenuButton(WeaponGroup, "Change Aiming Style (Wild)", function()
    TriggerEvent("menu:client:changeAimingStyle", "Wild")
end)
MachoMenuButton(WeaponGroup, "Change Aiming Style (Red Neck)", function()
    TriggerEvent("menu:client:changeAimingStyle", "RedNeck")
end)

MachoMenuButton(WeaponGroup, "Weapon Spawner", function()
    TriggerServerEvent("menu:server:spawnWeapon")
end)

------------------------------------------------------------------------
-- VEHICLE TAB
------------------------------------------------------------------------
MachoMenuButton(VehicleGroup, "Vehicle Godmode", function()
    TriggerEvent("menu:client:toggleVehicleGodmode")
end)

MachoMenuButton(VehicleGroup, "Force Vehicle Engine", function()
    TriggerEvent("menu:client:forceVehicleEngine")
end)

MachoMenuButton(VehicleGroup, "Vehicle Auto Repair", function()
    TriggerEvent("menu:client:autoRepairVehicle")
end)

MachoMenuButton(VehicleGroup, "Freeze Vehicle", function()
    TriggerEvent("menu:client:freezeVehicle")
end)

MachoMenuButton(VehicleGroup, "Vehicle Hop", function()
    TriggerEvent("menu:client:vehicleHop")
end)

MachoMenuButton(VehicleGroup, "Rainbow Vehicle", function()
    TriggerEvent("menu:client:rainbowVehicle")
end)

MachoMenuButton(VehicleGroup, "Drift Mode", function()
    TriggerEvent("menu:client:toggleDriftMode")
end)

MachoMenuButton(VehicleGroup, "Easy Handling", function()
    TriggerEvent("menu:client:easyHandling")
end)

MachoMenuButton(VehicleGroup, "Shift Boost", function()
    TriggerEvent("menu:client:shiftBoost")
end)

MachoMenuButton(VehicleGroup, "Instant Breaking", function()
    TriggerEvent("menu:client:instantBraking")
end)

MachoMenuButton(VehicleGroup, "Unlimited Fuel", function()
    TriggerEvent("menu:client:unlimitedFuel")
end)

MachoMenuButton(VehicleGroup, "License Plate Changer", function()
    TriggerEvent("menu:client:changePlate")
end)

MachoMenuButton(VehicleGroup, "Vehicle Spawner", function()
    TriggerServerEvent("menu:server:spawnVehicle")
end)

MachoMenuButton(VehicleGroup, "Repair, Flip, Clean, Delete Vehicle", function()
    TriggerEvent("menu:client:vehicleRepairFlipCleanDelete")
end)

MachoMenuButton(VehicleGroup, "Toggle Vehicle Engine", function()
    TriggerEvent("menu:client:toggleVehicleEngine")
end)

MachoMenuButton(VehicleGroup, "Max Vehicle Upgrades", function()
    TriggerServerEvent("menu:server:maxVehicleUpgrades")
end)

MachoMenuButton(VehicleGroup, "Unlock Closest Vehicle", function()
    TriggerEvent("menu:client:unlockClosestVehicle")
end)

MachoMenuButton(VehicleGroup, "Lock Closest Vehicle", function()
    TriggerEvent("menu:client:lockClosestVehicle")
end)

------------------------------------------------------------------------
-- ANIMATIONS TAB
------------------------------------------------------------------------
MachoMenuButton(AnimationsGroup, "Twerk On Them", function() TriggerEvent("menu:client:animTwerk") end)
MachoMenuButton(AnimationsGroup, "Give Them Backshots", function() TriggerEvent("menu:client:animBackshots") end)
MachoMenuButton(AnimationsGroup, "Wank On Them", function() TriggerEvent("menu:client:animWank") end)
MachoMenuButton(AnimationsGroup, "Piggyback On Player", function() TriggerEvent("menu:client:animPiggyback") end)
MachoMenuButton(AnimationsGroup, "Blame Arrest", function() TriggerEvent("menu:client:animBlameArrest") end)
MachoMenuButton(AnimationsGroup, "Blame Carry", function() TriggerEvent("menu:client:animBlameCarry") end)
MachoMenuButton(AnimationsGroup, "Sit On Them", function() TriggerEvent("menu:client:animSitOn") end)
MachoMenuButton(AnimationsGroup, "Ride Driver", function() TriggerEvent("menu:client:animRideDriver") end)
MachoMenuButton(AnimationsGroup, "Blow Driver", function() TriggerEvent("menu:client:animBlowDriver") end)
MachoMenuButton(AnimationsGroup, "Meditate On Them", function() TriggerEvent("menu:client:animMeditate") end)
MachoMenuButton(AnimationsGroup, "Force Emote", function() TriggerEvent("menu:client:forceEmote") end)

------------------------------------------------------------------------
-- TRIGGERS TAB
------------------------------------------------------------------------
MachoMenuButton(TriggersGroup, "Item Spawner", function() TriggerServerEvent("menu:server:spawnItem") end)
MachoMenuButton(TriggersGroup, "Money Spawner", function() TriggerServerEvent("menu:server:spawnMoney") end)
MachoMenuButton(TriggersGroup, "Custom Safe Triggers", function() TriggerServerEvent("menu:server:customSafeTrigger") end)
MachoMenuButton(TriggersGroup, "Force Rob", function() TriggerServerEvent("menu:server:forceRob") end)

------------------------------------------------------------------------
-- SETTINGS TAB
------------------------------------------------------------------------
MachoMenuButton(SettingsGroup, "Accent Changer", function()
    -- cycle accent colors (example)
    MachoMenuSetAccent(MenuWindow, math.random(0,255), math.random(0,255), math.random(0,255))
end)

MachoMenuButton(SettingsGroup, "Unload Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

MachoMenuButton(SettingsGroup, "Anti-Cheat Checker", function()
    TriggerEvent("menu:client:antiCheatCheck")
end)

MachoMenuButton(SettingsGroup, "Framework Checker", function()
    TriggerEvent("menu:client:frameworkCheck")
end)

-- End of menu

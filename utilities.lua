local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

-- Create menu window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)
MachoMenuSetVisible(MenuWindow, false)

-- ============================
-- Sections (Tabs)
-- ============================
SelfSection = MachoMenuGroup(MenuWindow, "Self Options", 20, 60, 580, 320)
SpawnerSection = MachoMenuGroup(MenuWindow, "Spawner Options", 20, 60, 580, 320)
TeleportSection = MachoMenuGroup(MenuWindow, "Teleport Options", 20, 60, 580, 320)

-- Start hidden
MachoMenuSetVisible(SelfSection, false)
MachoMenuSetVisible(SpawnerSection, false)
MachoMenuSetVisible(TeleportSection, false)

-- ============================
-- Tab Bar
-- ============================
Tabs = MachoMenuGroup(MenuWindow, "Tabs", 20, 20, 580, 50)

MachoMenuButton(Tabs, "Self", function()
    MachoMenuSetVisible(SelfSection, true)
    MachoMenuSetVisible(SpawnerSection, false)
    MachoMenuSetVisible(TeleportSection, false)
end)

MachoMenuButton(Tabs, "Spawner", function()
    MachoMenuSetVisible(SelfSection, false)
    MachoMenuSetVisible(SpawnerSection, true)
    MachoMenuSetVisible(TeleportSection, false)
end)

MachoMenuButton(Tabs, "Teleport", function()
    MachoMenuSetVisible(SelfSection, false)
    MachoMenuSetVisible(SpawnerSection, false)
    MachoMenuSetVisible(TeleportSection, true)
end)

-- ============================
-- Self Section
-- ============================
MachoMenuButton(SelfSection, "Godmode", function()
    SetEntityInvincible(PlayerPedId(), true)
end)

MachoMenuButton(SelfSection, "Revive", function()
    local ped = PlayerPedId()
    ResurrectPed(ped)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
end)

MachoMenuButton(SelfSection, "Suicide", function()
    SetEntityHealth(PlayerPedId(), 0)
end)

-- ============================
-- Spawner Section
-- ============================
MachoMenuButton(SpawnerSection, "Spawn Adder", function()
    local model = GetHashKey("adder")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, veh, -1)
end)

MachoMenuButton(SpawnerSection, "Spawn Buzzard", function()
    local model = GetHashKey("buzzard")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, veh, -1)
end)

-- ============================
-- Teleport Section
-- ============================
MachoMenuButton(TeleportSection, "TP to Waypoint", function()
    local blip = GetFirstBlipInfoId(8)
    if DoesBlipExist(blip) then
        local coord = GetBlipInfoIdCoord(blip)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
    end
end)

MachoMenuButton(TeleportSection, "TP to Legion Square", function()
    SetEntityCoords(PlayerPedId(), 215.76, -810.12, 30.73)
end)

-- ============================
-- Toggle Menu (Caps Lock)
-- ============================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 137) then -- Caps Lock
            local state = MachoMenuGetVisible(MenuWindow)
            MachoMenuSetVisible(MenuWindow, not state)
        end
    end
end)

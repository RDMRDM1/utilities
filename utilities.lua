local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500) 

local TabsBarWidth = 0
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 1 -- only 1 main panel visible at once
local SectionsPadding = 10 
local MachoPaneGap = 10 

local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Calculate panel positions
local PanelStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local PanelEnd = vec2(PanelStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create menu window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)

-- ============================
-- Main Menu (Categories)
-- ============================
MainMenu = MachoMenuGroup(MenuWindow, "Main Menu", PanelStart.x, PanelStart.y, PanelEnd.x, PanelEnd.y)

MachoMenuButton(MainMenu, "Self", function()
    MachoMenuSetVisible(MainMenu, false)
    MachoMenuSetVisible(SelfSection, true)
end)

MachoMenuButton(MainMenu, "Teleport", function()
    MachoMenuSetVisible(MainMenu, false)
    MachoMenuSetVisible(TeleportSection, true)
end)

MachoMenuButton(MainMenu, "Spawner", function()
    MachoMenuSetVisible(MainMenu, false)
    MachoMenuSetVisible(SpawnerSection, true)
end)

MachoMenuButton(MainMenu, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ============================
-- Self Section
-- ============================
SelfSection = MachoMenuGroup(MenuWindow, "Self Options", PanelStart.x, PanelStart.y, PanelEnd.x, PanelEnd.y)
MachoMenuSetVisible(SelfSection, false)

MachoMenuButton(SelfSection, "Godmode", function()
    SetEntityInvincible(PlayerPedId(), true)
    print("Godmode Enabled")
end)

MachoMenuButton(SelfSection, "Revive", function()
    local ped = PlayerPedId()
    ResurrectPed(ped)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedTasksImmediately(ped)
end)

MachoMenuButton(SelfSection, "Suicide", function()
    SetEntityHealth(PlayerPedId(), 0)
end)

MachoMenuButton(SelfSection, "Back", function()
    MachoMenuSetVisible(SelfSection, false)
    MachoMenuSetVisible(MainMenu, true)
end)

-- ============================
-- Teleport Section
-- ============================
TeleportSection = MachoMenuGroup(MenuWindow, "Teleport Options", PanelStart.x, PanelStart.y, PanelEnd.x, PanelEnd.y)
MachoMenuSetVisible(TeleportSection, false)

MachoMenuButton(TeleportSection, "TP to Waypoint", function()
    local blipMarker = GetFirstBlipInfoId(8)
    if DoesBlipExist(blipMarker) then
        local coord = GetBlipInfoIdCoord(blipMarker)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z, false, false, false, true)
    else
        print("No waypoint set")
    end
end)

MachoMenuButton(TeleportSection, "TP to Legion Square", function()
    SetEntityCoords(PlayerPedId(), 215.76, -810.12, 30.73, false, false, false, true)
end)

MachoMenuButton(TeleportSection, "Back", function()
    MachoMenuSetVisible(TeleportSection, false)
    MachoMenuSetVisible(MainMenu, true)
end)

-- ============================
-- Spawner Section
-- ============================
SpawnerSection = MachoMenuGroup(MenuWindow, "Spawner Options", PanelStart.x, PanelStart.y, PanelEnd.x, PanelEnd.y)
MachoMenuSetVisible(SpawnerSection, false)

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

MachoMenuButton(SpawnerSection, "Back", function()
    MachoMenuSetVisible(SpawnerSection, false)
    MachoMenuSetVisible(MainMenu, true)
end)

-- ============================
-- Open/Close with F2
-- ============================
MachoMenuSetVisible(MenuWindow, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 289) then -- F2
            local state = MachoMenuGetVisible(MenuWindow)
            MachoMenuSetVisible(MenuWindow, not state)
        end
    end
end)

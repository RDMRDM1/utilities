local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500) 

local TabsBarWidth = 0
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 3 
local SectionsPadding = 10 
local MachoPaneGap = 10 

local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Calculate section positions
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create menu window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)

-- ============================
-- First Section (Main Options)
-- ============================
FirstSection = MachoMenuGroup(MenuWindow, "Util.lua", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

MachoMenuButton(FirstSection, "Self: Godmode", function()
    SetEntityInvincible(PlayerPedId(), true)
    print("Godmode Enabled")
end)

MachoMenuButton(FirstSection, "Self: Revive", function()
    local ped = PlayerPedId()
    ResurrectPed(ped)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedTasksImmediately(ped)
    print("Revived")
end)

MachoMenuButton(FirstSection, "Self: Suicide", function()
    SetEntityHealth(PlayerPedId(), 0)
    print("Player Suicided")
end)

MachoMenuButton(FirstSection, "Self: Clear Tasks", function()
    ClearPedTasksImmediately(PlayerPedId())
    print("Tasks Cleared")
end)

-- ============================
-- Second Section (Spawner)
-- ============================
SecondSection = MachoMenuGroup(MenuWindow, "Spawner", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

MachoMenuButton(SecondSection, "Spawn Adder", function()
    local model = GetHashKey("adder")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    print("Spawned Adder")
end)

MachoMenuButton(SecondSection, "Spawn Buzzard", function()
    local model = GetHashKey("buzzard")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    print("Spawned Buzzard")
end)

-- ============================
-- Third Section (Teleport)
-- ============================
ThirdSection = MachoMenuGroup(MenuWindow, "Teleport", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

MachoMenuButton(ThirdSection, "TP to Waypoint", function()
    local blipMarker = GetFirstBlipInfoId(8) -- waypoint blip
    if DoesBlipExist(blipMarker) then
        local coord = GetBlipInfoIdCoord(blipMarker)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z, false, false, false, true)
        print("Teleported to Waypoint")
    else
        print("No waypoint set")
    end
end)

MachoMenuButton(ThirdSection, "TP to Legion Square", function()
    SetEntityCoords(PlayerPedId(), 215.76, -810.12, 30.73, false, false, false, true)
    print("Teleported to Legion Square")
end)

MachoMenuButton(ThirdSection, "Print Coords", function()
    local coords = GetEntityCoords(PlayerPedId())
    print(("Coords: %.2f, %.2f, %.2f"):format(coords.x, coords.y, coords.z))
end)

-- ============================
-- Open/Close with Caps Lock
-- ============================
MachoMenuSetVisible(MenuWindow, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 137) then -- Caps Lock
            local state = MachoMenuGetVisible(MenuWindow)
            MachoMenuSetVisible(MenuWindow, not state)
        end
    end
end)

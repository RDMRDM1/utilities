local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 0, 0) -- Red accent

local SectionOne = MachoMenuGroup(MenuWindow, "Tabs", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
local SectionTwo = MachoMenuGroup(MenuWindow, "MainContentLeft", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
local SectionThree = MachoMenuGroup(MenuWindow, "MainContentRight", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

local tabs = {"Self", "Server", "Teleport", "Weapon", "Vehicle", "Animations", "Triggers", "Settings"}
local selectedTab = 1

local function clearGroup(group)
    -- Clear previous menu items in group
    -- Depends on Macho API - pseudo code function here
    -- You may need to destroy and recreate group in Macho
end

local function buildContent()
    clearGroup(SectionTwo)
    clearGroup(SectionThree)

    if selectedTab == 1 then -- Self Tab Example
        MachoMenuText(SectionTwo, "Self Tab - Player Options")
        MachoMenuCheckbox(SectionTwo, "Godmode", function() SetEntityInvincible(PlayerPedId(), true) SetPlayerInvincible(PlayerId(), true) end, function() SetEntityInvincible(PlayerPedId(), false) SetPlayerInvincible(PlayerId(), false) end)
        -- Add all other checkboxes/buttons similarly...

        MachoMenuText(SectionThree, "Misc Options")
        local modelInput = MachoMenuInputbox(SectionThree, "Model Changer", "Enter model")
        MachoMenuButton(SectionThree, "Change Model", function()
            local model = MachoMenuGetInputbox(modelInput)
            if IsModelValid(GetHashKey(model)) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
                SetPlayerModel(PlayerId(), GetHashKey(model))
                SetModelAsNoLongerNeeded(GetHashKey(model))
            end
        end)
        -- Add rest right panel options
    elseif selectedTab == 5 then -- Vehicle Tab Example
        MachoMenuText(SectionTwo, "Vehicle Options")
        MachoMenuCheckbox(SectionTwo, "Vehicle Godmode", function() TriggerEvent("macho:VehicleGodmodeToggle", true) end, function() TriggerEvent("macho:VehicleGodmodeToggle", false) end)
        -- Add all vehicle toggles/buttons...

        MachoMenuText(SectionThree, "Spawn Vehicle")
        local vehicleInput = MachoMenuInputbox(SectionThree, "Vehicle Model", "Enter model")
        MachoMenuButton(SectionThree, "Spawn Vehicle", function()
            local model = MachoMenuGetInputbox(vehicleInput)
            if IsModelValid(GetHashKey(model)) then
                RequestModel(GetHashKey(model))
                while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
                local pos = GetEntityCoords(PlayerPedId())
                local veh = CreateVehicle(GetHashKey(model), pos.x + 3, pos.y + 3, pos.z, GetEntityHeading(PlayerPedId()), true, false)
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
                SetModelAsNoLongerNeeded(GetHashKey(model))
            end
        end)
    else
        MachoMenuText(SectionTwo, "Tab "..tabs[selectedTab].." content coming soon!")
        MachoMenuText(SectionThree, "")
    end
end

for i, name in ipairs(tabs) do
    MachoMenuButton(SectionOne, name, function()
        selectedTab = i
        buildContent()
    end)
end

buildContent()

MachoMenuButton(SectionOne, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

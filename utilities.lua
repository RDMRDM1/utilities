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

local tabs = {"Player", "Server", "Teleport", "Weapon", "Vehicle", "Animations", "Triggers", "Settings"}
local selectedTab = 1

local function clearPanels()
  -- Depending on Macho API, clear existing content here
  -- Placeholder: might destroy and recreate groups or reset state
end

local function selectTab(index)
  selectedTab = index
  clearPanels()

  if index == 1 then -- Player Tab
    MachoMenuText(LeftPanel, "Player Options")
    MachoMenuCheckbox(LeftPanel, "Godmode",
      function() SetEntityInvincible(playerPed, true) SetPlayerInvincible(playerId, true) end,
      function() SetEntityInvincible(playerPed, false) SetPlayerInvincible(playerId, false) end)
    MachoMenuCheckbox(LeftPanel, "Invisibility",
      function() SetEntityVisible(playerPed, false, false) end,
      function() SetEntityVisible(playerPed, true, false) end)
    -- Other toggles ...

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
    MachoMenuButton(RightPanel, "Heal", function() SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed)) end)
    MachoMenuButton(RightPanel, "Armor", function() SetPedArmour(playerPed, 100) end)
    MachoMenuButton(RightPanel, "Revive", function() NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), true, true, false) ClearPedTasksImmediately(playerPed) end)
    MachoMenuButton(RightPanel, "Suicide", function() SetEntityHealth(playerPed, 0) end)

  elseif index == 5 then -- Vehicle Tab
    MachoMenuText(LeftPanel, "Vehicle Options")
    MachoMenuCheckbox(LeftPanel, "Vehicle Godmode",
      function() TriggerEvent("macho:VehicleGodmodeToggle", true) end,
      function() TriggerEvent("macho:VehicleGodmodeToggle", false) end)
    MachoMenuCheckbox(LeftPanel, "Rainbow Vehicle",
      function() TriggerEvent("macho:RainbowVehicle", true) end,
      function() TriggerEvent("macho:RainbowVehicle", false) end)

    MachoMenuText(RightPanel, "Vehicle Spawn")
    local vehicleInput = MachoMenuInputbox(RightPanel, "Vehicle Model", "Enter vehicle model")
    MachoMenuButton(RightPanel, "Spawn Vehicle", function()
      local vehName = MachoMenuGetInputbox(vehicleInput)
      if IsModelValid(GetHashKey(vehName)) then
        RequestModel(GetHashKey(vehName))
        while not HasModelLoaded(GetHashKey(vehName)) do Citizen.Wait(10) end
        local pos = GetEntityCoords(playerPed)
        local vehicle = CreateVehicle(GetHashKey(vehName), pos.x + 3, pos.y + 3, pos.z, GetEntityHeading(playerPed), true, false)
        SetPedIntoVehicle(playerPed, vehicle, -1)
        SetModelAsNoLongerNeeded(GetHashKey(vehName))
      end
    end)

    -- Other Vehicle controls...

  else
    -- Implement other tabs similarly or add placeholder messages:
    MachoMenuText(LeftPanel, "Tab " .. tabs[index] .. " features coming soon!")
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

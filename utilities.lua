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

local isNoClipActive = false

-- No Clip toggle event handler placeholder
RegisterNetEvent("macho:EnableNoClip")
AddEventHandler("macho:EnableNoClip", function(enabled)
  isNoClipActive = enabled
  -- You need to implement your actual NoClip logic here.
  -- Example: enable free flight, disable collisions, show visual indicator, etc.
  print("NoClip toggled: ", isNoClipActive)
end)

-- Bind key "U" to toggle NoClip
RegisterCommand("toggleNoClip", function()
  isNoClipActive = not isNoClipActive
  TriggerEvent("macho:EnableNoClip", isNoClipActive)
end, false)
RegisterKeyMapping("toggleNoClip", "Toggle NoClip", "keyboard", "U")

local function clearPanels()
  -- Placeholder: depends on Macho API. Must clear previous menu items when switching tabs.
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
      function() 
        isNoClipActive = true
        TriggerEvent("macho:EnableNoClip", true)
      end,
      function()
        isNoClipActive = false
        TriggerEvent("macho:EnableNoClip", false)
      end)
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
    MachoMenuButton(RightPanel, "Heal", function() SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed)) end)
    MachoMenuButton(RightPanel, "Armor", function() SetPedArmour(playerPed, 100) end)
    MachoMenuButton(RightPanel, "Revive", function() NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), true, true, false) ClearPedTasksImmediately(playerPed) end)
    MachoMenuButton(RightPanel, "Suicide", function() SetEntityHealth(playerPed, 0) end)
    MachoMenuButton(RightPanel, "Clear Task", function() ClearPedTasksImmediately(playerPed) end)
    MachoMenuButton(RightPanel, "Clear Vision", function() ClearTimecycleModifier() end)
    MachoMenuButton(RightPanel, "Randomize Outfit", function() TriggerEvent("macho:RandomizeOutfit") end)

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

    -- Add other vehicle buttons/toggles here

  else
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

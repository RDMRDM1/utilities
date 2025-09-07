local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(300, 200)
local SidebarWidth = 140
local PanelGap = 12
local PanelWidth = (MenuSize.x - SidebarWidth - PanelGap) / 2

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0) -- Blue accent

local SidebarGroup = MachoMenuGroup(MenuWindow, "Menu", 0, 0, SidebarWidth, MenuSize.y)
local LeftPanel = MachoMenuGroup(MenuWindow, "LeftPanel", SidebarWidth + PanelGap, 0, SidebarWidth + PanelGap + PanelWidth, MenuSize.y)
local RightPanel = MachoMenuGroup(MenuWindow, "RightPanel", SidebarWidth + PanelGap + PanelWidth + PanelGap, 0, MenuSize.x, MenuSize.y)

local playerPed = PlayerPedId()
local playerId = PlayerId()

local selectedTab = 1
local tabs = {
  "Player", "Server", "Teleport", "Weapon",
  "Vehicle", "Animations", "Triggers", "Settings"
}

local function selectTab(index)
  selectedTab = index
  -- TODO: Clear and refresh panels for newly selected tab if needed
end

for i, tabName in ipairs(tabs) do
  MachoMenuButton(SidebarGroup, tabName, function()
    selectTab(i)
  end)
end

-- Define repeated toggle helpers
local function checkbox(label, onEnable, onDisable)
  MachoMenuCheckbox(LeftPanel, label, onEnable, onDisable)
end

local function button(label, onClick)
  MachoMenuButton(RightPanel, label, onClick)
end

-- Player Tab (selectedTab == 1)
if selectedTab == 1 then
  MachoMenuText(LeftPanel, "Player Options")
  checkbox("Godmode", function()
    SetEntityInvincible(playerPed, true)
    SetPlayerInvincible(playerId, true)
  end, function()
    SetEntityInvincible(playerPed, false)
    SetPlayerInvincible(playerId, false)
  end)
  checkbox("Invisibility", function()
    SetEntityVisible(playerPed, false, false)
  end, function()
    SetEntityVisible(playerPed, true, false)
  end)
  checkbox("No Ragdoll", function()
    SetPedCanRagdoll(playerPed, false)
  end, function()
    SetPedCanRagdoll(playerPed, true)
  end)
  checkbox("Infinite Stamina", function()
    SetPlayerUnlimitedStamina(playerId, true)
  end, function()
    SetPlayerUnlimitedStamina(playerId, false)
  end)
  checkbox("Tiny Ped", function()
    SetEntityScale(playerPed, 0.5)
  end, function()
    SetEntityScale(playerPed, 1.0)
  end)
  checkbox("No Clip", function()
    TriggerEvent("macho:EnableNoClip", true)
  end, function()
    TriggerEvent("macho:EnableNoClip", false)
  end)
  checkbox("Free Camera", function()
    TriggerEvent("macho:EnableFreeCam", true)
  end, function()
    TriggerEvent("macho:EnableFreeCam", false)
  end)
  checkbox("Super Jump", function()
    SetSuperJumpThisFrame(playerId)
  end, function()
    -- auto-disable, no native toggle off needed
  end)
  checkbox("Super Punch", function()
    -- Example: spawn special weapon or buff player, placeholder
    TriggerEvent("macho:EnableSuperPunch", true)
  end, function()
    TriggerEvent("macho:EnableSuperPunch", false)
  end)
  checkbox("Force Third Person", function()
    SetFollowPedCamViewMode(1)
  end, function()
    SetFollowPedCamViewMode(0)
  end)
  checkbox("Force Driveby", function()
    SetPlayerCanDoDriveBy(playerId, true)
  end, function()
    SetPlayerCanDoDriveBy(playerId, false)
  end)
  checkbox("Anti-Headshot", function()
    TriggerEvent("macho:AntiHeadshotEnable", true)
  end, function()
    TriggerEvent("macho:AntiHeadshotEnable", false)
  end)
  checkbox("Anti-Freeze", function()
    TriggerEvent("macho:AntiFreezeEnable", true)
  end, function()
    TriggerEvent("macho:AntiFreezeEnable", false)
  end)
  checkbox("Anti-Blackscreen", function()
    TriggerEvent("macho:AntiBlackScreenEnable", true)
  end, function()
    TriggerEvent("macho:AntiBlackScreenEnable", false)
  end)

  button("Max Health / Armor", function()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    SetPedArmour(playerPed, 100)
  end)
  button("Revive", function()
    NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), true, true, false)
    ClearPedTasksImmediately(playerPed)
  end)
  button("Suicide", function()
    SetEntityHealth(playerPed, 0)
  end)
  button("Clear Task", function()
    ClearPedTasksImmediately(playerPed)
  end)
  button("Clear Vision", function()
    ClearTimecycleModifier()
  end)
  button("Randomize Outfit", function()
    TriggerEvent("macho:RandomizeOutfit") -- Custom event; implement according to your server
  end)

  local modelInput = MachoMenuInputbox(RightPanel, "Model Changer", "Enter model name")
  button("Change Model", function()
    local model = MachoMenuGetInputbox(modelInput)
    -- Ensure model is loaded, then set player's model:
    if IsModelValid(GetHashKey(model)) then
      RequestModel(GetHashKey(model))
      while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
      SetPlayerModel(PlayerId(), GetHashKey(model))
      SetModelAsNoLongerNeeded(GetHashKey(model))
    end
  end)
end

-- Implement similarly with working natives / triggers for all rest tabs:
-- Server, Teleport, Weapon, Vehicle, Animations, Triggers, Settings
-- Each function should use FL natives and Macho-custom events for actual cheat effects!

-- Close menu button always available
MachoMenuButton(SidebarGroup, "Close Menu", function()
  MachoMenuDestroy(MenuWindow)
end)


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

local MenuWindow
local SectionOneGroup
local SectionTwoGroup
local SectionThreeGroup

local selectedTab = 1  -- We focus on Self tab so default

local playerPed = PlayerPedId()
local playerId = PlayerId()
local noclipActive = false

local function destroyMenu()
  if MenuWindow then
    MachoMenuDestroy(MenuWindow)
    MenuWindow = nil
  end
end

local function createMenu()
  destroyMenu() -- clear old if any

  MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
  MachoMenuSetAccent(MenuWindow, 255, 0, 0) -- red accent

  SectionOneGroup = MachoMenuGroup(MenuWindow, "Tabs", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
  SectionTwoGroup = MachoMenuGroup(MenuWindow, "Player Options", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
  SectionThreeGroup = MachoMenuGroup(MenuWindow, "Miscellaneous", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

  -- SectionOne: Single "Self" tab because focusing on self only here
  MachoMenuButton(SectionOneGroup, "Self", function()
    -- Could reload self tab content if you want
  end)

  buildSelfTab()

  -- Close button
  MachoMenuButton(SectionOneGroup, "Close Menu", function()
    destroyMenu()
  end)
end

function buildSelfTab()
  -- Clear and recreate left and right panels to refresh content
  if SectionTwoGroup then MachoMenuDestroyGroup(SectionTwoGroup) end
  if SectionThreeGroup then MachoMenuDestroyGroup(SectionThreeGroup) end

  -- Recreate groups
  SectionTwoGroup = MachoMenuGroup(MenuWindow, "Player Options", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
  SectionThreeGroup = MachoMenuGroup(MenuWindow, "Miscellaneous", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

  -- Left panel: Player Options
  MachoMenuText(SectionTwoGroup, "Player Options")

  MachoMenuCheckbox(SectionTwoGroup, "Godmode",
    function() SetEntityInvincible(playerPed, true) SetPlayerInvincible(playerId, true) end,
    function() SetEntityInvincible(playerPed, false) SetPlayerInvincible(playerId, false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Invisibility",
    function() SetEntityVisible(playerPed, false, false) end,
    function() SetEntityVisible(playerPed, true, false) end)

  MachoMenuCheckbox(SectionTwoGroup, "No Ragdoll",
    function() SetPedCanRagdoll(playerPed, false) end,
    function() SetPedCanRagdoll(playerPed, true) end)

  MachoMenuCheckbox(SectionTwoGroup, "Infinite Stamina",
    function() SetPlayerUnlimitedStamina(playerId, true) end,
    function() SetPlayerUnlimitedStamina(playerId, false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Tiny Ped",
    function() SetEntityScale(playerPed, 0.5) end,
    function() SetEntityScale(playerPed, 1.0) end)

  MachoMenuCheckbox(SectionTwoGroup, "No Clip",
    function()
      noclipActive = true
      TriggerEvent("macho:EnableNoClip", true)
    end,
    function()
      noclipActive = false
      TriggerEvent("macho:EnableNoClip", false)
    end)

  MachoMenuCheckbox(SectionTwoGroup, "Free Camera",
    function() TriggerEvent("macho:EnableFreeCam", true) end,
    function() TriggerEvent("macho:EnableFreeCam", false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Super Jump", function() SetSuperJumpThisFrame(playerId) end, function() end)

  MachoMenuCheckbox(SectionTwoGroup, "Super Punch",
    function() TriggerEvent("macho:EnableSuperPunch", true) end,
    function() TriggerEvent("macho:EnableSuperPunch", false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Force Third Person",
    function() SetFollowPedCamViewMode(1) end,
    function() SetFollowPedCamViewMode(0) end)

  MachoMenuCheckbox(SectionTwoGroup, "Force Driveby",
    function() SetPlayerCanDoDriveBy(playerId, true) end,
    function() SetPlayerCanDoDriveBy(playerId, false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Anti-Headshot",
    function() TriggerEvent("macho:AntiHeadshotEnable", true) end,
    function() TriggerEvent("macho:AntiHeadshotEnable", false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Anti-Freeze",
    function() TriggerEvent("macho:AntiFreezeEnable", true) end,
    function() TriggerEvent("macho:AntiFreezeEnable", false) end)

  MachoMenuCheckbox(SectionTwoGroup, "Anti-Blackscreen",
    function() TriggerEvent("macho:AntiBlackScreenEnable", true) end,
    function() TriggerEvent("macho:AntiBlackScreenEnable", false) end)

  -- Right panel: Misc Options
  MachoMenuText(SectionThreeGroup, "Miscellaneous")

  local modelInput = MachoMenuInputbox(SectionThreeGroup, "Model Changer", "Enter model name")
  MachoMenuButton(SectionThreeGroup, "Change Model", function()
    local model = MachoMenuGetInputbox(modelInput)
    if IsModelValid(GetHashKey(model)) then
      RequestModel(GetHashKey(model))
      while not HasModelLoaded(GetHashKey(model)) do Citizen.Wait(10) end
      SetPlayerModel(playerId, GetHashKey(model))
      SetModelAsNoLongerNeeded(GetHashKey(model))
    end
  end)

  MachoMenuButton(SectionThreeGroup, "Max Health / Armor", function()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    SetPedArmour(playerPed, 100)
  end)

  MachoMenuButton(SectionThreeGroup, "Revive", function()
    NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), true, true, false)
    ClearPedTasksImmediately(playerPed)
  end)

  MachoMenuButton(SectionThreeGroup, "Suicide", function()
    SetEntityHealth(playerPed, 0)
  end)

  MachoMenuButton(SectionThreeGroup, "Clear Task", function()
    ClearPedTasksImmediately(playerPed)
  end)

  MachoMenuButton(SectionThreeGroup, "Clear Vision", function()
    ClearTimecycleModifier()
  end)

  MachoMenuButton(SectionThreeGroup, "Randomize Outfit", function()
    TriggerEvent("macho:RandomizeOutfit")
  end)

  -- Example keybinding in this tab to toggle No Clip with key "U"
  MachoMenuKeybind(SectionTwoGroup, "Toggle NoClip (U)", 0x55, function(key, toggle)  -- 0x55 is VK_U
    noclipActive = toggle
    TriggerEvent("macho:EnableNoClip", toggle)
  end)
end

-- Open/close menu on Caps Lock (VK_CAPITAL 0x14)
local menuOpen = false

RegisterCommand("toggleMachoMenu", function()
  if menuOpen then
    destroyMenu()
    menuOpen = false
  else
    createMenu()
    menuOpen = true
  end
end, false)

RegisterKeyMapping("toggleMachoMenu", "Toggle Macho Menu (Caps Lock)", "keyboard", "CAPITAL")

local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(300, 200)

local SidebarWidth = 140
local PanelGap = 12
local PanelWidth = (MenuSize.x - SidebarWidth - PanelGap) / 2

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 0, 120, 255) -- Blue accent

-- Sidebar Group (Tabbed buttons)
local SidebarGroup = MachoMenuGroup(MenuWindow, "Menu", 0, 0, SidebarWidth, MenuSize.y)

local tabs = {
  "Player", "Server", "Teleport", "Weapon",
  "Vehicle", "Emotes", "Events", "Settings"
}

local selectedTab = 1

local function selectTab(index)
  selectedTab = index
  -- Logic to refresh visibility could go here if needed
end

for i, tabName in ipairs(tabs) do
  MachoMenuButton(SidebarGroup, tabName, function()
    selectTab(i)
  end)
end

-- Left panel and right panel (content)
local LeftPanel = MachoMenuGroup(MenuWindow, "LeftPanel", SidebarWidth + PanelGap, 0, SidebarWidth + PanelGap + PanelWidth, MenuSize.y)
local RightPanel = MachoMenuGroup(MenuWindow, "RightPanel", SidebarWidth + PanelGap + PanelWidth + PanelGap, 0, MenuSize.x, MenuSize.y)

-- Scrollable container note: Add scroll logic if Macho supports or repeat menu creation on tab switch.

-- === Player Tab Example ===
if selectedTab == 1 then
  -- Left Panel Controls (toggles)
  MachoMenuText(LeftPanel, "Player Options")
  MachoMenuCheckbox(LeftPanel, "Godmode", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Invisibility", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "No Ragdoll", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Infinite Stamina", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Freecam", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "No Clip", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Fly", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Super Punch", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Super Strength", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Super Jump", function() end, function() end)
  MachoMenuCheckbox(LeftPanel, "Throw People From Vehicle", function() end, function() end)

  -- Right Panel Controls (sliders & buttons)
  MachoMenuText(RightPanel, "Misc")
  MachoMenuSlider(RightPanel, "Health Amount", 100, 0, 100, "%", 1, function(value)
    -- Implement health percentage set here
  end)
  MachoMenuSlider(RightPanel, "Armor Amount", 100, 0, 100, "%", 1, function(value)
    -- Implement armor percentage set here
  end)
  local modelInput = MachoMenuInputbox(RightPanel, "Model Changer", "...")
  MachoMenuButton(RightPanel, "Change Model", function()
    local model = MachoMenuGetInputbox(modelInput)
    -- Change model logic here
  end)
  MachoMenuButton(RightPanel, "Heal", function() end)
  MachoMenuButton(RightPanel, "Armor", function() end)
  MachoMenuButton(RightPanel, "Revive", function() end)
  MachoMenuButton(RightPanel, "Native Revive", function() end)
  MachoMenuButton(RightPanel, "Suicide", function() end)
  MachoMenuButton(RightPanel, "Clear Task", function() end)
end

-- Add similar conditional blocks for tabs 2 to 8 with their respective options as previously detailed

-- Close button always visible on left
MachoMenuButton(SidebarGroup, "Close Menu", function()
  MachoMenuDestroy(MenuWindow)
end)

local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(300, 200)

local SidebarWidth = 140
local PanelGap = 12
local PanelWidth = (MenuSize.x - SidebarWidth - PanelGap) / 2

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 0, 120, 255) -- Blue accent

local SidebarGroup = MachoMenuGroup(MenuWindow, "Menu", 0, 0, SidebarWidth, MenuSize.y)

local tabs = {
  "Player", "Server", "Teleport", "Weapon",
  "Vehicle", "Emotes", "Events", "Settings"
}

local selectedTab = 1

-- We'll store LeftPanel and RightPanel groups here so we can destroy and recreate on tab change
local LeftPanelGroup
local RightPanelGroup

-- Clear and recreate panel groups with new content on tab change
local function buildPanels()
  -- Destroy previous if exists
  if LeftPanelGroup then MachoMenuDestroyGroup(LeftPanelGroup) end
  if RightPanelGroup then MachoMenuDestroyGroup(RightPanelGroup) end

  -- Create new groups for panels
  LeftPanelGroup = MachoMenuGroup(MenuWindow, "LeftPanel", SidebarWidth + PanelGap, 0, SidebarWidth + PanelGap + PanelWidth, MenuSize.y)
  RightPanelGroup = MachoMenuGroup(MenuWindow, "RightPanel", SidebarWidth + PanelGap + PanelWidth + PanelGap, 0, MenuSize.x, MenuSize.y)

  -- Build content depending on selected tab
  if selectedTab == 1 then -- Player tab
    MachoMenuText(LeftPanelGroup, "Player Options")
    MachoMenuCheckbox(LeftPanelGroup, "Godmode",
      function() print("Godmode on") end,
      function() print("Godmode off") end
    )
    -- Add other player checkboxes/buttons as needed

    MachoMenuText(RightPanelGroup, "Misc Options")
    local modelInput = MachoMenuInputbox(RightPanelGroup, "Model Changer", "...")
    MachoMenuButton(RightPanelGroup, "Change Model", function()
      local model = MachoMenuGetInputbox(modelInput)
      print("Change Model to "..model)
      -- Add real implementation here
    end)
    -- Add other right panel buttons
  elseif selectedTab == 2 then
    MachoMenuText(LeftPanelGroup, "Server Options")
    MachoMenuButton(LeftPanelGroup, "Kill Player", function() print("Kill Player") end)
    -- Similarly add rest buttons for server tab
  end

  -- Add similar blocks for other tabs...
end

local function selectTab(index)
  selectedTab = index
  buildPanels()
end

for i, tabName in ipairs(tabs) do
  MachoMenuButton(SidebarGroup, tabName, function()
    selectTab(i)
  end)
end

-- Build initial panel on menu load
buildPanels()

-- Close button always visible
MachoMenuButton(SidebarGroup, "Close Menu", function()
  MachoMenuDestroy(MenuWindow)
end)

local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Calculate section rectangles
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local MenuWindow = MachoMenuTabbedWindow('Nigga', 400, 400, 400, 100, 100, 120)
MachoMenuSetAccent(MenuWindow, 0, 120, 255)

local SectionOneGroup = MachoMenuGroup(MenuWindow, "SectionOne", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
local SectionTwoGroup = MachoMenuGroup(MenuWindow, "SectionTwo", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
local SectionThreeGroup = MachoMenuGroup(MenuWindow, "SectionThree", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

-- Example filling in SectionOne with tab buttons to act as menu tabs
local tabs = {
  "Self", "Server", "Teleport", "Weapon", "Vehicle", "Animations", "Triggers", "Settings"
}
local selectedTab = 1

local function clearGroup(group)
  -- Destroy or clear all existing controls in the group for refresh
  MachoMenuDestroyGroup(group)
end

local function rebuildContent()
  clearGroup(SectionTwoGroup)
  clearGroup(SectionThreeGroup)

  if selectedTab == 1 then -- Self tab controls example
    MachoMenuText(SectionTwoGroup, "Player Options")
    MachoMenuCheckbox(SectionTwoGroup, "Godmode",
      function() print("Godmode enabled") end,
      function() print("Godmode disabled") end)
    -- more checkboxes here...

    MachoMenuText(SectionThreeGroup, "Misc Options")
    local modelInput = MachoMenuInputbox(SectionThreeGroup, "Model Changer", "Enter model")
    MachoMenuButton(SectionThreeGroup, "Change Model", function()
      local model = MachoMenuGetInputbox(modelInput)
      print("Change Model to: "..model)
    end)
  elseif selectedTab == 5 then -- Vehicle tab example
    MachoMenuText(SectionTwoGroup, "Vehicle Options")
    MachoMenuCheckbox(SectionTwoGroup, "Vehicle Godmode", function() print("Veh Godmode on") end, function() print("Veh Godmode off") end)
    -- more options...

    MachoMenuText(SectionThreeGroup, "Vehicle Spawn")
    local vehicleInput = MachoMenuInputbox(SectionThreeGroup, "Vehicle Model", "Enter vehicle model")
    MachoMenuButton(SectionThreeGroup, "Spawn Vehicle", function()
      local model = MachoMenuGetInputbox(vehicleInput)
      print("Spawn Vehicle model: "..model)
    end)
  else
    MachoMenuText(SectionTwoGroup, "Tab "..tabs[selectedTab].." content coming soon.")
  end
end

for i, tabName in ipairs(tabs) do
  MachoMenuButton(SectionOneGroup, tabName, function()
    selectedTab = i
    rebuildContent()
  end)
end

rebuildContent()

MachoMenuButton(SectionOneGroup, "Close Menu", function()
  MachoMenuDestroy(MenuWindow)
end)

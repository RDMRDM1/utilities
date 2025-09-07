--========================================================
                 -- UTILITIES.LUA --
--========================================================

local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 90
local SectionsPadding = 10
local MachoPaneGap = 10
local TabNames = {"Self", "Server", "Teleport", "Weapon", "Vehicle", "Animations", "Triggers", "Settings"}

local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)

local function makeTab(tabName, xStart, yStart, xEnd, yEnd)
    return MachoMenuGroup(MenuWindow, tabName, xStart, yStart, xEnd, yEnd)
end

-- Calculating per-section coordinates dynamically for eight tabs
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = #TabNames
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local TabSections = {}
for i, name in ipairs(TabNames) do
    local x1 = TabsBarWidth + (SectionsPadding * i) + (EachSectionWidth * (i - 1))
    local y1 = SectionsPadding + MachoPaneGap
    local x2 = x1 + EachSectionWidth
    local y2 = MenuSize.y - SectionsPadding
    TabSections[i] = makeTab(name, x1, y1, x2, y2)
end

-- ######################### SELF TAB #########################
local selfTab = TabSections[1]

MachoMenuCheckbox(selfTab, "Godmode/Invincibility", function() -- on enable
    -- logic here
end, function() -- on disable
    -- logic here
end)
MachoMenuCheckbox(selfTab, "Invisibility", function() end, function() end)
MachoMenuCheckbox(selfTab, "No Ragdoll", function() end, function() end)
MachoMenuCheckbox(selfTab, "Infinite Stamina", function() end, function() end)
MachoMenuCheckbox(selfTab, "Tiny Ped", function() end, function() end)
MachoMenuCheckbox(selfTab, "No Clip", function() end, function() end)
MachoMenuCheckbox(selfTab, "Free Camera", function() end, function() end)
MachoMenuCheckbox(selfTab, "Super Jump", function() end, function() end)
MachoMenuCheckbox(selfTab, "Super Punch", function() end, function() end)
MachoMenuCheckbox(selfTab, "Force Third Person", function() end, function() end)
MachoMenuCheckbox(selfTab, "Force Driveby", function() end, function() end)
MachoMenuCheckbox(selfTab, "Anti-Headshot", function() end, function() end)
MachoMenuCheckbox(selfTab, "Anti-Freeze", function() end, function() end)
MachoMenuCheckbox(selfTab, "Anti-Blackscreen", function() end, function() end)
MachoMenuButton(selfTab, "Max Health/Armor", function() end)
MachoMenuButton(selfTab, "Revive", function() end)
MachoMenuButton(selfTab, "Suicide", function() end)
MachoMenuButton(selfTab, "Clear Task", function() end)
MachoMenuButton(selfTab, "Clear Vision", function() end)
MachoMenuButton(selfTab, "Randomize Outfit", function() end)
MachoMenuInputbox(selfTab, "Model Changer", "Enter model name")

-- ######################### SERVER TAB #########################
local serverTab = TabSections[2]

MachoMenuButton(serverTab, "Kill Player", function() end)
MachoMenuButton(serverTab, "Taze Player", function() end)
MachoMenuButton(serverTab, "Explode Player", function() end)
MachoMenuButton(serverTab, "Teleport To Player", function() end)
MachoMenuButton(serverTab, "Kick From Vehicle", function() end)
MachoMenuButton(serverTab, "Freeze Player", function() end)
MachoMenuButton(serverTab, "Glitch Player", function() end)
MachoMenuButton(serverTab, "Limbo Player", function() end)
MachoMenuButton(serverTab, "Copy Appearance", function() end)
MachoMenuButton(serverTab, "Spectate Player", function() end)
MachoMenuButton(serverTab, "Crash Nearby", function() end)
MachoMenuButton(serverTab, "Explode All Players", function() end)
MachoMenuButton(serverTab, "Explode All Vehicles", function() end)
MachoMenuButton(serverTab, "Delete All Vehicles", function() end)
MachoMenuButton(serverTab, "Delete All Peds", function() end)
MachoMenuButton(serverTab, "Delete All Objects", function() end)
MachoMenuButton(serverTab, "Kill All", function() end)
MachoMenuButton(serverTab, "Permanent Kill All", function() end)

-- ######################### TELEPORT TAB #########################
local teleportTab = TabSections[3]

MachoMenuInputbox(teleportTab, "Teleport To Coords", "x, y, z")
MachoMenuButton(teleportTab, "Teleport To Waypoint", function() end)
local locations = {"FIB Building", "Mission Row PD", "Pillbox Hospital", "Del Perro Pier", "Grove Street", "Legion Square",
                   "LS Customs", "Maze Bank", "Mirror Park", "Vespucci Beach", "Vinewood", "Sandy Shores"}
for _, location in ipairs(locations) do
    MachoMenuButton(teleportTab, "Teleport: "..location, function() end)
end
MachoMenuButton(teleportTab, "Print Current Coords", function() end)

-- ###### (Repeat this grouping/filling process for Weapon, Vehicle, Animations, Triggers, Settings tabs also, using the structure provided above) ######

-- Tip: For each button/checkbox, connect the logic required for FiveM via native calls or triggers.

-- Main close button
MachoMenuButton(TabSections[1], "Close", function() MachoMenuDestroy(MenuWindow) end)

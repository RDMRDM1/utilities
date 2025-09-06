-- =========================
-- Menu Settings
-- =========================
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd   = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd   = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd   = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- =========================
-- Create Menu Window (starts hidden)
-- =========================
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137)

-- Hide after a short delay to ensure MachoMenu initializes the window first
CreateThread(function()
    Wait(10) -- tiny wait for menu to initialize
    MachoMenuSetVisible(MenuWindow, false)
end)

-- =========================
-- Section One
-- =========================
local FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuSetVisible(MenuWindow, false)
end)

-- =========================
-- Section Two
-- =========================
local SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

local MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Checkbox", 
    function() print("Enabled") end,
    function() print("Disabled") end
)

local TextHandle = MachoMenuText(SecondSection, "SomeText")
MachoMenuButton(SecondSection, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- =========================
-- Section Three
-- =========================
local ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

local InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

local DropDownHandle = MachoMenuDropDown(ThirdSection, "Drop Down", 
    function(Index)
        print("New Value is " .. Index)
    end, 
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
)

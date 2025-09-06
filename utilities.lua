local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500) 

local TabsBarWidth = 0 -- width of tabs bar
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 5 -- now 5 sections
local SectionsPadding = 10
local MachoPaneGap = 10

local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Calculate start/end for each section
local SectionStarts = {}
local SectionEnds = {}
for i = 1, SectionsCount do
    SectionStarts[i] = vec2(TabsBarWidth + (SectionsPadding * i) + (EachSectionWidth * (i - 1)), SectionsPadding + MachoPaneGap)
    SectionEnds[i] = vec2(SectionStarts[i].x + EachSectionWidth, MenuSize.y - SectionsPadding)
end

-- Section names
local SectionNames = {"Player", "Server", "Teleport", "Weapon", "Vehicle"}

-- Create window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- Create all 5 sections
local Sections = {}
for i = 1, SectionsCount do
    Sections[i] = MachoMenuGroup(MenuWindow, SectionNames[i], SectionStarts[i].x, SectionStarts[i].y, SectionEnds[i].x, SectionEnds[i].y)

    -- Make section clickable even if nothing happens yet
    MachoMenuButton(Sections[i], "Click Me", function()
        print(SectionNames[i] .. " section clicked!")
    end)
end

-- Example of keeping existing features (optional)
-- Slider example in Server section (2nd section)
MenuSliderHandle = MachoMenuSlider(Sections[2], "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

-- Checkbox example in Server section
MachoMenuCheckbox(Sections[2], "Checkbox", 
    function()
        print("Enabled")
    end,
    function()
        print("Disabled")
    end
)

-- Text example in Server section
TextHandle = MachoMenuText(Sections[2], "SomeText")
MachoMenuButton(Sections[2], "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- Input box example in Third section (Teleport section)
InputBoxHandle = MachoMenuInputbox(Sections[3], "Input", "...")
MachoMenuButton(Sections[3], "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

-- Drop down example in Third section
DropDownHandle = MachoMenuDropDown(Sections[3], "Drop Down", 
    function(Index)
        print("New Value is " .. Index)
    end, 
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
)

-- Close button example in Player section (1st section)
MachoMenuButton(Sections[1], "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

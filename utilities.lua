-- =========================
-- Key Redemption System
-- =========================
local AllowedKeys = {
    "UTIL-7F9D-K2L8-1XQ3",
    "UTIL-3PZ4-V8J1-Q9H2",
    "UTIL-5M2K-T7B6-R4Y0",
    "UTIL-9G1X-W3F5-L8V7",
    "UTIL-2C8N-Q6Z9-P1R4",
    "UTIL-4H7L-J5S2-K3T8",
    "UTIL-8V0M-R1X6-D7B9",
    "UTIL-6Y3Q-P9N2-Z4C1",
    "UTIL-1K5J-T8L0-M7W3",
    "UTIL-0F2H-V4R8-S6X5"
}

-- Function to redeem key
local function RedeemKey()
    local Key = MachoMenuInput("Enter your key:") -- Example input function
    if not Key or Key == "" then
        print("No key entered!")
        return false
    end

    for i, validKey in ipairs(AllowedKeys) do
        if Key == validKey then
            print("Key redeemed successfully! [" .. Key .. "]")
            table.remove(AllowedKeys, i) -- Remove key so it cannot be reused
            return true
        end
    end

    print("Invalid key! [" .. Key .. "]")
    return false
end

-- Check key before opening menu
if not RedeemKey() then
    return -- Stop script if key invalid
end

-- =========================
-- Menu Setup
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
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)
MachoMenuSetVisible(MenuWindow, false) -- Start hidden

-- =========================
-- Section One
-- =========================
FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- =========================
-- Section Two
-- =========================
SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Checkbox", 
    function()
        print("Enabled")
    end,
    function()
        print("Disabled")
    end
)

TextHandle = MachoMenuText(SecondSection, "SomeText")

MachoMenuButton(SecondSection, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- =========================
-- Section Three
-- =========================
ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

DropDownHandle = MachoMenuDropDown(ThirdSection, "Drop Down", 
    function(Index)
        print("New Value is " .. Index)
    end, 
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
)

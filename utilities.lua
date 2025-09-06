local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(200, 200)

-- Create main window
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 200, 50, 50)
MachoMenuSetVisible(MenuWindow, false) -- start hidden

-- Sections (one per tab)
local Sections = {}

Sections["Self"] = MachoMenuGroup(MenuWindow, "Self", 20, 60, MenuSize.x - 20, MenuSize.y - 20)
Sections["Server"] = MachoMenuGroup(MenuWindow, "Server", 20, 60, MenuSize.x - 20, MenuSize.y - 20)

-- Start with only Self visible
for _, sec in pairs(Sections) do MachoMenuSetVisible(sec, false) end
MachoMenuSetVisible(Sections["Self"], true)

-- Tab buttons row
local function AddTabButton(tabName)
    MachoMenuButton(MenuWindow, tabName, function()
        for _, sec in pairs(Sections) do
            MachoMenuSetVisible(sec, false)
        end
        MachoMenuSetVisible(Sections[tabName], true)
    end)
end

AddTabButton("Self")
AddTabButton("Server")

-- Add buttons to "Self" tab
MachoMenuButton(Sections["Self"], "Godmode", function() print("Godmode") end)
MachoMenuButton(Sections["Self"], "Invisibility", function() print("Invisibility") end)

-- Add buttons to "Server" tab
MachoMenuButton(Sections["Server"], "Explode Player", function() print("Explode Player") end)
MachoMenuButton(Sections["Server"], "Freeze Player", function() print("Freeze Player") end)

-- Toggle menu with Caps Lock (137)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 137) then
            local state = MachoMenuGetVisible(MenuWindow)
            MachoMenuSetVisible(MenuWindow, not state)
        end
    end
end)

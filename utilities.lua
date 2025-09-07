--========================================================
                 -- UTILITIES.LUA --
--========================================================

-- Basic menu sizing
local MenuSize = vec2(800, 400)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Coordinates for the three columns
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd   = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd   = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd   = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create main window and set accent
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 150, 0, 0)

-- Start hidden (no keybind)
MachoMenuSetVisible(MenuWindow, false)
-- NOTE: keybind intentionally removed per request

-- Section groups
SectionOne = MachoMenuGroup(MenuWindow, "Util.lua", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
SectionTwo = MachoMenuGroup(MenuWindow, "Options", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
SectionThree = MachoMenuGroup(MenuWindow, "Status / Extras", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

-- Simple notify helper (safe placeholder - uses chat event if available)
local function Notify(msg)
    -- If you use a different notify system, replace this implementation
    if TriggerEvent then
        pcall(function() TriggerEvent("chat:addMessage", { args = { "[MENU]", msg } }) end)
    end
    print("[MENU] "..msg)
end

-- Helper to clear Section 2 + Section 3
local function ClearSections()
    -- MachoMenuClear is used in other examples; if not available replace with recreation logic
    if MachoMenuClear then
        MachoMenuClear(SectionTwo)
        MachoMenuClear(SectionThree)
    else
        -- fallback: recreate the groups (safe-if API differs)
        SectionTwo = MachoMenuGroup(MenuWindow, "Options", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
        SectionThree = MachoMenuGroup(MenuWindow, "Status / Extras", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)
    end
end

--===========================
-- Feature state variables
-- (all false by default)
--===========================
local state = {
    godmode = false,
    invisibility = false,
    no_ragdoll = false,
    infinite_stamina = false,
    tiny_ped = false,
    noclip = false,
    freecam = false,
    super_jump = false,
    super_punch = false,
    force_third = false,
    force_driveby = false,
    anti_headshot = false,
    anti_freeze = false,
    anti_blackscreen = false,
    max_health_armor = false
}

--===========================
-- Stub implementations
-- Replace these with your real logic.
-- Keep names clear: EnableX()/DisableX() or DoX().
--===========================

-- Godmode
local function EnableGodmode()
    state.godmode = true
    Notify("Godmode Enabled (placeholder)")
    print("EnableGodmode() called - replace with real logic")
end
local function DisableGodmode()
    state.godmode = false
    Notify("Godmode Disabled (placeholder)")
    print("DisableGodmode() called - replace with real logic")
end

-- Invisibility
local function EnableInvisibility()
    state.invisibility = true
    Notify("Invisibility Enabled (placeholder)")
    print("EnableInvisibility() called - replace with real logic")
end
local function DisableInvisibility()
    state.invisibility = false
    Notify("Invisibility Disabled (placeholder)")
    print("DisableInvisibility() called - replace with real logic")
end

-- No Ragdoll
local function EnableNoRagdoll()
    state.no_ragdoll = true
    Notify("No Ragdoll Enabled (placeholder)")
end
local function DisableNoRagdoll()
    state.no_ragdoll = false
    Notify("No Ragdoll Disabled (placeholder)")
end

-- Infinite Stamina
local function EnableInfiniteStamina()
    state.infinite_stamina = true
    Notify("Infinite Stamina Enabled (placeholder)")
end
local function DisableInfiniteStamina()
    state.infinite_stamina = false
    Notify("Infinite Stamina Disabled (placeholder)")
end

-- Tiny Ped
local function EnableTinyPed()
    state.tiny_ped = true
    Notify("Tiny Ped Enabled (placeholder)")
end
local function DisableTinyPed()
    state.tiny_ped = false
    Notify("Tiny Ped Disabled (placeholder)")
end

-- NoClip
local function EnableNoClip()
    state.noclip = true
    Notify("NoClip Enabled (placeholder) - replace with movement code")
end
local function DisableNoClip()
    state.noclip = false
    Notify("NoClip Disabled (placeholder)")
end

-- Freecam
local function EnableFreecam()
    state.freecam = true
    Notify("Freecam Enabled (placeholder)")
end
local function DisableFreecam()
    state.freecam = false
    Notify("Freecam Disabled (placeholder)")
end

-- Super Jump
local function EnableSuperJump()
    state.super_jump = true
    Notify("Super Jump Enabled (placeholder)")
end
local function DisableSuperJump()
    state.super_jump = false
    Notify("Super Jump Disabled (placeholder)")
end

-- Super Punch
local function EnableSuperPunch()
    state.super_punch = true
    Notify("Super Punch Enabled (placeholder)")
end
local function DisableSuperPunch()
    state.super_punch = false
    Notify("Super Punch Disabled (placeholder)")
end

-- Force Third Person
local function EnableForceThirdPerson()
    state.force_third = true
    Notify("Force Third Person Enabled (placeholder)")
end
local function DisableForceThirdPerson()
    state.force_third = false
    Notify("Force Third Person Disabled (placeholder)")
end

-- Force Driveby
local function EnableForceDriveby()
    state.force_driveby = true
    Notify("Force Driveby Enabled (placeholder)")
end
local function DisableForceDriveby()
    state.force_driveby = false
    Notify("Force Driveby Disabled (placeholder)")
end

-- Anti-Headshot
local function EnableAntiHeadshot()
    state.anti_headshot = true
    Notify("Anti-Headshot Enabled (placeholder)")
end
local function DisableAntiHeadshot()
    state.anti_headshot = false
    Notify("Anti-Headshot Disabled (placeholder)")
end

-- Anti-Freeze
local function EnableAntiFreeze()
    state.anti_freeze = true
    Notify("Anti-Freeze Enabled (placeholder)")
end
local function DisableAntiFreeze()
    state.anti_freeze = false
    Notify("Anti-Freeze Disabled (placeholder)")
end

-- Anti-Blackscreen
local function EnableAntiBlackScreen()
    state.anti_blackscreen = true
    Notify("Anti-Blackscreen Enabled (placeholder)")
end
local function DisableAntiBlackScreen()
    state.anti_blackscreen = false
    Notify("Anti-Blackscreen Disabled (placeholder)")
end

-- Max Health / Armor (toggle will just call placeholder)
local function ApplyMaxHealthArmor()
    state.max_health_armor = true
    Notify("Max Health / Armor applied (placeholder)")
end

-- Revive / Suicide (one-time actions)
local function DoRevive()
    Notify("Revive triggered (placeholder)")
end
local function DoSuicide()
    Notify("Suicide triggered (placeholder)")
end

-- Clear Task / Clear Vision
local function DoClearTaskVision()
    Notify("Clear Task / Clear Vision executed (placeholder)")
end

-- Randomize Outfit
local function DoRandomizeOutfit()
    Notify("Randomize Outfit executed (placeholder)")
end

-- Model Changer
local function DoModelChange(modelName)
    Notify("Model changed to '".. tostring(modelName) .."' (placeholder)")
end

-- Teleport placeholder functions
local function TeleportToWaypoint()
    Notify("Teleport to waypoint (placeholder)")
end
local function TeleportToCoords(x,y,z)
    Notify("Teleport to coords: ".. tostring(x) ..",".. tostring(y) ..",".. tostring(z) .." (placeholder)")
end

-- Vehicle placeholders
local function SpawnVehicle(model)
    Notify("Spawn vehicle '".. tostring(model) .."' (placeholder)")
end
local function RepairVehicle()
    Notify("Repair vehicle (placeholder)")
end
local function DeleteVehicle()
    Notify("Delete vehicle (placeholder)")
end
local function MaxUpgradesVehicle()
    Notify("Max upgrades applied to vehicle (placeholder)")
end

-- Events placeholders
local function SetWeather(name)
    Notify("Set weather to ".. tostring(name) .." (placeholder)")
end
local function SetTimeHour(hour)
    Notify("Set time to ".. tostring(hour) ..":00 (placeholder)")
end

-- Spawner placeholders
local function GiveWeapon(weaponName)
    Notify("Given weapon '".. tostring(weaponName) .."' (placeholder)")
end
local function SpawnNPC(model)
    Notify("Spawn NPC '".. tostring(model) .."' (placeholder)")
end
local function SpawnProp(model)
    Notify("Spawn prop '".. tostring(model) .."' (placeholder)")
end

-- Troll placeholders
local function DoRagdoll()
    Notify("Ragdoll (placeholder)")
end
local function DoExplode()
    Notify("Explode (placeholder)")
end
local function DoFakeFreeze()
    Notify("Fake freeze (placeholder)")
end
local function DoBlackScreen()
    Notify("Black screen (placeholder)")
end

--===========================
-- UI: Self menu with switches
--===========================
local function OpenSelfMenu()
    ClearSections()

    -- Status text handles (we use these to show current state; API dependent)
    local status_god = MachoMenuText(SectionThree, "Godmode: OFF")
    local status_invis = MachoMenuText(SectionThree, "Invisibility: OFF")
    local status_ragdoll = MachoMenuText(SectionThree, "No Ragdoll: OFF")
    local status_stamina = MachoMenuText(SectionThree, "Infinite Stamina: OFF")
    local status_tinyped = MachoMenuText(SectionThree, "Tiny Ped: OFF")
    local status_noclip = MachoMenuText(SectionThree, "NoClip: OFF")
    local status_freecam = MachoMenuText(SectionThree, "Freecam: OFF")
    local status_sj = MachoMenuText(SectionThree, "Super Jump: OFF")
    local status_sp = MachoMenuText(SectionThree, "Super Punch: OFF")
    local status_third = MachoMenuText(SectionThree, "Third Person: OFF")
    local status_driveby = MachoMenuText(SectionThree, "Driveby: OFF")

    -- Godmode checkbox
    MachoMenuCheckbox(SectionTwo, "Godmode",
        function()
            EnableGodmode()
            MachoMenuSetText(status_god, "Godmode: ON")
        end,
        function()
            DisableGodmode()
            MachoMenuSetText(status_god, "Godmode: OFF")
        end
    )

    -- Invisibility
    MachoMenuCheckbox(SectionTwo, "Invisibility",
        function()
            EnableInvisibility()
            MachoMenuSetText(status_invis, "Invisibility: ON")
        end,
        function()
            DisableInvisibility()
            MachoMenuSetText(status_invis, "Invisibility: OFF")
        end
    )

    -- No Ragdoll
    MachoMenuCheckbox(SectionTwo, "No Ragdoll",
        function()
            EnableNoRagdoll()
            MachoMenuSetText(status_ragdoll, "No Ragdoll: ON")
        end,
        function()
            DisableNoRagdoll()
            MachoMenuSetText(status_ragdoll, "No Ragdoll: OFF")
        end
    )

    -- Infinite Stamina
    MachoMenuCheckbox(SectionTwo, "Infinite Stamina",
        function()
            EnableInfiniteStamina()
            MachoMenuSetText(status_stamina, "Infinite Stamina: ON")
        end,
        function()
            DisableInfiniteStamina()
            MachoMenuSetText(status_stamina, "Infinite Stamina: OFF")
        end
    )

    -- Tiny Ped
    MachoMenuCheckbox(SectionTwo, "Tiny Ped",
        function()
            EnableTinyPed()
            MachoMenuSetText(status_tinyped, "Tiny Ped: ON")
        end,
        function()
            DisableTinyPed()
            MachoMenuSetText(status_tinyped, "Tiny Ped: OFF")
        end
    )

    -- NoClip
    MachoMenuCheckbox(SectionTwo, "NoClip",
        function()
            EnableNoClip()
            MachoMenuSetText(status_noclip, "NoClip: ON")
        end,
        function()
            DisableNoClip()
            MachoMenuSetText(status_noclip, "NoClip: OFF")
        end
    )

    -- Freecam
    MachoMenuCheckbox(SectionTwo, "Free Camera",
        function()
            EnableFreecam()
            MachoMenuSetText(status_freecam, "Freecam: ON")
        end,
        function()
            DisableFreecam()
            MachoMenuSetText(status_freecam, "Freecam: OFF")
        end
    )

    -- Super Jump
    MachoMenuCheckbox(SectionTwo, "Super Jump",
        function()
            EnableSuperJump()
            MachoMenuSetText(status_sj, "Super Jump: ON")
        end,
        function()
            DisableSuperJump()
            MachoMenuSetText(status_sj, "Super Jump: OFF")
        end
    )

    -- Super Punch
    MachoMenuCheckbox(SectionTwo, "Super Punch",
        function()
            EnableSuperPunch()
            MachoMenuSetText(status_sp, "Super Punch: ON")
        end,
        function()
            DisableSuperPunch()
            MachoMenuSetText(status_sp, "Super Punch: OFF")
        end
    )

    -- Force Third Person
    MachoMenuCheckbox(SectionTwo, "Force Third Person",
        function()
            EnableForceThirdPerson()
            MachoMenuSetText(status_third, "Third Person: ON")
        end,
        function()
            DisableForceThirdPerson()
            MachoMenuSetText(status_third, "Third Person: OFF")
        end
    )

    -- Force Driveby
    MachoMenuCheckbox(SectionTwo, "Force Driveby",
        function()
            EnableForceDriveby()
            MachoMenuSetText(status_driveby, "Driveby: ON")
        end,
        function()
            DisableForceDriveby()
            MachoMenuSetText(status_driveby, "Driveby: OFF")
        end
    )

    -- Anti-Headshot
    MachoMenuCheckbox(SectionTwo, "Anti-Headshot",
        function() EnableAntiHeadshot(); MachoMenuText(SectionThree, "Anti-Headshot: ON") end,
        function() DisableAntiHeadshot(); MachoMenuText(SectionThree, "Anti-Headshot: OFF") end
    )

    -- Anti-Freeze
    MachoMenuCheckbox(SectionTwo, "Anti-Freeze",
        function() EnableAntiFreeze(); MachoMenuText(SectionThree, "Anti-Freeze: ON") end,
        function() DisableAntiFreeze(); MachoMenuText(SectionThree, "Anti-Freeze: OFF") end
    )

    -- Anti-Blackscreen
    MachoMenuCheckbox(SectionTwo, "Anti-Blackscreen",
        function() EnableAntiBlackScreen(); MachoMenuText(SectionThree, "Anti-Blackscreen: ON") end,
        function() DisableAntiBlackScreen(); MachoMenuText(SectionThree, "Anti-Blackscreen: OFF") end
    )

    -- Max Health / Armor (one-shot)
    MachoMenuButton(SectionTwo, "Max Health / Armor", function()
        ApplyMaxHealthArmor()
        MachoMenuText(SectionThree, "Max Health / Armor: Applied")
    end)

    -- Revive / Suicide
    MachoMenuButton(SectionTwo, "Revive", function() DoRevive(); MachoMenuText(SectionThree, "Revive: Done") end)
    MachoMenuButton(SectionTwo, "Suicide", function() DoSuicide(); MachoMenuText(SectionThree, "Suicide: Done") end)

    -- Clear Task / Clear Vision
    MachoMenuButton(SectionTwo, "Clear Task / Clear Vision", function() DoClearTaskVision(); MachoMenuText(SectionThree, "Cleared") end)

    -- Randomize Outfit
    MachoMenuButton(SectionTwo, "Randomize Outfit", function() DoRandomizeOutfit(); MachoMenuText(SectionThree, "Randomized") end)

    -- Model Changer (example input + button)
    local modelInput = MachoMenuInputbox(SectionThree, "Model Name", "mp_m_freemode_01")
    MachoMenuButton(SectionThree, "Apply Model", function()
        local m = MachoMenuGetInputbox(modelInput)
        DoModelChange(m or "mp_m_freemode_01")
    end)
end

--===========================
-- Teleport menu (placeholders)
--===========================
local function OpenTeleportMenu()
    ClearSections()
    -- Status area
    MachoMenuText(SectionThree, "Teleport Status: idle")

    -- Waypoint teleport
    MachoMenuButton(SectionTwo, "Teleport to Waypoint", function()
        TeleportToWaypoint()
        MachoMenuText(SectionThree, "Teleport: waypoint (placeholder)")
    end)

    -- Teleport to coords input
    local tpInput = MachoMenuInputbox(SectionThree, "x,y,z", "0,0,72")
    MachoMenuButton(SectionThree, "Teleport", function()
        local input = MachoMenuGetInputbox(tpInput) or ""
        local x,y,z = string.match(input, "([^,]+),([^,]+),([^,]+)")
        TeleportToCoords(x or 0, y or 0, z or 72)
        MachoMenuText(SectionThree, "Teleport: "..tostring(input))
    end)
end

--===========================
-- Vehicle menu (placeholders)
--===========================
local function OpenVehicleMenu()
    ClearSections()
    MachoMenuText(SectionThree, "Vehicle Status: idle")

    local vehicleInput = MachoMenuInputbox(SectionThree, "Vehicle Model", "adder")
    MachoMenuButton(SectionTwo, "Spawn Vehicle (input)", function()
        local v = MachoMenuGetInputbox(vehicleInput) or "adder"
        SpawnVehicle(v)
        MachoMenuText(SectionThree, "Spawned: ".. tostring(v))
    end)

    MachoMenuButton(SectionTwo, "Repair Vehicle", function() RepairVehicle(); MachoMenuText(SectionThree, "Vehicle Repaired (placeholder)") end)
    MachoMenuButton(SectionTwo, "Delete Vehicle", function() DeleteVehicle(); MachoMenuText(SectionThree, "Vehicle Deleted (placeholder)") end)
    MachoMenuButton(SectionTwo, "Max Upgrades", function() MaxUpgradesVehicle(); MachoMenuText(SectionThree, "Max Upgrades Applied (placeholder)") end)
end

--===========================
-- Events menu (placeholders)
--===========================
local function OpenEventsMenu()
    ClearSections()
    MachoMenuText(SectionThree, "Events Status: idle")

    MachoMenuDropDown(SectionTwo, "Weather",
        function(Index)
            local list = {"EXTRASUNNY","RAIN","THUNDER","FOGGY","XMAS"}
            SetWeather(list[Index])
            MachoMenuText(SectionThree, "Weather set (placeholder)")
        end,
        "Sunny","Rain","Thunder","Fog","Snow"
    )

    MachoMenuSlider(SectionTwo, "Time Hour", 12, 0, 23, "h", 0, function(val)
        SetTimeHour(val)
        MachoMenuText(SectionThree, "Time set to "..val..":00")
    end)
end

--===========================
-- Spawner menu (placeholders)
--===========================
local function OpenSpawnerMenu()
    ClearSections()
    MachoMenuText(SectionThree, "Spawner Status: idle")

    local weaponDrop = MachoMenuDropDown(SectionTwo, "Give Weapon",
        function(Index)
            local list = {"WEAPON_PISTOL","WEAPON_SMG","WEAPON_CARBINERIFLE"}
            GiveWeapon(list[Index])
            MachoMenuText(SectionThree, "Given: "..list[Index])
        end,
        "Pistol","SMG","AR"
    )

    local spawnNPCInput = MachoMenuInputbox(SectionThree, "NPC Model", "a_m_m_business_01")
    MachoMenuButton(SectionThree, "Spawn NPC (input)", function()
        SpawnNPC(MachoMenuGetInputbox(spawnNPCInput) or "a_m_m_business_01")
        MachoMenuText(SectionThree, "Spawned NPC (placeholder)")
    end)

    local propInput = MachoMenuInputbox(SectionThree, "Prop Model", "prop_roadcone02a")
    MachoMenuButton(SectionThree, "Spawn Prop (input)", function()
        SpawnProp(MachoMenuGetInputbox(propInput) or "prop_roadcone02a")
        MachoMenuText(SectionThree, "Prop spawned (placeholder)")
    end)
end

--===========================
-- Troll menu (placeholders)
--===========================
local function OpenTrollMenu()
    ClearSections()
    MachoMenuText(SectionThree, "Troll Status: idle")

    MachoMenuButton(SectionTwo, "Ragdoll Self", function() DoRagdoll(); MachoMenuText(SectionThree, "Ragdoll (placeholder)") end)
    MachoMenuButton(SectionTwo, "Explode Self", function() DoExplode(); MachoMenuText(SectionThree, "Explode (placeholder)") end)
    MachoMenuButton(SectionTwo, "Fake Freeze", function() DoFakeFreeze(); MachoMenuText(SectionThree, "Fake Freeze (placeholder)") end)
    MachoMenuButton(SectionTwo, "Black Screen", function() DoBlackScreen(); MachoMenuText(SectionThree, "Black Screen (placeholder)") end)
end

--===========================
-- Main nav (Section 1) - always present
--===========================
MachoMenuButton(SectionOne, "Self", function() OpenSelfMenu() end)
MachoMenuButton(SectionOne, "Teleport", function() OpenTeleportMenu() end)
MachoMenuButton(SectionOne, "Vehicle", function() OpenVehicleMenu() end)
MachoMenuButton(SectionOne, "Events", function() OpenEventsMenu() end)
MachoMenuButton(SectionOne, "Spawner", function() OpenSpawnerMenu() end)
MachoMenuButton(SectionOne, "Troll", function() OpenTrollMenu() end)
MachoMenuButton(SectionOne, "Close Menu", function() MachoMenuDestroy(MenuWindow) end)

-- Initial state: load Self menu (optional)
OpenSelfMenu()

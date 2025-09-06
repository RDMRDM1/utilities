local scriptURL = "https://raw.githubusercontent.com/RDMRDM1/utilities/main/utilities.lua"
local menuCode = MachoWebRequest(scriptURL)
MachoIsolatedInject(menuCode)

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

-- Menu window
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- =========================
-- Utility vars
-- =========================
local selfOptions = {
    godmode = false,
    invis = false,
    noragdoll = false,
    infStamina = false,
    tinyPed = false,
    noclip = false,
    freecam = false,
    superJump = false,
    superPunch = false,
    force3rd = false,
    forceDriveby = false,
    antiHeadshot = false,
    antiFreeze = false,
    antiBlack = false,
}

local noclipSpeed = 1.5
local freecamSpeed = 1.5
local freecamCoords = nil
local freecamHeading = 0.0

-- =========================
-- Threads
-- =========================
CreateThread(function()
    while true do
        local ped = PlayerPedId()

        -- Godmode
        SetEntityInvincible(ped, selfOptions.godmode)

        -- Invisibility
        SetEntityVisible(ped, not selfOptions.invis, false)

        -- No Ragdoll
        SetPedCanRagdoll(ped, not selfOptions.noragdoll)

        -- Infinite Stamina
        if selfOptions.infStamina then
            RestorePlayerStamina(PlayerId(), 1.0)
        end

        -- Tiny Ped
        if selfOptions.tinyPed then
            SetPedScale(ped, 0.5)
        else
            SetPedScale(ped, 1.0)
        end

        -- Super Jump
        if selfOptions.superJump then
            SetSuperJumpThisFrame(PlayerId())
        end

        -- Super Punch
        if selfOptions.superPunch then
            SetExplosiveMeleeThisFrame(PlayerId())
        end

        -- Anti-Headshot
        SetPedSuffersCriticalHits(ped, not selfOptions.antiHeadshot)

        -- Handle NoClip
        if selfOptions.noclip then
            SetEntityInvincible(ped, true)
            SetEntityVisible(ped, false, false)
            SetEntityCollision(ped, false, false)

            local x, y, z = table.unpack(GetEntityCoords(ped))
            local forward = GetEntityForwardVector(ped)
            local right = vector3(-forward.y, forward.x, 0.0)
            local up = vector3(0.0, 0.0, 1.0)

            if IsControlPressed(0, 32) then -- W
                x = x + forward.x * noclipSpeed
                y = y + forward.y * noclipSpeed
                z = z + forward.z * noclipSpeed
            end
            if IsControlPressed(0, 33) then -- S
                x = x - forward.x * noclipSpeed
                y = y - forward.y * noclipSpeed
                z = z - forward.z * noclipSpeed
            end
            if IsControlPressed(0, 34) then -- A
                x = x + right.x * -noclipSpeed
                y = y + right.y * -noclipSpeed
            end
            if IsControlPressed(0, 35) then -- D
                x = x + right.x * noclipSpeed
                y = y + right.y * noclipSpeed
            end
            if IsControlPressed(0, 44) then -- Q
                z = z + noclipSpeed
            end
            if IsControlPressed(0, 20) then -- Z
                z = z - noclipSpeed
            end
            if IsControlPressed(0, 21) then -- Shift = Boost
                noclipSpeed = 5.0
            else
                noclipSpeed = 1.5
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        else
            SetEntityCollision(ped, true, true)
            SetEntityVisible(ped, true, false)
        end

        -- Handle FreeCam
        if selfOptions.freecam then
            if not freecamCoords then
                freecamCoords = GetEntityCoords(ped)
                freecamHeading = GetEntityHeading(ped)
            end

            local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamCoord(cam, freecamCoords.x, freecamCoords.y, freecamCoords.z)
            SetCamRot(cam, 0.0, 0.0, freecamHeading)
            RenderScriptCams(true, false, 0, true, true)

            local forward = GetEntityForwardVector(ped)
            local right = vector3(-forward.y, forward.x, 0.0)
            local x, y, z = freecamCoords.x, freecamCoords.y, freecamCoords.z

            if IsControlPressed(0, 32) then -- W
                x = x + forward.x * freecamSpeed
                y = y + forward.y * freecamSpeed
            end
            if IsControlPressed(0, 33) then -- S
                x = x - forward.x * freecamSpeed
                y = y - forward.y * freecamSpeed
            end
            if IsControlPressed(0, 34) then -- A
                x = x + right.x * -freecamSpeed
                y = y + right.y * -freecamSpeed
            end
            if IsControlPressed(0, 35) then -- D
                x = x + right.x * freecamSpeed
                y = y + right.y * freecamSpeed
            end
            if IsControlPressed(0, 44) then -- Q
                z = z + freecamSpeed
            end
            if IsControlPressed(0, 20) then -- Z
                z = z - freecamSpeed
            end
            if IsControlPressed(0, 21) then -- Shift
                freecamSpeed = 5.0
            else
                freecamSpeed = 1.5
            end

            freecamCoords = vector3(x, y, z)
            SetCamCoord(cam, x, y, z)
        else
            if freecamCoords then
                RenderScriptCams(false, false, 0, true, true)
                DestroyAllCams(true)
                freecamCoords = nil
            end
        end

        Wait(0)
    end
end)

-- =========================
-- Self Tab (Section One)
-- =========================
SelfSection = MachoMenuGroup(MenuWindow, "Self", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuCheckbox(SelfSection, "Godmode", function() selfOptions.godmode = true end, function() selfOptions.godmode = false end)
MachoMenuCheckbox(SelfSection, "Invisibility", function() selfOptions.invis = true end, function() selfOptions.invis = false end)
MachoMenuCheckbox(SelfSection, "No Ragdoll", function() selfOptions.noragdoll = true end, function() selfOptions.noragdoll = false end)
MachoMenuCheckbox(SelfSection, "Infinite Stamina", function() selfOptions.infStamina = true end, function() selfOptions.infStamina = false end)
MachoMenuCheckbox(SelfSection, "Tiny Ped", function() selfOptions.tinyPed = true end, function() selfOptions.tinyPed = false end)
MachoMenuCheckbox(SelfSection, "No Clip", function() selfOptions.noclip = not selfOptions.noclip end)
MachoMenuCheckbox(SelfSection, "Free Camera", function() selfOptions.freecam = not selfOptions.freecam end)
MachoMenuCheckbox(SelfSection, "Super Jump", function() selfOptions.superJump = true end, function() selfOptions.superJump = false end)
MachoMenuCheckbox(SelfSection, "Super Punch", function() selfOptions.superPunch = true end, function() selfOptions.superPunch = false end)
MachoMenuCheckbox(SelfSection, "Force Third Person", function() SetFollowPedCamViewMode(1) end, function() SetFollowPedCamViewMode(0) end)
MachoMenuCheckbox(SelfSection, "Force Driveby", function() SetPlayerCanDoDriveBy(PlayerId(), true) end, function() SetPlayerCanDoDriveBy(PlayerId(), false) end)
MachoMenuCheckbox(SelfSection, "Anti-Headshot", function() selfOptions.antiHeadshot = true end, function() selfOptions.antiHeadshot = false end)
MachoMenuCheckbox(SelfSection, "Anti-Freeze", function() selfOptions.antiFreeze = true end, function() selfOptions.antiFreeze = false end)
MachoMenuCheckbox(SelfSection, "Anti-Blackscreen", function() selfOptions.antiBlack = true end, function() selfOptions.antiBlack = false end)

MachoMenuButton(SelfSection, "Max Health / Armor", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 200)
end)

MachoMenuButton(SelfSection, "Revive / Suicide", function()
    local ped = PlayerPedId()
    if IsEntityDead(ped) then
        ResurrectPed(ped)
        ClearPedTasksImmediately(ped)
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
    else
        SetEntityHealth(ped, 0)
    end
end)

MachoMenuButton(SelfSection, "Clear Task / Clear Vision", function()
    ClearPedTasksImmediately(PlayerPedId())
    ClearTimecycleModifier()
end)

MachoMenuButton(SelfSection, "Randomize Outfit", function()
    local ped = PlayerPedId()
    SetPedRandomComponentVariation(ped, true)
end)

MachoMenuButton(SelfSection, "Model Changer", function()
    local model = GetHashKey("player_zero") -- Michael
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end)

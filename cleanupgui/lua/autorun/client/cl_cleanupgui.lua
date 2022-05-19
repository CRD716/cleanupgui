include("autorun/sh_cleanupgui.lua")

print("cl_cleanupgui file loaded!")

surface.CreateFont("genericfont", {
    font = "Roboto",
    size = ScreenScale(24) * 0.3, // nice to have a weird screen so you can catch this
    weight = 1000,
})

local frameColor = Color(47, 54, 64)
local buttonColor = Color(53, 59, 72)
local lineColor = Color(49, 165, 49)
local nukeColor = Color(179, 54, 54)
local isDebug = true // basically just extra notifications for things

function cleanthings(argument)
    if argument == "clientclean" then
        RunConsoleCommand("gmod_cleanup")
    elseif (argument == "garbagecoll") then
        print("Current floored dyn mem = " .. collectgarbage("count"))
        if isDebug then
            notification.AddLegacy( "Current floored dynmem is " .. collectgarbage("count"), 0 , 4)
        end
        collectgarbage("collect")
        notification.AddLegacy( "Lua garbage collection complete!", 4 , 4) // don't like how NOTIFY_CLEANUP looks but if someone is using a custom notif pack it'll be weird on anything else
    elseif (argument == "adminclean") then
        RunConsoleCommand("gmod_admin_cleanup")
    elseif (argument == "decalclean") then
        RunConsoleCommand("r_cleardecals")
    elseif (argument == "nuke") then
        RunConsoleCommand("gmod_admin_cleanup")
        notification.AddLegacy( "Cleaning up map...", 4 , 6)
        // calls GM:PreCleanupMap before cleaning up the map and GM:PostCleanupMap after cleaning up the map
        game.CleanUpMap( false, { "env_fire", "entityflame", "_firesmoke" } ) // fix for https://github.com/Facepunch/garrysmod-issues/issues/3637
        // removes decals, sounds, gibs, dead NPCs, and entities created via ents.CreateClientProp
    end
end

function HOTANIMATIONS.OpenMenu()
    if IsValid(HOTANIMATIONS.Menu) then
        HOTANIMATIONS.Menu:Remove()
    end
    local frameW, frameH, animTime, animDelay, animEase = ScrW() * .5, ScrH() * .5, 1.8, 0, .1
    HOTANIMATIONS.Menu = vgui.Create("DFrame")
    HOTANIMATIONS.Menu:SetTitle("CleanupGUI")
    HOTANIMATIONS.Menu:MakePopup(true)
    HOTANIMATIONS.Menu:SetSize(0,0)
    local isAnimating = true
    HOTANIMATIONS.Menu:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        isAnimating = false 
    end)
    HOTANIMATIONS.Menu.Paint = function(me,w,h)
        surface.SetDrawColor(frameColor)
        surface.DrawRect(0,0,w,h)
    end

    // Client Cleanup button
    local ccButton = HOTANIMATIONS.Menu:Add("DButton")
    ccButton:Dock(TOP)
    ccButton:SetText("")
    local speed = 2
    local barStatus = 0
    ccButton.Paint = function(me,w,h)
        if me:IsHovered() then
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
        else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(buttonColor)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0,h * .9,w *barStatus,h * .1)
        draw.SimpleText("Clean up client props", "genericfont", w * .5,  h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    ccButton.DoClick = function(me)
        cleanthings("clientclean")
    end

    // Admin Cleanup button
    local acButton = HOTANIMATIONS.Menu:Add("DButton")
    acButton:Dock(TOP)
    acButton:SetText("")
    local speed = 2
    local barStatus = 0
    acButton.Paint = function(me,w,h)
        if me:IsHovered() then
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
        else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(buttonColor)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0,h * .9,w *barStatus,h * .1)
        draw.SimpleText("Clean up all props", "genericfont", w * .5,  h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    acButton.DoClick = function(me)
        cleanthings("adminclean")
    end

    // Garbage Collector button
    local gcbutton = HOTANIMATIONS.Menu:Add("DButton")
    gcbutton:Dock(TOP)
    gcbutton:SetText("")
    local speed = 2
    local barStatus = 0
    gcbutton.Paint = function(me,w,h)
        if me:IsHovered() then
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
        else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(buttonColor)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0,h * .9,w *barStatus,h * .1)
        draw.SimpleText("Forcerun Lua GC", "genericfont", w * .5,  h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    gcbutton.DoClick = function(me)
        cleanthings("garbagecoll")
    end

    // Decal Cleanup button
    local dcbutton = HOTANIMATIONS.Menu:Add("DButton")
    dcbutton:Dock(TOP)
    dcbutton:SetText("")
    local speed = 2
    local barStatus = 0
    dcbutton.Paint = function(me,w,h)
        if me:IsHovered() then
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
        else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(buttonColor)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0,h * .9,w *barStatus,h * .1)
        draw.SimpleText("Cleanup Decals", "genericfont", w * .5,  h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    dcbutton.DoClick = function(me)
        cleanthings("decalclean")
    end

    // Nuke button
    local nkbutton = HOTANIMATIONS.Menu:Add("DButton")
    nkbutton:Dock(TOP)
    nkbutton:SetText("")
    local speed = 2
    local barStatus = 0
    nkbutton.Paint = function(me,w,h)
        if me:IsHovered() then
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
        else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(buttonColor)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(lineColor)
        surface.DrawRect(0,h * .9,w *barStatus,h * .1)
        draw.SimpleText("The Nuclear Option", "genericfont", w * .5,  h * .5, nukeColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    nkbutton.DoClick = function(me)
        cleanthings("nuke")
    end

    HOTANIMATIONS.Menu.Think = function(me)
        if isAnimating then
            me:Center()
        end
    end
end

concommand.Add("cleanupgui", HOTANIMATIONS.OpenMenu)
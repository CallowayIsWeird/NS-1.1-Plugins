function OptimizationMenu()
    local ply = LocalPlayer()
    local optimizeConVar = ply:GetInfoNum( "gmod_mcore_test", 0 )

    if (optimizeConVar >= 1) then
        local MaxW = ScrW() * .4
        local MaxH = ScrH() * .2

        local base = vgui.Create("DFrame")
        base:SetSize(300, 147)
        base:SetTitle("Optimization Menu")
        base:SetDraggable(false)
        base:ShowCloseButton(false)
        base:SetBackgroundBlur(true)
        base:Center()
        base:MakePopup()

        basebuttons = vgui.Create("DPanel", base)
	    basebuttons:SetSize((ScrW() * .5 - MaxW * .5) /1.11, ScrH() - MaxH * 1.5)
        basebuttons:Dock(FILL)

        donot = vgui.Create("DButton", basebuttons)
        donot:SetTall(55)
        donot:Dock(BOTTOM)
        donot:SetFont("Trebuchet24")
        donot:SetText("Do Not Optimize")
        donot.DoClick = function()
            base:Close()
            surface.PlaySound("buttons/lightswitch2.wav")
        end

        optimize = vgui.Create("DButton", basebuttons)
        optimize:SetTall(55)
        optimize:Dock(BOTTOM)
        optimize:SetFont("Trebuchet24")
        optimize:SetTextColor(Color(255, 255, 255, 255))
        optimize:SetText("Optimize")
        optimize.DoClick = function()
            RunConsoleCommand("OptimizationEnableSpawn")
            base:Close()
            surface.PlaySound("buttons/lightswitch2.wav")
        end
    end
end

net.Receive("OpenOptimizationMenu", function()
    local ply = LocalPlayer()
    
	OptimizationMenu()
end)
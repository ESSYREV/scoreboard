surface.CreateFont("TabFontDef", { font = "BudgetLabel", size = 20, weight = 256 })
surface.CreateFont("HudFontDef", { font = "BudgetLabel", size = 22, weight = 256 })


    local H = ScrH() -- Высота
    local W = ScrW() -- Ширина

        local snick   = H/2.75
        local sgroup  = H/3.5
        local sfrags  = H/9
        local sdeaths = H/9
        local sping   = H/9
        local srep   =  H/7.5
        local Size = 10 + snick + sgroup + sfrags + sdeaths + sping

    local yCenter = H/2 - Size / 2.5
    local xCenter = W/2 - Size / 2

    local leftSize = W/6 + 12.5
    local lgoto    = H/10
    local lbring   = H/10.25
    local lmute    = H/10


local function rscoreboardshow(pl)
    local ply = pl:Nick()

    rTab = vgui.Create("DFrame")
	rTab:SetSize(leftSize, 200)	    rTab:SetPos(xCenter + Size + 15,yCenter)
    rTab:SetTitle("")        	            rTab:MakePopup()
	rTab:SetDraggable(false) 	            rTab:ShowCloseButton(false)
    rTab.Paint = function( self, w, h )     rTab:SetBackgroundBlur( true )
    draw.RoundedBox( 0, 0, 0, w, 25, Color( 100, 100, 100, 255 ))
    draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ))
    draw.DrawText("ОКНО ВЗАИМОДЕЙСТВИЯ","TabFontDef",rTab:GetSize()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER) end

	local Scroll = vgui.Create( "DScrollPanel", rTab )
	Scroll:Dock( FILL )
    local sbar = Scroll:GetVBar(); sbar:SetWide(10)
	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL ) List:SetSpaceY( 5 ) List:SetSpaceX( 15 )

    local function TabMenuAdd(text)
        rTabMenu = List:Add("DButton")
        rTabMenu:SetSize(W/6,25)
        rTabMenu:SetTextColor(Color(0,0,0,0))
        rTabMenu.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
            draw.DrawText(text,"TabFontDef",W/6/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)
        end
    end

    TabMenuAdd("ОТКРЫТЬ ПРОФИЛЬ")
    rTabMenu.DoClick = function() pl:ShowProfile() end

    TabMenuAdd("МУТ ИГРОКА")
    rTabMenu.DoClick = function()
    local white = Color(255,255,255)
    local orange = Color(255,165,0)
    local blue = Color(65,105,225)
    local muted = pl:IsMuted()
    pl:SetMuted(not muted)
    chat.AddText(orange,"| ",white," Статус мута игрока ",blue,ply,white,": ",pl:IsMuted())

    end

    TabMenuAdd("ТЕЛЕПОРТИРОВАТЬСЯ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","goto",ply) end

    TabMenuAdd("ТЕЛЕПОРТИРОВАТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","bring",ply) end

    TabMenuAdd("ВЕРНУТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","return",ply) end

    TabMenuAdd("ЗАМОРОЗИТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","freeze",ply) end

    TabMenuAdd("РАЗМОРОЗИТЬ")
    rTabMenu.DoClick = function()  RunConsoleCommand("ulx","unfreeze",ply) end

end

local function scoreboardshow()
    local ply = player.GetAll()
    local formula = player.GetCount() * 30 + 75
    if formula > ScrW()/3 then formula = ScrW()/3 end
    Tab = vgui.Create("DFrame")
	Tab:SetSize(Size, formula)	Tab:SetPos(xCenter,yCenter)
    Tab:SetTitle("")        	Tab:MakePopup()
	Tab:SetDraggable(false) 	Tab:ShowCloseButton(false)
    Tab.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, 25, Color( 100, 100, 100, 255 ))
    draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ))
    draw.DrawText(GetHostName(),"TabFontDef",Tab:GetSize()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER) end

	local Scroll = vgui.Create( "DScrollPanel", Tab )
	Scroll:Dock( FILL )
    local sbar = Scroll:GetVBar(); sbar:SetWide(0)
	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL ) List:SetSpaceY( 5 ) List:SetSpaceX( 0 )

        local function TabMenuAdd(text,size,pos,align)
            if align == 0 then align = TEXT_ALIGN_LEFT else align = TEXT_ALIGN_CENTER end
            if pos == 0 then pos = 0 else pos = size / 2 end
            local PlayerTab = List:Add("DLabel")
            PlayerTab:SetSize(size,25)
            PlayerTab:SetTextColor(Color(0,0,0,0))
            PlayerTab.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
                draw.DrawText(text,"TabFontDef",pos,0,Color(30,144,255),align) end
        end

            TabMenuAdd("NICKNAME"   ,snick,0,0       )
            TabMenuAdd("USER GROUP"  ,sgroup,1,1  )
            TabMenuAdd("FRAGS"  ,sfrags,1,1  )
            TabMenuAdd("DEATHS" ,sdeaths,1,1 )
            TabMenuAdd("PING"   ,sping,1,1   )

    for N=1,#ply do

        local function TabMenuAdd(text,size,pos,align)
            if align == nil then align = TEXT_ALIGN_LEFT else align = TEXT_ALIGN_CENTER end
            if pos == nil then pos = 0 else pos = size / 2 end
            local PlayerTab = List:Add("DButton")
            PlayerTab:SetSize(size,25)
            PlayerTab:SetTextColor(Color(0,0,0,0))
            PlayerTab.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,175))
                draw.DrawText(text,"TabFontDef",pos,0,Color(255,255,255),align) end
            PlayerTab.DoClick = function()
                if IsValid(rTab) then rTab:Remove() end
                if IsValid(rTabt) then rTabt:Remove() end
                rscoreboardshow(ply[N]) end
        end

        local nick   = ply[N]:Nick()
        --local group  = ply[N]:GetNWString("Teg", nil)
        local frags  = ply[N]:Frags()
        local deaths = ply[N]:Deaths()
        local ping   = ply[N]:Ping()
        --local rep    = ply[N]:GetNWFloat("Reputation")
        --if ply[N]:GetNWString("Teg", nil) == "" then group = ply[N]:GetUserGroup() end
		local group = team.GetName(ply[N]:Team())
        TabMenuAdd(nick   ,snick       )
        TabMenuAdd(group  ,sgroup,1,1  )
        TabMenuAdd(frags  ,sfrags,1,1  )
        TabMenuAdd(deaths ,sdeaths,1,1 )
        TabMenuAdd(ping   ,sping,1,1   )
        --TabMenuAdd(rep   ,srep   )

    end


end


local function scoreboardhide()
    Tab:Remove()
    if IsValid(rTab) then rTab:Remove() end
    if IsValid(rTabt) then rTabt:Remove() end
    return true
end

hook.Add("ScoreboardHide", "ScoreboardHide", function()
    scoreboardhide()
end)

hook.Add("ScoreboardShow", "ScoreboardShow", function()
    scoreboardshow()
    return false
end)

-- Привет от Essyrev <3

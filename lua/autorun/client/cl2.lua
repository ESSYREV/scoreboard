local w = ScrW()/1.15
local h = ScreenScale(ScrH()) / 2.5

surface.CreateFont("tabFont_MAIN", {
    font = "BudgetLabel",
    size = w/75,
    weight = 1,
    antialias = true
})

surface.CreateFont("tabFont_MAIN_Huge", {
    font = "BudgetLabel",
    size = w/75,
    weight = 1,
    antialias = true
})

local tab

local gray = Color(55,55,55,200)
local whitegray = Color(80,80,80,200)

local function timeToStr( time, seconds )
    local tmp = time or 0
    local s = tmp % 60
    tmp = math.floor( tmp / 60 )
    local m = tmp % 60
    tmp = math.floor( tmp / 60 )
    local h = tmp % 24
    tmp = math.floor( tmp / 24 )
    local str = " %02ih %02im"
    if seconds then str=str.." %02is" end
    return string.format(str, h, m, s )
end

local function add(text,wide,parent,aligment,self)
    local slot = vgui.Create("DLabel", parent)
    slot:Dock(LEFT)
    slot:SetFont("tabFont_MAIN")
    slot:SetTextColor(Color(255, 255, 255))
    slot:SetContentAlignment(aligment or 4)
    slot:SetText(text)
    slot:SetWide(wide)
    slot:DockMargin(5, 0, 0, 0)

    return slot
end

local function scoreboardShow()

    local players = (#player.GetAll() + 1) 
    players = math.min(players, w)

    tab = vgui.Create("DPanel")
    --timer.Simple(5,function() tab:Remove() end)
    tab:SetSize(w, players * 34)
    tab:MakePopup()
    tab:Center()

    surface.SetFont("tabFont_MAIN_Huge")
    local wx, wy = surface.GetTextSize(GetHostName().." | Онлайн: "..(#player.GetAll().."/"..game.MaxPlayers()))

    tab.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 235))
        --draw.DrawText( GetHostName().." | Онлайн: "..(#player.GetAll().."/"..game.MaxPlayers()), "tabFont_MAIN_Huge", 65, 10-wy/2, color_white, TEXT_ALIGN_LEFT )
        --draw.SimpleText( GetHostName().." | Онлайн: "..(#player.GetAll().."/"..game.MaxPlayers()), "tabFont_MAIN_Huge", 65, -2, color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP )
        --draw.RoundedBox(0, 65, wy-2, w-150, 2, Color(255, 255, 255, 255))
    end


    local scroll = vgui.Create("DScrollPanel", tab)
    scroll:Dock(FILL)

        scroll:GetVBar():SetHideButtons(true)

        scroll:GetVBar().Paint = function(self, w, h)
            --draw.RoundedBox(15, 0, 0, w, h, Color(0, 0, 0, 100))
        end

        scroll:GetVBar().btnGrip.Paint = function(self, w, h)
            --draw.RoundedBox(12, 0, 0, w, h, Color(60, 60, 60))
        end

    local scale = w / 6

    local nameSize = scale
    local modeSize = scale
    local roleSize = scale
    local timeSize = scale
    local scoreSize = scale
    local pingSize  = scale


    local main = scroll:Add("DLabel")
    main:SetSelectable(true)
    main:SetText("")
    main:Dock(TOP)
    main:DockMargin(0, 0, 0, 2)
    main:SetHeight(32)
    main:SetTall(32)
                      add("",27,main)
                      add("ИМЯ",nameSize,main)
                      add("РОЛЬ",roleSize,main)
        local mode  = add("РЕЖИМ",modeSize,main,5)
        local time  = add("ВРЕМЯ",timeSize,main,5)
        local score = add("СЧЕТ",scoreSize,main,5)
        local ping  = add("ПИНГ",pingSize,main,5)

        main.Paint = function(self, w, h)  end

    for k,v in ipairs(player.GetAll()) do
        local plColor = team.GetColor( v:Team() )
        plColor["a"] = 75
        local bt = scroll:Add("DButton")
        bt:SetSelectable(true)
        bt:SetText("")
        bt:Dock(TOP)
        bt:DockMargin(0, 0, 0, 2)
        bt:SetHeight(32)
        bt:SetTall(32)

        bt.Paint = function(self, w, h)
            if self.Hovered then
                draw.RoundedBox(0, 0, 0, w, h,plColor)
            else
                draw.RoundedBox(0, 0, 0, w, h,gray)
            end
        end

        bt.DoClick = function()
            local derma = DermaMenu(false,bt)

            derma:AddOption("Открыть профиль", function() 
                v:ShowProfile()
            end)

            derma:AddOption("Скопировать SteamID", function()
                SetClipboardText(v:SteamID())
            end)

            derma:AddOption("Заморозить", function()
                RunConsoleCommand("ulx","freeze",v:Nick())
            end)

            derma:AddOption("Разморозить", function()
                RunConsoleCommand("ulx","unfreeze",v:Nick())
            end)

            local mute_trans = v:IsMuted() and "Размутить" or "Замутить"

            derma:AddOption(mute_trans, function()
                if v:IsMuted() then
                    v:SetMuted(false)
                else
                    v:SetMuted(true)
                end
            end)

            derma:AddOption("Телепортироваться", function()
                RunConsoleCommand("ulx","goto",v:Nick())
            end)


            derma:AddOption("Телепортировать к себе", function()
                RunConsoleCommand("ulx","bring",v:Nick())
            end)

            derma:Open()
        end



        local Avatar = vgui.Create( "AvatarImage", bt )
        Avatar:Dock(LEFT)
        Avatar:SetSize( 32, 32 )
        Avatar:DockMargin(0, 0, 0, 0)
        Avatar:SetPlayer( v, 32 )

        add(v:Nick(),nameSize,bt)

                      add(team.GetName(v:Team()),roleSize,bt)
        local mode  = add(v:GetNWBool("_Kyle_Buildmode") and "Build" or "PvP",modeSize,bt,5)
        local time  = add(timeToStr( v:GetNWFloat( "TotalUTime" ) ),timeSize,bt,5)
        local score = add(v:Frags().." / "..v:Deaths(),scoreSize,bt,5)
        local ping  = add(v:Ping(),pingSize,bt,5)

        bt.Think = function()
            if not IsValid(v) then bt:Remove(); return end
               local getBuild = v:GetNWBool("_Kyle_Buildmode") and "Build" or "PvP"
               local getTime = string.FormattedTime(v:GetUTimeTotalTime())

               mode:SetText( v:GetNWBool("_Kyle_Buildmode") and "Build" or "PvP" )
               ping:SetText(v:Ping() or "nil")
               score:SetText(v:Frags() .. " / " .. v:Deaths())
               local strTime = string.FormattedTime(v:GetUTimeTotalTime())
               time:SetText(strTime.h .. ":" .. strTime.m .. ":" .. strTime.s)
        end
    end
end

local function undertabmenu()

    if not IsValid(tab) then return end

    local underKeys = {}
    underKeys["Discord"] = [[gui.OpenURL("https://discord.com/invite/JZSRrSWuhu")]]
    underKeys["Контент"] = [[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1833617086")]]
    underKeys["Правила"] = [[LocalPlayer():ConCommand("ulx motd")]]

    if LocalPlayer():GetNWBool("_Kyle_Buildmode") == true then
        underKeys["Перейти в пвп"] = [[LocalPlayer():ConCommand("ulx pvp")]]
    elseif LocalPlayer():GetNWBool("_Kyle_Buildmode") == false then
        underKeys["Перейти в build"] = [[LocalPlayer():ConCommand("ulx build")]]
    end

    local under = vgui.Create("DFrame")
    under:SetSize(w, 32)
    under:MakePopup()
    under:SetTitle("")
    under:ShowCloseButton(false)
    under:SetParent(tab)
    local posx, posy = tab:GetPos()
    under:SetPos( posx, posy-64 )

    under.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 235))
    end

    local limit = w
    local buttonSize = 0
    local index = 0
    buttonSize = limit / table.Count(underKeys)

    for key, value in pairs(underKeys) do

        local DermaButton = vgui.Create( "DButton", under )
        DermaButton:SetText( "" )
        DermaButton:SetPos( index, 0 )
        DermaButton:SetSize( buttonSize, 32 ) 
        DermaButton:SetFontInternal( "tabFont_MAIN" )
        DermaButton.DoClick = function()
            RunString(value)
            tab:Remove()
        end

        DermaButton.Paint = function(self, w, h)
            if self.Hovered then
                draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 200))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            end
            draw.DrawText(key, "tabFont_MAIN",w/2,8, color_white, TEXT_ALIGN_CENTER )
        end

        index = index + buttonSize
    end

end

local function scoreboardHide()
    if IsValid(tab) then
        tab:Remove()
    end

    if IsValid(tab_menu) then
        tab_menu:Remove()
    end
end

hook.Add("ScoreboardShow", "trap_scoreboard", function()
    scoreboardShow()
    undertabmenu()

    return false
end)

hook.Add("ScoreboardHide", "trap_scoreboard", function()
    scoreboardHide()
end)

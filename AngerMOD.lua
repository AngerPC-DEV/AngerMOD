-- ⚔ SAURON V1 | by AngerPC-DEV ⚔

-- SERVICES
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local Debris           = game:GetService("Debris")
local VirtualUser      = game:GetService("VirtualUser")
local Stats            = game:GetService("Stats")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")
local Camera           = Workspace.CurrentCamera
local Player           = Players.LocalPlayer

local request        = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local getcustomasset = getcustomasset or getsynasset
local SessionID      = string.upper(HttpService:GenerateGUID(false):sub(1,8))

-- VARS (все перед GUI)
local States = {
    Aim=false, AntiKnockback=false, Hitbox=false, UnlockAll=false,
    SpdBypass=false, Fly=false, Spd=false, Jump=false, InfJump=false,
    Circle=false, UsePentagram=false, Ghosts=false, Esp=false,
    RGB=false, Fullbright=false, AntiAfk=true, NoFog=false,
    AmbientSync=false, AI=false, FriendBot=false, IsFollowing=true,
    IsRecording=false, IsPlaying=false, LoopPlay=false, KillAura=false,
    Watermark=true
}
local valSmooth=0.15; local valHitbox=5; local valFlySpeed=5
local valSpeed=50; local valBypassSpeed=0.11; local valJumpPower=100
local valRipple=15; local valGhostRate=0.05
local up=false; local down=false

local ESP_States = {BOX=true,NAME=true,HEALTH=true,DISTANCE=true,SKELETON=false,TRACER=false,CHAMS=false}
local RADAR_ESP = true
local ESPData = {}; local ESPLines = {}; local RadarDots = {}
local RGB_Objects = {}; local Movable_Objects = {}
local UI_Unlocked = false; local RecordedPath = {}

local Themes = {"RGB","БЕЛЫЙ","СЕРЫЙ","ГОЛУБОЙ","ФИОЛЕТОВЫЙ","НЕОБЫЧНЫЙ","РОЗОВЫЙ","КРАСНЫЙ"}
local ThemeColors = {
    ["БЕЛЫЙ"]=Color3.new(1,1,1),["СЕРЫЙ"]=Color3.fromRGB(120,120,120),
    ["ГОЛУБОЙ"]=Color3.fromRGB(0,190,255),["ФИОЛЕТОВЫЙ"]=Color3.fromRGB(170,0,255),
    ["НЕОБЫЧНЫЙ"]=Color3.fromRGB(255,170,0),["РОЗОВЫЙ"]=Color3.fromRGB(255,105,180),
    ["КРАСНЫЙ"]=Color3.fromRGB(255,0,0)
}
local CurrentThemeIndex = 1
local GroqModels = {"llama-3.3-70b-versatile","llama-3.1-70b-versatile","deepseek-r1-distill-llama-70b"}
local CurrentModelIndex = 1
local ChatHistory = {{role="system",content="Ты — SAURON. Создатель: AngerPC-DEV. Характер: дерзкий, краткий."}}

-- ════════════════════════════════════════════
-- LOGIN
-- ════════════════════════════════════════════
local LG = Instance.new("ScreenGui")
LG.Name="SauronLogin"; LG.ResetOnSpawn=false; LG.DisplayOrder=999; LG.IgnoreGuiInset=true
LG.Parent = Player:WaitForChild("PlayerGui")

local LBg = Instance.new("Frame",LG)
LBg.Size=UDim2.new(1,0,1,0); LBg.BackgroundColor3=Color3.fromRGB(5,5,5); LBg.BorderSizePixel=0

local LC = Instance.new("Frame",LBg)
LC.Size=UDim2.new(0,380,0,330); LC.Position=UDim2.new(0.5,-190,0.5,-165)
LC.BackgroundColor3=Color3.fromRGB(10,10,10); LC.BorderSizePixel=0
Instance.new("UICorner",LC).CornerRadius=UDim.new(0,16)
local LCS=Instance.new("UIStroke",LC); LCS.Thickness=1.5; LCS.Color=Color3.fromRGB(80,0,0)

local LTop=Instance.new("Frame",LC); LTop.Size=UDim2.new(1,0,0,3); LTop.BackgroundColor3=Color3.fromRGB(200,0,0); LTop.BorderSizePixel=0

local LImg=Instance.new("ImageLabel",LC)
LImg.Size=UDim2.new(0,250,0,62); LImg.Position=UDim2.new(0.5,-125,0,14)
LImg.BackgroundTransparency=1; LImg.ScaleType=Enum.ScaleType.Fit
LImg.Image="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"

local LFall=Instance.new("TextLabel",LC)
LFall.Size=UDim2.new(1,0,0,62); LFall.Position=UDim2.new(0,0,0,14)
LFall.BackgroundTransparency=1; LFall.Text="⚔ SAURON"
LFall.Font=Enum.Font.SciFi; LFall.TextSize=36; LFall.TextColor3=Color3.fromRGB(220,0,0); LFall.Visible=false
task.delay(2.5,function() if LImg.ContentImageSize==Vector2.new(0,0) then LFall.Visible=true; LImg.Visible=false end end)

local LDiv=Instance.new("Frame",LC); LDiv.Size=UDim2.new(0.86,0,0,1); LDiv.Position=UDim2.new(0.07,0,0,84); LDiv.BackgroundColor3=Color3.fromRGB(35,35,35); LDiv.BorderSizePixel=0

local LHint=Instance.new("TextLabel",LC); LHint.Size=UDim2.new(1,0,0,18); LHint.Position=UDim2.new(0,0,0,91); LHint.BackgroundTransparency=1; LHint.Text="ВВЕДИ КЛЮЧ ДОСТУПА"; LHint.Font=Enum.Font.SciFi; LHint.TextSize=11; LHint.TextColor3=Color3.fromRGB(80,80,80)

local LKB=Instance.new("TextBox",LC)
LKB.Size=UDim2.new(0.86,0,0,46); LKB.Position=UDim2.new(0.07,0,0,114)
LKB.BackgroundColor3=Color3.fromRGB(16,16,16); LKB.TextColor3=Color3.new(1,1,1)
LKB.PlaceholderText="SAURON-XXXXXXXX"; LKB.PlaceholderColor3=Color3.fromRGB(55,55,55)
LKB.Text=""; LKB.Font=Enum.Font.SciFi; LKB.TextSize=16; LKB.ClearTextOnFocus=false; LKB.BorderSizePixel=0
Instance.new("UICorner",LKB).CornerRadius=UDim.new(0,10)
local LKS=Instance.new("UIStroke",LKB); LKS.Thickness=1.5; LKS.Color=Color3.fromRGB(45,45,45)

local LSt=Instance.new("TextLabel",LC); LSt.Size=UDim2.new(0.86,0,0,20); LSt.Position=UDim2.new(0.07,0,0,168); LSt.BackgroundTransparency=1; LSt.Text="● ожидание"; LSt.Font=Enum.Font.SciFi; LSt.TextSize=12; LSt.TextColor3=Color3.fromRGB(80,80,80); LSt.TextXAlignment=Enum.TextXAlignment.Left

local LPBg=Instance.new("Frame",LC); LPBg.Size=UDim2.new(0.86,0,0,4); LPBg.Position=UDim2.new(0.07,0,0,196); LPBg.BackgroundColor3=Color3.fromRGB(20,20,20); LPBg.BorderSizePixel=0; LPBg.Visible=false
Instance.new("UICorner",LPBg).CornerRadius=UDim.new(1,0)
local LPF=Instance.new("Frame",LPBg); LPF.Size=UDim2.new(0,0,1,0); LPF.BackgroundColor3=Color3.fromRGB(200,0,0); LPF.BorderSizePixel=0
Instance.new("UICorner",LPF).CornerRadius=UDim.new(1,0)

local LBtn=Instance.new("TextButton",LC)
LBtn.Size=UDim2.new(0.86,0,0,48); LBtn.Position=UDim2.new(0.07,0,0,210)
LBtn.BackgroundColor3=Color3.fromRGB(160,0,0); LBtn.TextColor3=Color3.new(1,1,1)
LBtn.Text="▶  ВОЙТИ"; LBtn.Font=Enum.Font.SciFi; LBtn.TextSize=16; LBtn.BorderSizePixel=0
Instance.new("UICorner",LBtn).CornerRadius=UDim.new(0,12)

local LVer=Instance.new("TextLabel",LC); LVer.Size=UDim2.new(1,0,0,20); LVer.Position=UDim2.new(0,0,0,272); LVer.BackgroundTransparency=1; LVer.Text="SAURON V1  ·  AngerPC-DEV"; LVer.Font=Enum.Font.SciFi; LVer.TextSize=10; LVer.TextColor3=Color3.fromRGB(38,38,38)

task.spawn(function()
    while LG.Parent do
        TweenService:Create(LCS,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(220,0,0)}):Play(); task.wait(1.2)
        TweenService:Create(LCS,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(50,0,0)}):Play(); task.wait(1.2)
    end
end)
LBtn.MouseEnter:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(200,0,0)}):Play() end)
LBtn.MouseLeave:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(160,0,0)}):Play() end)

local ValidKeys={}; local KeysLoaded=false
task.spawn(function()
    local ok,res=pcall(function() return game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.sauron",true) end)
    if ok and res and #res>2 then
        for line in res:gmatch("[^\r\n]+") do
            line=line:match("^%s*(.-)%s*$"); local key=line:match("|%s*(.+)$") or line; key=key:match("^%s*(.-)%s*$")
            if key and #key>3 then ValidKeys[key]=true end
        end
        LSt.Text="● сервер доступен"; LSt.TextColor3=Color3.fromRGB(0,160,60); KeysLoaded=true
    else LSt.Text="● оффлайн режим"; LSt.TextColor3=Color3.fromRGB(200,140,0) end
end)

local function TryLogin()
    local key=LKB.Text:match("^%s*(.-)%s*$"); if key=="" then LSt.Text="● введи ключ!"; LSt.TextColor3=Color3.fromRGB(220,50,50); return end
    LBtn.Active=false; LBtn.Text="⏳  ПРОВЕРКА..."
    LSt.Text="● проверяем..."; LSt.TextColor3=Color3.fromRGB(200,160,0)
    LPBg.Visible=true; TweenService:Create(LPF,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(1)
    local valid=ValidKeys[key] or (not KeysLoaded and key:sub(1,7)=="SAURON-" and #key>=10)
    if valid then
        LSt.Text="● доступ разрешён!"; LSt.TextColor3=Color3.fromRGB(0,220,80)
        LBtn.Text="✅  ДОБРО ПОЖАЛОВАТЬ"; LBtn.BackgroundColor3=Color3.fromRGB(0,110,40)
        task.wait(0.8)
        TweenService:Create(LC,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-190,-0.15,-165)}):Play()
        TweenService:Create(LBg,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play(); task.wait(0.5); LG:Destroy()
    else
        LSt.Text="● неверный ключ!"; LSt.TextColor3=Color3.fromRGB(220,50,50)
        LBtn.Text="▶  ВОЙТИ"; LBtn.BackgroundColor3=Color3.fromRGB(160,0,0); LBtn.Active=true
        LPBg.Visible=false; LPF.Size=UDim2.new(0,0,1,0)
        local p=LC.Position; for i=1,5 do task.wait(0.04); LC.Position=p+UDim2.new(0,(i%2==0 and 7 or -7),0,0) end; LC.Position=p
    end
end
LBtn.MouseButton1Click:Connect(TryLogin)
LKB.FocusLost:Connect(function(enter) if enter then TryLogin() end end)
repeat task.wait(0.05) until not LG or not LG.Parent or not LG:IsDescendantOf(game)

-- ════════════════════════════════════════════
-- MAIN GUI
-- ════════════════════════════════════════════
local SG=Instance.new("ScreenGui")
SG.Name="SauronGUI_V1"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.Parent=Player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- Death screen
local DS=Instance.new("ScreenGui",SG.Parent); DS.Name="SauronDeath"; DS.Enabled=false
local DL=Instance.new("TextLabel",DS); DL.Size=UDim2.new(1,0,1,0); DL.BackgroundTransparency=1
DL.Text="WASTED"; DL.Font=Enum.Font.Creepster; DL.TextSize=100
DL.TextColor3=Color3.fromRGB(255,0,0); DL.TextStrokeTransparency=0

-- Уведомления
local NC=Instance.new("Frame",SG); NC.Size=UDim2.new(0,240,0.4,0); NC.Position=UDim2.new(1,-250,0.55,0); NC.BackgroundTransparency=1
local NL=Instance.new("UIListLayout",NC); NL.SortOrder=Enum.SortOrder.LayoutOrder; NL.VerticalAlignment=Enum.VerticalAlignment.Bottom; NL.Padding=UDim.new(0,4)
local function Notify(text)
    local f=Instance.new("Frame",NC); f.Size=UDim2.new(1,0,0,36); f.BackgroundColor3=Color3.fromRGB(12,12,12); f.BackgroundTransparency=1; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",f).Color=Color3.fromRGB(60,0,0)
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-12,1,0); l.Position=UDim2.new(0,8,0,0); l.BackgroundTransparency=1
    l.Text=text; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.SciFi; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextTransparency=1
    TweenService:Create(f,TweenInfo.new(0.2),{BackgroundTransparency=0.1}):Play(); TweenService:Create(l,TweenInfo.new(0.2),{TextTransparency=0}):Play()
    task.delay(3,function() TweenService:Create(f,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play(); TweenService:Create(l,TweenInfo.new(0.3),{TextTransparency=1}):Play(); task.wait(0.3); f:Destroy() end)
end

-- Кнопка открытия
local OpenBtn=Instance.new("TextButton",SG); OpenBtn.Name="SauronOpen"
OpenBtn.Size=UDim2.new(0,40,0,40); OpenBtn.Position=UDim2.new(0,8,0.5,-20)
OpenBtn.BackgroundColor3=Color3.fromRGB(130,0,0); OpenBtn.TextColor3=Color3.new(1,1,1)
OpenBtn.Text="⚔"; OpenBtn.Font=Enum.Font.SciFi; OpenBtn.TextSize=18; OpenBtn.BorderSizePixel=0
OpenBtn.Active=true; OpenBtn.Draggable=true
Instance.new("UICorner",OpenBtn).CornerRadius=UDim.new(1,0)
local OS=Instance.new("UIStroke",OpenBtn); OS.Thickness=2; OS.Color=Color3.fromRGB(220,0,0); table.insert(RGB_Objects,{Type="Stroke",Instance=OS})
table.insert(Movable_Objects,OpenBtn)

-- Главное окно
local Win=Instance.new("Frame",SG); Win.Name="SauronWin"
Win.Size=UDim2.new(0,560,0,500); Win.Position=UDim2.new(0.5,-280,0.5,-250)
Win.BackgroundColor3=Color3.fromRGB(8,8,8); Win.BorderSizePixel=0; Win.Visible=true; Win.Active=true; Win.Draggable=true
Instance.new("UICorner",Win).CornerRadius=UDim.new(0,12)
local WS=Instance.new("UIStroke",Win); WS.Thickness=1.5; WS.Color=Color3.fromRGB(60,0,0); table.insert(RGB_Objects,{Type="Stroke",Instance=WS})
table.insert(Movable_Objects,Win)

OpenBtn.MouseButton1Click:Connect(function() Win.Visible=not Win.Visible end)

-- Шапка
local Hdr=Instance.new("Frame",Win); Hdr.Size=UDim2.new(1,0,0,44); Hdr.BackgroundColor3=Color3.fromRGB(11,11,11); Hdr.BorderSizePixel=0
Instance.new("UICorner",Hdr).CornerRadius=UDim.new(0,12)
local HT=Instance.new("TextLabel",Hdr); HT.Size=UDim2.new(0,160,1,0); HT.Position=UDim2.new(0,14,0,0)
HT.BackgroundTransparency=1; HT.Text="⚔  SAURON"; HT.Font=Enum.Font.SciFi; HT.TextSize=20; HT.TextColor3=Color3.fromRGB(220,0,0); HT.TextXAlignment=Enum.TextXAlignment.Left
table.insert(RGB_Objects,{Type="Text",Instance=HT})
local HV=Instance.new("TextLabel",Hdr); HV.Size=UDim2.new(0,30,1,0); HV.Position=UDim2.new(0,128,0,0)
HV.BackgroundTransparency=1; HV.Text="V1"; HV.Font=Enum.Font.SciFi; HV.TextSize=11; HV.TextColor3=Color3.fromRGB(55,55,55); HV.TextXAlignment=Enum.TextXAlignment.Left
local CX=Instance.new("TextButton",Hdr); CX.Size=UDim2.new(0,26,0,26); CX.Position=UDim2.new(1,-34,0.5,-13)
CX.BackgroundColor3=Color3.fromRGB(110,0,0); CX.TextColor3=Color3.new(1,1,1); CX.Text="✕"; CX.Font=Enum.Font.SciFi; CX.TextSize=12; CX.BorderSizePixel=0
Instance.new("UICorner",CX).CornerRadius=UDim.new(0,6); CX.MouseButton1Click:Connect(function() Win.Visible=false end)

-- Левая панель
local LP=Instance.new("Frame",Win); LP.Size=UDim2.new(0,106,1,-52); LP.Position=UDim2.new(0,6,0,47)
LP.BackgroundColor3=Color3.fromRGB(11,11,11); LP.BorderSizePixel=0
Instance.new("UICorner",LP).CornerRadius=UDim.new(0,10)
local TLL=Instance.new("UIListLayout",LP); TLL.Padding=UDim.new(0,3); TLL.HorizontalAlignment=Enum.HorizontalAlignment.Center
local TLP=Instance.new("UIPadding",LP); TLP.PaddingTop=UDim.new(0,5)

-- Контент
local CA=Instance.new("Frame",Win); CA.Size=UDim2.new(1,-118,1,-52); CA.Position=UDim2.new(0,116,0,47); CA.BackgroundTransparency=1; CA.ClipsDescendants=true

-- ════════════════════
-- TAB SYSTEM
-- ════════════════════
local Tabs={}
local function SwitchTab(id)
    for tid,t in pairs(Tabs) do
        local on=(tid==id)
        TweenService:Create(t.btn,TweenInfo.new(0.12),{BackgroundColor3=on and Color3.fromRGB(140,0,0) or Color3.fromRGB(18,18,18)}):Play()
        t.page.Visible=on; t.ind.Visible=on
    end
end

local TabDefs={{id="ESP",icon="👁",lbl="ESP"},{id="PLAYER",icon="⚡",lbl="PLAYER"},{id="VISUAL",icon="✨",lbl="VISUAL"},{id="AI",icon="🤖",lbl="AI-SN"},{id="INFO",icon="📊",lbl="INFO"},{id="WORLD",icon="🌍",lbl="WORLD"},{id="UI",icon="🔧",lbl="UI"}}
for _,def in ipairs(TabDefs) do
    local btn=Instance.new("TextButton",LP); btn.Size=UDim2.new(0,90,0,54); btn.BackgroundColor3=Color3.fromRGB(18,18,18); btn.BorderSizePixel=0; btn.Text=""
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local iL=Instance.new("TextLabel",btn); iL.Size=UDim2.new(1,0,0,26); iL.Position=UDim2.new(0,0,0,6); iL.BackgroundTransparency=1; iL.Text=def.icon; iL.TextSize=17; iL.Font=Enum.Font.SciFi
    local nL=Instance.new("TextLabel",btn); nL.Size=UDim2.new(1,0,0,16); nL.Position=UDim2.new(0,0,0,31); nL.BackgroundTransparency=1; nL.Text=def.lbl; nL.TextSize=9; nL.Font=Enum.Font.SciFi; nL.TextColor3=Color3.fromRGB(110,110,110)
    local ind=Instance.new("Frame",btn); ind.Size=UDim2.new(0,3,0.5,0); ind.Position=UDim2.new(0,1,0.25,0); ind.BackgroundColor3=Color3.fromRGB(220,0,0); ind.BorderSizePixel=0; Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0); ind.Visible=false

    -- Страница со скроллом
    local page=Instance.new("ScrollingFrame",CA)
    page.Size=UDim2.new(1,-2,1,-4); page.Position=UDim2.new(0,1,0,2)
    page.BackgroundTransparency=1; page.ScrollBarThickness=3; page.ScrollBarImageColor3=Color3.fromRGB(180,0,0); page.Visible=false
    page.CanvasSize=UDim2.new(1,0,0,0)  -- будем обновлять вручную
    page.ScrollingDirection=Enum.ScrollingDirection.Y
    local pl=Instance.new("UIListLayout",page); pl.Padding=UDim.new(0,5); pl.SortOrder=Enum.SortOrder.LayoutOrder
    local pp=Instance.new("UIPadding",page); pp.PaddingTop=UDim.new(0,4); pp.PaddingBottom=UDim.new(0,8); pp.PaddingLeft=UDim.new(0,2); pp.PaddingRight=UDim.new(0,5)

    -- Автовысота канваса
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+12)
    end)

    btn.MouseButton1Click:Connect(function() SwitchTab(def.id) end)
    Tabs[def.id]={btn=btn,page=page,ind=ind}
end

-- ════════════════════
-- UI BUILDERS
-- ════════════════════
local function Sec(parent,text)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,22); f.BackgroundTransparency=1; f.BorderSizePixel=0
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-6,1,0); l.Position=UDim2.new(0,6,0,0); l.BackgroundTransparency=1
    l.Text=string.upper(text); l.Font=Enum.Font.SciFi; l.TextSize=10; l.TextColor3=Color3.fromRGB(100,0,0); l.TextXAlignment=Enum.TextXAlignment.Left
    local d=Instance.new("Frame",f); d.Size=UDim2.new(1,-6,0,1); d.Position=UDim2.new(0,6,1,-1); d.BackgroundColor3=Color3.fromRGB(35,0,0); d.BorderSizePixel=0
    return f
end

-- Тогл — stateKey это строка ключа в States, либо nil + customCallback
local function Tog(parent,text,stateKey,customCallback)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,42); f.BackgroundColor3=Color3.fromRGB(14,14,14); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local fs=Instance.new("UIStroke",f); fs.Thickness=1
    local isOn = stateKey ~= nil and States[stateKey] == true
    fs.Color = isOn and Color3.fromRGB(100,0,0) or Color3.fromRGB(30,30,30)

    local lbl=Instance.new("TextLabel",f); lbl.Size=UDim2.new(1,-68,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.Font=Enum.Font.SciFi; lbl.TextSize=14; lbl.TextColor3=Color3.fromRGB(210,210,210); lbl.TextXAlignment=Enum.TextXAlignment.Left

    local pill=Instance.new("Frame",f); pill.Size=UDim2.new(0,42,0,22); pill.Position=UDim2.new(1,-54,0.5,-11); pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0); pill.BackgroundColor3=isOn and Color3.fromRGB(180,0,0) or Color3.fromRGB(26,26,26)

    local dot=Instance.new("Frame",pill); dot.Size=UDim2.new(0,16,0,16); dot.BorderSizePixel=0; dot.BackgroundColor3=Color3.new(1,1,1)
    dot.Position=isOn and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    local btn=Instance.new("TextButton",f); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.MouseButton1Click:Connect(function()
        local on
        if customCallback then on=customCallback()
        else States[stateKey]=not States[stateKey]; on=States[stateKey] end
        TweenService:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and Color3.fromRGB(180,0,0) or Color3.fromRGB(26,26,26)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        fs.Color=on and Color3.fromRGB(100,0,0) or Color3.fromRGB(30,30,30)
        Notify(text..(on and " — ON" or " — OFF"))
    end)
    return f
end

-- Ползунок с надписью
local function Sld(parent,text,minV,maxV,defV,dec,onChange)
    dec=dec or 3; local fmt="%."..dec.."f"
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,58); f.BackgroundColor3=Color3.fromRGB(14,14,14); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",f).Color=Color3.fromRGB(28,28,28)

    local nl=Instance.new("TextLabel",f); nl.Size=UDim2.new(0.62,0,0,22); nl.Position=UDim2.new(0,12,0,5)
    nl.BackgroundTransparency=1; nl.Text=text; nl.Font=Enum.Font.SciFi; nl.TextSize=13; nl.TextColor3=Color3.fromRGB(195,195,195); nl.TextXAlignment=Enum.TextXAlignment.Left

    local vl=Instance.new("TextLabel",f); vl.Size=UDim2.new(0.34,0,0,22); vl.Position=UDim2.new(0.64,0,0,5)
    vl.BackgroundTransparency=1; vl.Text=string.format(fmt,defV); vl.Font=Enum.Font.SciFi; vl.TextSize=13; vl.TextColor3=Color3.fromRGB(220,0,0); vl.TextXAlignment=Enum.TextXAlignment.Right
    table.insert(RGB_Objects,{Type="Text",Instance=vl})

    local tr=Instance.new("Frame",f); tr.Size=UDim2.new(1,-22,0,6); tr.Position=UDim2.new(0,11,0,36)
    tr.BackgroundColor3=Color3.fromRGB(26,26,26); tr.BorderSizePixel=0
    Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    -- Делаем трек кликабельным через TextButton поверх
    local trBtn=Instance.new("TextButton",tr); trBtn.Size=UDim2.new(1,0,4,0); trBtn.Position=UDim2.new(0,0,-1.5,0); trBtn.BackgroundTransparency=1; trBtn.Text=""

    local p0=math.clamp((defV-minV)/(maxV-minV),0,1)
    local fill=Instance.new("Frame",tr); fill.Size=UDim2.new(p0,0,1,0); fill.BackgroundColor3=Color3.fromRGB(180,0,0); fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0); table.insert(RGB_Objects,{Type="Part",Instance=fill})

    local thumb=Instance.new("Frame",tr); thumb.Size=UDim2.new(0,14,0,14); thumb.Position=UDim2.new(p0,-7,0.5,-7)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)

    local curVal=defV; local drag=false

    local function upd(ax)
        local sz=tr.AbsoluteSize.X; if sz<=0 then return end
        local p=math.clamp((ax-tr.AbsolutePosition.X)/sz,0,1)
        curVal=math.floor((minV+p*(maxV-minV))*(10^dec)+0.5)/(10^dec)
        fill.Size=UDim2.new(p,0,1,0); thumb.Position=UDim2.new(p,-7,0.5,-7)
        vl.Text=string.format(fmt,curVal); if onChange then onChange(curVal) end
    end

    trBtn.MouseButton1Down:Connect(function(x,y) drag=true; upd(x) end)
    trBtn.MouseButton1Up:Connect(function() drag=false end)
    thumb.MouseButton1Down:Connect(function() drag=true end)
    thumb.MouseButton1Up:Connect(function() drag=false end)

    UserInputService.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then upd(inp.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    return f
end

-- Кнопка
local function Btn(parent,text,bg,cb)
    local b=Instance.new("TextButton",parent); b.Size=UDim2.new(1,0,0,42)
    b.BackgroundColor3=bg or Color3.fromRGB(20,20,20); b.TextColor3=Color3.new(1,1,1)
    b.Text=text; b.Font=Enum.Font.SciFi; b.TextSize=14; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",b).Color=Color3.fromRGB(45,45,45)
    if cb then b.MouseButton1Click:Connect(cb) end; return b
end

-- Инпут
local function Inp(parent,ph)
    local tb=Instance.new("TextBox",parent); tb.Size=UDim2.new(1,0,0,42)
    tb.BackgroundColor3=Color3.fromRGB(14,14,14); tb.TextColor3=Color3.new(1,1,1); tb.PlaceholderText=ph; tb.PlaceholderColor3=Color3.fromRGB(55,55,55)
    tb.Text=""; tb.Font=Enum.Font.SciFi; tb.TextSize=13; tb.ClearTextOnFocus=false; tb.BorderSizePixel=0
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",tb).Color=Color3.fromRGB(38,38,38)
    return tb
end

-- ════════════════════════════════════════════
-- TAB CONTENT
-- ════════════════════════════════════════════
local P={}; for id,t in pairs(Tabs) do P[id]=t.page end

-- ESP
Sec(P.ESP,"ESP — опции")
local function EspTog(lbl,key)
    Tog(P.ESP,lbl,nil,function()
        if key=="RADAR" then RADAR_ESP=not RADAR_ESP; return RADAR_ESP end
        ESP_States[key]=not ESP_States[key]; return ESP_States[key]
    end)
end
EspTog("📦  BOX ESP","BOX"); EspTog("👤  NAMETAG","NAME"); EspTog("❤   HEALTH BAR","HEALTH")
EspTog("📏  DISTANCE","DISTANCE"); EspTog("💀  SKELETON","SKELETON"); EspTog("➡   TRACER","TRACER")
EspTog("🎨  CHAMS","CHAMS"); EspTog("🛰   RADAR","RADAR")

-- PLAYER
Sec(P.PLAYER,"COMBAT")
Tog(P.PLAYER,"🎯  HUMAN AIM","Aim")
Sld(P.PLAYER,"  Плавность",0.01,1.0,0.15,3,function(v) valSmooth=v end)
Tog(P.PLAYER,"🛡  ANTI KNOCKBACK","AntiKnockback")
Tog(P.PLAYER,"⚡  KILL AURA","KillAura")
Sec(P.PLAYER,"HITBOX")
Tog(P.PLAYER,"💥  BIG HITBOX","Hitbox")
Sld(P.PLAYER,"  Размер хитбокса",0.0,100.0,5.0,3,function(v) valHitbox=v end)
Sec(P.PLAYER,"MOVEMENT")
Tog(P.PLAYER,"🏃  RAGE SPEED","Spd")
Sld(P.PLAYER,"  Скорость (RAGE)",0.0,100.0,50.0,3,function(v) valSpeed=v end)
Tog(P.PLAYER,"🔄  SPEED BYPASS","SpdBypass")
Sld(P.PLAYER,"  Скорость (BYPASS)",0.0,100.0,0.11,3,function(v) valBypassSpeed=v end)
Tog(P.PLAYER,"✈   FLY","Fly")
Sld(P.PLAYER,"  Скорость полёта",0.0,100.0,5.0,3,function(v) valFlySpeed=v end)
Tog(P.PLAYER,"🦘  SUPER JUMP","Jump")
Sld(P.PLAYER,"  Сила прыжка",0.0,100.0,100.0,3,function(v) valJumpPower=v end)
Tog(P.PLAYER,"♾   INF JUMP","InfJump")
Tog(P.PLAYER,"🔍  INF ZOOM","UnlockAll")
Tog(P.PLAYER,"💤  ANTI AFK","AntiAfk")

-- VISUAL
Sec(P.VISUAL,"ТЕМА")
local thBtn=Btn(P.VISUAL,"🎨  ТЕМА: "..Themes[CurrentThemeIndex],Color3.fromRGB(18,10,10))
thBtn.MouseButton1Click:Connect(function()
    CurrentThemeIndex=CurrentThemeIndex+1; if CurrentThemeIndex>#Themes then CurrentThemeIndex=1 end
    thBtn.Text="🎨  ТЕМА: "..Themes[CurrentThemeIndex]
end)
Sec(P.VISUAL,"ЭФФЕКТЫ")
Tog(P.VISUAL,"🖼   ПОКАЗАТЬ ЛОГО","Watermark"); Tog(P.VISUAL,"☀   FULLBRIGHT","Fullbright"); Tog(P.VISUAL,"🌈  RGB СКИН","RGB")
Sec(P.VISUAL,"GHOST TRAIL")
Tog(P.VISUAL,"👻  GHOST TRAIL","Ghosts"); Sld(P.VISUAL,"  Частота",0.01,2.0,0.05,3,function(v) valGhostRate=v end)
Sec(P.VISUAL,"RIPPLE")
Tog(P.VISUAL,"💫  JUMP RIPPLE","Circle"); Sld(P.VISUAL,"  Размер ripple",0.0,100.0,15.0,3,function(v) valRipple=v end)
Tog(P.VISUAL,"⛧   PENTAGRAM","UsePentagram")

-- AI
Sec(P.AI,"GROQ AI")
local AIKeyBox=Inp(P.AI,"GROQ API KEY")
local ModelBtn=Btn(P.AI,"⚙  "..GroqModels[CurrentModelIndex],Color3.fromRGB(14,14,22))
ModelBtn.TextSize=11
ModelBtn.MouseButton1Click:Connect(function()
    CurrentModelIndex=CurrentModelIndex+1; if CurrentModelIndex>#GroqModels then CurrentModelIndex=1 end
    ModelBtn.Text="⚙  "..GroqModels[CurrentModelIndex]
end)
Sec(P.AI,"БОТЫ")
Tog(P.AI,"🤖  AI AUTOREPLY",nil,function() States.AI=not States.AI; return States.AI end)
Tog(P.AI,"👥  FRIEND BOT",nil,function() States.FriendBot=not States.FriendBot; return States.FriendBot end)
Sec(P.AI,"МАКРО")
local AIStatus=Instance.new("TextLabel",P.AI); AIStatus.Size=UDim2.new(1,0,0,26); AIStatus.BackgroundTransparency=1
AIStatus.Text="  STATUS: IDLE"; AIStatus.Font=Enum.Font.SciFi; AIStatus.TextSize=12; AIStatus.TextColor3=Color3.fromRGB(90,90,90); AIStatus.TextXAlignment=Enum.TextXAlignment.Left
local mRow=Instance.new("Frame",P.AI); mRow.Size=UDim2.new(1,0,0,42); mRow.BackgroundTransparency=1; mRow.BorderSizePixel=0
local RecBtn=Instance.new("TextButton",mRow); RecBtn.Size=UDim2.new(0.48,-3,1,0); RecBtn.BackgroundColor3=Color3.fromRGB(40,8,8); RecBtn.TextColor3=Color3.new(1,1,1); RecBtn.Text="⏺  RECORD"; RecBtn.Font=Enum.Font.SciFi; RecBtn.TextSize=13; RecBtn.BorderSizePixel=0; Instance.new("UICorner",RecBtn).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",RecBtn).Color=Color3.fromRGB(60,20,20)
local PlayBtn=Instance.new("TextButton",mRow); PlayBtn.Size=UDim2.new(0.48,-3,1,0); PlayBtn.Position=UDim2.new(0.52,3,0,0); PlayBtn.BackgroundColor3=Color3.fromRGB(8,40,8); PlayBtn.TextColor3=Color3.new(1,1,1); PlayBtn.Text="▶  PLAY"; PlayBtn.Font=Enum.Font.SciFi; PlayBtn.TextSize=13; PlayBtn.BorderSizePixel=0; Instance.new("UICorner",PlayBtn).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",PlayBtn).Color=Color3.fromRGB(20,60,20)
Tog(P.AI,"🔁  LOOP PLAYBACK",nil,function() States.LoopPlay=not States.LoopPlay; return States.LoopPlay end)

-- INFO
Sec(P.INFO,"СЕССИЯ")
local InfoLabel=Instance.new("TextLabel",P.INFO); InfoLabel.Size=UDim2.new(1,0,0,200); InfoLabel.BackgroundTransparency=1; InfoLabel.TextColor3=Color3.new(1,1,1); InfoLabel.Font=Enum.Font.SciFi; InfoLabel.TextSize=14; InfoLabel.TextYAlignment=Enum.TextYAlignment.Top; InfoLabel.TextXAlignment=Enum.TextXAlignment.Left; InfoLabel.Text="  Загрузка..."

-- WORLD
Sec(P.WORLD,"ОКРУЖЕНИЕ")
local FogBtn=Btn(P.WORLD,"🌫   REMOVE FOG: OFF",Color3.fromRGB(22,8,8))
FogBtn.MouseButton1Click:Connect(function()
    States.NoFog=not States.NoFog; FogBtn.Text=States.NoFog and "🌫   REMOVE FOG: ON" or "🌫   REMOVE FOG: OFF"
    FogBtn.BackgroundColor3=States.NoFog and Color3.fromRGB(8,30,8) or Color3.fromRGB(22,8,8)
    if not States.NoFog then Lighting.FogEnd=1000 end; Notify("FOG "..(States.NoFog and "OFF" or "ON"))
end)
local AmbBtn=Btn(P.WORLD,"💡  AMBIENT SYNC: OFF",Color3.fromRGB(22,8,8))
AmbBtn.MouseButton1Click:Connect(function()
    States.AmbientSync=not States.AmbientSync; AmbBtn.Text=States.AmbientSync and "💡  AMBIENT SYNC: ON" or "💡  AMBIENT SYNC: OFF"
    AmbBtn.BackgroundColor3=States.AmbientSync and Color3.fromRGB(8,30,8) or Color3.fromRGB(22,8,8); Notify("AMBIENT "..(States.AmbientSync and "ON" or "OFF"))
end)
Sec(P.WORLD,"НЕБО")
local SkyBox=Inp(P.WORLD,"ASSET ID НЕБА")
Btn(P.WORLD,"🌄  ПРИМЕНИТЬ НЕБО",Color3.fromRGB(16,16,16),function()
    local id=SkyBox.Text:match("%d+"); if not id then Notify("НЕВЕРНЫЙ ID"); return end
    local sky=Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky",Lighting)
    local t="rbxassetid://"..id; sky.SkyboxBk,sky.SkyboxDn,sky.SkyboxFt,sky.SkyboxLf,sky.SkyboxRt,sky.SkyboxUp=t,t,t,t,t,t; Notify("SKY: "..id)
end)
Btn(P.WORLD,"🌌  КОСМОС",Color3.fromRGB(8,8,20),function()
    local sky=Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky",Lighting)
    local t="rbxassetid://159454299"; sky.SkyboxBk,sky.SkyboxDn,sky.SkyboxFt,sky.SkyboxLf,sky.SkyboxRt,sky.SkyboxUp=t,t,t,t,t,t; Notify("SPACE SKY ON")
end)
Sec(P.WORLD,"FLY CONTROL")
local fRow=Instance.new("Frame",P.WORLD); fRow.Size=UDim2.new(1,0,0,42); fRow.BackgroundTransparency=1; fRow.BorderSizePixel=0
local btnUp=Instance.new("TextButton",fRow); btnUp.Size=UDim2.new(0.48,-3,1,0); btnUp.BackgroundColor3=Color3.fromRGB(16,16,16); btnUp.TextColor3=Color3.new(1,1,1); btnUp.Text="▲  FLY UP"; btnUp.Font=Enum.Font.SciFi; btnUp.TextSize=13; btnUp.BorderSizePixel=0; Instance.new("UICorner",btnUp).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",btnUp).Color=Color3.fromRGB(40,40,40)
local btnDn=Instance.new("TextButton",fRow); btnDn.Size=UDim2.new(0.48,-3,1,0); btnDn.Position=UDim2.new(0.52,3,0,0); btnDn.BackgroundColor3=Color3.fromRGB(16,16,16); btnDn.TextColor3=Color3.new(1,1,1); btnDn.Text="▼  FLY DOWN"; btnDn.Font=Enum.Font.SciFi; btnDn.TextSize=13; btnDn.BorderSizePixel=0; Instance.new("UICorner",btnDn).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",btnDn).Color=Color3.fromRGB(40,40,40)
btnUp.MouseButton1Down:Connect(function() up=true end); btnUp.MouseButton1Up:Connect(function() up=false end)
btnDn.MouseButton1Down:Connect(function() down=true end); btnDn.MouseButton1Up:Connect(function() down=false end)

-- UI
Sec(P.UI,"НАСТРОЙКИ")
local UnlockBtn=Btn(P.UI,"🔓  UNLOCK MOVING: OFF",Color3.fromRGB(22,8,8))
UnlockBtn.MouseButton1Click:Connect(function()
    UI_Unlocked=not UI_Unlocked; UnlockBtn.Text=UI_Unlocked and "🔓  UNLOCK MOVING: ON" or "🔓  UNLOCK MOVING: OFF"
    UnlockBtn.BackgroundColor3=UI_Unlocked and Color3.fromRGB(8,30,8) or Color3.fromRGB(22,8,8)
    for _,o in pairs(Movable_Objects) do o.Active=UI_Unlocked; o.Draggable=UI_Unlocked end; Notify("MOVING "..(UI_Unlocked and "UNLOCKED" or "LOCKED"))
end)
local ConfigName="SauronConfig_V1.json"
Btn(P.UI,"💾  СОХРАНИТЬ КОНФИГ",Color3.fromRGB(8,8,22),function()
    if writefile then
        local d={}; for _,o in pairs(Movable_Objects) do d[o.Name]={XS=o.Position.X.Scale,XO=o.Position.X.Offset,YS=o.Position.Y.Scale,YO=o.Position.Y.Offset} end
        writefile(ConfigName,HttpService:JSONEncode(d)); Notify("КОНФИГ СОХРАНЁН")
    end
end)
task.spawn(function() if isfile and isfile(ConfigName) then pcall(function()
    local d=HttpService:JSONDecode(readfile(ConfigName))
    for _,o in pairs(Movable_Objects) do if d[o.Name] then o.Position=UDim2.new(d[o.Name].XS,d[o.Name].XO,d[o.Name].YS,d[o.Name].YO) end end
end) end end)

-- Запускаем первую вкладку
SwitchTab("PLAYER")

-- ════════════════════════════════════════════
-- WATERMARK
-- ════════════════════════════════════════════
task.spawn(function()
    local fn="AngerMOD.png"; local url="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"
    if writefile and isfile then pcall(function() if not isfile(fn) then writefile(fn,game:HttpGet(url,true)) end end) end
    local wg=Instance.new("ScreenGui",SG.Parent); wg.Name="SauronWatermark"; wg.ResetOnSpawn=false
    local wi=Instance.new("ImageLabel",wg); wi.Size=UDim2.new(0,260,0,65); wi.Position=UDim2.new(0,10,0,10); wi.BackgroundTransparency=1; wi.ScaleType=Enum.ScaleType.Fit
    if getcustomasset then local ok,a=pcall(function() return getcustomasset(fn) end); if ok and a~="" then wi.Image=a else wi.Image=url end else wi.Image=url end
end)

-- ════════════════════════════════════════════
-- LOGIC
-- ════════════════════════════════════════════
local function EmergencyBrake()
    local c=Player.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.Velocity=Vector3.zero; c.HumanoidRootPart.RotVelocity=Vector3.zero end
end
local function SendChat(msg)
    if game:GetService("TextChatService").ChatVersion==Enum.ChatVersion.TextChatService then
        pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg) end)
    else game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All") end
end
local function SmartMove(cf)
    local c=Player.Character; if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart"); local hum=c:FindFirstChild("Humanoid"); if not root or not hum then return end
    if hum.SeatPart and hum.SeatPart.Parent then hum.SeatPart.CFrame=cf; hum.SeatPart.Velocity=Vector3.zero
    else root.CFrame=cf; root.Velocity=Vector3.zero end
end
local function GetClosestPlayer()
    local t,d=nil,math.huge
    for _,v in pairs(Players:GetPlayers()) do
        if v~=Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
            local dd=(v.Character.Head.Position-Camera.CFrame.Position).Magnitude; if dd<d then d=dd; t=v.Character end
        end
    end; return t
end

RecBtn.MouseButton1Click:Connect(function()
    States.IsRecording=not States.IsRecording
    if States.IsRecording then States.IsPlaying=false; RecordedPath={}; RecBtn.Text="⏹  STOP REC"; RecBtn.BackgroundColor3=Color3.fromRGB(200,0,0); AIStatus.Text="  STATUS: RECORDING..."
    else RecBtn.Text="⏺  RECORD"; RecBtn.BackgroundColor3=Color3.fromRGB(40,8,8); AIStatus.Text="  STATUS: SAVED "..#RecordedPath.." FRAMES" end
end)
local function StartPlayback()
    if #RecordedPath==0 then AIStatus.Text="  ERROR: NO RECORDING"; States.IsPlaying=false; return end
    local c=Player.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChild("Humanoid")
    if r and h then h.PlatformStand=true; r.Anchored=true end
    task.spawn(function()
        while States.IsPlaying do
            for _,fr in ipairs(RecordedPath) do if not States.IsPlaying then break end; SmartMove(fr.CF); RunService.Heartbeat:Wait() end
            if not States.LoopPlay then States.IsPlaying=false; PlayBtn.Text="▶  PLAY"; PlayBtn.BackgroundColor3=Color3.fromRGB(8,40,8); break end
        end
        local pc=Player.Character; if pc then local rr=pc:FindFirstChild("HumanoidRootPart"); local hh=pc:FindFirstChild("Humanoid")
            if rr then rr.Anchored=false; rr.Velocity=Vector3.zero end; if hh then hh.PlatformStand=false end end
        AIStatus.Text="  STATUS: IDLE"
    end)
end
PlayBtn.MouseButton1Click:Connect(function()
    States.IsPlaying=not States.IsPlaying
    if States.IsPlaying then States.IsRecording=false; RecBtn.Text="⏺  RECORD"; PlayBtn.Text="⏹  STOP"; PlayBtn.BackgroundColor3=Color3.fromRGB(200,50,0); StartPlayback()
    else PlayBtn.Text="▶  PLAY"; PlayBtn.BackgroundColor3=Color3.fromRGB(8,40,8); EmergencyBrake() end
end)

local AI_DB=false
local function ProcessAI(msg,name)
    if AI_DB or not States.AI then return end; AI_DB=true; AIStatus.Text="  STATUS: THINKING..."
    local key=AIKeyBox.Text; if key=="" then AIStatus.Text="  ERROR: NO KEY"; AI_DB=false; return end
    table.insert(ChatHistory,{role="user",content=name..": "..msg}); if #ChatHistory>10 then table.remove(ChatHistory,2) end
    local ok,resp=pcall(function()
        if request then return request({Url="https://api.groq.com/openai/v1/chat/completions",Method="POST",
            Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..key},
            Body=HttpService:JSONEncode({model=GroqModels[CurrentModelIndex],messages=ChatHistory,max_tokens=60})}) end
    end)
    if ok and resp and resp.Body then
        local d=pcall(function() d=HttpService:JSONDecode(resp.Body) end); if type(d)=="table" and d.choices and d.choices[1] then
            local r=d.choices[1].message.content; SendChat(r); table.insert(ChatHistory,{role="assistant",content=r}); AIStatus.Text="  STATUS: REPLIED"
        else AIStatus.Text="  ERROR: API" end
    else AIStatus.Text="  ERROR: REQUEST" end
    task.wait(2); AI_DB=false; AIStatus.Text="  STATUS: IDLE"
end
for _,p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(m) if p~=Player then ProcessAI(m,p.Name) end end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(m) if p~=Player then ProcessAI(m,p.Name) end end) end)

local function SpawnRipple()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root=Player.Character.HumanoidRootPart
    local ray=Workspace:Raycast(root.Position,Vector3.new(0,-10,0),RaycastParams.new())
    local sp=ray and ray.Position or (root.Position-Vector3.new(0,2.8,0))
    local p=Instance.new("Part",Workspace); p.Name="SauronRipple"; p.Anchored=true; p.CanCollide=false
    if States.UsePentagram then
        p.Transparency=1; p.Size=Vector3.new(1,0.05,1); p.CFrame=CFrame.new(sp)
        local sg=Instance.new("SurfaceGui",p); sg.Face=Enum.NormalId.Top; sg.LightInfluence=0
        local img=Instance.new("ImageLabel",sg); img.Size=UDim2.new(1,0,1,0); img.BackgroundTransparency=1
        local ok,a=pcall(function() return getcustomasset("Anger_Pentagram_Circle1.png") end); if ok then img.Image=a end
        table.insert(RGB_Objects,{Type="Image",Instance=img})
        TweenService:Create(p,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(valRipple,0.05,valRipple)}):Play()
        TweenService:Create(img,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{ImageTransparency=1}):Play()
    else
        p.Shape=Enum.PartType.Cylinder; p.Material=Enum.Material.Neon; p.Size=Vector3.new(0.1,1,1)
        p.CFrame=CFrame.new(sp)*CFrame.Angles(0,0,math.rad(90)); p.Color=Color3.new(1,1,1); table.insert(RGB_Objects,{Type="Part",Instance=p})
        TweenService:Create(p,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(0.1,valRipple,valRipple),Transparency=1}):Play()
    end; Debris:AddItem(p,1.5)
end

task.spawn(function()
    if writefile and isfile then pcall(function() if not isfile("Anger_Pentagram_Circle1.png") then writefile("Anger_Pentagram_Circle1.png",game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/circle1.png",true)) end end) end
end)

Player.CharacterAdded:Connect(function(char) DS.Enabled=false; char:WaitForChild("Humanoid").Died:Connect(function() DS.Enabled=true end) end)
UserInputService.JumpRequest:Connect(function()
    if States.InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    if States.Circle then SpawnRipple() end
end)
Player.Idled:Connect(function() if States.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

-- ════════════════════════════════════════════
-- ESP DRAWING
-- ════════════════════════════════════════════
local SkeletonPairs={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"Head","Torso"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}}
local function NL2(c,t,tr) local l=Drawing.new("Line"); l.Color=c or Color3.new(1,1,1); l.Thickness=t or 1; l.Transparency=tr or 1; l.Visible=false; return l end
local function CreateESP(player)
    if ESPData[player] then return end
    local box=Drawing.new("Quad"); box.Filled=false; box.Thickness=1; box.Visible=false
    local corners={}; for i=1,8 do corners[i]=NL2(Color3.new(1,1,1),2.5) end
    local nL=Drawing.new("Text"); nL.Size=14; nL.Font=Drawing.Fonts.Plex; nL.Center=true; nL.Outline=true; nL.Visible=false
    local dL=Drawing.new("Text"); dL.Size=11; dL.Font=Drawing.Fonts.Plex; dL.Center=true; dL.Outline=true; dL.Color=Color3.fromRGB(200,200,200); dL.Visible=false
    local hBg=NL2(Color3.fromRGB(10,10,10),5); hBg.Transparency=0
    local hBar=NL2(Color3.fromRGB(0,255,80),3); hBar.Transparency=0
    local hTxt=Drawing.new("Text"); hTxt.Size=10; hTxt.Font=Drawing.Fonts.Plex; hTxt.Outline=true; hTxt.Visible=false
    local sks={}; for i=1,#SkeletonPairs do sks[i]=NL2(Color3.fromRGB(255,255,100),1) end
    local trc=NL2(Color3.new(1,1,1),1,0.6)
    local ln=Drawing.new("Line"); ln.Visible=false; ln.Color=Color3.new(1,1,1); ln.Thickness=2; ln.Transparency=0.8; ESPLines[player]=ln
    ESPData[player]={box=box,corners=corners,nL=nL,dL=dL,hBg=hBg,hBar=hBar,hTxt=hTxt,sks=sks,trc=trc}
end
local function RemoveESP(player)
    local d=ESPData[player]; if not d then return end
    d.box:Remove(); for _,c in ipairs(d.corners) do c:Remove() end
    d.nL:Remove(); d.dL:Remove(); d.hBg:Remove(); d.hBar:Remove(); d.hTxt:Remove()
    for _,l in ipairs(d.sks) do l:Remove() end; d.trc:Remove(); ESPData[player]=nil
    if ESPLines[player] then ESPLines[player]:Remove(); ESPLines[player]=nil end
    if RadarDots[player] then RadarDots[player].dot:Destroy(); RadarDots[player]=nil end
end
for _,p in pairs(Players:GetPlayers()) do if p~=Player then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) CreateESP(p) end)
Players.PlayerRemoving:Connect(function(p) RemoveESP(p) end)

-- RADAR
local RF=Instance.new("Frame",SG); RF.Name="SauronRadar"; RF.Size=UDim2.new(0,160,0,160); RF.Position=UDim2.new(1,-175,0,10)
RF.BackgroundColor3=Color3.fromRGB(5,5,5); RF.BackgroundTransparency=0.25; RF.Visible=RADAR_ESP; RF.BorderSizePixel=0
Instance.new("UICorner",RF).CornerRadius=UDim.new(1,0); local RFS=Instance.new("UIStroke",RF); RFS.Thickness=2; RFS.Color=Color3.fromRGB(80,0,0); table.insert(RGB_Objects,{Type="Stroke",Instance=RFS}); table.insert(Movable_Objects,RF)
local RT=Instance.new("TextLabel",RF); RT.Size=UDim2.new(1,0,0,18); RT.BackgroundTransparency=1; RT.Text="⚔ RADAR"; RT.Font=Enum.Font.SciFi; RT.TextSize=11; RT.TextColor3=Color3.fromRGB(200,0,0)
local RS=Instance.new("Frame",RF); RS.Size=UDim2.new(0,8,0,8); RS.Position=UDim2.new(0.5,-4,0.5,-4); RS.BackgroundColor3=Color3.fromRGB(0,255,100); RS.BorderSizePixel=0; Instance.new("UICorner",RS).CornerRadius=UDim.new(1,0)
local function GetRDot(player)
    if not RadarDots[player] then
        local dot=Instance.new("Frame",RF); dot.Size=UDim2.new(0,6,0,6); dot.BackgroundColor3=Color3.fromRGB(255,50,50); dot.BorderSizePixel=0; dot.ZIndex=5; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local lbl=Instance.new("TextLabel",dot); lbl.Size=UDim2.new(0,55,0,12); lbl.Position=UDim2.new(1,3,0,-3); lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(1,1,1); lbl.Font=Enum.Font.SciFi; lbl.TextSize=9; lbl.Text=player.Name:sub(1,7)
        RadarDots[player]={dot=dot,lbl=lbl}
    end; return RadarDots[player]
end

local function UpdateESP(ac)
    local myChar=Player.Character; local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
    local anyESP=ESP_States.BOX or ESP_States.NAME or ESP_States.HEALTH or ESP_States.DISTANCE or ESP_States.SKELETON or ESP_States.TRACER
    for _,p in pairs(Players:GetPlayers()) do
        if p==Player then continue end
        local d=ESPData[p]; if not d then continue end
        local char=p.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local root=char and char:FindFirstChild("HumanoidRootPart"); local head=char and char:FindFirstChild("Head")
        local ln=ESPLines[p]
        local function hide()
            d.box.Visible=false; for _,c in ipairs(d.corners) do c.Visible=false end
            d.nL.Visible=false; d.dL.Visible=false; d.hBg.Visible=false; d.hBar.Visible=false; d.hTxt.Visible=false
            for _,l in ipairs(d.sks) do l.Visible=false end; d.trc.Visible=false
            if ln then ln.Visible=false end; if RadarDots[p] then RadarDots[p].dot.Visible=false end
        end
        if not char or not root or not head or not hum or hum.Health<=0 then hide(); continue end
        local tV,tOn=Camera:WorldToViewportPoint(root.Position+Vector3.new(0,3.2,0))
        local bV,bOn=Camera:WorldToViewportPoint(root.Position-Vector3.new(0,2.8,0))
        if not tOn and not bOn then hide(); continue end
        local H=math.abs(tV.Y-bV.Y); local W=H*0.55; local cx=tV.X; local T=tV.Y; local B=bV.Y; local L=cx-W/2; local R=cx+W/2
        local dist=myRoot and math.floor((root.Position-myRoot.Position).Magnitude) or 0
        local hpPct=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1); local hpC=Color3.fromRGB(math.floor(255*(1-hpPct)),math.floor(255*hpPct),50)
        if anyESP and ESP_States.BOX then
            d.box.PointA=Vector2.new(L,T); d.box.PointB=Vector2.new(R,T); d.box.PointC=Vector2.new(R,B); d.box.PointD=Vector2.new(L,B); d.box.Color=ac; d.box.Transparency=0.5; d.box.Visible=true
            local cL=W*0.22; local cH=H*0.15; local cp={{L,T,L+cL,T},{L,T,L,T+cH},{R,T,R-cL,T},{R,T,R,T+cH},{L,B,L+cL,B},{L,B,L,B-cH},{R,B,R-cL,B},{R,B,R,B-cH}}
            for i,c in ipairs(d.corners) do c.From=Vector2.new(cp[i][1],cp[i][2]); c.To=Vector2.new(cp[i][3],cp[i][4]); c.Color=Color3.new(1,1,1); c.Visible=true end
        else d.box.Visible=false; for _,c in ipairs(d.corners) do c.Visible=false end end
        if anyESP and ESP_States.NAME then
            d.nL.Text=ESP_States.DISTANCE and string.format("[ %s  %dm ]",p.Name,dist) or string.format("[ %s ]",p.Name); d.nL.Position=Vector2.new(cx,T-17); d.nL.Color=ac; d.nL.Visible=true; d.dL.Visible=false
        elseif anyESP and ESP_States.DISTANCE then d.nL.Visible=false; d.dL.Text=dist.."m"; d.dL.Position=Vector2.new(cx,T-15); d.dL.Visible=true
        else d.nL.Visible=false; d.dL.Visible=false end
        if anyESP and ESP_States.HEALTH then
            local bx=L-7; local bf=T+(B-T)*(1-hpPct)
            d.hBg.From=Vector2.new(bx,T); d.hBg.To=Vector2.new(bx,B); d.hBg.Visible=true
            d.hBar.From=Vector2.new(bx,bf); d.hBar.To=Vector2.new(bx,B); d.hBar.Color=hpC; d.hBar.Visible=true
            d.hTxt.Text=math.floor(hum.Health).."hp"; d.hTxt.Position=Vector2.new(bx+4,bf-8); d.hTxt.Color=hpC; d.hTxt.Visible=true
        else d.hBg.Visible=false; d.hBar.Visible=false; d.hTxt.Visible=false end
        if anyESP and ESP_States.SKELETON then
            for i,pair in ipairs(SkeletonPairs) do local pA=char:FindFirstChild(pair[1]); local pB=char:FindFirstChild(pair[2]); local sl=d.sks[i]
                if pA and pB then local vA,oA=Camera:WorldToViewportPoint(pA.Position); local vB,oB=Camera:WorldToViewportPoint(pB.Position)
                    if oA or oB then sl.From=Vector2.new(vA.X,vA.Y); sl.To=Vector2.new(vB.X,vB.Y); sl.Color=ac; sl.Visible=true else sl.Visible=false end
                else sl.Visible=false end
            end
        else for _,l in ipairs(d.sks) do l.Visible=false end end
        if anyESP and ESP_States.TRACER then
            local rv,ron=Camera:WorldToViewportPoint(root.Position); d.trc.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); d.trc.To=Vector2.new(rv.X,rv.Y); d.trc.Color=ac; d.trc.Visible=ron
        else d.trc.Visible=false end
        if ESP_States.CHAMS then
            if not char:FindFirstChild("SauronESP") then local hl=Instance.new("Highlight",char); hl.Name="SauronESP"; hl.FillTransparency=0.5; hl.OutlineTransparency=0
            else char.SauronESP.FillColor=ac end
        else if char:FindFirstChild("SauronESP") then char.SauronESP:Destroy() end end
        if RADAR_ESP and myRoot then local rd=GetRDot(p); local rel=myRoot.CFrame:inverse()*CFrame.new(root.Position)
            local rx=math.clamp(rel.X/70,-1,1); local rz=math.clamp(-rel.Z/70,-1,1)
            rd.dot.Position=UDim2.new(0,rx*65+77,0,rz*65+77); rd.dot.BackgroundColor3=hpC; rd.dot.Visible=true
        elseif RadarDots[p] then RadarDots[p].dot.Visible=false end
    end; RS.BackgroundColor3=ac
end

-- ════════════════════════════════════════════
-- RENDER LOOP
-- ════════════════════════════════════════════
local lastGhost=0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local t=tick(); local cn=Themes[CurrentThemeIndex]; local ac=Color3.new(1,1,1)
        if cn=="RGB" then ac=Color3.fromHSV(t%3/3,1,1) elseif ThemeColors[cn] then ac=ThemeColors[cn] end

        -- RGB objects colour sync
        for i,obj in pairs(RGB_Objects) do
            if obj.Instance and obj.Instance.Parent then
                if obj.Type=="Stroke" then obj.Instance.Color=ac
                elseif obj.Type=="Text"  then obj.Instance.TextColor3=ac
                elseif obj.Type=="Image" then obj.Instance.ImageColor3=ac
                elseif obj.Type=="Part"  then obj.Instance.Color=ac end
            else table.remove(RGB_Objects,i) end
        end

        -- Watermark
        local wm=SG.Parent:FindFirstChild("SauronWatermark"); if wm then wm.Enabled=States.Watermark end
        DL.TextColor3=ac; RF.Visible=RADAR_ESP

        -- Info tab
        if P.INFO.Visible then
            pcall(function()
                InfoLabel.Text=string.format(
                    "  SESSION: %s\n  USER: %s\n  FPS: %d\n  PING: %d ms\n  GAME: %s",
                    SessionID, Player.Name,
                    math.floor(Workspace:GetRealPhysicsFPS()),
                    math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()),
                    game.Name)
            end)
        end

        -- ESP
        UpdateESP(ac)

        -- Character
        local char=Player.Character; if not char then return end
        local hum=char:FindFirstChild("Humanoid")
        local root=char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        -- FULLBRIGHT
        if States.Fullbright then
            Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=1e6
        end

        -- NO FOG
        if States.NoFog then
            Lighting.FogEnd=1e6; Lighting.FogStart=1e6
        end

        -- AMBIENT SYNC
        if States.AmbientSync then
            Lighting.OutdoorAmbient=ac; Lighting.Ambient=ac
        end

        -- RGB SKIN
        if States.RGB then
            local bc=char:FindFirstChild("Body Colors")
            if bc then bc.HeadColor3=ac; bc.TorsoColor3=ac; bc.LeftArmColor3=ac; bc.RightArmColor3=ac; bc.LeftLegColor3=ac; bc.RightLegColor3=ac end
        end

        -- RAGE SPEED — просто WalkSpeed
        if States.Spd then
            hum.WalkSpeed = valSpeed
        else
            if hum.WalkSpeed == valSpeed then hum.WalkSpeed = 16 end
        end

        -- SUPER JUMP
        if States.Jump then
            hum.UseJumpPower = true
            hum.JumpPower = valJumpPower
        else
            if hum.JumpPower == valJumpPower then
                hum.UseJumpPower = true; hum.JumpPower = 50
            end
        end

        -- FLY
        if States.Fly then
            local bv = root:FindFirstChild("SauronFlyVel") or Instance.new("BodyVelocity", root)
            bv.Name = "SauronFlyVel"; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            local dir = hum.MoveDirection * valFlySpeed
            if up   then dir = dir + Vector3.new(0, valFlySpeed, 0) end
            if down then dir = dir - Vector3.new(0, valFlySpeed, 0) end
            if dir == Vector3.zero then dir = Vector3.new(0, 0.1, 0) end
            bv.Velocity = dir
        else
            local bv = root:FindFirstChild("SauronFlyVel"); if bv then bv:Destroy() end
        end

        -- SPEED BYPASS (телепорт вперёд)
        if States.SpdBypass and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * valBypassSpeed)
        end

        -- AIM
        if States.Aim then
            local tgt = GetClosestPlayer()
            if tgt and tgt:FindFirstChild("Head") then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tgt.Head.Position), valSmooth)
            end
        end

        -- ANTI KNOCKBACK
        if States.AntiKnockback then
            if root.Velocity.Magnitude > 50 then
                root.Velocity = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection * hum.WalkSpeed or Vector3.zero
                root.RotVelocity = Vector3.zero
            end
        end

        -- RECORD
        if States.IsRecording then
            table.insert(RecordedPath, {CF = hum.SeatPart and hum.SeatPart.CFrame or root.CFrame})
        end

        -- INF ZOOM
        if States.UnlockAll then
            Player.CameraMaxZoomDistance = 999999
            Player.CameraMinZoomDistance = 0
        end

        -- BIG HITBOX
        if States.Hitbox then
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character then
                    local hd = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Head")
                    if hd then
                        hd.Size = Vector3.new(valHitbox, valHitbox, valHitbox)
                        hd.Transparency = 0.8; hd.CanCollide = false
                        hd.Color = ac; hd.Material = Enum.Material.Neon
                    end
                end
            end
        else
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character then
                    local hd = v.Character:FindFirstChild("HumanoidRootPart")
                    if hd and hd.Size ~= Vector3.new(2,2,1) then
                        hd.Size = Vector3.new(2,2,1); hd.Transparency = 1
                    end
                end
            end
        end

        -- KILL AURA
        if States.KillAura then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist < 50 and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                            tool.Handle.CFrame = v.Character.HumanoidRootPart.CFrame
                            tool:Activate()
                            pcall(function()
                                firetouchinterest(tool.Handle, v.Character.HumanoidRootPart, 0)
                                firetouchinterest(tool.Handle, v.Character.HumanoidRootPart, 1)
                            end)
                            break
                        end
                    end
                end
            end
        end

        -- GHOST TRAIL
        if States.Ghosts and tick()-lastGhost > valGhostRate then
            lastGhost = tick()
            for _,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.Transparency < 1 then
                    local g = v:Clone(); g.Parent = Workspace; g.Anchored = true; g.CanCollide = false
                    g.CFrame = v.CFrame; g.Color = ac; g.Material = Enum.Material.Neon; g:ClearAllChildren()
                    TweenService:Create(g, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Transparency=1, CFrame=g.CFrame*CFrame.Angles(math.rad(math.random(-30,30)),math.rad(math.random(-30,30)),0)}):Play()
                    Debris:AddItem(g, 0.5)
                end
            end
        end

    end)
end)

Notify("⚔ SAURON V1 — LOADED")

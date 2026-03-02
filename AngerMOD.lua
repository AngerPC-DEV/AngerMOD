-- ⚔ SAURON V1 | by AngerPC-DEV ⚔

-- ══════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local Lighting      = game:GetService("Lighting")
local Debris        = game:GetService("Debris")
local VirtualUser   = game:GetService("VirtualUser")
local Stats         = game:GetService("Stats")
local HttpService   = game:GetService("HttpService")
local Workspace     = game:GetService("Workspace")
local Camera        = Workspace.CurrentCamera
local Player        = Players.LocalPlayer

local request        = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local getcustomasset = getcustomasset or getsynasset

local SessionID = string.upper(HttpService:GenerateGUID(false):sub(1,8))

local GroqModels = {
    "llama-3.3-70b-versatile",
    "llama-3.1-70b-versatile",
    "deepseek-r1-distill-llama-70b"
}
local CurrentModelIndex = 1

local Themes = { "RGB","БЕЛЫЙ","СЕРЫЙ","ГОЛУБОЙ","ФИОЛЕТОВЫЙ","НЕОБЫЧНЫЙ","РОЗОВЫЙ","КРАСНЫЙ" }
local ThemeColors = {
    ["БЕЛЫЙ"]=Color3.new(1,1,1), ["СЕРЫЙ"]=Color3.fromRGB(120,120,120),
    ["ГОЛУБОЙ"]=Color3.fromRGB(0,190,255), ["ФИОЛЕТОВЫЙ"]=Color3.fromRGB(170,0,255),
    ["НЕОБЫЧНЫЙ"]=Color3.fromRGB(255,170,0), ["РОЗОВЫЙ"]=Color3.fromRGB(255,105,180),
    ["КРАСНЫЙ"]=Color3.fromRGB(255,0,0)
}
local CurrentThemeIndex = 1

local ChatHistory = {{role="system",content="Ты — SAURON, мощный ИИ-бот в Roblox. Создатель: AngerPC-DEV. Характер: дерзкий, краткий."}}

local CurrentSound = nil
local MusicPlaying = false

-- ══════════════════════════════════════════════
-- GAME STATES & VALUES
-- ══════════════════════════════════════════════
local States = {
    Watermark=true, Aim=false, Hitbox=false, AntiKnockback=false, UnlockAll=false,
    SpdBypass=false, Fly=false, Spd=false, Jump=false, Circle=false, UsePentagram=false,
    Ghosts=false, Esp=false, RGB=false, Fullbright=false, InfJump=false, AntiAfk=true,
    NoFog=false, AmbientSync=false, AI=false, FriendBot=false, IsFollowing=true,
    IsRecording=false, IsPlaying=false, LoopPlay=false, KillAura=false
}
local valSmooth=0.15; local valHitbox=5; local valFlySpeed=5; local valSpeed=50
local valBypassSpeed=0.11; local valJumpPower=100; local valRipple=15; local valGhostRate=0.05
local up,down = false,false

local RecordedPath = {}
local ESPLines = {}
local RGB_Objects = {}
local Movable_Objects = {}
local UI_Unlocked = false

local ESP_States = {BOX=true,NAME=true,HEALTH=true,DISTANCE=true,SKELETON=false,TRACER=false,CHAMS=false}
local RADAR_ESP = true
local ESPData = {}
local RadarDots = {}

-- ══════════════════════════════════════════════
-- ████  LOGIN SYSTEM  ████
-- ══════════════════════════════════════════════
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "SauronLogin"
LoginGui.ResetOnSpawn = false
LoginGui.DisplayOrder = 999
LoginGui.IgnoreGuiInset = true
LoginGui.Parent = Player:WaitForChild("PlayerGui")

-- Фон
local Bg = Instance.new("Frame", LoginGui)
Bg.Size = UDim2.new(1,0,1,0)
Bg.BackgroundColor3 = Color3.fromRGB(4,4,4)
Bg.BorderSizePixel = 0

-- Анимированная красная полоса сверху
local TopGlow = Instance.new("Frame", Bg)
TopGlow.Size = UDim2.new(1,0,0,3)
TopGlow.Position = UDim2.new(0,0,0,0)
TopGlow.BackgroundColor3 = Color3.fromRGB(200,0,0)
TopGlow.BorderSizePixel = 0

-- Центральная карточка
local Card = Instance.new("Frame", Bg)
Card.Size = UDim2.new(0,380,0,340)
Card.Position = UDim2.new(0.5,-190,0.5,-170)
Card.BackgroundColor3 = Color3.fromRGB(10,10,10)
Card.BorderSizePixel = 0
Instance.new("UICorner",Card).CornerRadius = UDim.new(0,16)
local cardStroke = Instance.new("UIStroke",Card)
cardStroke.Thickness = 1.5
cardStroke.Color = Color3.fromRGB(80,0,0)

-- Логотип
local LogoFrame = Instance.new("Frame", Card)
LogoFrame.Size = UDim2.new(1,0,0,80)
LogoFrame.Position = UDim2.new(0,0,0,0)
LogoFrame.BackgroundTransparency = 1

local LogoImg = Instance.new("ImageLabel", LogoFrame)
LogoImg.Size = UDim2.new(0,240,0,60)
LogoImg.Position = UDim2.new(0.5,-120,0.5,-30)
LogoImg.BackgroundTransparency = 1
LogoImg.ScaleType = Enum.ScaleType.Fit
LogoImg.Image = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"

-- Если лого не загрузилось — текст
local LogoFallback = Instance.new("TextLabel", LogoFrame)
LogoFallback.Size = UDim2.new(1,0,1,0)
LogoFallback.BackgroundTransparency = 1
LogoFallback.Text = "⚔ SAURON"
LogoFallback.Font = Enum.Font.SciFi
LogoFallback.TextSize = 38
LogoFallback.TextColor3 = Color3.fromRGB(220,0,0)
LogoFallback.Visible = false

task.spawn(function()
    task.wait(2)
    if LogoImg.IsLoaded == false or LogoImg.ContentImageSize == Vector2.new(0,0) then
        LogoFallback.Visible = true
        LogoImg.Visible = false
    end
end)

-- Разделитель
local Div1 = Instance.new("Frame", Card)
Div1.Size = UDim2.new(0.85,0,0,1)
Div1.Position = UDim2.new(0.075,0,0,84)
Div1.BackgroundColor3 = Color3.fromRGB(35,35,35)
Div1.BorderSizePixel = 0

-- Подзаголовок
local SubLbl = Instance.new("TextLabel", Card)
SubLbl.Size = UDim2.new(1,0,0,20)
SubLbl.Position = UDim2.new(0,0,0,90)
SubLbl.BackgroundTransparency = 1
SubLbl.Text = "ВВЕДИ КЛЮЧ ДОСТУПА"
SubLbl.Font = Enum.Font.SciFi
SubLbl.TextSize = 11
SubLbl.TextColor3 = Color3.fromRGB(90,90,90)

-- Инпут ключа
local KeyBox = Instance.new("TextBox", Card)
KeyBox.Size = UDim2.new(0.88,0,0,46)
KeyBox.Position = UDim2.new(0.06,0,0,118)
KeyBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "SAURON-XXXXXXXX"
KeyBox.PlaceholderColor3 = Color3.fromRGB(55,55,55)
KeyBox.Text = ""
KeyBox.Font = Enum.Font.SciFi
KeyBox.TextSize = 16
KeyBox.ClearTextOnFocus = false
KeyBox.BorderSizePixel = 0
local kbCorner = Instance.new("UICorner",KeyBox); kbCorner.CornerRadius = UDim.new(0,10)
local kbStroke = Instance.new("UIStroke",KeyBox); kbStroke.Thickness=1.5; kbStroke.Color=Color3.fromRGB(45,45,45)

-- Статус
local StatusLbl = Instance.new("TextLabel", Card)
StatusLbl.Size = UDim2.new(0.88,0,0,20)
StatusLbl.Position = UDim2.new(0.06,0,0,172)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "● ожидание ключа"
StatusLbl.Font = Enum.Font.SciFi
StatusLbl.TextSize = 12
StatusLbl.TextColor3 = Color3.fromRGB(80,80,80)
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Прогресс-бар
local ProgBg = Instance.new("Frame", Card)
ProgBg.Size = UDim2.new(0.88,0,0,4)
ProgBg.Position = UDim2.new(0.06,0,0,200)
ProgBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
ProgBg.BorderSizePixel = 0
ProgBg.Visible = false
Instance.new("UICorner",ProgBg).CornerRadius = UDim.new(1,0)
local ProgFill = Instance.new("Frame",ProgBg)
ProgFill.Size = UDim2.new(0,0,1,0)
ProgFill.BackgroundColor3 = Color3.fromRGB(200,0,0)
ProgFill.BorderSizePixel = 0
Instance.new("UICorner",ProgFill).CornerRadius = UDim.new(1,0)

-- Кнопка логина
local LoginBtn = Instance.new("TextButton", Card)
LoginBtn.Size = UDim2.new(0.88,0,0,48)
LoginBtn.Position = UDim2.new(0.06,0,0,215)
LoginBtn.BackgroundColor3 = Color3.fromRGB(160,0,0)
LoginBtn.TextColor3 = Color3.new(1,1,1)
LoginBtn.Text = "▶  ВОЙТИ"
LoginBtn.Font = Enum.Font.SciFi
LoginBtn.TextSize = 16
LoginBtn.BorderSizePixel = 0
Instance.new("UICorner",LoginBtn).CornerRadius = UDim.new(0,12)

-- Версия
local VerLbl = Instance.new("TextLabel", Card)
VerLbl.Size = UDim2.new(1,0,0,22)
VerLbl.Position = UDim2.new(0,0,0,276)
VerLbl.BackgroundTransparency = 1
VerLbl.Text = "SAURON V1  ·  secured  ·  AngerPC-DEV"
VerLbl.Font = Enum.Font.SciFi
VerLbl.TextSize = 10
VerLbl.TextColor3 = Color3.fromRGB(38,38,38)

-- Пульс карточки
task.spawn(function()
    while LoginGui.Parent do
        TweenService:Create(cardStroke,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(220,0,0)}):Play()
        task.wait(1.2)
        TweenService:Create(cardStroke,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(60,0,0)}):Play()
        task.wait(1.2)
    end
end)

-- Hover
LoginBtn.MouseEnter:Connect(function() TweenService:Create(LoginBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(210,0,0)}):Play() end)
LoginBtn.MouseLeave:Connect(function() TweenService:Create(LoginBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(160,0,0)}):Play() end)

-- Загрузка ключей
local ValidKeys = {}
local KeysLoaded = false
task.spawn(function()
    local ok, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.sauron",true)
    end)
    if ok and res and #res > 2 then
        for line in res:gmatch("[^\r\n]+") do
            line = line:match("^%s*(.-)%s*$")
            local key = line:match("|%s*(.+)$") or line
            key = key:match("^%s*(.-)%s*$")
            if key and #key > 3 then ValidKeys[key]=true end
        end
        StatusLbl.Text = "● сервер доступен"
        StatusLbl.TextColor3 = Color3.fromRGB(0,160,60)
        KeysLoaded = true
    else
        StatusLbl.Text = "● оффлайн режим"
        StatusLbl.TextColor3 = Color3.fromRGB(200,140,0)
    end
end)

-- Логин функция
local function TryLogin()
    local key = KeyBox.Text:match("^%s*(.-)%s*$")
    if key=="" then
        StatusLbl.Text = "● введи ключ!"
        StatusLbl.TextColor3 = Color3.fromRGB(220,50,50)
        TweenService:Create(kbStroke,TweenInfo.new(0.1),{Color=Color3.fromRGB(200,0,0)}):Play()
        task.wait(0.5); TweenService:Create(kbStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(45,45,45)}):Play()
        return
    end
    LoginBtn.Active=false; LoginBtn.Text="⏳  ПРОВЕРКА..."
    StatusLbl.Text="● проверяем ключ..."; StatusLbl.TextColor3=Color3.fromRGB(200,160,0)
    ProgBg.Visible=true
    TweenService:Create(ProgFill,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(1)

    local valid = ValidKeys[key] or (not KeysLoaded and key:sub(1,7)=="SAURON-" and #key>=10)
    if valid then
        StatusLbl.Text="● доступ разрешён!"; StatusLbl.TextColor3=Color3.fromRGB(0,220,80)
        LoginBtn.Text="✅  ДОБРО ПОЖАЛОВАТЬ"; LoginBtn.BackgroundColor3=Color3.fromRGB(0,120,40)
        TweenService:Create(cardStroke,TweenInfo.new(0.3),{Color=Color3.fromRGB(0,200,80)}):Play()
        task.wait(0.7)
        TweenService:Create(Card,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-190,-0.1,-170)}):Play()
        TweenService:Create(Bg,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        task.wait(0.5)
        LoginGui:Destroy()
    else
        StatusLbl.Text="● неверный ключ!"; StatusLbl.TextColor3=Color3.fromRGB(220,50,50)
        LoginBtn.Text="▶  ВОЙТИ"; LoginBtn.BackgroundColor3=Color3.fromRGB(160,0,0); LoginBtn.Active=true
        ProgBg.Visible=false; ProgFill.Size=UDim2.new(0,0,1,0)
        local p=Card.Position
        for i=1,5 do task.wait(0.04); Card.Position=p+UDim2.new(0,(i%2==0 and 7 or -7),0,0) end
        Card.Position=p
    end
end

LoginBtn.MouseButton1Click:Connect(TryLogin)
KeyBox.FocusLost:Connect(function(enter) if enter then TryLogin() end end)

-- Ждём логин
repeat task.wait(0.05) until not LoginGui or not LoginGui.Parent or not LoginGui:IsDescendantOf(game)

-- ══════════════════════════════════════════════
-- ████  MAIN SCREENGUI  ████
-- ══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SauronGUI_V1"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = Player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- Death screen
local DeathScreen = Instance.new("ScreenGui",ScreenGui.Parent)
DeathScreen.Name="SauronDeath"; DeathScreen.Enabled=false
local DeathLabel = Instance.new("TextLabel",DeathScreen)
DeathLabel.Size=UDim2.new(1,0,1,0); DeathLabel.BackgroundTransparency=1
DeathLabel.Text="WASTED"; DeathLabel.Font=Enum.Font.Creepster
DeathLabel.TextSize=100; DeathLabel.TextColor3=Color3.fromRGB(255,0,0); DeathLabel.TextStrokeTransparency=0

-- ══════════════════════════════════════════════
-- HELPER BUILDERS
-- ══════════════════════════════════════════════
local function AddStroke(obj, color, thick)
    local s=Instance.new("UIStroke",obj); s.Color=color or Color3.fromRGB(40,40,40); s.Thickness=thick or 1
    table.insert(RGB_Objects,{Type="Stroke",Instance=s}); return s
end

local function RoundFrame(parent, bg, radius)
    local f=Instance.new("Frame",parent); f.BackgroundColor3=bg or Color3.fromRGB(14,14,14); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,radius or 8); return f
end

-- Уведомления
local NotifyContainer = Instance.new("Frame",ScreenGui)
NotifyContainer.Size=UDim2.new(0,240,0.4,0); NotifyContainer.Position=UDim2.new(1,-250,0.55,0)
NotifyContainer.BackgroundTransparency=1
local NL=Instance.new("UIListLayout",NotifyContainer); NL.SortOrder=Enum.SortOrder.LayoutOrder
NL.VerticalAlignment=Enum.VerticalAlignment.Bottom; NL.Padding=UDim.new(0,4)

local function Notify(text)
    local f=Instance.new("Frame",NotifyContainer)
    f.Size=UDim2.new(1,0,0,36); f.BackgroundColor3=Color3.fromRGB(12,12,12); f.BackgroundTransparency=1; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local ls=Instance.new("UIStroke",f); ls.Thickness=1; ls.Color=Color3.fromRGB(60,0,0)
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-12,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.new(1,1,1)
    l.Font=Enum.Font.SciFi; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextTransparency=1
    TweenService:Create(f,TweenInfo.new(0.25),{BackgroundTransparency=0.1}):Play()
    TweenService:Create(l,TweenInfo.new(0.25),{TextTransparency=0}):Play()
    task.delay(3,function()
        TweenService:Create(f,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        TweenService:Create(l,TweenInfo.new(0.4),{TextTransparency=1}):Play()
        task.wait(0.4); f:Destroy()
    end)
end

-- ══════════════════════════════════════════════
-- ████  ГЛАВНОЕ МЕНЮ  ████
-- ══════════════════════════════════════════════

-- Кнопка открытия (⚔)
local OpenBtn = Instance.new("TextButton",ScreenGui)
OpenBtn.Name="SauronOpenBtn"
OpenBtn.Size=UDim2.new(0,42,0,42)
OpenBtn.Position=UDim2.new(0,8,0.5,-21)
OpenBtn.BackgroundColor3=Color3.fromRGB(140,0,0)
OpenBtn.TextColor3=Color3.new(1,1,1)
OpenBtn.Text="⚔"
OpenBtn.Font=Enum.Font.SciFi
OpenBtn.TextSize=20
OpenBtn.BorderSizePixel=0
OpenBtn.Active=true
OpenBtn.Draggable=true
Instance.new("UICorner",OpenBtn).CornerRadius=UDim.new(1,0)
AddStroke(OpenBtn,Color3.fromRGB(220,0,0),2)
table.insert(Movable_Objects,OpenBtn)

-- Главное окно
local Main = Instance.new("Frame",ScreenGui)
Main.Name="SauronMain"
Main.Size=UDim2.new(0,560,0,500)
Main.Position=UDim2.new(0.5,-280,0.5,-250)
Main.BackgroundColor3=Color3.fromRGB(8,8,8)
Main.BorderSizePixel=0
Main.Visible=true
Main.Active=true
Main.Draggable=true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14)
AddStroke(Main,Color3.fromRGB(60,0,0),2)
table.insert(Movable_Objects,Main)

-- Шапка
local Header=Instance.new("Frame",Main)
Header.Size=UDim2.new(1,0,0,44)
Header.BackgroundColor3=Color3.fromRGB(12,12,12)
Header.BorderSizePixel=0
Instance.new("UICorner",Header).CornerRadius=UDim.new(0,14)

local HeaderTitle=Instance.new("TextLabel",Header)
HeaderTitle.Size=UDim2.new(0,200,1,0); HeaderTitle.Position=UDim2.new(0,14,0,0)
HeaderTitle.BackgroundTransparency=1; HeaderTitle.Text="⚔  SAURON"
HeaderTitle.Font=Enum.Font.SciFi; HeaderTitle.TextSize=20
HeaderTitle.TextColor3=Color3.fromRGB(220,0,0); HeaderTitle.TextXAlignment=Enum.TextXAlignment.Left
table.insert(RGB_Objects,{Type="Text",Instance=HeaderTitle})

local HeaderVer=Instance.new("TextLabel",Header)
HeaderVer.Size=UDim2.new(0,50,1,0); HeaderVer.Position=UDim2.new(0,130,0,0)
HeaderVer.BackgroundTransparency=1; HeaderVer.Text="V1"
HeaderVer.Font=Enum.Font.SciFi; HeaderVer.TextSize=11
HeaderVer.TextColor3=Color3.fromRGB(60,60,60); HeaderVer.TextXAlignment=Enum.TextXAlignment.Left

-- Кнопка закрыть X
local CloseX=Instance.new("TextButton",Header)
CloseX.Size=UDim2.new(0,26,0,26); CloseX.Position=UDim2.new(1,-36,0.5,-13)
CloseX.BackgroundColor3=Color3.fromRGB(120,0,0); CloseX.TextColor3=Color3.new(1,1,1)
CloseX.Text="✕"; CloseX.Font=Enum.Font.SciFi; CloseX.TextSize=12; CloseX.BorderSizePixel=0
Instance.new("UICorner",CloseX).CornerRadius=UDim.new(0,6)
CloseX.MouseButton1Click:Connect(function() Main.Visible=false end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

-- ══════════════════════════════════════════════
-- ЛЕВАЯ ПАНЕЛЬ (вкладки)
-- ══════════════════════════════════════════════
local LeftPanel=Instance.new("Frame",Main)
LeftPanel.Size=UDim2.new(0,108,1,-52)
LeftPanel.Position=UDim2.new(0,6,0,48)
LeftPanel.BackgroundColor3=Color3.fromRGB(11,11,11)
LeftPanel.BorderSizePixel=0
Instance.new("UICorner",LeftPanel).CornerRadius=UDim.new(0,10)

local TabList=Instance.new("UIListLayout",LeftPanel)
TabList.Padding=UDim.new(0,3); TabList.HorizontalAlignment=Enum.HorizontalAlignment.Center
Instance.new("UIPadding",LeftPanel).PaddingTop=UDim.new(0,6)

-- Контент-область
local ContentArea=Instance.new("Frame",Main)
ContentArea.Size=UDim2.new(1,-120,1,-52)
ContentArea.Position=UDim2.new(0,118,0,48)
ContentArea.BackgroundTransparency=1
ContentArea.ClipsDescendants=true

-- ══════════════════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════════════════
local Tabs={}
local ActiveTab=nil

local function SwitchTab(id)
    for tid,t in pairs(Tabs) do
        local on=(tid==id)
        TweenService:Create(t.btn,TweenInfo.new(0.12),{BackgroundColor3=on and Color3.fromRGB(150,0,0) or Color3.fromRGB(18,18,18)}):Play()
        t.page.Visible=on
        t.ind.Visible=on
    end
    ActiveTab=id
end

local TabDefs={
    {id="ESP",    icon="👁",  lbl="ESP"},
    {id="PLAYER", icon="⚡", lbl="PLAYER"},
    {id="VISUAL", icon="✨", lbl="VISUAL"},
    {id="AI",     icon="🤖", lbl="AI-SN"},
    {id="INFO",   icon="📊", lbl="INFO"},
    {id="WORLD",  icon="🌍", lbl="WORLD"},
    {id="UI",     icon="🔧", lbl="UI"},
}

for _,def in ipairs(TabDefs) do
    local btn=Instance.new("TextButton",LeftPanel)
    btn.Size=UDim2.new(0,92,0,54); btn.BackgroundColor3=Color3.fromRGB(18,18,18)
    btn.BorderSizePixel=0; btn.Text=""
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)

    local iL=Instance.new("TextLabel",btn)
    iL.Size=UDim2.new(1,0,0,26); iL.Position=UDim2.new(0,0,0,6)
    iL.BackgroundTransparency=1; iL.Text=def.icon; iL.TextSize=17; iL.Font=Enum.Font.SciFi

    local nL=Instance.new("TextLabel",btn)
    nL.Size=UDim2.new(1,0,0,16); nL.Position=UDim2.new(0,0,0,31)
    nL.BackgroundTransparency=1; nL.Text=def.lbl; nL.TextSize=9
    nL.Font=Enum.Font.SciFi; nL.TextColor3=Color3.fromRGB(120,120,120)

    -- Активный индикатор
    local ind=Instance.new("Frame",btn)
    ind.Size=UDim2.new(0,3,0.55,0); ind.Position=UDim2.new(0,1,0.225,0)
    ind.BackgroundColor3=Color3.fromRGB(220,0,0); ind.BorderSizePixel=0
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0); ind.Visible=false

    -- Страница
    local page=Instance.new("ScrollingFrame",ContentArea)
    page.Size=UDim2.new(1,-4,1,-6); page.Position=UDim2.new(0,2,0,4)
    page.BackgroundTransparency=1; page.ScrollBarThickness=3
    page.ScrollBarImageColor3=Color3.fromRGB(180,0,0); page.Visible=false
    page.CanvasSize=UDim2.new(0,0,0,0); page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local pl=Instance.new("UIListLayout",page); pl.Padding=UDim.new(0,5); pl.SortOrder=Enum.SortOrder.LayoutOrder
    local pp=Instance.new("UIPadding",page); pp.PaddingRight=UDim.new(0,4); pp.PaddingBottom=UDim.new(0,6)

    btn.MouseButton1Click:Connect(function() SwitchTab(def.id) end)
    Tabs[def.id]={btn=btn,page=page,ind=ind}
end

-- ══════════════════════════════════════════════
-- UI COMPONENTS
-- ══════════════════════════════════════════════

-- Секция-заголовок
local function Section(parent, text)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,22); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-4,1,0); l.Position=UDim2.new(0,4,0,0)
    l.BackgroundTransparency=1; l.Text=string.upper(text)
    l.Font=Enum.Font.SciFi; l.TextSize=10; l.TextColor3=Color3.fromRGB(100,0,0)
    l.TextXAlignment=Enum.TextXAlignment.Left
    local div=Instance.new("Frame",f); div.Size=UDim2.new(1,-4,0,1); div.Position=UDim2.new(0,4,1,-1)
    div.BackgroundColor3=Color3.fromRGB(35,0,0); div.BorderSizePixel=0
    return f
end

-- Тогл
local function Toggle(parent, text, stateKey, customCallback)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,42); row.BackgroundColor3=Color3.fromRGB(14,14,14); row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",row); stroke.Thickness=1
    stroke.Color = (stateKey and States[stateKey]) and Color3.fromRGB(100,0,0) or Color3.fromRGB(30,30,30)

    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,-70,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.Font=Enum.Font.SciFi; lbl.TextSize=14
    lbl.TextColor3=Color3.fromRGB(210,210,210); lbl.TextXAlignment=Enum.TextXAlignment.Left

    local pill=Instance.new("Frame",row); pill.Size=UDim2.new(0,42,0,22); pill.Position=UDim2.new(1,-54,0.5,-11)
    pill.BorderSizePixel=0; Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    local initOn = stateKey and States[stateKey] or false
    pill.BackgroundColor3 = initOn and Color3.fromRGB(180,0,0) or Color3.fromRGB(28,28,28)

    local dot=Instance.new("Frame",pill); dot.Size=UDim2.new(0,16,0,16); dot.BorderSizePixel=0
    dot.BackgroundColor3=Color3.new(1,1,1)
    dot.Position = initOn and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

    local btn=Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.MouseButton1Click:Connect(function()
        local on
        if customCallback then
            on = customCallback()
        else
            States[stateKey]=not States[stateKey]; on=States[stateKey]
        end
        TweenService:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and Color3.fromRGB(180,0,0) or Color3.fromRGB(28,28,28)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        stroke.Color = on and Color3.fromRGB(100,0,0) or Color3.fromRGB(30,30,30)
        Notify(text..(on and " — ON" or " — OFF"))
    end)
    return row, pill, dot
end

-- Ползунок
local function Slider(parent, text, minV, maxV, defV, dec, onChange)
    dec=dec or 3
    local fmt="%."..dec.."f"
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,58); row.BackgroundColor3=Color3.fromRGB(14,14,14); row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",row).Color=Color3.fromRGB(30,30,30)

    local nameLbl=Instance.new("TextLabel",row); nameLbl.Size=UDim2.new(0.6,0,0,22); nameLbl.Position=UDim2.new(0,12,0,4)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=text; nameLbl.Font=Enum.Font.SciFi; nameLbl.TextSize=13
    nameLbl.TextColor3=Color3.fromRGB(200,200,200); nameLbl.TextXAlignment=Enum.TextXAlignment.Left

    local valLbl=Instance.new("TextLabel",row); valLbl.Size=UDim2.new(0.36,0,0,22); valLbl.Position=UDim2.new(0.62,0,0,4)
    valLbl.BackgroundTransparency=1; valLbl.Text=string.format(fmt,defV); valLbl.Font=Enum.Font.SciFi; valLbl.TextSize=13
    valLbl.TextColor3=Color3.fromRGB(220,0,0); valLbl.TextXAlignment=Enum.TextXAlignment.Right
    table.insert(RGB_Objects,{Type="Text",Instance=valLbl})

    local track=Instance.new("Frame",row); track.Size=UDim2.new(1,-24,0,6); track.Position=UDim2.new(0,12,0,36)
    track.BackgroundColor3=Color3.fromRGB(28,28,28); track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local pct0=math.clamp((defV-minV)/(maxV-minV),0,1)
    local fill=Instance.new("Frame",track); fill.Size=UDim2.new(pct0,0,1,0); fill.BackgroundColor3=Color3.fromRGB(180,0,0); fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    table.insert(RGB_Objects,{Type="Part",Instance=fill})

    local thumb=Instance.new("Frame",track); thumb.Size=UDim2.new(0,14,0,14); thumb.Position=UDim2.new(pct0,-7,0.5,-7)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)

    local curVal=defV; local dragging=false
    local function upd(ax)
        local p=math.clamp((ax-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        curVal=minV+p*(maxV-minV)
        curVal=math.floor(curVal*(10^dec)+0.5)/(10^dec)
        fill.Size=UDim2.new(p,0,1,0); thumb.Position=UDim2.new(p,-7,0.5,-7)
        valLbl.Text=string.format(fmt,curVal)
        if onChange then onChange(curVal) end
    end
    thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; upd(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging then upd(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    return row, function() return curVal end
end

-- Текстбокс
local function InputBox(parent, placeholder, text)
    local tb=Instance.new("TextBox",parent); tb.Size=UDim2.new(1,0,0,42)
    tb.BackgroundColor3=Color3.fromRGB(14,14,14); tb.TextColor3=Color3.new(1,1,1)
    tb.PlaceholderText=placeholder; tb.PlaceholderColor3=Color3.fromRGB(55,55,55)
    tb.Text=text or ""; tb.Font=Enum.Font.SciFi; tb.TextSize=13; tb.ClearTextOnFocus=false; tb.BorderSizePixel=0
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",tb).Color=Color3.fromRGB(40,40,40)
    return tb
end

-- Кнопка
local function Button(parent, text, bgColor, callback)
    local btn=Instance.new("TextButton",parent); btn.Size=UDim2.new(1,0,0,42)
    btn.BackgroundColor3=bgColor or Color3.fromRGB(20,20,20); btn.TextColor3=Color3.new(1,1,1)
    btn.Text=text; btn.Font=Enum.Font.SciFi; btn.TextSize=14; btn.BorderSizePixel=0
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",btn).Color=Color3.fromRGB(50,50,50)
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

-- ══════════════════════════════════════════════
-- ████  TAB: ESP  ████
-- ══════════════════════════════════════════════
local pESP=Tabs["ESP"].page
Section(pESP,"ESP — НАСТРОЙКИ")

local function ESPToggle(lbl, key)
    local row,pill,dot=Toggle(pESP,lbl,nil,function()
        if key=="RADAR" then RADAR_ESP=not RADAR_ESP; return RADAR_ESP end
        ESP_States[key]=not ESP_States[key]; return ESP_States[key]
    end)
    -- Синхронизируем начальное состояние
    local initOn = key=="RADAR" and RADAR_ESP or ESP_States[key]
    pill.BackgroundColor3=initOn and Color3.fromRGB(180,0,0) or Color3.fromRGB(28,28,28)
    dot.Position=initOn and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
end
ESPToggle("📦  BOX ESP",      "BOX")
ESPToggle("👤  NAMETAG",      "NAME")
ESPToggle("❤   HEALTH BAR",   "HEALTH")
ESPToggle("📏  DISTANCE",     "DISTANCE")
ESPToggle("💀  SKELETON",     "SKELETON")
ESPToggle("➡   TRACER",      "TRACER")
ESPToggle("🎨  CHAMS",        "CHAMS")
ESPToggle("🛰   RADAR",       "RADAR")

-- ══════════════════════════════════════════════
-- ████  TAB: PLAYER  ████
-- ══════════════════════════════════════════════
local pPLAYER=Tabs["PLAYER"].page

Section(pPLAYER,"COMBAT")
Toggle(pPLAYER,"🎯  HUMAN AIM","Aim")
Slider(pPLAYER,"  ПЛАВНОСТЬ AIM",0.01,1.0,0.15,3,function(v) valSmooth=v end)
Toggle(pPLAYER,"🛡  ANTI KNOCKBACK","AntiKnockback")
Toggle(pPLAYER,"⚡  KILL AURA","KillAura")

Section(pPLAYER,"HITBOX")
Toggle(pPLAYER,"💥  BIG HITBOX","Hitbox")
Slider(pPLAYER,"  РАЗМЕР ХИТБОКСА",0.0,100.0,5.0,3,function(v) valHitbox=v end)

Section(pPLAYER,"MOVEMENT")
Toggle(pPLAYER,"🏃  RAGE SPEED","Spd")
Slider(pPLAYER,"  СКОРОСТЬ",0.0,100.0,50.0,3,function(v) valSpeed=v end)
Toggle(pPLAYER,"🔄  SPEED BYPASS","SpdBypass")
Slider(pPLAYER,"  BYPASS СКОРОСТЬ",0.0,100.0,0.11,3,function(v) valBypassSpeed=v end)
Toggle(pPLAYER,"✈   FLY","Fly")
Slider(pPLAYER,"  СКОРОСТЬ ПОЛЁТА",0.0,100.0,5.0,3,function(v) valFlySpeed=v end)
Toggle(pPLAYER,"🦘  SUPER JUMP","Jump")
Slider(pPLAYER,"  СИЛА ПРЫЖКА",0.0,100.0,100.0,3,function(v) valJumpPower=v end)
Toggle(pPLAYER,"♾   INF JUMP","InfJump")
Toggle(pPLAYER,"🔍  INF ZOOM","UnlockAll")
Toggle(pPLAYER,"💤  ANTI AFK","AntiAfk")

-- ══════════════════════════════════════════════
-- ████  TAB: VISUAL  ████
-- ══════════════════════════════════════════════
local pVISUAL=Tabs["VISUAL"].page

Section(pVISUAL,"ТЕМА")
local themeBtn=Button(pVISUAL,"🎨  ТЕМА: "..Themes[CurrentThemeIndex],Color3.fromRGB(20,10,10))
themeBtn.MouseButton1Click:Connect(function()
    CurrentThemeIndex=CurrentThemeIndex+1; if CurrentThemeIndex>#Themes then CurrentThemeIndex=1 end
    themeBtn.Text="🎨  ТЕМА: "..Themes[CurrentThemeIndex]
end)

Section(pVISUAL,"ЭФФЕКТЫ")
Toggle(pVISUAL,"🖼   ПОКАЗАТЬ ЛОГО","Watermark")
Toggle(pVISUAL,"☀   FULLBRIGHT","Fullbright")
Toggle(pVISUAL,"🌈  RGB СКИН","RGB")

Section(pVISUAL,"GHOST TRAIL")
Toggle(pVISUAL,"👻  GHOST TRAIL","Ghosts")
Slider(pVISUAL,"  ЧАСТОТА",0.01,2.0,0.05,3,function(v) valGhostRate=v end)

Section(pVISUAL,"RIPPLE")
Toggle(pVISUAL,"💫  JUMP RIPPLE","Circle")
Slider(pVISUAL,"  РАЗМЕР RIPPLE",0.0,100.0,15.0,3,function(v) valRipple=v end)
Toggle(pVISUAL,"⛧   PENTAGRAM","UsePentagram")

-- ══════════════════════════════════════════════
-- ████  TAB: AI-SN  ████
-- ══════════════════════════════════════════════
local pAI=Tabs["AI"].page

Section(pAI,"GROQ AI")
local AIKeyBox=InputBox(pAI,"GROQ API KEY")

local ModelBtn=Button(pAI,"⚙  MODEL: "..GroqModels[CurrentModelIndex],Color3.fromRGB(18,18,28))
ModelBtn.MouseButton1Click:Connect(function()
    CurrentModelIndex=CurrentModelIndex+1; if CurrentModelIndex>#GroqModels then CurrentModelIndex=1 end
    ModelBtn.Text="⚙  MODEL: "..GroqModels[CurrentModelIndex]
end)

Section(pAI,"БОТЫ")
local aiToggleOn=false
local aiToggleRow,aiPill,aiDot=Toggle(pAI,"🤖  AI AUTOREPLY",nil,function()
    States.AI=not States.AI; aiToggleOn=States.AI
    if States.AI then Notify("AI AUTOREPLY ON") end
    return States.AI
end)

local friendOn=false
local friendRow,friendPill,friendDot=Toggle(pAI,"👥  FRIEND BOT",nil,function()
    States.FriendBot=not States.FriendBot
    if States.FriendBot then Notify("FRIEND BOT ON") end
    return States.FriendBot
end)

Section(pAI,"МАКРО")
local AIStatus=Instance.new("TextLabel",pAI); AIStatus.Size=UDim2.new(1,0,0,28)
AIStatus.BackgroundTransparency=1; AIStatus.Text="  STATUS: IDLE"
AIStatus.Font=Enum.Font.SciFi; AIStatus.TextSize=12
AIStatus.TextColor3=Color3.fromRGB(90,90,90); AIStatus.TextXAlignment=Enum.TextXAlignment.Left

local macroRow=Instance.new("Frame",pAI); macroRow.Size=UDim2.new(1,0,0,42); macroRow.BackgroundTransparency=1
local RecBtn=Instance.new("TextButton",macroRow); RecBtn.Size=UDim2.new(0.48,-3,1,0)
RecBtn.BackgroundColor3=Color3.fromRGB(40,10,10); RecBtn.TextColor3=Color3.new(1,1,1)
RecBtn.Text="⏺  RECORD"; RecBtn.Font=Enum.Font.SciFi; RecBtn.TextSize=13; RecBtn.BorderSizePixel=0
Instance.new("UICorner",RecBtn).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",RecBtn).Color=Color3.fromRGB(60,20,20)

local PlayBtn=Instance.new("TextButton",macroRow); PlayBtn.Size=UDim2.new(0.48,-3,1,0); PlayBtn.Position=UDim2.new(0.52,3,0,0)
PlayBtn.BackgroundColor3=Color3.fromRGB(10,40,10); PlayBtn.TextColor3=Color3.new(1,1,1)
PlayBtn.Text="▶  PLAY"; PlayBtn.Font=Enum.Font.SciFi; PlayBtn.TextSize=13; PlayBtn.BorderSizePixel=0
Instance.new("UICorner",PlayBtn).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",PlayBtn).Color=Color3.fromRGB(20,60,20)

local LoopBtn_row,_,_=Toggle(pAI,"🔁  LOOP PLAYBACK",nil,function()
    States.LoopPlay=not States.LoopPlay; return States.LoopPlay
end)

-- ══════════════════════════════════════════════
-- ████  TAB: INFO  ████
-- ══════════════════════════════════════════════
local pINFO=Tabs["INFO"].page
Section(pINFO,"ИНФОРМАЦИЯ О СЕССИИ")
local InfoLabel=Instance.new("TextLabel",pINFO); InfoLabel.Size=UDim2.new(1,0,0,200)
InfoLabel.BackgroundTransparency=1; InfoLabel.TextColor3=Color3.new(1,1,1)
InfoLabel.Font=Enum.Font.SciFi; InfoLabel.TextSize=14
InfoLabel.TextYAlignment=Enum.TextYAlignment.Top; InfoLabel.TextXAlignment=Enum.TextXAlignment.Left
InfoLabel.Text="  Загрузка..."; InfoLabel.RichText=false

-- ══════════════════════════════════════════════
-- ████  TAB: WORLD  ████
-- ══════════════════════════════════════════════
local pWORLD=Tabs["WORLD"].page

Section(pWORLD,"ОКРУЖЕНИЕ")
local FogBtn=Button(pWORLD,"🌫   REMOVE FOG: OFF",Color3.fromRGB(25,10,10))
local AmbientBtn=Button(pWORLD,"💡  AMBIENT SYNC: OFF",Color3.fromRGB(25,10,10))

FogBtn.MouseButton1Click:Connect(function()
    States.NoFog=not States.NoFog; FogBtn.Text=(States.NoFog and "🌫   REMOVE FOG: ON" or "🌫   REMOVE FOG: OFF")
    FogBtn.BackgroundColor3=States.NoFog and Color3.fromRGB(10,35,10) or Color3.fromRGB(25,10,10)
    if not States.NoFog then Lighting.FogEnd=1000 end; Notify("FOG "..(States.NoFog and "OFF" or "ON"))
end)
AmbientBtn.MouseButton1Click:Connect(function()
    States.AmbientSync=not States.AmbientSync; AmbientBtn.Text=(States.AmbientSync and "💡  AMBIENT SYNC: ON" or "💡  AMBIENT SYNC: OFF")
    AmbientBtn.BackgroundColor3=States.AmbientSync and Color3.fromRGB(10,35,10) or Color3.fromRGB(25,10,10)
    Notify("AMBIENT SYNC "..(States.AmbientSync and "ON" or "OFF"))
end)

Section(pWORLD,"НЕБО")
local SkyBox=InputBox(pWORLD,"CUSTOM SKY ASSET ID")
local SetSkyBtn=Button(pWORLD,"🌄  ПРИМЕНИТЬ НЕБО",Color3.fromRGB(18,18,18))
local SpaceSkyBtn=Button(pWORLD,"🌌  КОСМОС",Color3.fromRGB(10,10,25))

local function SetSky(id)
    local sky=Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky",Lighting)
    local t="rbxassetid://"..tostring(id)
    sky.SkyboxBk,sky.SkyboxDn,sky.SkyboxFt,sky.SkyboxLf,sky.SkyboxRt,sky.SkyboxUp=t,t,t,t,t,t
    Notify("SKY: "..tostring(id))
end
SetSkyBtn.MouseButton1Click:Connect(function()
    local id=SkyBox.Text:match("%d+"); if id then SetSky(id) else Notify("НЕВЕРНЫЙ ID") end
end)
SpaceSkyBtn.MouseButton1Click:Connect(function() SetSky("159454299") end)

Section(pWORLD,"FLY CONTROL")
local flyRow=Instance.new("Frame",pWORLD); flyRow.Size=UDim2.new(1,0,0,42); flyRow.BackgroundTransparency=1
local btnUp=Instance.new("TextButton",flyRow); btnUp.Size=UDim2.new(0.48,-3,1,0)
btnUp.BackgroundColor3=Color3.fromRGB(18,18,18); btnUp.TextColor3=Color3.new(1,1,1)
btnUp.Text="▲  FLY UP"; btnUp.Font=Enum.Font.SciFi; btnUp.TextSize=13; btnUp.BorderSizePixel=0
Instance.new("UICorner",btnUp).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",btnUp).Color=Color3.fromRGB(40,40,40)
local btnDn=Instance.new("TextButton",flyRow); btnDn.Size=UDim2.new(0.48,-3,1,0); btnDn.Position=UDim2.new(0.52,3,0,0)
btnDn.BackgroundColor3=Color3.fromRGB(18,18,18); btnDn.TextColor3=Color3.new(1,1,1)
btnDn.Text="▼  FLY DOWN"; btnDn.Font=Enum.Font.SciFi; btnDn.TextSize=13; btnDn.BorderSizePixel=0
Instance.new("UICorner",btnDn).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",btnDn).Color=Color3.fromRGB(40,40,40)
btnUp.MouseButton1Down:Connect(function() up=true end); btnUp.MouseButton1Up:Connect(function() up=false end)
btnDn.MouseButton1Down:Connect(function() down=true end); btnDn.MouseButton1Up:Connect(function() down=false end)

-- ══════════════════════════════════════════════
-- ████  TAB: UI  ████
-- ══════════════════════════════════════════════
local pUI=Tabs["UI"].page
Section(pUI,"ИНТЕРФЕЙС")

local UnlockBtn=Button(pUI,"🔓  UNLOCK MOVING: OFF",Color3.fromRGB(25,10,10))
local SaveBtn=Button(pUI,"💾  СОХРАНИТЬ КОНФИГ",Color3.fromRGB(10,10,25))

UnlockBtn.MouseButton1Click:Connect(function()
    UI_Unlocked=not UI_Unlocked
    UnlockBtn.Text=UI_Unlocked and "🔓  UNLOCK MOVING: ON" or "🔓  UNLOCK MOVING: OFF"
    UnlockBtn.BackgroundColor3=UI_Unlocked and Color3.fromRGB(10,35,10) or Color3.fromRGB(25,10,10)
    for _,obj in pairs(Movable_Objects) do obj.Active=UI_Unlocked; obj.Draggable=UI_Unlocked end
    Notify("MOVING "..(UI_Unlocked and "UNLOCKED" or "LOCKED"))
end)

local ConfigName="SauronConfig_V1.json"
SaveBtn.MouseButton1Click:Connect(function()
    if writefile then
        local data={}
        for _,obj in pairs(Movable_Objects) do
            data[obj.Name]={XS=obj.Position.X.Scale,XO=obj.Position.X.Offset,YS=obj.Position.Y.Scale,YO=obj.Position.Y.Offset}
        end
        writefile(ConfigName,HttpService:JSONEncode(data))
        SaveBtn.Text="✅  СОХРАНЕНО!"; task.wait(1.5); SaveBtn.Text="💾  СОХРАНИТЬ КОНФИГ"
    end
end)

task.spawn(function()
    if isfile and isfile(ConfigName) then
        local ok,data=pcall(function() return HttpService:JSONDecode(readfile(ConfigName)) end)
        if ok then for _,obj in pairs(Movable_Objects) do if data[obj.Name] then obj.Position=UDim2.new(data[obj.Name].XS,data[obj.Name].XO,data[obj.Name].YS,data[obj.Name].YO) end end end
    end
end)

-- Активируем первую вкладку
SwitchTab("PLAYER")

-- ══════════════════════════════════════════════
-- ████  WATERMARK  ████
-- ══════════════════════════════════════════════
task.spawn(function()
    local fileLogo="AngerMOD.png"
    local urlLogo="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"
    if writefile and isfile then
        pcall(function() if not isfile(fileLogo) then writefile(fileLogo,game:HttpGet(urlLogo,true)) end end)
    end
    local wg=Instance.new("ScreenGui",ScreenGui.Parent); wg.Name="SauronWatermark"; wg.ResetOnSpawn=false
    local wf=Instance.new("ImageLabel",wg)
    wf.Size=UDim2.new(0,260,0,65); wf.Position=UDim2.new(0,10,0,10)
    wf.BackgroundTransparency=1; wf.ScaleType=Enum.ScaleType.Fit
    local loaded=false
    if getcustomasset then
        local ok,a=pcall(function() return getcustomasset(fileLogo) end)
        if ok and a and a~="" then wf.Image=a; loaded=true end
    end
    if not loaded then wf.Image=urlLogo end
end)

-- ══════════════════════════════════════════════
-- ████  LOGIC  ████
-- ══════════════════════════════════════════════
local function EmergencyBrake()
    local c=Player.Character; if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.Velocity=Vector3.zero; c.HumanoidRootPart.RotVelocity=Vector3.zero
    end
end

local function SendChat(msg)
    if game:GetService("TextChatService").ChatVersion==Enum.ChatVersion.TextChatService then
        pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg) end)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
    end
end

local function SmartMove(targetCF)
    local c=Player.Character; if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart"); local hum=c:FindFirstChild("Humanoid"); if not root or not hum then return end
    local car=nil; if hum.SeatPart then car=hum.SeatPart.Parent end
    if car and car:IsA("Model") then local mp=car.PrimaryPart or hum.SeatPart; mp.Velocity=Vector3.zero; mp.CFrame=targetCF
    else root.CFrame=targetCF; root.Velocity=Vector3.zero end
end

local function GetClosestPlayer()
    local tgt,dst=nil,math.huge
    for _,v in pairs(Players:GetPlayers()) do
        if v~=Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
            local d=(v.Character.Head.Position-Camera.CFrame.Position).Magnitude
            if d<dst then dst=d; tgt=v.Character end
        end
    end; return tgt
end

-- RECORD / PLAY
RecBtn.MouseButton1Click:Connect(function()
    States.IsRecording=not States.IsRecording
    if States.IsRecording then States.IsPlaying=false; RecordedPath={}; RecBtn.Text="⏹  STOP REC"; RecBtn.BackgroundColor3=Color3.fromRGB(200,0,0); AIStatus.Text="  STATUS: RECORDING..."
    else RecBtn.Text="⏺  RECORD"; RecBtn.BackgroundColor3=Color3.fromRGB(40,10,10); AIStatus.Text="  STATUS: SAVED "..#RecordedPath.." FRAMES" end
end)

local function StartPlayback()
    if #RecordedPath==0 then AIStatus.Text="  ERROR: NO RECORDING"; States.IsPlaying=false; return end
    local c=Player.Character; local root=c and c:FindFirstChild("HumanoidRootPart"); local hum=c and c:FindFirstChild("Humanoid")
    if root and hum then hum.PlatformStand=true; root.Anchored=true end
    task.spawn(function()
        while States.IsPlaying do
            for _,frame in ipairs(RecordedPath) do
                if not States.IsPlaying then break end; SmartMove(frame.CF); RunService.Heartbeat:Wait()
            end
            if not States.LoopPlay then States.IsPlaying=false; PlayBtn.Text="▶  PLAY"; PlayBtn.BackgroundColor3=Color3.fromRGB(10,40,10); break end
        end
        local pc=Player.Character
        if pc then local r=pc:FindFirstChild("HumanoidRootPart"); local h=pc:FindFirstChild("Humanoid")
            if r then r.Anchored=false; r.Velocity=Vector3.zero end; if h then h.PlatformStand=false end
        end; AIStatus.Text="  STATUS: IDLE"
    end)
end

PlayBtn.MouseButton1Click:Connect(function()
    States.IsPlaying=not States.IsPlaying
    if States.IsPlaying then States.IsRecording=false; RecBtn.Text="⏺  RECORD"; RecBtn.BackgroundColor3=Color3.fromRGB(40,10,10); PlayBtn.Text="⏹  STOP"; PlayBtn.BackgroundColor3=Color3.fromRGB(200,50,0); StartPlayback()
    else PlayBtn.Text="▶  PLAY"; PlayBtn.BackgroundColor3=Color3.fromRGB(10,40,10); EmergencyBrake() end
end)

-- AI
local AI_Debounce=false
local function ProcessAI(msg,senderName)
    if AI_Debounce then return end
    if not States.AI then return end
    AI_Debounce=true; AIStatus.Text="  STATUS: THINKING..."
    local apiKey=AIKeyBox.Text; if apiKey=="" then AIStatus.Text="  ERROR: NO KEY"; AI_Debounce=false; return end
    table.insert(ChatHistory,{role="user",content=senderName..": "..msg})
    if #ChatHistory>10 then table.remove(ChatHistory,2) end
    local ok,resp=pcall(function()
        if request then return request({Url="https://api.groq.com/openai/v1/chat/completions",Method="POST",
            Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..apiKey},
            Body=HttpService:JSONEncode({model=GroqModels[CurrentModelIndex],messages=ChatHistory,max_tokens=60})}) end
    end)
    if ok and resp and resp.Body then
        local data=HttpService:JSONDecode(resp.Body)
        if data.choices and data.choices[1] then
            local reply=data.choices[1].message.content; SendChat(reply)
            table.insert(ChatHistory,{role="assistant",content=reply}); AIStatus.Text="  STATUS: REPLIED"
        else AIStatus.Text="  ERROR: API FAIL" end
    else AIStatus.Text="  ERROR: REQUEST FAIL" end
    task.wait(2); AI_Debounce=false; AIStatus.Text="  STATUS: IDLE"
end

local function ExecuteCommand(msg)
    local m=string.lower(msg); local c=Player.Character; local hum=c and c:FindFirstChild("Humanoid")
    if m:find("сядь") then if hum then hum.Sit=true end; return true
    elseif m:find("встань") then if hum then hum.Sit=false; hum.Jump=true end; return true
    elseif m:find("стой") then States.IsFollowing=false; EmergencyBrake(); return true
    elseif m:find("ко мне") then States.IsFollowing=true; return true end
    return false
end

for _,p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(msg)
    if p~=Player then if States.FriendBot then ExecuteCommand(msg) end; ProcessAI(msg,p.Name) end
end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg)
    if p~=Player then if States.FriendBot then ExecuteCommand(msg) end; ProcessAI(msg,p.Name) end
end) end)

-- RIPPLE
local function SpawnRipple()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root=Player.Character.HumanoidRootPart
    local ray=Workspace:Raycast(root.Position,Vector3.new(0,-10,0),RaycastParams.new())
    local sp=ray and ray.Position or (root.Position-Vector3.new(0,2.8,0))
    local p=Instance.new("Part",Workspace); p.Name="SauronRipple"; p.Anchored=true; p.CanCollide=false
    if States.UsePentagram then
        p.Transparency=1; p.Size=Vector3.new(1,0.05,1); p.CFrame=CFrame.new(sp)
        local sg=Instance.new("SurfaceGui",p); sg.Face=Enum.NormalId.Top; sg.LightInfluence=0; sg.AlwaysOnTop=false
        local img=Instance.new("ImageLabel",sg); img.Size=UDim2.new(1,0,1,0); img.BackgroundTransparency=1; img.ImageColor3=Color3.new(1,1,1)
        local s,a=pcall(function() return getcustomasset("Anger_Pentagram_Circle1.png") end); if s then img.Image=a end
        table.insert(RGB_Objects,{Type="Image",Instance=img})
        TweenService:Create(p,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(valRipple,0.05,valRipple)}):Play()
        TweenService:Create(img,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{ImageTransparency=1}):Play()
    else
        p.Shape=Enum.PartType.Cylinder; p.Material=Enum.Material.Neon; p.Size=Vector3.new(0.1,1,1)
        p.CFrame=CFrame.new(sp)*CFrame.Angles(0,0,math.rad(90)); p.Color=Color3.new(1,1,1)
        table.insert(RGB_Objects,{Type="Part",Instance=p})
        TweenService:Create(p,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(0.1,valRipple,valRipple),Transparency=1}):Play()
    end
    Debris:AddItem(p,1.5)
end

Player.CharacterAdded:Connect(function(char)
    DeathScreen.Enabled=false
    char:WaitForChild("Humanoid").Died:Connect(function() DeathScreen.Enabled=true end)
end)
UserInputService.JumpRequest:Connect(function()
    if States.InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    if States.Circle then SpawnRipple() end
end)
Player.Idled:Connect(function() if States.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

-- Pentagram download
task.spawn(function()
    local url="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/circle1.png"
    local name="Anger_Pentagram_Circle1.png"
    if writefile and isfile then pcall(function() if not isfile(name) then writefile(name,game:HttpGet(url,true)) end end) end
end)

-- ══════════════════════════════════════════════
-- ████  ESP DRAWING SYSTEM  ████
-- ══════════════════════════════════════════════
local SkeletonPairs={
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"Head","Torso"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}
}

local function NewLine(c,t,tr) local l=Drawing.new("Line"); l.Color=c or Color3.new(1,1,1); l.Thickness=t or 1; l.Transparency=tr or 1; l.Visible=false; return l end

local function CreateBoxESP(player)
    if ESPData[player] then return end
    local box=Drawing.new("Quad"); box.Filled=false; box.Thickness=1; box.Visible=false
    local corners={}; for i=1,8 do corners[i]=NewLine(Color3.new(1,1,1),2.5) end
    local nameL=Drawing.new("Text"); nameL.Size=14; nameL.Font=Drawing.Fonts.Plex; nameL.Center=true; nameL.Outline=true; nameL.Visible=false
    local distL=Drawing.new("Text"); distL.Size=11; distL.Font=Drawing.Fonts.Plex; distL.Center=true; distL.Outline=true; distL.Color=Color3.fromRGB(200,200,200); distL.Visible=false
    local hpBg=NewLine(Color3.fromRGB(10,10,10),5); hpBg.Transparency=0
    local hpBar=NewLine(Color3.fromRGB(0,255,80),3); hpBar.Transparency=0
    local hpTxt=Drawing.new("Text"); hpTxt.Size=10; hpTxt.Font=Drawing.Fonts.Plex; hpTxt.Outline=true; hpTxt.Visible=false
    local skels={}; for i=1,#SkeletonPairs do skels[i]=NewLine(Color3.fromRGB(255,255,100),1) end
    local tracer=NewLine(Color3.new(1,1,1),1,0.6)
    local line=Drawing.new("Line"); line.Visible=false; line.Color=Color3.new(1,1,1); line.Thickness=2; line.Transparency=0.8
    ESPLines[player]=line
    ESPData[player]={box=box,corners=corners,nameL=nameL,distL=distL,hpBg=hpBg,hpBar=hpBar,hpTxt=hpTxt,skels=skels,tracer=tracer}
end

local function RemoveBoxESP(player)
    local d=ESPData[player]; if not d then return end
    d.box:Remove(); for _,c in ipairs(d.corners) do c:Remove() end
    d.nameL:Remove(); d.distL:Remove(); d.hpBg:Remove(); d.hpBar:Remove(); d.hpTxt:Remove()
    for _,l in ipairs(d.skels) do l:Remove() end; d.tracer:Remove()
    ESPData[player]=nil
    if ESPLines[player] then ESPLines[player]:Remove(); ESPLines[player]=nil end
    if RadarDots[player] then RadarDots[player].dot:Destroy(); RadarDots[player]=nil end
end

for _,p in pairs(Players:GetPlayers()) do if p~=Player then CreateBoxESP(p) end end
Players.PlayerAdded:Connect(function(p) CreateBoxESP(p) end)
Players.PlayerRemoving:Connect(function(p) RemoveBoxESP(p) end)

-- RADAR
local RadarFrame=Instance.new("Frame",ScreenGui)
RadarFrame.Name="SauronRadar"; RadarFrame.Size=UDim2.new(0,160,0,160)
RadarFrame.Position=UDim2.new(1,-175,0,10); RadarFrame.BackgroundColor3=Color3.fromRGB(5,5,5)
RadarFrame.BackgroundTransparency=0.25; RadarFrame.Visible=RADAR_ESP; RadarFrame.BorderSizePixel=0
Instance.new("UICorner",RadarFrame).CornerRadius=UDim.new(1,0)
AddStroke(RadarFrame,Color3.fromRGB(80,0,0),2); table.insert(Movable_Objects,RadarFrame)

local RadarTitle=Instance.new("TextLabel",RadarFrame); RadarTitle.Size=UDim2.new(1,0,0,18)
RadarTitle.BackgroundTransparency=1; RadarTitle.Text="⚔ RADAR"; RadarTitle.Font=Enum.Font.SciFi
RadarTitle.TextSize=11; RadarTitle.TextColor3=Color3.fromRGB(200,0,0)

local RadarSelf=Instance.new("Frame",RadarFrame); RadarSelf.Size=UDim2.new(0,8,0,8)
RadarSelf.Position=UDim2.new(0.5,-4,0.5,-4); RadarSelf.BackgroundColor3=Color3.fromRGB(0,255,100)
RadarSelf.BorderSizePixel=0; Instance.new("UICorner",RadarSelf).CornerRadius=UDim.new(1,0)

local function GetRadarDot(player)
    if not RadarDots[player] then
        local dot=Instance.new("Frame",RadarFrame); dot.Size=UDim2.new(0,6,0,6)
        dot.BackgroundColor3=Color3.fromRGB(255,50,50); dot.BorderSizePixel=0; dot.ZIndex=5
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local lbl=Instance.new("TextLabel",dot); lbl.Size=UDim2.new(0,55,0,12); lbl.Position=UDim2.new(1,3,0,-3)
        lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(1,1,1); lbl.Font=Enum.Font.SciFi
        lbl.TextSize=9; lbl.Text=player.Name:sub(1,7)
        RadarDots[player]={dot=dot,lbl=lbl}
    end; return RadarDots[player]
end

local function UpdateESP(ac)
    local anyOn=ESP_States.BOX or ESP_States.NAME or ESP_States.HEALTH or ESP_States.DISTANCE or ESP_States.SKELETON or ESP_States.TRACER
    local myChar=Player.Character; local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
    for _,p in pairs(Players:GetPlayers()) do
        if p==Player then continue end
        local d=ESPData[p]; if not d then continue end
        local char=p.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart"); local head=char and char:FindFirstChild("Head")
        local line=ESPLines[p]
        local function hide()
            d.box.Visible=false; for _,c in ipairs(d.corners) do c.Visible=false end
            d.nameL.Visible=false; d.distL.Visible=false; d.hpBg.Visible=false; d.hpBar.Visible=false; d.hpTxt.Visible=false
            for _,l in ipairs(d.skels) do l.Visible=false end; d.tracer.Visible=false
            if line then line.Visible=false end; if RadarDots[p] then RadarDots[p].dot.Visible=false end
        end
        if not char or not root or not head or not hum or hum.Health<=0 then hide(); continue end

        local topV,topOn=Camera:WorldToViewportPoint(root.Position+Vector3.new(0,3.2,0))
        local botV,botOn=Camera:WorldToViewportPoint(root.Position-Vector3.new(0,2.8,0))
        if not topOn and not botOn then hide(); continue end

        local H=math.abs(topV.Y-botV.Y); local W=H*0.55
        local cx=topV.X; local T=topV.Y; local B=botV.Y; local L=cx-W/2; local R=cx+W/2
        local dist=myRoot and math.floor((root.Position-myRoot.Position).Magnitude) or 0
        local hpPct=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
        local hpColor=Color3.fromRGB(math.floor(255*(1-hpPct)),math.floor(255*hpPct),50)

        -- LINE (tracer старый)
        if line and States.Esp then
            local rv,ron=Camera:WorldToViewportPoint(root.Position)
            if ron then line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); line.To=Vector2.new(rv.X,rv.Y); line.Color=ac; line.Visible=true else line.Visible=false end
        elseif line then line.Visible=false end

        -- BOX
        if anyOn and ESP_States.BOX then
            d.box.PointA=Vector2.new(L,T); d.box.PointB=Vector2.new(R,T); d.box.PointC=Vector2.new(R,B); d.box.PointD=Vector2.new(L,B)
            d.box.Color=ac; d.box.Transparency=0.5; d.box.Visible=true
            local cL=W*0.22; local cH=H*0.15
            local cp={{L,T,L+cL,T},{L,T,L,T+cH},{R,T,R-cL,T},{R,T,R,T+cH},{L,B,L+cL,B},{L,B,L,B-cH},{R,B,R-cL,B},{R,B,R,B-cH}}
            for i,c in ipairs(d.corners) do c.From=Vector2.new(cp[i][1],cp[i][2]); c.To=Vector2.new(cp[i][3],cp[i][4]); c.Color=Color3.new(1,1,1); c.Visible=true end
        else d.box.Visible=false; for _,c in ipairs(d.corners) do c.Visible=false end end

        -- NAME + DIST
        if anyOn and ESP_States.NAME then
            d.nameL.Text=ESP_States.DISTANCE and string.format("[ %s   %dm ]",p.Name,dist) or string.format("[ %s ]",p.Name)
            d.nameL.Position=Vector2.new(cx,T-17); d.nameL.Color=ac; d.nameL.Visible=true; d.distL.Visible=false
        elseif anyOn and ESP_States.DISTANCE then
            d.nameL.Visible=false; d.distL.Text=dist.."m"; d.distL.Position=Vector2.new(cx,T-15); d.distL.Visible=true
        else d.nameL.Visible=false; d.distL.Visible=false end

        -- HP
        if anyOn and ESP_States.HEALTH then
            local bx=L-7; local bf=T+(B-T)*(1-hpPct)
            d.hpBg.From=Vector2.new(bx,T); d.hpBg.To=Vector2.new(bx,B); d.hpBg.Visible=true
            d.hpBar.From=Vector2.new(bx,bf); d.hpBar.To=Vector2.new(bx,B); d.hpBar.Color=hpColor; d.hpBar.Visible=true
            d.hpTxt.Text=math.floor(hum.Health).."hp"; d.hpTxt.Position=Vector2.new(bx+4,bf-8); d.hpTxt.Color=hpColor; d.hpTxt.Visible=true
        else d.hpBg.Visible=false; d.hpBar.Visible=false; d.hpTxt.Visible=false end

        -- SKELETON
        if anyOn and ESP_States.SKELETON then
            for i,pair in ipairs(SkeletonPairs) do
                local pA=char:FindFirstChild(pair[1]); local pB=char:FindFirstChild(pair[2]); local sl=d.skels[i]
                if pA and pB then local vA,oA=Camera:WorldToViewportPoint(pA.Position); local vB,oB=Camera:WorldToViewportPoint(pB.Position)
                    if oA or oB then sl.From=Vector2.new(vA.X,vA.Y); sl.To=Vector2.new(vB.X,vB.Y); sl.Color=ac; sl.Visible=true else sl.Visible=false end
                else sl.Visible=false end
            end
        else for _,l in ipairs(d.skels) do l.Visible=false end end

        -- TRACER
        if anyOn and ESP_States.TRACER then
            local rv,ron=Camera:WorldToViewportPoint(root.Position)
            d.tracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); d.tracer.To=Vector2.new(rv.X,rv.Y); d.tracer.Color=ac; d.tracer.Visible=ron
        else d.tracer.Visible=false end

        -- CHAMS
        if ESP_States.CHAMS then
            if not char:FindFirstChild("SauronESP") then
                local hl=Instance.new("Highlight",char); hl.Name="SauronESP"; hl.FillTransparency=0.5; hl.OutlineTransparency=0
            else char.SauronESP.FillColor=ac end
        else if char:FindFirstChild("SauronESP") then char.SauronESP:Destroy() end end

        -- RADAR
        if RADAR_ESP and myRoot then
            local rd=GetRadarDot(p); local rel=myRoot.CFrame:inverse()*CFrame.new(root.Position)
            local rx=math.clamp(rel.X/70,-1,1); local rz=math.clamp(-rel.Z/70,-1,1)
            rd.dot.Position=UDim2.new(0,rx*65+77,0,rz*65+77); rd.dot.BackgroundColor3=hpColor; rd.dot.Visible=true
        elseif RadarDots[p] then RadarDots[p].dot.Visible=false end
    end
    RadarSelf.BackgroundColor3=ac
end

-- ══════════════════════════════════════════════
-- ████  RENDER LOOP  ████
-- ══════════════════════════════════════════════
local lastGhostTime=0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local t=tick(); local cn=Themes[CurrentThemeIndex]; local ac=Color3.new(1,1,1)
        if cn=="RGB" then ac=Color3.fromHSV(t%3/3,1,1) elseif ThemeColors[cn] then ac=ThemeColors[cn] end

        -- RGB objects
        for i,obj in pairs(RGB_Objects) do
            if obj.Instance and obj.Instance.Parent then
                if obj.Type=="Stroke" then obj.Instance.Color=ac
                elseif obj.Type=="Text" then obj.Instance.TextColor3=ac
                elseif obj.Type=="Image" then obj.Instance.ImageColor3=ac
                elseif obj.Type=="Part" then obj.Instance.Color=ac end
            else table.remove(RGB_Objects,i) end
        end

        -- Watermark visibility
        local wm=ScreenGui.Parent:FindFirstChild("SauronWatermark"); if wm then wm.Enabled=States.Watermark end

        -- Death label color
        DeathLabel.TextColor3=ac

        -- Info update
        if Tabs["INFO"].page.Visible then
            InfoLabel.Text=string.format("  SESSION: %s\n  USER: %s\n  FPS: %d\n  PING: %d ms\n  GAME: %s",
                SessionID, Player.Name,
                math.floor(Workspace:GetRealPhysicsFPS()),
                math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()),
                game.Name)
        end

        -- ESP
        UpdateESP(ac)
        RadarFrame.Visible=RADAR_ESP

        -- Player character logic
        local char=Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hum=char:FindFirstChild("Humanoid"); local root=char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        if States.Fullbright then Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=1e6 end
        if States.RGB and char:FindFirstChild("Body Colors") then
            local bc=char:FindFirstChild("Body Colors"); bc.HeadColor3=ac; bc.TorsoColor3=ac; bc.LeftArmColor3=ac; bc.RightArmColor3=ac; bc.LeftLegColor3=ac; bc.RightLegColor3=ac
        end
        if States.AntiKnockback then
            if root.Velocity.Magnitude>25 then
                if hum.MoveDirection.Magnitude>0 then root.Velocity=hum.MoveDirection*hum.WalkSpeed else root.Velocity=Vector3.zero end
                root.RotVelocity=Vector3.zero
            end
        end
        if States.Aim then
            local tgt=GetClosestPlayer(); if tgt and tgt:FindFirstChild("Head") then
                Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,tgt.Head.Position),valSmooth)
            end
        end
        if States.IsRecording then
            local pos=root.CFrame; if hum.SeatPart then pos=hum.SeatPart.CFrame end
            table.insert(RecordedPath,{CF=pos})
        end
        if States.UnlockAll then Player.CameraMaxZoomDistance=100000; Player.CameraMinZoomDistance=0
            if Player.CameraMode~=Enum.CameraMode.Classic then Player.CameraMode=Enum.CameraMode.Classic end
        end
        if States.SpdBypass and hum.MoveDirection.Magnitude>0 then root.CFrame=root.CFrame+(hum.MoveDirection*valBypassSpeed) end
        if States.Fly and root and hum then
            root.Velocity=Vector3.new(0,0.1,0)
            if hum.MoveDirection.Magnitude>0 then root.CFrame=root.CFrame+(hum.MoveDirection*valFlySpeed) end
            if up then root.CFrame=root.CFrame*CFrame.new(0,valFlySpeed,0) end
            if down then root.CFrame=root.CFrame*CFrame.new(0,-valFlySpeed,0) end
        end
        if States.KillAura then
            local tool=char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for _,v in pairs(Players:GetPlayers()) do
                    if v~=Player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health>0 then
                        local d=(v.Character.Head.Position-root.Position).Magnitude
                        if d<50 then tool.Handle.CFrame=v.Character.Head.CFrame; tool:Activate()
                            pcall(function() firetouchinterest(tool.Handle,v.Character.Head,0); firetouchinterest(tool.Handle,v.Character.Head,1) end); break end
                    end
                end
            end
        end
        if States.Ghosts and tick()-lastGhostTime>valGhostRate then lastGhostTime=tick()
            for _,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.Transparency<1 then
                    local g=v:Clone(); g.Parent=Workspace; g.Anchored=true; g.CanCollide=false; g.CFrame=v.CFrame
                    g.Color=ac; g.Material=Enum.Material.Neon; g:ClearAllChildren()
                    TweenService:Create(g,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=1,CFrame=g.CFrame*CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),0),Size=g.Size*1.1}):Play()
                    Debris:AddItem(g,0.5)
                end
            end
        end
        if States.Spd and hum.MoveDirection.Magnitude>0 then root.CFrame=root.CFrame+(hum.MoveDirection*(0.5*valSpeed)) end
        if States.Jump then hum.UseJumpPower=true; hum.JumpPower=valJumpPower else hum.JumpPower=50 end
        if States.Hitbox then
            for _,v in pairs(Players:GetPlayers()) do
                if v~=Player and v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size=Vector3.new(valHitbox,valHitbox,valHitbox)
                    v.Character.Head.Transparency=0.7; v.Character.Head.CanCollide=false; v.Character.Head.Color=ac; v.Character.Head.Material=Enum.Material.Neon
                end
            end
        else
            for _,v in pairs(Players:GetPlayers()) do
                if v~=Player and v.Character and v.Character:FindFirstChild("Head") then
                    local hd=v.Character.Head; if hd.Size~=Vector3.new(1,1,1) then hd.Size=Vector3.new(1,1,1); hd.Transparency=0 end
                end
            end
        end
    end)
end)

Notify("⚔ SAURON V1 — LOADED")

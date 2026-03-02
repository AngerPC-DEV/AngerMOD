-- [[ ⛧ AngerPC ⛧ V127 GROQ-MUSIC ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- [[ DELTA COMPATIBILITY ]] --
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local getcustomasset = getcustomasset or getsynasset

-- [[ SESSION INFO ]] --
local SessionID = string.upper(HttpService:GenerateGUID(false):sub(1, 8))

-- [[ MEMORY SYSTEM (AI) ]] --
local ChatHistory = {
    {
        role = "system",
        content = "Ты — AngerPC, крутой ИИ-бот в Roblox. Создатель: AngerPC-DEV. Характер: дерзкий, краткий."
    }
}

-- [[ GROQ MODELS ]] --
local GroqModels = {
    "llama-3.3-70b-versatile",
    "llama-3.1-70b-versatile", 
    "deepseek-r1-distill-llama-70b"
}
local CurrentModelIndex = 1

-- [[ THEME SYSTEM ]] --
local Themes = { "RGB", "БЕЛЫЙ", "СЕРЫЙ", "ГОЛУБОЙ", "ФИОЛЕТОВЫЙ", "НЕОБЫЧНЫЙ", "РОЗОВЫЙ", "КРАСНЫЙ" }
local ThemeColors = {
    ["БЕЛЫЙ"] = Color3.new(1, 1, 1), ["СЕРЫЙ"] = Color3.fromRGB(120, 120, 120),
    ["ГОЛУБОЙ"] = Color3.fromRGB(0, 190, 255), ["ФИОЛЕТОВЫЙ"] = Color3.fromRGB(170, 0, 255),
    ["НЕОБЫЧНЫЙ"] = Color3.fromRGB(255, 170, 0), ["РОЗОВЫЙ"] = Color3.fromRGB(255, 105, 180),
    ["КРАСНЫЙ"] = Color3.fromRGB(255, 0, 0)
}
local CurrentThemeIndex = 1 

-- [[ MUSIC SYSTEM ]] --
local CurrentSound = nil
local MusicPlaying = false


-- ══════════════════════════════════════════════════════
-- LOGIN
-- ══════════════════════════════════════════════════════
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "SauronLogin"; LoginGui.ResetOnSpawn = false
LoginGui.DisplayOrder = 999; LoginGui.IgnoreGuiInset = true
LoginGui.Parent = Player:WaitForChild("PlayerGui")

local LBg = Instance.new("Frame", LoginGui)
LBg.Size = UDim2.new(1,0,1,0); LBg.BackgroundColor3 = Color3.fromRGB(5,5,5); LBg.BorderSizePixel = 0

local LC = Instance.new("Frame", LBg)
LC.Size = UDim2.new(0,380,0,310); LC.Position = UDim2.new(0.5,-190,0.5,-155)
LC.BackgroundColor3 = Color3.fromRGB(10,10,10); LC.BorderSizePixel = 0
Instance.new("UICorner",LC).CornerRadius = UDim.new(0,14)
local LCS = Instance.new("UIStroke",LC); LCS.Thickness = 1.5; LCS.Color = Color3.fromRGB(80,0,0)
Instance.new("Frame",LC).Size = UDim2.new(1,0,0,3)
LC:FindFirstChildOfClass("Frame").BackgroundColor3 = Color3.fromRGB(200,0,0)
LC:FindFirstChildOfClass("Frame").BorderSizePixel = 0

local LImg = Instance.new("ImageLabel",LC)
LImg.Size = UDim2.new(0,240,0,58); LImg.Position = UDim2.new(0.5,-120,0,14)
LImg.BackgroundTransparency = 1; LImg.ScaleType = Enum.ScaleType.Fit
LImg.Image = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"
local LFb = Instance.new("TextLabel",LC)
LFb.Size = UDim2.new(1,0,0,58); LFb.Position = UDim2.new(0,0,0,14)
LFb.BackgroundTransparency = 1; LFb.Text = "⚔  SAURON V1"
LFb.Font = Enum.Font.SciFi; LFb.TextSize = 32; LFb.TextColor3 = Color3.fromRGB(220,0,0); LFb.Visible = false
task.delay(3, function() if LImg.ContentImageSize == Vector2.new(0,0) then LFb.Visible=true; LImg.Visible=false end end)

local function LDiv(ypos)
    local d = Instance.new("Frame",LC); d.Size = UDim2.new(0.88,0,0,1); d.Position = UDim2.new(0.06,0,0,ypos)
    d.BackgroundColor3 = Color3.fromRGB(35,35,35); d.BorderSizePixel = 0
end
LDiv(80)

local LHint = Instance.new("TextLabel",LC); LHint.Size = UDim2.new(1,0,0,16); LHint.Position = UDim2.new(0,0,0,88)
LHint.BackgroundTransparency = 1; LHint.Text = "ВВЕДИ КЛЮЧ ДОСТУПА"
LHint.Font = Enum.Font.SciFi; LHint.TextSize = 11; LHint.TextColor3 = Color3.fromRGB(75,75,75)

local LKB = Instance.new("TextBox",LC)
LKB.Size = UDim2.new(0.88,0,0,46); LKB.Position = UDim2.new(0.06,0,0,108)
LKB.BackgroundColor3 = Color3.fromRGB(16,16,16); LKB.TextColor3 = Color3.new(1,1,1)
LKB.PlaceholderText = "SAURON-XXXXXXXX"; LKB.PlaceholderColor3 = Color3.fromRGB(55,55,55)
LKB.Text = ""; LKB.Font = Enum.Font.SciFi; LKB.TextSize = 16; LKB.ClearTextOnFocus = false; LKB.BorderSizePixel = 0
Instance.new("UICorner",LKB).CornerRadius = UDim.new(0,10)
local LKS = Instance.new("UIStroke",LKB); LKS.Thickness = 1.5; LKS.Color = Color3.fromRGB(45,45,45)

local LSt = Instance.new("TextLabel",LC)
LSt.Size = UDim2.new(0.88,0,0,18); LSt.Position = UDim2.new(0.06,0,0,160)
LSt.BackgroundTransparency = 1; LSt.Text = "●  ожидание"
LSt.Font = Enum.Font.SciFi; LSt.TextSize = 12; LSt.TextColor3 = Color3.fromRGB(75,75,75); LSt.TextXAlignment = Enum.TextXAlignment.Left

local LPBg = Instance.new("Frame",LC); LPBg.Size = UDim2.new(0.88,0,0,4); LPBg.Position = UDim2.new(0.06,0,0,185)
LPBg.BackgroundColor3 = Color3.fromRGB(20,20,20); LPBg.BorderSizePixel = 0; LPBg.Visible = false
Instance.new("UICorner",LPBg).CornerRadius = UDim.new(1,0)
local LPF = Instance.new("Frame",LPBg); LPF.Size = UDim2.new(0,0,1,0); LPF.BackgroundColor3 = Color3.fromRGB(200,0,0); LPF.BorderSizePixel = 0
Instance.new("UICorner",LPF).CornerRadius = UDim.new(1,0)

local LBtn = Instance.new("TextButton",LC)
LBtn.Size = UDim2.new(0.88,0,0,48); LBtn.Position = UDim2.new(0.06,0,0,198)
LBtn.BackgroundColor3 = Color3.fromRGB(155,0,0); LBtn.TextColor3 = Color3.new(1,1,1)
LBtn.Text = "▶  ВОЙТИ"; LBtn.Font = Enum.Font.SciFi; LBtn.TextSize = 16; LBtn.BorderSizePixel = 0
Instance.new("UICorner",LBtn).CornerRadius = UDim.new(0,12)

local LVer = Instance.new("TextLabel",LC); LVer.Size = UDim2.new(1,0,0,16); LVer.Position = UDim2.new(0,0,0,262)
LVer.BackgroundTransparency = 1; LVer.Text = "SAURON V1  ·  AngerPC-DEV"
LVer.Font = Enum.Font.SciFi; LVer.TextSize = 10; LVer.TextColor3 = Color3.fromRGB(38,38,38)

task.spawn(function()
    while LoginGui.Parent do
        TweenService:Create(LCS,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(220,0,0)}):Play(); task.wait(1.2)
        TweenService:Create(LCS,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(55,0,0)}):Play(); task.wait(1.2)
    end
end)
LBtn.MouseEnter:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(200,0,0)}):Play() end)
LBtn.MouseLeave:Connect(function() TweenService:Create(LBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(155,0,0)}):Play() end)

local ValidKeys = {}; local KeysLoaded = false
task.spawn(function()
    local ok,res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.sauron",true) end)
    if ok and res and #res > 2 then
        for line in res:gmatch("[^\r\n]+") do
            line = line:match("^%s*(.-)%s*$")
            local key = line:match("|%s*(.+)$") or line; key = key:match("^%s*(.-)%s*$")
            if key and #key > 3 then ValidKeys[key] = true end
        end
        LSt.Text = "●  сервер доступен"; LSt.TextColor3 = Color3.fromRGB(0,160,60); KeysLoaded = true
    else LSt.Text = "●  оффлайн"; LSt.TextColor3 = Color3.fromRGB(200,140,0) end
end)

local function TryLogin()
    local key = LKB.Text:match("^%s*(.-)%s*$")
    if key == "" then LSt.Text="●  введи ключ!"; LSt.TextColor3=Color3.fromRGB(220,50,50); return end
    LBtn.Active=false; LBtn.Text="⏳  ПРОВЕРКА..."
    LSt.Text="●  проверяем..."; LSt.TextColor3=Color3.fromRGB(200,160,0)
    LPBg.Visible=true; TweenService:Create(LPF,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
    task.wait(1)
    local valid = ValidKeys[key] or (not KeysLoaded and key:sub(1,7)=="SAURON-" and #key>=10)
    if valid then
        LSt.Text="●  доступ разрешён!"; LSt.TextColor3=Color3.fromRGB(0,220,80)
        LBtn.Text="✅  ДОБРО ПОЖАЛОВАТЬ"; LBtn.BackgroundColor3=Color3.fromRGB(0,110,40)
        task.wait(0.7)
        TweenService:Create(LC,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-190,-0.15,-155)}):Play()
        TweenService:Create(LBg,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play(); task.wait(0.5); LoginGui:Destroy()
    else
        LSt.Text="●  неверный ключ!"; LSt.TextColor3=Color3.fromRGB(220,50,50)
        LBtn.Text="▶  ВОЙТИ"; LBtn.BackgroundColor3=Color3.fromRGB(155,0,0); LBtn.Active=true
        LPBg.Visible=false; LPF.Size=UDim2.new(0,0,1,0)
        local p=LC.Position; for i=1,6 do task.wait(0.04); LC.Position=p+UDim2.new(0,i%2==0 and 8 or -8,0,0) end; LC.Position=p
    end
end
LBtn.MouseButton1Click:Connect(TryLogin)
LKB.FocusLost:Connect(function(enter) if enter then TryLogin() end end)
repeat task.wait(0.05) until not LoginGui or not LoginGui.Parent or not LoginGui:IsDescendantOf(game)

-- ══════════════════════════════════════════════════════
-- MAIN GUI SETUP (оригинальная логика сохранена)
-- ══════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SauronGUI_V1"; ScreenGui.ResetOnSpawn = false
if Player:FindFirstChild("PlayerGui") then ScreenGui.Parent = Player.PlayerGui
else ScreenGui.Parent = game:GetService("CoreGui") end

-- DEATH SCREEN
local DeathScreen = Instance.new("ScreenGui", ScreenGui.Parent)
DeathScreen.Name = "AngerDeath"; DeathScreen.Enabled = false
local DeathLabel = Instance.new("TextLabel", DeathScreen)
DeathLabel.Size=UDim2.new(1,0,1,0); DeathLabel.BackgroundTransparency=1; DeathLabel.Text="WASTED"
DeathLabel.Font=Enum.Font.Creepster; DeathLabel.TextSize=100; DeathLabel.TextColor3=Color3.fromRGB(255,0,0); DeathLabel.TextStrokeTransparency=0

-- LISTS & VARS
local RGB_Objects = {}
local Movable_Objects = {}
local RecordedPath = {}
local UI_Unlocked = false
local ESPLines = {}

local function style(obj, radius, thickness)
    local uiC = Instance.new("UICorner", obj); uiC.CornerRadius = UDim.new(0, radius or 6)
    local uiS = Instance.new("UIStroke", obj); uiS.Color = Color3.fromRGB(60,60,60); uiS.Thickness = thickness or 1
    table.insert(RGB_Objects, {Type="Stroke", Instance=uiS})
    return uiS
end

-- NOTIFICATIONS
local NotifyContainer = Instance.new("Frame", ScreenGui)
NotifyContainer.Size=UDim2.new(0,250,0.4,0); NotifyContainer.Position=UDim2.new(1,-260,0.55,0); NotifyContainer.BackgroundTransparency=1
local NotifyLayout=Instance.new("UIListLayout",NotifyContainer); NotifyLayout.SortOrder=Enum.SortOrder.LayoutOrder; NotifyLayout.VerticalAlignment=Enum.VerticalAlignment.Bottom; NotifyLayout.Padding=UDim.new(0,5)

local function Notify(text)
    local f=Instance.new("Frame",NotifyContainer); f.Size=UDim2.new(1,0,0,35); f.BackgroundColor3=Color3.fromRGB(20,20,20); f.BackgroundTransparency=0.2; style(f,4,1)
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,5,0,0); l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.SciFi; l.TextSize=14; l.TextXAlignment=Enum.TextXAlignment.Left
    f.BackgroundTransparency=1; l.TextTransparency=1
    TweenService:Create(f,TweenInfo.new(0.3),{BackgroundTransparency=0.2}):Play(); TweenService:Create(l,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    task.delay(3,function() TweenService:Create(f,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play(); TweenService:Create(l,TweenInfo.new(0.5),{TextTransparency=1}):Play(); task.wait(0.5); f:Destroy() end)
end

-- MUSIC WIDGET
local MusicWidget=Instance.new("Frame",ScreenGui); MusicWidget.Size=UDim2.new(0,200,0,120); MusicWidget.Position=UDim2.new(1,-210,1,-130); MusicWidget.BackgroundColor3=Color3.fromRGB(15,15,15); MusicWidget.Visible=false; MusicWidget.Active=true; MusicWidget.Draggable=true; style(MusicWidget,8,2); table.insert(Movable_Objects,MusicWidget)
local MusicIcon=Instance.new("ImageLabel",MusicWidget); MusicIcon.Size=UDim2.new(0,50,0,50); MusicIcon.Position=UDim2.new(0,10,0,10); MusicIcon.BackgroundTransparency=1; MusicIcon.Image="rbxassetid://6031265976"; table.insert(RGB_Objects,{Type="Image",Instance=MusicIcon})
local MusicTitle=Instance.new("TextLabel",MusicWidget); MusicTitle.Size=UDim2.new(1,-70,0,25); MusicTitle.Position=UDim2.new(0,65,0,10); MusicTitle.BackgroundTransparency=1; MusicTitle.Text="NO MUSIC"; MusicTitle.TextColor3=Color3.new(1,1,1); MusicTitle.Font=Enum.Font.SciFi; MusicTitle.TextSize=14; MusicTitle.TextXAlignment=Enum.TextXAlignment.Left; MusicTitle.TextScaled=true
local MusicStatus=Instance.new("TextLabel",MusicWidget); MusicStatus.Size=UDim2.new(1,-70,0,20); MusicStatus.Position=UDim2.new(0,65,0,35); MusicStatus.BackgroundTransparency=1; MusicStatus.Text="IDLE"; MusicStatus.TextColor3=Color3.fromRGB(150,150,150); MusicStatus.Font=Enum.Font.SciFi; MusicStatus.TextSize=12; MusicStatus.TextXAlignment=Enum.TextXAlignment.Left
local BtnPlayPause=Instance.new("TextButton",MusicWidget); BtnPlayPause.Size=UDim2.new(0.3,-5,0,30); BtnPlayPause.Position=UDim2.new(0,10,1,-40); BtnPlayPause.Text="PLAY"; BtnPlayPause.BackgroundColor3=Color3.fromRGB(20,40,20); BtnPlayPause.TextColor3=Color3.new(1,1,1); BtnPlayPause.Font=Enum.Font.SciFi; BtnPlayPause.TextSize=12; style(BtnPlayPause)
local BtnStop=Instance.new("TextButton",MusicWidget); BtnStop.Size=UDim2.new(0.3,-5,0,30); BtnStop.Position=UDim2.new(0.35,0,1,-40); BtnStop.Text="STOP"; BtnStop.BackgroundColor3=Color3.fromRGB(40,20,20); BtnStop.TextColor3=Color3.new(1,1,1); BtnStop.Font=Enum.Font.SciFi; BtnStop.TextSize=12; style(BtnStop)
local BtnSkip=Instance.new("TextButton",MusicWidget); BtnSkip.Size=UDim2.new(0.3,-5,0,30); BtnSkip.Position=UDim2.new(0.7,0,1,-40); BtnSkip.Text="SKIP"; BtnSkip.BackgroundColor3=Color3.fromRGB(20,20,40); BtnSkip.TextColor3=Color3.new(1,1,1); BtnSkip.Font=Enum.Font.SciFi; BtnSkip.TextSize=12; style(BtnSkip)

-- ══════════════════════════════════════════════════════
-- НОВЫЙ КРАСИВЫЙ ГЛАВНЫЙ ФРЕЙМ
-- ══════════════════════════════════════════════════════

-- Кнопка открыть/закрыть ⚔
local SideBtn = Instance.new("TextButton", ScreenGui)
SideBtn.Name = "ToggleMenu"; SideBtn.Size = UDim2.new(0,46,0,46); SideBtn.Position = UDim2.new(0,8,0.5,-23)
SideBtn.BackgroundColor3 = Color3.fromRGB(130,0,0); SideBtn.TextColor3 = Color3.new(1,1,1)
SideBtn.Text = "⚔"; SideBtn.Font = Enum.Font.SciFi; SideBtn.TextSize = 20; SideBtn.BorderSizePixel = 0
SideBtn.Active = true; SideBtn.Draggable = true
Instance.new("UICorner",SideBtn).CornerRadius = UDim.new(1,0)
local SBS = Instance.new("UIStroke",SideBtn); SBS.Thickness=2; SBS.Color=Color3.fromRGB(220,0,0)
table.insert(RGB_Objects,{Type="Stroke",Instance=SBS}); table.insert(Movable_Objects,SideBtn)

-- Главный фрейм
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,570,0,510); Main.Position = UDim2.new(0.5,-285,0.5,-255)
Main.BackgroundColor3 = Color3.fromRGB(8,8,8); Main.BorderSizePixel = 0
Main.Visible = true; Main.Active = true; Main.Draggable = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)
local MnS = Instance.new("UIStroke",Main); MnS.Thickness=1.5; MnS.Color=Color3.fromRGB(55,0,0)
table.insert(RGB_Objects,{Type="Stroke",Instance=MnS}); table.insert(Movable_Objects,Main)

SideBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Шапка
local Hdr = Instance.new("Frame",Main); Hdr.Size=UDim2.new(1,0,0,44); Hdr.BackgroundColor3=Color3.fromRGB(11,11,11); Hdr.BorderSizePixel=0
Instance.new("UICorner",Hdr).CornerRadius = UDim.new(0,12)
local Title = Instance.new("TextLabel",Hdr); Title.Size=UDim2.new(1,-50,1,0); Title.Position=UDim2.new(0,14,0,0)
Title.BackgroundTransparency=1; Title.Text="⚔  SAURON  V1"; Title.Font=Enum.Font.SciFi; Title.TextSize=20
Title.TextColor3=Color3.fromRGB(220,0,0); Title.TextXAlignment=Enum.TextXAlignment.Left
table.insert(RGB_Objects,{Type="Text",Instance=Title})
local CloseX = Instance.new("TextButton",Hdr); CloseX.Size=UDim2.new(0,26,0,26); CloseX.Position=UDim2.new(1,-34,0.5,-13)
CloseX.BackgroundColor3=Color3.fromRGB(110,0,0); CloseX.TextColor3=Color3.new(1,1,1); CloseX.Text="✕"
CloseX.Font=Enum.Font.SciFi; CloseX.TextSize=12; CloseX.BorderSizePixel=0
Instance.new("UICorner",CloseX).CornerRadius=UDim.new(0,6)
CloseX.MouseButton1Click:Connect(function() Main.Visible=false end)

-- Левая панель
local LP = Instance.new("Frame",Main); LP.Size=UDim2.new(0,108,1,-52); LP.Position=UDim2.new(0,6,0,47)
LP.BackgroundColor3=Color3.fromRGB(11,11,11); LP.BorderSizePixel=0
Instance.new("UICorner",LP).CornerRadius=UDim.new(0,10)
local TLL=Instance.new("UIListLayout",LP); TLL.Padding=UDim.new(0,3); TLL.HorizontalAlignment=Enum.HorizontalAlignment.Center
local TLP=Instance.new("UIPadding",LP); TLP.PaddingTop=UDim.new(0,5)

-- Контент
local CA = Instance.new("Frame",Main); CA.Size=UDim2.new(1,-118,1,-52); CA.Position=UDim2.new(0,116,0,47)
CA.BackgroundTransparency=1; CA.ClipsDescendants=true

-- TAB SYSTEM
local Tabs = {}
local function SwitchTab(id)
    for tid,t in pairs(Tabs) do
        local on=(tid==id)
        TweenService:Create(t.btn,TweenInfo.new(0.12),{BackgroundColor3=on and Color3.fromRGB(140,0,0) or Color3.fromRGB(18,18,18)}):Play()
        t.page.Visible=on; t.ind.Visible=on
    end
end

local TabDefs = {
    {id="MAIN",   icon="⚡", lbl="PLAYER"},
    {id="ESP",    icon="👁",  lbl="ESP"},
    {id="VISUAL", icon="✨", lbl="VISUAL"},
    {id="AI",     icon="🤖", lbl="AI-SN"},
    {id="INFO",   icon="📊", lbl="INFO"},
    {id="WORLD",  icon="🌍", lbl="WORLD"},
    {id="UI",     icon="🔧", lbl="UI"},
}
for _,def in ipairs(TabDefs) do
    local btn=Instance.new("TextButton",LP); btn.Size=UDim2.new(0,92,0,54); btn.BackgroundColor3=Color3.fromRGB(18,18,18); btn.BorderSizePixel=0; btn.Text=""
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local iL=Instance.new("TextLabel",btn); iL.Size=UDim2.new(1,0,0,26); iL.Position=UDim2.new(0,0,0,6); iL.BackgroundTransparency=1; iL.Text=def.icon; iL.TextSize=17; iL.Font=Enum.Font.SciFi
    local nL=Instance.new("TextLabel",btn); nL.Size=UDim2.new(1,0,0,16); nL.Position=UDim2.new(0,0,0,31); nL.BackgroundTransparency=1; nL.Text=def.lbl; nL.TextSize=9; nL.Font=Enum.Font.SciFi; nL.TextColor3=Color3.fromRGB(110,110,110)
    local ind=Instance.new("Frame",btn); ind.Size=UDim2.new(0,3,0.5,0); ind.Position=UDim2.new(0,1,0.25,0); ind.BackgroundColor3=Color3.fromRGB(220,0,0); ind.BorderSizePixel=0; Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0); ind.Visible=false
    local page=Instance.new("ScrollingFrame",CA); page.Size=UDim2.new(1,-2,1,-4); page.Position=UDim2.new(0,1,0,2)
    page.BackgroundTransparency=1; page.ScrollBarThickness=3; page.ScrollBarImageColor3=Color3.fromRGB(180,0,0); page.Visible=false
    page.CanvasSize=UDim2.new(0,0,0,0); page.ScrollingDirection=Enum.ScrollingDirection.Y
    local pl=Instance.new("UIListLayout",page); pl.Padding=UDim.new(0,6); pl.SortOrder=Enum.SortOrder.LayoutOrder
    local pp=Instance.new("UIPadding",page); pp.PaddingTop=UDim.new(0,4); pp.PaddingBottom=UDim.new(0,8); pp.PaddingLeft=UDim.new(0,2); pp.PaddingRight=UDim.new(0,5)
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() page.CanvasSize=UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+14) end)
    btn.MouseButton1Click:Connect(function() SwitchTab(def.id) end)
    Tabs[def.id]={btn=btn,page=page,ind=ind}
end

-- Алиасы страниц для совместимости с оригинальным кодом ниже
local PageMain  = Tabs["MAIN"].page
local PageInfo  = Tabs["INFO"].page
local PageAI    = Tabs["AI"].page
local PageWorld = Tabs["WORLD"].page
local PageUI    = Tabs["UI"].page

-- СТРАНИЦА ESP
local PageESP   = Tabs["ESP"].page
local function ESPTogRow(parent, lbl, tbl, key)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,40); f.BackgroundColor3=Color3.fromRGB(14,14,14); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8); local fs=Instance.new("UIStroke",f); fs.Thickness=1; fs.Color=Color3.fromRGB(30,30,30)
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-60,1,0); l.Position=UDim2.new(0,12,0,0); l.BackgroundTransparency=1; l.Text=lbl; l.Font=Enum.Font.SciFi; l.TextSize=14; l.TextColor3=Color3.fromRGB(210,210,210); l.TextXAlignment=Enum.TextXAlignment.Left
    local on0=tbl[key]==true
    local pill=Instance.new("Frame",f); pill.Size=UDim2.new(0,38,0,20); pill.Position=UDim2.new(1,-50,0.5,-10); pill.BorderSizePixel=0; Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0); pill.BackgroundColor3=on0 and Color3.fromRGB(160,0,0) or Color3.fromRGB(26,26,26)
    local dot=Instance.new("Frame",pill); dot.Size=UDim2.new(0,14,0,14); dot.BorderSizePixel=0; dot.BackgroundColor3=Color3.new(1,1,1); dot.Position=on0 and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7); Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local btn=Instance.new("TextButton",f); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.MouseButton1Click:Connect(function()
        tbl[key]=not tbl[key]; local on=tbl[key]
        TweenService:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and Color3.fromRGB(160,0,0) or Color3.fromRGB(26,26,26)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
        fs.Color=on and Color3.fromRGB(80,0,0) or Color3.fromRGB(30,30,30)
    end)
end
-- ESP_States объявляется ниже в логике, пока заглушка
local ESP_States = {BOX=true,NAME=true,HEALTH=true,DISTANCE=false,SKELETON=false,TRACER=false,CHAMS=false}
ESPTogRow(PageESP,"📦  BOX ESP",      ESP_States,"BOX")
ESPTogRow(PageESP,"👤  NAMETAG",      ESP_States,"NAME")
ESPTogRow(PageESP,"❤   HEALTH BAR",   ESP_States,"HEALTH")
ESPTogRow(PageESP,"📏  DISTANCE",     ESP_States,"DISTANCE")
ESPTogRow(PageESP,"💀  SKELETON",     ESP_States,"SKELETON")
ESPTogRow(PageESP,"➡   TRACER",      ESP_States,"TRACER")
ESPTogRow(PageESP,"🎨  CHAMS (Esp)",  ESP_States,"CHAMS")

-- СТРАНИЦА VISUAL
local PageVisual = Tabs["VISUAL"].page

-- PageMusic dummy — нужна логике
local PageMusic = Instance.new("Frame",ScreenGui); PageMusic.Visible=false; PageMusic.Size=UDim2.new(0,1,0,1)
local MusicIDBox=Instance.new("TextBox",PageMusic); MusicIDBox.Text=""
local PlayIDBtn=Instance.new("TextButton",PageMusic); PlayIDBtn.Text=""
local YouTubeLinkBox=Instance.new("TextBox",PageMusic); YouTubeLinkBox.Text=""
local PlayYTBtn=Instance.new("TextButton",PageMusic); PlayYTBtn.Text=""
local SearchBox=Instance.new("TextBox",PageMusic); SearchBox.Text=""
local SearchBtn=Instance.new("TextButton",PageMusic); SearchBtn.Text=""
local StopMusicBtn=Instance.new("TextButton",PageMusic); StopMusicBtn.Text=""
local VolumeSlider=Instance.new("TextBox",PageMusic); VolumeSlider.Text="5"

-- КНОПКА ТЕМЫ
local btnTheme=Instance.new("TextButton",PageMain); btnTheme.Size=UDim2.new(1,0,0,42); btnTheme.BackgroundColor3=Color3.fromRGB(22,10,10); btnTheme.Text="🎨  ТЕМА: "..Themes[CurrentThemeIndex]; btnTheme.TextColor3=Color3.new(1,1,1); btnTheme.Font=Enum.Font.SciFi; btnTheme.TextSize=14; btnTheme.BorderSizePixel=0; Instance.new("UICorner",btnTheme).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",btnTheme).Color=Color3.fromRGB(40,10,10)
btnTheme.MouseButton1Click:Connect(function() CurrentThemeIndex=CurrentThemeIndex+1; if CurrentThemeIndex>#Themes then CurrentThemeIndex=1 end; btnTheme.Text="🎨  ТЕМА: "..Themes[CurrentThemeIndex] end)

-- addOption — создаёт строку с тогглом + инпут, добавляет в нужную страницу
local function addOption(name, key, useInput, defaultInputVal, inputCallback, customPage)
    local parent = customPage or PageMain
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,42); f.BackgroundColor3=Color3.fromRGB(14,14,14); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8); local fs=Instance.new("UIStroke",f); fs.Thickness=1; fs.Color=Color3.fromRGB(30,30,30)
    -- label
    local lbl=Instance.new("TextLabel",f); lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.SciFi; lbl.TextSize=13; lbl.TextColor3=Color3.fromRGB(210,210,210); lbl.TextXAlignment=Enum.TextXAlignment.Left
    local inp=nil
    if useInput then
        lbl.Size=UDim2.new(0.52,-4,1,0); lbl.Position=UDim2.new(0,10,0,0); lbl.Text=name
        inp=Instance.new("TextBox",f); inp.Size=UDim2.new(0.22,-4,0.7,0); inp.Position=UDim2.new(0.52,2,0.15,0)
        inp.Text=tostring(defaultInputVal); inp.BackgroundColor3=Color3.fromRGB(22,22,22); inp.TextColor3=Color3.new(1,1,1)
        inp.Font=Enum.Font.SciFi; inp.TextSize=12; inp.ClearTextOnFocus=false; inp.BorderSizePixel=0
        Instance.new("UICorner",inp).CornerRadius=UDim.new(0,6)
        inp.FocusLost:Connect(function() local n=tonumber(inp.Text); if n then inputCallback(n) else inp.Text=tostring(defaultInputVal) end end)
    else
        lbl.Size=UDim2.new(0.76,-4,1,0); lbl.Position=UDim2.new(0,10,0,0); lbl.Text=name
    end
    -- пилюля тогл
    local pill=Instance.new("Frame",f); pill.Size=UDim2.new(0,38,0,20); pill.Position=UDim2.new(1,-50,0.5,-10); pill.BorderSizePixel=0; Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    pill.BackgroundColor3=Color3.fromRGB(26,26,26)
    local dot=Instance.new("Frame",pill); dot.Size=UDim2.new(0,14,0,14); dot.BorderSizePixel=0; dot.BackgroundColor3=Color3.new(1,1,1); dot.Position=UDim2.new(0,2,0.5,-7); Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local function Toggle()
        if not States then return end
        States[key]=not States[key]; local on=States[key]
        TweenService:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and Color3.fromRGB(160,0,0) or Color3.fromRGB(26,26,26)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
        fs.Color=on and Color3.fromRGB(80,0,0) or Color3.fromRGB(30,30,30)
        Notify(name..(on and " ON" or " OFF"))
    end
    local hk=Instance.new("TextButton",ScreenGui); hk.Name="Bind_"..name; hk.Size=UDim2.new(0,50,0,50); hk.Position=UDim2.new(0.85,0,0.4,0); hk.BackgroundColor3=Color3.fromRGB(15,15,15); hk.Text=name:sub(1,3); hk.TextColor3=Color3.new(1,1,1); hk.Visible=false; hk.Active=UI_Unlocked; hk.Draggable=UI_Unlocked; style(hk,25); hk.MouseButton1Click:Connect(Toggle); table.insert(Movable_Objects,hk)
    local btn=Instance.new("TextButton",f); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.MouseButton1Click:Connect(Toggle)
end

local function Sec(parent, text)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.BorderSizePixel=0
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-6,1,0); l.Position=UDim2.new(0,6,0,0); l.BackgroundTransparency=1; l.Text=string.upper(text); l.Font=Enum.Font.SciFi; l.TextSize=10; l.TextColor3=Color3.fromRGB(100,0,0); l.TextXAlignment=Enum.TextXAlignment.Left
    local d=Instance.new("Frame",f); d.Size=UDim2.new(1,-6,0,1); d.Position=UDim2.new(0,6,1,-1); d.BackgroundColor3=Color3.fromRGB(35,0,0); d.BorderSizePixel=0
end

-- PLAYER TAB
Sec(PageMain,"COMBAT")
addOption("🎯 HUMAN AIM",      "Aim",           true,  0.15,  function(v) valSmooth=math.clamp(v,0.01,1) end)
addOption("🛡 ANTI KNOCKBACK", "AntiKnockback", false)
addOption("⚡ KILL AURA",      "KillAura",      false)
Sec(PageMain,"HITBOX")
addOption("💥 BIG HITBOX",     "Hitbox",        true,  5,     function(v) valHitbox=v end)
Sec(PageMain,"MOVEMENT")
addOption("🏃 RAGE SPEED",     "Spd",           true,  50,    function(v) valSpeed=v end)
addOption("🔄 SPEED BYPASS",   "SpdBypass",     true,  0.11,  function(v) valBypassSpeed=v end)
addOption("✈ FLY",             "Fly",           true,  5,     function(v) valFlySpeed=v end)
addOption("🦘 SUPER JUMP",     "Jump",          true,  100,   function(v) valJumpPower=v end)
addOption("♾ INF JUMP",        "InfJump",       false)
addOption("🔍 INF ZOOM",       "UnlockAll",     false)
addOption("💤 ANTI AFK",       "AntiAfk",       false)

-- VISUAL TAB
Sec(PageVisual,"ЭФФЕКТЫ")
addOption("🖼 SHOW LOGO",      "Watermark",     false, nil,nil,PageVisual)
addOption("☀ FULLBRIGHT",      "Fullbright",    false, nil,nil,PageVisual)
addOption("🌈 RGB СКИН",       "RGB",           false, nil,nil,PageVisual)
addOption("✨ ESP HIGHLIGHT",  "Esp",           false, nil,nil,PageVisual)
addOption("💫 JUMP RIPPLE",    "Circle",        true,  15,    function(v) valRipple=v end,PageVisual)
addOption("⛧ PENTAGRAM",       "UsePentagram",  false, nil,nil,PageVisual)
addOption("👻 GHOST TRAIL",    "Ghosts",        true,  0.05,  function(v) valGhostRate=math.clamp(v,0.01,2) end,PageVisual)

-- AI TAB - нужны для оригинальной логики
local AIKeyBox=Instance.new("TextBox",PageAI); AIKeyBox.Size=UDim2.new(1,0,0,42); AIKeyBox.BackgroundColor3=Color3.fromRGB(14,14,14); AIKeyBox.TextColor3=Color3.new(1,1,1); AIKeyBox.PlaceholderText="GROQ API KEY"; AIKeyBox.PlaceholderColor3=Color3.fromRGB(55,55,55); AIKeyBox.Text=""; AIKeyBox.Font=Enum.Font.SciFi; AIKeyBox.TextSize=14; AIKeyBox.ClearTextOnFocus=false; AIKeyBox.BorderSizePixel=0; Instance.new("UICorner",AIKeyBox).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",AIKeyBox).Color=Color3.fromRGB(38,38,38)

local ModelBtn=Instance.new("TextButton",PageAI); ModelBtn.Size=UDim2.new(1,0,0,42); ModelBtn.BackgroundColor3=Color3.fromRGB(16,16,24); ModelBtn.TextColor3=Color3.new(1,1,1); ModelBtn.Text="MODEL: "..GroqModels[CurrentModelIndex]; ModelBtn.Font=Enum.Font.SciFi; ModelBtn.TextSize=12; ModelBtn.BorderSizePixel=0; Instance.new("UICorner",ModelBtn).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",ModelBtn).Color=Color3.fromRGB(38,38,38)

local AIToggleBtn=Instance.new("TextButton",PageAI); AIToggleBtn.Size=UDim2.new(1,0,0,42); AIToggleBtn.BackgroundColor3=Color3.fromRGB(30,10,10); AIToggleBtn.TextColor3=Color3.new(1,1,1); AIToggleBtn.Text="AI AUTOREPLY: OFF"; AIToggleBtn.Font=Enum.Font.SciFi; AIToggleBtn.TextSize=14; AIToggleBtn.BorderSizePixel=0; Instance.new("UICorner",AIToggleBtn).CornerRadius=UDim.new(0,8)
local FriendBtn=Instance.new("TextButton",PageAI); FriendBtn.Size=UDim2.new(1,0,0,42); FriendBtn.BackgroundColor3=Color3.fromRGB(30,10,10); FriendBtn.TextColor3=Color3.new(1,1,1); FriendBtn.Text="FRIEND BOT: OFF"; FriendBtn.Font=Enum.Font.SciFi; FriendBtn.TextSize=14; FriendBtn.BorderSizePixel=0; Instance.new("UICorner",FriendBtn).CornerRadius=UDim.new(0,8)

local macRow=Instance.new("Frame",PageAI); macRow.Size=UDim2.new(1,0,0,42); macRow.BackgroundTransparency=1; macRow.BorderSizePixel=0
local RecBtn=Instance.new("TextButton",macRow); RecBtn.Size=UDim2.new(0.48,-3,1,0); RecBtn.BackgroundColor3=Color3.fromRGB(40,10,10); RecBtn.TextColor3=Color3.new(1,1,1); RecBtn.Text="⏺  RECORD"; RecBtn.Font=Enum.Font.SciFi; RecBtn.TextSize=13; RecBtn.BorderSizePixel=0; Instance.new("UICorner",RecBtn).CornerRadius=UDim.new(0,8)
local PlayBtn=Instance.new("TextButton",macRow); PlayBtn.Size=UDim2.new(0.48,-3,1,0); PlayBtn.Position=UDim2.new(0.52,3,0,0); PlayBtn.BackgroundColor3=Color3.fromRGB(10,40,10); PlayBtn.TextColor3=Color3.new(1,1,1); PlayBtn.Text="▶  PLAY"; PlayBtn.Font=Enum.Font.SciFi; PlayBtn.TextSize=13; PlayBtn.BorderSizePixel=0; Instance.new("UICorner",PlayBtn).CornerRadius=UDim.new(0,8)
local LoopBtn=Instance.new("TextButton",PageAI); LoopBtn.Size=UDim2.new(1,0,0,42); LoopBtn.BackgroundColor3=Color3.fromRGB(22,22,22); LoopBtn.TextColor3=Color3.new(1,1,1); LoopBtn.Text="LOOP PLAYBACK: OFF"; LoopBtn.Font=Enum.Font.SciFi; LoopBtn.TextSize=14; LoopBtn.BorderSizePixel=0; Instance.new("UICorner",LoopBtn).CornerRadius=UDim.new(0,8)
local AIStatus=Instance.new("TextLabel",PageAI); AIStatus.Size=UDim2.new(1,0,0,26); AIStatus.BackgroundTransparency=1; AIStatus.Text="STATUS: IDLE"; AIStatus.TextColor3=Color3.fromRGB(150,150,150); AIStatus.Font=Enum.Font.SciFi; AIStatus.TextSize=12; AIStatus.TextXAlignment=Enum.TextXAlignment.Left

-- WORLD TAB
local FogBtn=Instance.new("TextButton",PageWorld); FogBtn.Size=UDim2.new(1,0,0,42); FogBtn.BackgroundColor3=Color3.fromRGB(25,10,10); FogBtn.TextColor3=Color3.new(1,1,1); FogBtn.Text="🌫 REMOVE FOG: OFF"; FogBtn.Font=Enum.Font.SciFi; FogBtn.TextSize=14; FogBtn.BorderSizePixel=0; Instance.new("UICorner",FogBtn).CornerRadius=UDim.new(0,8)
local AmbientBtn=Instance.new("TextButton",PageWorld); AmbientBtn.Size=UDim2.new(1,0,0,42); AmbientBtn.BackgroundColor3=Color3.fromRGB(25,10,10); AmbientBtn.TextColor3=Color3.new(1,1,1); AmbientBtn.Text="💡 AMBIENT SYNC: OFF"; AmbientBtn.Font=Enum.Font.SciFi; AmbientBtn.TextSize=14; AmbientBtn.BorderSizePixel=0; Instance.new("UICorner",AmbientBtn).CornerRadius=UDim.new(0,8)
local SkyBox=Instance.new("TextBox",PageWorld); SkyBox.Size=UDim2.new(1,0,0,42); SkyBox.BackgroundColor3=Color3.fromRGB(14,14,14); SkyBox.TextColor3=Color3.new(1,1,1); SkyBox.PlaceholderText="CUSTOM SKY ID"; SkyBox.PlaceholderColor3=Color3.fromRGB(55,55,55); SkyBox.Text=""; SkyBox.Font=Enum.Font.SciFi; SkyBox.TextSize=14; SkyBox.ClearTextOnFocus=false; SkyBox.BorderSizePixel=0; Instance.new("UICorner",SkyBox).CornerRadius=UDim.new(0,8)
local SetSkyBtn=Instance.new("TextButton",PageWorld); SetSkyBtn.Size=UDim2.new(1,0,0,42); SetSkyBtn.BackgroundColor3=Color3.fromRGB(18,18,18); SetSkyBtn.TextColor3=Color3.new(1,1,1); SetSkyBtn.Text="APPLY CUSTOM SKY"; SetSkyBtn.Font=Enum.Font.SciFi; SetSkyBtn.TextSize=14; SetSkyBtn.BorderSizePixel=0; Instance.new("UICorner",SetSkyBtn).CornerRadius=UDim.new(0,8)
local SpaceSkyBtn=Instance.new("TextButton",PageWorld); SpaceSkyBtn.Size=UDim2.new(1,0,0,42); SpaceSkyBtn.BackgroundColor3=Color3.fromRGB(10,10,22); SpaceSkyBtn.TextColor3=Color3.new(1,1,1); SpaceSkyBtn.Text="🌌 SET SPACE SKY"; SpaceSkyBtn.Font=Enum.Font.SciFi; SpaceSkyBtn.TextSize=14; SpaceSkyBtn.BorderSizePixel=0; Instance.new("UICorner",SpaceSkyBtn).CornerRadius=UDim.new(0,8)
local flyRow=Instance.new("Frame",PageWorld); flyRow.Size=UDim2.new(1,0,0,42); flyRow.BackgroundTransparency=1
local btnUp=Instance.new("TextButton",flyRow); btnUp.Size=UDim2.new(0.48,-3,1,0); btnUp.BackgroundColor3=Color3.fromRGB(16,16,16); btnUp.TextColor3=Color3.new(1,1,1); btnUp.Text="▲ FLY UP"; btnUp.Font=Enum.Font.SciFi; btnUp.TextSize=13; btnUp.BorderSizePixel=0; Instance.new("UICorner",btnUp).CornerRadius=UDim.new(0,8)
local btnDn=Instance.new("TextButton",flyRow); btnDn.Size=UDim2.new(0.48,-3,1,0); btnDn.Position=UDim2.new(0.52,3,0,0); btnDn.BackgroundColor3=Color3.fromRGB(16,16,16); btnDn.TextColor3=Color3.new(1,1,1); btnDn.Text="▼ FLY DOWN"; btnDn.Font=Enum.Font.SciFi; btnDn.TextSize=13; btnDn.BorderSizePixel=0; Instance.new("UICorner",btnDn).CornerRadius=UDim.new(0,8)

-- UI TAB
local UnlockBtn=Instance.new("TextButton",PageUI); UnlockBtn.Size=UDim2.new(1,0,0,42); UnlockBtn.BackgroundColor3=Color3.fromRGB(30,10,10); UnlockBtn.TextColor3=Color3.new(1,1,1); UnlockBtn.Text="🔓 UNLOCK MOVING: OFF"; UnlockBtn.Font=Enum.Font.SciFi; UnlockBtn.TextSize=14; UnlockBtn.BorderSizePixel=0; Instance.new("UICorner",UnlockBtn).CornerRadius=UDim.new(0,8)
local SaveBtn=Instance.new("TextButton",PageUI); SaveBtn.Size=UDim2.new(1,0,0,42); SaveBtn.BackgroundColor3=Color3.fromRGB(8,8,24); SaveBtn.TextColor3=Color3.new(1,1,1); SaveBtn.Text="💾 SAVE CONFIG"; SaveBtn.Font=Enum.Font.SciFi; SaveBtn.TextSize=14; SaveBtn.BorderSizePixel=0; Instance.new("UICorner",SaveBtn).CornerRadius=UDim.new(0,8)

-- INFO TAB
local InfoLabel=Instance.new("TextLabel",PageInfo); InfoLabel.Size=UDim2.new(1,0,1,0); InfoLabel.BackgroundTransparency=1; InfoLabel.TextColor3=Color3.new(1,1,1); InfoLabel.TextSize=16; InfoLabel.TextYAlignment=Enum.TextYAlignment.Top; InfoLabel.Text="Загрузка..."

-- Запуск вкладки по умолчанию
SwitchTab("MAIN")

-- [[ 2. LOGIC ]] --
local States = { 
    Watermark = true, Aim = false, Hitbox = false, AntiKnockback = false, UnlockAll = false,
    SpdBypass = false, Fly = false, Spd = false, Jump = false, Circle = false, UsePentagram = false,
    Ghosts = false, Esp = false, RGB = false, Fullbright = false, InfJump = false, AntiAfk = true,
    NoFog = false, AmbientSync = false, AI = false, FriendBot = false, IsFollowing = true, 
    IsRecording = false, IsPlaying = false, LoopPlay = false, KillAura = false
} 
local valSmooth, valHitbox, valFlySpeed, valSpeed, valBypassSpeed, valJumpPower, valRipple, valGhostRate = 0.15, 5, 5, 50, 0.11, 100, 15, 0.05
local up, down = false, false

local function EmergencyBrake()
    local char = Player.Character; if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Velocity = Vector3.new(0,0,0); char.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0) end
end

-- [[ MUSIC FUNCTIONS ]] --
local function PlayMusic(audioId, title)
    if CurrentSound then 
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil 
    end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        Notify("ERROR: NO CHARACTER")
        return
    end
    
    CurrentSound = Instance.new("Sound")
    CurrentSound.Parent = char.HumanoidRootPart
    CurrentSound.SoundId = "rbxassetid://" .. tostring(audioId)
    CurrentSound.Volume = tonumber(VolumeSlider.Text) or 5
    CurrentSound.Looped = true
    CurrentSound.Playing = true
    
    local success = pcall(function()
        CurrentSound:Play()
    end)
    
    if success then
        MusicPlaying = true
        MusicTitle.Text = title or ("ID: " .. tostring(audioId))
        MusicStatus.Text = "♪ PLAYING"
        MusicWidget.Visible = true
        BtnPlayPause.Text = "⏸"
        Notify("MUSIC: " .. (title or tostring(audioId)))
    else
        Notify("ERROR: INVALID AUDIO ID")
        if CurrentSound then
            CurrentSound:Destroy()
            CurrentSound = nil
        end
    end
end

local function StopMusic()
    if CurrentSound then 
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil 
    end
    MusicPlaying = false
    MusicTitle.Text = "NO MUSIC"
    MusicStatus.Text = "⏹ STOPPED"
    BtnPlayPause.Text = "▶"
    Notify("MUSIC STOPPED")
end

local function TogglePlayPause()
    if not CurrentSound then return end
    if MusicPlaying then
        CurrentSound:Pause()
        MusicPlaying = false
        MusicStatus.Text = "⏸ PAUSED"
        BtnPlayPause.Text = "▶"
    else
        CurrentSound:Resume()
        MusicPlaying = true
        MusicStatus.Text = "♪ PLAYING"
        BtnPlayPause.Text = "⏸"
    end
end

local function ExtractYouTubeID(link)
    local patterns = {
        "youtube%.com/watch%?v=([%w-_]+)",
        "youtu%.be/([%w-_]+)",
        "youtube%.com/embed/([%w-_]+)",
        "youtube%.com/v/([%w-_]+)"
    }
    
    for _, pattern in ipairs(patterns) do
        local id = string.match(link, pattern)
        if id then return id end
    end
    
    if string.match(link, "^[%w-_]+$") and #link == 11 then
        return link
    end
    
    return nil
end

local function SearchYouTubeToRoblox(query)
    Notify("SEARCHING: " .. query)
    task.spawn(function()
        if request then
            local success, response = pcall(function()
                return request({
                    Url = "https://www.roblox.com/audio/search?Keyword=" .. HttpService:UrlEncode(query),
                    Method = "GET"
                })
            end)
            
            if success and response and response.Body then
                local audioId = string.match(response.Body, 'data%-item%-id="(%d+)"')
                if audioId then
                    PlayMusic(audioId, query)
                else
                    Notify("NO RESULTS FOUND")
                end
            else
                Notify("SEARCH FAILED")
            end
        else
            Notify("HTTP NOT AVAILABLE")
        end
    end)
end

PlayIDBtn.MouseButton1Click:Connect(function()
    local id = MusicIDBox.Text:gsub("%s+", "")
    if id ~= "" then
        local numericId = id:match("%d+")
        if numericId then
            PlayMusic(numericId, "Custom Audio")
        else
            Notify("INVALID ID FORMAT")
        end
    else
        Notify("ENTER AUDIO ID")
    end
end)

PlayYTBtn.MouseButton1Click:Connect(function()
    local link = YouTubeLinkBox.Text:gsub("%s+", "")
    if link ~= "" then
        local ytId = ExtractYouTubeID(link)
        if ytId then
            Notify("YT ID: " .. ytId)
            SearchYouTubeToRoblox(ytId)
        else
            Notify("INVALID YOUTUBE LINK")
        end
    else
        Notify("ENTER YOUTUBE LINK")
    end
end)

SearchBtn.MouseButton1Click:Connect(function()
    local query = SearchBox.Text:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
    if query ~= "" then
        SearchYouTubeToRoblox(query)
    else
        Notify("ENTER SEARCH QUERY")
    end
end)

StopMusicBtn.MouseButton1Click:Connect(function() 
    StopMusic() 
end)

BtnPlayPause.MouseButton1Click:Connect(function() 
    TogglePlayPause() 
end)

BtnStop.MouseButton1Click:Connect(function() 
    StopMusic() 
end)

BtnSkip.MouseButton1Click:Connect(function()
    if CurrentSound then
        CurrentSound.TimePosition = 0
        Notify("MUSIC RESTARTED")
    end
end)

VolumeSlider.FocusLost:Connect(function()
    local vol = tonumber(VolumeSlider.Text)
    if vol then
        vol = math.clamp(vol, 0, 10)
        VolumeSlider.Text = tostring(vol)
        if CurrentSound then
            CurrentSound.Volume = vol
            Notify("VOLUME: " .. tostring(vol))
        end
    else
        VolumeSlider.Text = "5"
    end
end)

-- [[ FIXED REPLAY MOVEMENT ]] --
local function SmartMove(targetCF)
    local char = Player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    
    local car = nil; if hum.SeatPart then car = hum.SeatPart.Parent end
    if car and car:IsA("Model") then 
        local mainPart = car.PrimaryPart or hum.SeatPart
        mainPart.Velocity = Vector3.new(0,0,0)
        mainPart.CFrame = targetCF 
    else 
        root.CFrame = targetCF
        root.Velocity = Vector3.new(0,0,0)
    end
end

local function SendChat(msg)
    if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
        pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg) end)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

btnUp.MouseButton1Down:Connect(function() up = true end); btnUp.MouseButton1Up:Connect(function() up = false end)
btnDn.MouseButton1Down:Connect(function() down = true end); btnDn.MouseButton1Up:Connect(function() down = false end)

local function makeBind(name, callback)
    local hb = Instance.new("TextButton", ScreenGui); hb.Name="Bind_"..name; hb.Size=UDim2.new(0,50,0,50); hb.Position=UDim2.new(0.85,0,0.4,0); hb.BackgroundColor3=Color3.fromRGB(15,15,15); hb.Text=name:sub(1,3); hb.TextColor3=Color3.new(1,1,1); hb.Visible=false
    hb.Active = UI_Unlocked; hb.Draggable = UI_Unlocked
    style(hb,25); hb.MouseButton1Click:Connect(callback); table.insert(Movable_Objects, hb); return hb
end

local btnTheme = Instance.new("TextButton", PageMain); btnTheme.Size = UDim2.new(1, 0, 0, 40); btnTheme.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btnTheme.Text = "THEME: " .. Themes[CurrentThemeIndex]; btnTheme.TextColor3 = Color3.new(1,1,1); btnTheme.Font = Enum.Font.SciFi; btnTheme.TextSize = 16; style(btnTheme)
btnTheme.MouseButton1Click:Connect(function() CurrentThemeIndex = CurrentThemeIndex + 1; if CurrentThemeIndex > #Themes then CurrentThemeIndex = 1 end; btnTheme.Text = "THEME: " .. Themes[CurrentThemeIndex] end)

ModelBtn.MouseButton1Click:Connect(function()
    CurrentModelIndex = CurrentModelIndex + 1
    if CurrentModelIndex > #GroqModels then CurrentModelIndex = 1 end
    ModelBtn.Text = "MODEL: " .. GroqModels[CurrentModelIndex]
end)

local function addOption(name, key, useInput, defaultInputVal, inputCallback)
    local f = Instance.new("Frame", PageMain); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
    local btnSize = useInput and 0.5 or 0.75
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(btnSize, -5, 1, 0); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(1,1,1); style(b)
    if States[key] then b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
    
    local function Toggle()
        States[key] = not States[key]
        b.BackgroundColor3 = States[key] and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(20, 20, 20)
        Notify(name .. (States[key] and " [ON]" or " [OFF]"))
    end
    
    local hk = makeBind(name, Toggle)
    b.MouseButton1Click:Connect(Toggle)
    
    local bb = Instance.new("TextButton", f); bb.Size = UDim2.new(0.25, 0, 1, 0); bb.Position = UDim2.new(0.75, 0, 0, 0); bb.Text = "BIND"; style(bb)
    bb.MouseButton1Click:Connect(function() hk.Visible = not hk.Visible end)
    
    if useInput then
        local inp = Instance.new("TextBox", f); inp.Size = UDim2.new(0.25, -5, 1, 0); inp.Position = UDim2.new(0.5, 0, 0, 0); inp.Text = tostring(defaultInputVal); inp.BackgroundColor3 = Color3.fromRGB(15,15,15); inp.TextColor3 = Color3.new(1,1,1); style(inp)
        inp.FocusLost:Connect(function() local n = tonumber(inp.Text); if n then inputCallback(n) else inp.Text = tostring(defaultInputVal) end end)
    end
end

-- [ OPTIONS ] --
addOption("SHOW LOGO", "Watermark", false) 
addOption("HUMAN AIM", "Aim", true, valSmooth, function(v) valSmooth = math.clamp(v, 0.01, 1) end)
addOption("ANTI KNOCKBACK", "AntiKnockback", false) 
addOption("INF ZOOM", "UnlockAll", false) 
addOption("SPEED BYPASS", "SpdBypass", true, valBypassSpeed, function(v) valBypassSpeed = v end)
addOption("KILL AURA", "KillAura", false)
addOption("BIG HITBOX", "Hitbox", true, valHitbox, function(v) valHitbox = v end)
addOption("FLY BYPASS", "Fly", true, valFlySpeed, function(v) valFlySpeed = v end)
addOption("RAGE SPEED", "Spd", true, valSpeed, function(v) valSpeed = v end)
addOption("SUPER JUMP", "Jump", true, valJumpPower, function(v) valJumpPower = v end)
addOption("JUMP RIPPLE", "Circle", true, valRipple, function(v) valRipple = v end)
addOption("PENTAGRAM MODE", "UsePentagram", false) 
addOption("GHOST TRAIL", "Ghosts", true, valGhostRate, function(v) valGhostRate = math.clamp(v, 0.01, 2) end) 
addOption("ESP HIGHLIGHT", "Esp", false)
addOption("SKIN COLOR", "RGB", false) 
addOption("FULLBRIGHT", "Fullbright", false) 
addOption("INF JUMP", "InfJump", false)

SideBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ UI EDITOR & SAVE ]] --
UnlockBtn.MouseButton1Click:Connect(function()
    UI_Unlocked = not UI_Unlocked
    UnlockBtn.Text = UI_Unlocked and "UNLOCK MOVING: ON" or "UNLOCK MOVING: OFF"
    UnlockBtn.BackgroundColor3 = UI_Unlocked and Color3.fromRGB(10,50,10) or Color3.fromRGB(30,10,10)
    for _, obj in pairs(Movable_Objects) do obj.Active = UI_Unlocked; obj.Draggable = UI_Unlocked end
end)
local ConfigName = "AngerConfig_V127.json"
SaveBtn.MouseButton1Click:Connect(function()
    local data = {}; for _, obj in pairs(Movable_Objects) do data[obj.Name] = {X_S=obj.Position.X.Scale, X_O=obj.Position.X.Offset, Y_S=obj.Position.Y.Scale, Y_O=obj.Position.Y.Offset} end
    if writefile then writefile(ConfigName, game:GetService("HttpService"):JSONEncode(data)); SaveBtn.Text="SAVED!"; task.wait(1); SaveBtn.Text="SAVE CONFIG" end
end)
task.spawn(function() if isfile and isfile(ConfigName) then local data = game:GetService("HttpService"):JSONDecode(readfile(ConfigName)); for _, obj in pairs(Movable_Objects) do if data[obj.Name] then obj.Position = UDim2.new(data[obj.Name].X_S, data[obj.Name].X_O, data[obj.Name].Y_S, data[obj.Name].Y_O) end end end end)

-- [[ WORLD FUNCTIONS ]] --
FogBtn.MouseButton1Click:Connect(function()
    States.NoFog = not States.NoFog
    FogBtn.Text = States.NoFog and "REMOVE FOG: ON" or "REMOVE FOG: OFF"
    FogBtn.BackgroundColor3 = States.NoFog and Color3.fromRGB(10, 50, 10) or Color3.fromRGB(30, 10, 10)
    if not States.NoFog then Lighting.FogEnd = 1000 end
    Notify("NO FOG" .. (States.NoFog and " [ON]" or " [OFF]"))
end)
AmbientBtn.MouseButton1Click:Connect(function()
    States.AmbientSync = not States.AmbientSync
    AmbientBtn.Text = States.AmbientSync and "AMBIENT SYNC: ON" or "AMBIENT SYNC: OFF"
    AmbientBtn.BackgroundColor3 = States.AmbientSync and Color3.fromRGB(10, 50, 10) or Color3.fromRGB(30, 10, 10)
    Notify("AMBIENT" .. (States.AmbientSync and " [ON]" or " [OFF]"))
end)
local function SetSky(id)
    local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    local tex = "rbxassetid://" .. tostring(id)
    sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = tex, tex, tex, tex, tex, tex
    Notify("CUSTOM SKY: " .. tostring(id))
end
SetSkyBtn.MouseButton1Click:Connect(function() 
    local id = SkyBox.Text:gsub("%s+", ""):match("%d+")
    if id then 
        SetSky(id) 
    else
        Notify("INVALID SKY ID")
    end
end)
SpaceSkyBtn.MouseButton1Click:Connect(function() SetSky("159454299") end) 

-- [[ MACRO LOGIC (FIXED) ]] --
RecBtn.MouseButton1Click:Connect(function()
    States.IsRecording = not States.IsRecording
    if States.IsRecording then 
        States.IsPlaying = false
        RecordedPath = {} 
        RecBtn.Text = "STOP REC"
        RecBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        AIStatus.Text = "STATUS: RECORDING..."
        Notify("RECORDING STARTED") 
    else 
        RecBtn.Text = "RECORD"
        RecBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        AIStatus.Text = "STATUS: SAVED " .. #RecordedPath .. " FRAMES"
        Notify("RECORDING STOPPED") 
    end
end)

local function StartPlayback()
    if #RecordedPath == 0 then AIStatus.Text = "ERROR: NO RECORDING"; States.IsPlaying = false; return end
    
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if root and hum then
        hum.PlatformStand = true
        root.Anchored = true
    end

    task.spawn(function()
        while States.IsPlaying do
            for i, frame in ipairs(RecordedPath) do
                if not States.IsPlaying then break end
                SmartMove(frame.CF)
                RunService.Heartbeat:Wait()
            end
            if not States.LoopPlay then 
                States.IsPlaying = false
                PlayBtn.Text = "PLAY"
                PlayBtn.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
                Notify("PLAYBACK ENDED")
                break 
            end
        end
        if Player.Character then
            local r = Player.Character:FindFirstChild("HumanoidRootPart")
            local h = Player.Character:FindFirstChild("Humanoid")
            if r then r.Anchored = false r.Velocity = Vector3.zero end
            if h then h.PlatformStand = false end
        end
        AIStatus.Text = "STATUS: IDLE"
    end)
end

PlayBtn.MouseButton1Click:Connect(function()
    States.IsPlaying = not States.IsPlaying
    if States.IsPlaying then 
        States.IsRecording = false
        RecBtn.Text = "RECORD"
        RecBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        PlayBtn.Text = "STOP PLAY"
        PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        Notify("PLAYBACK STARTED")
        StartPlayback() 
    else 
        PlayBtn.Text = "PLAY"
        PlayBtn.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
        EmergencyBrake()
        Notify("PLAYBACK STOPPED") 
    end
end)

LoopBtn.MouseButton1Click:Connect(function()
    States.LoopPlay = not States.LoopPlay
    LoopBtn.Text = States.LoopPlay and "LOOP PLAYBACK: ON" or "LOOP PLAYBACK: OFF"
    LoopBtn.BackgroundColor3 = States.LoopPlay and Color3.fromRGB(10, 50, 10) or Color3.fromRGB(30, 30, 30)
    Notify("LOOP" .. (States.LoopPlay and " [ON]" or " [OFF]"))
end)

-- [[ AI LOGIC (GROQ) ]] --
local AI_Debounce = false
AIToggleBtn.MouseButton1Click:Connect(function() 
    States.AI = not States.AI
    AIToggleBtn.Text = States.AI and "AI AUTOREPLY: ON" or "AI AUTOREPLY: OFF"
    AIToggleBtn.BackgroundColor3 = States.AI and Color3.fromRGB(10, 50, 10) or Color3.fromRGB(30, 10, 10)
    Notify("AI CHAT" .. (States.AI and " [ON]" or " [OFF]"))
    if States.AI then SendChat("AngerMOD: Модуль чата активен.") end
end)
FriendBtn.MouseButton1Click:Connect(function() 
    States.FriendBot = not States.FriendBot
    FriendBtn.Text = States.FriendBot and "FRIEND BOT: ON" or "FRIEND BOT: OFF"
    FriendBtn.BackgroundColor3 = States.FriendBot and Color3.fromRGB(10, 50, 10) or Color3.fromRGB(30, 10, 10) 
    Notify("FRIEND BOT" .. (States.FriendBot and " [ON]" or " [OFF]"))
    if States.FriendBot then SendChat("Я теперь твой хвостик!") end
end)

local function ExecuteCommand(msg)
    local m = string.lower(msg); local char = Player.Character; local hum = char and char:FindFirstChild("Humanoid")
    if string.find(m, "сядь") then if hum then hum.Sit = true end; return true
    elseif string.find(m, "встань") then if hum then hum.Sit = false; hum.Jump = true end; return true
    elseif string.find(m, "стой") then States.IsFollowing = false; EmergencyBrake(); return true
    elseif string.find(m, "ко мне") then States.IsFollowing = true; return true end
    return false
end

local function ProcessAI(msg, senderName)
    if AI_Debounce then return end
    if States.FriendBot and ExecuteCommand(msg) then return end 
    if not States.AI then return end
    AI_Debounce = true; AIStatus.Text = "STATUS: THINKING..."
    local apiKey = AIKeyBox.Text; if apiKey == "" then AIStatus.Text = "ERROR: NO KEY"; AI_Debounce = false; return end
    table.insert(ChatHistory, {role = "user", content = senderName .. ": " .. msg})
    if #ChatHistory > 10 then table.remove(ChatHistory, 2) end
    local success, response = pcall(function()
        if request then return request({ 
            Url = "https://api.groq.com/openai/v1/chat/completions", 
            Method = "POST", 
            Headers = {
                ["Content-Type"] = "application/json", 
                ["Authorization"] = "Bearer " .. apiKey
            }, 
            Body = HttpService:JSONEncode({ 
                model = GroqModels[CurrentModelIndex], 
                messages = ChatHistory, 
                max_tokens = 60 
            }) 
        }) end
    end)
    if success and response and response.Body then 
        local data = HttpService:JSONDecode(response.Body)
        if data.choices and data.choices[1] then 
            local reply = data.choices[1].message.content
            SendChat(reply)
            table.insert(ChatHistory, {role = "assistant", content = reply})
            AIStatus.Text = "STATUS: REPLIED" 
        else 
            AIStatus.Text = "ERROR: API FAIL" 
        end
    else 
        AIStatus.Text = "ERROR: REQUEST FAIL" 
    end
    task.wait(2); AI_Debounce = false; task.wait(1); AIStatus.Text = "STATUS: WAITING..."
end
for _, p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(msg) if p ~= Player then ProcessAI(msg, p.Name) end end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg) if p ~= Player then ProcessAI(msg, p.Name) end end) end)

-- [[ VISUALS ]] --
local function SpawnRipple()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = Player.Character.HumanoidRootPart; local ray = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), RaycastParams.new())
    local spawnPos = ray and ray.Position or (root.Position - Vector3.new(0, 2.8, 0)); local p = Instance.new("Part", workspace); p.Name = "AngerRipple"; p.Anchored = true; p.CanCollide = false
    if States.UsePentagram then
        p.Transparency = 1; p.Size = Vector3.new(1, 0.05, 1); p.CFrame = CFrame.new(spawnPos); local sg = Instance.new("SurfaceGui", p); sg.Face = Enum.NormalId.Top; sg.LightInfluence = 0; sg.AlwaysOnTop = false; local img = Instance.new("ImageLabel", sg); img.Size = UDim2.new(1, 0, 1, 0); img.BackgroundTransparency = 1; img.ImageColor3 = Color3.new(1, 1, 1); 
        local s, a = pcall(function() return getcustomasset("Anger_Pentagram_Circle1.png") end)
        if s then img.Image = a else img.Image = "rbxassetid://0" end; 
        table.insert(RGB_Objects, {Type = "Image", Instance = img}); TweenService:Create(p, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(valRipple, 0.05, valRipple)}):Play(); TweenService:Create(img, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play(); Debris:AddItem(p, 1.5)
    else
        p.Shape = Enum.PartType.Cylinder; p.Material = Enum.Material.Neon; p.Size = Vector3.new(0.1, 1, 1); p.CFrame = CFrame.new(spawnPos) * CFrame.Angles(0, 0, math.rad(90)); p.Color = Color3.new(1,1,1); table.insert(RGB_Objects, {Type = "Part", Instance = p}); TweenService:Create(p, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(0.1, valRipple, valRipple), Transparency = 1}):Play(); Debris:AddItem(p, 1)
    end
end

local function GetClosestPlayer()
    local target = nil; local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do 
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then 
            local d = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude
            if d < dist then dist = d; target = v.Character end 
        end 
    end; return target
end

Player.CharacterAdded:Connect(function(char) 
    DeathScreen.Enabled = false
    char:WaitForChild("Humanoid").Died:Connect(function() DeathScreen.Enabled = true end)
end)

-- [[ ESP LINES ]] --
local function CreateESPLine(player)
    if ESPLines[player] then return end
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.new(1, 1, 1)
    line.Thickness = 2
    line.Transparency = 0.8
    ESPLines[player] = line
end

local function UpdateESPLines(activeColor)
    for player, line in pairs(ESPLines) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and States.Esp then
            local char = player.Character
            local rootPart = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(vector.X, vector.Y)
                line.Color = activeColor
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Player then CreateESPLine(player) end
end

Players.PlayerAdded:Connect(function(player)
    CreateESPLine(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPLines[player] then
        ESPLines[player]:Remove()
        ESPLines[player] = nil
    end
end)

-- [[ RENDER LOOP ]] --
local lastGhostTime = 0
RunService.RenderStepped:Connect(function()
    pcall(function() 
        local tickTime = tick()
        local currentThemeName = Themes[CurrentThemeIndex]
        local activeColor = Color3.new(1,1,1)
        if currentThemeName == "RGB" then activeColor = Color3.fromHSV(tickTime % 3 / 3, 1, 1) elseif ThemeColors[currentThemeName] then activeColor = ThemeColors[currentThemeName] end
        
        if States.AmbientSync then Lighting.OutdoorAmbient = activeColor; Lighting.Ambient = activeColor end
        if States.NoFog then Lighting.FogEnd = 1000000; Lighting.FogStart = 1000000 end

        DeathLabel.TextColor3 = activeColor
        for i, obj in pairs(RGB_Objects) do 
            if obj.Instance and obj.Instance.Parent then 
                if obj.Type == "Stroke" then obj.Instance.Color = activeColor elseif obj.Type == "Text" then obj.Instance.TextColor3 = activeColor elseif obj.Type == "Image" then obj.Instance.ImageColor3 = activeColor elseif obj.Type == "Part" then obj.Instance.Color = activeColor end 
            else table.remove(RGB_Objects, i) end 
        end
        
        UpdateESPLines(activeColor)
        
        local wm = ScreenGui.Parent:FindFirstChild("AngerWatermark"); if wm then wm.Enabled = States.Watermark end
        if PageInfo.Visible then InfoLabel.Text = string.format("SESSION:\nUser: %s\nID: %s\nFPS: %d\nPing: %d ms", Player.Name, SessionID, math.floor(workspace:GetRealPhysicsFPS()), math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) end

        local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hum = char:FindFirstChild("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart")

        if States.AntiKnockback then
             if root.Velocity.Magnitude > 25 then
                 if hum.MoveDirection.Magnitude > 0 then
                    root.Velocity = hum.MoveDirection * hum.WalkSpeed
                 else
                    root.Velocity = Vector3.new(0,0,0)
                 end
                 root.RotVelocity = Vector3.new(0,0,0)
             end
        end

        if States.Aim then
            local target = GetClosestPlayer()
            if target and target:FindFirstChild("Head") then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Head.Position), valSmooth)
            end
        end
        
        if States.IsRecording then 
             local pos = root.CFrame
             if hum and hum.SeatPart then pos = hum.SeatPart.CFrame end
             table.insert(RecordedPath, {CF = pos}) 
        end

        if States.UnlockAll then 
            Player.CameraMaxZoomDistance = 100000
            Player.CameraMinZoomDistance = 0 
            if Player.CameraMode ~= Enum.CameraMode.Classic then Player.CameraMode = Enum.CameraMode.Classic end
        end

        if States.SpdBypass and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * valBypassSpeed) end
        if States.Fly and root and hum then root.Velocity = Vector3.new(0, 0.1, 0); if hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * valFlySpeed) end; if up then root.CFrame = root.CFrame * CFrame.new(0, valFlySpeed, 0) end; if down then root.CFrame = root.CFrame * CFrame.new(0, -valFlySpeed, 0) end end
        if States.KillAura then local tool = char:FindFirstChildOfClass("Tool"); if tool and tool:FindFirstChild("Handle") then for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then local dist = (v.Character.Head.Position - root.Position).Magnitude; if dist < 50 then tool.Handle.CFrame = v.Character.Head.CFrame; tool:Activate(); pcall(function() firetouchinterest(tool.Handle, v.Character.Head, 0); firetouchinterest(tool.Handle, v.Character.Head, 1) end); break end end end end end
        if States.Ghosts and tick() - lastGhostTime > valGhostRate then lastGhostTime = tick(); for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") and v.Transparency < 1 then local g = v:Clone(); g.Parent = workspace; g.Anchored = true; g.CanCollide = false; g.CFrame = v.CFrame; g.Color = activeColor; g.Material = Enum.Material.Neon; g:ClearAllChildren(); TweenService:Create(g, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency=1, CFrame=g.CFrame*CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),0), Size=g.Size*1.1}):Play(); Debris:AddItem(g, 0.5) end end end
        if States.Spd and hum.MoveDirection.Magnitude > 0 then root.CFrame += (hum.MoveDirection * (0.5 * valSpeed)) end
        if States.Jump then hum.UseJumpPower = true; hum.JumpPower = valJumpPower else hum.JumpPower = 50 end

        if States.Esp then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character then
                    if not v.Character:FindFirstChild("AngerESP") then
                        local hl = Instance.new("Highlight", v.Character); hl.Name = "AngerESP"; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
                    else
                        v.Character.AngerESP.FillColor = activeColor
                    end
                end
            end
        else
            for _, v in pairs(game.Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("AngerESP") then v.Character.AngerESP:Destroy() end end
        end

        for _, v in pairs(game.Players:GetPlayers()) do 
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then 
                local head = v.Character.Head
                if States.Hitbox then
                    head.Size = Vector3.new(valHitbox, valHitbox, valHitbox)
                    head.Transparency = 0.7
                    head.CanCollide = false
                    head.Color = activeColor
                    head.Material = Enum.Material.Neon
                else
                    head.Size = Vector3.new(1,1,1)
                    head.Transparency = 0
                end
            end 
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if States.InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end; if States.Circle then SpawnRipple() end end)
Player.Idled:Connect(function() if States.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

-- ASSET LOADING
task.spawn(function()
    local urlLogo = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"
    local fileLogo = "AngerMOD_Logo_V127.png"
    if writefile and readfile then pcall(function() if not isfile(fileLogo) then writefile(fileLogo, game:HttpGet(urlLogo)) end end) end
    local lg = Instance.new("ScreenGui", ScreenGui.Parent); lg.Name = "AngerWatermark"; local im = Instance.new("ImageLabel", lg); im.Size = UDim2.new(0, 200, 0, 100); im.Position = UDim2.new(0, 10, 0, 10); im.BackgroundTransparency = 1; im.BorderSizePixel = 0; local stroke = Instance.new("UIStroke", im); stroke.Thickness = 3; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; stroke.Color = Color3.new(1, 0, 0); table.insert(RGB_Objects, {Type = "Stroke", Instance = stroke})
    local s, a = pcall(function() return getcustomasset(fileLogo) end); if s then im.Image = a else im.Image = urlLogo end
end)

task.spawn(function()
    local pentagramUrl = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/circle1.png"
    local pentagramName = "Anger_Pentagram_Circle1.png"
    if writefile and readfile and isfile then pcall(function() if not isfile(pentagramName) then writefile(pentagramName, game:HttpGet(pentagramUrl)) end end) end
end)

Notify("⚔ SAURON V1 — LOADED")
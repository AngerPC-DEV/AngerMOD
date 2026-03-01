-- [[ ⚔ SAURON V1 | by AngerPC-DEV ]] --
-- LOGIN SYSTEM

local _Players   = game:GetService("Players")
local _TweenSvc  = game:GetService("TweenService")
local _LocalPlr  = _Players.LocalPlayer
local _HttpSvc   = game:GetService("HttpService")

-- ════════════════════════════════════
-- LOGIN GUI
-- ════════════════════════════════════
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "SauronLogin"
LoginGui.ResetOnSpawn = false
LoginGui.DisplayOrder = 999
LoginGui.Parent = _LocalPlr:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- Затемнение фона
local Overlay = Instance.new("Frame", LoginGui)
Overlay.Size = UDim2.new(1,0,1,0)
Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
Overlay.BackgroundTransparency = 0.3
Overlay.BorderSizePixel = 0

-- Главная карточка
local Card = Instance.new("Frame", LoginGui)
Card.Size = UDim2.new(0, 360, 0, 320)
Card.Position = UDim2.new(0.5, -180, 0.5, -160)
Card.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Card.BorderSizePixel = 0
local cardCorner = Instance.new("UICorner", Card); cardCorner.CornerRadius = UDim.new(0, 14)
local cardStroke = Instance.new("UIStroke", Card); cardStroke.Thickness = 2; cardStroke.Color = Color3.fromRGB(180, 0, 0)

-- Декоративная полоса сверху
local TopBar = Instance.new("Frame", Card)
TopBar.Size = UDim2.new(1, 0, 0, 4)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

-- Логотип текст
local LogoLabel = Instance.new("TextLabel", Card)
LogoLabel.Size = UDim2.new(1, 0, 0, 60)
LogoLabel.Position = UDim2.new(0, 0, 0, 12)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "⚔ SAURON"
LogoLabel.Font = Enum.Font.SciFi
LogoLabel.TextSize = 36
LogoLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
LogoLabel.TextStrokeTransparency = 0.6
LogoLabel.TextStrokeColor3 = Color3.fromRGB(255, 50, 50)

local SubLabel = Instance.new("TextLabel", Card)
SubLabel.Size = UDim2.new(1, 0, 0, 20)
SubLabel.Position = UDim2.new(0, 0, 0, 68)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "V1  |  by AngerPC-DEV"
SubLabel.Font = Enum.Font.SciFi
SubLabel.TextSize = 13
SubLabel.TextColor3 = Color3.fromRGB(120, 120, 120)

-- Разделитель
local Divider = Instance.new("Frame", Card)
Divider.Size = UDim2.new(0.8, 0, 0, 1)
Divider.Position = UDim2.new(0.1, 0, 0, 97)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Divider.BorderSizePixel = 0

-- Лейбл ключа
local KeyHint = Instance.new("TextLabel", Card)
KeyHint.Size = UDim2.new(0.9, 0, 0, 20)
KeyHint.Position = UDim2.new(0.05, 0, 0, 108)
KeyHint.BackgroundTransparency = 1
KeyHint.Text = "ВВЕДИ КЛЮЧ ДОСТУПА"
KeyHint.Font = Enum.Font.SciFi
KeyHint.TextSize = 12
KeyHint.TextColor3 = Color3.fromRGB(150, 150, 150)

-- Инпут ключа
local KeyBox = Instance.new("TextBox", Card)
KeyBox.Size = UDim2.new(0.9, 0, 0, 44)
KeyBox.Position = UDim2.new(0.05, 0, 0, 132)
KeyBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.PlaceholderText = "SAURON-XXXXXXXX"
KeyBox.PlaceholderColor3 = Color3.fromRGB(80,80,80)
KeyBox.Text = ""
KeyBox.Font = Enum.Font.SciFi
KeyBox.TextSize = 16
KeyBox.ClearTextOnFocus = false
KeyBox.BorderSizePixel = 0
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
local kbStroke = Instance.new("UIStroke", KeyBox); kbStroke.Thickness = 1.5; kbStroke.Color = Color3.fromRGB(60,60,60)

-- Статус
local StatusLabel = Instance.new("TextLabel", Card)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 22)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 182)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "  ожидание ключа..."
StatusLabel.Font = Enum.Font.SciFi
StatusLabel.TextSize = 12
StatusLabel.TextColor3 = Color3.fromRGB(120,120,120)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка входа
local LoginBtn = Instance.new("TextButton", Card)
LoginBtn.Size = UDim2.new(0.9, 0, 0, 44)
LoginBtn.Position = UDim2.new(0.05, 0, 0, 210)
LoginBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
LoginBtn.TextColor3 = Color3.new(1,1,1)
LoginBtn.Text = "▶  ВОЙТИ"
LoginBtn.Font = Enum.Font.SciFi
LoginBtn.TextSize = 16
LoginBtn.BorderSizePixel = 0
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 10)
local btnStroke = Instance.new("UIStroke", LoginBtn); btnStroke.Thickness = 1.5; btnStroke.Color = Color3.fromRGB(255,80,80)

-- Прогресс-бар (скрытый)
local ProgBg = Instance.new("Frame", Card)
ProgBg.Size = UDim2.new(0.9, 0, 0, 6)
ProgBg.Position = UDim2.new(0.05, 0, 0, 264)
ProgBg.BackgroundColor3 = Color3.fromRGB(25,25,25)
ProgBg.BorderSizePixel = 0
ProgBg.Visible = false
Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(0, 3)

local ProgFill = Instance.new("Frame", ProgBg)
ProgFill.Size = UDim2.new(0, 0, 1, 0)
ProgFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ProgFill.BorderSizePixel = 0
Instance.new("UICorner", ProgFill).CornerRadius = UDim.new(0, 3)

-- Версия внизу
local VerLabel = Instance.new("TextLabel", Card)
VerLabel.Size = UDim2.new(1, 0, 0, 20)
VerLabel.Position = UDim2.new(0, 0, 0, 292)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "SAURON V1  |  secured access"
VerLabel.Font = Enum.Font.SciFi
VerLabel.TextSize = 10
VerLabel.TextColor3 = Color3.fromRGB(50,50,50)

-- Анимация пульса логотипа
task.spawn(function()
    while LoginGui.Parent do
        _TweenSvc:Create(cardStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(255,50,50)}):Play()
        task.wait(1)
        _TweenSvc:Create(cardStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(100,0,0)}):Play()
        task.wait(1)
    end
end)

-- ══════════════════════════════
-- КЛЮЧИ — загрузка с GitHub
-- ══════════════════════════════
local ValidKeys = {}

local function LoadKeys()
    local ok, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.sauron")
    end)
    if ok and result and #result > 2 then
        for line in result:gmatch("[^\r\n]+") do
            line = line:match("^%s*(.-)%s*$")
            if line ~= "" then
                -- Поддержка формата "1 | SAURON-KEY" и просто "SAURON-KEY"
                local key = line:match("|%s*(.+)$") or line
                key = key:match("^%s*(.-)%s*$")
                if key and #key > 3 then
                    ValidKeys[key] = true
                end
            end
        end
        StatusLabel.Text = "  ✅ сервер доступен"
        StatusLabel.TextColor3 = Color3.fromRGB(0,200,80)
        return true
    else
        -- Оффлайн-фолбек: принимаем любой ключ начинающийся с SAURON-
        StatusLabel.Text = "  ⚠ сервер недоступен (оффлайн режим)"
        StatusLabel.TextColor3 = Color3.fromRGB(255,180,0)
        return false
    end
end

local KeysLoaded = false
task.spawn(function()
    KeysLoaded = LoadKeys()
end)

-- ══════════════════════════════
-- ЛОГИКА ВХОДА
-- ══════════════════════════════
local function TryLogin()
    local inputKey = KeyBox.Text:match("^%s*(.-)%s*$")
    if inputKey == "" then
        StatusLabel.Text = "  ❌ введи ключ!"
        StatusLabel.TextColor3 = Color3.fromRGB(255,60,60)
        _TweenSvc:Create(KeyBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50,10,10)}):Play()
        task.wait(0.5)
        _TweenSvc:Create(KeyBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15,15,15)}):Play()
        return
    end

    -- Кнопку заблокировать
    LoginBtn.Active = false
    LoginBtn.Text = "⏳  ПРОВЕРКА..."
    StatusLabel.Text = "  🔍 проверяем ключ..."
    StatusLabel.TextColor3 = Color3.fromRGB(200,180,0)

    -- Анимация прогресс-бара
    ProgBg.Visible = true
    _TweenSvc:Create(ProgFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()

    task.wait(1.2)

    -- Проверка ключа
    local isValid = false
    if ValidKeys[inputKey] then
        isValid = true
    elseif not KeysLoaded then
        -- Оффлайн: принимаем SAURON-* формат
        if inputKey:sub(1,7) == "SAURON-" and #inputKey >= 10 then
            isValid = true
        end
    end

    if isValid then
        -- Анимация успеха
        StatusLabel.Text = "  ✅ доступ разрешён!"
        StatusLabel.TextColor3 = Color3.fromRGB(0,255,80)
        LoginBtn.Text = "✅  ДОБРО ПОЖАЛОВАТЬ"
        LoginBtn.BackgroundColor3 = Color3.fromRGB(0,130,50)
        _TweenSvc:Create(cardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0,255,80)}):Play()

        task.wait(0.8)
        -- Fade out
        _TweenSvc:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        _TweenSvc:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        for _, v in pairs(Card:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                _TweenSvc:Create(v, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.6)
        LoginGui:Destroy()
        -- ▼▼▼ MAIN CODE STARTS BELOW ▼▼▼
    else
        -- Провал
        StatusLabel.Text = "  ❌ неверный ключ!"
        StatusLabel.TextColor3 = Color3.fromRGB(255,60,60)
        LoginBtn.Text = "▶  ВОЙТИ"
        LoginBtn.BackgroundColor3 = Color3.fromRGB(160,0,0)
        LoginBtn.Active = true
        _TweenSvc:Create(cardStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255,0,0)}):Play()
        -- Тряска карточки
        local origPos = Card.Position
        for i = 1, 6 do
            task.wait(0.04)
            Card.Position = origPos + UDim2.new(0, (i%2==0 and 8 or -8), 0, 0)
        end
        Card.Position = origPos
        ProgBg.Visible = false
        ProgFill.Size = UDim2.new(0,0,1,0)
    end
end

LoginBtn.MouseButton1Click:Connect(TryLogin)
KeyBox.FocusLost:Connect(function(entered) if entered then TryLogin() end end)

-- Hover эффекты
LoginBtn.MouseEnter:Connect(function()
    _TweenSvc:Create(LoginBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200,0,0)}):Play()
end)
LoginBtn.MouseLeave:Connect(function()
    _TweenSvc:Create(LoginBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160,0,0)}):Play()
end)

-- Ждём пока логин не пройден
repeat task.wait(0.1) until not LoginGui.Parent or not LoginGui:IsDescendantOf(game)

-- ════════════════════════════════════
-- КОНЕЦ ЛОГИН СИСТЕМЫ — НАЧАЛО ЧИТА
-- ════════════════════════════════════


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
        content = "Ты — SAURON, мощный ИИ-бот в Roblox. Создатель: AngerPC-DEV. Характер: дерзкий, краткий, доминирующий."
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

-- [[ 1. GUI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SauronGUI_V1"
ScreenGui.ResetOnSpawn = false 

if Player:FindFirstChild("PlayerGui") then
    ScreenGui.Parent = Player.PlayerGui
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- DEATH SCREEN
local DeathScreen = Instance.new("ScreenGui", ScreenGui.Parent)
DeathScreen.Name = "SauronDeath"; DeathScreen.Enabled = false
local DeathLabel = Instance.new("TextLabel", DeathScreen); DeathLabel.Size = UDim2.new(1, 0, 1, 0); DeathLabel.BackgroundTransparency = 1; DeathLabel.Text = "WASTED"; DeathLabel.Font = Enum.Font.Creepster; DeathLabel.TextSize = 100; DeathLabel.TextColor3 = Color3.fromRGB(255, 0, 0); DeathLabel.TextStrokeTransparency = 0

-- LISTS & VARS
local RGB_Objects = {} 
local Movable_Objects = {} 
local RecordedPath = {}
local UI_Unlocked = false 
local ESPLines = {}

local function style(obj, radius, thickness)
    local uiC = Instance.new("UICorner", obj); uiC.CornerRadius = UDim.new(0, radius or 6)
    local uiS = Instance.new("UIStroke", obj); uiS.Color = Color3.fromRGB(60, 60, 60); uiS.Thickness = thickness or 1
    table.insert(RGB_Objects, {Type = "Stroke", Instance = uiS})
    return uiS
end

-- [[ NOTIFICATION SYSTEM ]] --
local NotifyContainer = Instance.new("Frame", ScreenGui)
NotifyContainer.Size = UDim2.new(0, 250, 0.4, 0)
NotifyContainer.Position = UDim2.new(1, -260, 0.55, 0)
NotifyContainer.BackgroundTransparency = 1
local NotifyLayout = Instance.new("UIListLayout", NotifyContainer)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 5)

local function Notify(text)
    local f = Instance.new("Frame", NotifyContainer)
    f.Size = UDim2.new(1, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    f.BackgroundTransparency = 0.2
    style(f, 4, 1)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.new(0, 5, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = Enum.Font.SciFi
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    f.BackgroundTransparency = 1
    l.TextTransparency = 1
    TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(l, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(3, function()
        TweenService:Create(f, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(l, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        f:Destroy()
    end)
end

-- // MUSIC WIDGET // --
local MusicWidget = Instance.new("Frame", ScreenGui)
MusicWidget.Size = UDim2.new(0, 200, 0, 120)
MusicWidget.Position = UDim2.new(1, -210, 1, -130)
MusicWidget.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MusicWidget.Visible = false
MusicWidget.Active = true
MusicWidget.Draggable = true
style(MusicWidget, 8, 2)
table.insert(Movable_Objects, MusicWidget)

local MusicIcon = Instance.new("ImageLabel", MusicWidget)
MusicIcon.Size = UDim2.new(0, 50, 0, 50)
MusicIcon.Position = UDim2.new(0, 10, 0, 10)
MusicIcon.BackgroundTransparency = 1
MusicIcon.Image = "rbxassetid://6031265976"
table.insert(RGB_Objects, {Type = "Image", Instance = MusicIcon})

local MusicTitle = Instance.new("TextLabel", MusicWidget)
MusicTitle.Size = UDim2.new(1, -70, 0, 25)
MusicTitle.Position = UDim2.new(0, 65, 0, 10)
MusicTitle.BackgroundTransparency = 1
MusicTitle.Text = "NO MUSIC"
MusicTitle.TextColor3 = Color3.new(1, 1, 1)
MusicTitle.Font = Enum.Font.SciFi
MusicTitle.TextSize = 14
MusicTitle.TextXAlignment = Enum.TextXAlignment.Left
MusicTitle.TextScaled = true

local MusicStatus = Instance.new("TextLabel", MusicWidget)
MusicStatus.Size = UDim2.new(1, -70, 0, 20)
MusicStatus.Position = UDim2.new(0, 65, 0, 35)
MusicStatus.BackgroundTransparency = 1
MusicStatus.Text = "IDLE"
MusicStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
MusicStatus.Font = Enum.Font.SciFi
MusicStatus.TextSize = 12
MusicStatus.TextXAlignment = Enum.TextXAlignment.Left

local BtnPlayPause = Instance.new("TextButton", MusicWidget)
BtnPlayPause.Size = UDim2.new(0.3, -5, 0, 30)
BtnPlayPause.Position = UDim2.new(0, 10, 1, -40)
BtnPlayPause.Text = "PLAY"
BtnPlayPause.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
BtnPlayPause.TextColor3 = Color3.new(1, 1, 1)
BtnPlayPause.Font = Enum.Font.SciFi
BtnPlayPause.TextSize = 12
style(BtnPlayPause)

local BtnStop = Instance.new("TextButton", MusicWidget)
BtnStop.Size = UDim2.new(0.3, -5, 0, 30)
BtnStop.Position = UDim2.new(0.35, 0, 1, -40)
BtnStop.Text = "STOP"
BtnStop.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
BtnStop.TextColor3 = Color3.new(1, 1, 1)
BtnStop.Font = Enum.Font.SciFi
BtnStop.TextSize = 12
style(BtnStop)

local BtnSkip = Instance.new("TextButton", MusicWidget)
BtnSkip.Size = UDim2.new(0.3, -5, 0, 30)
BtnSkip.Position = UDim2.new(0.7, 0, 1, -40)
BtnSkip.Text = "SKIP"
BtnSkip.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
BtnSkip.TextColor3 = Color3.new(1, 1, 1)
BtnSkip.Font = Enum.Font.SciFi
BtnSkip.TextSize = 12
style(BtnSkip)

-- // MAIN MENU // --
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 480, 0, 550); Main.Position = UDim2.new(0.1, 0, 0.2, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = true; Main.Active = true; Main.Draggable = true; style(Main, 8, 2); table.insert(Movable_Objects, Main)

-- TABS
local TabFrame = Instance.new("Frame", Main); TabFrame.Size = UDim2.new(1, -20, 0, 30); TabFrame.Position = UDim2.new(0, 10, 0, 50); TabFrame.BackgroundTransparency = 1
local layoutTabs = Instance.new("UIListLayout", TabFrame); layoutTabs.FillDirection=Enum.FillDirection.Horizontal; layoutTabs.Padding=UDim.new(0,5)

local function MakeTab(text)
    local b = Instance.new("TextButton", TabFrame); b.Size=UDim2.new(0.16,0,1,0); b.BackgroundColor3=Color3.fromRGB(20,20,20); b.Text=text; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.SciFi; style(b); b.TextScaled = true
    return b
end
local btnTabMain = MakeTab("MAIN"); local btnTabInfo = MakeTab("INFO"); local btnTabAI = MakeTab("AI"); local btnTabWorld = MakeTab("WORLD"); local btnTabUI = MakeTab("UI"); local btnTabMusic = MakeTab("MUSIC")

-- TITLE
local Title = Instance.new("TextLabel", Main); Title.Size=UDim2.new(1,0,0,45); Title.BackgroundTransparency=1; Title.Text="⚔ SAURON V1 ⚔"; Title.Font=Enum.Font.SciFi; Title.TextSize=24; Title.TextColor3=Color3.new(1,1,1); table.insert(RGB_Objects, {Type="Text", Instance=Title})

-- // PAGES // --
local PageMain = Instance.new("ScrollingFrame", Main); PageMain.Size=UDim2.new(1,-20,0.78,0); PageMain.Position=UDim2.new(0,10,0.18,0); PageMain.BackgroundTransparency=1; PageMain.ScrollBarThickness=2; PageMain.Visible=true; Instance.new("UIListLayout", PageMain).Padding=UDim.new(0,8)
local PageInfo = Instance.new("Frame", Main); PageInfo.Size=UDim2.new(1,-20,0.78,0); PageInfo.Position=UDim2.new(0,10,0.18,0); PageInfo.BackgroundTransparency=1; PageInfo.Visible=false
local PageAI = Instance.new("Frame", Main); PageAI.Size=UDim2.new(1,-20,0.78,0); PageAI.Position=UDim2.new(0,10,0.18,0); PageAI.BackgroundTransparency=1; PageAI.Visible=false
local PageWorld = Instance.new("Frame", Main); PageWorld.Size=UDim2.new(1,-20,0.78,0); PageWorld.Position=UDim2.new(0,10,0.18,0); PageWorld.BackgroundTransparency=1; PageWorld.Visible=false
local PageUI = Instance.new("Frame", Main); PageUI.Size=UDim2.new(1,-20,0.78,0); PageUI.Position=UDim2.new(0,10,0.18,0); PageUI.BackgroundTransparency=1; PageUI.Visible=false
local PageMusic = Instance.new("ScrollingFrame", Main); PageMusic.Size=UDim2.new(1,-20,0.78,0); PageMusic.Position=UDim2.new(0,10,0.18,0); PageMusic.BackgroundTransparency=1; PageMusic.ScrollBarThickness=2; PageMusic.Visible=false; Instance.new("UIListLayout", PageMusic).Padding=UDim.new(0,8)

btnTabMain.MouseButton1Click:Connect(function() PageMain.Visible=true; PageInfo.Visible=false; PageAI.Visible=false; PageWorld.Visible=false; PageUI.Visible=false; PageMusic.Visible=false end)
btnTabInfo.MouseButton1Click:Connect(function() PageMain.Visible=false; PageInfo.Visible=true; PageAI.Visible=false; PageWorld.Visible=false; PageUI.Visible=false; PageMusic.Visible=false end)
btnTabAI.MouseButton1Click:Connect(function() PageMain.Visible=false; PageInfo.Visible=false; PageAI.Visible=true; PageWorld.Visible=false; PageUI.Visible=false; PageMusic.Visible=false end)
btnTabWorld.MouseButton1Click:Connect(function() PageMain.Visible=false; PageInfo.Visible=false; PageAI.Visible=false; PageWorld.Visible=true; PageUI.Visible=false; PageMusic.Visible=false end)
btnTabUI.MouseButton1Click:Connect(function() PageMain.Visible=false; PageInfo.Visible=false; PageAI.Visible=false; PageWorld.Visible=false; PageUI.Visible=true; PageMusic.Visible=false end)
btnTabMusic.MouseButton1Click:Connect(function() PageMain.Visible=false; PageInfo.Visible=false; PageAI.Visible=false; PageWorld.Visible=false; PageUI.Visible=false; PageMusic.Visible=true end)

-- INFO PAGE
local InfoLabel = Instance.new("TextLabel", PageInfo); InfoLabel.Size = UDim2.new(1,0,1,0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = Color3.new(1,1,1); InfoLabel.TextSize = 18; InfoLabel.TextYAlignment = Enum.TextYAlignment.Top; InfoLabel.Text = "Loading stats..."

-- // WORLD PAGE // --
local FogBtn = Instance.new("TextButton", PageWorld); FogBtn.Size = UDim2.new(1, 0, 0, 40); FogBtn.Position=UDim2.new(0,0,0,0); FogBtn.Text = "REMOVE FOG: OFF"; FogBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); FogBtn.TextColor3 = Color3.new(1, 1, 1); style(FogBtn)
local AmbientBtn = Instance.new("TextButton", PageWorld); AmbientBtn.Size = UDim2.new(1, 0, 0, 40); AmbientBtn.Position=UDim2.new(0,0,0.1,0); AmbientBtn.Text = "AMBIENT SYNC: OFF"; AmbientBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); AmbientBtn.TextColor3 = Color3.new(1, 1, 1); style(AmbientBtn)
local SkyBox = Instance.new("TextBox", PageWorld); SkyBox.Size = UDim2.new(1, 0, 0, 40); SkyBox.Position=UDim2.new(0,0,0.25,0); SkyBox.PlaceholderText = "CUSTOM SKY ID"; SkyBox.Text = ""; SkyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SkyBox.TextColor3 = Color3.new(1, 1, 1); style(SkyBox)
local SetSkyBtn = Instance.new("TextButton", PageWorld); SetSkyBtn.Size = UDim2.new(1, 0, 0, 40); SetSkyBtn.Position=UDim2.new(0,0,0.35,0); SetSkyBtn.Text = "APPLY CUSTOM SKY"; SetSkyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SetSkyBtn.TextColor3 = Color3.new(1, 1, 1); style(SetSkyBtn)
local SpaceSkyBtn = Instance.new("TextButton", PageWorld); SpaceSkyBtn.Size = UDim2.new(1, 0, 0, 40); SpaceSkyBtn.Position=UDim2.new(0,0,0.45,0); SpaceSkyBtn.Text = "SET SPACE SKY"; SpaceSkyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40); SpaceSkyBtn.TextColor3 = Color3.new(1, 1, 1); style(SpaceSkyBtn)

-- // AI PAGE // --
local AIKeyBox = Instance.new("TextBox", PageAI); AIKeyBox.Size = UDim2.new(1, 0, 0, 40); AIKeyBox.Position = UDim2.new(0,0,0,0); AIKeyBox.PlaceholderText = "GROQ API KEY"; AIKeyBox.Text = ""; AIKeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); AIKeyBox.TextColor3 = Color3.new(1, 1, 1); style(AIKeyBox)

local ModelBtn = Instance.new("TextButton", PageAI); ModelBtn.Size = UDim2.new(1, 0, 0, 40); ModelBtn.Position = UDim2.new(0, 0, 0.09, 0); ModelBtn.Text = "MODEL: " .. GroqModels[CurrentModelIndex]; ModelBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); ModelBtn.TextColor3 = Color3.new(1, 1, 1); ModelBtn.Font = Enum.Font.SciFi; ModelBtn.TextSize = 14; style(ModelBtn)

local AIToggleBtn = Instance.new("TextButton", PageAI); AIToggleBtn.Size = UDim2.new(1, 0, 0, 40); AIToggleBtn.Position = UDim2.new(0, 0, 0.19, 0); AIToggleBtn.Text = "AI AUTOREPLY: OFF"; AIToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); AIToggleBtn.TextColor3 = Color3.new(1, 1, 1); style(AIToggleBtn)
local FriendBtn = Instance.new("TextButton", PageAI); FriendBtn.Size = UDim2.new(1, 0, 0, 40); FriendBtn.Position = UDim2.new(0, 0, 0.29, 0); FriendBtn.Text = "FRIEND BOT: OFF"; FriendBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10); FriendBtn.TextColor3 = Color3.new(1, 1, 1); style(FriendBtn)
local RecBtn = Instance.new("TextButton", PageAI); RecBtn.Size = UDim2.new(0.48, 0, 0, 40); RecBtn.Position = UDim2.new(0, 0, 0.49, 0); RecBtn.Text = "RECORD"; RecBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10); RecBtn.TextColor3 = Color3.new(1, 1, 1); style(RecBtn)
local PlayBtn = Instance.new("TextButton", PageAI); PlayBtn.Size = UDim2.new(0.48, 0, 0, 40); PlayBtn.Position = UDim2.new(0.52, 0, 0.49, 0); PlayBtn.Text = "PLAY"; PlayBtn.BackgroundColor3 = Color3.fromRGB(10, 40, 10); PlayBtn.TextColor3 = Color3.new(1, 1, 1); style(PlayBtn)
local LoopBtn = Instance.new("TextButton", PageAI); LoopBtn.Size = UDim2.new(1, 0, 0, 40); LoopBtn.Position = UDim2.new(0, 0, 0.59, 0); LoopBtn.Text = "LOOP PLAYBACK: OFF"; LoopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); LoopBtn.TextColor3 = Color3.new(1, 1, 1); style(LoopBtn)
local AIStatus = Instance.new("TextLabel", PageAI); AIStatus.Size = UDim2.new(1, 0, 0, 30); AIStatus.Position = UDim2.new(0, 0, 0.71, 0); AIStatus.BackgroundTransparency = 1; AIStatus.Text = "STATUS: IDLE"; AIStatus.TextColor3 = Color3.fromRGB(150, 150, 150); style(AIStatus, 0, 0)

-- // UI PAGE // --
local UnlockBtn = Instance.new("TextButton", PageUI); UnlockBtn.Size = UDim2.new(1, 0, 0, 40); UnlockBtn.Position = UDim2.new(0,0,0,0); UnlockBtn.Text = "UNLOCK MOVING: OFF"; UnlockBtn.BackgroundColor3 = Color3.fromRGB(30,10,10); UnlockBtn.TextColor3 = Color3.new(1,1,1); style(UnlockBtn)
local SaveBtn = Instance.new("TextButton", PageUI); SaveBtn.Size = UDim2.new(1, 0, 0, 40); SaveBtn.Position = UDim2.new(0,0,0.12,0); SaveBtn.Text = "SAVE CONFIG"; SaveBtn.BackgroundColor3 = Color3.fromRGB(20,20,40); SaveBtn.TextColor3 = Color3.new(1,1,1); style(SaveBtn)

-- // MUSIC PAGE // --
local MusicIDBox = Instance.new("TextBox", PageMusic); MusicIDBox.Size = UDim2.new(1, 0, 0, 40); MusicIDBox.PlaceholderText = "ROBLOX AUDIO ID"; MusicIDBox.Text = ""; MusicIDBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MusicIDBox.TextColor3 = Color3.new(1, 1, 1); MusicIDBox.Font = Enum.Font.SciFi; MusicIDBox.TextSize = 16; style(MusicIDBox)

local PlayIDBtn = Instance.new("TextButton", PageMusic); PlayIDBtn.Size = UDim2.new(1, 0, 0, 40); PlayIDBtn.Text = "▶ PLAY BY ID"; PlayIDBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20); PlayIDBtn.TextColor3 = Color3.new(1, 1, 1); PlayIDBtn.Font = Enum.Font.SciFi; PlayIDBtn.TextSize = 16; style(PlayIDBtn)

local YouTubeLinkBox = Instance.new("TextBox", PageMusic); YouTubeLinkBox.Size = UDim2.new(1, 0, 0, 40); YouTubeLinkBox.PlaceholderText = "YOUTUBE LINK OR VIDEO ID"; YouTubeLinkBox.Text = ""; YouTubeLinkBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); YouTubeLinkBox.TextColor3 = Color3.new(1, 1, 1); YouTubeLinkBox.Font = Enum.Font.SciFi; YouTubeLinkBox.TextSize = 16; style(YouTubeLinkBox)

local PlayYTBtn = Instance.new("TextButton", PageMusic); PlayYTBtn.Size = UDim2.new(1, 0, 0, 40); PlayYTBtn.Text = "🎵 PLAY FROM YOUTUBE"; PlayYTBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20); PlayYTBtn.TextColor3 = Color3.new(1, 1, 1); PlayYTBtn.Font = Enum.Font.SciFi; PlayYTBtn.TextSize = 16; style(PlayYTBtn)

local SearchBox = Instance.new("TextBox", PageMusic); SearchBox.Size = UDim2.new(1, 0, 0, 40); SearchBox.PlaceholderText = "SEARCH MUSIC NAME"; SearchBox.Text = ""; SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SearchBox.TextColor3 = Color3.new(1, 1, 1); SearchBox.Font = Enum.Font.SciFi; SearchBox.TextSize = 16; style(SearchBox)

local SearchBtn = Instance.new("TextButton", PageMusic); SearchBtn.Size = UDim2.new(1, 0, 0, 40); SearchBtn.Text = "🔍 SEARCH MUSIC"; SearchBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40); SearchBtn.TextColor3 = Color3.new(1, 1, 1); SearchBtn.Font = Enum.Font.SciFi; SearchBtn.TextSize = 16; style(SearchBtn)

local StopMusicBtn = Instance.new("TextButton", PageMusic); StopMusicBtn.Size = UDim2.new(1, 0, 0, 40); StopMusicBtn.Text = "⏹ STOP MUSIC"; StopMusicBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10); StopMusicBtn.TextColor3 = Color3.new(1, 1, 1); StopMusicBtn.Font = Enum.Font.SciFi; StopMusicBtn.TextSize = 16; style(StopMusicBtn)

local VolumeSlider = Instance.new("TextBox", PageMusic); VolumeSlider.Size = UDim2.new(1, 0, 0, 40); VolumeSlider.PlaceholderText = "VOLUME (0-10)"; VolumeSlider.Text = "5"; VolumeSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 20); VolumeSlider.TextColor3 = Color3.new(1, 1, 1); VolumeSlider.Font = Enum.Font.SciFi; VolumeSlider.TextSize = 16; style(VolumeSlider)

-- FLY BUTTONS
local btnUp = Instance.new("TextButton", PageWorld); btnUp.Size = UDim2.new(0.45, 0, 0, 40); btnUp.Position = UDim2.new(0, 0, 0.6, 0); btnUp.Text = "FLY UP"; btnUp.BackgroundColor3 = Color3.fromRGB(20,20,20); btnUp.TextColor3 = Color3.new(1,1,1); style(btnUp)
local btnDn = Instance.new("TextButton", PageWorld); btnDn.Size = UDim2.new(0.45, 0, 0, 40); btnDn.Position = UDim2.new(0.5, 0, 0.6, 0); btnDn.Text = "FLY DOWN"; btnDn.BackgroundColor3 = Color3.fromRGB(20,20,20); btnDn.TextColor3 = Color3.new(1,1,1); style(btnDn)

local SideBtn = Instance.new("TextButton", ScreenGui); SideBtn.Name = "ToggleMenu"; SideBtn.Size = UDim2.new(0, 50, 0, 50); SideBtn.Position = UDim2.new(0, 10, 0.5, 0); SideBtn.Text = "O/C"; SideBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); SideBtn.TextColor3 = Color3.new(1,1,1); style(SideBtn, 16); table.insert(Movable_Objects, SideBtn)

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
local ConfigName = "SauronConfig_V1.json"
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
    local spawnPos = ray and ray.Position or (root.Position - Vector3.new(0, 2.8, 0)); local p = Instance.new("Part", workspace); p.Name = "SauronRipple"; p.Anchored = true; p.CanCollide = false
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
        
        local wm = ScreenGui.Parent:FindFirstChild("SauronWatermark"); if wm then wm.Enabled = States.Watermark end
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
                    if not v.Character:FindFirstChild("SauronESP") then
                        local hl = Instance.new("Highlight", v.Character); hl.Name = "SauronESP"; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
                    else
                        v.Character.SauronESP.FillColor = activeColor
                    end
                end
            end
        else
            for _, v in pairs(game.Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("SauronESP") then v.Character.SauronESP:Destroy() end end
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
    -- AngerMOD.png = твой логотип SAURON (лежит рядом со скриптом)
    local fileLogo  = "AngerMOD.png"
    local urlLogoGH = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"

    -- Скачиваем файл если его нет локально
    if writefile and isfile then
        pcall(function()
            if not isfile(fileLogo) then
                local data = game:HttpGet(urlLogoGH, true)
                writefile(fileLogo, data)
            end
        end)
    end

    -- Создаём Watermark GUI
    local lg = Instance.new("ScreenGui", ScreenGui.Parent)
    lg.Name = "SauronWatermark"
    lg.ResetOnSpawn = false
    lg.DisplayOrder = 10

    -- ImageLabel для логотипа
    local im = Instance.new("ImageLabel", lg)
    im.Size = UDim2.new(0, 280, 0, 70)   -- пропорции SAURON лого ~4:1
    im.Position = UDim2.new(0, 10, 0, 10)
    im.BackgroundTransparency = 1
    im.BorderSizePixel = 0
    im.ScaleType = Enum.ScaleType.Fit
    im.ImageTransparency = 0

    -- Попытка 1: getcustomasset (локальный файл через эксплойт)
    local loaded = false
    if getcustomasset then
        local ok, asset = pcall(function() return getcustomasset(fileLogo) end)
        if ok and asset and asset ~= "" then
            im.Image = asset
            loaded = true
        end
    end

    -- Попытка 2: прямой raw URL как fallback
    if not loaded then
        im.Image = urlLogoGH
    end
end)

task.spawn(function()
    local pentagramUrl = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/circle1.png"
    local pentagramName = "Anger_Pentagram_Circle1.png"
    if writefile and readfile and isfile then pcall(function() if not isfile(pentagramName) then writefile(pentagramName, game:HttpGet(pentagramUrl)) end end) end
end)





-- ════════════════════════════════════════════════════════
-- [[ ⚔ SAURON ESP SYSTEM — BOX + TILES UI ]]
-- ════════════════════════════════════════════════════════

local ESPData    = {}
local ESPEnabled = true
local RADAR_ESP  = true

-- ESP состояния — начальные значения
local ESP_States = {
    BOX      = true,
    NAME     = true,
    HEALTH   = true,
    DISTANCE = true,
    SKELETON = false,
    TRACER   = false,
    CHAMS    = false,   -- уже есть States.Esp но отдельно для compat
}

-- ── TILES PANEL (плитки для включения ESP) ──────────────
local ESPPanel = Instance.new("Frame", ScreenGui)
ESPPanel.Name = "SauronESPPanel"
ESPPanel.Size = UDim2.new(0, 352, 0, 130)
ESPPanel.Position = UDim2.new(0.5, -176, 0, 10)
ESPPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
ESPPanel.BackgroundTransparency = 0.15
ESPPanel.Visible = false
ESPPanel.Active = true
ESPPanel.Draggable = true
style(ESPPanel, 10, 2)
table.insert(Movable_Objects, ESPPanel)

-- Заголовок панели
local EPTitle = Instance.new("TextLabel", ESPPanel)
EPTitle.Size = UDim2.new(1, -70, 0, 22)
EPTitle.Position = UDim2.new(0, 10, 0, 5)
EPTitle.BackgroundTransparency = 1
EPTitle.Text = "⚔  SAURON ESP"
EPTitle.Font = Enum.Font.SciFi
EPTitle.TextSize = 14
EPTitle.TextColor3 = Color3.new(1,1,1)
EPTitle.TextXAlignment = Enum.TextXAlignment.Left
table.insert(RGB_Objects, {Type = "Text", Instance = EPTitle})

-- Кнопка закрытия
local EPClose = Instance.new("TextButton", ESPPanel)
EPClose.Size = UDim2.new(0, 22, 0, 22)
EPClose.Position = UDim2.new(1, -28, 0, 5)
EPClose.BackgroundColor3 = Color3.fromRGB(140,0,0)
EPClose.Text = "✕"
EPClose.TextColor3 = Color3.new(1,1,1)
EPClose.Font = Enum.Font.SciFi
EPClose.TextSize = 12
EPClose.BorderSizePixel = 0
Instance.new("UICorner", EPClose).CornerRadius = UDim.new(0,6)
EPClose.MouseButton1Click:Connect(function() ESPPanel.Visible = false end)

-- Разделитель
local EPDiv = Instance.new("Frame", ESPPanel)
EPDiv.Size = UDim2.new(0.92, 0, 0, 1)
EPDiv.Position = UDim2.new(0.04, 0, 0, 30)
EPDiv.BackgroundColor3 = Color3.fromRGB(50,50,50)
EPDiv.BorderSizePixel = 0

-- Контейнер для плиток
local TilesContainer = Instance.new("Frame", ESPPanel)
TilesContainer.Size = UDim2.new(1, -16, 0, 82)
TilesContainer.Position = UDim2.new(0, 8, 0, 38)
TilesContainer.BackgroundTransparency = 1
local tilesLayout = Instance.new("UIListLayout", TilesContainer)
tilesLayout.FillDirection = Enum.FillDirection.Horizontal
tilesLayout.Padding = UDim.new(0, 6)
tilesLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Данные плиток
local TilesDef = {
    {key = "BOX",      icon = "📦", label = "BOX"},
    {key = "NAME",     icon = "👤", label = "NAME"},
    {key = "HEALTH",   icon = "❤",  label = "HP"},
    {key = "DISTANCE", icon = "📏", label = "DIST"},
    {key = "SKELETON", icon = "💀", label = "SKEL"},
    {key = "TRACER",   icon = "➡",  label = "TRACE"},
    {key = "CHAMS",    icon = "🎨", label = "CHAMS"},
}

local TileButtons = {}

local function CreateTile(def)
    local tile = Instance.new("TextButton", TilesContainer)
    tile.Size = UDim2.new(0, 44, 0, 72)
    tile.BackgroundColor3 = ESP_States[def.key]
        and Color3.fromRGB(15, 45, 15)
        or  Color3.fromRGB(25, 15, 15)
    tile.TextColor3 = Color3.new(1,1,1)
    tile.Font = Enum.Font.SciFi
    tile.Text = ""
    tile.BorderSizePixel = 0
    local tc = Instance.new("UICorner", tile); tc.CornerRadius = UDim.new(0,8)
    local ts = Instance.new("UIStroke", tile); ts.Thickness = 1.5
    ts.Color = ESP_States[def.key] and Color3.fromRGB(0,200,60) or Color3.fromRGB(80,20,20)

    -- Иконка
    local iconLbl = Instance.new("TextLabel", tile)
    iconLbl.Size = UDim2.new(1,0,0,30)
    iconLbl.Position = UDim2.new(0,0,0,6)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = def.icon
    iconLbl.TextSize = 20
    iconLbl.Font = Enum.Font.SciFi

    -- Имя
    local nameLbl = Instance.new("TextLabel", tile)
    nameLbl.Size = UDim2.new(1,0,0,14)
    nameLbl.Position = UDim2.new(0,0,0,36)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = def.label
    nameLbl.TextSize = 9
    nameLbl.Font = Enum.Font.SciFi
    nameLbl.TextColor3 = Color3.fromRGB(180,180,180)

    -- Чекбокс индикатор (✅ / ❎)
    local checkLbl = Instance.new("TextLabel", tile)
    checkLbl.Size = UDim2.new(1,0,0,16)
    checkLbl.Position = UDim2.new(0,0,0,52)
    checkLbl.BackgroundTransparency = 1
    checkLbl.Text = ESP_States[def.key] and "✅" or "❎"
    checkLbl.TextSize = 11
    checkLbl.Font = Enum.Font.SciFi

    tile.MouseButton1Click:Connect(function()
        ESP_States[def.key] = not ESP_States[def.key]
        local on = ESP_States[def.key]
        tile.BackgroundColor3 = on and Color3.fromRGB(15,45,15) or Color3.fromRGB(25,15,15)
        ts.Color = on and Color3.fromRGB(0,200,60) or Color3.fromRGB(80,20,20)
        checkLbl.Text = on and "✅" or "❎"
        Notify(def.label .. (on and " ESP ON" or " ESP OFF"))
    end)

    -- Hover
    tile.MouseEnter:Connect(function()
        TweenService:Create(tile, TweenInfo.new(0.12), {BackgroundColor3 = ESP_States[def.key] and Color3.fromRGB(20,60,20) or Color3.fromRGB(40,20,20)}):Play()
    end)
    tile.MouseLeave:Connect(function()
        TweenService:Create(tile, TweenInfo.new(0.12), {BackgroundColor3 = ESP_States[def.key] and Color3.fromRGB(15,45,15) or Color3.fromRGB(25,15,15)}):Play()
    end)

    TileButtons[def.key] = {tile = tile, stroke = ts, check = checkLbl}
end

for _, def in ipairs(TilesDef) do CreateTile(def) end

-- Кнопка открытия ESP Panel (в PageMain)
local espPanelBtn = Instance.new("TextButton", PageMain)
espPanelBtn.Size = UDim2.new(1, 0, 0, 40)
espPanelBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
espPanelBtn.TextColor3 = Color3.new(1,1,1)
espPanelBtn.Font = Enum.Font.SciFi
espPanelBtn.TextSize = 14
espPanelBtn.Text = "⚔  ОТКРЫТЬ ESP НАСТРОЙКИ"
style(espPanelBtn, 6, 1)
espPanelBtn.MouseButton1Click:Connect(function()
    ESPPanel.Visible = not ESPPanel.Visible
    if ESPPanel.Visible then Notify("ESP PANEL OPENED") end
end)

-- ── RADAR ────────────────────────────────────────────────
local RadarFrame = Instance.new("Frame", ScreenGui)
RadarFrame.Name = "SauronRadar"
RadarFrame.Size = UDim2.new(0, 160, 0, 160)
RadarFrame.Position = UDim2.new(1, -175, 0, 10)
RadarFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
RadarFrame.BackgroundTransparency = 0.25
RadarFrame.Visible = RADAR_ESP
style(RadarFrame, 80, 2)
table.insert(Movable_Objects, RadarFrame)

local RadarTitle = Instance.new("TextLabel", RadarFrame)
RadarTitle.Size = UDim2.new(1,0,0,18)
RadarTitle.BackgroundTransparency = 1
RadarTitle.Text = "⚔ RADAR"
RadarTitle.Font = Enum.Font.SciFi
RadarTitle.TextSize = 11
RadarTitle.TextColor3 = Color3.fromRGB(200,0,0)

local RadarSelf = Instance.new("Frame", RadarFrame)
RadarSelf.Size = UDim2.new(0,8,0,8)
RadarSelf.Position = UDim2.new(0.5,-4,0.5,-4)
RadarSelf.BackgroundColor3 = Color3.fromRGB(0,255,100)
RadarSelf.BorderSizePixel = 0
Instance.new("UICorner", RadarSelf).CornerRadius = UDim.new(1,0)

-- Перекрестие радара
for _, dir in ipairs({{0.5,0.02,0.5,0.46},{0.5,0.54,0.5,0.98},{0.02,0.5,0.46,0.5},{0.54,0.5,0.98,0.5}}) do
    local l = Instance.new("Frame", RadarFrame)
    l.Size = (dir[3]-dir[1] < 0.1) and UDim2.new(dir[3]-dir[1],0,0,1) or UDim2.new(0,1,dir[4]-dir[2],0)
    l.Position = UDim2.new(dir[1],0,dir[2],0)
    l.BackgroundColor3 = Color3.fromRGB(40,40,40)
    l.BorderSizePixel = 0
end

local RadarDots = {}

local function GetOrCreateRadarDot(player)
    if not RadarDots[player] then
        local dot = Instance.new("Frame", RadarFrame)
        dot.Size = UDim2.new(0,6,0,6)
        dot.BackgroundColor3 = Color3.fromRGB(255,50,50)
        dot.BorderSizePixel = 0
        dot.ZIndex = 5
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
        local lbl = Instance.new("TextLabel", dot)
        lbl.Size = UDim2.new(0,55,0,12)
        lbl.Position = UDim2.new(1,3,0,-3)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.SciFi
        lbl.TextSize = 9
        lbl.Text = player.Name:sub(1,7)
        RadarDots[player] = {dot=dot, label=lbl}
    end
    return RadarDots[player]
end

-- ── SKELETON PAIRS ───────────────────────────────────────
local SkeletonPairs = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"Head","Torso"},{"Torso","Right Arm"},{"Torso","Left Arm"},{"Torso","Right Leg"},{"Torso","Left Leg"}
}

-- ── CREATE / REMOVE ESP ──────────────────────────────────
local function NewLine(col,thick,trans)
    local l=Drawing.new("Line"); l.Color=col or Color3.new(1,1,1); l.Thickness=thick or 1; l.Transparency=trans or 1; l.Visible=false; return l
end

local function CreateBoxESP(player)
    if ESPData[player] then return end
    local box  = Drawing.new("Quad"); box.Filled=false; box.Thickness=1; box.Visible=false
    local corners = {}
    for i=1,8 do corners[i]=NewLine(Color3.new(1,1,1),2.5) end

    local nameLbl=Drawing.new("Text"); nameLbl.Size=14; nameLbl.Font=Drawing.Fonts.Plex; nameLbl.Center=true; nameLbl.Outline=true; nameLbl.Visible=false
    local distLbl=Drawing.new("Text"); distLbl.Size=11; distLbl.Font=Drawing.Fonts.Plex; distLbl.Center=true; distLbl.Outline=true; distLbl.Color=Color3.fromRGB(200,200,200); distLbl.Visible=false
    local hpBg  =NewLine(Color3.fromRGB(10,10,10),5);   hpBg.Transparency=0
    local hpBar =NewLine(Color3.fromRGB(0,255,80),3);   hpBar.Transparency=0
    local hpTxt =Drawing.new("Text"); hpTxt.Size=10; hpTxt.Font=Drawing.Fonts.Plex; hpTxt.Outline=true; hpTxt.Visible=false
    local skelLines={}; for i=1,#SkeletonPairs do skelLines[i]=NewLine(Color3.fromRGB(255,255,100),1) end
    local tracer=NewLine(Color3.new(1,1,1),1,0.6)

    ESPData[player]={box=box,corners=corners,nameLbl=nameLbl,distLbl=distLbl,hpBg=hpBg,hpBar=hpBar,hpTxt=hpTxt,skelLines=skelLines,tracer=tracer}
end

local function RemoveBoxESP(player)
    local d=ESPData[player]; if not d then return end
    d.box:Remove()
    for _,c in ipairs(d.corners) do c:Remove() end
    d.nameLbl:Remove(); d.distLbl:Remove(); d.hpBg:Remove(); d.hpBar:Remove(); d.hpTxt:Remove()
    for _,l in ipairs(d.skelLines) do l:Remove() end
    d.tracer:Remove()
    ESPData[player]=nil
    if RadarDots[player] then RadarDots[player].dot:Destroy(); RadarDots[player]=nil end
end

for _,p in pairs(Players:GetPlayers()) do if p~=Player then CreateBoxESP(p) end end
Players.PlayerAdded:Connect(function(p) CreateBoxESP(p) end)
Players.PlayerRemoving:Connect(function(p)
    RemoveBoxESP(p)
    if ESPLines[p] then ESPLines[p]:Remove(); ESPLines[p]=nil end
end)

-- ── UPDATE FUNCTION ──────────────────────────────────────
local function UpdateBoxESP(activeColor)
    local anyOn = ESP_States.BOX or ESP_States.NAME or ESP_States.HEALTH or ESP_States.DISTANCE or ESP_States.SKELETON or ESP_States.TRACER
    local myChar  = Player.Character
    local myRoot  = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _,p in pairs(Players:GetPlayers()) do
        if p==Player then continue end
        local d=ESPData[p]; if not d then continue end
        local char=p.Character
        local hum =char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local head=char and char:FindFirstChild("Head")

        local function hideAll()
            d.box.Visible=false
            for _,c in ipairs(d.corners) do c.Visible=false end
            d.nameLbl.Visible=false; d.distLbl.Visible=false
            d.hpBg.Visible=false; d.hpBar.Visible=false; d.hpTxt.Visible=false
            for _,l in ipairs(d.skelLines) do l.Visible=false end
            d.tracer.Visible=false
            if RadarDots[p] then RadarDots[p].dot.Visible=false end
        end

        if not anyOn or not char or not root or not head or not hum or hum.Health<=0 then hideAll(); continue end

        local rootPos=root.Position
        local topPos =rootPos+Vector3.new(0,3.2,0)
        local botPos =rootPos-Vector3.new(0,2.8,0)
        local topVec,topOn=Camera:WorldToViewportPoint(topPos)
        local botVec,botOn=Camera:WorldToViewportPoint(botPos)

        if not topOn and not botOn then hideAll(); continue end

        local boxH=math.abs(topVec.Y-botVec.Y)
        local boxW=boxH*0.55
        local cx=topVec.X; local top2D=topVec.Y; local bot2D=botVec.Y
        local L=cx-boxW/2; local R=cx+boxW/2
        local dist=myRoot and math.floor((rootPos-myRoot.Position).Magnitude) or 0
        local hpPct=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
        local hpColor=Color3.fromRGB(math.floor(255*(1-hpPct)),math.floor(255*hpPct),50)

        -- BOX
        if ESP_States.BOX then
            d.box.PointA=Vector2.new(L,top2D); d.box.PointB=Vector2.new(R,top2D)
            d.box.PointC=Vector2.new(R,bot2D); d.box.PointD=Vector2.new(L,bot2D)
            d.box.Color=activeColor; d.box.Transparency=0.5; d.box.Visible=true
            -- Угловые декоры
            local cL=boxW*0.22; local cH=boxH*0.15
            local cp={{L,top2D,L+cL,top2D},{L,top2D,L,top2D+cH},{R,top2D,R-cL,top2D},{R,top2D,R,top2D+cH},{L,bot2D,L+cL,bot2D},{L,bot2D,L,bot2D-cH},{R,bot2D,R-cL,bot2D},{R,bot2D,R,bot2D-cH}}
            for i,c in ipairs(d.corners) do c.From=Vector2.new(cp[i][1],cp[i][2]); c.To=Vector2.new(cp[i][3],cp[i][4]); c.Color=Color3.new(1,1,1); c.Visible=true end
        else d.box.Visible=false; for _,c in ipairs(d.corners) do c.Visible=false end end

        -- NAME
        if ESP_States.NAME then
            local tag = ESP_States.DISTANCE and string.format("[ %s   %dm ]",p.Name,dist) or string.format("[ %s ]",p.Name)
            d.nameLbl.Text=tag; d.nameLbl.Position=Vector2.new(cx,top2D-17); d.nameLbl.Color=activeColor; d.nameLbl.Visible=true
            d.distLbl.Visible=false
        elseif ESP_States.DISTANCE then
            d.nameLbl.Visible=false
            d.distLbl.Text=dist.."m"; d.distLbl.Position=Vector2.new(cx,top2D-15); d.distLbl.Visible=true
        else d.nameLbl.Visible=false; d.distLbl.Visible=false end

        -- HEALTH BAR
        if ESP_States.HEALTH then
            local bx=L-7; local bfill=top2D+(bot2D-top2D)*(1-hpPct)
            d.hpBg.From=Vector2.new(bx,top2D); d.hpBg.To=Vector2.new(bx,bot2D); d.hpBg.Visible=true
            d.hpBar.From=Vector2.new(bx,bfill); d.hpBar.To=Vector2.new(bx,bot2D); d.hpBar.Color=hpColor; d.hpBar.Visible=true
            d.hpTxt.Text=math.floor(hum.Health).."hp"; d.hpTxt.Position=Vector2.new(bx+4,bfill-8); d.hpTxt.Color=hpColor; d.hpTxt.Visible=true
        else d.hpBg.Visible=false; d.hpBar.Visible=false; d.hpTxt.Visible=false end

        -- SKELETON
        if ESP_States.SKELETON then
            for i,pair in ipairs(SkeletonPairs) do
                local pA=char:FindFirstChild(pair[1]); local pB=char:FindFirstChild(pair[2]); local ln=d.skelLines[i]
                if pA and pB then local vA,oA=Camera:WorldToViewportPoint(pA.Position); local vB,oB=Camera:WorldToViewportPoint(pB.Position)
                    if oA or oB then ln.From=Vector2.new(vA.X,vA.Y); ln.To=Vector2.new(vB.X,vB.Y); ln.Color=activeColor; ln.Visible=true else ln.Visible=false end
                else ln.Visible=false end
            end
        else for _,l in ipairs(d.skelLines) do l.Visible=false end end

        -- TRACER
        if ESP_States.TRACER then
            local vr,on=Camera:WorldToViewportPoint(rootPos)
            d.tracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); d.tracer.To=Vector2.new(vr.X,vr.Y); d.tracer.Color=activeColor; d.tracer.Visible=on
        else d.tracer.Visible=false end

        -- CHAMS (Highlight)
        if ESP_States.CHAMS then
            if not char:FindFirstChild("SauronESP") then
                local hl=Instance.new("Highlight",char); hl.Name="SauronESP"; hl.FillTransparency=0.5; hl.OutlineTransparency=0
            else char.SauronESP.FillColor=activeColor end
        else
            if char:FindFirstChild("SauronESP") then char.SauronESP:Destroy() end
        end

        -- RADAR
        if RADAR_ESP and myRoot then
            local rd=GetOrCreateRadarDot(p)
            local rel=myRoot.CFrame:inverse()*CFrame.new(rootPos)
            local rx=math.clamp(rel.X/70,-1,1); local rz=math.clamp(-rel.Z/70,-1,1)
            rd.dot.Position=UDim2.new(0,rx*65+77,0,rz*65+77)
            rd.dot.BackgroundColor3=hpColor; rd.dot.Visible=true
        elseif RadarDots[p] then RadarDots[p].dot.Visible=false end
    end

    -- Обновляем self-dot цвет
    if RadarSelf then RadarSelf.BackgroundColor3=activeColor end
end

-- ── HOOK RENDER ──────────────────────────────────────────
RunService.RenderStepped:Connect(function()
    pcall(function()
        local t=tick(); local cn=Themes[CurrentThemeIndex]; local ac=Color3.new(1,1,1)
        if cn=="RGB" then ac=Color3.fromHSV(t%3/3,1,1) elseif ThemeColors[cn] then ac=ThemeColors[cn] end
        UpdateBoxESP(ac)
        -- Синхронизируем CHAMS с States.Esp (обратная совместимость)
        if States.Esp ~= ESP_States.CHAMS then States.Esp = ESP_States.CHAMS end
    end)
end)

-- Плитки радара в ESP panel
local radarTile = Instance.new("TextButton", TilesContainer)
radarTile.Size = UDim2.new(0,44,0,72)
radarTile.BackgroundColor3 = RADAR_ESP and Color3.fromRGB(15,45,15) or Color3.fromRGB(25,15,15)
radarTile.Text = ""; radarTile.BorderSizePixel = 0
Instance.new("UICorner", radarTile).CornerRadius = UDim.new(0,8)
local rtStroke=Instance.new("UIStroke",radarTile); rtStroke.Thickness=1.5; rtStroke.Color=RADAR_ESP and Color3.fromRGB(0,200,60) or Color3.fromRGB(80,20,20)
local ri=Instance.new("TextLabel",radarTile); ri.Size=UDim2.new(1,0,0,30); ri.Position=UDim2.new(0,0,0,6); ri.BackgroundTransparency=1; ri.Text="🛰"; ri.TextSize=20; ri.Font=Enum.Font.SciFi
local rn=Instance.new("TextLabel",radarTile); rn.Size=UDim2.new(1,0,0,14); rn.Position=UDim2.new(0,0,0,36); rn.BackgroundTransparency=1; rn.Text="RADAR"; rn.TextSize=9; rn.Font=Enum.Font.SciFi; rn.TextColor3=Color3.fromRGB(180,180,180)
local rc=Instance.new("TextLabel",radarTile); rc.Size=UDim2.new(1,0,0,16); rc.Position=UDim2.new(0,0,0,52); rc.BackgroundTransparency=1; rc.Text=RADAR_ESP and "✅" or "❎"; rc.TextSize=11; rc.Font=Enum.Font.SciFi
radarTile.MouseButton1Click:Connect(function()
    RADAR_ESP=not RADAR_ESP; RadarFrame.Visible=RADAR_ESP
    radarTile.BackgroundColor3=RADAR_ESP and Color3.fromRGB(15,45,15) or Color3.fromRGB(25,15,15)
    rtStroke.Color=RADAR_ESP and Color3.fromRGB(0,200,60) or Color3.fromRGB(80,20,20)
    rc.Text=RADAR_ESP and "✅" or "❎"
    Notify("RADAR " .. (RADAR_ESP and "ON" or "OFF"))
end)

-- ════════════════════════════════════════════════════════
Notify("⚔ SAURON V1 LOADED")

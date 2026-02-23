-- ================================================================
-- [[ ⛧ AngerMOD V2.0.0 ⛧ Roblox Edition ]]
-- KEY SYSTEM + PUBG-STYLE MENU
-- ================================================================

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace      = game:GetService("Workspace")
local Camera         = Workspace.CurrentCamera
local TweenService   = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris         = game:GetService("Debris")
local VirtualUser    = game:GetService("VirtualUser")
local Lighting       = game:GetService("Lighting")
local Stats          = game:GetService("Stats")
local HttpService    = game:GetService("HttpService")
local Player         = Players.LocalPlayer

local request        = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local getcustomasset = getcustomasset or getsynasset

-- ================================================================
-- [[ DEVICE INFO ]]
-- ================================================================
local function GetDeviceInfo()
    local platform = "PC"
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        platform = "MOBILE"
    elseif UserInputService.GamepadEnabled then
        platform = "GAMEPAD"
    end
    return platform
end

local DeviceInfo = GetDeviceInfo()

-- ================================================================
-- [[ KEY SYSTEM ]]
-- ================================================================
local KEY_JSON_URL  = "https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.json"
local KEY_SAVE_FILE = "AngerMOD_key.txt"

local function GetKeyDuration(keyData)
    local days  = tonumber(keyData["time"]) or 0
    local hours = tonumber(keyData["time-hours"]) or 0
    if days > 0 then return days * 86400
    elseif hours > 0 then return hours * 3600 end
    return 0
end

local function ValidateKey(inputKey)
    if not request then return false, "HTTP недоступен", nil end
    local ok, response = pcall(function()
        return request({ Url = KEY_JSON_URL, Method = "GET" })
    end)
    if not ok or not response or response.StatusCode ~= 200 then
        return false, "Не удалось загрузить базу ключей", nil
    end
    local parsed, keys = pcall(function() return HttpService:JSONDecode(response.Body) end)
    if not parsed or type(keys) ~= "table" then
        return false, "Ошибка парсинга key.json", nil
    end
    for _, keyData in ipairs(keys) do
        if type(keyData) == "table" and keyData["key"] == inputKey then
            local activations = tonumber(keyData["activate"]) or 0
            if activations <= 0 then return false, "Ключ исчерпал лимит активаций", nil end
            return true, "OK", keyData
        end
    end
    return false, "Неверный ключ", nil
end

local function SaveKey(key)
    if writefile then pcall(function() writefile(KEY_SAVE_FILE, key) end) end
end

local function LoadSavedKey()
    if readfile and isfile and isfile(KEY_SAVE_FILE) then
        local ok, val = pcall(function() return readfile(KEY_SAVE_FILE) end)
        if ok and val and val ~= "" then return val end
    end
    return nil
end

local function FormatTime(seconds)
    if seconds >= 86400 then return math.floor(seconds / 86400) .. " дн."
    elseif seconds >= 3600 then return math.floor(seconds / 3600) .. " ч."
    elseif seconds >= 60 then return math.floor(seconds / 60) .. " мин."
    else return seconds .. " сек." end
end

-- ================================================================
-- [[ LOGIN GUI - PUBG STYLE ]]
-- ================================================================
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "AngerMOD_Login_V2"
LoginGui.ResetOnSpawn = false
LoginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if Player:FindFirstChild("PlayerGui") then LoginGui.Parent = Player.PlayerGui
else LoginGui.Parent = game:GetService("CoreGui") end

-- Полноэкранный полупрозрачный красный оверлей (как на скрине — текст по всему экрану)
local ErrorOverlay = Instance.new("Frame", LoginGui)
ErrorOverlay.Size = UDim2.new(1, 0, 1, 0)
ErrorOverlay.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ErrorOverlay.BackgroundTransparency = 0.25
ErrorOverlay.BorderSizePixel = 0
ErrorOverlay.ZIndex = 1
ErrorOverlay.Visible = false

local ErrorText = Instance.new("TextLabel", ErrorOverlay)
ErrorText.Size = UDim2.new(1, 0, 1, 0)
ErrorText.BackgroundTransparency = 1
ErrorText.Text = "ANGERMOD NOT ALLOWED FOR YOU"
ErrorText.TextColor3 = Color3.fromRGB(255, 255, 255)
ErrorText.Font = Enum.Font.SciFi
ErrorText.TextSize = 60
ErrorText.TextWrapped = true
ErrorText.ZIndex = 2
ErrorText.TextStrokeTransparency = 0
ErrorText.TextStrokeColor3 = Color3.fromRGB(100, 0, 0)

-- Мелкий повторяющийся текст на фоне (как в PUBG скрине)
local BgTextLabel = Instance.new("TextLabel", LoginGui)
BgTextLabel.Size = UDim2.new(1, 0, 1, 0)
BgTextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BgTextLabel.BackgroundTransparency = 0.5
BgTextLabel.BorderSizePixel = 0
BgTextLabel.TextColor3 = Color3.fromRGB(200, 150, 0)
BgTextLabel.Font = Enum.Font.SciFi
BgTextLabel.TextSize = 13
BgTextLabel.TextWrapped = true
BgTextLabel.ZIndex = 1
BgTextLabel.Text = string.rep("COPY KEY BEFORE OPEN GAME ERROR!! LOGIN ERROR!! ", 500)

-- FPS лейбл в правом верхнем углу
local LoginFPSLabel = Instance.new("TextLabel", LoginGui)
LoginFPSLabel.Size = UDim2.new(0, 160, 0, 28)
LoginFPSLabel.Position = UDim2.new(1, -170, 0, 8)
LoginFPSLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoginFPSLabel.BackgroundTransparency = 0.5
LoginFPSLabel.BorderSizePixel = 0
LoginFPSLabel.TextColor3 = Color3.fromRGB(0, 220, 100)
LoginFPSLabel.Font = Enum.Font.SciFi
LoginFPSLabel.TextSize = 14
LoginFPSLabel.ZIndex = 5
LoginFPSLabel.Text = "FPS: --"
Instance.new("UICorner", LoginFPSLabel).CornerRadius = UDim.new(0, 4)

-- Главная панель логина (полупрозрачная, как на скрине)
local LoginFrame = Instance.new("Frame", LoginGui)
LoginFrame.Size = UDim2.new(0, 440, 0, 310)
LoginFrame.Position = UDim2.new(0.5, -220, 0.5, -155)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 5)
LoginFrame.BackgroundTransparency = 0.15
LoginFrame.BorderSizePixel = 0
LoginFrame.ZIndex = 3
LoginFrame.Active = true
LoginFrame.Draggable = true

local lc_r = Instance.new("UICorner", LoginFrame); lc_r.CornerRadius = UDim.new(0, 6)
local ls_r = Instance.new("UIStroke", LoginFrame)
ls_r.Color = Color3.fromRGB(220, 170, 0); ls_r.Thickness = 2

-- Заголовок (▼ [Z] MODS стиль → наш)
local TitleBar = Instance.new("Frame", LoginFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 15, 5)
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 4
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 6)

local TitleArrow = Instance.new("TextLabel", TitleBar)
TitleArrow.Size = UDim2.new(0, 20, 1, 0)
TitleArrow.Position = UDim2.new(0, 6, 0, 0)
TitleArrow.BackgroundTransparency = 1
TitleArrow.Text = "▼"
TitleArrow.TextColor3 = Color3.fromRGB(220, 170, 0)
TitleArrow.Font = Enum.Font.SciFi
TitleArrow.TextSize = 14
TitleArrow.ZIndex = 5

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 30, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AngerMOD V2.0.0 || Roblox || FPS — --"
TitleLabel.TextColor3 = Color3.fromRGB(220, 170, 0)
TitleLabel.Font = Enum.Font.SciFi
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 5

-- Кнопка закрыть (×)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SciFi
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 6
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() LoginGui:Destroy() end)

-- Подзаголовки (как "Please PM Admin To Order Key")
local SubInfo1 = Instance.new("TextLabel", LoginFrame)
SubInfo1.Size = UDim2.new(1, -20, 0, 22)
SubInfo1.Position = UDim2.new(0, 10, 0, 44)
SubInfo1.BackgroundTransparency = 1
SubInfo1.Text = "Please PM Admin To Order Key"
SubInfo1.TextColor3 = Color3.fromRGB(220, 170, 0)
SubInfo1.Font = Enum.Font.SciFi
SubInfo1.TextSize = 14
SubInfo1.TextXAlignment = Enum.TextXAlignment.Left
SubInfo1.ZIndex = 4

local SubInfo2 = Instance.new("TextLabel", LoginFrame)
SubInfo2.Size = UDim2.new(1, -20, 0, 22)
SubInfo2.Position = UDim2.new(0, 10, 0, 64)
SubInfo2.BackgroundTransparency = 1
SubInfo2.Text = "Please Login (Copy Key)"
SubInfo2.TextColor3 = Color3.fromRGB(180, 180, 180)
SubInfo2.Font = Enum.Font.SciFi
SubInfo2.TextSize = 13
SubInfo2.TextXAlignment = Enum.TextXAlignment.Left
SubInfo2.ZIndex = 4

-- Поле ввода ключа
local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.Size = UDim2.new(1, -20, 0, 40)
KeyBox.Position = UDim2.new(0, 10, 0, 94)
KeyBox.BackgroundColor3 = Color3.fromRGB(15, 12, 5)
KeyBox.BackgroundTransparency = 0.1
KeyBox.PlaceholderText = "AngerMOD-XXXX-XXXXXXXXXX"
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(220, 170, 0)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 90, 30)
KeyBox.Font = Enum.Font.SciFi
KeyBox.TextSize = 15
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 4
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 4)
local ks = Instance.new("UIStroke", KeyBox); ks.Color = Color3.fromRGB(220, 170, 0); ks.Thickness = 1.5

-- Статус / лоадер
local StatusLabel = Instance.new("TextLabel", LoginFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 24)
StatusLabel.Position = UDim2.new(0, 10, 0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.SciFi
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 4
StatusLabel.TextWrapped = true

-- ENTER LOGIN кнопка
local EnterBtn = Instance.new("TextButton", LoginFrame)
EnterBtn.Size = UDim2.new(1, -20, 0, 42)
EnterBtn.Position = UDim2.new(0, 10, 0, 170)
EnterBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 5)
EnterBtn.BackgroundTransparency = 0.1
EnterBtn.Text = "ENTER LOGIN"
EnterBtn.TextColor3 = Color3.fromRGB(220, 170, 0)
EnterBtn.Font = Enum.Font.SciFi
EnterBtn.TextSize = 18
EnterBtn.ZIndex = 4
Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 4)
local es = Instance.new("UIStroke", EnterBtn); es.Color = Color3.fromRGB(220, 170, 0); es.Thickness = 1.5

-- DEVICE INFO кнопка (вместо PASTE KEY)
local DeviceBtn = Instance.new("TextButton", LoginFrame)
DeviceBtn.Size = UDim2.new(1, -20, 0, 38)
DeviceBtn.Position = UDim2.new(0, 10, 0, 220)
DeviceBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 5)
DeviceBtn.BackgroundTransparency = 0.2
DeviceBtn.Text = "DEVICE: " .. DeviceInfo .. " | " .. Player.Name
DeviceBtn.TextColor3 = Color3.fromRGB(220, 170, 0)
DeviceBtn.Font = Enum.Font.SciFi
DeviceBtn.TextSize = 14
DeviceBtn.ZIndex = 4
Instance.new("UICorner", DeviceBtn).CornerRadius = UDim.new(0, 4)
local ds = Instance.new("UIStroke", DeviceBtn); ds.Color = Color3.fromRGB(220, 170, 0); ds.Thickness = 1.5
DeviceBtn.MouseButton1Click:Connect(function()
    -- Вставить ключ из буфера (если доступно)
    if setclipboard then
        KeyBox.Text = ""
    end
    StatusLabel.Text = "📱 " .. DeviceInfo .. " | " .. Player.Name
    StatusLabel.TextColor3 = Color3.fromRGB(220, 170, 0)
end)

-- GitHub ссылка
local GithubBtn = Instance.new("TextButton", LoginFrame)
GithubBtn.Size = UDim2.new(1, -20, 0, 24)
GithubBtn.Position = UDim2.new(0, 10, 0, 268)
GithubBtn.BackgroundTransparency = 1
GithubBtn.Text = "🔑 github.com/AngerPC-DEV/AngerMOD"
GithubBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
GithubBtn.Font = Enum.Font.SciFi
GithubBtn.TextSize = 12
GithubBtn.ZIndex = 4
GithubBtn.TextXAlignment = Enum.TextXAlignment.Left
GithubBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "🔑 github.com/AngerPC-DEV/AngerMOD → key.json"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
end)

-- ================================================================
-- [[ ЛОГИКА ЛОГИНА ]]
-- ================================================================
local isChecking = false
local StartAngerMOD

local function SetStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.new(1, 1, 1)
end

local function ShowNotAllowed()
    ErrorOverlay.Visible = true
    -- Мигание
    task.spawn(function()
        for _ = 1, 6 do
            ErrorOverlay.BackgroundTransparency = 0.1
            task.wait(0.15)
            ErrorOverlay.BackgroundTransparency = 0.35
            task.wait(0.15)
        end
        ErrorOverlay.BackgroundTransparency = 0.25
    end)
    task.delay(4, function()
        TweenService:Create(ErrorOverlay, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        TweenService:Create(ErrorText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1)
        ErrorOverlay.Visible = false
        ErrorText.TextTransparency = 0
        ErrorOverlay.BackgroundTransparency = 0.25
    end)
end

local function OnActivate()
    if isChecking then return end
    local key = KeyBox.Text:gsub("%s+", "")
    if key == "" then
        SetStatus("⚠ Введите ключ!", Color3.fromRGB(255, 200, 0))
        return
    end

    isChecking = true
    EnterBtn.Active = false
    EnterBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 5)
    SetStatus("⟳ Проверка...", Color3.fromRGB(220, 170, 0))

    task.spawn(function()
        local valid, msg, keyData = ValidateKey(key)
        isChecking = false
        EnterBtn.Active = true
        EnterBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 5)

        if valid then
            local duration = GetKeyDuration(keyData)
            local timeStr = duration > 0 and ("Действует: " .. FormatTime(duration)) or "Постоянный"
            SetStatus("✅ " .. timeStr, Color3.fromRGB(0, 255, 80))
            SaveKey(key)

            -- Анимация исчезновения
            task.wait(1.0)
            TweenService:Create(LoginFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -220, -0.6, 0),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(BgTextLabel, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.6)
            LoginGui:Destroy()
            StartAngerMOD()
        else
            -- Показать красный экран NOT ALLOWED
            ShowNotAllowed()
            SetStatus("❌ " .. (msg or "Неверный ключ"), Color3.fromRGB(255, 60, 60))
            -- Тряска
            task.spawn(function()
                for _ = 1, 5 do
                    LoginFrame.Position = UDim2.new(0.5, -220 + 8, 0.5, -155)
                    task.wait(0.05)
                    LoginFrame.Position = UDim2.new(0.5, -220 - 8, 0.5, -155)
                    task.wait(0.05)
                end
                LoginFrame.Position = UDim2.new(0.5, -220, 0.5, -155)
            end)
        end
    end)
end

EnterBtn.MouseButton1Click:Connect(OnActivate)
KeyBox.FocusLost:Connect(function(enter) if enter then OnActivate() end end)

-- Анимация появления
LoginFrame.Position = UDim2.new(0.5, -220, -0.6, 0)
TweenService:Create(LoginFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -220, 0.5, -155)
}):Play()

-- FPS счётчик в логин экране
RunService.RenderStepped:Connect(function()
    if LoginGui and LoginGui.Parent then
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        LoginFPSLabel.Text = "FPS: " .. math.floor(workspace:GetRealPhysicsFPS and workspace:GetRealPhysicsFPS() or 60)
        TitleLabel.Text = "AngerMOD V2.0.0 || Roblox || FPS — " .. math.floor(workspace:GetRealPhysicsFPS and workspace:GetRealPhysicsFPS() or 60)
    end
end)

-- Автологин
task.spawn(function()
    local savedKey = LoadSavedKey()
    if savedKey and savedKey ~= "" then
        KeyBox.Text = savedKey
        SetStatus("⟳ Авто-проверка...", Color3.fromRGB(220, 170, 0))
        task.wait(1.0)
        OnActivate()
    end
end)

-- ================================================================
-- [[ ⛧ ОСНОВНОЙ МОД ]] — запускается после успешного логина
-- ================================================================
StartAngerMOD = function()

local SessionID = string.upper(HttpService:GenerateGUID(false):sub(1, 8))

local ChatHistory = {
    { role = "system", content = "Ты — AngerPC, крутой ИИ-бот в Roblox. Создатель: AngerPC-DEV. Характер: дерзкий, краткий." }
}

local GroqModels = { "llama-3.3-70b-versatile", "llama-3.1-70b-versatile", "deepseek-r1-distill-llama-70b" }
local CurrentModelIndex = 1

local Themes = { "RGB", "БЕЛЫЙ", "СЕРЫЙ", "ГОЛУБОЙ", "ФИОЛЕТОВЫЙ", "НЕОБЫЧНЫЙ", "РОЗОВЫЙ", "КРАСНЫЙ" }
local ThemeColors = {
    ["БЕЛЫЙ"] = Color3.new(1, 1, 1), ["СЕРЫЙ"] = Color3.fromRGB(120, 120, 120),
    ["ГОЛУБОЙ"] = Color3.fromRGB(0, 190, 255), ["ФИОЛЕТОВЫЙ"] = Color3.fromRGB(170, 0, 255),
    ["НЕОБЫЧНЫЙ"] = Color3.fromRGB(255, 170, 0), ["РОЗОВЫЙ"] = Color3.fromRGB(255, 105, 180),
    ["КРАСНЫЙ"] = Color3.fromRGB(255, 0, 0)
}
local CurrentThemeIndex = 1

local CurrentSound = nil
local MusicPlaying = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AngerGUI_V200"; ScreenGui.ResetOnSpawn = false
if Player:FindFirstChild("PlayerGui") then ScreenGui.Parent = Player.PlayerGui
else ScreenGui.Parent = game:GetService("CoreGui") end

-- DEATH SCREEN
local DeathScreen = Instance.new("ScreenGui", ScreenGui.Parent)
DeathScreen.Name = "AngerDeath"; DeathScreen.Enabled = false
local DeathLabel = Instance.new("TextLabel", DeathScreen)
DeathLabel.Size = UDim2.new(1,0,1,0); DeathLabel.BackgroundTransparency = 1
DeathLabel.Text = "WASTED"; DeathLabel.Font = Enum.Font.Creepster
DeathLabel.TextSize = 100; DeathLabel.TextColor3 = Color3.fromRGB(255,0,0)
DeathLabel.TextStrokeTransparency = 0

local RGB_Objects   = {}
local Movable_Objects = {}
local RecordedPath  = {}
local UI_Unlocked   = false
local ESPLines      = {}

local function style(obj, radius, thickness)
    local uiC = Instance.new("UICorner", obj); uiC.CornerRadius = UDim.new(0, radius or 6)
    local uiS = Instance.new("UIStroke", obj); uiS.Color = Color3.fromRGB(60,60,60); uiS.Thickness = thickness or 1
    table.insert(RGB_Objects, {Type="Stroke", Instance=uiS})
    return uiS
end

-- NOTIFY
local NotifyContainer = Instance.new("Frame", ScreenGui)
NotifyContainer.Size = UDim2.new(0,250,0.4,0); NotifyContainer.Position = UDim2.new(1,-260,0.55,0); NotifyContainer.BackgroundTransparency = 1
local NL = Instance.new("UIListLayout", NotifyContainer)
NL.SortOrder = Enum.SortOrder.LayoutOrder; NL.VerticalAlignment = Enum.VerticalAlignment.Bottom; NL.Padding = UDim.new(0,5)

local function Notify(text)
    local f = Instance.new("Frame", NotifyContainer); f.Size=UDim2.new(1,0,0,35); f.BackgroundColor3=Color3.fromRGB(20,20,20); f.BackgroundTransparency=0.2; style(f,4,1)
    local l = Instance.new("TextLabel",f); l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,5,0,0); l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.SciFi; l.TextSize=14; l.TextXAlignment=Enum.TextXAlignment.Left
    f.BackgroundTransparency=1; l.TextTransparency=1
    TweenService:Create(f,TweenInfo.new(0.3),{BackgroundTransparency=0.2}):Play()
    TweenService:Create(l,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    task.delay(3,function()
        TweenService:Create(f,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        TweenService:Create(l,TweenInfo.new(0.5),{TextTransparency=1}):Play()
        task.wait(0.5); f:Destroy()
    end)
end

-- ================================================================
-- [[ MAIN MENU — PUBG STYLE TRANSPARENT ]]
-- ================================================================
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "AngerMain"
Main.Size = UDim2.new(0, 480, 0, 580)
Main.Position = UDim2.new(0.5, -240, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(10, 8, 5)
Main.BackgroundTransparency = 0.2
Main.Visible = true
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(220, 170, 0); mainStroke.Thickness = 2
table.insert(Movable_Objects, Main)

-- TITLE BAR
local MainTitleBar = Instance.new("Frame", Main)
MainTitleBar.Size = UDim2.new(1, 0, 0, 38)
MainTitleBar.BackgroundColor3 = Color3.fromRGB(20, 15, 5)
MainTitleBar.BackgroundTransparency = 0.1
MainTitleBar.BorderSizePixel = 0
Instance.new("UICorner", MainTitleBar).CornerRadius = UDim.new(0, 6)

local MainArrow = Instance.new("TextLabel", MainTitleBar)
MainArrow.Size = UDim2.new(0,20,1,0); MainArrow.Position = UDim2.new(0,6,0,0)
MainArrow.BackgroundTransparency = 1; MainArrow.Text = "▼"
MainArrow.TextColor3 = Color3.fromRGB(220,170,0); MainArrow.Font = Enum.Font.SciFi; MainArrow.TextSize = 14

local MainTitle = Instance.new("TextLabel", MainTitleBar)
MainTitle.Size = UDim2.new(1,-110,1,0); MainTitle.Position = UDim2.new(0,30,0,0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "AngerMOD V2.0.0 || Roblox || FPS — --"
MainTitle.TextColor3 = Color3.fromRGB(220,170,0); MainTitle.Font = Enum.Font.SciFi
MainTitle.TextSize = 13; MainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- FPS рядом с заголовком
local FPSLabel = Instance.new("TextLabel", MainTitleBar)
FPSLabel.Size = UDim2.new(0,70,1,0); FPSLabel.Position = UDim2.new(1,-110,0,0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(0,220,100); FPSLabel.Font = Enum.Font.SciFi; FPSLabel.TextSize = 13

-- Кнопка закрыть X
local MainCloseBtn = Instance.new("TextButton", MainTitleBar)
MainCloseBtn.Size = UDim2.new(0,32,0,28); MainCloseBtn.Position = UDim2.new(1,-36,0,5)
MainCloseBtn.BackgroundColor3 = Color3.fromRGB(180,0,0); MainCloseBtn.BackgroundTransparency = 0.2
MainCloseBtn.Text = "✕"; MainCloseBtn.TextColor3 = Color3.new(1,1,1)
MainCloseBtn.Font = Enum.Font.SciFi; MainCloseBtn.TextSize = 16
Instance.new("UICorner", MainCloseBtn).CornerRadius = UDim.new(0,4)
MainCloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- TABS
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1,-10,0,30); TabFrame.Position = UDim2.new(0,5,0,44)
TabFrame.BackgroundTransparency = 1
local layoutTabs = Instance.new("UIListLayout", TabFrame)
layoutTabs.FillDirection = Enum.FillDirection.Horizontal; layoutTabs.Padding = UDim.new(0,4)

local function MakeTab(text)
    local b = Instance.new("TextButton", TabFrame)
    b.Size = UDim2.new(0.155,0,1,0)
    b.BackgroundColor3 = Color3.fromRGB(20,15,5)
    b.BackgroundTransparency = 0.2
    b.Text = text; b.TextColor3 = Color3.fromRGB(220,170,0)
    b.Font = Enum.Font.SciFi; b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    local bs = Instance.new("UIStroke", b); bs.Color = Color3.fromRGB(220,170,0); bs.Thickness = 1
    return b
end
local btnTabMain  = MakeTab("MAIN")
local btnTabInfo  = MakeTab("INFO")
local btnTabAI    = MakeTab("AI")
local btnTabWorld = MakeTab("WORLD")
local btnTabUI    = MakeTab("UI")
local btnTabMusic = MakeTab("MUSIC")

-- PAGES
local function MakePage(scrolling)
    local p
    if scrolling then
        p = Instance.new("ScrollingFrame", Main)
        p.ScrollBarThickness = 3
        p.ScrollBarImageColor3 = Color3.fromRGB(220,170,0)
        Instance.new("UIListLayout", p).Padding = UDim.new(0,6)
    else
        p = Instance.new("Frame", Main)
    end
    p.Size = UDim2.new(1,-10,1,-84); p.Position = UDim2.new(0,5,0,80)
    p.BackgroundTransparency = 1; p.Visible = false
    return p
end

local PageMain  = MakePage(true);  PageMain.Visible  = true
local PageInfo  = MakePage(false)
local PageAI    = MakePage(false)
local PageWorld = MakePage(false)
local PageUI    = MakePage(false)
local PageMusic = MakePage(true)

local function SwitchPage(target)
    for _, pg in ipairs({PageMain, PageInfo, PageAI, PageWorld, PageUI, PageMusic}) do
        pg.Visible = false
    end
    target.Visible = true
end
btnTabMain.MouseButton1Click:Connect(function()  SwitchPage(PageMain)  end)
btnTabInfo.MouseButton1Click:Connect(function()  SwitchPage(PageInfo)  end)
btnTabAI.MouseButton1Click:Connect(function()    SwitchPage(PageAI)    end)
btnTabWorld.MouseButton1Click:Connect(function() SwitchPage(PageWorld) end)
btnTabUI.MouseButton1Click:Connect(function()    SwitchPage(PageUI)    end)
btnTabMusic.MouseButton1Click:Connect(function() SwitchPage(PageMusic) end)

-- INFO PAGE
local InfoLabel = Instance.new("TextLabel", PageInfo)
InfoLabel.Size = UDim2.new(1,0,1,0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(220,170,0); InfoLabel.TextSize = 16
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top; InfoLabel.Font = Enum.Font.SciFi
InfoLabel.Text = "Loading..."

-- Стиль для кнопок меню (золотой/прозрачный)
local function styleGold(obj, r, t)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, r or 5)
    local s = Instance.new("UIStroke", obj)
    s.Color = Color3.fromRGB(220,170,0); s.Thickness = t or 1.5
    table.insert(RGB_Objects, {Type="Stroke", Instance=s})
    return s
end

local function MakeWorldBtn(parent, text, yp)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,0,0,40); b.Position = UDim2.new(0,0,yp,0)
    b.BackgroundColor3 = Color3.fromRGB(20,15,5); b.BackgroundTransparency = 0.2
    b.Text = text; b.TextColor3 = Color3.fromRGB(220,170,0)
    b.Font = Enum.Font.SciFi
    styleGold(b)
    return b
end

-- WORLD PAGE
local FogBtn     = MakeWorldBtn(PageWorld, "REMOVE FOG: OFF", 0)
local AmbientBtn = MakeWorldBtn(PageWorld, "AMBIENT SYNC: OFF", 0.1)
local SkyBox     = Instance.new("TextBox", PageWorld)
SkyBox.Size=UDim2.new(1,0,0,40); SkyBox.Position=UDim2.new(0,0,0.25,0)
SkyBox.PlaceholderText="CUSTOM SKY ID"; SkyBox.Text=""; SkyBox.BackgroundColor3=Color3.fromRGB(20,15,5)
SkyBox.BackgroundTransparency=0.2; SkyBox.TextColor3=Color3.fromRGB(220,170,0); SkyBox.Font=Enum.Font.SciFi
styleGold(SkyBox)
local SetSkyBtn   = MakeWorldBtn(PageWorld, "APPLY CUSTOM SKY", 0.35)
local SpaceSkyBtn = MakeWorldBtn(PageWorld, "SET SPACE SKY", 0.45)
local btnUp = MakeWorldBtn(PageWorld, "FLY UP", 0.6)
btnUp.Size = UDim2.new(0.48,0,0,40)
local btnDn = MakeWorldBtn(PageWorld, "FLY DOWN", 0.6)
btnDn.Size = UDim2.new(0.48,0,0,40); btnDn.Position = UDim2.new(0.52,0,0.6,0)

-- AI PAGE
local AIKeyBox = Instance.new("TextBox", PageAI)
AIKeyBox.Size=UDim2.new(1,0,0,40); AIKeyBox.Position=UDim2.new(0,0,0,0)
AIKeyBox.PlaceholderText="GROQ API KEY"; AIKeyBox.Text=""; AIKeyBox.BackgroundColor3=Color3.fromRGB(20,15,5)
AIKeyBox.BackgroundTransparency=0.2; AIKeyBox.TextColor3=Color3.fromRGB(220,170,0); AIKeyBox.Font=Enum.Font.SciFi
styleGold(AIKeyBox)

local ModelBtn   = MakeWorldBtn(PageAI, "MODEL: " .. GroqModels[CurrentModelIndex], 0)
ModelBtn.Position = UDim2.new(0,0,0.09,0)
local AIToggleBtn = MakeWorldBtn(PageAI, "AI AUTOREPLY: OFF", 0.19)
local FriendBtn   = MakeWorldBtn(PageAI, "FRIEND BOT: OFF", 0.29)
local RecBtn = Instance.new("TextButton", PageAI); RecBtn.Size=UDim2.new(0.48,0,0,40); RecBtn.Position=UDim2.new(0,0,0.49,0); RecBtn.BackgroundColor3=Color3.fromRGB(30,10,5); RecBtn.BackgroundTransparency=0.2; RecBtn.Text="RECORD"; RecBtn.TextColor3=Color3.fromRGB(220,170,0); RecBtn.Font=Enum.Font.SciFi; styleGold(RecBtn)
local PlayBtn2 = Instance.new("TextButton", PageAI); PlayBtn2.Size=UDim2.new(0.48,0,0,40); PlayBtn2.Position=UDim2.new(0.52,0,0.49,0); PlayBtn2.BackgroundColor3=Color3.fromRGB(5,30,10); PlayBtn2.BackgroundTransparency=0.2; PlayBtn2.Text="PLAY"; PlayBtn2.TextColor3=Color3.fromRGB(220,170,0); PlayBtn2.Font=Enum.Font.SciFi; styleGold(PlayBtn2)
local LoopBtn = MakeWorldBtn(PageAI, "LOOP PLAYBACK: OFF", 0.59)
local AIStatus = Instance.new("TextLabel", PageAI); AIStatus.Size=UDim2.new(1,0,0,30); AIStatus.Position=UDim2.new(0,0,0.71,0); AIStatus.BackgroundTransparency=1; AIStatus.Text="STATUS: IDLE"; AIStatus.TextColor3=Color3.fromRGB(150,150,150); AIStatus.Font=Enum.Font.SciFi; AIStatus.TextSize=14

-- UI PAGE
local UnlockBtn = MakeWorldBtn(PageUI, "UNLOCK MOVING: OFF", 0)
local SaveBtn   = MakeWorldBtn(PageUI, "SAVE CONFIG", 0.12)

-- MUSIC PAGE (scrolling)
local function MakeMusicBox(ph)
    local b = Instance.new("TextBox", PageMusic)
    b.Size=UDim2.new(1,0,0,40); b.PlaceholderText=ph; b.Text=""
    b.BackgroundColor3=Color3.fromRGB(20,15,5); b.BackgroundTransparency=0.2
    b.TextColor3=Color3.fromRGB(220,170,0); b.Font=Enum.Font.SciFi; b.TextSize=15
    styleGold(b); return b
end
local function MakeMusicBtn(text, bgc)
    local b = Instance.new("TextButton", PageMusic)
    b.Size=UDim2.new(1,0,0,40); b.Text=text
    b.BackgroundColor3=bgc or Color3.fromRGB(20,15,5); b.BackgroundTransparency=0.2
    b.TextColor3=Color3.fromRGB(220,170,0); b.Font=Enum.Font.SciFi; b.TextSize=15
    styleGold(b); return b
end
local MusicIDBox    = MakeMusicBox("ROBLOX AUDIO ID")
local PlayIDBtn     = MakeMusicBtn("▶ PLAY BY ID", Color3.fromRGB(5,25,5))
local YouTubeLinkBox = MakeMusicBox("YOUTUBE LINK OR VIDEO ID")
local PlayYTBtn     = MakeMusicBtn("🎵 PLAY FROM YOUTUBE", Color3.fromRGB(30,5,5))
local SearchBox     = MakeMusicBox("SEARCH MUSIC NAME")
local SearchBtn     = MakeMusicBtn("🔍 SEARCH MUSIC")
local StopMusicBtn  = MakeMusicBtn("⏹ STOP MUSIC", Color3.fromRGB(30,5,5))
local VolumeSlider  = MakeMusicBox("VOLUME (0-10)")
VolumeSlider.Text = "5"

-- TOGGLE BUTTON (вместо SideBtn — стрелка)
local SideBtn = Instance.new("TextButton", ScreenGui)
SideBtn.Name = "ToggleMenu"; SideBtn.Size = UDim2.new(0,44,0,44)
SideBtn.Position = UDim2.new(0,10,0.5,0)
SideBtn.BackgroundColor3 = Color3.fromRGB(20,15,5)
SideBtn.BackgroundTransparency = 0.2
SideBtn.Text = "☰"; SideBtn.TextColor3 = Color3.fromRGB(220,170,0)
SideBtn.Font = Enum.Font.SciFi; SideBtn.TextSize = 22
Instance.new("UICorner", SideBtn).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", SideBtn).Color = Color3.fromRGB(220,170,0)
table.insert(Movable_Objects, SideBtn)
SideBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- MUSIC WIDGET
local MusicWidget = Instance.new("Frame", ScreenGui)
MusicWidget.Size=UDim2.new(0,200,0,120); MusicWidget.Position=UDim2.new(1,-210,1,-130)
MusicWidget.BackgroundColor3=Color3.fromRGB(15,12,5); MusicWidget.BackgroundTransparency=0.15
MusicWidget.Visible=false; MusicWidget.Active=true; MusicWidget.Draggable=true
Instance.new("UICorner", MusicWidget).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke", MusicWidget).Color=Color3.fromRGB(220,170,0)
table.insert(Movable_Objects, MusicWidget)

local MusicIcon = Instance.new("ImageLabel",MusicWidget); MusicIcon.Size=UDim2.new(0,50,0,50); MusicIcon.Position=UDim2.new(0,10,0,10); MusicIcon.BackgroundTransparency=1; MusicIcon.Image="rbxassetid://6031265976"; table.insert(RGB_Objects,{Type="Image",Instance=MusicIcon})
local MusicTitle2 = Instance.new("TextLabel",MusicWidget); MusicTitle2.Size=UDim2.new(1,-70,0,25); MusicTitle2.Position=UDim2.new(0,65,0,10); MusicTitle2.BackgroundTransparency=1; MusicTitle2.Text="NO MUSIC"; MusicTitle2.TextColor3=Color3.fromRGB(220,170,0); MusicTitle2.Font=Enum.Font.SciFi; MusicTitle2.TextSize=13; MusicTitle2.TextXAlignment=Enum.TextXAlignment.Left; MusicTitle2.TextScaled=true
local MusicStatus = Instance.new("TextLabel",MusicWidget); MusicStatus.Size=UDim2.new(1,-70,0,20); MusicStatus.Position=UDim2.new(0,65,0,35); MusicStatus.BackgroundTransparency=1; MusicStatus.Text="IDLE"; MusicStatus.TextColor3=Color3.fromRGB(150,150,150); MusicStatus.Font=Enum.Font.SciFi; MusicStatus.TextSize=12; MusicStatus.TextXAlignment=Enum.TextXAlignment.Left
local BtnPlayPause = Instance.new("TextButton",MusicWidget); BtnPlayPause.Size=UDim2.new(0.3,-5,0,30); BtnPlayPause.Position=UDim2.new(0,10,1,-40); BtnPlayPause.Text="▶"; BtnPlayPause.BackgroundColor3=Color3.fromRGB(5,25,5); BtnPlayPause.TextColor3=Color3.fromRGB(220,170,0); BtnPlayPause.Font=Enum.Font.SciFi; BtnPlayPause.TextSize=14; styleGold(BtnPlayPause)
local BtnStop2 = Instance.new("TextButton",MusicWidget); BtnStop2.Size=UDim2.new(0.3,-5,0,30); BtnStop2.Position=UDim2.new(0.35,0,1,-40); BtnStop2.Text="⏹"; BtnStop2.BackgroundColor3=Color3.fromRGB(30,5,5); BtnStop2.TextColor3=Color3.fromRGB(220,170,0); BtnStop2.Font=Enum.Font.SciFi; BtnStop2.TextSize=14; styleGold(BtnStop2)
local BtnSkip = Instance.new("TextButton",MusicWidget); BtnSkip.Size=UDim2.new(0.3,-5,0,30); BtnSkip.Position=UDim2.new(0.7,0,1,-40); BtnSkip.Text="⏭"; BtnSkip.BackgroundColor3=Color3.fromRGB(5,5,30); BtnSkip.TextColor3=Color3.fromRGB(220,170,0); BtnSkip.Font=Enum.Font.SciFi; BtnSkip.TextSize=14; styleGold(BtnSkip)

-- ================================================================
-- [[ LOGIC ]]
-- ================================================================
local States = {
    Watermark=true, Aim=false, Hitbox=false, AntiKnockback=false, UnlockAll=false,
    SpdBypass=false, Fly=false, Spd=false, Jump=false, Circle=false, UsePentagram=false,
    Ghosts=false, Esp=false, RGB=false, Fullbright=false, InfJump=false, AntiAfk=true,
    NoFog=false, AmbientSync=false, AI=false, FriendBot=false, IsFollowing=true,
    IsRecording=false, IsPlaying=false, LoopPlay=false, KillAura=false
}
local valSmooth,valHitbox,valFlySpeed,valSpeed,valBypassSpeed,valJumpPower,valRipple,valGhostRate = 0.15,5,5,50,0.11,100,15,0.05
local up,down = false,false

local function EmergencyBrake()
    local char=Player.Character; if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity=Vector3.new(0,0,0); char.HumanoidRootPart.RotVelocity=Vector3.new(0,0,0) end
end

local function PlayMusic(audioId, title)
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy(); CurrentSound=nil end
    local char=Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then Notify("ERROR: NO CHARACTER"); return end
    CurrentSound=Instance.new("Sound"); CurrentSound.Parent=char.HumanoidRootPart
    CurrentSound.SoundId="rbxassetid://"..tostring(audioId); CurrentSound.Volume=tonumber(VolumeSlider.Text) or 5
    CurrentSound.Looped=true; CurrentSound.Playing=true
    local success=pcall(function() CurrentSound:Play() end)
    if success then
        MusicPlaying=true; MusicTitle2.Text=title or ("ID: "..tostring(audioId))
        MusicStatus.Text="♪ PLAYING"; MusicWidget.Visible=true; BtnPlayPause.Text="⏸"
        Notify("MUSIC: "..(title or tostring(audioId)))
    else
        Notify("ERROR: INVALID AUDIO ID"); if CurrentSound then CurrentSound:Destroy(); CurrentSound=nil end
    end
end

local function StopMusic()
    if CurrentSound then CurrentSound:Stop(); CurrentSound:Destroy(); CurrentSound=nil end
    MusicPlaying=false; MusicTitle2.Text="NO MUSIC"; MusicStatus.Text="⏹ STOPPED"; BtnPlayPause.Text="▶"; Notify("MUSIC STOPPED")
end

local function TogglePlayPause()
    if not CurrentSound then return end
    if MusicPlaying then CurrentSound:Pause(); MusicPlaying=false; MusicStatus.Text="⏸ PAUSED"; BtnPlayPause.Text="▶"
    else CurrentSound:Resume(); MusicPlaying=true; MusicStatus.Text="♪ PLAYING"; BtnPlayPause.Text="⏸" end
end

local function ExtractYouTubeID(link)
    local patterns={"youtube%.com/watch%?v=([%w-_]+)","youtu%.be/([%w-_]+)","youtube%.com/embed/([%w-_]+)","youtube%.com/v/([%w-_]+)"}
    for _,pattern in ipairs(patterns) do local id=string.match(link,pattern); if id then return id end end
    if string.match(link,"^[%w-_]+$") and #link==11 then return link end
    return nil
end

local function SearchYouTubeToRoblox(query)
    Notify("SEARCHING: "..query)
    task.spawn(function()
        if request then
            local ok,resp=pcall(function() return request({Url="https://www.roblox.com/audio/search?Keyword="..HttpService:UrlEncode(query),Method="GET"}) end)
            if ok and resp and resp.Body then
                local audioId=string.match(resp.Body,'data%-item%-id="(%d+)"')
                if audioId then PlayMusic(audioId,query) else Notify("NO RESULTS FOUND") end
            else Notify("SEARCH FAILED") end
        else Notify("HTTP NOT AVAILABLE") end
    end)
end

PlayIDBtn.MouseButton1Click:Connect(function()
    local id=MusicIDBox.Text:gsub("%s+",""); if id~="" then local n=id:match("%d+"); if n then PlayMusic(n,"Custom Audio") else Notify("INVALID ID") end else Notify("ENTER ID") end
end)
PlayYTBtn.MouseButton1Click:Connect(function()
    local link=YouTubeLinkBox.Text:gsub("%s+",""); if link~="" then local ytId=ExtractYouTubeID(link); if ytId then SearchYouTubeToRoblox(ytId) else Notify("INVALID YT LINK") end else Notify("ENTER YT LINK") end
end)
SearchBtn.MouseButton1Click:Connect(function()
    local q=SearchBox.Text:gsub("^%s*(.-)%s*$","%1"); if q~="" then SearchYouTubeToRoblox(q) else Notify("ENTER QUERY") end
end)
StopMusicBtn.MouseButton1Click:Connect(StopMusic)
BtnPlayPause.MouseButton1Click:Connect(TogglePlayPause)
BtnStop2.MouseButton1Click:Connect(StopMusic)
BtnSkip.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound.TimePosition=0; Notify("RESTARTED") end end)
VolumeSlider.FocusLost:Connect(function()
    local v=tonumber(VolumeSlider.Text); if v then v=math.clamp(v,0,10); VolumeSlider.Text=tostring(v); if CurrentSound then CurrentSound.Volume=v end else VolumeSlider.Text="5" end
end)

local function SmartMove(targetCF)
    local char=Player.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChild("Humanoid"); if not root or not hum then return end
    local car=nil; if hum.SeatPart then car=hum.SeatPart.Parent end
    if car and car:IsA("Model") then local mp=car.PrimaryPart or hum.SeatPart; mp.Velocity=Vector3.new(0,0,0); mp.CFrame=targetCF
    else root.CFrame=targetCF; root.Velocity=Vector3.new(0,0,0) end
end

local function SendChat(msg)
    if game:GetService("TextChatService").ChatVersion==Enum.ChatVersion.TextChatService then
        pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg) end)
    else game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All") end
end

btnUp.MouseButton1Down:Connect(function() up=true end); btnUp.MouseButton1Up:Connect(function() up=false end)
btnDn.MouseButton1Down:Connect(function() down=true end); btnDn.MouseButton1Up:Connect(function() down=false end)

local function makeBind(name,callback)
    local hb=Instance.new("TextButton",ScreenGui); hb.Name="Bind_"..name; hb.Size=UDim2.new(0,44,0,44)
    hb.Position=UDim2.new(0.85,0,0.4,0); hb.BackgroundColor3=Color3.fromRGB(15,12,5)
    hb.BackgroundTransparency=0.2; hb.Text=name:sub(1,3); hb.TextColor3=Color3.fromRGB(220,170,0)
    hb.Font=Enum.Font.SciFi; hb.Visible=false; hb.Active=UI_Unlocked; hb.Draggable=UI_Unlocked
    Instance.new("UICorner",hb).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",hb).Color=Color3.fromRGB(220,170,0)
    hb.MouseButton1Click:Connect(callback); table.insert(Movable_Objects,hb); return hb
end

-- THEME BTN
local btnTheme = Instance.new("TextButton", PageMain)
btnTheme.Size=UDim2.new(1,0,0,40); btnTheme.BackgroundColor3=Color3.fromRGB(20,15,5); btnTheme.BackgroundTransparency=0.2
btnTheme.Text="THEME: "..Themes[CurrentThemeIndex]; btnTheme.TextColor3=Color3.fromRGB(220,170,0); btnTheme.Font=Enum.Font.SciFi; btnTheme.TextSize=16
styleGold(btnTheme)
btnTheme.MouseButton1Click:Connect(function()
    CurrentThemeIndex=CurrentThemeIndex+1; if CurrentThemeIndex>#Themes then CurrentThemeIndex=1 end
    btnTheme.Text="THEME: "..Themes[CurrentThemeIndex]
end)

ModelBtn.MouseButton1Click:Connect(function()
    CurrentModelIndex=CurrentModelIndex+1; if CurrentModelIndex>#GroqModels then CurrentModelIndex=1 end
    ModelBtn.Text="MODEL: "..GroqModels[CurrentModelIndex]
end)

local function addOption(name, key, useInput, defaultInputVal, inputCallback)
    local f=Instance.new("Frame",PageMain); f.Size=UDim2.new(1,0,0,40); f.BackgroundTransparency=1
    local btnSize=useInput and 0.5 or 0.75
    local b=Instance.new("TextButton",f); b.Size=UDim2.new(btnSize,-5,1,0); b.Text=name
    b.BackgroundColor3=Color3.fromRGB(20,15,5); b.BackgroundTransparency=0.2
    b.TextColor3=Color3.fromRGB(220,170,0); b.Font=Enum.Font.SciFi; styleGold(b)
    if States[key] then b.BackgroundColor3=Color3.fromRGB(5,30,5) end
    local function Toggle()
        States[key]=not States[key]
        b.BackgroundColor3=States[key] and Color3.fromRGB(5,30,5) or Color3.fromRGB(20,15,5)
        Notify(name..(States[key] and " [ON]" or " [OFF]"))
    end
    local hk=makeBind(name,Toggle); b.MouseButton1Click:Connect(Toggle)
    local bb=Instance.new("TextButton",f); bb.Size=UDim2.new(0.25,0,1,0); bb.Position=UDim2.new(0.75,0,0,0)
    bb.Text="BIND"; bb.BackgroundColor3=Color3.fromRGB(20,15,5); bb.BackgroundTransparency=0.2
    bb.TextColor3=Color3.fromRGB(220,170,0); bb.Font=Enum.Font.SciFi; styleGold(bb)
    bb.MouseButton1Click:Connect(function() hk.Visible=not hk.Visible end)
    if useInput then
        local inp=Instance.new("TextBox",f); inp.Size=UDim2.new(0.25,-5,1,0); inp.Position=UDim2.new(0.5,0,0,0)
        inp.Text=tostring(defaultInputVal); inp.BackgroundColor3=Color3.fromRGB(15,12,5)
        inp.BackgroundTransparency=0.2; inp.TextColor3=Color3.fromRGB(220,170,0); inp.Font=Enum.Font.SciFi
        styleGold(inp,4,1)
        inp.FocusLost:Connect(function() local n=tonumber(inp.Text); if n then inputCallback(n) else inp.Text=tostring(defaultInputVal) end end)
    end
end

addOption("SHOW LOGO","Watermark",false)
addOption("HUMAN AIM","Aim",true,valSmooth,function(v) valSmooth=math.clamp(v,0.01,1) end)
addOption("ANTI KNOCKBACK","AntiKnockback",false)
addOption("INF ZOOM","UnlockAll",false)
addOption("SPEED BYPASS","SpdBypass",true,valBypassSpeed,function(v) valBypassSpeed=v end)
addOption("KILL AURA","KillAura",false)
addOption("BIG HITBOX","Hitbox",true,valHitbox,function(v) valHitbox=v end)
addOption("FLY BYPASS","Fly",true,valFlySpeed,function(v) valFlySpeed=v end)
addOption("RAGE SPEED","Spd",true,valSpeed,function(v) valSpeed=v end)
addOption("SUPER JUMP","Jump",true,valJumpPower,function(v) valJumpPower=v end)
addOption("JUMP RIPPLE","Circle",true,valRipple,function(v) valRipple=v end)
addOption("PENTAGRAM MODE","UsePentagram",false)
addOption("GHOST TRAIL","Ghosts",true,valGhostRate,function(v) valGhostRate=math.clamp(v,0.01,2) end)
addOption("ESP HIGHLIGHT","Esp",false)
addOption("SKIN COLOR","RGB",false)
addOption("FULLBRIGHT","Fullbright",false)
addOption("INF JUMP","InfJump",false)

-- UI EDITOR
UnlockBtn.MouseButton1Click:Connect(function()
    UI_Unlocked=not UI_Unlocked; UnlockBtn.Text=UI_Unlocked and "UNLOCK MOVING: ON" or "UNLOCK MOVING: OFF"
    for _,obj in pairs(Movable_Objects) do obj.Active=UI_Unlocked; obj.Draggable=UI_Unlocked end
end)
local ConfigName="AngerConfig_V200.json"
SaveBtn.MouseButton1Click:Connect(function()
    local data={}; for _,obj in pairs(Movable_Objects) do data[obj.Name]={X_S=obj.Position.X.Scale,X_O=obj.Position.X.Offset,Y_S=obj.Position.Y.Scale,Y_O=obj.Position.Y.Offset} end
    if writefile then writefile(ConfigName,HttpService:JSONEncode(data)); SaveBtn.Text="SAVED!"; task.wait(1); SaveBtn.Text="SAVE CONFIG" end
end)
task.spawn(function() if isfile and isfile(ConfigName) then local data=HttpService:JSONDecode(readfile(ConfigName)); for _,obj in pairs(Movable_Objects) do if data[obj.Name] then obj.Position=UDim2.new(data[obj.Name].X_S,data[obj.Name].X_O,data[obj.Name].Y_S,data[obj.Name].Y_O) end end end end)

-- WORLD
FogBtn.MouseButton1Click:Connect(function()
    States.NoFog=not States.NoFog; FogBtn.Text=States.NoFog and "REMOVE FOG: ON" or "REMOVE FOG: OFF"
    if not States.NoFog then Lighting.FogEnd=1000 end; Notify("NO FOG"..(States.NoFog and " [ON]" or " [OFF]"))
end)
AmbientBtn.MouseButton1Click:Connect(function()
    States.AmbientSync=not States.AmbientSync; AmbientBtn.Text=States.AmbientSync and "AMBIENT SYNC: ON" or "AMBIENT SYNC: OFF"
    Notify("AMBIENT"..(States.AmbientSync and " [ON]" or " [OFF]"))
end)
local function SetSky(id)
    local sky=Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky",Lighting)
    local tex="rbxassetid://"..tostring(id)
    sky.SkyboxBk,sky.SkyboxDn,sky.SkyboxFt,sky.SkyboxLf,sky.SkyboxRt,sky.SkyboxUp=tex,tex,tex,tex,tex,tex
    Notify("CUSTOM SKY: "..tostring(id))
end
SetSkyBtn.MouseButton1Click:Connect(function() local id=SkyBox.Text:gsub("%s+",""):match("%d+"); if id then SetSky(id) else Notify("INVALID SKY ID") end end)
SpaceSkyBtn.MouseButton1Click:Connect(function() SetSky("159454299") end)

-- MACRO
RecBtn.MouseButton1Click:Connect(function()
    States.IsRecording=not States.IsRecording
    if States.IsRecording then
        States.IsPlaying=false; RecordedPath={}; RecBtn.Text="STOP REC"; AIStatus.Text="STATUS: RECORDING..."; Notify("RECORDING STARTED")
    else RecBtn.Text="RECORD"; AIStatus.Text="STATUS: SAVED "..#RecordedPath.." FRAMES"; Notify("RECORDING STOPPED") end
end)

local function StartPlayback()
    if #RecordedPath==0 then AIStatus.Text="ERROR: NO RECORDING"; States.IsPlaying=false; return end
    local char=Player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChild("Humanoid")
    if root and hum then hum.PlatformStand=true; root.Anchored=true end
    task.spawn(function()
        while States.IsPlaying do
            for _,frame in ipairs(RecordedPath) do if not States.IsPlaying then break end; SmartMove(frame.CF); RunService.Heartbeat:Wait() end
            if not States.LoopPlay then States.IsPlaying=false; PlayBtn2.Text="PLAY"; Notify("PLAYBACK ENDED"); break end
        end
        if Player.Character then
            local r=Player.Character:FindFirstChild("HumanoidRootPart"); local h=Player.Character:FindFirstChild("Humanoid")
            if r then r.Anchored=false; r.Velocity=Vector3.zero end; if h then h.PlatformStand=false end
        end
        AIStatus.Text="STATUS: IDLE"
    end)
end

PlayBtn2.MouseButton1Click:Connect(function()
    States.IsPlaying=not States.IsPlaying
    if States.IsPlaying then
        States.IsRecording=false; RecBtn.Text="RECORD"; PlayBtn2.Text="STOP PLAY"; Notify("PLAYBACK STARTED"); StartPlayback()
    else PlayBtn2.Text="PLAY"; EmergencyBrake(); Notify("PLAYBACK STOPPED") end
end)
LoopBtn.MouseButton1Click:Connect(function()
    States.LoopPlay=not States.LoopPlay; LoopBtn.Text=States.LoopPlay and "LOOP PLAYBACK: ON" or "LOOP PLAYBACK: OFF"
    Notify("LOOP"..(States.LoopPlay and " [ON]" or " [OFF]"))
end)

-- AI GROQ
local AI_Debounce=false
AIToggleBtn.MouseButton1Click:Connect(function()
    States.AI=not States.AI; AIToggleBtn.Text=States.AI and "AI AUTOREPLY: ON" or "AI AUTOREPLY: OFF"
    Notify("AI CHAT"..(States.AI and " [ON]" or " [OFF]")); if States.AI then SendChat("AngerMOD: Модуль чата активен.") end
end)
FriendBtn.MouseButton1Click:Connect(function()
    States.FriendBot=not States.FriendBot; FriendBtn.Text=States.FriendBot and "FRIEND BOT: ON" or "FRIEND BOT: OFF"
    Notify("FRIEND BOT"..(States.FriendBot and " [ON]" or " [OFF]")); if States.FriendBot then SendChat("Я теперь твой хвостик!") end
end)

local function ExecuteCommand(msg)
    local m=string.lower(msg); local char=Player.Character; local hum=char and char:FindFirstChild("Humanoid")
    if string.find(m,"сядь") then if hum then hum.Sit=true end; return true
    elseif string.find(m,"встань") then if hum then hum.Sit=false; hum.Jump=true end; return true
    elseif string.find(m,"стой") then States.IsFollowing=false; EmergencyBrake(); return true
    elseif string.find(m,"ко мне") then States.IsFollowing=true; return true end
    return false
end

local function ProcessAI(msg,senderName)
    if AI_Debounce then return end
    if States.FriendBot and ExecuteCommand(msg) then return end
    if not States.AI then return end
    AI_Debounce=true; AIStatus.Text="STATUS: THINKING..."
    local apiKey=AIKeyBox.Text; if apiKey=="" then AIStatus.Text="ERROR: NO KEY"; AI_Debounce=false; return end
    table.insert(ChatHistory,{role="user",content=senderName..": "..msg})
    if #ChatHistory>10 then table.remove(ChatHistory,2) end
    local ok,response=pcall(function()
        if request then return request({
            Url="https://api.groq.com/openai/v1/chat/completions",Method="POST",
            Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..apiKey},
            Body=HttpService:JSONEncode({model=GroqModels[CurrentModelIndex],messages=ChatHistory,max_tokens=60})
        }) end
    end)
    if ok and response and response.Body then
        local data=HttpService:JSONDecode(response.Body)
        if data.choices and data.choices[1] then
            local reply=data.choices[1].message.content; SendChat(reply)
            table.insert(ChatHistory,{role="assistant",content=reply}); AIStatus.Text="STATUS: REPLIED"
        else AIStatus.Text="ERROR: API FAIL" end
    else AIStatus.Text="ERROR: REQUEST FAIL" end
    task.wait(2); AI_Debounce=false; task.wait(1); AIStatus.Text="STATUS: WAITING..."
end
for _,p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(msg) if p~=Player then ProcessAI(msg,p.Name) end end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg) if p~=Player then ProcessAI(msg,p.Name) end end) end)

-- VISUALS
local function SpawnRipple()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root=Player.Character.HumanoidRootPart; local ray=workspace:Raycast(root.Position,Vector3.new(0,-10,0),RaycastParams.new())
    local spawnPos=ray and ray.Position or (root.Position-Vector3.new(0,2.8,0)); local p=Instance.new("Part",workspace); p.Name="AngerRipple"; p.Anchored=true; p.CanCollide=false
    if States.UsePentagram then
        p.Transparency=1; p.Size=Vector3.new(1,0.05,1); p.CFrame=CFrame.new(spawnPos); local sg=Instance.new("SurfaceGui",p); sg.Face=Enum.NormalId.Top; sg.LightInfluence=0; sg.AlwaysOnTop=false; local img=Instance.new("ImageLabel",sg); img.Size=UDim2.new(1,0,1,0); img.BackgroundTransparency=1; img.ImageColor3=Color3.new(1,1,1)
        local s,a=pcall(function() return getcustomasset("Anger_Pentagram_Circle1.png") end)
        if s then img.Image=a else img.Image="rbxassetid://0" end
        table.insert(RGB_Objects,{Type="Image",Instance=img}); TweenService:Create(p,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(valRipple,0.05,valRipple)}):Play(); TweenService:Create(img,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{ImageTransparency=1}):Play(); Debris:AddItem(p,1.5)
    else
        p.Shape=Enum.PartType.Cylinder; p.Material=Enum.Material.Neon; p.Size=Vector3.new(0.1,1,1); p.CFrame=CFrame.new(spawnPos)*CFrame.Angles(0,0,math.rad(90)); p.Color=Color3.new(1,1,1); table.insert(RGB_Objects,{Type="Part",Instance=p}); TweenService:Create(p,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(0.1,valRipple,valRipple),Transparency=1}):Play(); Debris:AddItem(p,1)
    end
end

local function GetClosestPlayer()
    local target=nil; local dist=math.huge
    for _,v in pairs(Players:GetPlayers()) do
        if v~=Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
            local d=(v.Character.Head.Position-Camera.CFrame.Position).Magnitude
            if d<dist then dist=d; target=v.Character end
        end
    end; return target
end

Player.CharacterAdded:Connect(function(char)
    DeathScreen.Enabled=false
    char:WaitForChild("Humanoid").Died:Connect(function() DeathScreen.Enabled=true end)
end)

-- ESP
local function CreateESPLine(player)
    if ESPLines[player] then return end
    local line=Drawing.new("Line"); line.Visible=false; line.Color=Color3.fromRGB(220,170,0); line.Thickness=2; line.Transparency=0.8; ESPLines[player]=line
end
local function UpdateESPLines(activeColor)
    for player,line in pairs(ESPLines) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and States.Esp then
            local char=player.Character; local rootPart=char.HumanoidRootPart
            local vector,onScreen=Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); line.To=Vector2.new(vector.X,vector.Y); line.Color=activeColor; line.Visible=true
            else line.Visible=false end
        else line.Visible=false end
    end
end
for _,player in pairs(Players:GetPlayers()) do if player~=Player then CreateESPLine(player) end end
Players.PlayerAdded:Connect(function(player) CreateESPLine(player) end)
Players.PlayerRemoving:Connect(function(player) if ESPLines[player] then ESPLines[player]:Remove(); ESPLines[player]=nil end end)

-- RENDER LOOP
local lastGhostTime=0
RunService.RenderStepped:Connect(function()
    pcall(function()
        local tickTime=tick(); local currentThemeName=Themes[CurrentThemeIndex]; local activeColor=Color3.new(1,1,1)
        if currentThemeName=="RGB" then activeColor=Color3.fromHSV(tickTime%3/3,1,1) elseif ThemeColors[currentThemeName] then activeColor=ThemeColors[currentThemeName] end
        if States.AmbientSync then Lighting.OutdoorAmbient=activeColor; Lighting.Ambient=activeColor end
        if States.NoFog then Lighting.FogEnd=1000000; Lighting.FogStart=1000000 end
        DeathLabel.TextColor3=activeColor

        -- FPS в заголовке
        local fps=math.floor(workspace:GetRealPhysicsFPS())
        MainTitle.Text="AngerMOD V2.0.0 || Roblox || FPS — "..fps
        FPSLabel.Text="FPS: "..fps

        for i,obj in pairs(RGB_Objects) do
            if obj.Instance and obj.Instance.Parent then
                if obj.Type=="Stroke" then obj.Instance.Color=activeColor
                elseif obj.Type=="Text" then obj.Instance.TextColor3=activeColor
                elseif obj.Type=="Image" then obj.Instance.ImageColor3=activeColor
                elseif obj.Type=="Part" then obj.Instance.Color=activeColor end
            else table.remove(RGB_Objects,i) end
        end

        UpdateESPLines(activeColor)

        local wm=ScreenGui.Parent:FindFirstChild("AngerWatermark"); if wm then wm.Enabled=States.Watermark end
        if PageInfo.Visible then InfoLabel.Text=string.format("SESSION:\nUser: %s\nDevice: %s\nID: %s\nFPS: %d\nPing: %d ms",Player.Name,DeviceInfo,SessionID,fps,math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) end

        local char=Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hum=char:FindFirstChild("Humanoid"); local root=char:FindFirstChild("HumanoidRootPart")

        if States.AntiKnockback then
            if root.Velocity.Magnitude>25 then
                if hum.MoveDirection.Magnitude>0 then root.Velocity=hum.MoveDirection*hum.WalkSpeed else root.Velocity=Vector3.new(0,0,0) end
                root.RotVelocity=Vector3.new(0,0,0)
            end
        end
        if States.Aim then local target=GetClosestPlayer(); if target and target:FindFirstChild("Head") then Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,target.Head.Position),valSmooth) end end
        if States.IsRecording then local pos=root.CFrame; if hum and hum.SeatPart then pos=hum.SeatPart.CFrame end; table.insert(RecordedPath,{CF=pos}) end
        if States.UnlockAll then Player.CameraMaxZoomDistance=100000; Player.CameraMinZoomDistance=0; if Player.CameraMode~=Enum.CameraMode.Classic then Player.CameraMode=Enum.CameraMode.Classic end end
        if States.SpdBypass and hum.MoveDirection.Magnitude>0 then root.CFrame=root.CFrame+(hum.MoveDirection*valBypassSpeed) end
        if States.Fly and root and hum then root.Velocity=Vector3.new(0,0.1,0); if hum.MoveDirection.Magnitude>0 then root.CFrame=root.CFrame+(hum.MoveDirection*valFlySpeed) end; if up then root.CFrame=root.CFrame*CFrame.new(0,valFlySpeed,0) end; if down then root.CFrame=root.CFrame*CFrame.new(0,-valFlySpeed,0) end end
        if States.KillAura then local tool=char:FindFirstChildOfClass("Tool"); if tool and tool:FindFirstChild("Handle") then for _,v in pairs(game.Players:GetPlayers()) do if v~=Player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health>0 then local dist=(v.Character.Head.Position-root.Position).Magnitude; if dist<50 then tool.Handle.CFrame=v.Character.Head.CFrame; tool:Activate(); pcall(function() firetouchinterest(tool.Handle,v.Character.Head,0); firetouchinterest(tool.Handle,v.Character.Head,1) end); break end end end end end
        if States.Ghosts and tick()-lastGhostTime>valGhostRate then lastGhostTime=tick(); for _,v in pairs(char:GetChildren()) do if v:IsA("BasePart") and v.Transparency<1 then local g=v:Clone(); g.Parent=workspace; g.Anchored=true; g.CanCollide=false; g.CFrame=v.CFrame; g.Color=activeColor; g.Material=Enum.Material.Neon; g:ClearAllChildren(); TweenService:Create(g,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=1,CFrame=g.CFrame*CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),0),Size=g.Size*1.1}):Play(); Debris:AddItem(g,0.5) end end end
        if States.Spd and hum.MoveDirection.Magnitude>0 then root.CFrame+=(hum.MoveDirection*(0.5*valSpeed)) end
        if States.Jump then hum.UseJumpPower=true; hum.JumpPower=valJumpPower else hum.JumpPower=50 end
        if States.Esp then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v~=Player and v.Character then
                    if not v.Character:FindFirstChild("AngerESP") then local hl=Instance.new("Highlight",v.Character); hl.Name="AngerESP"; hl.FillTransparency=0.5; hl.OutlineTransparency=0
                    else v.Character.AngerESP.FillColor=activeColor end
                end
            end
        else for _,v in pairs(game.Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("AngerESP") then v.Character.AngerESP:Destroy() end end end
        for _,v in pairs(game.Players:GetPlayers()) do
            if v~=Player and v.Character and v.Character:FindFirstChild("Head") then
                local head=v.Character.Head
                if States.Hitbox then head.Size=Vector3.new(valHitbox,valHitbox,valHitbox); head.Transparency=0.7; head.CanCollide=false; head.Color=activeColor; head.Material=Enum.Material.Neon
                else head.Size=Vector3.new(1,1,1); head.Transparency=0 end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if States.InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    if States.Circle then SpawnRipple() end
end)
Player.Idled:Connect(function() if States.AntiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

-- ASSETS
task.spawn(function()
    local urlLogo="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/AngerMOD.png"
    local fileLogo="AngerMOD_Logo_V200.png"
    if writefile and readfile then pcall(function() if not isfile(fileLogo) then writefile(fileLogo,game:HttpGet(urlLogo)) end end) end
    local lg=Instance.new("ScreenGui",ScreenGui.Parent); lg.Name="AngerWatermark"
    local im=Instance.new("ImageLabel",lg); im.Size=UDim2.new(0,200,0,100); im.Position=UDim2.new(0,10,0,10); im.BackgroundTransparency=1; im.BorderSizePixel=0
    local stroke=Instance.new("UIStroke",im); stroke.Thickness=3; stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; stroke.Color=Color3.fromRGB(220,170,0)
    table.insert(RGB_Objects,{Type="Stroke",Instance=stroke})
    local s,a=pcall(function() return getcustomasset(fileLogo) end); if s then im.Image=a else im.Image=urlLogo end
end)
task.spawn(function()
    local pentagramUrl="https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/circle1.png"
    local pentagramName="Anger_Pentagram_Circle1.png"
    if writefile and readfile and isfile then pcall(function() if not isfile(pentagramName) then writefile(pentagramName,game:HttpGet(pentagramUrl)) end end) end
end)

Notify("⛧ AngerMOD V2.0.0 LOADED ⛧")

end -- конец StartAngerMOD()

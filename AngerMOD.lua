-- [[ ⛧ AngerPC ⛧ V128 MICRO (TG-BOT + LOGIN) ]] --
local P = game.Players.LocalPlayer
local Http = game:GetService("HttpService")
local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
local CG = P:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- СУПЕР-ФУНКЦИЯ: Сокращает код интерфейса в 10 раз
local function C(cls, prop, parent)
    local i = Instance.new(cls)
    for k, v in pairs(prop) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- [[ 1. LOGIN SYSTEM ]] --
local LogGui = C("ScreenGui", {Name="AngerLogin", ResetOnSpawn=false}, CG)
local LogF = C("Frame", {Size=UDim2.new(0,300,0,150), Position=UDim2.new(0.5,-150,0.5,-75), BackgroundColor3=Color3.fromRGB(15,15,15)}, LogGui)
C("UICorner", {CornerRadius=UDim.new(0,8)}, LogF)
C("UIStroke", {Color=Color3.fromRGB(255,0,0), Thickness=2}, LogF)
C("TextLabel", {Size=UDim2.new(1,0,0,40), Text="AngerMOD V128", TextColor3=Color3.new(1,1,1), BackgroundTransparency=1, Font=Enum.Font.SciFi, TextSize=20}, LogF)

local KeyBox = C("TextBox", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.35,0), PlaceholderText="ENTER KEY...", BackgroundColor3=Color3.fromRGB(30,30,30), TextColor3=Color3.new(1,1,1)}, LogF)
local LogBtn = C("TextButton", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.65,0), Text="VERIFY KEY", BackgroundColor3=Color3.fromRGB(50,10,10), TextColor3=Color3.new(1,1,1)}, LogF)

local function LoadMain()
    LogGui:Destroy()

    -- [[ 2. MAIN TG-GUI ]] --
    local MainGui = C("ScreenGui", {Name="AngerMain"}, CG)
    local Main = C("Frame", {Size=UDim2.new(0,350,0,300), Position=UDim2.new(0.1,0,0.2,0), BackgroundColor3=Color3.fromRGB(15,15,15), Active=true, Draggable=true}, MainGui)
    C("UICorner", {CornerRadius=UDim.new(0,8)}, Main)
    C("UIStroke", {Color=Color3.fromRGB(60,60,60), Thickness=2}, Main)
    C("TextLabel", {Size=UDim2.new(1,0,0,40), Text="TG-BOT MENU", TextColor3=Color3.new(1,1,1), BackgroundTransparency=1, Font=Enum.Font.SciFi, TextSize=20}, Main)

    local TBox = C("TextBox", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.15,0), PlaceholderText="BOT TOKEN", BackgroundColor3=Color3.fromRGB(20,20,20), TextColor3=Color3.new(1,1,1)}, Main)
    local CBox = C("TextBox", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.3,0), PlaceholderText="CHAT ID", BackgroundColor3=Color3.fromRGB(20,20,20), TextColor3=Color3.new(1,1,1)}, Main)
    local RBtn = C("TextButton", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.5,0), Text="TG -> ROBLOX: OFF", BackgroundColor3=Color3.fromRGB(30,10,10), TextColor3=Color3.new(1,1,1)}, Main)
    local SBtn = C("TextButton", {Size=UDim2.new(0.9,0,0,40), Position=UDim2.new(0.05,0,0.65,0), Text="ROBLOX -> TG: OFF", BackgroundColor3=Color3.fromRGB(30,10,10), TextColor3=Color3.new(1,1,1)}, Main)

    local rOn, sOn, off = false, false, 0

    -- Функция вывода в чат игры
    local function sendChat(m)
        local tcs = game:GetService("TextChatService")
        if tcs.ChatVersion == Enum.ChatVersion.TextChatService then pcall(function() tcs.TextChannels.RBXGeneral:SendAsync(m) end)
        else game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(m, "All") end
    end

    -- Переключатели
    RBtn.MouseButton1Click:Connect(function() rOn = not rOn; RBtn.Text = "TG -> ROBLOX: "..(rOn and "ON" or "OFF"); RBtn.BackgroundColor3 = rOn and Color3.fromRGB(10,50,10) or Color3.fromRGB(30,10,10) end)
    SBtn.MouseButton1Click:Connect(function() sOn = not sOn; SBtn.Text = "ROBLOX -> TG: "..(sOn and "ON" or "OFF"); SBtn.BackgroundColor3 = sOn and Color3.fromRGB(10,50,10) or Color3.fromRGB(30,10,10) end)

    -- Кнопка Окрыть/Закрыть сбоку
    local TogBtn = C("TextButton", {Size=UDim2.new(0,50,0,50), Position=UDim2.new(0,10,0.5,0), Text="O/C", BackgroundColor3=Color3.fromRGB(20,20,20), TextColor3=Color3.new(1,1,1)}, MainGui)
    TogBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- [[ 3. TG LOGIC ]] --
    
    -- Получение сообщений (TG -> Игра)
    task.spawn(function()
        while task.wait(2.5) do
            if rOn and TBox.Text ~= "" and req then
                pcall(function()
                    local res = req({Url="https://api.telegram.org/bot"..TBox.Text.."/getUpdates?offset="..off, Method="GET"})
                    local d = Http:JSONDecode(res.Body)
                    if d.ok then for _, u in pairs(d.result) do off = u.update_id + 1; if u.message and u.message.text then sendChat("[TG] "..(u.message.from.first_name or "User")..": "..u.message.text) end end end
                end)
            end
        end
    end)

    -- Отправка сообщений (Игра -> TG)
    P.Chatted:Connect(function(m)
        if sOn and TBox.Text ~= "" and CBox.Text ~= "" and req and not m:find("[TG]") then
            task.spawn(function() req({Url="https://api.telegram.org/bot"..TBox.Text.."/sendMessage", Method="POST", Headers={["Content-Type"]="application/json"}, Body=Http:JSONEncode({chat_id=CBox.Text, text=P.Name..": "..m})}) end)
        end
    end)
end

-- [[ ПРОВЕРКА КЛЮЧА ИЗ GITHUB ]] --
LogBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "" then LogBtn.Text = "ENTER KEY!"; return end
    LogBtn.Text = "CHECKING..."
    task.spawn(function()
        local s, r = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/AngerPC-DEV/AngerMOD/main/key.json") end)
        if s then
            local keys, valid = Http:JSONDecode(r), false
            for _, k in pairs(keys) do if k == KeyBox.Text then valid = true break end end
            if valid then LogBtn.Text = "SUCCESS!"; task.wait(1); LoadMain() else LogBtn.Text = "INVALID KEY" end
        else LogBtn.Text = "ERROR API" end
    end)
end)

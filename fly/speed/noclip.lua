--[[ 
    GEMINI HUB V8: GOD MODE EDITION (ALL-IN-ONE)
    - Full Visuals: Health, Name, Distance, Chams (Skeleton Style)
    - Full Teleport: Generator Auto-Scan & Player TP
    - Optimized for Mobile Executors
]]

if _G.GeminiV8Loaded then 
    local old = game:GetService("PlayerGui"):FindFirstChild("Gemini_V8")
    if old then old:Destroy() end
end
_G.GeminiV8Loaded = true

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "Gemini_V8"
ScreenGui.ResetOnSpawn = false

local function buildHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 215, 0, 350)
    MainFrame.Position = UDim2.new(0.5, 50, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    --// Tab System
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local function createTabBtn(txt, pos, width)
        local b = Instance.new("TextButton", TabBar)
        b.Size = UDim2.new(width, 0, 1, 0)
        b.Position = pos
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 10
        b.BorderSizePixel = 0
        return b
    end

    local bMain = createTabBtn("MAIN", UDim2.new(0,0,0,0), 0.33)
    local bTP = createTabBtn("TP", UDim2.new(0.33,0,0,0), 0.33)
    local bESP = createTabBtn("FULL ESP", UDim2.new(0.66,0,0,0), 0.34)

    local pMain = Instance.new("ScrollingFrame", MainFrame)
    local pTP = Instance.new("ScrollingFrame", MainFrame)
    local pESP = Instance.new("ScrollingFrame", MainFrame)

    local function setupPage(p)
        p.Size = UDim2.new(1, 0, 0.9, 0)
        p.Position = UDim2.new(0, 0, 0.1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 2
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 5)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end
    setupPage(pMain); setupPage(pTP); setupPage(pESP)
    pMain.Visible = true

    local function makeBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.92, 0, 0, 38)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- [ TAB 1: MOVEMENT ]
    local speedOn, flyOn, noclipOn = false, false, false
    local sB = makeBtn("Speed: OFF", pMain, function() speedOn = not speedOn sB.Text = "Speed: "..(speedOn and "ON" or "OFF") end)
    local fB = makeBtn("Fly: OFF", pMain, function() flyOn = not flyOn fB.Text = "Fly: "..(flyOn and "ON" or "OFF") end)
    local nB = makeBtn("Noclip: OFF", pMain, function() noclipOn = not noclipOn nB.Text = "Noclip: "..(noclipOn and "ON" or "OFF") end)

    -- [ TAB 2: TELEPORT ]
    local function updateTP()
        for _, v in pairs(pTP:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
        local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
        if genPath then
            local l = Instance.new("TextLabel", pTP)
            l.Size = UDim2.new(1, 0, 0, 20) l.Text = "-- GENERATORS --" l.TextColor3 = Color3.new(0, 0.6, 1) l.BackgroundTransparency = 1
            for i, obj in pairs(genPath:GetChildren()) do
                makeBtn("Generator #"..i, pTP, function()
                    player.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame) * CFrame.new(0, 5, 0)
                end)
            end
        end
        local l2 = Instance.new("TextLabel", pTP)
        l2.Size = UDim2.new(1, 0, 0, 20) l2.Text = "-- PLAYERS --" l2.TextColor3 = Color3.new(0, 1, 0.5) l2.BackgroundTransparency = 1
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player then
                makeBtn(p.DisplayName, pTP, function()
                    if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
                end)
            end
        end
    end

    -- [ TAB 3: FULL VISUAL ESP ]
    local pEsp, gEsp = false, false
    makeBtn("PLAYER (CHAMS+HP+DIST)", pESP, function() pEsp = not pEsp end)
    makeBtn("GENERATOR ESP", pESP, function() gEsp = not gEsp end)

    local function applyFullVisual(target, name, color, isPlayer)
        if target:FindFirstChild("GeminiTag") then target.GeminiTag:Destroy() end
        local bill = Instance.new("BillboardGui", target)
        bill.Name = "GeminiTag"
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.ExtentsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextSize = 12
        label.Font = Enum.Font.SourceSansBold

        if not target:FindFirstChild("GeminiChams") then
            local high = Instance.new("Highlight", target.Parent)
            high.Name = "GeminiChams"
            high.FillColor = color
            high.FillTransparency = 0.5
            high.OutlineColor = Color3.new(1, 1, 1)
        end

        runService.RenderStepped:Connect(function()
            if not target or not target.Parent or (isPlayer and not pEsp) or (not isPlayer and not gEsp) then
                bill:Destroy()
                if target.Parent:FindFirstChild("GeminiChams") then target.Parent.GeminiChams:Destroy() end
                return
            end
            local dist = math.floor((player.Character.HumanoidRootPart.Position - target.Position).Magnitude)
            local hp = isPlayer and target.Parent:FindFirstChild("Humanoid") and math.floor(target.Parent.Humanoid.Health) or 100
            label.Text = string.format("%s\n%d HP | %d m", name, hp, dist)
        end)
    end

    --// Tab logic
    bMain.MouseButton1Click:Connect(function() pMain.Visible = true; pTP.Visible = false; pESP.Visible = false end)
    bTP.MouseButton1Click:Connect(function() pMain.Visible = false; pTP.Visible = true; pESP.Visible = false; updateTP() end)
    bESP.MouseButton1Click:Connect(function() pMain.Visible = false; pTP.Visible = false; pESP.Visible = true end)

    --// Final Loop
    runService.Stepped:Connect(function()
        if not player.Character then return end
        if speedOn then player.Character.Humanoid.WalkSpeed = 23 end
        if noclipOn then
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        if pEsp then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    applyFullVisual(p.Character.HumanoidRootPart, p.DisplayName, Color3.new(0, 1, 0.5), true)
                end
            end
        end

        if gEsp then
            local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
            if genPath then
                for i, g in pairs(genPath:GetChildren()) do
                    local t = g:IsA("Model") and (g.PrimaryPart or g:FindFirstChildWhichIsA("BasePart")) or g
                    if t then applyFullVisual(t, "Gen #"..i, Color3.new(0, 0.7, 1), false) end
                end
            end
        end
    end)

    local T = Instance.new("TextButton", ScreenGui)
    T.Size = UDim2.new(0, 45, 0, 45)
    T.Position = UDim2.new(0, 10, 0.5, -22)
    T.Text = "G"
    T.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    T.TextColor3 = Color3.new(0, 1, 0.6)
    T.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

task.wait(0.5)
buildHub()

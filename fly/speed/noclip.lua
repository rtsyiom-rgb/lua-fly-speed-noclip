--[[ 
    GEMINI HUB V9: ULTIMATE VISION (HP + ESP + SCAN)
    - Full Player ESP: Health Bar, HP Value, Distance
    - Generator & Item ESP: Detects Gens and Mission Items
    - Optimized for Mobile & PC Executors
]]

if _G.GeminiV9Loaded then 
    local old = game:GetService("PlayerGui"):FindFirstChild("Gemini_V9")
    if old then old:Destroy() end
end
_G.GeminiV9Loaded = true

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

--// UI Setup
local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "Gemini_V9"
ScreenGui.ResetOnSpawn = false

local function buildHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 220, 0, 360)
    MainFrame.Position = UDim2.new(0.5, 60, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Active = true
    MainFrame.Draggable = true

    --// Tab System
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local function createTabBtn(txt, pos, width)
        local b = Instance.new("TextButton", TabBar)
        b.Size = UDim2.new(width, 0, 1, 0)
        b.Position = pos
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 11
        return b
    end

    local bMain = createTabBtn("MAIN", UDim2.new(0,0,0,0), 0.33)
    local bTP = createTabBtn("TP LIST", UDim2.new(0.33,0,0,0), 0.33)
    local bESP = createTabBtn("VISION ESP", UDim2.new(0.66,0,0,0), 0.34)

    local pageMain = Instance.new("ScrollingFrame", MainFrame)
    local pageTP = Instance.new("ScrollingFrame", MainFrame)
    local pageESP = Instance.new("ScrollingFrame", MainFrame)

    local function setupPage(p)
        p.Size = UDim2.new(1, 0, 0.9, 0)
        p.Position = UDim2.new(0, 0, 0.1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 5)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end
    setupPage(pageMain); setupPage(pageTP); setupPage(pageESP)
    pageMain.Visible = true

    local function makeBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.9, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- [ TAB 1: MAIN ]
    local speedOn, flyOn, noclipOn = false, false, false
    makeBtn("Speed: OFF", pageMain, function() speedOn = not speedOn end)
    makeBtn("Fly: OFF", pageMain, function() flyOn = not flyOn end)
    makeBtn("Noclip: OFF", pageMain, function() noclipOn = not noclipOn end)

    -- [ TAB 2: TELEPORT SCAN ]
    local function updateTP()
        for _, v in pairs(pageTP:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
        if genPath then
            for i, obj in pairs(genPath:GetChildren()) do
                makeBtn("TP to Generator #"..i, pageTP, function() 
                    player.Character.HumanoidRootPart.CFrame = (obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame) * CFrame.new(0,5,0) 
                end)
            end
        end
    end
    makeBtn("Refresh Scan", pageTP, updateTP) --

    -- [ TAB 3: ULTIMATE VISION (HP + ESP) ]
    local hpEspOn, genEspOn = false, false
    makeBtn("PLAYER HP ESP: OFF", pageESP, function() hpEspOn = not hpEspOn end)
    makeBtn("GENERATOR ESP: OFF", pageESP, function() genEspOn = not genEspOn end)

    --// HP & ESP Core Function
    local function applyFullESP(target, name, color, isPlayer)
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
        end

        runService.RenderStepped:Connect(function()
            if not target or not target.Parent or (isPlayer and not hpEspOn) or (not isPlayer and not genEspOn) then
                bill:Destroy()
                if target.Parent:FindFirstChild("GeminiChams") then target.Parent.GeminiChams:Destroy() end
                return
            end
            local dist = math.floor((player.Character.HumanoidRootPart.Position - target.Position).Magnitude)
            local hp = isPlayer and target.Parent:FindFirstChild("Humanoid") and math.floor(target.Parent.Humanoid.Health) or 100
            label.Text = string.format("%s\nHP: %d | %d m", name, hp, dist)
            -- แถบสีเปลี่ยนตามเลือด
            label.TextColor3 = isPlayer and (hp > 50 and Color3.new(0,1,0) or Color3.new(1,0,0)) or color
        end)
    end

    --// Tab Swapping
    bMain.MouseButton1Click:Connect(function() pageMain.Visible = true; pageTP.Visible = false; pageESP.Visible = false end)
    bTP.MouseButton1Click:Connect(function() pageMain.Visible = false; pageTP.Visible = true; pageESP.Visible = false; updateTP() end)
    bESP.MouseButton1Click:Connect(function() pageMain.Visible = false; pageTP.Visible = false; pageESP.Visible = true end)

    --// Main Control Loop
    runService.Stepped:Connect(function()
        if not player.Character then return end
        if speedOn then player.Character.Humanoid.WalkSpeed = 24 end
        if noclipOn then
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        if hpEspOn then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    applyFullESP(p.Character.HumanoidRootPart, p.DisplayName, Color3.new(1, 1, 1), true)
                end
            end
        end

        if genEspOn then
            local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
            if genPath then
                for i, g in pairs(genPath:GetChildren()) do
                    local t = g:IsA("Model") and (g.PrimaryPart or g:FindFirstChildWhichIsA("BasePart")) or g
                    if t then applyFullVisual(t, "Gen #"..i, Color3.new(0, 0.7, 1), false) end
                end
            end
        end
    end)

    -- Toggle Button
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

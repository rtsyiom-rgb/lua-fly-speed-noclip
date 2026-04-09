--[[ 
    GEMINI HUB V6 (FINAL ALL-IN-ONE)
    - FEATURES: MAIN (Speed, Fly, Noclip), TP (Gens, Players), ESP (Gens, Players)
    - COMPATIBILITY: Mobile / Tablet (Optimized)
    - KEY: key_powsnas232-waodKLS
]]

if _G.GeminiFinalLoaded then 
    local old = game:GetService("PlayerGui"):FindFirstChild("Gemini_Final")
    if old then old:Destroy() end
end
_G.GeminiFinalLoaded = true

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

--// UI Configuration
local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "Gemini_Final"
ScreenGui.ResetOnSpawn = false

local function buildHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 210, 0, 330)
    MainFrame.Position = UDim2.new(0.5, 50, 0.5, -165)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
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
        b.TextSize = 12
        b.BorderSizePixel = 0
        return b
    end

    local bMain = createTabBtn("MAIN", UDim2.new(0,0,0,0), 0.33)
    local bTP = createTabBtn("TP", UDim2.new(0.33,0,0,0), 0.33)
    local bESP = createTabBtn("ESP", UDim2.new(0.66,0,0,0), 0.34)

    --// Pages
    local pMain = Instance.new("ScrollingFrame", MainFrame)
    local pTP = Instance.new("ScrollingFrame", MainFrame)
    local pESP = Instance.new("ScrollingFrame", MainFrame)

    local function setupPage(p)
        p.Size = UDim2.new(1, 0, 0.88, 0)
        p.Position = UDim2.new(0, 0, 0.12, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 3
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 5)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end
    setupPage(pMain); setupPage(pTP); setupPage(pESP)
    pMain.Visible = true

    local function makeBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.92, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- [ TAB 1: MAIN SETTINGS ]
    local speedOn, flyOn, noclipOn = false, false, false
    local sB = makeBtn("Speed: OFF", pMain, function() speedOn = not speedOn sB.Text = "Speed: "..(speedOn and "ON" or "OFF") end)
    local fB = makeBtn("Fly: OFF", pMain, function() flyOn = not flyOn fB.Text = "Fly: "..(flyOn and "ON" or "OFF") end)
    local nB = makeBtn("Noclip: OFF", pMain, function() noclipOn = not noclipOn nB.Text = "Noclip: "..(noclipOn and "ON" or "OFF") end)

    -- [ TAB 2: TELEPORT LIST ]
    local function updateTP()
        for _, v in pairs(pTP:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
        
        local maps = workspace:FindFirstChild("MAPS")
        local genPath = maps and maps:FindFirstChild("GAME MAP") and maps["GAME MAP"]:FindFirstChild("Generators")
        
        if genPath then
            local l = Instance.new("TextLabel", pTP)
            l.Size = UDim2.new(1, 0, 0, 20) l.Text = "-- GENERATORS --" l.TextColor3 = Color3.new(0,0.6,1) l.BackgroundTransparency = 1
            for i, obj in pairs(genPath:GetChildren()) do
                makeBtn("Generator #"..i, pTP, function()
                    local pos = obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame
                    player.Character.HumanoidRootPart.CFrame = pos * CFrame.new(0, 5, 0)
                end)
            end
        end

        local pl = Instance.new("TextLabel", pTP)
        pl.Size = UDim2.new(1, 0, 0, 20) pl.Text = "-- PLAYERS --" pl.TextColor3 = Color3.new(0,1,0.5) pl.BackgroundTransparency = 1
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player then
                makeBtn(p.DisplayName, pTP, function()
                    if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
                end)
            end
        end
        pTP.CanvasSize = UDim2.new(0,0,0, pTP.UIListLayout.AbsoluteContentSize.Y + 20)
    end

    -- [ TAB 3: ESP OPTIONS ]
    local pEsp, gEsp = false, false
    local peB = makeBtn("Player ESP: OFF", pESP, function() pEsp = not pEsp peB.Text = "Player ESP: "..(pEsp and "ON" or "OFF") end)
    local geB = makeBtn("Gen ESP: OFF", pESP, function() gEsp = not gEsp geB.Text = "Gen ESP: "..(gEsp and "ON" or "OFF") end)

    -- ESP Creator Function
    local function applyESP(obj, color)
        if obj:FindFirstChild("GeminiVisual") then return end
        local box = Instance.new("BoxHandleAdornment", obj)
        box.Name = "GeminiVisual"
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Adornee = obj
        box.Size = obj:IsA("Model") and obj:GetExtentsSize() or (obj:IsA("BasePart") and obj.Size or Vector3.new(4,6,4))
        box.Transparency = 0.5
        box.Color3 = color
    end

    --// Tab Logic
    bMain.MouseButton1Click:Connect(function() pMain.Visible = true; pTP.Visible = false; pESP.Visible = false end)
    bTP.MouseButton1Click:Connect(function() pMain.Visible = false; pTP.Visible = true; pESP.Visible = false; updateTP() end)
    bESP.MouseButton1Click:Connect(function() pMain.Visible = false; pTP.Visible = false; pESP.Visible = true end)

    --// Main Loop
    runService.Stepped:Connect(function()
        if not player.Character then return end
        if speedOn then player.Character.Humanoid.WalkSpeed = 22 end
        if noclipOn then
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        -- Player ESP
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if pEsp then applyESP(p.Character.HumanoidRootPart, Color3.new(0,1,0))
                else if p.Character.HumanoidRootPart:FindFirstChild("GeminiVisual") then p.Character.HumanoidRootPart.GeminiVisual:Destroy() end end
            end
        end

        -- Gen ESP
        local maps = workspace:FindFirstChild("MAPS")
        local genPath = maps and maps:FindFirstChild("GAME MAP") and maps["GAME MAP"]:FindFirstChild("Generators")
        if genPath then
            for _, gen in pairs(genPath:GetChildren()) do
                local target = gen:IsA("Model") and (gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")) or gen
                if target and gEsp then applyESP(target, Color3.new(0,0.5,1))
                elseif target and target:FindFirstChild("GeminiVisual") then target.GeminiVisual:Destroy() end
            end
        end
    end)

    --// Toggle Hub Button
    local T = Instance.new("TextButton", ScreenGui)
    T.Size = UDim2.new(0, 42, 0, 42)
    T.Position = UDim2.new(0, 10, 0.5, -21)
    T.Text = "G"
    T.BackgroundColor3 = Color3.fromRGB(30,30,30)
    T.TextColor3 = Color3.new(0,1,0.6)
    T.ZIndex = 100
    T.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

task.wait(0.5)
buildHub()

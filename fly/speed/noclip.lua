--[[ 
    GEMINI HUB V1: THE DEFINITIVE EDITION
    - Speed: 20 (CFrame Bypass)
    - Fly: Smooth (Space to Up, Ctrl to Down)
    - Noclip: Always On Logic
    - Player Scanner: Auto-Pull Names & Click to TP
    - GUI: Draggable & Toggleable (Press Insert to Hide)
]]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

--// UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local SpeedBtn = Instance.new("TextButton", Main)
local FlyBtn = Instance.new("TextButton", Main)
local NocBtn = Instance.new("TextButton", Main)
local ListTitle = Instance.new("TextLabel", Main)
local TPFrame = Instance.new("ScrollingFrame", Main)
local UIList = Instance.new("UIListLayout", TPFrame)

--// UI Styling (Infinite Yield Style)
Main.Name = "GeminiHub_Final"
Main.Size = UDim2.new(0, 160, 0, 300)
Main.Position = UDim2.new(0.5, -80, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = " GEMINI HUB V1 (ALL)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 10
Title.Font = Enum.Font.SourceSansBold

local function styleBtn(btn, pos, text)
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
end

styleBtn(SpeedBtn, UDim2.new(0.05, 0, 0.1, 0), "Speed (20): OFF")
styleBtn(FlyBtn, UDim2.new(0.05, 0, 0.2, 0), "Fly: OFF")
styleBtn(NocBtn, UDim2.new(0.05, 0, 0.3, 0), "Noclip: OFF")

ListTitle.Size = UDim2.new(1, 0, 0, 20)
ListTitle.Position = UDim2.new(0, 0, 0.4, 0)
ListTitle.BackgroundTransparency = 1
ListTitle.Text = "--- PLAYER SCANNER ---"
ListTitle.TextColor3 = Color3.new(0.6, 0.6, 0.6)
ListTitle.TextSize = 10

TPFrame.Size = UDim2.new(0.9, 0, 0, 150)
TPFrame.Position = UDim2.new(0.05, 0, 0.48, 0)
TPFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TPFrame.BorderSizePixel = 0
TPFrame.ScrollBarThickness = 4
UIList.SortOrder = Enum.SortOrder.LayoutOrder

--// Logic Variables
local speedOn, flyOn, noclipOn = false, false, false
local ws_speed = 20
local fly_speed = 2

--// Heartbeat Loop (Core Logic)
runService.Heartbeat:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    local move = hum.MoveDirection

    -- 1. Speed Bypass
    if speedOn and not flyOn then
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move * (ws_speed / 45))
        end
    end

    -- 2. Fly Bypass
    if flyOn then
        hum.PlatformStand = true
        root.Velocity = Vector3.new(0, 0, 0)
        local cam = workspace.CurrentCamera.CFrame
        local newCF = root.CFrame
        if move.Magnitude > 0 then
            newCF = newCF + (cam.LookVector * (move.Z * -1) * fly_speed) + (cam.RightVector * move.X * fly_speed)
        end
        if uis:IsKeyDown(Enum.KeyCode.Space) then newCF = newCF * CFrame.new(0, fly_speed, 0)
        elseif uis:IsKeyDown(Enum.KeyCode.LeftControl) then newCF = newCF * CFrame.new(0, -fly_speed, 0) end
        root.CFrame = newCF
    end

    -- 3. Noclip
    if noclipOn then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

--// Button Events
SpeedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    SpeedBtn.Text = speedOn and "Speed (20): ON" or "Speed (20): OFF"
    SpeedBtn.TextColor3 = speedOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

FlyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    FlyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
    FlyBtn.TextColor3 = flyOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    if not flyOn and player.Character then player.Character.Humanoid.PlatformStand = false end
end)

NocBtn.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    NocBtn.Text = noclipOn and "Noclip: ON" or "Noclip: OFF"
    NocBtn.TextColor3 = noclipOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

--// Player Scanner (Auto-Pull)
local function updatePlayerList()
    for _, v in pairs(TPFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton", TPFrame)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.BorderSizePixel = 0
            pBtn.Text = "TP TO: " .. p.DisplayName
            pBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 12
            
            pBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
        end
    end
    TPFrame.CanvasSize = UDim2.new(0, 0, 0, #players:GetPlayers() * 25)
end

players.PlayerAdded:Connect(updatePlayerList)
players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

--// Hotkey Insert to Toggle UI
uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)

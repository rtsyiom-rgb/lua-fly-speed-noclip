--[[ 
    GEMINI HUB V1: THE MASTER EDITION (All-in-One)
    Features:
    - Speed Bypass (Locked at 20)
    - Fly Mode (Space/Ctrl)
    - Noclip (Walk through walls)
    - Player Scanner (Auto-update list)
    - Fly To Player (Auto-follow targeted player)
    Hotkeys: [Insert] to Hide UI, [Q] to Stop FlyTo
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
local TPFrame = Instance.new("ScrollingFrame", Main)
local UIList = Instance.new("UIListLayout", TPFrame)

--// UI Styling
Main.Name = "GeminiMaster_V1"
Main.Size = UDim2.new(0, 170, 0, 320)
Main.Position = UDim2.new(0.5, -85, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = " GEMINI MASTER V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 12
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

styleBtn(SpeedBtn, UDim2.new(0.05, 0, 0.12, 0), "Speed (20): OFF")
styleBtn(FlyBtn, UDim2.new(0.05, 0, 0.22, 0), "Fly Mode: OFF")
styleBtn(NocBtn, UDim2.new(0.05, 0, 0.32, 0), "Noclip: OFF")

TPFrame.Size = UDim2.new(0.9, 0, 0, 170)
TPFrame.Position = UDim2.new(0.05, 0, 0.43, 0)
TPFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TPFrame.BorderSizePixel = 0
TPFrame.ScrollBarThickness = 4
UIList.SortOrder = Enum.SortOrder.LayoutOrder

--// Core Variables
local speedOn, flyOn, noclipOn = false, false, false
local targetPlayer = nil
local ws_speed = 20
local fly_speed = 2
local flyTo_speed = 2.5

--// Core Loop (Heartbeat)
runService.Heartbeat:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    local move = hum.MoveDirection

    -- 1. Fly To Player (Priority)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        hum.PlatformStand = true
        root.Velocity = Vector3.new(0,0,0)
        local tRoot = targetPlayer.Character.HumanoidRootPart
        local dir = (tRoot.Position - root.Position).Unit
        if (tRoot.Position - root.Position).Magnitude > 6 then
            root.CFrame = root.CFrame + (dir * flyTo_speed)
            root.CFrame = CFrame.lookAt(root.Position, tRoot.Position)
        end
        return -- Skip other movement logic while FlyTo is active
    end

    -- 2. Fly Mode
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

    -- 3. Speed 20
    if speedOn and not flyOn then
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move * (ws_speed / 45))
        end
    end

    -- 4. Noclip
    if noclipOn then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

--// Player List Scanner
local function updatePlayerList()
    for _, v in pairs(TPFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton", TPFrame)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.Text = "FLY TO: " .. p.DisplayName
            pBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.BorderSizePixel = 0
            
            pBtn.MouseButton1Click:Connect(function()
                if targetPlayer == p then
                    targetPlayer = nil
                    if player.Character then player.Character.Humanoid.PlatformStand = false end
                else
                    targetPlayer = p
                end
            end)
        end
    end
    TPFrame.CanvasSize = UDim2.new(0, 0, 0, #players:GetPlayers() * 25)
end

--// Button Events
SpeedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    SpeedBtn.Text = speedOn and "Speed (20): ON" or "Speed (20): OFF"

--// Gemini Hub V1: THE ULTIMATE EDITION (All-in-One)
--// Features: Speed 20, Fly, Noclip, Player TP Scanner

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

-- สร้าง UI (IY Classic Theme)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local SpeedBtn = Instance.new("TextButton", Main)
local FlyBtn = Instance.new("TextButton", Main)
local NocBtn = Instance.new("TextButton", Main)
local RefreshBtn = Instance.new("TextButton", Main)
local TPFrame = Instance.new("ScrollingFrame", Main)
local UIList = Instance.new("UIListLayout", TPFrame)

-- ตกแต่ง UI
Main.Name = "GeminiHub_All"
Main.Size = UDim2.new(0, 160, 0, 260)
Main.Position = UDim2.new(0.5, -80, 0.5, -130)
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

-- ฟังก์ชันสร้างปุ่ม
local function styleBtn(btn, pos, text)
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
end

styleBtn(SpeedBtn, UDim2.new(0.05, 0, 0.12, 0), "Speed (20): OFF")
styleBtn(FlyBtn, UDim2.new(0.05, 0, 0.23, 0), "Fly: OFF")
styleBtn(NocBtn, UDim2.new(0.05, 0, 0.34, 0), "Noclip: OFF")

RefreshBtn.Size = UDim2.new(0.9, 0, 0, 20)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
RefreshBtn.Text = "REFRESH PLAYER LIST"
RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
RefreshBtn.TextSize = 11

TPFrame.Size = UDim2.new(0.9, 0, 0, 105)
TPFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
TPFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TPFrame.BorderSizePixel = 0
TPFrame.ScrollBarThickness = 4
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Logic Variables
local speedOn, flyOn, noclipOn = false, false, false
local ws_speed = 20
local fly_speed = 2

-- ระบบ Loop หลัก (Heartbeat)
runService.Heartbeat:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    local move = hum.MoveDirection

    -- 1. Speed 20 Bypass (CFrame)
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

-- ปุ่มสลับโหมด
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

-- ระบบ Scanner & TP
local function updateList()
    for _, v in pairs(TPFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton", TPFrame)
            pBtn.Size = UDim2.new(1, 0, 0, 20)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.Text = p.DisplayName
            pBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.BorderSizePixel = 0
            pBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
        end
    end
    TPFrame.CanvasSize = UDim2.new(0, 0, 0, #players:GetPlayers() * 20)
end

RefreshBtn.MouseButton1Click:Connect(updateList)
updateList()

-- ปุ่มลัดปิด/เปิด UI (กดปุ่ม Insert)
uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)

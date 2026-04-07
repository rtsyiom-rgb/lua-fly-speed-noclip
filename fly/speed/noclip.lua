--// Gemini All-in-One (Speed, Fly, Noclip, Teleport)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

-- สร้าง UI (ปรับขนาดเพิ่มขึ้นเพื่อรองรับระบบ TP)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local SpeedBtn = Instance.new("TextButton", Main)
local FlyBtn = Instance.new("TextButton", Main)
local NocBtn = Instance.new("TextButton", Main)
local TPInput = Instance.new("TextBox", Main) -- ช่องใส่ชื่อผู้เล่น
local TPBtn = Instance.new("TextButton", Main)  -- ปุ่มกด TP

-- ปรับแต่ง UI สไตล์ IY
Main.Size = UDim2.new(0, 150, 0, 195) -- เพิ่มความสูงเพื่อใส่ระบบ TP
Main.Position = UDim2.new(0.5, -75, 0.5, -97)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = " GEMINI HUB V1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold

-- ปุ่ม Speed
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 25)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.16, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.Text = "Speed: OFF"
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)

-- ปุ่ม Fly
FlyBtn.Size = UDim2.new(0.9, 0, 0, 25)
FlyBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.new(1, 1, 1)

-- ปุ่ม Noclip
NocBtn.Size = UDim2.new(0.9, 0, 0, 25)
NocBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
NocBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NocBtn.Text = "Noclip: OFF"
NocBtn.TextColor3 = Color3.new(1, 1, 1)

-- ช่องใส่ชื่อผู้เล่น (TP)
TPInput.Size = UDim2.new(0.9, 0, 0, 25)
TPInput.Position = UDim2.new(0.05, 0, 0.64, 0)
TPInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TPInput.PlaceholderText = "Player Name..."
TPInput.Text = ""
TPInput.TextColor3 = Color3.new(1, 1, 1)
TPInput.Font = Enum.Font.SourceSans

-- ปุ่มกด TP
TPBtn.Size = UDim2.new(0.9, 0, 0, 25)
TPBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TPBtn.Text = "TELEPORT"
TPBtn.TextColor3 = Color3.new(1, 1, 1)

-- ระบบ Logic เดิม
local speedOn = false
local flyOn = false
local noclipOn = false
local ws_speed = 100
local fly_speed = 2

runService.Heartbeat:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local hum = player.Character.Humanoid
    local move = hum.MoveDirection

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

    if speedOn and not flyOn then
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move * (ws_speed / 50))
        end
    end

    if noclipOn then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ปุ่มกดต่างๆ
SpeedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    SpeedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
    SpeedBtn.TextColor3 = speedOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

FlyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    FlyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
    FlyBtn.TextColor3 = flyOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    if not flyOn then player.Character.Humanoid.PlatformStand = false end
end)

NocBtn.MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    NocBtn.Text = noclipOn and "Noclip: ON" or "Noclip: OFF"
    NocBtn.TextColor3 = noclipOn and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

-- ระบบ Teleport (หาชื่อย่อได้เหมือน IY)
TPBtn.MouseButton1Click:Connect(function()
    local targetName = TPInput.Text:lower()
    for _, p in pairs(players:GetPlayers()) do
        if p.Name:lower():sub(1, #targetName) == targetName or p.DisplayName:lower():sub(1, #targetName) == targetName then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end
end)

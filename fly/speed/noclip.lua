--// Gemini All-in-One (Speed, Fly, Noclip)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- สร้าง UI สไตล์ Infinite Yield (เพิ่มขนาดความสูงให้พอดีกับ 3 ปุ่ม)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local SpeedBtn = Instance.new("TextButton", Main)
local FlyBtn = Instance.new("TextButton", Main)
local NocBtn = Instance.new("TextButton", Main) -- ปุ่ม Noclip

-- ปรับแต่ง UI
Main.Size = UDim2.new(0, 150, 0, 135) -- เพิ่มความสูงจาก 100 เป็น 135
Main.Position = UDim2.new(0.5, -75, 0.5, -67)
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

SpeedBtn.Size = UDim2.new(0.9, 0, 0, 25)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.Text = "Speed: OFF"
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)

FlyBtn.Size = UDim2.new(0.9, 0, 0, 25)
FlyBtn.Position = UDim2.new(0.05, 0, 0.50, 0)
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.new(1, 1, 1)

NocBtn.Size = UDim2.new(0.9, 0, 0, 25)
NocBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
NocBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NocBtn.Text = "Noclip: OFF"
NocBtn.TextColor3 = Color3.new(1, 1, 1)

-- ระบบ Logic (ใช้ CFrame Bypass)
local speedOn = false
local flyOn = false
local noclipOn = false
local ws_speed = 20
local fly_speed = 2

runService.Heartbeat:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local hum = player.Character.Humanoid
    local move = hum.MoveDirection

    -- บิน (Fly)
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

    -- วิ่งเร็ว (Speed Bypass)
    if speedOn and not flyOn then
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move * (ws_speed / 50))
        end
    end

    -- ทะลุกำแพง (Noclip)
    if noclipOn then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ระบบปุ่มกด
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

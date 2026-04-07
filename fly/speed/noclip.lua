--[[ 
    GEMINI HUB V2: MOBILE TABBED EDITION
    - Tab 1: Main (Speed, Fly, Noclip)
    - Tab 2: TP (Auto-Gen Scan, Players)
    - Key: key_powsnas232-waodKLS
]]

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local saveFile = "Gemini_Mobile_V2.txt"
local CorrectKey = "key_powsnas232-waodKLS"

-- ล้าง UI เก่าเพื่อกันปัญหาจอดำ
if pgui:FindFirstChild("GeminiMobile_UI") then pgui.GeminiMobile_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "GeminiMobile_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// ฟังก์ชันสร้างหน้าหลัก (Mobile Optimized)
local function buildHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 210, 0, 320)
    MainFrame.Position = UDim2.new(0.5, 50, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- ลากย้ายตำแหน่งได้บนจอ

    -- แถบเลือกหน้า (Tab Bar)
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local MainTabBtn = Instance.new("TextButton", TabBar)
    MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    MainTabBtn.Text = "MAIN"
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainTabBtn.TextColor3 = Color3.new(1, 1, 1)

    local TPTabBtn = Instance.new("TextButton", TabBar)
    TPTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    TPTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
    TPTabBtn.Text = "TP LIST"
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TPTabBtn.TextColor3 = Color3.new(0.7, 0.7, 0.7)

    -- หน้าต่างๆ (Pages)
    local MainPage = Instance.new("ScrollingFrame", MainFrame)
    MainPage.Size = UDim2.new(1, 0, 0.88, 0)
    MainPage.Position = UDim2.new(0, 0, 0.12, 0)
    MainPage.BackgroundTransparency = 1
    MainPage.Visible = true

    local TPPage = Instance.new("ScrollingFrame", MainFrame)
    TPPage.Size = UDim2.new(1, 0, 0.88, 0)
    TPPage.Position = UDim2.new(0, 0, 0.12, 0)
    TPPage.BackgroundTransparency = 1
    TPPage.Visible = false

    local function setupLayout(p)
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 6)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        p.ScrollBarThickness = 4
    end
    setupLayout(MainPage)
    setupLayout(TPPage)

    local function makeBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.92, 0, 0, 38) -- ขนาดปุ่มใหญ่สำหรับมือถือ
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 16
        b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- [ หน้า 1: ฟีเจอร์หลัก ]
    local speedOn, flyOn, noclipOn = false, false, false
    local sBtn = makeBtn("Speed: OFF", MainPage, function() 
        speedOn = not speedOn 
        sBtn.Text = "Speed: "..(speedOn and "ON" or "OFF")
    end)
    local fBtn = makeBtn("Fly: OFF", MainPage, function() 
        flyOn = not flyOn 
        fBtn.Text = "Fly: "..(flyOn and "ON" or "OFF")
        if not flyOn and player.Character then player.Character.Humanoid.PlatformStand = false end
    end)
    local nBtn = makeBtn("Noclip: OFF", MainPage, function() 
        noclipOn = not noclipOn 
        nBtn.Text = "Noclip: "..(noclipOn and "ON" or "OFF")
    end)

    -- [ หน้า 2: ระบบวาร์ป (Auto Scan) ]
    local function updateTPPage()
        for _, v in pairs(TPPage:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
        
        -- Generator TP
        local gLab = Instance.new("TextLabel", TPPage)
        gLab.Size = UDim2.new(1, 0, 0, 25)
        gLab.Text = "--- GENERATORS ---"
        gLab.TextColor3 = Color3.fromRGB(100, 150, 255)
        gLab.BackgroundTransparency = 1

        local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
        if genPath then
            for i, obj in pairs(genPath:GetChildren()) do
                local pos = obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame
                makeBtn("Generator #"..i, TPPage, function()
                    if player.Character then player.Character.HumanoidRootPart.CFrame = pos * CFrame.new(0, 5, 0) end
                end)
            end
        end

        -- Player TP
        local pLab = Instance.new("TextLabel", TPPage)
        pLab.Size = UDim2.new(1, 0, 0, 25)
        pLab.Text = "--- PLAYERS ---"
        pLab.TextColor3 = Color3.fromRGB(100, 255, 150)
        pLab.BackgroundTransparency = 1
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player then
                makeBtn(p.DisplayName, TPPage, function()
                    if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
                end)
            end
        end
        TPPage.CanvasSize = UDim2.new(0, 0, 0, TPPage.UIListLayout.AbsoluteContentSize.Y + 20)
    end

    -- สลับหน้า
    MainTabBtn.MouseButton1Click:Connect(function()
        MainPage.Visible = true; TPPage.Visible = false
        MainTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TPTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    TPTabBtn.MouseButton1Click:Connect(function()
        MainPage.Visible = false; TPPage.Visible = true
        updateTPPage()
        TPTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); MainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)

    -- ระบบควบคุมตัวละคร
    runService.Stepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
        if speedOn and not flyOn then player.Character.Humanoid.WalkSpeed = 17 end
        if flyOn then
            player.Character.Humanoid.PlatformStand = true
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            local move = player.Character.Humanoid.MoveDirection
            local cam = workspace.CurrentCamera.CFrame
            if move.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame:Lerp(player.Character.HumanoidRootPart.CFrame + (cam.LookVector * (move.Z * -1) * 1.6) + (cam.RightVector * move.X * 1.6), 0.5)
            end
        end
        if noclipOn then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    -- ปุ่มเปิด/ปิดเมนู (G)
    local Toggle = Instance.new("TextButton", ScreenGui)
    Toggle.Size = UDim2.new(0, 45, 0, 45)
    Toggle.Position = UDim2.new(0, 10, 0.5, -22)
    Toggle.Text = "G"
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.TextColor3 = Color3.fromRGB(0, 255, 150)
    Toggle.ZIndex = 10
    Toggle.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

--// ระบบ Key & Auto Login
if isfile and isfile(saveFile) and readfile(saveFile) == CorrectKey then
    buildHub()
else
    local KF = Instance.new("Frame", ScreenGui)
    KF.Size = UDim2.new(0, 240, 0, 150)
    KF.Position = UDim2.new(0.5, -120, 0.5, -75)
    KF.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local In = Instance.new("TextBox", KF)
    In.Size = UDim2.new(0.8, 0, 0, 35)
    In.Position = UDim2.new(0.1, 0, 0.3, 0)
    In.PlaceholderText = "Enter Key..."
    
    local Sb = Instance.new("TextButton", KF)
    Sb.Size = UDim2.new(0.8, 0, 0, 40)
    Sb.Position = UDim2.new(0.1, 0, 0.65, 0)
    Sb.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    Sb.Text = "SUBMIT"
    Sb.TextColor3 = Color3.new(1, 1, 1)

    Sb.MouseButton1Click:Connect(function()
        if In.Text == CorrectKey then
            if writefile then writefile(saveFile, CorrectKey) end
            KF:Destroy(); buildHub()
        end
    end)
end
--[[ 
    GEMINI HUB V2: MOBILE TABBED EDITION
    - Tab 1: Main (Speed, Fly, Noclip)
    - Tab 2: TP (Auto-Gen Scan, Players)
    - Key: key_powsnas232-waodKLS
]]

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local saveFile = "Gemini_Mobile_V2.txt"
local CorrectKey = "key_powsnas232-waodKLS"

-- ล้าง UI เก่าเพื่อกันปัญหาจอดำ
if pgui:FindFirstChild("GeminiMobile_UI") then pgui.GeminiMobile_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "GeminiMobile_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// ฟังก์ชันสร้างหน้าหลัก (Mobile Optimized)
local function buildHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 210, 0, 320)
    MainFrame.Position = UDim2.new(0.5, 50, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- ลากย้ายตำแหน่งได้บนจอ

    -- แถบเลือกหน้า (Tab Bar)
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local MainTabBtn = Instance.new("TextButton", TabBar)
    MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    MainTabBtn.Text = "MAIN"
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainTabBtn.TextColor3 = Color3.new(1, 1, 1)

    local TPTabBtn = Instance.new("TextButton", TabBar)
    TPTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    TPTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
    TPTabBtn.Text = "TP LIST"
    TPTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TPTabBtn.TextColor3 = Color3.new(0.7, 0.7, 0.7)

    -- หน้าต่างๆ (Pages)
    local MainPage = Instance.new("ScrollingFrame", MainFrame)
    MainPage.Size = UDim2.new(1, 0, 0.88, 0)
    MainPage.Position = UDim2.new(0, 0, 0.12, 0)
    MainPage.BackgroundTransparency = 1
    MainPage.Visible = true

    local TPPage = Instance.new("ScrollingFrame", MainFrame)
    TPPage.Size = UDim2.new(1, 0, 0.88, 0)
    TPPage.Position = UDim2.new(0, 0, 0.12, 0)
    TPPage.BackgroundTransparency = 1
    TPPage.Visible = false

    local function setupLayout(p)
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 6)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        p.ScrollBarThickness = 4
    end
    setupLayout(MainPage)
    setupLayout(TPPage)

    local function makeBtn(txt, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.92, 0, 0, 38) -- ขนาดปุ่มใหญ่สำหรับมือถือ
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 16
        b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- [ หน้า 1: ฟีเจอร์หลัก ]
    local speedOn, flyOn, noclipOn = false, false, false
    local sBtn = makeBtn("Speed: OFF", MainPage, function() 
        speedOn = not speedOn 
        sBtn.Text = "Speed: "..(speedOn and "ON" or "OFF")
    end)
    local fBtn = makeBtn("Fly: OFF", MainPage, function() 
        flyOn = not flyOn 
        fBtn.Text = "Fly: "..(flyOn and "ON" or "OFF")
        if not flyOn and player.Character then player.Character.Humanoid.PlatformStand = false end
    end)
    local nBtn = makeBtn("Noclip: OFF", MainPage, function() 
        noclipOn = not noclipOn 
        nBtn.Text = "Noclip: "..(noclipOn and "ON" or "OFF")
    end)

    -- [ หน้า 2: ระบบวาร์ป (Auto Scan) ]
    local function updateTPPage()
        for _, v in pairs(TPPage:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
        
        -- Generator TP
        local gLab = Instance.new("TextLabel", TPPage)
        gLab.Size = UDim2.new(1, 0, 0, 25)
        gLab.Text = "--- GENERATORS ---"
        gLab.TextColor3 = Color3.fromRGB(100, 150, 255)
        gLab.BackgroundTransparency = 1

        local genPath = workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
        if genPath then
            for i, obj in pairs(genPath:GetChildren()) do
                local pos = obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame
                makeBtn("Generator #"..i, TPPage, function()
                    if player.Character then player.Character.HumanoidRootPart.CFrame = pos * CFrame.new(0, 5, 0) end
                end)
            end
        end

        -- Player TP
        local pLab = Instance.new("TextLabel", TPPage)
        pLab.Size = UDim2.new(1, 0, 0, 25)
        pLab.Text = "--- PLAYERS ---"
        pLab.TextColor3 = Color3.fromRGB(100, 255, 150)
        pLab.BackgroundTransparency = 1
        for _, p in pairs(players:GetPlayers()) do
            if p ~= player then
                makeBtn(p.DisplayName, TPPage, function()
                    if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
                end)
            end
        end
        TPPage.CanvasSize = UDim2.new(0, 0, 0, TPPage.UIListLayout.AbsoluteContentSize.Y + 20)
    end

    -- สลับหน้า
    MainTabBtn.MouseButton1Click:Connect(function()
        MainPage.Visible = true; TPPage.Visible = false
        MainTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TPTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    TPTabBtn.MouseButton1Click:Connect(function()
        MainPage.Visible = false; TPPage.Visible = true
        updateTPPage()
        TPTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); MainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)

    -- ระบบควบคุมตัวละคร
    runService.Stepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
        if speedOn and not flyOn then player.Character.Humanoid.WalkSpeed = 17 end
        if flyOn then
            player.Character.Humanoid.PlatformStand = true
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            local move = player.Character.Humanoid.MoveDirection
            local cam = workspace.CurrentCamera.CFrame
            if move.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame:Lerp(player.Character.HumanoidRootPart.CFrame + (cam.LookVector * (move.Z * -1) * 1.6) + (cam.RightVector * move.X * 1.6), 0.5)
            end
        end
        if noclipOn then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    -- ปุ่มเปิด/ปิดเมนู (G)
    local Toggle = Instance.new("TextButton", ScreenGui)
    Toggle.Size = UDim2.new(0, 45, 0, 45)
    Toggle.Position = UDim2.new(0, 10, 0.5, -22)
    Toggle.Text = "G"
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.TextColor3 = Color3.fromRGB(0, 255, 150)
    Toggle.ZIndex = 10
    Toggle.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

--// ระบบ Key & Auto Login
if isfile and isfile(saveFile) and readfile(saveFile) == CorrectKey then
    buildHub()
else
    local KF = Instance.new("Frame", ScreenGui)
    KF.Size = UDim2.new(0, 240, 0, 150)
    KF.Position = UDim2.new(0.5, -120, 0.5, -75)
    KF.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local In = Instance.new("TextBox", KF)
    In.Size = UDim2.new(0.8, 0, 0, 35)
    In.Position = UDim2.new(0.1, 0, 0.3, 0)
    In.PlaceholderText = "Enter Key..."
    
    local Sb = Instance.new("TextButton", KF)
    Sb.Size = UDim2.new(0.8, 0, 0, 40)
    Sb.Position = UDim2.new(0.1, 0, 0.65, 0)
    Sb.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    Sb.Text = "SUBMIT"
    Sb.TextColor3 = Color3.new(1, 1, 1)

    Sb.MouseButton1Click:Connect(function()
        if In.Text == CorrectKey then
            if writefile then writefile(saveFile, CorrectKey) end
            KF:Destroy(); buildHub()
        end
    end)
end

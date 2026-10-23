-- AXAC ALL IN ONE [Axac Vermeil Exclusive Edition - FULL ACCESSORIES UPDATE]
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local VERMEIL_IMAGE_URL = "https://raw.githubusercontent.com/masadepanindah327-cpu/Axac-Hub/main/805e9cffb3636dff8a02c009f1692d1b-removebg-preview.png"

getgenv().AxacState = {
    RgbMode = false,
    FpsBoost = false,
    Shaders = false,
    Headless = false,
    Korblox = false,
    Fly = false,
    FlySpeed = 50,
    WalkSpeedFast = false,
    HighJump = false,
    InfiniteJump = false,
    Noclip = false,
    EspPlayer = false,
    Fullbright = false,
    SpinBot = false,
    GhostMode = false,
    RgbAvatar = false,
    LowGravity = false,
    HitboxExpand = false,
    AntiVoid = false,
    -- ACCESSORIES STATE
    DemonHorns = false,
    GoldenHalo = false,
    CyberWings = false,
    DualKatana = false
}

if CoreGui:FindFirstChild("AxacGithubGui") then
    CoreGui.AxacGithubGui:Destroy()
end

local function getOnlineAsset(url, filename)
    if not isfile or not writefile or not getcustomasset then
        return "rbxassetid://6031094667"
    end
    if not isfile(filename) then
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content then writefile(filename, content) end
    end
    if isfile(filename) then return getcustomasset(filename) end
    return "rbxassetid://6031094667"
end

local vermeilAsset = getOnlineAsset(VERMEIL_IMAGE_URL, "axac_vermeil_exclusive.png")

local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- SYSTEM PASANG ACCESSORIES AXAC
local function attachAxacAccessory(accName, meshId, textureId, parentPart, scale, offset)
    local char = LocalPlayer.Character
    if not char then return end
    local targetPart = char:FindFirstChild(parentPart)
    if not targetPart then return end

    local existing = char:FindFirstChild(accName)
    if existing then existing:Destroy() end

    local accHandle = Instance.new("Part")
    accHandle.Name = accName
    accHandle.Size = Vector3.new(1, 1, 1)
    accHandle.CanCollide = false
    accHandle.Transparency = 0

    local mesh = Instance.new("SpecialMesh", accHandle)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = meshId
    mesh.TextureId = textureId
    mesh.Scale = scale or Vector3.new(1, 1, 1)

    local weld = Instance.new("Weld", accHandle)
    weld.Part0 = targetPart
    weld.Part1 = accHandle
    weld.C0 = offset or CFrame.new(0, 0, 0)

    accHandle.Parent = char
end

local function removeAxacAccessory(accName)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(accName) then
        char[accName]:Destroy()
    end
end

-- KORBLOX REAL PERFECT FIX & HEADLESS & ACCESSORIES
local function applyCosmetics()
    local char = LocalPlayer.Character
    if not char then return end

    -- Headless
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0)
        local face = head:FindFirstChild("face")
        if face then face.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0) end
    end

    -- Korblox Leg
    local rUpper = char:FindFirstChild("RightUpperLeg")
    local rLower = char:FindFirstChild("RightLowerLeg")
    local rFoot = char:FindFirstChild("RightFoot")

    if getgenv().AxacState.Korblox then
        if rUpper then 
            rUpper.Transparency = 1 
            for _, v in pairs(rUpper:GetChildren()) do if v:IsA("WrapTarget") or v:IsA("CharacterMesh") then v:Destroy() end end
        end
        if rFoot then 
            rFoot.Transparency = 1 
            for _, v in pairs(rFoot:GetChildren()) do if v:IsA("WrapTarget") or v:IsA("CharacterMesh") then v:Destroy() end end
        end

        if rLower then
            rLower.Transparency = 0
            for _, child in pairs(rLower:GetChildren()) do
                if child:IsA("CharacterMesh") or child:IsA("WrapTarget") or child:IsA("SpecialMesh") then
                    if child.Name ~= "KorbloxDeathLeg" then child:Destroy() end
                end
            end
            
            local kMesh = rLower:FindFirstChild("KorbloxDeathLeg") or Instance.new("SpecialMesh")
            kMesh.Name = "KorbloxDeathLeg"
            kMesh.MeshType = Enum.MeshType.FileMesh
            kMesh.MeshId = "rbxassetid://902942093"
            kMesh.TextureId = "rbxassetid://902843398"
            kMesh.Scale = Vector3.new(1.02, 1.02, 1.02)
            kMesh.Parent = rLower
        end
    else
        if rUpper then rUpper.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
        if rFoot then rFoot.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
        if rLower then
            if rLower:FindFirstChild("KorbloxDeathLeg") then rLower.KorbloxDeathLeg:Destroy() end
            rLower.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0
        end
    end

    -- Custom Accessories Toggle
    if getgenv().AxacState.DemonHorns then
        attachAxacAccessory("AxacDemonHorns", "rbxassetid://30138956", "rbxassetid://30138958", "Head", Vector3.new(1.1, 1.1, 1.1), CFrame.new(0, 0.6, 0))
    else removeAxacAccessory("AxacDemonHorns") end

    if getgenv().AxacState.GoldenHalo then
        attachAxacAccessory("AxacHalo", "rbxassetid://3270017", "rbxassetid://3270018", "Head", Vector3.new(1.5, 1.5, 1.5), CFrame.new(0, 1.5, 0))
    else removeAxacAccessory("AxacHalo") end

    if getgenv().AxacState.CyberWings then
        attachAxacAccessory("AxacWings", "rbxassetid://475355041", "rbxassetid://475355043", "UpperTorso", Vector3.new(2, 2, 2), CFrame.new(0, 0, 0.8))
    else removeAxacAccessory("AxacWings") end

    if getgenv().AxacState.DualKatana then
        attachAxacAccessory("AxacKatana", "rbxassetid://11442510", "rbxassetid://11442511", "UpperTorso", Vector3.new(1.2, 1.2, 1.2), CFrame.new(0, 0, 0.7) * CFrame.Angles(0, 0, math.rad(45)))
    else removeAxacAccessory("AxacKatana") end
end

-- FLY SYSTEM
local flyBV, flyBG
local function toggleFly(state)
    getgenv().AxacState.Fly = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if state then
        hum.PlatformStand = true
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)

        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBG.CFrame = hrp.CFrame

        task.spawn(function()
            local cam = Workspace.CurrentCamera
            while getgenv().AxacState.Fly and char and hrp and flyBV do
                RunService.RenderStepped:Wait()
                local moveDir = hum.MoveDirection
                flyBG.CFrame = cam.CFrame
                if moveDir.Magnitude > 0 then
                    local camCFrame = cam.CFrame
                    local moveVector = (camCFrame.RightVector * moveDir.X) + (camCFrame.LookVector * -moveDir.Z)
                    flyBV.Velocity = moveVector.Unit * getgenv().AxacState.FlySpeed
                else
                    flyBV.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        hum.PlatformStand = false
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end

-- SPIN BOT 360
task.spawn(function()
    while RunService.RenderStepped:Wait() do
        if getgenv().AxacState.SpinBot then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0)
            end
        end
    end
end)

-- HITBOX EXPANDER
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AxacState.HitboxExpand then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Royal purple")
                    v.Character.HumanoidRootPart.Material = Enum.Material.Neon
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

-- ANTI VOID LOOP
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AxacState.AntiVoid then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -100 then
                hrp.Velocity = Vector3.new(0, 150, 0)
            end
        end
    end
end)

-- GHOST TRANSPARENCY
local function toggleGhost(state)
    getgenv().AxacState.GhostMode = state
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Head" then
                part.Transparency = state and 0.5 or 0
            end
        end
        applyCosmetics()
    end
end

-- FPS BOOST & SHADERS
local StoredMaterials = {}
local function toggleFps(state)
    getgenv().AxacState.FpsBoost = state
    if state then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not StoredMaterials[v] then
                StoredMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        for part, mat in pairs(StoredMaterials) do
            if part and part.Parent then part.Material = mat end
        end
        table.clear(StoredMaterials)
    end
end

local CC = Lighting:FindFirstChild("AxacCC") or Instance.new("ColorCorrectionEffect", Lighting)
CC.Name = "AxacCC"
CC.Enabled = false

local function toggleShaders(state)
    getgenv().AxacState.Shaders = state
    CC.Brightness = state and 0.05 or 0
    CC.Contrast = state and 0.25 or 0
    CC.Saturation = state and 0.4 or 0
    CC.Enabled = state
end

-- NOCLIP LOOP
RunService.Stepped:Connect(function()
    if getgenv().AxacState.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if getgenv().AxacState.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ESP PLAYER
local function updateEsp()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = plr.Character:FindFirstChild("AxacHighlight")
            if getgenv().AxacState.EspPlayer then
                if not highlight then
                    highlight = Instance.new("Highlight", plr.Character)
                    highlight.Name = "AxacHighlight"
                    highlight.FillColor = Color3.fromRGB(230, 80, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

-- FULLBRIGHT
local origBrightness = Lighting.Brightness
local origClock = Lighting.TimeOfDay
local function toggleFullbright(state)
    getgenv().AxacState.Fullbright = state
    if state then
        Lighting.Brightness = 3
        Lighting.TimeOfDay = "12:00:00"
    else
        Lighting.Brightness = origBrightness
        Lighting.TimeOfDay = origClock
    end
end

-- TELEPORT TOOL
local function giveTpTool()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.Name = "⚡ Axac TP Tool"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local pos = mouse.Hit.Position + Vector3.new(0, 3, 0)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end

-- STATS LOOP
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AxacState.EspPlayer then updateEsp() end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.WalkSpeed = getgenv().AxacState.WalkSpeedFast and 75 or 16
            hum.JumpPower = getgenv().AxacState.HighJump and 130 or 50
            if hum:FindFirstChild("JumpHeight") then
                hum.JumpHeight = getgenv().AxacState.HighJump and 28 or 7.2
            end
        end
        Workspace.Gravity = getgenv().AxacState.LowGravity and 40 or 196.2
    end
end)

-- GUI SETUP (VERMEIL SIGNATURE THEME)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxacGithubGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 350)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 24)
MainFrame.BackgroundTransparency = 0.15
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 22)

local FrameGlow = Instance.new("UIStroke", MainFrame)
FrameGlow.Color = Color3.fromRGB(220, 90, 255)
FrameGlow.Thickness = 2.5

-- GAMBAR VERMEIL UTAMA (KANAN)
local VermeilImageRight = Instance.new("ImageLabel")
VermeilImageRight.Size = UDim2.new(0, 185, 0, 270)
VermeilImageRight.Position = UDim2.new(1, -175, 1, -260)
VermeilImageRight.BackgroundTransparency = 1
VermeilImageRight.Image = vermeilAsset
VermeilImageRight.ScaleType = Enum.ScaleType.Fit
VermeilImageRight.ZIndex = 3
VermeilImageRight.Parent = MainFrame

-- GAMBAR VERMEIL CHIBI (KIRI BAWAH)
local VermeilChibiLeft = Instance.new("ImageLabel")
VermeilChibiLeft.Size = UDim2.new(0, 90, 0, 90)
VermeilChibiLeft.Position = UDim2.new(0, 5, 1, -95)
VermeilChibiLeft.BackgroundTransparency = 1
VermeilChibiLeft.Image = vermeilAsset
VermeilChibiLeft.ScaleType = Enum.ScaleType.Fit
VermeilChibiLeft.ZIndex = 4
VermeilChibiLeft.Parent = MainFrame

-- TEKS "AXAC MULAI DARI NOL ⚜"
local QuoteText = Instance.new("TextLabel")
QuoteText.Size = UDim2.new(0, 170, 0, 24)
QuoteText.Position = UDim2.new(1, -172, 1, -275)
QuoteText.BackgroundTransparency = 1
QuoteText.Text = "Axac Mulai Dari Nol ⚜"
QuoteText.TextColor3 = Color3.fromRGB(255, 215, 120)
QuoteText.TextSize = 11
QuoteText.Font = Enum.Font.GothamBold
QuoteText.TextStrokeTransparency = 0.4
QuoteText.ZIndex = 4
QuoteText.Parent = MainFrame

-- COPYRIGHT AXAC OFFICIAL
local CopyrightText = Instance.new("TextLabel")
CopyrightText.Size = UDim2.new(0, 250, 0, 18)
CopyrightText.Position = UDim2.new(0, 100, 1, -20)
CopyrightText.BackgroundTransparency = 1
CopyrightText.Text = "© 2026 Axac Hub — All Rights Reserved"
CopyrightText.TextColor3 = Color3.fromRGB(180, 140, 210)
CopyrightText.TextSize = 9
CopyrightText.Font = Enum.Font.GothamSemibold
CopyrightText.TextXAlignment = Enum.TextXAlignment.Left
CopyrightText.ZIndex = 4
CopyrightText.Parent = MainFrame

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 48)
HeaderBar.BackgroundColor3 = Color3.fromRGB(38, 10, 56)
HeaderBar.BackgroundTransparency = 0.2
HeaderBar.Parent = MainFrame

local HeaderVermeilIcon = Instance.new("ImageLabel")
HeaderVermeilIcon.Size = UDim2.new(0, 38, 0, 38)
HeaderVermeilIcon.Position = UDim2.new(0, 10, 0.5, -19)
HeaderVermeilIcon.BackgroundTransparency = 1
HeaderVermeilIcon.Image = vermeilAsset
HeaderVermeilIcon.ScaleType = Enum.ScaleType.Fit
HeaderVermeilIcon.Parent = HeaderBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 52, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ AXAC VERMEIL EXCLUSIVE EDITION ⚜"
Title.TextColor3 = Color3.fromRGB(255, 200, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBar

makeDraggable(MainFrame)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(0, 330, 1, -78)
ScrollContainer.Position = UDim2.new(0, 12, 0, 52)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1020)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(220, 100, 255)
ScrollContainer.ZIndex = 4
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollContainer)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function createHeaderSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -10, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Text = "━━━━ " .. titleText .. " ━━━━"
    sec.TextColor3 = Color3.fromRGB(255, 180, 120)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 10
    sec.ZIndex = 5
    sec.Parent = ScrollContainer
end

local function createToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(160, 45, 210) or Color3.fromRGB(48, 15, 72)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.ZIndex = 5
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(180, 70, 230)
    stroke.Thickness = 1

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(160, 45, 210) or Color3.fromRGB(48, 15, 72)
        callback(state)
    end)
end

local function createButton(symbol, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(75, 25, 110)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 230, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = symbol .. " " .. labelText
    btn.ZIndex = 5
    btn.Parent = ScrollContainer

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(210, 100, 255)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(callback)
end

-- FLY SPEED CONTROLLER
local FlySpeedFrame = Instance.new("Frame")
FlySpeedFrame.Size = UDim2.new(1, -10, 0, 42)
FlySpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
FlySpeedFrame.ZIndex = 5
FlySpeedFrame.Parent = ScrollContainer

local FlyCorner = Instance.new("UICorner", FlySpeedFrame)
FlyCorner.CornerRadius = UDim.new(0, 10)

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(0.5, 0, 1, 0)
FlyLabel.Position = UDim2.new(0, 10, 0, 0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "🕊️ FLY SPEED: " .. getgenv().AxacState.FlySpeed
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.Font = Enum.Font.GothamSemibold
FlyLabel.TextSize = 10
FlyLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyLabel.ZIndex = 6
FlyLabel.Parent = FlySpeedFrame

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 28, 0, 28)
BtnMinus.Position = UDim2.new(1, -68, 0.5, -14)
BtnMinus.BackgroundColor3 = Color3.fromRGB(140, 45, 185)
BtnMinus.Text = "-"
BtnMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.ZIndex = 6
BtnMinus.Parent = FlySpeedFrame
Instance.new("UICorner", BtnMinus).CornerRadius = UDim.new(0, 6)

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 28, 0, 28)
BtnPlus.Position = UDim2.new(1, -34, 0.5, -14)
BtnPlus.BackgroundColor3 = Color3.fromRGB(140, 45, 185)
BtnPlus.Text = "+"
BtnPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnPlus.Font = Enum.Font.GothamBold
BtnPlus.ZIndex = 6
BtnPlus.Parent = FlySpeedFrame
Instance.new("UICorner", BtnPlus).CornerRadius = UDim.new(0, 6)

BtnMinus.MouseButton1Click:Connect(function()
    getgenv().AxacState.FlySpeed = math.max(10, getgenv().AxacState.FlySpeed - 20)
    FlyLabel.Text = "🕊️ FLY SPEED: " .. getgenv().AxacState.FlySpeed
end)

BtnPlus.MouseButton1Click:Connect(function()
    getgenv().AxacState.FlySpeed = math.min(350, getgenv().AxacState.FlySpeed + 20)
    FlyLabel.Text = "🕊️ FLY SPEED: " .. getgenv().AxacState.FlySpeed
end)

-- OPEN BUTTON
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "AxacGithubOpenBtn"
OpenBtn.Size = UDim2.new(0, 56, 0, 56)
OpenBtn.Position = UDim2.new(0, 15, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 120)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Image = vermeilAsset
OpenBtn.ScaleType = Enum.ScaleType.Fit
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(1, 0)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(220, 120, 255)
OpenStroke.Thickness = 2.5

makeDraggable(OpenBtn)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- SETUP KATEGORI & FITUR
createHeaderSection("CHARACTER & MOVEMENT")
createToggle("🕊️", "FLY MODE", false, toggleFly)
createToggle("🏃", "FAST WALKSPEED", false, function(s) getgenv().AxacState.WalkSpeedFast = s end)
createToggle("🦘", "HIGH JUMP POWER", false, function(s) getgenv().AxacState.HighJump = s end)
createToggle("🧱", "NOCLIP (TEMBUS WALL)", false, function(s) getgenv().AxacState.Noclip = s end)
createToggle("🦘", "INFINITE JUMP", false, function(s) getgenv().AxacState.InfiniteJump = s end)
createToggle("🌌", "LOW GRAVITY MODE", false, function(s) getgenv().AxacState.LowGravity = s end)

createHeaderSection("ACCESSORIES & COSMETICS")
createToggle("👤", "HEADLESS MODE", false, function(s) getgenv().AxacState.Headless = s; applyCosmetics() end)
createToggle("🦵", "KORBLOX RIGHT LEG", false, function(s) getgenv().AxacState.Korblox = s; applyCosmetics() end)
createToggle("🌸", "PINK DEMON HORNS", false, function(s) getgenv().AxacState.DemonHorns = s; applyCosmetics() end)
createToggle("👑", "GOLDEN CYBER HALO", false, function(s) getgenv().AxacState.GoldenHalo = s; applyCosmetics() end)
createToggle("🎒", "TACTICAL CYBER WINGS", false, function(s) getgenv().AxacState.CyberWings = s; applyCosmetics() end)
createToggle("⚔️", "DUAL KATANA BACK", false, function(s) getgenv().AxacState.DualKatana = s; applyCosmetics() end)
createToggle("✨", "RGB AVATAR GLOW", false, function(s) getgenv().AxacState.RgbAvatar = s end)
createToggle("👻", "GHOST INVISIBLE MODE", false, toggleGhost)

createHeaderSection("EXPLOITS & PAMER")
createButton("⚡", "GET TELEPORT CLICK TOOL", giveTpTool)
createToggle("🌀", "SPIN BOT 360", false, function(s) getgenv().AxacState.SpinBot = s end)
createToggle("🎯", "HITBOX EXPANDER", false, function(s) getgenv().AxacState.HitboxExpand = s end)
createToggle("🛡️", "ANTI-VOID FALL PROTECTION", false, function(s) getgenv().AxacState.AntiVoid = s end)

createHeaderSection("VISUALS & SYSTEM")
createToggle("👁️", "ESP PLAYER WALLHACK", false, function(s) getgenv().AxacState.EspPlayer = s; updateEsp() end)
createToggle("☀️", "FULLBRIGHT (MODE TERANG)", false, toggleFullbright)
createToggle("🌈", "RGB OUTLINE MODE", false, function(s) getgenv().AxacState.RgbMode = s end)
createToggle("⚡", "MAX FPS BOOST", false, toggleFps)
createToggle("✦", "P35 SHADERS", false, toggleShaders)

-- LOOP RGB MODE
task.spawn(function()
    local hue = 0
    while RunService.RenderStepped:Wait() do
        hue = (hue + 0.005) % 1
        local rgbColor = Color3.fromHSV(hue, 0.8, 1)

        if getgenv().AxacState.RgbMode then
            FrameGlow.Color = rgbColor
            OpenStroke.Color = rgbColor
        else
            FrameGlow.Color = Color3.fromRGB(220, 90, 255)
            OpenStroke.Color = Color3.fromRGB(220, 120, 255)
        end

        local char = LocalPlayer.Character
        if char then
            local highlight = char:FindFirstChild("AxacAvatarGlow")
            if getgenv().AxacState.RgbAvatar then
                if not highlight then
                    highlight = Instance.new("Highlight", char)
                    highlight.Name = "AxacAvatarGlow"
                end
                highlight.FillColor = rgbColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    applyCosmetics()
    if getgenv().AxacState.Fly then toggleFly(true) end
end)

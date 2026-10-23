-- AXAC ALL IN ONE [Axac Vermeil Exclusive Edition - ENHANCED VISUALS & DYNAMIC UI BUILD]
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
    DemonHorns = false,
    GoldenHalo = false,
    CyberWings = false,
    DualKatana = false,
    ZombieAnim = false,
    SubMenuOpen = false
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

local function applyCosmetics()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0)
        local face = head:FindFirstChild("face")
        if face then face.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0) end
    end

    if hum then
        pcall(function()
            local desc = hum:GetAppliedDescription()
            if getgenv().AxacState.Korblox then
                desc.RightLeg = 139603750
            else
                desc.RightLeg = 0
            end
            hum:ApplyDescription(desc)
        end)
    end

    local rLower = char:FindFirstChild("RightLowerLeg")
    local rFoot = char:FindFirstChild("RightFoot")
    if getgenv().AxacState.Korblox then
        if rFoot then rFoot.Transparency = 1 end
        if rLower then rLower.Transparency = 0 end
    else
        if rFoot then rFoot.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
        if rLower then rLower.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
    end

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

local function applyZombieAnimation(state)
    getgenv().AxacState.ZombieAnim = state
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        animate.Enabled = not state
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
        if state then
            local zombieAnimate = Instance.new("LocalScript")
            zombieAnimate.Name = "AxacZombieAnimate"
            zombieAnimate.Parent = char
            zombieAnimate.Source = [[
                local plr = game.Players.LocalPlayer
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hum = char:WaitForChild("Humanoid")
                while char.Parent and hum.Health > 0 do task.wait(0.1) end
            ]]
            zombieAnimate.Disabled = false
        else
            if char:FindFirstChild("AxacZombieAnimate") then
                char.AxacZombieAnimate:Destroy()
            end
            animate.Enabled = true
        end
    end
end

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
                    local moveVector = (camCFrame.RightVector * moveDir.X) + (camCFrame.LookVector * moveDir.Z)
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

local Atmos = Lighting:FindFirstChild("AxacAtmos") or Instance.new("Atmosphere", Lighting)
Atmos.Name = "AxacAtmos"
Atmos.Enabled = false

local function toggleShaders(state)
    getgenv().AxacState.Shaders = state
    CC.Brightness = state and 0.15 or 0
    CC.Contrast = state and 0.4 or 0
    CC.Saturation = state and 0.6 or 0
    CC.TintColor = Color3.fromRGB(255, 230, 255)
    CC.Enabled = state

    Atmos.Density = state and 0.4 or 0.25
    Atmos.Offset = state and 0.3 or 0
    Atmos.Color = Color3.fromRGB(210, 160, 240)
    Atmos.Decay = Color3.fromRGB(80, 30, 100)
    Atmos.Enabled = state
end

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

UserInputService.JumpRequest:Connect(function()
    if getgenv().AxacState.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum:ChangeState(Enum.HumanoidStateType.Jumping) 
            hum.JumpPower = 150
            hum.JumpHeight = 35
        end
    end
end)

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

local function toggleFullbright(state)
    getgenv().AxacState.Fullbright = state
    if state then
        Lighting.Brightness = 10
        Lighting.ClockTime = 14
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.GlobalShadows = true
    end
end

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

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AxacState.EspPlayer then updateEsp() end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.UseJumpPower = true
                hum.WalkSpeed = getgenv().AxacState.WalkSpeedFast and 80 or 16
                if getgenv().AxacState.HighJump then
                    hum.JumpPower = 150
                    if hum:FindFirstChild("JumpHeight") then
                        hum.JumpHeight = 35
                    end
                else
                    hum.JumpPower = 50
                    if hum:FindFirstChild("JumpHeight") then
                        hum.JumpHeight = 7.2
                    end
                end
            end)
        end
        Workspace.Gravity = getgenv().AxacState.LowGravity and 40 or 196.2
    end
end)

-- ENHANCED GUI SETUP: ADDED GLOWING EFFECTS, DYNAMIC BADGES, AND STATUS FOOTER
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxacGithubGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 3, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = false
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)

local BgGradient = Instance.new("UIGradient", MainFrame)
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 12, 70)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(18, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 2, 14))
})
BgGradient.Rotation = 60

local OuterGlow = Instance.new("UIStroke", MainFrame)
OuterGlow.Name = "OuterAura"
OuterGlow.Color = Color3.fromRGB(255, 255, 255)
OuterGlow.Transparency = 0.25
OuterGlow.Thickness = 3.5

local FrameGlow = Instance.new("UIStroke", MainFrame)
FrameGlow.Name = "InnerGlow"
FrameGlow.Color = Color3.fromRGB(255, 120, 255)
FrameGlow.Thickness = 1.8

local VermeilImageRight = Instance.new("ImageLabel")
VermeilImageRight.Size = UDim2.new(0, 190, 0, 280)
VermeilImageRight.Position = UDim2.new(1, -180, 1, -270)
VermeilImageRight.BackgroundTransparency = 1
VermeilImageRight.Image = vermeilAsset
VermeilImageRight.ScaleType = Enum.ScaleType.Fit
VermeilImageRight.ZIndex = 9
VermeilImageRight.Parent = MainFrame

local VermeilChibiLeft = Instance.new("ImageLabel")
VermeilChibiLeft.Size = UDim2.new(0, 85, 0, 85)
VermeilChibiLeft.Position = UDim2.new(0, 8, 1, -90)
VermeilChibiLeft.BackgroundTransparency = 1
VermeilChibiLeft.Image = vermeilAsset
VermeilChibiLeft.ScaleType = Enum.ScaleType.Fit
VermeilChibiLeft.ZIndex = 9
VermeilChibiLeft.Parent = MainFrame

-- DYNAMIC STATUS FOOTER
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 22)
StatusBar.Position = UDim2.new(0, 10, 1, -28)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 6, 32)
StatusBar.BackgroundTransparency = 0.3
StatusBar.ZIndex = 12
StatusBar.Parent = MainFrame
Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 6)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 5, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "⚜ AXAC HUB v6.0 | STATUS: ACTIVE | ENGINE: READY"
StatusText.TextColor3 = Color3.fromRGB(220, 180, 255)
StatusText.TextSize = 9
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 13
StatusText.Parent = StatusBar

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 48)
HeaderBar.BackgroundColor3 = Color3.fromRGB(30, 8, 48)
HeaderBar.BackgroundTransparency = 0.2
HeaderBar.ZIndex = 15
HeaderBar.Parent = MainFrame

local HeaderVermeilIcon = Instance.new("ImageLabel")
HeaderVermeilIcon.Size = UDim2.new(0, 38, 0, 38)
HeaderVermeilIcon.Position = UDim2.new(0, 10, 0.5, -19)
HeaderVermeilIcon.BackgroundTransparency = 1
HeaderVermeilIcon.Image = vermeilAsset
HeaderVermeilIcon.ScaleType = Enum.ScaleType.Fit
HeaderVermeilIcon.ZIndex = 16
HeaderVermeilIcon.Parent = HeaderBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -160, 1, 0)
Title.Position = UDim2.new(0, 52, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ AXAC VERMEIL EXCLUSIVE EDITION ⚜"
Title.TextColor3 = Color3.fromRGB(255, 210, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 16
Title.Parent = HeaderBar

makeDraggable(MainFrame)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(0, 335, 1, -85)
ScrollContainer.Position = UDim2.new(0, 12, 0, 52)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1020)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(220, 100, 255)
ScrollContainer.ZIndex = 15
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollContainer)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)


local function createHeaderSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -10, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Text = "━━━━ " .. titleText .. " ━━━━"
    sec.TextColor3 = Color3.fromRGB(255, 185, 120)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 10
    sec.ZIndex = 16
    sec.Parent = ScrollContainer
end

local function createToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(170, 50, 220) or Color3.fromRGB(45, 12, 68)
    btn.BackgroundTransparency = 0.15
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.ZIndex = 16
    btn.Parent = ScrollContainer

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = defaultState and Color3.fromRGB(255, 140, 255) or Color3.fromRGB(150, 60, 200)
    stroke.Thickness = 1.2

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(170, 50, 220) or Color3.fromRGB(45, 12, 68)
        stroke.Color = state and Color3.fromRGB(255, 140, 255) or Color3.fromRGB(150, 60, 200)
        callback(state)
    end)
end

local function createButton(symbol, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(80, 28, 120)
    btn.BackgroundTransparency = 0.15
    btn.TextColor3 = Color3.fromRGB(255, 235, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Text = symbol .. " " .. labelText
    btn.ZIndex = 16
    btn.Parent = ScrollContainer

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(220, 110, 255)
    stroke.Thickness = 1.2

    btn.MouseButton1Click:Connect(callback)
end

local FlySpeedFrame = Instance.new("Frame")
FlySpeedFrame.Size = UDim2.new(1, -10, 0, 42)
FlySpeedFrame.BackgroundColor3 = Color3.fromRGB(42, 14, 62)
FlySpeedFrame.BackgroundTransparency = 0.15
FlySpeedFrame.ZIndex = 16
FlySpeedFrame.Parent = ScrollContainer

Instance.new("UICorner", FlySpeedFrame).CornerRadius = UDim.new(0, 10)

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(0.5, 0, 1, 0)
FlyLabel.Position = UDim2.new(0, 10, 0, 0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "🕊️ FLY SPEED: " .. getgenv().AxacState.FlySpeed
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.Font = Enum.Font.GothamSemibold
FlyLabel.TextSize = 10
FlyLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyLabel.ZIndex = 17
FlyLabel.Parent = FlySpeedFrame

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 28, 0, 28)
BtnMinus.Position = UDim2.new(1, -68, 0.5, -14)
BtnMinus.BackgroundColor3 = Color3.fromRGB(150, 48, 195)
BtnMinus.Text = "-"
BtnMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.ZIndex = 17
BtnMinus.Parent = FlySpeedFrame
Instance.new("UICorner", BtnMinus).CornerRadius = UDim.new(0, 6)

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 28, 0, 28)
BtnPlus.Position = UDim2.new(1, -34, 0.5, -14)
BtnPlus.BackgroundColor3 = Color3.fromRGB(150, 48, 195)
BtnPlus.Text = "+"
BtnPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnPlus.Font = Enum.Font.GothamBold
BtnPlus.ZIndex = 17
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

local SubMenuFrame = Instance.new("Frame")
SubMenuFrame.Size = UDim2.new(0, 225, 0, 335)
SubMenuFrame.Position = UDim2.new(0, 70, 0, 50)
SubMenuFrame.BackgroundColor3 = Color3.fromRGB(16, 4, 26)
SubMenuFrame.BackgroundTransparency = 0.05
SubMenuFrame.Visible = false
SubMenuFrame.ZIndex = 30
SubMenuFrame.Parent = MainFrame

Instance.new("UICorner", SubMenuFrame).CornerRadius = UDim.new(0, 16)
local SubStroke = Instance.new("UIStroke", SubMenuFrame)
SubStroke.Color = Color3.fromRGB(255, 255, 255)
SubStroke.Transparency = 0.2
SubStroke.Thickness = 2.2

local SubScroll = Instance.new("ScrollingFrame")
SubScroll.Size = UDim2.new(1, -10, 1, -10)
SubScroll.Position = UDim2.new(0, 5, 0, 5)
SubScroll.BackgroundTransparency = 1
SubScroll.CanvasSize = UDim2.new(0, 0, 0, 420)
SubScroll.ScrollBarThickness = 3
SubScroll.ZIndex = 31
SubScroll.Parent = SubMenuFrame

local SubLayout = Instance.new("UIListLayout", SubScroll)
SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
SubLayout.Padding = UDim.new(0, 6)

local function createSubToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 34)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(170, 50, 220) or Color3.fromRGB(45, 12, 68)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.ZIndex = 32
    btn.Parent = SubScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(170, 50, 220) or Color3.fromRGB(45, 12, 68)
        callback(state)
    end)
end

local SubHeader = Instance.new("TextLabel")
SubHeader.Size = UDim2.new(1, -5, 0, 24)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "✦ ACCESSORIES MENU ✦"
SubHeader.TextColor3 = Color3.fromRGB(255, 215, 120)
SubHeader.Font = Enum.Font.GothamBold
SubHeader.TextSize = 11
SubHeader.ZIndex = 32
SubHeader.Parent = SubScroll

createSubToggle("👤", "HEADLESS MODE", false, function(s) getgenv().AxacState.Headless = s; applyCosmetics() end)
createSubToggle("🦵", "KORBLOX RIGHT LEG", false, function(s) getgenv().AxacState.Korblox = s; applyCosmetics() end)
createSubToggle("🌸", "PINK DEMON HORNS", false, function(s) getgenv().AxacState.DemonHorns = s; applyCosmetics() end)
createSubToggle("👑", "GOLDEN CYBER HALO", false, function(s) getgenv().AxacState.GoldenHalo = s; applyCosmetics() end)
createSubToggle("🎒", "TACTICAL CYBER WINGS", false, function(s) getgenv().AxacState.CyberWings = s; applyCosmetics() end)
createSubToggle("⚔️", "DUAL KATANA BACK", false, function(s) getgenv().AxacState.DualKatana = s; applyCosmetics() end)
createSubToggle("🧟", "ZOMBIE ANIMATION", false, applyZombieAnimation)
createSubToggle("✨", "RGB AVATAR GLOW", false, function(s) getgenv().AxacState.RgbAvatar = s end)
createSubToggle("👻", "GHOST INVISIBLE MODE", false, toggleGhost)

local AccMenuBtn = Instance.new("TextButton")
AccMenuBtn.Size = UDim2.new(0, 115, 0, 32)
AccMenuBtn.Position = UDim2.new(1, -125, 0, 8)
AccMenuBtn.BackgroundColor3 = Color3.fromRGB(100, 32, 155)
AccMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AccMenuBtn.TextSize = 9
AccMenuBtn.Font = Enum.Font.GothamBold
AccMenuBtn.Text = "🎒 ACCESSORIES"
AccMenuBtn.ZIndex = 20
AccMenuBtn.Parent = HeaderBar
Instance.new("UICorner", AccMenuBtn).CornerRadius = UDim.new(0, 8)

AccMenuBtn.MouseButton1Click:Connect(function()
    getgenv().AxacState.SubMenuOpen = not getgenv().AxacState.SubMenuOpen
    SubMenuFrame.Visible = getgenv().AxacState.SubMenuOpen
end)

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "AxacGithubOpenBtn"
OpenBtn.Size = UDim2.new(0, 56, 0, 56)
OpenBtn.Position = UDim2.new(0, 15, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 120)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Image = vermeilAsset
OpenBtn.ScaleType = Enum.ScaleType.Fit
OpenBtn.ZIndex = 100
OpenBtn.Parent = ScreenGui

Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 2.5

makeDraggable(OpenBtn)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

createHeaderSection("CHARACTER & MOVEMENT")
createToggle("🕊️", "FLY MODE", false, toggleFly)
createToggle("🏃", "FAST WALKSPEED", false, function(s) getgenv().AxacState.WalkSpeedFast = s end)
createToggle("🦘", "HIGH JUMP POWER", false, function(s) getgenv().AxacState.HighJump = s end)
createToggle("🧱", "NOCLIP (TEMBUS WALL)", false, function(s) getgenv().AxacState.Noclip = s end)
createToggle("🦘", "INFINITE JUMP", false, function(s) getgenv().AxacState.InfiniteJump = s end)
createToggle("🌌", "LOW GRAVITY MODE", false, function(s) getgenv().AxacState.LowGravity = s end)

createHeaderSection("EXPLOITS & PAMER")
createButton("⚡", "GET TELEPORT CLICK TOOL", giveTpTool)
createToggle("🌀", "SPIN BOT 360", false, function(s) getgenv().AxacState.SpinBot = s end)
createToggle("🎯", "HITBOX EXPANDER", false, function(s) getgenv().AxacState.HitboxExpand = s end)
createToggle("🛡️", "ANTI-VOID FALL PROTECTION", false, function(s) getgenv().AxacState.AntiVoid = s end)

createHeaderSection("VISUALS & SYSTEM")
createToggle("👁️", "ESP PLAYER WALLHACK", false, function(s) getgenv().AxacState.EspPlayer = s; updateEsp() end)
createToggle("☀️", "FULLBRIGHT (MAXIMUM)", false, toggleFullbright)
createToggle("🌈", "RGB OUTLINE MODE", false, function(s) getgenv().AxacState.RgbMode = s end)
createToggle("⚡", "MAX FPS BOOST", false, toggleFps)
createToggle("✦", "P35 ULTRA SHADERS", false, toggleShaders)

task.spawn(function()
    local hue = 0
    while RunService.RenderStepped:Wait() do
        hue = (hue + 0.003) % 1
        local rgbColor = Color3.fromHSV(hue, 0.85, 1)

        if getgenv().AxacState.RgbMode then
            FrameGlow.Color = rgbColor
            OuterGlow.Color = rgbColor
            OpenStroke.Color = rgbColor
        else
            FrameGlow.Color = Color3.fromRGB(255, 120, 255)
            OuterGlow.Color = Color3.fromRGB(255, 255, 255)
            OpenStroke.Color = Color3.fromRGB(255, 255, 255)
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
    task.wait(0.8)
    applyCosmetics()
    if getgenv().AxacState.Fly then toggleFly(true) end
    if getgenv().AxacState.ZombieAnim then applyZombieAnimation(true) end
end)

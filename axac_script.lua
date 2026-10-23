-- AXAC ALL IN ONE [Axac Vermeil Exclusive Edition - ULTRA FEATURED]
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
    RgbAvatar = false
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

-- COSMETICS (KORBLOX & HEADLESS ULTRA FIX)
local function applyCosmetics()
    local char = LocalPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0)
        local face = head:FindFirstChild("face")
        if face then face.Transparency = getgenv().AxacState.Headless and 1 or (getgenv().AxacState.GhostMode and 0.5 or 0) end
    end

    local rUpper = char:FindFirstChild("RightUpperLeg")
    local rLower = char:FindFirstChild("RightLowerLeg")
    local rFoot = char:FindFirstChild("RightFoot")

    if getgenv().AxacState.Korblox then
        if rUpper then rUpper.Transparency = 1 end
        if rFoot then rFoot.Transparency = 1 end
        if rLower then
            rLower.Transparency = 0
            for _, child in pairs(rLower:GetChildren()) do
                if child:IsA("CharacterMesh") or child:IsA("WrapTarget") then child:Destroy() end
            end
            local mesh = rLower:FindFirstChild("KorbloxRealMesh") or Instance.new("SpecialMesh", rLower)
            mesh.Name = "KorbloxRealMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://902942093"
            mesh.TextureId = "rbxassetid://902843398"
            mesh.Scale = Vector3.new(1.05, 1.05, 1.05)
        end
    else
        if rUpper then rUpper.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
        if rFoot then rFoot.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0 end
        if rLower then
            if rLower:FindFirstChild("KorbloxRealMesh") then rLower.KorbloxRealMesh:Destroy() end
            rLower.Transparency = getgenv().AxacState.GhostMode and 0.5 or 0
        end
    end
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

-- SPIN BOT / ANTI-AIM
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

-- GHOST TRANSPARENCY MODE
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
    CC.Contrast = state and 0.2 or 0
    CC.Saturation = state and 0.3 or 0
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
                    highlight.FillColor = Color3.fromRGB(210, 90, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
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

-- LOOP FORCE APPLY STATS
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
    end
end)

-- GUI SETUP (LANDSCAPE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxacGithubGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 8, 28)
MainFrame.BackgroundTransparency = 0.25
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 20)

local FrameGlow = Instance.new("UIStroke", MainFrame)
FrameGlow.Color = Color3.fromRGB(210, 100, 255)
FrameGlow.Thickness = 2.5

-- GAMBAR VERMEIL KANAN
local VermeilImageRight = Instance.new("ImageLabel")
VermeilImageRight.Size = UDim2.new(0, 175, 0, 260)
VermeilImageRight.Position = UDim2.new(1, -165, 1, -250)
VermeilImageRight.BackgroundTransparency = 1
VermeilImageRight.Image = vermeilAsset
VermeilImageRight.ScaleType = Enum.ScaleType.Fit
VermeilImageRight.ZIndex = 3
VermeilImageRight.Parent = MainFrame

-- TEKS ESTETIK "AXAC MULAI DARI NOL" DI ATAS VERMEIL
local QuoteText = Instance.new("TextLabel")
QuoteText.Size = UDim2.new(0, 160, 0, 24)
QuoteText.Position = UDim2.new(1, -162, 1, -260)
QuoteText.BackgroundTransparency = 1
QuoteText.Text = "Axac Mulai Dari Nol ⚜"
QuoteText.TextColor3 = Color3.fromRGB(240, 180, 255)
QuoteText.TextSize = 11
QuoteText.Font = Enum.Font.GothamBold
QuoteText.TextStrokeTransparency = 0.5
QuoteText.ZIndex = 4
QuoteText.Parent = MainFrame

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 45)
HeaderBar.BackgroundColor3 = Color3.fromRGB(45, 15, 65)
HeaderBar.BackgroundTransparency = 0.25
HeaderBar.Parent = MainFrame

local HeaderVermeilIcon = Instance.new("ImageLabel")
HeaderVermeilIcon.Size = UDim2.new(0, 35, 0, 35)
HeaderVermeilIcon.Position = UDim2.new(0, 10, 0.5, -17)
HeaderVermeilIcon.BackgroundTransparency = 1
HeaderVermeilIcon.Image = vermeilAsset
HeaderVermeilIcon.ScaleType = Enum.ScaleType.Fit
HeaderVermeilIcon.Parent = HeaderBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ AXAC VERMEIL EXCLUSIVE EDITION ⚜"
Title.TextColor3 = Color3.fromRGB(245, 190, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBar

makeDraggable(MainFrame)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(0, 330, 1, -58)
ScrollContainer.Position = UDim2.new(0, 12, 0, 50)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 720)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(210, 90, 255)
ScrollContainer.ZIndex = 4
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function createToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 50, 200) or Color3.fromRGB(50, 20, 75)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.ZIndex = 5
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 50, 200) or Color3.fromRGB(50, 20, 75)
        callback(state)
    end)
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
FlyLabel.Position = UDim2.new(0, 12, 0, 0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "🕊️ FLY SPEED: " .. getgenv().AxacState.FlySpeed
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.Font = Enum.Font.GothamSemibold
FlyLabel.TextSize = 11
FlyLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyLabel.ZIndex = 6
FlyLabel.Parent = FlySpeedFrame

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 32, 0, 30)
BtnMinus.Position = UDim2.new(1, -75, 0.5, -15)
BtnMinus.BackgroundColor3 = Color3.fromRGB(130, 45, 175)
BtnMinus.Text = "-"
BtnMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.ZIndex = 6
BtnMinus.Parent = FlySpeedFrame
Instance.new("UICorner", BtnMinus).CornerRadius = UDim.new(0, 6)

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 32, 0, 30)
BtnPlus.Position = UDim2.new(1, -38, 0.5, -15)
BtnPlus.BackgroundColor3 = Color3.fromRGB(130, 45, 175)
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

-- ALL TOGGLES
createToggle("🌈", "RGB OUTLINE MODE", false, function(s) getgenv().AxacState.RgbMode = s end)
createToggle("✨", "RGB AVATAR GLOW (PAMER)", false, function(s) getgenv().AxacState.RgbAvatar = s end)
createToggle("🌀", "SPIN BOT 360", false, function(s) getgenv().AxacState.SpinBot = s end)
createToggle("👻", "GHOST INVISIBLE MODE", false, toggleGhost)
createToggle("🕊️", "FLY MODE", false, toggleFly)
createToggle("🏃", "FAST WALKSPEED", false, function(s) getgenv().AxacState.WalkSpeedFast = s end)
createToggle("🦘", "HIGH JUMP POWER", false, function(s) getgenv().AxacState.HighJump = s end)
createToggle("👤", "HEADLESS MODE", false, function(s) getgenv().AxacState.Headless = s; applyCosmetics() end)
createToggle("🦵", "KORBLOX RIGHT LEG", false, function(s) getgenv().AxacState.Korblox = s; applyCosmetics() end)
createToggle("🧱", "NOCLIP (TEMBUS WALL)", false, function(s) getgenv().AxacState.Noclip = s end)
createToggle("🦘", "INFINITE JUMP", false, function(s) getgenv().AxacState.InfiniteJump = s end)
createToggle("👁️", "ESP PLAYER WALLHACK", false, function(s) getgenv().AxacState.EspPlayer = s; updateEsp() end)
createToggle("☀️", "FULLBRIGHT (MODE TERANG)", false, toggleFullbright)
createToggle("⚡", "MAX FPS BOOST", false, toggleFps)
createToggle("✦", "P35 SHADERS", false, toggleShaders)

-- LOOP RGB MODE & AVATAR GLOW
task.spawn(function()
    local hue = 0
    while RunService.RenderStepped:Wait() do
        hue = (hue + 0.005) % 1
        local rgbColor = Color3.fromHSV(hue, 0.8, 1)

        -- RGB Outline GUI
        if getgenv().AxacState.RgbMode then
            FrameGlow.Color = rgbColor
            OpenStroke.Color = rgbColor
        else
            FrameGlow.Color = Color3.fromRGB(210, 100, 255)
            OpenStroke.Color = Color3.fromRGB(220, 120, 255)
        end

        -- RGB Avatar Glow Pamer
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

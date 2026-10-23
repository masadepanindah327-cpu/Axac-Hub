-- AXAC ALL IN ONE [VERMEIL ULTRA EDITION]
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local VERMEIL_IMAGE_URL = "https://raw.githubusercontent.com/masadepanindah327-cpu/Axac-Hub/main/805e9cffb3636dff8a02c009f1692d1b-removebg-preview.png"

getgenv().AxacState = {
    FpsBoost = false,
    Shaders = false,
    Headless = false,
    Korblox = false,
    Fly = false,
    FlySpeed = 50,
    WalkSpeedFast = false
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
        if success and content then
            writefile(filename, content)
        end
    end
    if isfile(filename) then
        return getcustomasset(filename)
    end
    return "rbxassetid://6031094667"
end

local vermeilAsset = getOnlineAsset(VERMEIL_IMAGE_URL, "axac_vermeil_ultra.png")

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

-- EFEK BUBBLE / RIPPLE AESTHETIC
local function createBubbleEffect(button, x, y)
    local circle = Instance.new("Frame")
    circle.Name = "BubbleRipple"
    circle.BackgroundColor3 = Color3.fromRGB(235, 150, 255)
    circle.BackgroundTransparency = 0.4
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.ZIndex = 10
    circle.Parent = button

    local corner = Instance.new("UICorner", circle)
    corner.CornerRadius = UDim.new(1, 0)

    local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local tweenSize = TweenService:Create(circle, tweenInfo, {Size = UDim2.new(0, targetSize, 0, targetSize), BackgroundTransparency = 1})
    tweenSize:Play()
    tweenSize.Completed:Connect(function()
        circle:Destroy()
    end)
end

-- FIX KORBLOX & HEADLESS PERFECT RIG
local function applyCosmetics()
    local char = LocalPlayer.Character
    if not char then return end

    -- Headless Fix
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = getgenv().AxacState.Headless and 1 or 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = getgenv().AxacState.Headless and 1 or 0 end
    end

    -- Korblox Fix
    local rightLegParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
    for _, partName in ipairs(rightLegParts) do
        local p = char:FindFirstChild(partName)
        if p then
            p.Transparency = getgenv().AxacState.Korblox and 1 or 0
            for _, child in pairs(p:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = getgenv().AxacState.Korblox and 1 or 0
                end
            end
        end
    end

    local rLower = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
    if rLower then
        local existingMesh = rLower:FindFirstChild("KorbloxMeshAttachment")
        if getgenv().AxacState.Korblox then
            if not existingMesh then
                local korbloxPart = Instance.new("SpecialMesh")
                korbloxPart.Name = "KorbloxMeshAttachment"
                korbloxPart.MeshType = Enum.MeshType.FileMesh
                korbloxPart.MeshId = "rbxassetid://902942093"
                korbloxPart.TextureId = "rbxassetid://902843398"
                korbloxPart.Scale = Vector3.new(1.05, 1.05, 1.05)
                korbloxPart.Parent = rLower
            end
        else
            if existingMesh then existingMesh:Destroy() end
        end
    end
end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxacGithubGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 380)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
MainFrame.BackgroundTransparency = 0.25
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 16)

local FrameGlow = Instance.new("UIStroke", MainFrame)
FrameGlow.Color = Color3.fromRGB(210, 100, 255)
FrameGlow.Thickness = 2

-- WATERMARK BACKGROUND VERMEIL
local BgVermeil = Instance.new("ImageLabel")
BgVermeil.Size = UDim2.new(0, 300, 0, 300)
BgVermeil.Position = UDim2.new(0.5, -150, 0.5, -130)
BgVermeil.BackgroundTransparency = 1
BgVermeil.Image = vermeilAsset
BgVermeil.ImageTransparency = 0.88
BgVermeil.Parent = MainFrame

-- GAMBAR VERMEIL KANAN
local VermeilImageRight = Instance.new("ImageLabel")
VermeilImageRight.Size = UDim2.new(0, 170, 0, 250)
VermeilImageRight.Position = UDim2.new(1, -160, 1, -240)
VermeilImageRight.BackgroundTransparency = 1
VermeilImageRight.Image = vermeilAsset
VermeilImageRight.ScaleType = Enum.ScaleType.Fit
VermeilImageRight.ZIndex = 3
VermeilImageRight.Parent = MainFrame

-- HEADER BAR WITH MINI VERMEIL
local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 45)
HeaderBar.BackgroundColor3 = Color3.fromRGB(45, 15, 65)
HeaderBar.BackgroundTransparency = 0.2
HeaderBar.Parent = MainFrame

local HeaderVermeilIcon = Instance.new("ImageLabel")
HeaderVermeilIcon.Size = UDim2.new(0, 35, 0, 35)
HeaderVermeilIcon.Position = UDim2.new(0, 8, 0.5, -17)
HeaderVermeilIcon.BackgroundTransparency = 1
HeaderVermeilIcon.Image = vermeilAsset
HeaderVermeilIcon.ScaleType = Enum.ScaleType.Fit
HeaderVermeilIcon.Parent = HeaderBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 48, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ AXAC HUB // VERMEIL EDITION ⚜"
Title.TextColor3 = Color3.fromRGB(245, 190, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBar

makeDraggable(MainFrame)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(0, 280, 1, -60)
ScrollContainer.Position = UDim2.new(0, 12, 0, 52)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 380)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 90, 255)
ScrollContainer.ZIndex = 4
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function createToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 50, 200) or Color3.fromRGB(50, 20, 75)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.ClipsDescendants = true
    btn.ZIndex = 5
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(180, 80, 230)
    stroke.Thickness = 1

    local state = defaultState
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            createBubbleEffect(btn, input.Position.X, input.Position.Y)
            state = not state
            btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(150, 50, 200) or Color3.fromRGB(50, 20, 75)
            callback(state)
        end
    end)
end

createToggle("⚡", "MAX FPS BOOST", false, function(s) end)
createToggle("✦", "P35 SHADERS", false, function(s) end)
createToggle("👤", "HEADLESS MODE", false, function(s) getgenv().AxacState.Headless = s; applyCosmetics() end)
createToggle("🦵", "KORBLOX RIGHT LEG", false, function(s) getgenv().AxacState.Korblox = s; applyCosmetics() end)
createToggle("🕊️", "FLY MODE", false, function(s) end)
createToggle("🏃", "FAST WALKSPEED", false, function(s) end)

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "AxacGithubOpenBtn"
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 120)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Image = vermeilAsset
OpenBtn.ScaleType = Enum.ScaleType.Fit
OpenBtn.ClipsDescendants = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0, 28)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(220, 120, 255)
OpenStroke.Thickness = 2

makeDraggable(OpenBtn)

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        createBubbleEffect(OpenBtn, input.Position.X, input.Position.Y)
        MainFrame.Visible = not MainFrame.Visible
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    applyCosmetics()
end)

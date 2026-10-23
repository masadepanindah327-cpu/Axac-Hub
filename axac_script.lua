
-- AXAC ALL IN ONE [VERMEIL EDITION]
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LINK RAW GAMBAR VERMEIL KAMU
local VERMEIL_IMAGE_URL = "https://raw.githubusercontent.com/masadepanindah327-cpu/Axac-Hub/main/805e9cffb3636dff8a02c009f1692d1b-removebg-preview.png"

getgenv().AxacState = {
    FpsBoost = false,
    Shaders = false,
    Headless = false,
    Korblox = false,
    Fly = false,
    FlySpeed = 50,
    WalkSpeedFast = false,
    Invisible = false,
    Fling = false
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

local vermeilImageAsset = getOnlineAsset(VERMEIL_IMAGE_URL, "axac_vermeil.png")

local function makeDraggable(guiObject)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            update(input)
        end
    end)
end

local function applyCosmetics()
    local char = LocalPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = getgenv().AxacState.Headless and 1 or 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = getgenv().AxacState.Headless and 1 or 0 end
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then
            mesh.Scale = getgenv().AxacState.Headless and Vector3.new(0, 0, 0) or Vector3.new(1.25, 1.25, 1.25)
        end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local isR15 = hum and hum.RigType == Enum.HumanoidRigType.R15

    if isR15 then
        local rUpper = char:FindFirstChild("RightUpperLeg")
        local rLower = char:FindFirstChild("RightLowerLeg")
        local rFoot = char:FindFirstChild("RightFoot")

        if getgenv().AxacState.Korblox then
            if rUpper then rUpper.Transparency = 1 end
            if rFoot then rFoot.Transparency = 1 end

            if rLower then
                rLower.Transparency = 0
                for _, v in pairs(rLower:GetChildren()) do
                    if v:IsA("CharacterMesh") or v:IsA("WrapTarget") then
                        v:Destroy()
                    end
                end

                local mesh = rLower:FindFirstChild("KorbloxMesh") or Instance.new("SpecialMesh", rLower)
                mesh.Name = "KorbloxMesh"
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxassetid://902942093"
                mesh.TextureId = "rbxassetid://902843398"
                mesh.Offset = Vector3.new(0, 0.6, 0)
                mesh.Scale = Vector3.new(1.05, 1.1, 1.05)
            end
        else
            if rUpper then rUpper.Transparency = 0 end
            if rFoot then rFoot.Transparency = 0 end
            if rLower and rLower:FindFirstChild("KorbloxMesh") then
                rLower.KorbloxMesh:Destroy()
            end
        end
    end
end

local StoredMaterials = {}
local StoredDecals = {}

local function toggleFps(state)
    getgenv().AxacState.FpsBoost = state
    if state then
        pcall(function()
            sethiddenproperty(settings().Rendering, "QualityLevel", 1)
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
        end)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not StoredMaterials[v] then
                StoredMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif (v:IsA("Decal") or v:IsA("Texture")) and not StoredDecals[v] then
                StoredDecals[v] = v.Transparency
                v.Transparency = 1
            end
        end
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Lighting.GlobalShadows = true
        end)
        for part, mat in pairs(StoredMaterials) do
            if part and part.Parent then part.Material = mat end
        end
        for decal, trans in pairs(StoredDecals) do
            if decal and decal.Parent then decal.Transparency = trans end
        end
        table.clear(StoredMaterials)
        table.clear(StoredDecals)
    end
end

local CC = Lighting:FindFirstChild("AxacCC") or Instance.new("ColorCorrectionEffect", Lighting)
CC.Name = "AxacCC"
CC.Enabled = false

local function toggleShaders(state)
    getgenv().AxacState.Shaders = state
    CC.Brightness = state and 0.05 or 0
    CC.Contrast = state and 0.15 or 0
    CC.Saturation = state and 0.25 or 0
    CC.Enabled = state
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
                    flyBV.Velocity = (cam.CFrame.LookVector * (moveDir.Magnitude * getgenv().AxacState.FlySpeed))
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
    while task.wait(0.2) do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = getgenv().AxacState.WalkSpeedFast and 60 or 16
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxacGithubGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 380)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 8, 28)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 14)

local FrameGlow = Instance.new("UIStroke", MainFrame)
FrameGlow.Color = Color3.fromRGB(180, 70, 240)
FrameGlow.Thickness = 1.5

local VermeilImage = Instance.new("ImageLabel")
VermeilImage.Name = "VermeilImage"
VermeilImage.Size = UDim2.new(0, 160, 0, 240)
VermeilImage.Position = UDim2.new(1, -150, 1, -230)
VermeilImage.BackgroundTransparency = 1
VermeilImage.Image = vermeilImageAsset
VermeilImage.ScaleType = Enum.ScaleType.Fit
VermeilImage.Parent = MainFrame

local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 44)
HeaderBar.BackgroundColor3 = Color3.fromRGB(38, 14, 56)
HeaderBar.BackgroundTransparency = 0.3
HeaderBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ AXAC HUB // VERMEIL EDITION ⚜"
Title.TextColor3 = Color3.fromRGB(235, 180, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBar

makeDraggable(MainFrame)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(0, 320, 1, -58)
ScrollContainer.Position = UDim2.new(0, 12, 0, 50)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(180, 70, 230)
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function createToggle(symbol, labelText, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(140, 45, 190) or Color3.fromRGB(48, 20, 72)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = symbol .. " " .. labelText .. ": " .. (defaultState and "ON" or "OFF")
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = symbol .. " " .. labelText .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(140, 45, 190) or Color3.fromRGB(48, 20, 72)
        callback(state)
    end)
end

createToggle("⚡", "MAX FPS BOOST", false, toggleFps)
createToggle("✦", "P35 SHADERS", false, toggleShaders)
createToggle("👤", "HEADLESS MODE", false, function(s) getgenv().AxacState.Headless = s; applyCosmetics() end)
createToggle("🦵", "KORBLOX RIGHT LEG", false, function(s) getgenv().AxacState.Korblox = s; applyCosmetics() end)
createToggle("🕊️", "FLY MODE", false, toggleFly)
createToggle("🏃", "FAST WALKSPEED", false, function(s) getgenv().AxacState.WalkSpeedFast = s end)

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "AxacGithubOpenBtn"
OpenBtn.Size = UDim2.new(0, 56, 0, 56)
OpenBtn.Position = UDim2.new(0, 15, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(75, 25, 110)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Image = vermeilImageAsset
OpenBtn.ScaleType = Enum.ScaleType.Fit
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0, 28)

makeDraggable(OpenBtn)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    applyCosmetics()
    if getgenv().AxacState.Fly then toggleFly(true) end
end)

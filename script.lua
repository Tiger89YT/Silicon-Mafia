-- Variabili e riferimenti
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variabile per il giocatore selezionato
local SelectedPlayer = nil

-- Crea la GUI base
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "SiliconMafiaGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.ClipsDescendants = true
Frame.Visible = true

-- Titolo
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Silicon Mafia GUI"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Position = UDim2.new(0.5, 0, 0, 0)

-- Dropdown lista giocatori
local PlayerDropdown = Instance.new("TextButton", Frame)
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 50)
PlayerDropdown.Text = "Seleziona Giocatore"
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 18

local DropdownOpen = false
local DropdownFrame = Instance.new("Frame", Frame)
DropdownFrame.Size = UDim2.new(1, -20, 0, 150)
DropdownFrame.Position = UDim2.new(0, 10, 0, 80)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropdownFrame.Visible = false
DropdownFrame.ClipsDescendants = true

-- Funzione per aggiornare lista giocatori
local function UpdatePlayerList()
    -- Cancella vecchi bottoni
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local yOffset = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", DropdownFrame)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yOffset)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16

            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
                PlayerDropdown.Text = "Giocatore: " .. plr.Name
                DropdownFrame.Visible = false
                DropdownOpen = false
            end)

            yOffset = yOffset + 30
        end
    end
end

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownOpen = not DropdownOpen
    DropdownFrame.Visible = DropdownOpen
    if DropdownOpen then
        UpdatePlayerList()
    end
end)

-- Bottone Teletrasporto a Te
local TpToMeBtn = Instance.new("TextButton", Frame)
TpToMeBtn.Size = UDim2.new(1, -20, 0, 30)
TpToMeBtn.Position = UDim2.new(0, 10, 0, 240)
TpToMeBtn.Text = "Teletrasporta a me"
TpToMeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TpToMeBtn.TextColor3 = Color3.new(1, 1, 1)
TpToMeBtn.Font = Enum.Font.GothamBold
TpToMeBtn.TextSize = 18

TpToMeBtn.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SelectedPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    else
        warn("Seleziona un giocatore con personaggio in gioco.")
    end
end)

-- Bottone Teletrasporto da Te
local TpFromMeBtn = Instance.new("TextButton", Frame)
TpFromMeBtn.Size = UDim2.new(1, -20, 0, 30)
TpFromMeBtn.Position = UDim2.new(0, 10, 0, 280)
TpFromMeBtn.Text = "Teletrasporta me a giocatore"
TpFromMeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TpFromMeBtn.TextColor3 = Color3.new(1, 1, 1)
TpFromMeBtn.Font = Enum.Font.GothamBold
TpFromMeBtn.TextSize = 18

TpFromMeBtn.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    else
        warn("Seleziona un giocatore con personaggio in gioco.")
    end
end)

-- Toggle Fly
local Flying = false
local FlySpeed = 50
local FlyBodyVelocity = nil

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1, -20, 0, 30)
FlyBtn.Position = UDim2.new(0, 10, 0, 320)
FlyBtn.Text = "Fly OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.TextSize = 18

local function StopFly()
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    Flying = false
    FlyBtn.Text = "Fly OFF"
end

local function StartFly()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
        FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        Flying = true
        FlyBtn.Text = "Fly ON"

        -- Update velocity in RunService
        RunService:BindToRenderStep("FlyMovement", 301, function()
            if Flying and FlyBodyVelocity and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local direction = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end

                FlyBodyVelocity.Velocity = direction.Unit * FlySpeed
            else
                FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
            end
        end)
    end
end

FlyBtn.MouseButton1Click:Connect(function()
    if Flying then
        RunService:UnbindFromRenderStep("FlyMovement")
        StopFly()
    else
        StartFly()
    end
end)

-- Funzioni Troll

-- Loop Sit
local LoopSitActive = false
local LoopSitConnection = nil

local LoopSitBtn = Instance.new("TextButton", Frame)
LoopSitBtn.Size = UDim2.new(1, -20, 0, 30)
LoopSitBtn.Position = UDim2.new(0, 10, 0, 360)
LoopSitBtn.Text = "Toggle Loop Sit"
LoopSitBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LoopSitBtn.TextColor3 = Color3.new(1, 1, 1)
LoopSitBtn.Font = Enum.Font.GothamBold
LoopSitBtn.TextSize = 18

LoopSitBtn.MouseButton1Click:Connect(function()
    if LoopSitActive then
        if LoopSitConnection then
            LoopSitConnection:Disconnect()
            LoopSitConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Sit = false
        end
        LoopSitActive = false
        LoopSitBtn.Text = "Toggle Loop Sit"
    else
        LoopSitActive = true
        LoopSitBtn.Text = "Loop Sit ON"
        LoopSitConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Sit = true
            end
        end)
    end
end)

-- Reset Character
local ResetBtn = Instance.new("TextButton", Frame)
ResetBtn.Size = UDim2.new(1, -20, 0, 30)
ResetBtn.Position = UDim2.new(0, 10, 0, 400)
ResetBtn.Text = "Reset Character"
ResetBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ResetBtn.TextColor3 = Color3.new(1, 1, 1)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 18

ResetBtn.MouseButton1Click:Connect(function()
    LocalPlayer.Character:BreakJoints()
end)

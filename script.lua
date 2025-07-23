local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Frame is your main GUI container (make sure it exists)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = game.CoreGui -- or StarterGui for testing

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Dropdown to select player
local selectedPlayer = nil

local function createPlayerButton(p)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 18
    btn.Text = p.Name
    btn.Parent = Frame

    btn.MouseButton1Click:Connect(function()
        selectedPlayer = p
        print("Selected player: "..p.Name)
        -- Optional: visually highlight the selected button
        for _, child in ipairs(Frame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 170)
    end)
end

-- Create player buttons
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createPlayerButton(p)
    end
end

-- Update player list when someone joins/leaves
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        createPlayerButton(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    for _, child in ipairs(Frame:GetChildren()) do
        if child:IsA("TextButton") and child.Text == p.Name then
            child:Destroy()
            if selectedPlayer == p then
                selectedPlayer = nil
            end
        end
    end
end)

-- Teleport button
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -20, 0, 50)
tpBtn.Position = UDim2.new(0, 10, 1, -60)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
tpBtn.Font = Enum.Font.RobotoMono
tpBtn.TextSize = 22
tpBtn.Text = "Teleport Selected Player"
tpBtn.Parent = Frame

tpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        local char = selectedPlayer.Character
        local myChar = LocalPlayer.Character
        if char and myChar and char:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
            print("Teleported "..selectedPlayer.Name.." to you.")
        else
            print("Missing character or HumanoidRootPart.")
        end
    else
        print("No player selected!")
    end
end)

--[[
  script.lua - Silicon Mafia Admin Tool
  Funzioni:
    • Main GUI: selezione giocatore + Teleport
    • Fly GUI: toggle volo
    • ESP GUI: toggle ESP
    • Troll GUI: sit loop, spin, freeze, reset
--]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- STILE
local PRIMARY = Color3.fromRGB(0,170,255)
local ACCENT = Color3.fromRGB(15,15,15)
local BACK = Color3.fromRGB(20,20,20)
local FONT = Enum.Font.RobotoMono

-- FUNZIONI UTILITARIE GUI
local function makeGui(name)
  local gui = Instance.new("ScreenGui")
  gui.Name = name
  gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
  return gui
end

local function makeFrame(parent, y)
  local f = Instance.new("Frame", parent)
  f.Size = UDim2.new(0,260,0,50)
  f.Position = UDim2.new(0,10,0,y)
  f.BackgroundColor3 = BACK
  f.BorderSizePixel = 0
  Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
  return f
end

local function makeButton(parent, text, callback)
  local btn = Instance.new("TextButton", parent)
  btn.Size = UDim2.new(1,-10,1,-10)
  btn.Position = UDim2.new(0,5,0,5)
  btn.BackgroundColor3 = ACCENT
  btn.TextColor3 = PRIMARY
  btn.Font = FONT
  btn.TextSize = 18
  btn.Text = text
  btn.AutoButtonColor = false
  Instance.new("UICorner", btn).CornerRadius=UDim.new(0,8)

  -- Animazione click
  btn.MouseButton1Click:Connect(function()
    local og = btn.Size
    local tween1 = TweenService:Create(btn, TweenInfo.new(0.1), {Size = og + UDim2.new(0,0,0,5)})
    local tween2 = TweenService:Create(btn, TweenInfo.new(0.1), {Size = og})
    tween1:Play(); tween1.Completed:Wait(); tween2:Play()
    callback()
  end)
  return btn
end

-- MAIN GUI: selezione + teleport
local mainGui = makeGui("MafiaMain")
local selected = nil

do
  local f = makeFrame(mainGui, 10)
  f.Size = UDim2.new(0,260,0,200)
  -- player buttons container
  local layout = Instance.new("UIListLayout", f)
  layout.Padding = UDim.new(0,4)
  layout.SortOrder = Enum.SortOrder.LayoutOrder

  local function addPlayer(p)
    if p == LocalPlayer then return end
    local btn = makeButton(f, p.Name, function()
      selected = p
      print("🔵 Sel: "..p.Name)
      for _,c in pairs(f:GetChildren()) do
        if c:IsA("TextButton") then c.BackgroundColor3 = ACCENT end
      end
      btn.BackgroundColor3 = PRIMARY
    end)
  end

  for _,p in pairs(Players:GetPlayers()) do addPlayer(p) end
  Players.PlayerAdded:Connect(addPlayer)

  makeButton(mainGui, "Teleport Selezionato → Te", function()
    if selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart")
      and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selected.Character.HumanoidRootPart.CFrame = 
          LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
    end
  end).Parent.Position = UDim2.new(0,10,0,220)
end

-- FLY GUI
local flyGui = makeGui("MafiaFly")
do
  local f = makeFrame(flyGui, 10)
  local flying, bv = false, nil

  makeButton(f, "Toggle Fly", function()
    flying = not flying
    if flying then
      local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,0,0)
        RunService.Heartbeat:Connect(function()
          if flying and bv and hrp then
            bv.Velocity = hrp.CFrame.LookVector * 50
          end
        end)
      end
    else
      if bv then bv:Destroy(); bv=nil end
    end
  end)
end

-- ESP GUI
local espGui = makeGui("MafiaESP")
do
  local enabled = false
  local boxes = {}

  local function toggleESP()
    enabled = not enabled
    if enabled then
      for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
          local h = p.Character:FindFirstChild("HumanoidRootPart")
          if h then
            local b = Instance.new("BoxHandleAdornment", h)
            b.Adornee = h
            b.AlwaysOnTop = true
            b.ZIndex = 10
            b.Size = Vector3.new(2,3,1)
            b.Color3 = PRIMARY
            b.Transparency = 0.5
            boxes[p] = b
          end
        end
      end
      Players.PlayerAdded:Connect(toggleESP)
    else
      for _,b in pairs(boxes) do b:Destroy() end
      boxes = {}
    end
  end

  makeButton(makeFrame(espGui,10), "Toggle ESP", toggleESP)
end

-- TROLL GUI (server-side se privilegi)
local trollGui = makeGui("MafiaTroll")
do
  local function doAction(action)
    if not selected or not selected.Character then return end
    local hrp = selected.Character:FindFirstChild("HumanoidRootPart")
    local hum = selected.Character:FindFirstChildOfClass("Humanoid")
    if action=="sitLoop" then
      spawn(function() for i=1,20 do hum.Sit=true; wait(0.2) end end)
    elseif action=="spin" then
      local bav = Instance.new("BodyAngularVelocity", hrp)
      bav.AngularVelocity = Vector3.new(0,10,0)
      bav.MaxTorque = Vector3.new(0,1e5,0)
      game.Debris:AddItem(bav,2)
    elseif action=="freeze" then
      hum.PlatformStand = true
      wait(2)
      hum.PlatformStand = false
    elseif action=="reset" then
      hum.Health = 0
    end
  end

  local baseY = 10
  for i,act in ipairs({"sitLoop","spin","freeze","reset"}) do
    makeButton(makeFrame(trollGui, baseY), act, function() doAction(act) end)
    baseY += 60
  end
end

print("✨ Silicon Mafia script initialized!")

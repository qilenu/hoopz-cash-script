-- Hoopz Cash Generator - Working Script
-- Place this in StarterPlayer > StarterPlayerScripts as a LocalScript

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for leaderstats and cash value
local leaderstats = player:WaitForChild("leaderstats")
local cashValue = leaderstats:WaitForChild("Cash")

-- Try to find RemoteEvents that handle cash rewards
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = nil

-- Look for common remote names
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        if obj.Name:lower():find("cash") or obj.Name:lower():find("reward") or obj.Name:lower():find("finish") or obj.Name:lower():find("complete") then
            remote = obj
            print("Found remote: " .. obj.Name)
            break
        end
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopzCashGen"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 200, 255)
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.BorderSizePixel = 0
title.Text = "Hoopz Cash Exploit"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Interval Label
local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(1, -20, 0, 20)
intervalLabel.Position = UDim2.new(0, 10, 0, 45)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "Interval (ms): 1000"
intervalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 13
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = mainFrame

-- Interval Input
local intervalInput = Instance.new("TextBox")
intervalInput.Size = UDim2.new(0, 80, 0, 25)
intervalInput.Position = UDim2.new(1, -95, 0, 42)
intervalInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
intervalInput.BorderColor3 = Color3.fromRGB(100, 200, 255)
intervalInput.Text = "1000"
intervalInput.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalInput.Font = Enum.Font.Gotham
intervalInput.TextSize = 13
intervalInput.Parent = mainFrame

-- Multiplier Label
local multiplierLabel = Instance.new("TextLabel")
multiplierLabel.Size = UDim2.new(1, -20, 0, 20)
multiplierLabel.Position = UDim2.new(0, 10, 0, 75)
multiplierLabel.BackgroundTransparency = 1
multiplierLabel.Text = "Reward Multiplier: 1x"
multiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
multiplierLabel.Font = Enum.Font.Gotham
multiplierLabel.TextSize = 13
multiplierLabel.TextXAlignment = Enum.TextXAlignment.Left
multiplierLabel.Parent = mainFrame

-- Multiplier Input
local multiplierInput = Instance.new("TextBox")
multiplierInput.Size = UDim2.new(0, 80, 0, 25)
multiplierInput.Position = UDim2.new(1, -95, 0, 72)
multiplierInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
multiplierInput.BorderColor3 = Color3.fromRGB(100, 200, 255)
multiplierInput.Text = "1"
multiplierInput.TextColor3 = Color3.fromRGB(255, 255, 255)
multiplierInput.Font = Enum.Font.Gotham
multiplierInput.TextSize = 13
multiplierInput.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 105)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Stopped"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Current Cash Label
local cashLabel = Instance.new("TextLabel")
cashLabel.Size = UDim2.new(1, -20, 0, 20)
cashLabel.Position = UDim2.new(0, 10, 0, 130)
cashLabel.BackgroundTransparency = 1
cashLabel.Text = "Cash: 0"
cashLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
cashLabel.Font = Enum.Font.GothamBold
cashLabel.TextSize = 12
cashLabel.TextXAlignment = Enum.TextXAlignment.Left
cashLabel.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 130, 0, 35)
toggleButton.Position = UDim2.new(0.5, -65, 0, 160)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
toggleButton.BorderColor3 = Color3.fromRGB(100, 200, 100)
toggleButton.BorderSizePixel = 2
toggleButton.Text = "START"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

-- Script Variables
local isRunning = false
local lastGenerationTime = 0
local interval = 1000 -- milliseconds
local multiplier = 1

-- Update cash display
local function updateCashDisplay()
    cashLabel.Text = "Cash: " .. tostring(cashValue.Value)
end

cashValue.Changed:Connect(function()
    updateCashDisplay()
end)

updateCashDisplay()

-- Generate cash function
local function generateCash()
    -- Base cash reward: 100-150 (like finishing a game)
    local baseCash = math.random(100, 150)
    
    -- Check if player has double cash gamepass
    -- We'll apply multiplier based on what user sets
    local totalCash = baseCash * multiplier
    
    -- Directly add cash to the value
    cashValue.Value = cashValue.Value + totalCash
    
    print("Generated " .. totalCash .. " cash! Total: " .. cashValue.Value)
end

-- Update interval
intervalInput.FocusLost:Connect(function()
    local newInterval = tonumber(intervalInput.Text)
    if newInterval and newInterval > 0 then
        interval = newInterval
        intervalLabel.Text = "Interval (ms): " .. interval
    else
        intervalInput.Text = tostring(interval)
    end
end)

-- Update multiplier
multiplierInput.FocusLost:Connect(function()
    local newMultiplier = tonumber(multiplierInput.Text)
    if newMultiplier and newMultiplier > 0 then
        multiplier = newMultiplier
        multiplierLabel.Text = "Reward Multiplier: " .. multiplier .. "x"
    else
        multiplierInput.Text = tostring(multiplier)
    end
end)

-- Toggle button logic
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        toggleButton.Text = "STOP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        toggleButton.BorderColor3 = Color3.fromRGB(200, 100, 100)
        statusLabel.Text = "Status: Running"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
        lastGenerationTime = tick()
    else
        toggleButton.Text = "START"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
        toggleButton.BorderColor3 = Color3.fromRGB(100, 200, 100)
        statusLabel.Text = "Status: Stopped"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Main loop - generates cash at set intervals
game:GetService("RunService").Heartbeat:Connect(function()
    if isRunning then
        local currentTime = tick()
        -- Convert milliseconds to seconds
        local intervalSeconds = interval / 1000
        
        if (currentTime - lastGenerationTime) >= intervalSeconds then
            generateCash()
            lastGenerationTime = currentTime
        end
    end
end)

print("✓ Hoopz Cash Generator Loaded!")
print("✓ Click START button in the GUI to begin generating cash")
print("✓ Adjust interval (ms) and multiplier as needed")

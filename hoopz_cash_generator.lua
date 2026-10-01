-- Hoopz Cash Generator Script
-- Place this in StarterPlayer > StarterPlayerScripts as a LocalScript
-- This script generates cash by simulating game completion rewards (100-150 cash based on stats)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()

-- Find leaderstats or create reference to cash value
local leaderstats = player:WaitForChild("leaderstats")
local cashValue = leaderstats:WaitForChild("Cash")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopzCashGen"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 200, 255)
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.BorderSizePixel = 0
title.Text = "Hoopz Cash Generator"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Interval Label
local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(1, -20, 0, 25)
intervalLabel.Position = UDim2.new(0, 10, 0, 45)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "Interval (seconds): 5"
intervalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 14
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = mainFrame

-- Interval Input
local intervalInput = Instance.new("TextBox")
intervalInput.Size = UDim2.new(0, 80, 0, 25)
intervalInput.Position = UDim2.new(1, -95, 0, 45)
intervalInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
intervalInput.BorderColor3 = Color3.fromRGB(100, 200, 255)
intervalInput.Text = "5"
intervalInput.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalInput.Font = Enum.Font.Gotham
intervalInput.TextSize = 14
intervalInput.Parent = mainFrame

-- Multiplier Label
local multiplierLabel = Instance.new("TextLabel")
multiplierLabel.Size = UDim2.new(1, -20, 0, 25)
multiplierLabel.Position = UDim2.new(0, 10, 0, 75)
multiplierLabel.BackgroundTransparency = 1
multiplierLabel.Text = "Multiplier: 1x"
multiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
multiplierLabel.Font = Enum.Font.Gotham
multiplierLabel.TextSize = 14
multiplierLabel.TextXAlignment = Enum.TextXAlignment.Left
multiplierLabel.Parent = mainFrame

-- Multiplier Slider
local multiplierInput = Instance.new("TextBox")
multiplierInput.Size = UDim2.new(0, 80, 0, 25)
multiplierInput.Position = UDim2.new(1, -95, 0, 75)
multiplierInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
multiplierInput.BorderColor3 = Color3.fromRGB(100, 200, 255)
multiplierInput.Text = "1"
multiplierInput.TextColor3 = Color3.fromRGB(255, 255, 255)
multiplierInput.Font = Enum.Font.Gotham
multiplierInput.TextSize = 14
multiplierInput.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 105)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Stopped"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0.5, -60, 0, 155)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
toggleButton.BorderColor3 = Color3.fromRGB(100, 200, 100)
toggleButton.BorderSizePixel = 2
toggleButton.Text = "START"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = mainFrame

-- Script Variables
local isRunning = false
local generatorConnection = nil
local interval = 5
local multiplier = 1

-- Function to generate cash (simulates game completion)
local function generateCash()
    -- Base cash: 100-150 (from game completion)
    local baseCash = math.random(100, 150)
    
    -- Apply multiplier
    local totalCash = baseCash * multiplier
    
    -- Add to player's cash
    cashValue.Value += totalCash
    
    print("Generated " .. totalCash .. " cash! Total: " .. cashValue.Value)
end

-- Update interval label
intervalInput.FocusLost:Connect(function()
    local newInterval = tonumber(intervalInput.Text)
    if newInterval and newInterval > 0 then
        interval = newInterval
        intervalLabel.Text = "Interval (seconds): " .. interval
    else
        intervalInput.Text = tostring(interval)
    end
end)

-- Update multiplier label
multiplierInput.FocusLost:Connect(function()
    local newMultiplier = tonumber(multiplierInput.Text)
    if newMultiplier and newMultiplier > 0 then
        multiplier = newMultiplier
        multiplierLabel.Text = "Multiplier: " .. multiplier .. "x"
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
        statusLabel.Text = "Status: Running (Every " .. interval .. "s)"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
        
        generatorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local currentTime = tick()
            local nextGenerationTime = 0
            
            -- Generate cash at set intervals
            while true do
                if tick() - currentTime >= interval then
                    if isRunning then
                        generateCash()
                        currentTime = tick()
                    end
                end
                break
            end
        end)
    else
        toggleButton.Text = "START"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
        toggleButton.BorderColor3 = Color3.fromRGB(100, 200, 100)
        statusLabel.Text = "Status: Stopped"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if generatorConnection then
            generatorConnection:Disconnect()
            generatorConnection = nil
        end
    end
end)

-- Better interval-based generator
local lastGenerationTime = 0

game:GetService("RunService").Heartbeat:Connect(function()
    if isRunning then
        local currentTime = tick()
        if currentTime - lastGenerationTime >= interval then
            generateCash()
            lastGenerationTime = currentTime
        end
    end
end)

-- Cleanup on player leave
player.Humanoid.Died:Connect(function()
    if generatorConnection then
        generatorConnection:Disconnect()
    end
end)

print("Hoopz Cash Generator loaded! Open the GUI to start generating cash.")

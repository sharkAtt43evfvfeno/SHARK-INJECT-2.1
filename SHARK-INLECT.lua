local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local savedScripts = {}

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
mainFrame.BackgroundTransparency = 0.1
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "SHARK LOADER v2.2"
title.Size = UDim2.new(1, 0, 0, 40)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.BackgroundTransparency = 1
title.Parent = mainFrame

local input = Instance.new("TextBox")
input.PlaceholderText = "Enter script URL..."
input.Size = UDim2.new(0.9, 0, 0, 40)
input.Position = UDim2.new(0.05, 0, 0.2, 0)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
input.Parent = mainFrame

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(0.9, 0, 0, 40)
buttonsFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local function createButton(text, color, xPos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = buttonsFrame
    return btn
end

local executeBtn = createButton("EXECUTE", Color3.fromRGB(0, 120, 215), 0)
local saveBtn = createButton("SAVE", Color3.fromRGB(80, 160, 80), 0.33)
local showSavedBtn = createButton("SAVED", Color3.fromRGB(150, 100, 200), 0.66)

local status = Instance.new("TextLabel")
status.Text = "Status: Ready"
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.9, 0)
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.Font = Enum.Font.Gotham
status.BackgroundTransparency = 1
status.Parent = mainFrame

local savedScriptsFrame = Instance.new("Frame")
savedScriptsFrame.Size = UDim2.new(0.9, 0, 0, 200)
savedScriptsFrame.Position = UDim2.new(0.05, 0, 1.1, 0)
savedScriptsFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
savedScriptsFrame.Visible = false
Instance.new("UICorner", savedScriptsFrame).CornerRadius = UDim.new(0, 8)
savedScriptsFrame.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = savedScriptsFrame

local function showSavedScripts()
    scrollFrame:ClearAllChildren()
    for i, script in pairs(savedScripts) do
        local scriptFrame = Instance.new("Frame")
        scriptFrame.Size = UDim2.new(1, 0, 0, 40)
        scriptFrame.Position = UDim2.new(0, 0, 0, (i-1)*45)
        scriptFrame.BackgroundTransparency = 1
        scriptFrame.Parent = scrollFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = script.name
        nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Parent = scriptFrame
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Text = "LOAD"
        loadBtn.Size = UDim2.new(0.35, 0, 0.8, 0)
        loadBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        loadBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)
        loadBtn.Parent = scriptFrame
        
        loadBtn.MouseButton1Click:Connect(function()
            input.Text = script.url
            savedScriptsFrame.Visible = false
        end)
    end
    savedScriptsFrame.Visible = not savedScriptsFrame.Visible
end

local function saveScript()
    local url = input.Text
    if url == "" then
        status.Text = "Status: Nothing to save!"
        return
    end
    table.insert(savedScripts, {name = "Script #"..#savedScripts+1, url = url})
    status.Text = "Status: Script saved!"
end

local function executeScript()
    local url = input.Text
    if url == "" then
        status.Text = "Status: Empty URL!"
        return
    end
    status.Text = "Status: Loading..."
    local success, err = pcall(function() loadstring(game:HttpGet(url))() end)
    status.Text = success and "Status: Executed!" or "Status: Error - "..tostring(err)
end

executeBtn.MouseButton1Click:Connect(executeScript)
saveBtn.MouseButton1Click:Connect(saveScript)
showSavedBtn.MouseButton1Click:Connect(showSavedScripts)

local dragging = false
local dragStartPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        mainFrame.Position += UDim2.new(0, delta.X, 0, delta.Y)
        dragStartPos = input.Position
    end
end)

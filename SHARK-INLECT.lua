local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local storageName = "SharkLoaderData"
local savedScripts = {}
local success, data = pcall(function()
    return HttpService:JSONDecode(player:GetAttribute(storageName) or "[]")
end)
if success then savedScripts = data end

local frameSize = isMobile and UDim2.new(0, 280, 0, 200) or UDim2.new(0, 400, 0, 250)
local mainFrame = Instance.new("Frame")
mainFrame.Size = frameSize
mainFrame.Position = UDim2.new(0.5, -frameSize.X.Offset/2, 0.5, -frameSize.Y.Offset/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
mainFrame.Parent = gui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "☰"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
toggleBtn.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "SHARK LOADER"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.Gotham
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local input = Instance.new("TextBox")
input.PlaceholderText = "URL..."
input.Size = UDim2.new(0.9, 0, 0, 35)
input.Position = UDim2.new(0.05, 0, 0.2, 0)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
input.Parent = mainFrame

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(0.9, 0, 0, 35)
buttonsFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local function createBtn(text, color, xPos)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Position = UDim2.new(xPos, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = buttonsFrame
    return btn
end

local executeBtn = createBtn("RUN", Color3.fromRGB(0, 120, 215), 0)
local saveBtn = createBtn("SAVE", Color3.fromRGB(80, 160, 80), 0.33)
local listBtn = createBtn("LIST", Color3.fromRGB(150, 100, 200), 0.66)

local status = Instance.new("TextLabel")
status.Text = "Ready"
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.85, 0)
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.Font = Enum.Font.Gotham
status.BackgroundTransparency = 1
status.Parent = mainFrame

local scriptsFrame = Instance.new("Frame")
scriptsFrame.Size = UDim2.new(0.9, 0, 0, 150)
scriptsFrame.Position = UDim2.new(0.05, 0, 1.1, 0)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
scriptsFrame.Visible = false
Instance.new("UICorner", scriptsFrame).CornerRadius = UDim.new(0, 8)
scriptsFrame.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = scriptsFrame

local function saveData()
    player:SetAttribute(storageName, HttpService:JSONEncode(savedScripts))
end

local function showScripts()
    scrollFrame:ClearAllChildren()
    for i, script in pairs(savedScripts) do
        local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, (i-1)*45)
        frame.BackgroundTransparency = 1
        frame.Parent = scrollFrame
        
        local name = Instance.new("TextLabel")
        name.Text = script.name
        name.Size = UDim2.new(0.6, 0, 1, 0)
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Font = Enum.Font.Gotham
        name.TextColor3 = Color3.new(1, 1, 1)
        name.Parent = frame
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Text = "LOAD"
        loadBtn.Size = UDim2.new(0.35, 0, 0.8, 0)
        loadBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        loadBtn.Font = Enum.Font.Gotham
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)
        loadBtn.Parent = frame
        
        loadBtn.MouseButton1Click:Connect(function()
            input.Text = script.url
            scriptsFrame.Visible = false
        end)
    end
    scriptsFrame.Visible = not scriptsFrame.Visible
end

saveBtn.MouseButton1Click:Connect(function()
    local url = input.Text
    if url == "" then
        status.Text = "Empty URL!"
        return
    end
    table.insert(savedScripts, {
        name = "Script#"..#savedScripts+1,
        url = url,
        time = os.time()
    })
    saveData()
    status.Text = "Saved!"
end)

executeBtn.MouseButton1Click:Connect(function()
    local url = input.Text
    if url == "" then
        status.Text = "Empty URL!"
        return
    end
    status.Text = "Loading..."
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    status.Text = success and "Executed!" or "Error: "..tostring(err):sub(1,20)
end)

listBtn.MouseButton1Click:Connect(showScripts)

local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
    toggleBtn.Text = mainFrame.Visible and "✕" or "☰"
end

if isMobile then
    local dragStart, frameStart, dragging
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = mainFrame.Position
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
    mainFrame.InputEnded:Connect(function()
        dragging = false
    end)
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)

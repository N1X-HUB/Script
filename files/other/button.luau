local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local uis = game:GetService("UserInputService")

local sg = Instance.new("ScreenGui")
sg.Name = "EndBtnGui"
sg.ResetOnSpawn = false
sg.Parent = pg

local btn = Instance.new("ImageButton")
btn.Name = "EndBtn"
btn.Parent = sg
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.Position = UDim2.new(0.5, 0, 0.5, 0)
btn.Size = UDim2.fromOffset(80, 80)
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.AutoButtonColor = true
btn.Image = ""
btn.ImageTransparency = 1
btn.BorderSizePixel = 0

local crn = Instance.new("UICorner", btn)
crn.CornerRadius = UDim.new(1, 0)

local lbl = Instance.new("TextLabel", btn)
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "Script"
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 20
lbl.TextColor3 = Color3.new(1,1,1)

local drag = false
local dragInp, dragStart, startPos

local function upd(inp)
    local d = inp.Position - dragStart
    btn.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + d.X,
        startPos.Y.Scale,
        startPos.Y.Offset + d.Y
    )
end

btn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 
    or inp.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragStart = inp.Position
        startPos = btn.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                drag = false
            end
        end)
    end
end)

btn.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement 
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragInp = inp
    end
end)

uis.InputChanged:Connect(function(inp)
    if inp == dragInp and drag then
        upd(inp)
    end
end)

local function sendEnd()
    local ok, er = pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.End, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.End, false, game)
    end)
    return ok, er
end

btn.Activated:Connect(function()
    local ok, msg = sendEnd()
    if ok then
        btn.BackgroundColor3 = Color3.fromRGB(50,180,80)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    else
        warn("[Butao do end] - ", msg)
        btn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end
end)

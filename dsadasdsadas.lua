--// Eps1llonUI - 2025 Modern | Pro UI (Updated with Rayfield-inspired elements)
local Eps1llonUI = {}
Eps1llonUI._VERSION = "2025.07.19-ProUX-Rayfield"

local player           = game.Players.LocalPlayer
local TweenService     = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local CoreGui          = game:GetService("CoreGui")

local IS_MOBILE = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
local function isTouch(input) return input.UserInputType == Enum.UserInputType.Touch end

local GUI_NAME = 'Eps1llonHub'
pcall(function() if CoreGui:FindFirstChild(GUI_NAME) then CoreGui[GUI_NAME]:Destroy() end end)
local gui = Instance.new('ScreenGui')
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
gui.Parent = CoreGui
gui.AncestryChanged:Connect(function(_, parent) if not parent then task.wait(0.1) if not gui.Parent then gui.Parent = CoreGui end end end)
player.CharacterAdded:Connect(function() task.wait(0.2) if not gui.Parent then gui.Parent = CoreGui end end)

-- Modern Main Frame
local mainFrame = Instance.new('Frame', gui)
mainFrame.Size = UDim2.new(0, 650, 0, 360)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.14
mainFrame.Active = true
mainFrame.Draggable = false
Instance.new('UICorner', mainFrame).CornerRadius = UDim.new(0, 8)
local UIScale = Instance.new("UIScale", mainFrame)
UIScale.Scale = 1

local headerFrame = Instance.new('Frame', mainFrame)
headerFrame.Size = UDim2.new(1, 0, 0, 30)
headerFrame.BackgroundTransparency = 1
headerFrame.Active = true
do
    local dragging, dragStart, startPos = false, nil, nil
    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or isTouch(input) then
            dragging, dragStart, startPos = true, input.Position, mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or isTouch(input)) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or isTouch(input) then dragging = false end
    end)
end

local title = Instance.new('TextLabel', headerFrame)
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = 'Eps1llon Hub'
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local underline = Instance.new('Frame', mainFrame)
underline.Size = UDim2.new(1, 0, 0, 4)
underline.Position = UDim2.new(0, 0, 0, 30)
underline.BackgroundColor3 = Color3.fromRGB(31, 81, 178)
underline.BorderSizePixel = 0

local minimize = Instance.new('TextButton', headerFrame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -50, 0, 2)
minimize.Text = '-'
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.BackgroundTransparency = 1

local close = Instance.new('TextButton', headerFrame)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 2)
close.Text = 'X'
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Sidebar
local sidebar = Instance.new('Frame', mainFrame)
sidebar.Size = UDim2.new(0, 140, 0, 280)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(30,30,35)
sidebar.BackgroundTransparency = 0.12
sidebar.BorderSizePixel = 0
Instance.new('UICorner', sidebar).CornerRadius = UDim.new(0,6)
local outline = Instance.new('UIStroke', sidebar)
outline.Thickness = 2
outline.Color = Color3.fromRGB(31,81,178)
outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local highlighter = Instance.new('Frame', sidebar)
highlighter.Size = UDim2.new(1, 0, 0, 30)
highlighter.Position = UDim2.new(0, 0, 0, 10)
highlighter.BackgroundColor3 = Color3.fromRGB(31,81,178)
highlighter.BackgroundTransparency = 0.3
highlighter.ZIndex = 2
Instance.new('UICorner', highlighter).CornerRadius = UDim.new(1,999)

local contentFrame = Instance.new('Frame', mainFrame)
contentFrame.Size = UDim2.new(0, 480, 0, 280)
contentFrame.Position = UDim2.new(0, 160, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)
contentFrame.BackgroundTransparency = 0.7
contentFrame.BorderSizePixel = 0
Instance.new('UICorner', contentFrame).CornerRadius = UDim.new(0,6)
local outlineContentFrame = Instance.new('UIStroke', contentFrame)
outlineContentFrame.Thickness = 2
outlineContentFrame.Color = Color3.fromRGB(31,81,178)
outlineContentFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Tab System
local _TABS = {}
local sidebarButtons, tabSections, tabCallbacks = {}, {}, {}
local DEFAULT_COLOR, ACTIVE_COLOR = Color3.fromRGB(210,210,210), Color3.fromRGB(255,255,255)
local DEFAULT_SIZE, ACTIVE_SIZE = 16, 18

local function createSection(name)
    local scroll = Instance.new('ScrollingFrame')
    scroll.Name = name
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 200)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Visible = false
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ClipsDescendants = true
    scroll.Parent = contentFrame

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)

    return scroll
end

local function setButtonActive(idx)
    for i, group in ipairs(sidebarButtons) do
        local btn = group.TextButton
        local isActive = (i == idx)
        TweenService:Create(btn, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            TextSize    = isActive and ACTIVE_SIZE or DEFAULT_SIZE,
            TextColor3  = isActive and ACTIVE_COLOR or DEFAULT_COLOR
        }):Play()
        btn.Font = Enum.Font.GothamBold
        if isActive then
            TweenService:Create(highlighter, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
                Position = group.ButtonFrame.Position,
                Size     = group.ButtonFrame.Size,
                BackgroundTransparency = 0.13
            }):Play()
        end
    end
end

local function createSidebarButton(text, y, idx)
    local frame = Instance.new('Frame', sidebar)
    frame.Size = UDim2.new(1,0,0,30)
    frame.Position = UDim2.new(0,0,0,y)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3

    local btn = Instance.new('TextButton', frame)
    btn.Size = UDim2.new(1,0,1,0)
    btn.Position = UDim2.new(0,0,0,0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = DEFAULT_SIZE
    btn.TextColor3 = DEFAULT_COLOR
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        for _,s in pairs(tabSections) do s.Visible = false end
        tabSections[text].Visible = true
        setButtonActive(idx)
        if tabCallbacks[text] then tabCallbacks[text]() end
    end)
    btn.TouchTap:Connect(btn.MouseButton1Click)

    sidebarButtons[idx] = { ButtonFrame = frame, TextButton = btn }
    return frame
end

function Eps1llonUI:AddTab(name)
    assert(name and type(name) == "string", "Invalid tab name")
    if tabSections[name] then return end

    table.insert(_TABS, name)
    local idx = #_TABS

    tabSections[name] = createSection(name)
    createSidebarButton(name, 10 + (idx - 1) * 35, idx)

    -- Automatically select first tab
    if idx == 1 then
        tabSections[name].Visible = true
        setButtonActive(idx)
    end
end

-- MODERN BUTTON
function Eps1llonUI:AddButton(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 38)
    btn.BackgroundColor3 = opts.BackgroundColor3 or Color3.fromRGB(35,36,40)
    btn.BorderSizePixel = 0
    btn.Text = opts.Name or "Button"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
    btn.TextColor3 = opts.TextColor3 or Color3.fromRGB(220,240,255)
    btn.LayoutOrder = #sec:GetChildren() + 1
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.Parent = sec
    btn.MouseButton1Click:Connect(function() if opts.Callback then opts.Callback() end end)
    btn.TouchTap:Connect(function() if opts.Callback then opts.Callback() end end)
    return btn
end

-- MODERN LABEL
function Eps1llonUI:AddLabel(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, opts.Height or 28)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Text or "Label"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = opts.TextSize or 15
    lbl.TextColor3 = opts.TextColor3 or Color3.fromRGB(220,220,220)
    lbl.TextXAlignment = opts.TextXAlignment or Enum.TextXAlignment.Left
    lbl.TextYAlignment = opts.TextYAlignment or Enum.TextYAlignment.Center
    lbl.LayoutOrder = #sec:GetChildren() + 1
    lbl.Parent = sec
    return lbl
end

-- RAYFIELD-INSPIRED TOGGLE
function Eps1llonUI:AddToggle(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 48)
    cont.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    cont.BackgroundTransparency = 0.3
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 12)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- Rayfield-style border
    local border = Instance.new("UIStroke", cont)
    border.Thickness = 1.5
    border.Color = Color3.fromRGB(50, 50, 55)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Name or "Toggle"
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Rayfield toggle design - larger and more rounded
    local toggleBG = Instance.new("Frame", cont)
    toggleBG.Size = UDim2.new(0, 60, 0, 28)
    toggleBG.Position = UDim2.new(1, -76, 0.5, -14)
    toggleBG.BackgroundColor3 = opts.Default and Eps1llonUI._ACCENT or Color3.fromRGB(40, 40, 45)
    toggleBG.BorderSizePixel = 0
    Instance.new("UICorner", toggleBG).CornerRadius = UDim.new(0, 14)
    toggleBG.ClipsDescendants = false

    -- Rayfield-style shadow effect
    local shadow = Instance.new("Frame", toggleBG)
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = -1
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

    local knob = Instance.new("Frame", toggleBG)
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = opts.Default and UDim2.new(1,-26,0,2) or UDim2.new(0,2,0,2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 12)
    knob.ZIndex = 2

    -- Rayfield knob shadow
    local knobShadow = Instance.new("Frame", knob)
    knobShadow.Size = UDim2.new(1, 2, 1, 2)
    knobShadow.Position = UDim2.new(0, -1, 0, -1)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.7
    knobShadow.ZIndex = -1
    Instance.new("UICorner", knobShadow).CornerRadius = UDim.new(0, 13)

    local value = opts.Default and true or false
    local function setToggle(val)
        value = val
        TweenService:Create(toggleBG, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = val and Eps1llonUI._ACCENT or Color3.fromRGB(40, 40, 45)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = val and UDim2.new(1,-26,0,2) or UDim2.new(0,2,0,2)
        }):Play()
        if opts.Callback then opts.Callback(val) end
    end
    
    cont.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then
            setToggle(not value)
        end
    end)
    
    -- Theme coloring
    Eps1llonUI._OnThemeChange = Eps1llonUI._OnThemeChange or {}
    table.insert(Eps1llonUI._OnThemeChange, function(accent)
        if value then toggleBG.BackgroundColor3 = accent end
    end)
    return cont
end

-- RAYFIELD-INSPIRED SLIDER
function Eps1llonUI:AddSlider(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 55)
    cont.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    cont.BackgroundTransparency = 0.3
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 12)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- Rayfield-style border
    local border = Instance.new("UIStroke", cont)
    border.Thickness = 1.5
    border.Color = Color3.fromRGB(50, 50, 55)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -20, 0, 22)
    lbl.Position = UDim2.new(0, 16, 0, 8)
    lbl.Text = opts.Name or "Slider"
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valText = Instance.new("TextLabel", cont)
    valText.Size = UDim2.new(0, 60, 0, 22)
    valText.Position = UDim2.new(1, -76, 0, 8)
    valText.BackgroundTransparency = 1
    valText.TextColor3 = Eps1llonUI._ACCENT
    valText.Font = Enum.Font.GothamBold
    valText.TextSize = 15
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.TextYAlignment = Enum.TextYAlignment.Center
    valText.Text = tostring(opts.Default or opts.Min)

    -- Rayfield slider track
    local barBG = Instance.new("Frame", cont)
    barBG.Size = UDim2.new(1, -32, 0, 6)
    barBG.Position = UDim2.new(0, 16, 1, -18)
    barBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    barBG.BorderSizePixel = 0
    Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 3)

    -- Rayfield fill bar
    local fill = Instance.new("Frame", barBG)
    fill.Size = UDim2.new(((opts.Default or opts.Min)-opts.Min)/(opts.Max-opts.Min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Eps1llonUI._ACCENT
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    -- Rayfield knob (larger and more prominent)
    local knob = Instance.new("Frame", barBG)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(fill.Size.X.Scale, fill.Size.X.Offset - 8, 0, -5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)
    knob.ZIndex = 2

    -- Rayfield knob shadow
    local knobShadow = Instance.new("Frame", knob)
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.Position = UDim2.new(0, -2, 0, -2)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.6
    knobShadow.ZIndex = -1
    Instance.new("UICorner", knobShadow).CornerRadius = UDim.new(0, 10)

    local function setSliderPos(x)
        local pct = math.clamp(x/barBG.AbsoluteSize.X, 0, 1)
        local v = math.floor((opts.Min or 0) + ((opts.Max or 100)-(opts.Min or 0))*pct + 0.5)
        
        TweenService:Create(fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(pct, 0, 1, 0)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(pct, -8, 0, -5)
        }):Play()
        
        valText.Text = tostring(v)
        if opts.Callback then opts.Callback(v) end
    end

    local dragging = false
    barBG.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then
            dragging = true
            setSliderPos(i.Position.X - barBG.AbsolutePosition.X)
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or isTouch(i)) then
            setSliderPos(i.Position.X - barBG.AbsolutePosition.X)
        end
    end)
    
    -- Theme coloring
    Eps1llonUI._OnThemeChange = Eps1llonUI._OnThemeChange or {}
    table.insert(Eps1llonUI._OnThemeChange, function(accent)
        fill.BackgroundColor3 = accent
        valText.TextColor3 = accent
    end)
    
    return cont, valText
end

-- RAYFIELD-INSPIRED DROPDOWN
function Eps1llonUI:AddDropdown(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 48)
    cont.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    cont.BackgroundTransparency = 0.3
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 12)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- Rayfield-style border
    local border = Instance.new("UIStroke", cont)
    border.Thickness = 1.5
    border.Color = Color3.fromRGB(50, 50, 55)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Name or "Dropdown"
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Rayfield dropdown button
    local dropBtn = Instance.new("TextButton", cont)
    dropBtn.Size = UDim2.new(0.5, -20, 0, 32)
    dropBtn.Position = UDim2.new(0.5, 4, 0.5, -16)
    dropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    dropBtn.BorderSizePixel = 0
    dropBtn.Text = opts.Default or "Select..."
    dropBtn.Font = Enum.Font.GothamMedium
    dropBtn.TextSize = 14
    dropBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)

    -- Dropdown arrow
    local arrow = Instance.new("TextLabel", dropBtn)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.TextColor3 = Eps1llonUI._ACCENT
    arrow.TextXAlignment = Enum.TextXAlignment.Center

    -- Padding for dropdown text
    local textPadding = Instance.new("UIPadding", dropBtn)
    textPadding.PaddingLeft = UDim.new(0, 12)
    textPadding.PaddingRight = UDim.new(0, 25)

    -- Rayfield dropdown list
    local dropList = Instance.new("Frame", cont)
    dropList.Size = UDim2.new(0.5, -20, 0, math.min(#opts.Options * 32, 160))
    dropList.Position = UDim2.new(0.5, 4, 1, 4)
    dropList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    dropList.BorderSizePixel = 0
    dropList.Visible = false
    dropList.ZIndex = 10
    Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)

    -- Dropdown border
    local dropBorder = Instance.new("UIStroke", dropList)
    dropBorder.Thickness = 1.5
    dropBorder.Color = Color3.fromRGB(50, 50, 55)
    dropBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Dropdown shadow
    local dropShadow = Instance.new("Frame", dropList)
    dropShadow.Size = UDim2.new(1, 6, 1, 6)
    dropShadow.Position = UDim2.new(0, -3, 0, -3)
    dropShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dropShadow.BackgroundTransparency = 0.7
    dropShadow.ZIndex = -1
    Instance.new("UICorner", dropShadow).CornerRadius = UDim.new(0, 10)

    local scrollFrame = Instance.new("ScrollingFrame", dropList)
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #opts.Options * 32)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Eps1llonUI._ACCENT
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ZIndex = 11

    local listLayout = Instance.new("UIListLayout", scrollFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local currentValue = opts.Default
    
    for i, option in ipairs(opts.Options) do
        local optBtn = Instance.new("TextButton", scrollFrame)
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        optBtn.BorderSizePixel = 0
        optBtn.Text = option
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.TextSize = 14
        optBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 12
        optBtn.LayoutOrder = i

        local optPadding = Instance.new("UIPadding", optBtn)
        optPadding.PaddingLeft = UDim.new(0, 12)

        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            }):Play()
        end)
        
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            }):Play()
        end)

        optBtn.MouseButton1Click:Connect(function()
            currentValue = option
            dropBtn.Text = option
            dropList.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
            if opts.Callback then opts.Callback(option) end
        end)
    end

    dropBtn.MouseButton1Click:Connect(function()
        dropList.Visible = not dropList.Visible
        TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Rotation = dropList.Visible and 180 or 0
        }):Play()
    end)

    -- Theme coloring
    Eps1llonUI._OnThemeChange = Eps1llonUI._OnThemeChange or {}
    table.insert(Eps1llonUI._OnThemeChange, function(accent)
        arrow.TextColor3 = accent
        scrollFrame.ScrollBarImageColor3 = accent
    end)

    return cont, function() return currentValue end
end

function Eps1llonUI:SetTabCallback(tab, callback)
    assert(tabSections[tab], "Tab "..tostring(tab).." does not exist.")
    tabCallbacks[tab] = callback
end

-- MINIMIZE / RESTORE
local minimizedButton = Instance.new('ImageButton', gui)
minimizedButton.Name = "Eps1llonMini"
minimizedButton.Size = UDim2.new(0,55,0,55)
minimizedButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimizedButton.BackgroundTransparency= 0.08
minimizedButton.AutoButtonColor = true
minimizedButton.Visible = false
Instance.new('UICorner', minimizedButton).CornerRadius = UDim.new(1,999)
local esText = Instance.new('TextLabel', minimizedButton)
esText.Size = UDim2.new(1,0,1,0)
esText.BackgroundTransparency = 1
esText.Text = "ES"
esText.Font = Enum.Font.GothamBlack
esText.TextScaled = true
esText.TextColor3 = Color3.fromRGB(255,255,255)
esText.TextStrokeTransparency = 0.25
esText.ZIndex = 2
esText.TextXAlignment = Enum.TextXAlignment.Center
esText.TextYAlignment = Enum.TextYAlignment.Center
esText.TextSize = 12

local function animateObj(obj, sFrom, sTo, tFrom, tTo, d, cb)
    local sc = obj:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", obj)
    sc.Scale = sFrom
    obj.BackgroundTransparency = tFrom
    obj.Visible = true
    local tw1 = TweenService:Create(sc, TweenInfo.new(d, Enum.EasingStyle.Quad), {Scale=sTo})
    local tw2 = TweenService:Create(obj, TweenInfo.new(d, Enum.EasingStyle.Quad), {BackgroundTransparency=tTo})
    tw1:Play(); tw2:Play()
    tw1.Completed:Connect(function() if cb then cb() end end)
end

local dragMini, startMini, startPosMini
minimizedButton.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then
        dragMini = true
        startMini = i.Position
        startPosMini = minimizedButton.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then dragMini = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragMini and (i.UserInputType==Enum.UserInputType.MouseMovement or isTouch(i)) then
        local delta = i.Position - startMini
        minimizedButton.Position = UDim2.new(
            startPosMini.X.Scale, startPosMini.X.Offset + delta.X,
            startPosMini.Y.Scale, startPosMini.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then dragMini = false end
end)

local function setMainVisible(v)
    mainFrame.Visible       = v
    minimizedButton.Visible = not v
end
minimize.MouseButton1Click:Connect(function()
    animateObj(mainFrame, 1, 0, 0.14, 1, 0.22, function()
        setMainVisible(false)
        animateObj(minimizedButton, 0, 1, 1, 0.08, 0.22)
    end)
end)
minimizedButton.MouseButton1Click:Connect(function()
    animateObj(minimizedButton, 1, 0, 0.08, 1, 0.18, function()
        setMainVisible(true)
        animateObj(mainFrame, 0, 1, 1, 0.14, 0.23)
    end)
end)
minimizedButton.TouchTap:Connect(minimizedButton.MouseButton1Click)

function Eps1llonUI:SetScale(val)
    UIScale.Scale = val
end
function Eps1llonUI:GetSection(tab)
    return tabSections[tab]
end
function Eps1llonUI:Destroy()
    gui:Destroy()
end

-- THEME HANDLING
local themes = {
    Blue   = { main = Color3.fromRGB(25,25,30),    accent = Color3.fromRGB(31,81,178)  },
    Red    = { main = Color3.fromRGB(35,25,25),    accent = Color3.fromRGB(255,69,69)   },
    Green  = { main = Color3.fromRGB(25,35,25),    accent = Color3.fromRGB(69,255,69)   },
    Purple = { main = Color3.fromRGB(25,25,35),    accent = Color3.fromRGB(138,43,226)  },
    Yellow = { main = Color3.fromRGB(35,35,25),    accent = Color3.fromRGB(255,255,69)  },
    Black  = { main = Color3.fromRGB(20,20,20),    accent = Color3.fromRGB(180,180,180) },
    Orange = { main = Color3.fromRGB(35,20,0),     accent = Color3.fromRGB(255,165,0)   },
    White  = { main = Color3.fromRGB(240,240,240), accent = Color3.fromRGB(200,200,200) },
    Brown  = { main = Color3.fromRGB(60,40,20),    accent = Color3.fromRGB(160,82,45)   },
    Pink   = { main = Color3.fromRGB(35,20,30),    accent = Color3.fromRGB(255,105,180) },
}
Eps1llonUI._ACCENT = themes["Blue"].accent
local currentTheme = "Blue"
local function applyTheme(name)
    local t = themes[name]
    if not t then return end
    currentTheme                 = name
    mainFrame.BackgroundColor3   = t.main
    underline.BackgroundColor3   = t.accent
    outline.Color                = t.accent
    outlineContentFrame.Color    = t.accent
    highlighter.BackgroundColor3 = t.accent
    Eps1llonUI._ACCENT = t.accent
    if Eps1llonUI._OnThemeChange then
        for _,func in ipairs(Eps1llonUI._OnThemeChange) do
            pcall(function() func(t.accent) end)
        end
    end
end
applyTheme(currentTheme)

-- Toggle Keybind
local toggleKey = Enum.KeyCode.Insert
UserInputService.InputBegan:Connect(function(i, p)
    if p then return end
    if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==toggleKey then
        setMainVisible(not mainFrame.Visible)
    end
end)

-- UI Settings tab (if it doesn't exist, create it)
if not tabSections["UI Settings"] then
    Eps1llonUI:AddTab("UI Settings")
end

do
    local uiSettings = tabSections["UI Settings"]
    local row1 = Instance.new("Frame", uiSettings)
    row1.Size                = UDim2.new(1, -40, 0, 30)
    row1.Position            = UDim2.new(0, 20, 0, 30)
    row1.BackgroundTransparency = 1

    local keyLabel = Instance.new("TextLabel", row1)
    keyLabel.Size            = UDim2.new(0.4, 0, 1, 0)
    keyLabel.Text            = "Toggle Keybind"
    keyLabel.Font            = Enum.Font.GothamBold
    keyLabel.TextSize        = 16
    keyLabel.TextColor3      = Color3.fromRGB(220,220,220)
    keyLabel.BackgroundTransparency = 1
    keyLabel.TextXAlignment  = Enum.TextXAlignment.Left

    local keyBtn = Instance.new("TextButton", row1)
    keyBtn.Size              = UDim2.new(0.4, 0, 1, 0)
    keyBtn.Position          = UDim2.new(0.6, 0, 0, 0)
    keyBtn.Text              = toggleKey.Name
    keyBtn.Font              = Enum.Font.GothamBold
    keyBtn.TextSize          = 16
    keyBtn.TextColor3        = Color3.fromRGB(220,220,220)
    keyBtn.BackgroundColor3  = Color3.fromRGB(32,32,36)
    keyBtn.BorderSizePixel   = 0
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,4)

    keyBtn.MouseButton1Click:Connect(function()
        keyBtn.Text = "Press any key..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.Keyboard then
                toggleKey = inp.KeyCode
                keyBtn.Text = toggleKey.Name
                conn:Disconnect()
            end
        end)
    end)
    
    local row2 = Instance.new("Frame", uiSettings)
    row2.Size                = UDim2.new(1, -40, 0, 30)
    row2.Position            = UDim2.new(0, 20, 0, 80)
    row2.BackgroundTransparency = 1

    local themeLabel = Instance.new("TextLabel", row2)
    themeLabel.Size          = UDim2.new(0.4, 0, 1, 0)
    themeLabel.Text          = "Theme"
    themeLabel.Font          = Enum.Font.GothamBold
    themeLabel.TextSize      = 16
    themeLabel.TextColor3    = Color3.fromRGB(220,220,220)
    themeLabel.BackgroundTransparency = 1
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local themeNames = {"Blue","Red","Green","Purple","Yellow","Black","Orange","White","Brown","Pink"}

    local themeBtn = Instance.new("TextButton", row2)
    themeBtn.Size            = UDim2.new(0.4, 0, 1, 0)
    themeBtn.Position        = UDim2.new(0.6, 0, 0, 0)
    themeBtn.Text            = currentTheme
    themeBtn.Font            = Enum.Font.GothamBold
    themeBtn.TextSize        = 16
    themeBtn.TextColor3      = Color3.fromRGB(220,220,220)
    themeBtn.BackgroundColor3= Color3.fromRGB(32,32,36)
    themeBtn.BorderSizePixel = 0
    Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0,4)

    local themeList = Instance.new("Frame", row2)
    themeList.Size           = UDim2.new(0.4, 0, 0, #themeNames * 28)
    themeList.Position       = UDim2.new(0.6, 0, 1, 2)
    themeList.BackgroundColor3 = Color3.fromRGB(32,32,36)
    themeList.BorderSizePixel= 0
    themeList.Visible        = false
    Instance.new("UICorner", themeList).CornerRadius = UDim.new(0,4)
 
    for i, name in ipairs(themeNames) do
        local opt = Instance.new("TextButton", themeList)
        opt.Size              = UDim2.new(1, 0, 0, 28)
        opt.Position          = UDim2.new(0, 0, 0, (i-1)*28)
        opt.BackgroundColor3  = Color3.fromRGB(32,32,36)
        opt.BorderSizePixel   = 0
        opt.Text              = name
        opt.Font              = Enum.Font.Gotham
        opt.TextSize          = 14
        opt.TextColor3        = Color3.fromRGB(220,220,220)
        Instance.new("UICorner", opt).CornerRadius = UDim.new(0,2)
        opt.MouseButton1Click:Connect(function()
            applyTheme(name)
            themeBtn.Text = name
            themeList.Visible = false
        end)
    end

    themeBtn.MouseButton1Click:Connect(function()
        themeList.Visible = not themeList.Visible
    end)
end

print("[Eps1llonUI] Script loaded successfully with Rayfield-inspired design elements")
return Eps1llonUI

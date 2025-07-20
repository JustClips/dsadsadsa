--// Eps1llonUI - 2025 Modern | Pro UI (Rayfield-inspired - Corrected)
local Eps1llonUI = {}
Eps1llonUI._VERSION = "2025.07.19-ProUX-RayfieldTrue"

local player           = game.Players.LocalPlayer
local TweenService     = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")

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

-- TRUE RAYFIELD-STYLE TOGGLE (from actual source)
function Eps1llonUI:AddToggle(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 48)
    cont.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- SelectedTheme.ElementBackground
    cont.BackgroundTransparency = 0
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 6)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- UIStroke like Rayfield
    local stroke = Instance.new("UIStroke", cont)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(50, 50, 50) -- SelectedTheme.ElementStroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Name or "Toggle"
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center

    -- TRUE Rayfield Toggle Switch
    local switchFrame = Instance.new("Frame", cont)
    switchFrame.Size = UDim2.new(0, 45, 0, 20)
    switchFrame.Position = UDim2.new(1, -65, 0.5, -10)
    switchFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- ToggleBackground
    switchFrame.BorderSizePixel = 0
    Instance.new("UICorner", switchFrame).CornerRadius = UDim.new(0, 10)

    -- Switch UIStroke
    local switchStroke = Instance.new("UIStroke", switchFrame)
    switchStroke.Thickness = 1
    switchStroke.Color = opts.Default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(125, 125, 125) -- ToggleEnabledOuterStroke/ToggleDisabledOuterStroke
    switchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- The actual indicator (like Rayfield)
    local indicator = Instance.new("Frame", switchFrame)
    indicator.Size = UDim2.new(0, 17, 0, 17)
    indicator.Position = opts.Default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(1, -40, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = opts.Default and Color3.fromRGB(0, 146, 214) or Color3.fromRGB(100, 100, 100) -- ToggleEnabled/ToggleDisabled
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 8)

    -- Indicator UIStroke
    local indicatorStroke = Instance.new("UIStroke", indicator)
    indicatorStroke.Thickness = 1
    indicatorStroke.Color = opts.Default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(125, 125, 125) -- ToggleEnabledStroke/ToggleDisabledStroke
    indicatorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local value = opts.Default and true or false
    
    local function setToggle(val)
        value = val
        
        -- Animate like Rayfield
        if val then
            TweenService:Create(indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0.5, 0)
            }):Play()
            TweenService:Create(indicatorStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(0, 170, 255) -- ToggleEnabledStroke
            }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(0, 146, 214) -- ToggleEnabled
            }):Play()
            TweenService:Create(switchStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(0, 170, 255) -- ToggleEnabledOuterStroke
            }):Play()
        else
            TweenService:Create(indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -40, 0.5, 0)
            }):Play()
            TweenService:Create(indicatorStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(125, 125, 125) -- ToggleDisabledStroke
            }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- ToggleDisabled
            }):Play()
            TweenService:Create(switchStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(125, 125, 125) -- ToggleDisabledOuterStroke
            }):Play()
        end
        
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
        if value then 
            indicator.BackgroundColor3 = accent
            indicatorStroke.Color = accent
            switchStroke.Color = accent
        end
    end)
    return cont
end

-- TRUE RAYFIELD-STYLE SLIDER (NO KNOB - just progress bar)
function Eps1llonUI:AddSlider(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 55)
    cont.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- SelectedTheme.ElementBackground
    cont.BackgroundTransparency = 0
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 6)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- UIStroke like Rayfield
    local stroke = Instance.new("UIStroke", cont)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(50, 50, 50) -- SelectedTheme.ElementStroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 16, 0, 8)
    lbl.Text = opts.Name or "Slider"
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center

    -- TRUE RAYFIELD SLIDER - Main track
    local sliderMain = Instance.new("Frame", cont)
    sliderMain.Size = UDim2.new(1, -32, 0, 8)
    sliderMain.Position = UDim2.new(0, 16, 1, -20)
    sliderMain.BackgroundColor3 = Color3.fromRGB(50, 138, 220) -- SelectedTheme.SliderBackground
    sliderMain.BorderSizePixel = 0
    Instance.new("UICorner", sliderMain).CornerRadius = UDim.new(0, 4)

    -- Slider stroke like Rayfield
    local sliderStroke = Instance.new("UIStroke", sliderMain)
    sliderStroke.Thickness = 1
    sliderStroke.Color = Color3.fromRGB(58, 163, 255) -- SelectedTheme.SliderStroke
    sliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sliderStroke.Transparency = 0.4

    -- Progress bar (NO KNOB like real Rayfield)
    local progress = Instance.new("Frame", sliderMain)
    progress.Size = UDim2.new(((opts.Default or opts.Min)-opts.Min)/(opts.Max-opts.Min), 0, 1, 0)
    progress.Position = UDim2.new(0, 0, 0, 0)
    progress.BackgroundColor3 = Color3.fromRGB(50, 138, 220) -- SelectedTheme.SliderProgress
    progress.BorderSizePixel = 0
    Instance.new("UICorner", progress).CornerRadius = UDim.new(0, 4)

    -- Progress stroke
    local progressStroke = Instance.new("UIStroke", progress)
    progressStroke.Thickness = 1
    progressStroke.Color = Color3.fromRGB(58, 163, 255) -- SelectedTheme.SliderStroke
    progressStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    progressStroke.Transparency = 0.3

    -- Value display
    local valueLabel = Instance.new("TextLabel", sliderMain)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, 10, 0, -6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.TextYAlignment = Enum.TextYAlignment.Center
    valueLabel.Text = tostring(opts.Default or opts.Min) .. (opts.Suffix and " " .. opts.Suffix or "")

    -- Interaction (like Rayfield)
    local interact = Instance.new("TextButton", sliderMain)
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""

    local dragging = false
    
    local function setSliderPos(x)
        local pct = math.clamp(x/sliderMain.AbsoluteSize.X, 0, 1)
        local v = math.floor((opts.Min or 0) + ((opts.Max or 100)-(opts.Min or 0))*pct + 0.5)
        
        -- Update progress size (like real Rayfield)
        TweenService:Create(progress, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(pct, 0, 1, 0)
        }):Play()
        
        valueLabel.Text = tostring(v) .. (opts.Suffix and " " .. opts.Suffix or "")
        if opts.Callback then opts.Callback(v) end
    end

    interact.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then
            dragging = true
            -- Visual feedback like Rayfield
            TweenService:Create(sliderStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
            TweenService:Create(progressStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        end
    end)

    interact.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or isTouch(i) then
            dragging = false
            -- Reset visual feedback
            TweenService:Create(sliderStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.4}):Play()
            TweenService:Create(progressStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
        end
    end)

    interact.MouseButton1Down:Connect(function()
        if dragging then
            local loop
            loop = RunService.Stepped:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local relativePos = mousePos - sliderMain.AbsolutePosition.X
                    setSliderPos(relativePos)
                else
                    loop:Disconnect()
                end
            end)
        end
    end)
    
    -- Theme coloring
    Eps1llonUI._OnThemeChange = Eps1llonUI._OnThemeChange or {}
    table.insert(Eps1llonUI._OnThemeChange, function(accent)
        sliderMain.BackgroundColor3 = accent
        progress.BackgroundColor3 = accent
        progressStroke.Color = accent
        sliderStroke.Color = accent
    end)
    
    return cont, valueLabel
end

-- TRUE RAYFIELD-STYLE DROPDOWN
function Eps1llonUI:AddDropdown(tab, opts)
    local sec = tabSections[tab]
    assert(sec, "Tab "..tostring(tab).." does not exist.")
    
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -8, 0, 45)
    cont.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- SelectedTheme.ElementBackground
    cont.BackgroundTransparency = 0
    cont.BorderSizePixel = 0
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 6)
    cont.LayoutOrder = #sec:GetChildren() + 1
    cont.Parent = sec

    -- UIStroke like Rayfield
    local stroke = Instance.new("UIStroke", cont)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(50, 50, 50) -- SelectedTheme.ElementStroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Name or "Dropdown"
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Selected display
    local selected = Instance.new("TextLabel", cont)
    selected.Size = UDim2.new(0.4, -30, 1, 0)
    selected.Position = UDim2.new(0.5, 4, 0, 0)
    selected.BackgroundTransparency = 1
    selected.Text = opts.Default or "None"
    selected.Font = Enum.Font.Gotham
    selected.TextSize = 14
    selected.TextColor3 = Color3.fromRGB(240, 240, 240)
    selected.TextXAlignment = Enum.TextXAlignment.Right
    selected.TextYAlignment = Enum.TextYAlignment.Center

    -- Toggle arrow (like Rayfield)
    local toggle = Instance.new("ImageLabel", cont)
    toggle.Size = UDim2.new(0, 12, 0, 12)
    toggle.Position = UDim2.new(1, -25, 0.5, -6)
    toggle.BackgroundTransparency = 1
    toggle.Image = "rbxassetid://3570695787" -- Default arrow
    toggle.ImageColor3 = Color3.fromRGB(240, 240, 240)
    toggle.Rotation = 180

    -- Dropdown list
    local list = Instance.new("ScrollingFrame", cont)
    list.Size = UDim2.new(1, 0, 0, math.min(#opts.Options * 30, 135))
    list.Position = UDim2.new(0, 0, 1, 5)
    list.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- SelectedTheme.ElementBackground
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.ScrollBarThickness = 6
    list.ScrollBarImageColor3 = Eps1llonUI._ACCENT
    list.CanvasSize = UDim2.new(0, 0, 0, #opts.Options * 30)
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

    -- List stroke
    local listStroke = Instance.new("UIStroke", list)
    listStroke.Thickness = 1
    listStroke.Color = Color3.fromRGB(50, 50, 50)
    listStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local listLayout = Instance.new("UIListLayout", list)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local currentValue = opts.Default
    
    for i, option in ipairs(opts.Options) do
        local optBtn = Instance.new("TextButton", list)
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- DropdownUnselected
        optBtn.BorderSizePixel = 0
        optBtn.Text = option
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 11
        optBtn.LayoutOrder = i

        local optPadding = Instance.new("UIPadding", optBtn)
        optPadding.PaddingLeft = UDim.new(0, 12)

        if option == currentValue then
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- DropdownSelected
        end

        optBtn.MouseEnter:Connect(function()
            if option ~= currentValue then
                TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                }):Play()
            end
        end)
        
        optBtn.MouseLeave:Connect(function()
            if option ~= currentValue then
                TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play()
            end
        end)

        optBtn.MouseButton1Click:Connect(function()
            currentValue = option
            selected.Text = option
            list.Visible = false
            
            -- Update all options
            for _, child in pairs(list:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = child.Text == option and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
                end
            end
            
            TweenService:Create(toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {
                Rotation = 180
            }):Play()
            
            if opts.Callback then opts.Callback(option) end
        end)
    end

    -- Interact button
    local interact = Instance.new("TextButton", cont)
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""
    interact.ZIndex = 5

    interact.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        TweenService:Create(toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {
            Rotation = list.Visible and 0 or 180
        }):Play()
        
        if list.Visible then
            cont.Size = UDim2.new(1, -8, 0, 180)
        else
            cont.Size = UDim2.new(1, -8, 0, 45)
        end
    end)

    -- Theme coloring
    Eps1llonUI._OnThemeChange = Eps1llonUI._OnThemeChange or {}
    table.insert(Eps1llonUI._OnThemeChange, function(accent)
        list.ScrollBarImageColor3 = accent
        toggle.ImageColor3 = accent
    end)

    return cont, function() return currentValue end
end

function Eps1llonUI:SetTabCallback(tab, callback)
    assert(tabSections[tab], "Tab "..tostring(tab).." does not exist.")
    tabCallbacks[tab] = callback
end

-- Rest of the code remains the same (minimize/maximize, theme handling, etc.)
-- [Previous minimize/maximize and theme code here...]

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

print("[Eps1llonUI] Script loaded successfully with TRUE Rayfield-inspired design elements")
return Eps1llonUI

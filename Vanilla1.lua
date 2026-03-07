-- DESTROY OLD GUI + cleanup (also kills all active connections from a previous run)
if type(_G.VanillaHubCleanup) == "function" then
    pcall(_G.VanillaHubCleanup)
    _G.VanillaHubCleanup = nil
end

-- Nuke leftover GUIs
for _, name in pairs({"VanillaHub", "VanillaHubWarning"}) do
    if game.CoreGui:FindFirstChild(name) then
        game.CoreGui[name]:Destroy()
    end
end

-- Nuke leftover _G.VH table completely
if _G.VH then
    if _G.VH.butter and _G.VH.butter.running then
        _G.VH.butter.running = false
        if _G.VH.butter.thread then pcall(task.cancel, _G.VH.butter.thread) end
        _G.VH.butter.thread = nil
    end
    _G.VH = nil
end

-- Nuke leftover workspace markers
if workspace:FindFirstChild("VanillaHubTpCircle") then
    workspace.VanillaHubTpCircle:Destroy()
end

-- Only Lumber Tycoon 2
if game.PlaceId ~= 13822889 then
    task.spawn(function()
        task.wait(0.4)
        local warnGui = Instance.new("ScreenGui")
        warnGui.Name = "VanillaHubWarning"
        warnGui.Parent = game.CoreGui
        warnGui.ResetOnSpawn = false
        local frame = Instance.new("Frame", warnGui)
        frame.Size = UDim2.new(0, 400, 0, 220)
        frame.Position = UDim2.new(0.5, -200, 0.5, -110)
        frame.BackgroundColor3 = Color3.fromRGB(14, 10, 18)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
        local uiStroke = Instance.new("UIStroke", frame)
        uiStroke.Color = Color3.fromRGB(160, 80, 180)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4
        local icon = Instance.new("TextLabel", frame)
        icon.Size = UDim2.new(0, 48, 0, 48)
        icon.Position = UDim2.new(0, 24, 0, 24)
        icon.BackgroundTransparency = 1
        icon.Font = Enum.Font.GothamBlack
        icon.TextSize = 42
        icon.TextColor3 = Color3.fromRGB(200, 130, 230)
        icon.Text = "!"
        local msg = Instance.new("TextLabel", frame)
        msg.Size = UDim2.new(1, -100, 0, 120)
        msg.Position = UDim2.new(0, 90, 0, 30)
        msg.BackgroundTransparency = 1
        msg.Font = Enum.Font.GothamSemibold
        msg.TextSize = 15
        msg.TextColor3 = Color3.fromRGB(220, 200, 230)
        msg.TextXAlignment = Enum.TextXAlignment.Left
        msg.TextYAlignment = Enum.TextYAlignment.Top
        msg.TextWrapped = true
        msg.Text = "VanillaHub is made exclusively for Lumber Tycoon 2 (Place ID: 13822889).\n\nPlease join Lumber Tycoon 2 and re-execute the script there."
        local okBtn = Instance.new("TextButton", frame)
        okBtn.Size = UDim2.new(0, 160, 0, 46)
        okBtn.Position = UDim2.new(0.5, -80, 1, -66)
        okBtn.BackgroundColor3 = Color3.fromRGB(130, 60, 160)
        okBtn.BorderSizePixel = 0
        okBtn.Font = Enum.Font.GothamBold
        okBtn.TextSize = 16
        okBtn.TextColor3 = Color3.fromRGB(240, 225, 248)
        okBtn.Text = "I Understand"
        Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 12)
        local TS2 = game:GetService("TweenService")
        frame.BackgroundTransparency = 1; msg.TextTransparency = 1; icon.TextTransparency = 1
        okBtn.BackgroundTransparency = 1; okBtn.TextTransparency = 1
        TS2:Create(frame, TweenInfo.new(0.75, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.15}):Play()
        TS2:Create(msg,   TweenInfo.new(0.85, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
        TS2:Create(icon,  TweenInfo.new(0.85, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
        TS2:Create(okBtn, TweenInfo.new(0.95, Enum.EasingStyle.Quint), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        okBtn.MouseButton1Click:Connect(function()
            local outTween = TS2:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 1})
            outTween:Play()
            TS2:Create(msg,   TweenInfo.new(0.8), {TextTransparency = 1}):Play()
            TS2:Create(icon,  TweenInfo.new(0.8), {TextTransparency = 1}):Play()
            TS2:Create(okBtn, TweenInfo.new(0.8), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            outTween.Completed:Connect(function() if warnGui and warnGui.Parent then warnGui:Destroy() end end)
        end)
    end)
    return
end

-- ════════════════════════════════════════════════════
-- SERVICES & PLAYER
-- ════════════════════════════════════════════════════
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TeleportService  = game:GetService("TeleportService")
local Stats            = game:GetService("Stats")
local player           = Players.LocalPlayer

-- ── VANILLA PALETTE ──────────────────────────────────────────────────────────
local C = {
    -- Backgrounds
    BG_DEEP      = Color3.fromRGB(10,  8,  14),   -- main window
    BG_PANEL     = Color3.fromRGB(15, 11, 20),    -- side panel
    BG_CARD      = Color3.fromRGB(22, 16, 30),    -- cards / rows
    BG_CARD2     = Color3.fromRGB(28, 20, 38),    -- alternate card shade
    BG_TOPBAR    = Color3.fromRGB(14, 10, 20),    -- top bar
    BG_SEP       = Color3.fromRGB(45, 32, 60),    -- separator lines
    -- Accents
    ACC_PURPLE   = Color3.fromRGB(130, 60, 180),  -- primary accent
    ACC_LAVENDER = Color3.fromRGB(175,120,220),   -- secondary / hover
    ACC_SOFT     = Color3.fromRGB(210,175,240),   -- text highlight / active
    ACC_DIM      = Color3.fromRGB(100, 70, 140),  -- muted accent
    -- Text
    TEXT_BRIGHT  = Color3.fromRGB(235, 215, 250), -- main labels
    TEXT_MID     = Color3.fromRGB(170, 145, 195), -- secondary labels
    TEXT_MUTED   = Color3.fromRGB(110,  90, 140), -- section headers / hints
    TEXT_WHITE   = Color3.fromRGB(255, 255, 255),
    -- Status
    OK_GREEN     = Color3.fromRGB(100, 200, 130),
    ERR_RED      = Color3.fromRGB(200,  80,  80),
    WARN_AMBER   = Color3.fromRGB(210, 155,  60),
    -- Buttons
    BTN          = Color3.fromRGB(34, 24, 48),
    BTN_HOV      = Color3.fromRGB(55, 38, 75),
    BTN_ACTIVE   = Color3.fromRGB(100, 55, 140),
    -- Toggle
    TOG_ON       = Color3.fromRGB(120, 60, 170),
    TOG_OFF      = Color3.fromRGB(34, 24, 48),
    -- Tab
    TAB_IDLE     = Color3.fromRGB(18, 13, 26),
    TAB_HOV      = Color3.fromRGB(30, 20, 44),
    TAB_ACTIVE   = Color3.fromRGB(42, 28, 60),
    -- Sliders
    TRACK        = Color3.fromRGB(34, 24, 48),
    FILL         = Color3.fromRGB(130, 60, 180),
    KNOB         = Color3.fromRGB(220, 195, 245),
}

local THEME_TEXT = C.TEXT_BRIGHT  -- alias for legacy references

-- ════════════════════════════════════════════════════
-- CLEANUP REGISTRY
-- ════════════════════════════════════════════════════
local cleanupTasks = {}
local butterRunning = false
local butterThread  = nil

local function onExit()
    butterRunning = false
    if butterThread then pcall(task.cancel, butterThread); butterThread = nil end

    if _G.VH and _G.VH.butter then
        _G.VH.butter.running = false
        if _G.VH.butter.thread then
            pcall(task.cancel, _G.VH.butter.thread)
            _G.VH.butter.thread = nil
        end
    end

    for _, fn in ipairs(cleanupTasks) do pcall(fn) end
    cleanupTasks = {}

    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        local char = lp and lp.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then
            hum.PlatformStand = false
            hum.WalkSpeed     = 16
            hum.JumpPower     = 50
        end
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then pcall(function() obj:Destroy() end) end
            end
        end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
        end
    end)

    pcall(function()
        if workspace:FindFirstChild("VanillaHubTpCircle") then workspace.VanillaHubTpCircle:Destroy() end
    end)

    pcall(function()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "WalkWaterPlane" then obj:Destroy() end
        end
    end)

    _G.VH = nil
    _G.VanillaHubCleanup = nil
end

-- ════════════════════════════════════════════════════
-- GUI SCAFFOLD
-- ════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "VanillaHub"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false
table.insert(cleanupTasks, function()
    if gui and gui.Parent then gui:Destroy() end
end)

_G.VanillaHubCleanup = onExit

-- Outer wrapper (holds corner, no clip, no stroke)
local wrapper = Instance.new("Frame", gui)
wrapper.Size = UDim2.new(0, 0, 0, 0)
wrapper.Position = UDim2.new(0.5, -270, 0.5, -180)
wrapper.BackgroundColor3 = C.BG_DEEP
wrapper.BackgroundTransparency = 1
wrapper.BorderSizePixel = 0
wrapper.ClipsDescendants = false
Instance.new("UICorner", wrapper).CornerRadius = UDim.new(0, 14)

-- Outer glow stroke on wrapper
local outerStroke = Instance.new("UIStroke", wrapper)
outerStroke.Color = C.ACC_PURPLE
outerStroke.Thickness = 1.2
outerStroke.Transparency = 0.55

-- Main inner frame (clips content)
local main = Instance.new("Frame", wrapper)
main.Size = UDim2.new(1, 0, 1, 0)
main.Position = UDim2.new(0, 0, 0, 0)
main.BackgroundColor3 = C.BG_DEEP
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- Open animation
TweenService:Create(wrapper, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 540, 0, 360),
    BackgroundTransparency = 0
}):Play()
TweenService:Create(main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

-- ── TOP BAR ──────────────────────────────────────────────────────────────────
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = C.BG_TOPBAR
topBar.BorderSizePixel = 0
topBar.ZIndex = 4

-- Subtle bottom border on topbar
local topBarBorder = Instance.new("Frame", topBar)
topBarBorder.Size = UDim2.new(1, 0, 0, 1)
topBarBorder.Position = UDim2.new(0, 0, 1, -1)
topBarBorder.BackgroundColor3 = C.ACC_DIM
topBarBorder.BackgroundTransparency = 0.5
topBarBorder.BorderSizePixel = 0

local hubIcon = Instance.new("ImageLabel", topBar)
hubIcon.Size               = UDim2.new(0, 24, 0, 24)
hubIcon.Position           = UDim2.new(0, 10, 0.5, -12)
hubIcon.BackgroundTransparency = 1
hubIcon.BorderSizePixel    = 0
hubIcon.ScaleType          = Enum.ScaleType.Fit
hubIcon.ZIndex             = 6
hubIcon.Image              = "rbxassetid://97128823316544"
Instance.new("UICorner", hubIcon).CornerRadius = UDim.new(0, 5)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1, -90, 1, 0)
titleLbl.Position = UDim2.new(0, 42, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "VanillaHub"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 16
titleLbl.TextColor3 = C.TEXT_BRIGHT
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

local titleSub = Instance.new("TextLabel", topBar)
titleSub.Size = UDim2.new(1, -90, 1, 0)
titleSub.Position = UDim2.new(0, 130, 0, 0)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Lumber Tycoon 2"
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 11
titleSub.TextColor3 = C.TEXT_MUTED
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.ZIndex = 5

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = C.TEXT_WHITE
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(210, 60, 60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 45, 45)}):Play()
end)

-- ── CONFIRM CLOSE DIALOG ─────────────────────────────────────────────────────
local function showConfirmClose()
    if main:FindFirstChild("ConfirmOverlay") then return end
    local overlay = Instance.new("Frame", main)
    overlay.Name = "ConfirmOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.ZIndex = 9
    local dialog = Instance.new("Frame", main)
    dialog.Name = "ConfirmDialog"
    dialog.Size = UDim2.new(0, 360, 0, 170)
    dialog.Position = UDim2.new(0.5, -180, 0.5, -85)
    dialog.BackgroundColor3 = C.BG_CARD2
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 10
    Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 14)
    local dStroke = Instance.new("UIStroke", dialog)
    dStroke.Color = C.ACC_DIM; dStroke.Thickness = 1.2; dStroke.Transparency = 0.45
    local dtitle = Instance.new("TextLabel", dialog)
    dtitle.Size = UDim2.new(1, -24, 0, 38)
    dtitle.Position = UDim2.new(0, 12, 0, 10)
    dtitle.BackgroundTransparency = 1
    dtitle.Font = Enum.Font.GothamBold; dtitle.TextSize = 17
    dtitle.TextColor3 = C.TEXT_BRIGHT; dtitle.TextXAlignment = Enum.TextXAlignment.Left
    dtitle.Text = "Close VanillaHub?"
    dtitle.ZIndex = 11
    local dmsg = Instance.new("TextLabel", dialog)
    dmsg.Size = UDim2.new(1, -24, 0, 48)
    dmsg.Position = UDim2.new(0, 12, 0, 46)
    dmsg.BackgroundTransparency = 1
    dmsg.Font = Enum.Font.Gotham; dmsg.TextSize = 13
    dmsg.TextColor3 = C.TEXT_MID
    dmsg.Text = "This will stop all active features. You will need to re-execute the script to use VanillaHub again."
    dmsg.TextWrapped = true; dmsg.TextXAlignment = Enum.TextXAlignment.Left
    dmsg.ZIndex = 11
    local cancelBtn2 = Instance.new("TextButton", dialog)
    cancelBtn2.Size = UDim2.new(0, 148, 0, 40)
    cancelBtn2.Position = UDim2.new(0.5, -156, 1, -56)
    cancelBtn2.BackgroundColor3 = C.BTN
    cancelBtn2.Text = "Cancel"; cancelBtn2.Font = Enum.Font.GothamSemibold
    cancelBtn2.TextSize = 14; cancelBtn2.TextColor3 = C.TEXT_MID
    cancelBtn2.ZIndex = 11; cancelBtn2.BorderSizePixel = 0
    Instance.new("UICorner", cancelBtn2).CornerRadius = UDim.new(0, 9)
    local confirmBtn2 = Instance.new("TextButton", dialog)
    confirmBtn2.Size = UDim2.new(0, 148, 0, 40)
    confirmBtn2.Position = UDim2.new(0.5, 8, 1, -56)
    confirmBtn2.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
    confirmBtn2.Text = "Close Hub"; confirmBtn2.Font = Enum.Font.GothamSemibold
    confirmBtn2.TextSize = 14; confirmBtn2.TextColor3 = C.TEXT_WHITE
    confirmBtn2.ZIndex = 11; confirmBtn2.BorderSizePixel = 0
    Instance.new("UICorner", confirmBtn2).CornerRadius = UDim.new(0, 9)
    for _, b in {cancelBtn2, confirmBtn2} do
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = (b == confirmBtn2) and Color3.fromRGB(200, 60, 60) or C.BTN_HOV
            }):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = (b == confirmBtn2) and Color3.fromRGB(160, 45, 45) or C.BTN
            }):Play()
        end)
    end
    cancelBtn2.MouseButton1Click:Connect(function() overlay:Destroy(); dialog:Destroy() end)
    confirmBtn2.MouseButton1Click:Connect(function()
        overlay:Destroy(); dialog:Destroy()
        onExit()
        local t = TweenService:Create(wrapper, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function() if gui and gui.Parent then gui:Destroy() end end)
    end)
end

closeBtn.MouseButton1Click:Connect(showConfirmClose)

-- ── DRAG ─────────────────────────────────────────────────────────────────────
local dragging, dragStart, startPos = false, nil, nil
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = wrapper.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        wrapper.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ════════════════════════════════════════════════════
-- SIDE PANEL
-- ════════════════════════════════════════════════════
local side = Instance.new("ScrollingFrame", main)
side.Size = UDim2.new(0, 152, 1, -40)
side.Position = UDim2.new(0, 0, 0, 40)
side.BackgroundColor3 = C.BG_PANEL
side.BorderSizePixel = 0
side.ScrollBarThickness = 3
side.ScrollBarImageColor3 = C.ACC_DIM
side.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Subtle right border on side panel
local sideBorder = Instance.new("Frame", side)
sideBorder.Size = UDim2.new(0, 1, 1, 0)
sideBorder.Position = UDim2.new(1, -1, 0, 0)
sideBorder.BackgroundColor3 = C.ACC_DIM
sideBorder.BackgroundTransparency = 0.55
sideBorder.BorderSizePixel = 0
sideBorder.ZIndex = 2

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.Padding = UDim.new(0, 3)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
local sidePad = Instance.new("UIPadding", side)
sidePad.PaddingTop = UDim.new(0, 10)
sidePad.PaddingBottom = UDim.new(0, 10)
sideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    side.CanvasSize = UDim2.new(0, 0, 0, sideLayout.AbsoluteContentSize.Y + 24)
end)

-- ── SIDE PANEL SECTION DIVIDER ───────────────────────────────────────────────
local function addSideLabel(text)
    local lbl = Instance.new("TextLabel", side)
    lbl.Size = UDim2.new(0.9, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = C.TEXT_MUTED
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = string.upper(text)
    local lp = Instance.new("UIPadding", lbl); lp.PaddingLeft = UDim.new(0, 8)
end

-- ── CONTENT AREA ─────────────────────────────────────────────────────────────
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -152, 1, -40)
content.Position = UDim2.new(0, 152, 0, 40)
content.BackgroundColor3 = C.BG_DEEP
content.BorderSizePixel = 0

-- ════════════════════════════════════════════════════
-- WELCOME POPUP (compact banner, no pfp)
-- ════════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.8)
    if not (gui and gui.Parent) then return end

    local wf = Instance.new("Frame", gui)
    wf.Size = UDim2.new(0, 320, 0, 68)
    wf.Position = UDim2.new(0.5, -160, 1, -90)
    wf.BackgroundColor3 = C.BG_CARD2
    wf.BackgroundTransparency = 1
    wf.BorderSizePixel = 0
    Instance.new("UICorner", wf).CornerRadius = UDim.new(0, 12)
    local ws = Instance.new("UIStroke", wf)
    ws.Color = C.ACC_PURPLE; ws.Thickness = 1.2; ws.Transparency = 0.45

    -- hub icon (small)
    local wIcon = Instance.new("ImageLabel", wf)
    wIcon.Size = UDim2.new(0, 36, 0, 36)
    wIcon.Position = UDim2.new(0, 16, 0.5, -18)
    wIcon.BackgroundTransparency = 1
    wIcon.ImageTransparency = 1
    wIcon.ScaleType = Enum.ScaleType.Fit
    wIcon.Image = "rbxassetid://97128823316544"
    Instance.new("UICorner", wIcon).CornerRadius = UDim.new(0, 6)

    local wt = Instance.new("TextLabel", wf)
    wt.Size = UDim2.new(1, -66, 0, 24)
    wt.Position = UDim2.new(0, 62, 0, 10)
    wt.BackgroundTransparency = 1
    wt.Font = Enum.Font.GothamBold; wt.TextSize = 15
    wt.TextColor3 = C.TEXT_BRIGHT
    wt.TextXAlignment = Enum.TextXAlignment.Left
    wt.TextTransparency = 1
    wt.Text = "Welcome back, " .. player.DisplayName .. " ✨"

    local ws2 = Instance.new("TextLabel", wf)
    ws2.Size = UDim2.new(1, -66, 0, 18)
    ws2.Position = UDim2.new(0, 62, 0, 36)
    ws2.BackgroundTransparency = 1
    ws2.Font = Enum.Font.Gotham; ws2.TextSize = 11
    ws2.TextColor3 = C.TEXT_MUTED
    ws2.TextXAlignment = Enum.TextXAlignment.Left
    ws2.TextTransparency = 1
    ws2.Text = "VanillaHub is ready to use."

    TweenService:Create(wf,   TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(wt,   TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(ws2,  TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(wIcon,TweenInfo.new(0.6, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()

    task.delay(6, function()
        if not (wf and wf.Parent) then return end
        local ot = TweenService:Create(wf, TweenInfo.new(1.0, Enum.EasingStyle.Quint), {BackgroundTransparency = 1})
        ot:Play()
        TweenService:Create(wt,   TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        TweenService:Create(ws2,  TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        TweenService:Create(wIcon,TweenInfo.new(1.0), {ImageTransparency = 1}):Play()
        ot.Completed:Connect(function() if wf and wf.Parent then wf:Destroy() end end)
    end)
end)

-- ════════════════════════════════════════════════════
-- TABS
-- ════════════════════════════════════════════════════
local tabs = {"Home","Player","World","Teleport","Wood","Slot","Dupe","Item","Sorter","AutoBuy","Pixel Art","Build","Vehicle","Search","Settings"}
local pages = {}

for _, name in ipairs(tabs) do
    local page = Instance.new("ScrollingFrame", content)
    page.Name = name .. "Tab"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = C.ACC_DIM
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 16); pad.PaddingBottom = UDim.new(0, 20)
    pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 40)
    end)
    pages[name .. "Tab"] = page
end

-- ── TAB SWITCHING ─────────────────────────────────────────────────────────────
local activeTabButton = nil
local function switchTab(targetName)
    for _, page in pairs(pages) do page.Visible = (page.Name == targetName) end
    if activeTabButton then
        TweenService:Create(activeTabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = C.TAB_IDLE,
            TextColor3 = C.TEXT_MUTED
        }):Play()
        -- remove accent bar
        local bar = activeTabButton:FindFirstChild("AccentBar")
        if bar then TweenService:Create(bar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
    end
    local btn = side:FindFirstChild(targetName:gsub("Tab",""))
    if btn then
        activeTabButton = btn
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = C.TAB_ACTIVE,
            TextColor3 = C.ACC_SOFT
        }):Play()
        local bar = btn:FindFirstChild("AccentBar")
        if bar then TweenService:Create(bar, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end
    end
end

-- ── TAB BUTTONS ───────────────────────────────────────────────────────────────
-- Group labels
local tabGroups = {
    {label = "Overview",  items = {"Home"}},
    {label = "Character", items = {"Player","World"}},
    {label = "Navigation",items = {"Teleport"}},
    {label = "Lumber",    items = {"Wood","Slot","Dupe","Item","Sorter","AutoBuy"}},
    {label = "Creative",  items = {"Pixel Art","Build","Vehicle"}},
    {label = "Utility",   items = {"Search","Settings"}},
}

-- Build a lookup: tab name → group
local tabGroupMap = {}
for _, grp in ipairs(tabGroups) do
    for _, t in ipairs(grp.items) do tabGroupMap[t] = grp.label end
end

local lastGroup = nil
for _, name in ipairs(tabs) do
    local grp = tabGroupMap[name]
    if grp ~= lastGroup then
        addSideLabel(grp or "")
        lastGroup = grp
    end

    local btn = Instance.new("TextButton", side)
    btn.Name = name
    btn.Size = UDim2.new(0.92, 0, 0, 34)
    btn.BackgroundColor3 = C.TAB_IDLE
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = C.TEXT_MUTED
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 14)

    -- Left accent bar (hidden by default)
    local accentBar = Instance.new("Frame", btn)
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 3, 0.6, 0)
    accentBar.AnchorPoint = Vector2.new(0, 0.5)
    accentBar.Position = UDim2.new(0, 0, 0.5, 0)
    accentBar.BackgroundColor3 = C.ACC_LAVENDER
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    -- Ripple container
    local rippleCont = Instance.new("Frame", btn)
    rippleCont.Size = UDim2.new(1, 0, 1, 0)
    rippleCont.BackgroundTransparency = 1
    rippleCont.BorderSizePixel = 0
    rippleCont.ZIndex = 2
    rippleCont.ClipsDescendants = true
    Instance.new("UICorner", rippleCont).CornerRadius = UDim.new(0, 7)

    btn.MouseEnter:Connect(function()
        if activeTabButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = C.TAB_HOV,
                TextColor3 = C.TEXT_MID
            }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTabButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = C.TAB_IDLE,
                TextColor3 = C.TEXT_MUTED
            }):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            local rip = Instance.new("Frame", rippleCont)
            rip.Size = UDim2.new(0, 6, 0, 6)
            rip.Position = UDim2.new(0.5, -3, 0.5, -3)
            rip.BackgroundColor3 = C.ACC_SOFT
            rip.BackgroundTransparency = 0.7
            rip.BorderSizePixel = 0
            Instance.new("UICorner", rip).CornerRadius = UDim.new(1, 0)
            TweenService:Create(rip, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 120, 0, 120),
                Position = UDim2.new(0.5, -60, 0.5, -60),
                BackgroundTransparency = 1.0
            }):Play()
            task.wait(0.38)
            if rip and rip.Parent then rip:Destroy() end
        end)
        switchTab(name.."Tab")
    end)
end

switchTab("HomeTab")

-- ════════════════════════════════════════════════════
-- GUI TOGGLE
-- ════════════════════════════════════════════════════
local currentToggleKey = Enum.KeyCode.LeftAlt
local waitingForKeyGUI = false
local guiOpen = true
local isAnimatingGUI = false
local keybindButtonGUI

local function toggleGUI()
    if isAnimatingGUI then return end
    guiOpen = not guiOpen
    isAnimatingGUI = true
    if guiOpen then
        main.Visible = true
        main.Size = UDim2.new(0,0,0,0)
        main.BackgroundTransparency = 1
        local t = TweenService:Create(main, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0,540,0,360), BackgroundTransparency = 0
        })
        t:Play()
        t.Completed:Connect(function() isAnimatingGUI = false end)
    else
        local t = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function() main.Visible = false; isAnimatingGUI = false end)
    end
end

-- ════════════════════════════════════════════════════
-- SHARED COMPONENT BUILDERS
-- ════════════════════════════════════════════════════

-- Section header
local function makeSectionHeader(parent, text)
    local wrapper2 = Instance.new("Frame", parent)
    wrapper2.Size = UDim2.new(1, 0, 0, 28)
    wrapper2.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", wrapper2)
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = C.TEXT_MUTED
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = string.upper(text)

    local line = Instance.new("Frame", wrapper2)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = C.BG_SEP
    line.BackgroundTransparency = 0.4
    line.BorderSizePixel = 0
    return wrapper2
end

-- Separator
local function makeSep(parent)
    local sep = Instance.new("Frame", parent)
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = C.BG_SEP
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    return sep
end

-- Card button
local function makeButton(parent, text, subtext, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, subtext and 46 or 36)
    btn.BackgroundColor3 = C.BTN
    btn.BorderSizePixel = 0
    btn.Text = ""; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -16, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, subtext and 6 or 8)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13
    lbl.TextColor3 = C.TEXT_BRIGHT; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text

    if subtext then
        local sub = Instance.new("TextLabel", btn)
        sub.Size = UDim2.new(1, -16, 0, 16)
        sub.Position = UDim2.new(0, 12, 0, 26)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham; sub.TextSize = 10
        sub.TextColor3 = C.TEXT_MUTED; sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Text = subtext
    end

    -- Right arrow
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -26, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 14
    arrow.TextColor3 = C.ACC_DIM; arrow.Text = "›"

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN_HOV}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.15), {TextColor3 = C.ACC_LAVENDER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.15), {TextColor3 = C.ACC_DIM}):Play()
    end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

-- Toggle row
local function makeToggle(parent, text, subtext, defaultState, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, subtext and 48 or 38)
    frame.BackgroundColor3 = C.BG_CARD
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -60, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, subtext and 6 or 9)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13
    lbl.TextColor3 = C.TEXT_BRIGHT; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text

    if subtext then
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(1, -60, 0, 16)
        sub.Position = UDim2.new(0, 12, 0, 28)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham; sub.TextSize = 10
        sub.TextColor3 = C.TEXT_MUTED; sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Text = subtext
    end

    local tb = Instance.new("TextButton", frame)
    tb.Size = UDim2.new(0, 36, 0, 20)
    tb.Position = UDim2.new(1, -48, 0.5, -10)
    tb.BackgroundColor3 = defaultState and C.TOG_ON or C.TOG_OFF
    tb.Text = ""; tb.AutoButtonColor = false; tb.BorderSizePixel = 0
    Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", tb)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, defaultState and 20 or 2, 0.5, -7)
    knob.BackgroundColor3 = C.TEXT_WHITE; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local toggled = defaultState
    if callback then callback(toggled) end

    local function setToggled(val)
        toggled = val
        TweenService:Create(tb, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {BackgroundColor3 = val and C.TOG_ON or C.TOG_OFF}):Play()
        TweenService:Create(knob, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Position = UDim2.new(0, val and 20 or 2, 0.5, -7)}):Play()
    end

    tb.MouseButton1Click:Connect(function()
        toggled = not toggled; setToggled(toggled)
        if callback then callback(toggled) end
    end)
    return frame, setToggled, function() return toggled end
end

-- Slider row
local function makeSlider(parent, text, minVal, maxVal, defaultVal, unit, onChanged)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 58)
    frame.BackgroundColor3 = C.BG_CARD
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local topRow = Instance.new("Frame", frame)
    topRow.Size = UDim2.new(1, -16, 0, 20)
    topRow.Position = UDim2.new(0, 8, 0, 8)
    topRow.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", topRow)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13
    lbl.TextColor3 = C.TEXT_BRIGHT; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = text

    local valLbl = Instance.new("TextLabel", topRow)
    valLbl.Size = UDim2.new(0.35, 0, 1, 0); valLbl.Position = UDim2.new(0.65, 0, 0, 0)
    valLbl.BackgroundTransparency = 1; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 13
    valLbl.TextColor3 = C.ACC_LAVENDER; valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Text = tostring(defaultVal) .. (unit or "")

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, -16, 0, 6); track.Position = UDim2.new(0, 8, 0, 38)
    track.BackgroundColor3 = C.TRACK; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal), 0, 1, 0)
    fill.BackgroundColor3 = C.FILL; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("TextButton", track)
    knob.Size = UDim2.new(0, 14, 0, 14); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal), 0, 0.5, 0)
    knob.BackgroundColor3 = C.KNOB; knob.Text = ""; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false
    local function updateSlider(absX)
        local ratio = math.clamp((absX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.round(minVal + ratio*(maxVal-minVal))
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        valLbl.Text = tostring(val) .. (unit or "")
        if onChanged then onChanged(val) end
    end
    knob.MouseButton1Down:Connect(function() draggingSlider = true end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true; updateSlider(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    return frame
end

-- Stat display row
local function makeStatRow(parent, label, valueText, valueColor)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = C.BG_CARD
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12
    lbl.TextColor3 = C.TEXT_MID; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label

    local val = Instance.new("TextLabel", frame)
    val.Size = UDim2.new(0.45, -12, 1, 0)
    val.Position = UDim2.new(0.55, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Font = Enum.Font.GothamSemibold; val.TextSize = 12
    val.TextColor3 = valueColor or C.TEXT_BRIGHT; val.TextXAlignment = Enum.TextXAlignment.Right
    val.Text = valueText
    return frame, val
end

-- ════════════════════════════════════════════════════
-- HOME TAB
-- ════════════════════════════════════════════════════
local homePage = pages["HomeTab"]

-- ── GREETING CARD ────────────────────────────────────────────────────────────
local greetCard = Instance.new("Frame", homePage)
greetCard.Size = UDim2.new(1, 0, 0, 64)
greetCard.BackgroundColor3 = C.BG_CARD2
greetCard.BorderSizePixel = 0
Instance.new("UICorner", greetCard).CornerRadius = UDim.new(0, 10)
local greetStroke = Instance.new("UIStroke", greetCard)
greetStroke.Color = C.ACC_PURPLE; greetStroke.Thickness = 1; greetStroke.Transparency = 0.5
local greetGrad = Instance.new("UIGradient", greetCard)
greetGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 24, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 12, 30)),
})
greetGrad.Rotation = 120

local greetIcon = Instance.new("ImageLabel", greetCard)
greetIcon.Size = UDim2.new(0, 38, 0, 38)
greetIcon.Position = UDim2.new(0, 14, 0.5, -19)
greetIcon.BackgroundTransparency = 1; greetIcon.ScaleType = Enum.ScaleType.Fit
greetIcon.Image = "rbxassetid://97128823316544"
Instance.new("UICorner", greetIcon).CornerRadius = UDim.new(0, 7)

local greetName = Instance.new("TextLabel", greetCard)
greetName.Size = UDim2.new(1, -72, 0, 22)
greetName.Position = UDim2.new(0, 64, 0, 12)
greetName.BackgroundTransparency = 1
greetName.Font = Enum.Font.GothamBold; greetName.TextSize = 16
greetName.TextColor3 = C.TEXT_BRIGHT; greetName.TextXAlignment = Enum.TextXAlignment.Left
greetName.Text = "Hey " .. player.DisplayName .. " ✨"

local greetSub = Instance.new("TextLabel", greetCard)
greetSub.Size = UDim2.new(1, -72, 0, 16)
greetSub.Position = UDim2.new(0, 64, 0, 36)
greetSub.BackgroundTransparency = 1
greetSub.Font = Enum.Font.Gotham; greetSub.TextSize = 11
greetSub.TextColor3 = C.TEXT_MUTED; greetSub.TextXAlignment = Enum.TextXAlignment.Left
greetSub.Text = "VanillaHub is loaded and ready."

-- ── STATS SECTION ────────────────────────────────────────────────────────────
makeSectionHeader(homePage, "Session Info")

local _, pingVal = makeStatRow(homePage, "Connection Ping", "Calculating...", C.OK_GREEN)
local _, lagVal = makeStatRow(homePage, "Lag Detected", "No", C.OK_GREEN)
makeStatRow(homePage, "Account Age", player.AccountAge .. " days")
makeStatRow(homePage, "Display Name", player.DisplayName)
makeStatRow(homePage, "User ID", tostring(player.UserId))

makeSectionHeader(homePage, "Quick Actions")

makeButton(homePage, "Rejoin Server", "Teleports you to a fresh instance", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
end)

makeButton(homePage, "Copy User ID", "Copies your Roblox User ID to clipboard", function()
    -- clipboard paste handled by executor environment
    setclipboard(tostring(player.UserId))
end)

local pingConn = RunService.Heartbeat:Connect(function()
    local ok, ping = pcall(function() return math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if ok then
        pingVal.Text = ping .. " ms"
        pingVal.TextColor3 = ping < 100 and C.OK_GREEN or ping < 200 and C.WARN_AMBER or C.ERR_RED
        lagVal.Text = ping > 300 and "Yes" or "No"
        lagVal.TextColor3 = ping > 300 and C.ERR_RED or C.OK_GREEN
    else
        pingVal.Text = "N/A"
    end
end)
table.insert(cleanupTasks, function()
    if pingConn then pingConn:Disconnect(); pingConn = nil end
end)

-- ════════════════════════════════════════════════════
-- TELEPORT TAB
-- ════════════════════════════════════════════════════
local teleportPage = pages["TeleportTab"]

makeSectionHeader(teleportPage, "Quick Travel")

local locations = {
    {name="Spawn",              desc="Starting area",                   x=172,    y=3,      z=74},
    {name="Wood Drop-Off",      desc="Sell logs here",                  x=323.41, y=-2.8,   z=134.73},
    {name="Wood R-Us",          desc="Buy tools and axes",              x=265,    y=3.2,    z=57},
    {name="Land Store",         desc="Purchase land plots",             x=258,    y=3.2,    z=-99},
    {name="The Den",            desc="Cozy cave area",                  x=323,    y=41.8,   z=1930},
    {name="Bob's Shack",        desc="Trader NPC location",             x=260,    y=8.4,    z=-2542},
    {name="Strange Man",        desc="Mysterious merchant",             x=1061,   y=16.8,   z=1131},
    {name="Link's Logic",       desc="Electronics and gadgets shop",    x=4605,   y=3,      z=-727},
    {name="Fine Art Shop",      desc="Art supply store",                x=5207,   y=-166.2, z=719},
    {name="Fancy Furnishings",  desc="Furniture store",                 x=491,    y=3.2,    z=-1720},
    {name="Docks",              desc="Waterfront area",                 x=1114,   y=-1.2,   z=-197},
    {name="Bridge",             desc="Connects main areas",             x=112.31, y=11,     z=-782.36},
    {name="Safari",             desc="Animal biome",                    x=111.85, y=11,     z=-998.8},
    {name="Snow Biome",         desc="Frosted forest area",             x=889.96, y=59.8,   z=1195.55},
    {name="SnowGlow Biome",     desc="Glowing snow trees",              x=-1086.85,y=-5.9,  z=-945.32},
    {name="Cherry Meadow",      desc="Pink blossom forest",             x=220.9,  y=59.8,   z=1305.8},
    {name="The Cabin",          desc="Isolated cabin in the woods",     x=1244,   y=63.6,   z=2306},
    {name="Tiaga Peak",         desc="Snowy mountain peak",             x=1560,   y=410.32, z=3274},
    {name="LightHouse",         desc="Coastal lighthouse",              x=1464.8, y=355.25, z=3257.2},
    {name="The Swamp",          desc="Murky swamp biome",               x=-1209,  y=132.32, z=-801},
    {name="Shrine of Sight",    desc="Hidden shrine location",          x=-1600,  y=195.4,  z=919},
    {name="Volcano",            desc="Active volcano top",              x=-1585,  y=622.8,  z=1140},
    {name="Green Box",          desc="Green mystery box spot",          x=-1668.05,y=349.6, z=1475.39},
    {name="Cave",               desc="Underground cave system",         x=3581,   y=-179.54,z=430},
    {name="EndTimes Cave",      desc="Eerie end-game cave",             x=113,    y=-213,   z=-951},
    {name="Bird Cave",          desc="Bird nest cave entrance",         x=4813.1, y=17.7,   z=-978.8},
    {name="Palm Island",        desc="Tropical island",                 x=2549,   y=-5.9,   z=-42},
    {name="Palm Island 2",      desc="Second tropical island",          x=1960,   y=-5.9,   z=-1501},
    {name="Palm Island 3",      desc="Third tropical island",           x=4344,   y=-5.9,   z=-1813},
    {name="Boxed Cars",         desc="Abandoned car lot",               x=509,    y=3.2,    z=-1463},
}

for _, loc in ipairs(locations) do
    makeButton(teleportPage, loc.name, loc.desc, function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y + 3, loc.z)
        end
    end)
end

-- ════════════════════════════════════════════════════
-- PLAYER TAB
-- ════════════════════════════════════════════════════
local playerPage = pages["PlayerTab"]

local savedWalkSpeed = 16
local savedJumpPower = 50

local statsConn2 = RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if hum.WalkSpeed ~= savedWalkSpeed then hum.WalkSpeed = savedWalkSpeed end
    if hum.JumpPower ~= savedJumpPower then hum.JumpPower = savedJumpPower end
end)
table.insert(cleanupTasks, function()
    if statsConn2 then statsConn2:Disconnect(); statsConn2 = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
    end
end)

makeSectionHeader(playerPage, "Movement")

makeSlider(playerPage, "Walk Speed", 16, 150, 16, nil, function(val)
    savedWalkSpeed = val
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = val end
end)

makeSlider(playerPage, "Jump Power", 50, 300, 50, nil, function(val)
    savedJumpPower = val
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = val end
end)

local flySpeed = 100
makeSlider(playerPage, "Fly Speed", 50, 600, 100, nil, function(val) flySpeed = val end)

-- Fly key binding row
local flyKeyFrame = Instance.new("Frame", playerPage)
flyKeyFrame.Size = UDim2.new(1, 0, 0, 38)
flyKeyFrame.BackgroundColor3 = C.BG_CARD
flyKeyFrame.BorderSizePixel = 0
Instance.new("UICorner", flyKeyFrame).CornerRadius = UDim.new(0, 8)

local fkLabel = Instance.new("TextLabel", flyKeyFrame)
fkLabel.Size = UDim2.new(0.6, 0, 1, 0); fkLabel.Position = UDim2.new(0, 12, 0, 0)
fkLabel.BackgroundTransparency = 1; fkLabel.Font = Enum.Font.GothamSemibold; fkLabel.TextSize = 13
fkLabel.TextColor3 = C.TEXT_BRIGHT; fkLabel.TextXAlignment = Enum.TextXAlignment.Left; fkLabel.Text = "Fly Toggle Key"

local currentFlyKey = Enum.KeyCode.Q
local waitingForFlyKey = false
local flyKeyBtn = Instance.new("TextButton", flyKeyFrame)
flyKeyBtn.Size = UDim2.new(0, 56, 0, 24); flyKeyBtn.Position = UDim2.new(1, -68, 0.5, -12)
flyKeyBtn.BackgroundColor3 = C.BTN; flyKeyBtn.Font = Enum.Font.GothamBold
flyKeyBtn.TextSize = 12; flyKeyBtn.TextColor3 = C.ACC_SOFT; flyKeyBtn.Text = "Q"
flyKeyBtn.BorderSizePixel = 0
Instance.new("UICorner", flyKeyBtn).CornerRadius = UDim.new(0, 6)
flyKeyBtn.MouseEnter:Connect(function() TweenService:Create(flyKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN_HOV}):Play() end)
flyKeyBtn.MouseLeave:Connect(function() TweenService:Create(flyKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN}):Play() end)
flyKeyBtn.MouseButton1Click:Connect(function()
    if _G.VH and _G.VH.waitingForFlyKey then return end
    if _G.VH then _G.VH.waitingForFlyKey = true end
    flyKeyBtn.Text = "..."
    flyKeyBtn.BackgroundColor3 = C.BTN_ACTIVE
end)

-- Fly hint
local flyHintRow = Instance.new("Frame", playerPage)
flyHintRow.Size = UDim2.new(1, 0, 0, 28)
flyHintRow.BackgroundColor3 = C.BG_CARD
flyHintRow.BorderSizePixel = 0
Instance.new("UICorner", flyHintRow).CornerRadius = UDim.new(0, 8)
local flyHintLbl = Instance.new("TextLabel", flyHintRow)
flyHintLbl.Size = UDim2.new(1, -16, 1, 0); flyHintLbl.Position = UDim2.new(0, 10, 0, 0)
flyHintLbl.BackgroundTransparency = 1; flyHintLbl.Font = Enum.Font.Gotham; flyHintLbl.TextSize = 11
flyHintLbl.TextColor3 = C.TEXT_MUTED; flyHintLbl.TextXAlignment = Enum.TextXAlignment.Left
flyHintLbl.Text = "Press your fly key (Q by default) to toggle flight on and off."

makeSep(playerPage)
makeSectionHeader(playerPage, "Abilities")

local isFlyEnabled = false
local flyToggleEnabled = true
local flyBV, flyBG, flyConn

local function stopFly()
    isFlyEnabled = false
    if _G.VH then _G.VH.isFlyEnabled = false end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
    if flyBG and flyBG.Parent then flyBG:Destroy(); flyBG = nil end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
end

local function startFly()
    stopFly(); isFlyEnabled = true
    if _G.VH then _G.VH.isFlyEnabled = true end
    local char = player.Character
    if not char then isFlyEnabled = false; return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChild("Humanoid")
    if not root or not hum then isFlyEnabled = false; return end
    hum.PlatformStand = true
    flyBV = Instance.new("BodyVelocity", root)
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5); flyBV.Velocity = Vector3.zero
    flyBG = Instance.new("BodyGyro", root)
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBG.P = 1e4; flyBG.D = 100
    flyConn = RunService.Heartbeat:Connect(function()
        if not (flyBV and flyBV.Parent and flyBG and flyBG.Parent) then return end
        local c = player.Character; local h = c and c:FindFirstChild("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
        if not (h and r) then return end
        local cam = workspace.CurrentCamera; local cf = cam.CFrame
        local UIS = UserInputService; local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        h.PlatformStand = true
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        flyBG.CFrame = cf
    end)
end

table.insert(cleanupTasks, stopFly)

makeToggle(playerPage, "Noclip", "Walk through walls and objects", false, function(val)
    if val then
        local nc
        nc = RunService.Stepped:Connect(function()
            if not val then nc:Disconnect(); return end
            local char = player.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
        table.insert(cleanupTasks, function() if nc then nc:Disconnect() end end)
    else
        local char = player.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

makeToggle(playerPage, "Infinite Jump", "Jump again mid-air with no limit", false, function(val)
    if val then
        local ij
        ij = UserInputService.JumpRequest:Connect(function()
            if not val then ij:Disconnect(); return end
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        table.insert(cleanupTasks, function() if ij then ij:Disconnect() end end)
    end
end)

-- ════════════════════════════════════════════════════
-- ITEM TAB  (rebuilt with new components)
-- ════════════════════════════════════════════════════
local itemPage = pages["ItemTab"]
local itemList2 = itemPage:FindFirstChildOfClass("UIListLayout")
if itemList2 then itemList2.Padding = UDim.new(0, 6) end

local clickSelection = false
local lassoTool = false
local groupSelection = false
local selectedItems = {}
local tpCircle = nil
local isItemTeleporting = false
local tpProgressContainer = nil
local tpProgressFill = nil
local tpProgressLabel = nil

local function getOwner(model)
    local ov = model:FindFirstChild("Owner")
    if ov then
        if ov:IsA("ObjectValue") then return ov.Value
        elseif ov:IsA("StringValue") then return ov.Value end
    end
    return nil
end

local function getItemCategory(model)
    local iv = model:FindFirstChild("ItemName")
    if iv and iv:IsA("StringValue") then return iv.Value end
    return model.Name
end

local function isMoveableItem(model)
    local mp = model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    if not mp then return false end
    if model == workspace then return false end
    local staticNames = {Map=true,Terrain=true,Camera=true,Baseplate=true,Base=true,Ground=true,Land=true,Island=true,Water=true,Tree=true,Palm=true,Bush=true,Rock=true,Stump=true,Branch=true,Log=true,PalmTree=true,CypressTree=true,SpruceTree=true,ElmTree=true,ChestnutTree=true,CherryTree=true,OakTree=true,BirchTree=true,Fence=true,Road=true,Path=true,River=true,Cliff=true,Hill=true,Bridge=true}
    if staticNames[model.Name] then return false end
    local hasOwner = model:FindFirstChild("Owner") ~= nil
    if not hasOwner then
        local hasItemName = model:FindFirstChild("ItemName") ~= nil
        if not hasItemName then return false end
    end
    return true
end

local function highlightModel(model)
    if selectedItems[model] then return end
    local hl = Instance.new("SelectionBox")
    hl.Color3 = C.ACC_LAVENDER; hl.LineThickness = 0.05
    hl.Adornee = model; hl.Parent = model
    selectedItems[model] = hl
end
local function unhighlightModel(model)
    if selectedItems[model] then selectedItems[model]:Destroy(); selectedItems[model] = nil end
end
local function unhighlightAll()
    for model, hl in pairs(selectedItems) do if hl and hl.Parent then hl:Destroy() end end
    selectedItems = {}
end

local function handleSelection(target, forceSelect)
    if not target then return end
    local model = target:FindFirstAncestorOfClass("Model")
    if not (model and isMoveableItem(model)) then return end
    if groupSelection then
        local ownerVal = getOwner(model); local cat = getItemCategory(model)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and isMoveableItem(obj) then
                local objCat = getItemCategory(obj)
                if objCat == cat then
                    local objOwner = getOwner(obj); local ownerMatch = true
                    if ownerVal ~= nil and objOwner ~= nil then ownerMatch = tostring(ownerVal) == tostring(objOwner) end
                    if ownerMatch then highlightModel(obj) end
                end
            end
        end
    else
        if forceSelect then highlightModel(model)
        else if selectedItems[model] then unhighlightModel(model) else highlightModel(model) end
        end
    end
end

makeSectionHeader(itemPage, "Selection Tools")

makeToggle(itemPage, "Click Selection", "Click items in the world to select them", false, function(val) clickSelection = val; if val then lassoTool = false end end)
makeToggle(itemPage, "Lasso Tool", "Draw a box to select multiple items at once", false, function(val) lassoTool = val; if val then clickSelection = false end end)
makeToggle(itemPage, "Group Selection", "Selects all matching item types by owner", false, function(val) groupSelection = val end)

makeSectionHeader(itemPage, "Teleport Destination")

-- Destination controls row
local destRow = Instance.new("Frame", itemPage)
destRow.Size = UDim2.new(1, 0, 0, 36)
destRow.BackgroundTransparency = 1

local tpSet = Instance.new("TextButton", destRow)
tpSet.Size = UDim2.new(0.5, -4, 1, 0); tpSet.Position = UDim2.new(0, 0, 0, 0)
tpSet.BackgroundColor3 = C.BTN; tpSet.Font = Enum.Font.GothamSemibold
tpSet.TextSize = 12; tpSet.TextColor3 = C.TEXT_BRIGHT; tpSet.Text = "Set Destination"
tpSet.BorderSizePixel = 0
Instance.new("UICorner", tpSet).CornerRadius = UDim.new(0, 8)

local tpRemove = Instance.new("TextButton", destRow)
tpRemove.Size = UDim2.new(0.5, -4, 1, 0); tpRemove.Position = UDim2.new(0.5, 4, 0, 0)
tpRemove.BackgroundColor3 = C.BTN; tpRemove.Font = Enum.Font.GothamSemibold
tpRemove.TextSize = 12; tpRemove.TextColor3 = C.TEXT_MID; tpRemove.Text = "Clear Destination"
tpRemove.BorderSizePixel = 0
Instance.new("UICorner", tpRemove).CornerRadius = UDim.new(0, 8)

for _, b in {tpSet, tpRemove} do
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN_HOV}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.BTN}):Play() end)
end

tpSet.MouseButton1Click:Connect(function()
    if tpCircle then tpCircle:Destroy() end
    tpCircle = Instance.new("Part"); tpCircle.Name = "VanillaHubTpCircle"
    tpCircle.Shape = Enum.PartType.Ball; tpCircle.Size = Vector3.new(3,3,3)
    tpCircle.Material = Enum.Material.Neon; tpCircle.Color = C.ACC_PURPLE
    tpCircle.Anchored = true; tpCircle.CanCollide = false
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then tpCircle.Position = char.HumanoidRootPart.Position end
    tpCircle.Parent = workspace
    tpSet.Text = "Destination Set"; tpSet.TextColor3 = C.OK_GREEN
    task.delay(2, function() if tpSet and tpSet.Parent then tpSet.Text = "Set Destination"; tpSet.TextColor3 = C.TEXT_BRIGHT end end)
end)
tpRemove.MouseButton1Click:Connect(function()
    if tpCircle then tpCircle:Destroy(); tpCircle = nil end
    tpRemove.Text = "Cleared"; tpRemove.TextColor3 = C.ERR_RED
    task.delay(1.5, function() if tpRemove and tpRemove.Parent then tpRemove.Text = "Clear Destination"; tpRemove.TextColor3 = C.TEXT_MID end end)
end)

table.insert(cleanupTasks, function()
    if tpCircle and tpCircle.Parent then tpCircle:Destroy(); tpCircle = nil end
    unhighlightAll()
end)

makeSectionHeader(itemPage, "Actions")

makeButton(itemPage, "Teleport Selected Items", "Moves all highlighted items to destination", function()
    if not tpCircle then return end
    if isItemTeleporting then return end
    isItemTeleporting = true
    task.spawn(function()
        local queue = {}
        for model in pairs(selectedItems) do if model and model.Parent then table.insert(queue, model) end end
        local total = #queue; local done = 0
        if tpProgressContainer then
            tpProgressContainer.Visible = true
            tpProgressFill.Size = UDim2.new(0, 0, 1, 0)
            tpProgressLabel.Text = "Teleporting  0 / " .. total
        end
        for _, model in ipairs(queue) do
            if not isItemTeleporting then break end
            if not (model and model.Parent) then done = done + 1; continue end
            local mainPart = model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
            if not mainPart then done = done + 1; continue end
            local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then done = done + 1; continue end
            hrp.CFrame = mainPart.CFrame * CFrame.new(0, 4, 2); task.wait(0.12)
            local dragger = game.ReplicatedStorage:FindFirstChild("Interaction") and game.ReplicatedStorage.Interaction:FindFirstChild("ClientIsDragging")
            if dragger then dragger:FireServer(model) end; task.wait(0.08)
            if mainPart and mainPart.Parent then mainPart.CFrame = tpCircle.CFrame end; task.wait(0.08)
            if dragger then dragger:FireServer(model) end; task.wait(0.22)
            local hl = selectedItems[model]; if hl and hl.Parent then hl:Destroy() end; selectedItems[model] = nil
            done = done + 1
            if tpProgressContainer and tpProgressContainer.Visible then
                local pct = done / math.max(total, 1)
                TweenService:Create(tpProgressFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
                tpProgressLabel.Text = "Teleporting  " .. done .. " / " .. total
            end
        end
        isItemTeleporting = false
        if tpProgressContainer and tpProgressContainer.Visible then
            TweenService:Create(tpProgressFill, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            tpProgressLabel.Text = "Done — " .. done .. " item(s) moved"
            task.delay(2.2, function()
                if tpProgressContainer then
                    TweenService:Create(tpProgressContainer, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(tpProgressFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(tpProgressLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                    task.delay(0.45, function()
                        if tpProgressContainer then
                            tpProgressContainer.Visible = false
                            tpProgressContainer.BackgroundTransparency = 0
                            tpProgressFill.BackgroundTransparency = 0
                            tpProgressLabel.TextTransparency = 0
                        end
                    end)
                end
            end)
        end
    end)
end)

makeButton(itemPage, "Cancel Teleport", "Stops the current teleport operation", function() isItemTeleporting = false end)
makeButton(itemPage, "Clear Selection", "Deselects and unhighlights all items", function() unhighlightAll() end)

-- Progress bar
do
    local pbWrapper = Instance.new("Frame", itemPage)
    pbWrapper.Size = UDim2.new(1, 0, 0, 44)
    pbWrapper.BackgroundColor3 = C.BG_CARD; pbWrapper.BorderSizePixel = 0; pbWrapper.Visible = false
    Instance.new("UICorner", pbWrapper).CornerRadius = UDim.new(0, 8)
    local pbLabel = Instance.new("TextLabel", pbWrapper)
    pbLabel.Size = UDim2.new(1, -12, 0, 16); pbLabel.Position = UDim2.new(0, 10, 0, 6)
    pbLabel.BackgroundTransparency = 1; pbLabel.Font = Enum.Font.GothamSemibold; pbLabel.TextSize = 11
    pbLabel.TextColor3 = C.TEXT_MID; pbLabel.TextXAlignment = Enum.TextXAlignment.Left; pbLabel.Text = "Teleporting..."
    local pbTrack = Instance.new("Frame", pbWrapper)
    pbTrack.Size = UDim2.new(1, -20, 0, 8); pbTrack.Position = UDim2.new(0, 10, 0, 28)
    pbTrack.BackgroundColor3 = C.TRACK; pbTrack.BorderSizePixel = 0
    Instance.new("UICorner", pbTrack).CornerRadius = UDim.new(1, 0)
    local pbFill = Instance.new("Frame", pbTrack)
    pbFill.Size = UDim2.new(0, 0, 1, 0); pbFill.BackgroundColor3 = C.FILL; pbFill.BorderSizePixel = 0
    Instance.new("UICorner", pbFill).CornerRadius = UDim.new(1, 0)
    tpProgressContainer = pbWrapper; tpProgressFill = pbFill; tpProgressLabel = pbLabel
end

-- Lasso frame
local lassoFrame = Instance.new("Frame", gui)
lassoFrame.Name = "LassoRect"
lassoFrame.BackgroundColor3 = C.ACC_PURPLE
lassoFrame.BackgroundTransparency = 0.82; lassoFrame.BorderSizePixel = 0
lassoFrame.Visible = false; lassoFrame.ZIndex = 20
local lassoStroke = Instance.new("UIStroke", lassoFrame)
lassoStroke.Color = C.ACC_LAVENDER; lassoStroke.Thickness = 1.5; lassoStroke.Transparency = 0

local lassoStartPos = nil
local function updateLassoFrame(s, c2)
    local minX = math.min(s.X, c2.X); local minY = math.min(s.Y, c2.Y)
    lassoFrame.Position = UDim2.new(0, minX, 0, minY)
    lassoFrame.Size = UDim2.new(0, math.abs(c2.X-s.X), 0, math.abs(c2.Y-s.Y))
end

local camera = workspace.CurrentCamera
local function selectItemsInLasso()
    if not lassoStartPos then return end
    local cur = Vector2.new(player:GetMouse().X, player:GetMouse().Y)
    local minX = math.min(lassoStartPos.X, cur.X); local maxX = math.max(lassoStartPos.X, cur.X)
    local minY = math.min(lassoStartPos.Y, cur.Y); local maxY = math.max(lassoStartPos.Y, cur.Y)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and isMoveableItem(obj) then
            local mp = obj.PrimaryPart or obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
            if mp then
                local sp, onScreen = camera:WorldToScreenPoint(mp.Position)
                if onScreen and sp.X >= minX and sp.X <= maxX and sp.Y >= minY and sp.Y <= maxY then highlightModel(obj) end
            end
        end
    end
end

local mouse = player:GetMouse(); local mouseIsDragging = false
mouse.Button1Down:Connect(function()
    mouseIsDragging = true
    if lassoTool then
        lassoStartPos = Vector2.new(mouse.X, mouse.Y); lassoFrame.Size = UDim2.new(0,0,0,0); lassoFrame.Visible = true
    elseif clickSelection or groupSelection then handleSelection(mouse.Target, false) end
end)
mouse.Button1Up:Connect(function()
    mouseIsDragging = false
    if lassoTool then selectItemsInLasso(); lassoFrame.Visible = false; lassoStartPos = nil end
end)
mouse.Move:Connect(function()
    if mouseIsDragging and lassoTool and lassoStartPos then updateLassoFrame(lassoStartPos, Vector2.new(mouse.X, mouse.Y)) end
end)

-- ════════════════════════════════════════════════════
-- SHARED GLOBALS — exported for Vanilla2 and Vanilla3
-- ════════════════════════════════════════════════════
_G.VH = {
    TweenService     = TweenService,
    Players          = Players,
    UserInputService = UserInputService,
    RunService       = RunService,
    TeleportService  = TeleportService,
    Stats            = Stats,
    player           = player,
    cleanupTasks     = cleanupTasks,
    pages            = pages,
    tabs             = tabs,
    -- Color palette (accessible to Vanilla2/Vanilla3)
    C                = C,
    BTN_COLOR        = C.BTN,
    BTN_HOVER        = C.BTN_HOV,
    THEME_TEXT       = THEME_TEXT,
    -- Builders (accessible to child scripts)
    makeSectionHeader = makeSectionHeader,
    makeSep           = makeSep,
    makeButton        = makeButton,
    makeToggle        = makeToggle,
    makeSlider        = makeSlider,
    makeStatRow       = makeStatRow,
    -- State
    switchTab        = switchTab,
    toggleGUI        = toggleGUI,
    stopFly          = stopFly,
    startFly         = startFly,
    butter           = { running = false, thread = nil },
    flyToggleEnabled = true,
    isFlyEnabled     = false,
    currentFlyKey    = Enum.KeyCode.Q,
    waitingForFlyKey = false,
    flyKeyBtn        = flyKeyBtn,
    currentToggleKey = currentToggleKey,
    waitingForKeyGUI = waitingForKeyGUI,
    keybindButtonGUI = nil,
}

_G.VanillaHubCleanup = onExit

print("[VanillaHub] Vanilla1 loaded — redesigned palette active")

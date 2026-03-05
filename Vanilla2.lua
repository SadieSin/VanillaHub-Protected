-- ════════════════════════════════════════════════════
-- VANILLA2 — Butter Leak Tab
-- Imports shared state from Vanilla1 via _G.VH
-- ════════════════════════════════════════════════════

if not _G.VH then
    warn("[VanillaHub] Vanilla2: _G.VH not found. Execute Vanilla1 first.")
    return
end

print("[VanillaHub] Vanilla2 loaded")

local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player           = Players.LocalPlayer

-- ── THEME ─────────────────────────────────────────────
local C = {
    BG        = Color3.fromRGB(18, 10, 18),
    PANEL     = Color3.fromRGB(26, 14, 26),
    CARD      = Color3.fromRGB(34, 18, 34),
    TOPBAR    = Color3.fromRGB(10, 5, 12),
    PINK      = Color3.fromRGB(255, 105, 180),
    PINK_DIM  = Color3.fromRGB(200, 70, 140),
    PINK_DARK = Color3.fromRGB(120, 30, 80),
    PINK_GLOW = Color3.fromRGB(255, 160, 210),
    BTN       = Color3.fromRGB(50, 25, 50),
    BTN_HOV   = Color3.fromRGB(80, 35, 75),
    BORDER    = Color3.fromRGB(80, 30, 70),
    TEXT      = Color3.fromRGB(255, 220, 240),
    TEXT_DIM  = Color3.fromRGB(160, 110, 150),
    RED       = Color3.fromRGB(200, 40, 80),
    PROG_BG   = Color3.fromRGB(28, 10, 28),
    PROG_DONE = Color3.fromRGB(60, 200, 110),
}

-- ── CLEANUP ───────────────────────────────────────────
local cleanupTasks = {}
local function addCleanup(fn) table.insert(cleanupTasks, fn) end
local function runCleanup()
    for _, fn in ipairs(cleanupTasks) do pcall(fn) end
end

-- ══════════════════════════════════════════════════════
-- ROOT GUI
-- ══════════════════════════════════════════════════════
if game.CoreGui:FindFirstChild("VanillaButterHub") then
    game.CoreGui.VanillaButterHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name           = "VanillaButterHub"
gui.Parent         = game.CoreGui
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
addCleanup(function() if gui and gui.Parent then gui:Destroy() end end)

-- ── TOGGLE BUTTON ────────────────────────────────────
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size             = UDim2.new(0, 28, 0, 90)
toggleBtn.Position         = UDim2.new(0, 0, 0.5, -45)
toggleBtn.BackgroundColor3 = C.PINK_DARK
toggleBtn.BorderSizePixel  = 0
toggleBtn.Text             = "♡\nH\nU\nB"
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.TextSize         = 10
toggleBtn.TextColor3       = C.PINK_GLOW
toggleBtn.ZIndex           = 30
toggleBtn.AutoButtonColor  = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
local tgStroke = Instance.new("UIStroke", toggleBtn)
tgStroke.Color = C.PINK; tgStroke.Thickness = 1.2; tgStroke.Transparency = 0.3
TweenService:Create(tgStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.85}):Play()

-- ── MAIN WINDOW ───────────────────────────────────────
local main = Instance.new("Frame", gui)
main.Name                   = "Main"
main.Size                   = UDim2.new(0, 0, 0, 0)
main.Position               = UDim2.new(0.5, -195, 0.5, -245)
main.BackgroundColor3       = C.BG
main.BackgroundTransparency = 1
main.BorderSizePixel        = 0
main.ClipsDescendants       = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.BORDER; mainStroke.Thickness = 1.4; mainStroke.Transparency = 0.2

local isOpen = false
local function openWindow()
    isOpen = true
    TweenService:Create(main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 390, 0, 490), BackgroundTransparency = 0}):Play()
end
local function closeWindow()
    isOpen = false
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
end
toggleBtn.MouseButton1Click:Connect(function()
    if isOpen then closeWindow() else openWindow() end
end)
openWindow()

-- ── TOP BAR ───────────────────────────────────────────
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40); topBar.BackgroundColor3 = C.TOPBAR; topBar.BorderSizePixel = 0
local topGrad = Instance.new("UIGradient", topBar)
topGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40,10,35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,5,12))})
topGrad.Rotation = 90
local dot = Instance.new("Frame", topBar)
dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(0,14,0.5,-4); dot.BackgroundColor3 = C.PINK; dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1,-100,1,0); titleLbl.Position = UDim2.new(0,30,0,0); titleLbl.BackgroundTransparency = 1
titleLbl.Text = "♡  Butter Leak"; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 16
titleLbl.TextColor3 = C.PINK_GLOW; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0,28,0,28); closeBtn.Position = UDim2.new(1,-36,0.5,-14)
closeBtn.BackgroundColor3 = C.RED; closeBtn.Text = "×"; closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18; closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.BorderSizePixel = 0; closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
closeBtn.MouseButton1Click:Connect(function() runCleanup(); closeWindow() end)

-- ── DRAG ──────────────────────────────────────────────
local dragging, dragStart, startPos = false, nil, nil
topBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=main.Position end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ══════════════════════════════════════════════════════
-- WIDGET HELPERS
-- ══════════════════════════════════════════════════════
local function makeScroll(parent)
    local s = Instance.new("ScrollingFrame", parent)
    s.Size = UDim2.new(1,0,1,0); s.BackgroundTransparency = 1; s.BorderSizePixel = 0
    s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = C.PINK_DIM; s.CanvasSize = UDim2.new(0,0,0,0)
    local ll = Instance.new("UIListLayout", s)
    ll.Padding = UDim.new(0,5); ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        s.CanvasSize = UDim2.new(0,0,0, ll.AbsoluteContentSize.Y + 18)
    end)
    local pad = Instance.new("UIPadding", s)
    pad.PaddingTop = UDim.new(0,8); pad.PaddingBottom = UDim.new(0,10)
    return s
end

local function sectionLabel(parent, text, order)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1,-20,0,18); lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.TextColor3 = C.PINK_DIM
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = "▸  " .. string.upper(text)
    lbl.LayoutOrder = order or 0
    local p = Instance.new("UIPadding", lbl); p.PaddingLeft = UDim.new(0,4)
    return lbl
end

local function sep(parent, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-20,0,1); f.BackgroundColor3 = C.BORDER
    f.BorderSizePixel = 0; f.BackgroundTransparency = 0.5; f.LayoutOrder = order or 0
    return f
end

local function makeBtn(parent, text, color, order)
    color = color or C.BTN
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,-20,0,32); btn.BackgroundColor3 = color; btn.Text = text
    btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextColor3 = C.TEXT
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.LayoutOrder = order or 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.6
    local hov = Color3.fromRGB(math.min(color.R*255+30,255)/255, math.min(color.G*255+10,255)/255, math.min(color.B*255+25,255)/255)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=hov}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=color}):Play() end)
    return btn
end

local function makeToggle(parent, text, default, order, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,32); frame.BackgroundColor3 = C.CARD
    frame.BorderSizePixel = 0; frame.LayoutOrder = order or 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.6
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1,-56,1,0); lbl.Position = UDim2.new(0,12,0,0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextColor3 = C.TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextButton", frame)
    tb.Size = UDim2.new(0,36,0,20); tb.Position = UDim2.new(1,-46,0.5,-10)
    tb.BackgroundColor3 = default and C.PINK_DARK or C.BTN; tb.Text = ""; tb.BorderSizePixel = 0; tb.AutoButtonColor = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", tb)
    knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(0, default and 19 or 3, 0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local toggled = default
    if cb then cb(toggled) end
    tb.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(tb, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {BackgroundColor3 = toggled and C.PINK_DARK or C.BTN}):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {Position = UDim2.new(0, toggled and 19 or 3, 0.5,-7)}):Play()
        if cb then cb(toggled) end
    end)
    return frame, function() return toggled end
end

local function makeInputRow(parent, labelText, placeholder, order)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,32); frame.BackgroundColor3 = C.CARD
    frame.BorderSizePixel = 0; frame.LayoutOrder = order or 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.5
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0,100,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1
    lbl.Text = labelText; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11
    lbl.TextColor3 = C.TEXT_DIM; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1,-115,0,22); box.Position = UDim2.new(0,108,0.5,-11)
    box.BackgroundColor3 = C.BTN; box.BorderSizePixel = 0; box.Text = ""
    box.PlaceholderText = placeholder or "..."; box.PlaceholderColor3 = C.TEXT_DIM
    box.Font = Enum.Font.Gotham; box.TextSize = 11; box.TextColor3 = C.TEXT; box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)
    local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0,6)
    return frame, box
end

-- ── STATUS PILL ───────────────────────────────────────
local function makeStatusPill(parent, order)
    local bar = Instance.new("Frame", parent)
    bar.Size = UDim2.new(1,-20,0,26); bar.BackgroundColor3 = Color3.fromRGB(12,6,14)
    bar.BorderSizePixel = 0; bar.LayoutOrder = order or 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,6)
    local stroke = Instance.new("UIStroke", bar)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.4
    local sdot = Instance.new("Frame", bar)
    sdot.Size = UDim2.new(0,7,0,7); sdot.Position = UDim2.new(0,10,0.5,-3)
    sdot.BackgroundColor3 = C.PINK_DIM; sdot.BorderSizePixel = 0
    Instance.new("UICorner", sdot).CornerRadius = UDim.new(1,0)
    local stxt = Instance.new("TextLabel", bar)
    stxt.Size = UDim2.new(1,-70,1,0); stxt.Position = UDim2.new(0,24,0,0); stxt.BackgroundTransparency = 1
    stxt.Font = Enum.Font.Gotham; stxt.TextSize = 11; stxt.TextColor3 = C.TEXT_DIM
    stxt.TextXAlignment = Enum.TextXAlignment.Left; stxt.Text = "Ready"
    local scnt = Instance.new("TextLabel", bar)
    scnt.Size = UDim2.new(0,60,1,0); scnt.Position = UDim2.new(1,-68,0,0); scnt.BackgroundTransparency = 1
    scnt.Font = Enum.Font.GothamBold; scnt.TextSize = 11; scnt.TextColor3 = C.PINK
    scnt.TextXAlignment = Enum.TextXAlignment.Right; scnt.Text = ""
    return bar, stxt, scnt, sdot
end

-- ── PROGRESS BLOCK ─────────────────────────────────────
local function makeProgressBlock(parent, label, order)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1,-20,0,42)
    container.BackgroundColor3 = C.CARD
    container.BorderSizePixel = 0
    container.LayoutOrder = order or 0
    container.Visible = false
    Instance.new("UICorner", container).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.5

    local labelLbl = Instance.new("TextLabel", container)
    labelLbl.Size = UDim2.new(0.6,0,0,18)
    labelLbl.Position = UDim2.new(0,10,0,4)
    labelLbl.BackgroundTransparency = 1
    labelLbl.Font = Enum.Font.GothamSemibold
    labelLbl.TextSize = 11
    labelLbl.TextColor3 = C.PINK_GLOW
    labelLbl.TextXAlignment = Enum.TextXAlignment.Left
    labelLbl.Text = label

    local counterLbl = Instance.new("TextLabel", container)
    counterLbl.Size = UDim2.new(0.4,-10,0,18)
    counterLbl.Position = UDim2.new(0.6,0,0,4)
    counterLbl.BackgroundTransparency = 1
    counterLbl.Font = Enum.Font.GothamBold
    counterLbl.TextSize = 11
    counterLbl.TextColor3 = C.PINK
    counterLbl.TextXAlignment = Enum.TextXAlignment.Right
    counterLbl.Text = "0 / 0"

    local track = Instance.new("Frame", container)
    track.Size = UDim2.new(1,-16,0,8)
    track.Position = UDim2.new(0,8,0,26)
    track.BackgroundColor3 = C.PROG_BG
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = C.PINK
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local function setProgress(done, total)
        local pct = math.clamp(done / math.max(total, 1), 0, 1)
        counterLbl.Text = done .. " / " .. total .. " left"
        local barColor = pct >= 1
            and C.PROG_DONE
            or Color3.fromRGB(
                math.floor(C.PINK.R*255 + (C.PROG_DONE.R*255 - C.PINK.R*255)*pct) / 255,
                math.floor(C.PINK.G*255 + (C.PROG_DONE.G*255 - C.PINK.G*255)*pct) / 255,
                math.floor(C.PINK.B*255 + (C.PROG_DONE.B*255 - C.PINK.B*255)*pct) / 255
            )
        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Size = UDim2.new(pct, 0, 1, 0),
            BackgroundColor3 = barColor
        }):Play()
    end

    local function reset()
        fill.Size = UDim2.new(0,0,1,0)
        fill.BackgroundColor3 = C.PINK
        counterLbl.Text = "0 / 0"
        container.Visible = false
    end

    return container, setProgress, reset
end

-- ══════════════════════════════════════════════════════
-- ▌ BUTTER LEAK CONTENT
-- ══════════════════════════════════════════════════════
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1,0,1,-40); contentArea.Position = UDim2.new(0,0,0,40)
contentArea.BackgroundColor3 = C.PANEL; contentArea.BorderSizePixel = 0; contentArea.ClipsDescendants = true

local scrollButter = makeScroll(contentArea)
scrollButter.Visible = true

local _, sTxt2, sCnt2, sDot2 = makeStatusPill(scrollButter, 1)
local function setStatus2(msg) sTxt2.Text = msg end

sectionLabel(scrollButter, "Players", 2)
local _, giverBox    = makeInputRow(scrollButter, "Giver Name",    "player username", 3)
local _, receiverBox = makeInputRow(scrollButter, "Receiver Name", "player username", 4)

sep(scrollButter, 5)
sectionLabel(scrollButter, "What to Transfer", 6)

local _, getStructures = makeToggle(scrollButter, "Structures",      false, 7)
local _, getFurniture  = makeToggle(scrollButter, "Furniture",       false, 8)
local _, getTrucks     = makeToggle(scrollButter, "Trucks + Cargo",  false, 9)
local _, getItems      = makeToggle(scrollButter, "Purchased Items", false, 10)
local _, getGifs       = makeToggle(scrollButter, "Gif Items",       false, 11)
local _, getWood       = makeToggle(scrollButter, "Wood",            false, 12)

sep(scrollButter, 13)
sectionLabel(scrollButter, "Progress", 14)

local progStructures, setProgStructures, resetProgStructures = makeProgressBlock(scrollButter, "Structures",      15)
local progFurniture,  setProgFurniture,  resetProgFurniture  = makeProgressBlock(scrollButter, "Furniture",       16)
local progTrucks,     setProgTrucks,     resetProgTrucks     = makeProgressBlock(scrollButter, "Trucks + Cargo",  17)
local progItems,      setProgItems,      resetProgItems      = makeProgressBlock(scrollButter, "Purchased Items", 18)
local progGifs,       setProgGifs,       resetProgGifs       = makeProgressBlock(scrollButter, "Gif Items",       19)
local progWood,       setProgWood,       resetProgWood       = makeProgressBlock(scrollButter, "Wood",            20)

sep(scrollButter, 21)
local runBtn  = makeBtn(scrollButter, "▶  Run Butter Dupe", Color3.fromRGB(100,30,70), 22)
local stopBtn = makeBtn(scrollButter, "■  Stop", C.BTN, 23)

local butterRunning = false
local butterThread  = nil

local function resetAllButterProgress()
    resetProgStructures(); resetProgFurniture(); resetProgTrucks()
    resetProgItems(); resetProgGifs(); resetProgWood()
end

stopBtn.MouseButton1Click:Connect(function()
    butterRunning = false
    if butterThread then task.cancel(butterThread) end
    butterThread = nil
    setStatus2("Stopped")
    sDot2.BackgroundColor3 = C.TEXT_DIM
    resetAllButterProgress()
end)

runBtn.MouseButton1Click:Connect(function()
    if butterRunning then setStatus2("Already running!") return end
    local giverName    = giverBox.Text
    local receiverName = receiverBox.Text
    if giverName=="" or receiverName=="" then setStatus2("⚠ Enter both player names!") return end

    butterRunning = true
    sDot2.BackgroundColor3 = C.PINK
    setStatus2("Finding bases...")
    resetAllButterProgress()

    butterThread = task.spawn(function()
        local RS   = game:GetService("ReplicatedStorage")
        local LP   = Players.LocalPlayer
        local Char = LP.Character or LP.CharacterAdded:Wait()

        local GiveBase, ReceiverBase, GiveBaseOrigin, ReceiverBaseOrigin

        for _, v in pairs(workspace.Properties:GetDescendants()) do
            if v.Name == "Owner" then
                local val = tostring(v.Value)
                if val == giverName    then GiveBase=v;     GiveBaseOrigin=v.Parent:FindFirstChild("OriginSquare") end
                if val == receiverName then ReceiverBase=v; ReceiverBaseOrigin=v.Parent:FindFirstChild("OriginSquare") end
            end
        end

        if not (GiveBaseOrigin and ReceiverBaseOrigin) then
            setStatus2("⚠ Couldn't find bases!"); butterRunning=false; sDot2.BackgroundColor3=C.TEXT_DIM; return
        end

        local function isPointInside(point, boxCFrame, boxSize)
            local r = boxCFrame:PointToObjectSpace(point)
            return math.abs(r.X)<=boxSize.X/2 and math.abs(r.Y)<=boxSize.Y/2+2 and math.abs(r.Z)<=boxSize.Z/2
        end

        local function countItems(typeCheck)
            local n = 0
            for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                if v.Name=="Owner" and tostring(v.Value)==giverName and typeCheck(v.Parent) then n+=1 end
            end
            return n
        end

        -- ── STRUCTURES ────────────────────────────────────
        if getStructures() then
            local total = countItems(function(p) return p:FindFirstChild("Type") and tostring(p.Type.Value)=="Structure" and (p:FindFirstChildOfClass("Part") or p:FindFirstChildOfClass("WedgePart")) end)
            if total > 0 then
                progStructures.Visible = true
                setProgStructures(0, total)
                setStatus2("Sending structures...")
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChild("Type") and tostring(v.Parent.Type.Value)=="Structure" then
                                if v.Parent:FindFirstChildOfClass("Part") or v.Parent:FindFirstChildOfClass("WedgePart") then
                                    local PCF = (v.Parent:FindFirstChild("MainCFrame") and v.Parent.MainCFrame.Value) or v.Parent:FindFirstChildOfClass("Part").CFrame
                                    local DA  = v.Parent:FindFirstChild("BlueprintWoodClass") and v.Parent.BlueprintWoodClass.Value or nil
                                    local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                    local Off  = CFrame.new(nPos) * PCF.Rotation
                                    repeat task.wait()
                                        pcall(function()
                                            RS.PlaceStructure.ClientPlacedStructure:FireServer(v.Parent.ItemName.Value, Off, LP, DA, v.Parent, true)
                                        end)
                                    until not v.Parent
                                    done += 1; setProgStructures(done, total)
                                end
                            end
                        end
                    end
                end)
                setProgStructures(total, total)
            end
        end

        -- ── FURNITURE ─────────────────────────────────────
        if getFurniture() and butterRunning then
            local total = countItems(function(p) return p:FindFirstChild("Type") and tostring(p.Type.Value)=="Furniture" and p:FindFirstChildOfClass("Part") end)
            if total > 0 then
                progFurniture.Visible = true
                setProgFurniture(0, total)
                setStatus2("Sending furniture...")
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChild("Type") and tostring(v.Parent.Type.Value)=="Furniture" then
                                if v.Parent:FindFirstChildOfClass("Part") then
                                    local PCF = (v.Parent:FindFirstChild("MainCFrame") and v.Parent.MainCFrame.Value)
                                        or (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame)
                                        or v.Parent:FindFirstChildOfClass("Part").CFrame
                                    local DA  = v.Parent:FindFirstChild("BlueprintWoodClass") and v.Parent.BlueprintWoodClass.Value or nil
                                    local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                    local Off  = CFrame.new(nPos) * PCF.Rotation
                                    repeat task.wait()
                                        pcall(function()
                                            RS.PlaceStructure.ClientPlacedStructure:FireServer(v.Parent.ItemName.Value, Off, LP, DA, v.Parent, true)
                                        end)
                                    until not v.Parent
                                    done += 1; setProgFurniture(done, total)
                                end
                            end
                        end
                    end
                end)
                setProgFurniture(total, total)
            end
        end

        -- ══════════════════════════════════════════════════
        -- ── TRUCKS (with 25-attempt cargo retry loop) ─────
        -- After all trucks are teleported, we go back to the
        -- giver's plot and re-attempt any missed cargo parts.
        -- This repeats up to 25 times before giving up.
        -- ══════════════════════════════════════════════════
        local teleportedParts = {}
        local ignoredParts    = {}
        local DidTruckTeleport = false

        local function TeleportTruck()
            if DidTruckTeleport then return end
            if not Char.Humanoid.SeatPart then return end
            local TCF  = Char.Humanoid.SeatPart.Parent:FindFirstChild("Main").CFrame
            local nPos = TCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
            Char.Humanoid.SeatPart.Parent:SetPrimaryPartCFrame(CFrame.new(nPos) * TCF.Rotation)
            DidTruckTeleport = true
        end

        if getTrucks() and butterRunning then
            -- Count trucks
            local truckCount = 0
            for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                if v.Name=="Owner" and tostring(v.Value)==giverName and v.Parent:FindFirstChild("DriveSeat") then truckCount+=1 end
            end

            if truckCount > 0 then
                progTrucks.Visible = true
                setProgTrucks(0, truckCount)
                setStatus2("Sending trucks...")
                local truckDone = 0

                -- ── Phase 1: Teleport all trucks ──────────────
                for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                    if not butterRunning then break end
                    if v.Name=="Owner" and tostring(v.Value)==giverName and v.Parent:FindFirstChild("DriveSeat") then
                        v.Parent.DriveSeat:Sit(Char.Humanoid)
                        repeat task.wait() v.Parent.DriveSeat:Sit(Char.Humanoid) until Char.Humanoid.SeatPart
                        local tModel = Char.Humanoid.SeatPart.Parent
                        local mCF, mSz = tModel:GetBoundingBox()
                        for _, p in ipairs(tModel:GetDescendants()) do if p:IsA("BasePart") then ignoredParts[p]=true end end
                        for _, p in ipairs(Char:GetDescendants()) do if p:IsA("BasePart") then ignoredParts[p]=true end end

                        -- Collect cargo parts inside the truck's bounding box
                        for _, part in ipairs(workspace:GetDescendants()) do
                            if part:IsA("BasePart") and not ignoredParts[part] then
                                if part.Name=="Main" or part.Name=="WoodSection" then
                                    if part:FindFirstChild("Weld") and part.Weld.Part1.Parent ~= part.Parent then continue end
                                    task.spawn(function()
                                        if isPointInside(part.Position, mCF, mSz) then
                                            TeleportTruck()
                                            local PCF = part.CFrame
                                            local nP  = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                            local tOff = CFrame.new(nP) * PCF.Rotation
                                            part.CFrame = tOff
                                            table.insert(teleportedParts, {Instance=part, OldPos=part.Position, TargetCFrame=tOff})
                                        end
                                    end)
                                end
                            end
                        end

                        local SitPart   = Char.Humanoid.SeatPart
                        local DoorHinge = SitPart.Parent:FindFirstChild("PaintParts")
                            and SitPart.Parent.PaintParts:FindFirstChild("DoorLeft")
                            and SitPart.Parent.PaintParts.DoorLeft:FindFirstChild("ButtonRemote_Hinge")
                        task.wait()
                        Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        task.wait(0.1); SitPart:Destroy(); TeleportTruck(); DidTruckTeleport=false; task.wait(0.1)
                        if DoorHinge then
                            for i=1,10 do RS.Interaction.RemoteProxy:FireServer(DoorHinge) end
                        end
                        truckDone += 1; setProgTrucks(truckDone, truckCount)
                    end
                end

                -- ── Phase 2: Retry missed cargo (up to 25 attempts) ──
                -- After ALL trucks are done, loop back to the giver's plot
                -- and keep retrying any cargo that didn't move, up to 25 times.
                task.wait(1)

                local retryList = {}
                for _, data in ipairs(teleportedParts) do
                    if data.Instance and data.Instance.Parent
                        and (data.Instance.Position - data.OldPos).Magnitude < 5 then
                        ignoredParts[data.Instance] = nil
                        table.insert(retryList, data)
                    end
                end

                local cargoTotal = #teleportedParts
                local cargoDone  = cargoTotal - #retryList
                if cargoTotal > 0 then
                    progTrucks.Visible = true
                    setProgTrucks(cargoDone, cargoTotal)
                end

                local MAX_TRIES = 25
                local attempt   = 0

                repeat
                    task.wait(1)
                    retryList = {}
                    for _, data in ipairs(teleportedParts) do
                        if data.Instance and data.Instance.Parent
                            and (data.Instance.Position - data.OldPos).Magnitude < 25 then
                            table.insert(retryList, data)
                        end
                    end

                    if #retryList > 0 and butterRunning then
                        attempt += 1
                        setStatus2(string.format("Retry %d/%d — %d cargo left...", attempt, MAX_TRIES, #retryList))

                        -- Warp back to giver's plot so we are near the missed parts
                        Char.HumanoidRootPart.CFrame = CFrame.new(GiveBaseOrigin.Position + Vector3.new(0, 5, 0))
                        task.wait(0.3)

                        for _, data in ipairs(retryList) do
                            if not butterRunning then break end
                            local item = data.Instance
                            if not (item and item.Parent) then continue end
                            while (Char.HumanoidRootPart.Position - item.Position).Magnitude > 25 do
                                Char.HumanoidRootPart.CFrame = item.CFrame; task.wait(0.1)
                            end
                            RS.Interaction.ClientIsDragging:FireServer(item.Parent)
                            task.wait(0.6)
                            item.CFrame = data.TargetCFrame
                            cargoDone = cargoTotal - #retryList
                            setProgTrucks(cargoDone, cargoTotal)
                        end
                    end
                until #retryList == 0 or not butterRunning or attempt >= MAX_TRIES

                if #retryList > 0 then
                    setStatus2(string.format("Gave up after %d tries — %d part(s) missed", MAX_TRIES, #retryList))
                else
                    setStatus2("✓ All cargo teleported! ♡")
                end

                setProgTrucks(cargoTotal, cargoTotal)
                task.wait(1)
            end
        end

        -- ── SEND ITEM HELPER ──────────────────────────────
        local function seekNetOwn(part)
            if not butterRunning then return end
            if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
            end
            for i=1,50 do task.wait(0.05); RS.Interaction.ClientIsDragging:FireServer(part.Parent) end
        end
        local function sendItem(part, Offset)
            if not butterRunning then return end
            if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
            end
            seekNetOwn(part)
            for i=1,200 do part.CFrame = Offset end
            task.wait(0.2)
        end

        -- ── PURCHASED ITEMS ───────────────────────────────
        if getItems() and butterRunning then
            local total = countItems(function(p) return p:FindFirstChild("PurchasedBoxItemName") and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")) end)
            if total > 0 then
                progItems.Visible = true; setProgItems(0, total)
                setStatus2("Sending purchased items..."); local done=0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChild("PurchasedBoxItemName") then
                                local part = v.Parent:FindFirstChild("Main") or v.Parent:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame) or v.Parent:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                sendItem(part, CFrame.new(nPos) * PCF.Rotation)
                                done+=1; setProgItems(done, total)
                            end
                        end
                    end
                end)
                setProgItems(total, total)
            end
        end

        -- ── GIF ITEMS ─────────────────────────────────────
        if getGifs() and butterRunning then
            local total = countItems(function(p) return p:FindFirstChildOfClass("Script") and p:FindFirstChild("DraggableItem") and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")) end)
            if total > 0 then
                progGifs.Visible = true; setProgGifs(0, total)
                setStatus2("Sending gif items..."); local done=0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChildOfClass("Script") and v.Parent:FindFirstChild("DraggableItem") then
                                local part = v.Parent:FindFirstChild("Main") or v.Parent:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame) or v.Parent:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                sendItem(part, CFrame.new(nPos) * PCF.Rotation)
                                done+=1; setProgGifs(done, total)
                            end
                        end
                    end
                end)
                setProgGifs(total, total)
            end
        end

        -- ── WOOD ──────────────────────────────────────────
        if getWood() and butterRunning then
            local total = countItems(function(p) return p:FindFirstChild("TreeClass") and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")) end)
            if total > 0 then
                progWood.Visible = true; setProgWood(0, total)
                setStatus2("Sending wood..."); local done=0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChild("TreeClass") then
                                local part = v.Parent:FindFirstChild("Main") or v.Parent:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame) or v.Parent:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                                    Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
                                end
                                for i=1,50 do task.wait(0.05); RS.Interaction.ClientIsDragging:FireServer(part.Parent) end
                                for i=1,200 do part.CFrame = CFrame.new(nPos) * PCF.Rotation end
                                task.wait(0.2)
                                done+=1; setProgWood(done, total)
                            end
                        end
                    end
                end)
                setProgWood(total, total)
            end
        end

        if butterRunning then setStatus2("✓ Done! ♡") end
        butterRunning = false
        sDot2.BackgroundColor3 = C.PINK_DIM
        butterThread = nil
    end)
end)

-- ── KEYBIND ───────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightBracket then
        if isOpen then closeWindow() else openWindow() end
    end
end)

print("[VanillaHub] Vanilla2 — Butter Leak ready ♡  |  Press ] or click side button to toggle")

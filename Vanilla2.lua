-- ════════════════════════════════════════════════════
-- VANILLA2 — World Tab + Butter Leak Tab
-- Imports shared state from Vanilla1 via _G.VH
-- ════════════════════════════════════════════════════

if not _G.VH then
    warn("[VanillaHub] Vanilla2: _G.VH not found. Execute Vanilla1 first.")
    return
end

local TweenService     = _G.VH.TweenService
local Players          = _G.VH.Players
local UserInputService = _G.VH.UserInputService
local RunService       = _G.VH.RunService
local player           = _G.VH.player
local cleanupTasks     = _G.VH.cleanupTasks
local pages            = _G.VH.pages
local BTN_COLOR        = _G.VH.BTN_COLOR
local BTN_HOVER        = _G.VH.BTN_HOVER
local THEME_TEXT       = _G.VH.THEME_TEXT or Color3.fromRGB(230, 206, 226)

-- ════════════════════════════════════════════════════
-- WORLD TAB
-- ════════════════════════════════════════════════════
local worldPage = pages["WorldTab"]

local function createWSectionLabel(text)
    local lbl = Instance.new("TextLabel", worldPage)
    lbl.Size = UDim2.new(1,-12,0,22); lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(120,120,150); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = string.upper(text)
    local pad = Instance.new("UIPadding", lbl); pad.PaddingLeft = UDim.new(0, 4)
end

local function createWSep()
    local sep = Instance.new("Frame", worldPage)
    sep.Size = UDim2.new(1,-12,0,1); sep.BackgroundColor3 = Color3.fromRGB(40,40,55); sep.BorderSizePixel = 0
end

local function createWorldToggle(text, defaultState, callback)
    local frame = Instance.new("Frame", worldPage)
    frame.Size = UDim2.new(1,-12,0,32); frame.BackgroundColor3 = Color3.fromRGB(24,24,30)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1,-50,1,0); lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13; lbl.TextColor3 = THEME_TEXT; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextButton", frame)
    tb.Size = UDim2.new(0,34,0,18); tb.Position = UDim2.new(1,-44,0.5,-9)
    tb.BackgroundColor3 = defaultState and Color3.fromRGB(60,180,60) or BTN_COLOR
    tb.Text = ""; Instance.new("UICorner", tb).CornerRadius = UDim.new(1,0)
    local circle = Instance.new("Frame", tb)
    circle.Size = UDim2.new(0,14,0,14)
    circle.Position = UDim2.new(0, defaultState and 18 or 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
    local toggled = defaultState
    if callback then callback(toggled) end
    tb.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(tb, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = toggled and Color3.fromRGB(60,180,60) or BTN_COLOR
        }):Play()
        TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, toggled and 18 or 2, 0.5, -7)
        }):Play()
        if callback then callback(toggled) end
    end)
    return frame
end

local worldClockConn = nil
local alwaysDayActive = false
local alwaysNightActive = false
local walkOnWaterConn = nil
local walkOnWaterParts = {}

table.insert(cleanupTasks, function()
    if worldClockConn then worldClockConn:Disconnect(); worldClockConn = nil end
    if walkOnWaterConn then walkOnWaterConn:Disconnect(); walkOnWaterConn = nil end
    for _, p in ipairs(walkOnWaterParts) do
        if p and p.Parent then p:Destroy() end
    end
    walkOnWaterParts = {}
    alwaysDayActive = false
    alwaysNightActive = false
end)

createWSectionLabel("Environment")

createWorldToggle("Always Day", true, function(v)
    alwaysDayActive = v
    if worldClockConn then worldClockConn:Disconnect(); worldClockConn = nil end
    if v then
        alwaysNightActive = false
        local Lighting = game:GetService("Lighting")
        Lighting.ClockTime = 14
        worldClockConn = game:GetService("RunService").Heartbeat:Connect(function()
            Lighting.ClockTime = 14
        end)
    end
end)

createWorldToggle("Always Night", false, function(v)
    alwaysNightActive = v
    if worldClockConn then worldClockConn:Disconnect(); worldClockConn = nil end
    if v then
        alwaysDayActive = false
        local Lighting = game:GetService("Lighting")
        Lighting.ClockTime = 0
        worldClockConn = game:GetService("RunService").Heartbeat:Connect(function()
            Lighting.ClockTime = 0
        end)
    end
end)

local _origFogEnd   = game:GetService("Lighting").FogEnd
local _origFogStart = game:GetService("Lighting").FogStart
createWorldToggle("Remove Fog", false, function(v)
    local Lighting = game:GetService("Lighting")
    if v then
        Lighting.FogEnd   = 1e9
        Lighting.FogStart = 1e9
    else
        Lighting.FogEnd   = _origFogEnd
        Lighting.FogStart = _origFogStart
    end
end)

createWorldToggle("Shadows", true, function(v)
    game:GetService("Lighting").GlobalShadows = v
end)

createWSep()
createWSectionLabel("Water")

createWorldToggle("Walk On Water", false, function(v)
    if walkOnWaterConn then walkOnWaterConn:Disconnect(); walkOnWaterConn = nil end
    for _, p in ipairs(walkOnWaterParts) do
        if p and p.Parent then p:Destroy() end
    end
    walkOnWaterParts = {}
    if v then
        local function makeSolid(part)
            if part:IsA("Part") and part.Name == "Water" then
                local clone = Instance.new("Part")
                clone.Size = part.Size; clone.CFrame = part.CFrame
                clone.Anchored = true; clone.CanCollide = true
                clone.Transparency = 1; clone.Name = "WalkWaterPlane"
                clone.Parent = game:GetService("Workspace")
                table.insert(walkOnWaterParts, clone)
            end
        end
        for _, p in ipairs(game:GetService("Workspace"):GetDescendants()) do makeSolid(p) end
        walkOnWaterConn = game:GetService("Workspace").DescendantAdded:Connect(makeSolid)
    end
end)

createWorldToggle("Remove Water", false, function(v)
    if _G.VH and _G.VH.setRemovedWater then _G.VH.setRemovedWater(v) end
    for _, p in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if p:IsA("Part") and p.Name == "Water" then
            p.Transparency = v and 1 or 0.5
            p.CanCollide   = false
        end
    end
end)

-- ════════════════════════════════════════════════════
-- BUTTER LEAK TAB
-- Pulled from PinkHub v2 and integrated into VanillaHub
-- ════════════════════════════════════════════════════
local butterPage = pages["ButterTab"]

-- ── Cargo Teleport System v2 ─────────────────────────────
-- Constants
local PROXIMITY_THRESHOLD  = 25
local FAIL_THRESHOLD_FIRST = 5
local FAIL_THRESHOLD_RETRY = 5
local CARGO_MAX_ATTEMPTS   = 4
local DRAG_WAIT            = 0.6
local MOVE_WAIT            = 0.1
local RETRY_WAIT           = 1.0

local function cargoIsAlive(instance)
    return instance ~= nil and instance.Parent ~= nil
end

local function cargoHasMovedEnough(data, threshold)
    if not cargoIsAlive(data.Instance) then return true end
    return (data.Instance.Position - data.OldPos).Magnitude >= threshold
end

local function moveCharToItem(Char, item)
    local root = Char.HumanoidRootPart
    local attempts = 0
    while cargoIsAlive(item) and (root.Position - item.Position).Magnitude > PROXIMITY_THRESHOLD do
        attempts += 1
        if attempts > 50 then
            warn("[Cargo] Could not get close to item: " .. tostring(item))
            return false
        end
        root.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 4))
        task.wait(MOVE_WAIT)
    end
    return true
end

local function fireServerWithTimeout(RS, item)
    RS.Interaction.ClientIsDragging:FireServer(item.Parent)
    task.wait(DRAG_WAIT)
    return true
end

local function attemptCargoTeleport(RS, Char, data)
    local item = data.Instance
    if not cargoIsAlive(item) then return true end
    local gotClose = moveCharToItem(Char, item)
    if not gotClose then return false end
    fireServerWithTimeout(RS, item)
    if cargoIsAlive(item) then
        item.CFrame = data.TargetCFrame
        return true
    end
    return false
end

local function buildCargoRetryList(teleportedParts, threshold)
    local list = {}
    for _, data in ipairs(teleportedParts) do
        if cargoIsAlive(data.Instance) and not cargoHasMovedEnough(data, threshold) then
            table.insert(list, data)
        end
    end
    return list
end

local function runCargoV2(RS, Char, teleportedParts, onStatus, onProgress, totalForProgress)
    if #teleportedParts == 0 then
        warn("[Cargo] teleportedParts is empty — nothing to process.")
        return
    end

    task.wait(RETRY_WAIT)

    local retryList = buildCargoRetryList(teleportedParts, FAIL_THRESHOLD_FIRST)
    local attempts  = 0
    local cargoTotal = totalForProgress or #teleportedParts
    local cargoDone  = cargoTotal - #retryList

    while #retryList > 0 and attempts < CARGO_MAX_ATTEMPTS do
        attempts += 1
        if onStatus then onStatus(string.format("Retrying %d cargo (pass %d/%d)...", #retryList, attempts, CARGO_MAX_ATTEMPTS)) end

        local successCount = 0

        for _, data in ipairs(retryList) do
            local ok, err = pcall(attemptCargoTeleport, RS, Char, data)
            if ok then
                successCount += 1
                cargoDone += 1
            else
                warn("[Cargo] Error teleporting part: " .. tostring(err))
            end
            if onProgress then onProgress(cargoDone, cargoTotal) end
        end

        print(string.format("[Cargo] Pass %d complete — %d succeeded.", attempts, successCount))
        task.wait(RETRY_WAIT)
        retryList = buildCargoRetryList(teleportedParts, FAIL_THRESHOLD_RETRY)
    end

    if #retryList == 0 then
        print("[Cargo] All cargo teleported successfully!")
    else
        warn(string.format("[Cargo] %d part(s) unresolved after %d attempts.", #retryList, attempts))
    end
end

-- ── UI helpers scoped to butterPage ──────────────────────
local C = {
    BG        = Color3.fromRGB(18, 10, 18),
    CARD      = Color3.fromRGB(34, 18, 34),
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

local function bSectionLabel(text, order)
    local lbl = Instance.new("TextLabel", butterPage)
    lbl.Size = UDim2.new(1,-20,0,18); lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.TextColor3 = C.PINK_DIM
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = "▸  " .. string.upper(text)
    lbl.LayoutOrder = order or 0
    local p = Instance.new("UIPadding", lbl); p.PaddingLeft = UDim.new(0,4)
    return lbl
end

local function bSep(order)
    local f = Instance.new("Frame", butterPage)
    f.Size = UDim2.new(1,-20,0,1); f.BackgroundColor3 = C.BORDER
    f.BorderSizePixel = 0; f.BackgroundTransparency = 0.5; f.LayoutOrder = order or 0
    return f
end

local function bBtn(text, color, order)
    color = color or C.BTN
    local btn = Instance.new("TextButton", butterPage)
    btn.Size = UDim2.new(1,-20,0,32); btn.BackgroundColor3 = color; btn.Text = text
    btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextColor3 = C.TEXT
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.LayoutOrder = order or 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.6
    local hov = Color3.fromRGB(
        math.min(color.R*255+30,255)/255,
        math.min(color.G*255+10,255)/255,
        math.min(color.B*255+25,255)/255
    )
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=hov}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3=color}):Play() end)
    return btn
end

local function bToggle(text, default, order, cb)
    local frame = Instance.new("Frame", butterPage)
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

local function bInputRow(labelText, placeholder, order)
    local frame = Instance.new("Frame", butterPage)
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

local function bStatusPill(order)
    local bar = Instance.new("Frame", butterPage)
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

local function bProgressBlock(label, order)
    local container = Instance.new("Frame", butterPage)
    container.Size = UDim2.new(1,-20,0,42); container.BackgroundColor3 = C.CARD
    container.BorderSizePixel = 0; container.LayoutOrder = order or 0; container.Visible = false
    Instance.new("UICorner", container).CornerRadius = UDim.new(0,7)
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = C.BORDER; stroke.Thickness = 1; stroke.Transparency = 0.5
    local labelLbl = Instance.new("TextLabel", container)
    labelLbl.Size = UDim2.new(0.6,0,0,18); labelLbl.Position = UDim2.new(0,10,0,4)
    labelLbl.BackgroundTransparency = 1; labelLbl.Font = Enum.Font.GothamSemibold
    labelLbl.TextSize = 11; labelLbl.TextColor3 = C.PINK_GLOW
    labelLbl.TextXAlignment = Enum.TextXAlignment.Left; labelLbl.Text = label
    local counterLbl = Instance.new("TextLabel", container)
    counterLbl.Size = UDim2.new(0.4,-10,0,18); counterLbl.Position = UDim2.new(0.6,0,0,4)
    counterLbl.BackgroundTransparency = 1; counterLbl.Font = Enum.Font.GothamBold
    counterLbl.TextSize = 11; counterLbl.TextColor3 = C.PINK
    counterLbl.TextXAlignment = Enum.TextXAlignment.Right; counterLbl.Text = "0 / 0"
    local track = Instance.new("Frame", container)
    track.Size = UDim2.new(1,-16,0,8); track.Position = UDim2.new(0,8,0,26)
    track.BackgroundColor3 = C.PROG_BG; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0,0,1,0); fill.BackgroundColor3 = C.PINK; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local function setProgress(done, total)
        local pct = math.clamp(done / math.max(total,1), 0, 1)
        counterLbl.Text = done .. " / " .. total .. " left"
        local barColor = pct >= 1 and C.PROG_DONE or Color3.fromRGB(
            math.floor(C.PINK.R*255 + (C.PROG_DONE.R*255 - C.PINK.R*255)*pct) / 255,
            math.floor(C.PINK.G*255 + (C.PROG_DONE.G*255 - C.PINK.G*255)*pct) / 255,
            math.floor(C.PINK.B*255 + (C.PROG_DONE.B*255 - C.PINK.B*255)*pct) / 255
        )
        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = barColor
        }):Play()
    end
    local function reset()
        fill.Size = UDim2.new(0,0,1,0); fill.BackgroundColor3 = C.PINK
        counterLbl.Text = "0 / 0"; container.Visible = false
    end
    return container, setProgress, reset
end

-- ── Build Butter UI ───────────────────────────────────────
local _, sTxt2, sCnt2, sDot2 = bStatusPill(1)
local function setStatus2(msg) sTxt2.Text = msg end

bSectionLabel("Players", 2)
local _, giverBox    = bInputRow("Giver Name",    "player username", 3)
local _, receiverBox = bInputRow("Receiver Name", "player username", 4)

bSep(5)
bSectionLabel("What to Transfer", 6)

local _, getStructures = bToggle("Structures",      false, 7)
local _, getFurniture  = bToggle("Furniture",       false, 8)
local _, getTrucks     = bToggle("Trucks + Cargo",  false, 9)
local _, getItems      = bToggle("Purchased Items", false, 10)
local _, getGifs       = bToggle("Gif Items",       false, 11)
local _, getWood       = bToggle("Wood",            false, 12)

bSep(13)
bSectionLabel("Progress", 14)

local progStructures, setProgStructures, resetProgStructures = bProgressBlock("Structures",      15)
local progFurniture,  setProgFurniture,  resetProgFurniture  = bProgressBlock("Furniture",       16)
local progTrucks,     setProgTrucks,     resetProgTrucks     = bProgressBlock("Trucks + Cargo",  17)
local progItems,      setProgItems,      resetProgItems      = bProgressBlock("Purchased Items", 18)
local progGifs,       setProgGifs,       resetProgGifs       = bProgressBlock("Gif Items",       19)
local progWood,       setProgWood,       resetProgWood       = bProgressBlock("Wood",            20)

bSep(21)
local runBtn  = bBtn("▶  Run Butter Dupe", Color3.fromRGB(100,30,70), 22)
local stopBtn = bBtn("■  Stop", C.BTN, 23)

local butterRunning = false
local butterThread  = nil

local function resetAllButterProgress()
    resetProgStructures(); resetProgFurniture(); resetProgTrucks()
    resetProgItems(); resetProgGifs(); resetProgWood()
end

table.insert(cleanupTasks, function()
    butterRunning = false
    if butterThread then task.cancel(butterThread) end
    butterThread = nil
    resetAllButterProgress()
end)

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

        -- ── STRUCTURES ───────────────────────────────────
        if getStructures() then
            local total = countItems(function(p)
                return p:FindFirstChild("Type") and tostring(p.Type.Value)=="Structure"
                    and (p:FindFirstChildOfClass("Part") or p:FindFirstChildOfClass("WedgePart"))
            end)
            if total > 0 then
                progStructures.Visible = true; setProgStructures(0, total)
                setStatus2("Sending structures..."); local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name=="Owner" and tostring(v.Value)==giverName then
                            if v.Parent:FindFirstChild("Type") and tostring(v.Parent.Type.Value)=="Structure" then
                                if v.Parent:FindFirstChildOfClass("Part") or v.Parent:FindFirstChildOfClass("WedgePart") then
                                    local PCF = (v.Parent:FindFirstChild("MainCFrame") and v.Parent.MainCFrame.Value)
                                        or v.Parent:FindFirstChildOfClass("Part").CFrame
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

        -- ── FURNITURE ────────────────────────────────────
        if getFurniture() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChild("Type") and tostring(p.Type.Value)=="Furniture" and p:FindFirstChildOfClass("Part")
            end)
            if total > 0 then
                progFurniture.Visible = true; setProgFurniture(0, total)
                setStatus2("Sending furniture..."); local done = 0
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

        -- ── TRUCKS + CARGO (v2 retry system) ─────────────
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
            local truckCount = 0
            for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                if v.Name=="Owner" and tostring(v.Value)==giverName and v.Parent:FindFirstChild("DriveSeat") then truckCount+=1 end
            end
            if truckCount > 0 then
                progTrucks.Visible = true; setProgTrucks(0, truckCount)
                setStatus2("Sending trucks..."); local truckDone = 0
                for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                    if not butterRunning then break end
                    if v.Name=="Owner" and tostring(v.Value)==giverName and v.Parent:FindFirstChild("DriveSeat") then
                        v.Parent.DriveSeat:Sit(Char.Humanoid)
                        repeat task.wait() v.Parent.DriveSeat:Sit(Char.Humanoid) until Char.Humanoid.SeatPart
                        local tModel = Char.Humanoid.SeatPart.Parent
                        local mCF, mSz = tModel:GetBoundingBox()
                        for _, p in ipairs(tModel:GetDescendants()) do if p:IsA("BasePart") then ignoredParts[p]=true end end
                        for _, p in ipairs(Char:GetDescendants())   do if p:IsA("BasePart") then ignoredParts[p]=true end end
                        for _, part in ipairs(workspace:GetDescendants()) do
                            if part:IsA("BasePart") and not ignoredParts[part] then
                                if part.Name=="Main" or part.Name=="WoodSection" then
                                    if part:FindFirstChild("Weld") and part.Weld.Part1.Parent ~= part.Parent then continue end
                                    task.spawn(function()
                                        if isPointInside(part.Position, mCF, mSz) then
                                            TeleportTruck()
                                            local PCF  = part.CFrame
                                            local nP   = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
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

                -- ── Cargo Teleport System v2 ──────────────
                if #teleportedParts > 0 then
                    local cargoTotal = #teleportedParts
                    progTrucks.Visible = true
                    setProgTrucks(0, cargoTotal)
                    runCargoV2(
                        RS, Char, teleportedParts,
                        function(msg) setStatus2(msg) end,
                        function(done, total) setProgTrucks(done, total) end,
                        cargoTotal
                    )
                    setProgTrucks(cargoTotal, cargoTotal)
                end
            end
        end

        -- ── SEND ITEM HELPERS ─────────────────────────────
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
            local total = countItems(function(p)
                return p:FindFirstChild("PurchasedBoxItemName") and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
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
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame)
                                    or v.Parent:FindFirstChildOfClass("Part").CFrame
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
            local total = countItems(function(p)
                return p:FindFirstChildOfClass("Script") and p:FindFirstChild("DraggableItem")
                    and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
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
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame)
                                    or v.Parent:FindFirstChildOfClass("Part").CFrame
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
            local total = countItems(function(p)
                return p:FindFirstChild("TreeClass") and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
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
                                local PCF  = (v.Parent:FindFirstChild("Main") and v.Parent.Main.CFrame)
                                    or v.Parent:FindFirstChildOfClass("Part").CFrame
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

print("[VanillaHub] Vanilla2 loaded")

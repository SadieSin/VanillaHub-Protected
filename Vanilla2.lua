-- ════════════════════════════════════════════════════════════════════════════════
-- VANILLA COMBINED — Vanilla2 (Butter Leak / Dupe Tab) + World Tab
-- Requires Vanilla1 (_G.VH) to be loaded first.
-- ════════════════════════════════════════════════════════════════════════════════

if not _G.VH then
    warn("[VanillaHub] Combined: _G.VH not found. Execute Vanilla1 first.")
    return
end

local VH           = _G.VH
local TweenService = VH.TweenService
local Players      = VH.Players
local player       = VH.player
local BTN_COLOR    = VH.BTN_COLOR
local BTN_HOVER    = VH.BTN_HOVER
local THEME_TEXT   = VH.THEME_TEXT
local dupePage     = VH.pages["DupeTab"]
local worldPage    = VH.pages["WorldTab"]

if not dupePage then
    warn("[VanillaHub] Combined: DupeTab page not found.")
    return
end
if not worldPage then
    warn("[VanillaHub] Combined: WorldTab page not found.")
    return
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SHARED HELPERS (used by both tabs)
-- ════════════════════════════════════════════════════════════════════════════════

local function makeLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size               = UDim2.new(1, -12, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 11
    lbl.TextColor3         = Color3.fromRGB(120, 120, 150)
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = string.upper(text)
    Instance.new("UIPadding", lbl).PaddingLeft = UDim.new(0, 4)
    return lbl
end

local function makeSep(parent)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, -12, 0, 1)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    f.BorderSizePixel  = 0
    return f
end

local function makeToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size             = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    frame.BorderSizePixel  = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size               = UDim2.new(1, -50, 1, 0)
    lbl.Position           = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 13
    lbl.TextColor3         = THEME_TEXT
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = text
    local tb = Instance.new("TextButton", frame)
    tb.Size             = UDim2.new(0, 34, 0, 18)
    tb.Position         = UDim2.new(1, -44, 0.5, -9)
    tb.BackgroundColor3 = default and Color3.fromRGB(60, 180, 60) or BTN_COLOR
    tb.Text             = ""
    tb.BorderSizePixel  = 0
    tb.AutoButtonColor  = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", tb)
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.Position         = UDim2.new(0, default and 18 or 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local toggled = default
    if callback then callback(toggled) end
    tb.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(tb, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = toggled and Color3.fromRGB(60, 180, 60) or BTN_COLOR
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, toggled and 18 or 2, 0.5, -7)
        }):Play()
        if callback then callback(toggled) end
    end)
    -- Return frame + getter (for dupePage usage) AND tb/knob refs (for worldPage auto-enable)
    return frame, function() return toggled end, tb, knob
end

local function makeBtn(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size             = UDim2.new(1, -12, 0, 34)
    btn.BackgroundColor3 = color or BTN_COLOR
    btn.BorderSizePixel  = 0
    btn.Font             = Enum.Font.GothamSemibold
    btn.TextSize         = 13
    btn.TextColor3       = THEME_TEXT
    btn.Text             = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local base = color or BTN_COLOR
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = BTN_HOVER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function makeInput(parent, labelText, placeholder)
    local frame = Instance.new("Frame", parent)
    frame.Size             = UDim2.new(1, -12, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    frame.BorderSizePixel  = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size               = UDim2.new(0, 110, 1, 0)
    lbl.Position           = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 12
    lbl.TextColor3         = Color3.fromRGB(160, 150, 170)
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = labelText
    local box = Instance.new("TextBox", frame)
    box.Size              = UDim2.new(1, -125, 0, 22)
    box.Position          = UDim2.new(0, 118, 0.5, -11)
    box.BackgroundColor3  = Color3.fromRGB(35, 35, 45)
    box.BorderSizePixel   = 0
    box.Font              = Enum.Font.Gotham
    box.TextSize          = 12
    box.TextColor3        = THEME_TEXT
    box.PlaceholderText   = placeholder or "..."
    box.PlaceholderColor3 = Color3.fromRGB(90, 85, 100)
    box.Text              = ""
    box.ClearTextOnFocus  = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)
    return frame, box
end

local function makeProgressBar(parent, labelText)
    local wrap = Instance.new("Frame", parent)
    wrap.Size             = UDim2.new(1, -12, 0, 44)
    wrap.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    wrap.BorderSizePixel  = 0
    wrap.Visible          = false
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", wrap)
    stroke.Color       = Color3.fromRGB(60, 60, 80)
    stroke.Thickness   = 1
    stroke.Transparency = 0.5
    local topRow = Instance.new("Frame", wrap)
    topRow.Size                 = UDim2.new(1, -12, 0, 18)
    topRow.Position             = UDim2.new(0, 6, 0, 4)
    topRow.BackgroundTransparency = 1
    local nameLbl = Instance.new("TextLabel", topRow)
    nameLbl.Size               = UDim2.new(0.6, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font               = Enum.Font.GothamSemibold
    nameLbl.TextSize           = 11
    nameLbl.TextColor3         = THEME_TEXT
    nameLbl.TextXAlignment     = Enum.TextXAlignment.Left
    nameLbl.Text               = labelText
    local cntLbl = Instance.new("TextLabel", topRow)
    cntLbl.Size               = UDim2.new(0.4, 0, 1, 0)
    cntLbl.Position           = UDim2.new(0.6, 0, 0, 0)
    cntLbl.BackgroundTransparency = 1
    cntLbl.Font               = Enum.Font.GothamBold
    cntLbl.TextSize           = 11
    cntLbl.TextColor3         = Color3.fromRGB(120, 200, 120)
    cntLbl.TextXAlignment     = Enum.TextXAlignment.Right
    cntLbl.Text               = "0 / 0"
    local track = Instance.new("Frame", wrap)
    track.Size             = UDim2.new(1, -12, 0, 10)
    track.Position         = UDim2.new(0, 6, 0, 26)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size             = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
    fill.BorderSizePixel  = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local function setProgress(done, total)
        local pct = math.clamp(done / math.max(total, 1), 0, 1)
        cntLbl.Text = done .. " / " .. total
        TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(pct, 0, 1, 0)
        }):Play()
    end
    local function reset()
        fill.Size    = UDim2.new(0, 0, 1, 0)
        cntLbl.Text  = "0 / 0"
        wrap.Visible = false
    end
    return wrap, setProgress, reset
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DUPE TAB — Butter Leak
-- ════════════════════════════════════════════════════════════════════════════════

-- ── STATUS BAR ────────────────────────────────────────────────────────────────
local statusBar = Instance.new("Frame", dupePage)
statusBar.Size             = UDim2.new(1, -12, 0, 28)
statusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
statusBar.BorderSizePixel  = 0
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", statusBar).Color = Color3.fromRGB(50, 50, 70)

local statusDot = Instance.new("Frame", statusBar)
statusDot.Size             = UDim2.new(0, 8, 0, 8)
statusDot.Position         = UDim2.new(0, 10, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
statusDot.BorderSizePixel  = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size                 = UDim2.new(1, -28, 1, 0)
statusLbl.Position             = UDim2.new(0, 26, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Font                 = Enum.Font.Gotham
statusLbl.TextSize             = 12
statusLbl.TextColor3           = Color3.fromRGB(160, 155, 175)
statusLbl.TextXAlignment       = Enum.TextXAlignment.Left
statusLbl.Text                 = "Ready"

local function setStatus(msg, active)
    statusLbl.Text = msg
    TweenService:Create(statusDot, TweenInfo.new(0.2), {
        BackgroundColor3 = active and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(100, 100, 120)
    }):Play()
end

-- ── PLAYER INPUTS ─────────────────────────────────────────────────────────────
makeLabel(dupePage, "Players")
local _, giverBox    = makeInput(dupePage, "Giver Name",    "username")
local _, receiverBox = makeInput(dupePage, "Receiver Name", "username")

makeSep(dupePage)
makeLabel(dupePage, "What to Transfer")

local _, getStructures = makeToggle(dupePage, "Structures",      false)
local _, getFurniture  = makeToggle(dupePage, "Furniture",       false)
local _, getTrucks     = makeToggle(dupePage, "Trucks + Cargo",  false)
local _, getItems      = makeToggle(dupePage, "Purchased Items", false)
local _, getGifs       = makeToggle(dupePage, "Gif Items",       false)
local _, getWood       = makeToggle(dupePage, "Wood",            false)

makeSep(dupePage)
makeLabel(dupePage, "Progress")

local progStructures, setProgStructures, resetProgStructures = makeProgressBar(dupePage, "Structures")
local progFurniture,  setProgFurniture,  resetProgFurniture  = makeProgressBar(dupePage, "Furniture")
local progTrucks,     setProgTrucks,     resetProgTrucks     = makeProgressBar(dupePage, "Trucks + Cargo")
local progItems,      setProgItems,      resetProgItems      = makeProgressBar(dupePage, "Purchased Items")
local progGifs,       setProgGifs,       resetProgGifs       = makeProgressBar(dupePage, "Gif Items")
local progWood,       setProgWood,       resetProgWood       = makeProgressBar(dupePage, "Wood")

makeSep(dupePage)

local runBtn  = makeBtn(dupePage, "▶  Run Butter Dupe", Color3.fromRGB(35, 65, 35),  function() end)
local stopBtn = makeBtn(dupePage, "■  Stop",            Color3.fromRGB(65, 25, 25),  function() end)

-- ── LOGIC ─────────────────────────────────────────────────────────────────────
local butterRunning = false
local butterThread  = nil

local function resetAllProgress()
    resetProgStructures(); resetProgFurniture(); resetProgTrucks()
    resetProgItems();      resetProgGifs();      resetProgWood()
end

stopBtn.MouseButton1Click:Connect(function()
    butterRunning = false; VH.butter.running = false
    if butterThread then pcall(task.cancel, butterThread); butterThread = nil end
    VH.butter.thread = nil
    setStatus("Stopped", false)
    resetAllProgress()
end)

runBtn.MouseButton1Click:Connect(function()
    if butterRunning then setStatus("Already running!", true) return end

    local giverName    = giverBox.Text
    local receiverName = receiverBox.Text
    if giverName == "" or receiverName == "" then
        setStatus("⚠ Enter both player names!", false) return
    end

    butterRunning = true; VH.butter.running = true
    setStatus("Finding bases...", true)
    resetAllProgress()

    butterThread = task.spawn(function()
        VH.butter.thread = butterThread

        local RS   = game:GetService("ReplicatedStorage")
        local LP   = Players.LocalPlayer
        local Char = LP.Character or LP.CharacterAdded:Wait()

        local GiveBaseOrigin, ReceiverBaseOrigin

        for _, v in pairs(workspace.Properties:GetDescendants()) do
            if v.Name == "Owner" then
                local val = tostring(v.Value)
                if val == giverName    then GiveBaseOrigin     = v.Parent:FindFirstChild("OriginSquare") end
                if val == receiverName then ReceiverBaseOrigin = v.Parent:FindFirstChild("OriginSquare") end
            end
        end

        if not (GiveBaseOrigin and ReceiverBaseOrigin) then
            setStatus("⚠ Couldn't find bases!", false)
            butterRunning = false; VH.butter.running = false; butterThread = nil; VH.butter.thread = nil
            return
        end

        local function isPointInside(point, boxCFrame, boxSize)
            local r = boxCFrame:PointToObjectSpace(point)
            return math.abs(r.X) <= boxSize.X / 2
               and math.abs(r.Y) <= boxSize.Y / 2 + 2
               and math.abs(r.Z) <= boxSize.Z / 2
        end

        local function countItems(typeCheck)
            local n = 0
            for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                if v.Name == "Owner" and tostring(v.Value) == giverName and typeCheck(v.Parent) then
                    n += 1
                end
            end
            return n
        end

        -- ── STRUCTURES ────────────────────────────────────────────────────────
        if getStructures() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChild("Type") and tostring(p.Type.Value) == "Structure"
                    and (p:FindFirstChildOfClass("Part") or p:FindFirstChildOfClass("WedgePart"))
            end)
            if total > 0 then
                progStructures.Visible = true; setProgStructures(0, total)
                setStatus("Sending structures...", true)
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name == "Owner" and tostring(v.Value) == giverName then
                            local p = v.Parent
                            if p:FindFirstChild("Type") and tostring(p.Type.Value) == "Structure" then
                                if p:FindFirstChildOfClass("Part") or p:FindFirstChildOfClass("WedgePart") then
                                    local PCF  = (p:FindFirstChild("MainCFrame") and p.MainCFrame.Value) or p:FindFirstChildOfClass("Part").CFrame
                                    local DA   = p:FindFirstChild("BlueprintWoodClass") and p.BlueprintWoodClass.Value or nil
                                    local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                    local Off  = CFrame.new(nPos) * PCF.Rotation
                                    repeat task.wait()
                                        pcall(function()
                                            RS.PlaceStructure.ClientPlacedStructure:FireServer(p.ItemName.Value, Off, LP, DA, p, true)
                                        end)
                                    until not p.Parent
                                    done += 1; setProgStructures(done, total)
                                end
                            end
                        end
                    end
                end)
                setProgStructures(total, total)
            end
        end

        -- ── FURNITURE ─────────────────────────────────────────────────────────
        if getFurniture() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChild("Type") and tostring(p.Type.Value) == "Furniture"
                    and p:FindFirstChildOfClass("Part")
            end)
            if total > 0 then
                progFurniture.Visible = true; setProgFurniture(0, total)
                setStatus("Sending furniture...", true)
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name == "Owner" and tostring(v.Value) == giverName then
                            local p = v.Parent
                            if p:FindFirstChild("Type") and tostring(p.Type.Value) == "Furniture" then
                                if p:FindFirstChildOfClass("Part") then
                                    local PCF  = (p:FindFirstChild("MainCFrame") and p.MainCFrame.Value)
                                             or (p:FindFirstChild("Main") and p.Main.CFrame)
                                             or p:FindFirstChildOfClass("Part").CFrame
                                    local DA   = p:FindFirstChild("BlueprintWoodClass") and p.BlueprintWoodClass.Value or nil
                                    local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                    local Off  = CFrame.new(nPos) * PCF.Rotation
                                    repeat task.wait()
                                        pcall(function()
                                            RS.PlaceStructure.ClientPlacedStructure:FireServer(p.ItemName.Value, Off, LP, DA, p, true)
                                        end)
                                    until not p.Parent
                                    done += 1; setProgFurniture(done, total)
                                end
                            end
                        end
                    end
                end)
                setProgFurniture(total, total)
            end
        end

        -- ── TRUCKS + CARGO ────────────────────────────────────────────────────
        if getTrucks() and butterRunning then
            local teleportedParts  = {}
            local ignoredParts     = {}
            local DidTruckTeleport = false

            local function TeleportTruck()
                if DidTruckTeleport then return end
                if not Char.Humanoid.SeatPart then return end
                local TCF  = Char.Humanoid.SeatPart.Parent:FindFirstChild("Main").CFrame
                local nPos = TCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                Char.Humanoid.SeatPart.Parent:SetPrimaryPartCFrame(CFrame.new(nPos) * TCF.Rotation)
                DidTruckTeleport = true
            end

            local truckCount = 0
            for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                if v.Name == "Owner" and tostring(v.Value) == giverName and v.Parent:FindFirstChild("DriveSeat") then
                    truckCount += 1
                end
            end

            if truckCount > 0 then
                progTrucks.Visible = true; setProgTrucks(0, truckCount)
                setStatus("Sending trucks...", true)
                local truckDone = 0

                -- Phase 1: teleport all trucks
                for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                    if not butterRunning then break end
                    if v.Name == "Owner" and tostring(v.Value) == giverName and v.Parent:FindFirstChild("DriveSeat") then
                        v.Parent.DriveSeat:Sit(Char.Humanoid)
                        repeat task.wait() v.Parent.DriveSeat:Sit(Char.Humanoid) until Char.Humanoid.SeatPart

                        local tModel   = Char.Humanoid.SeatPart.Parent
                        local mCF, mSz = tModel:GetBoundingBox()

                        for _, p in ipairs(tModel:GetDescendants()) do
                            if p:IsA("BasePart") then ignoredParts[p] = true end
                        end
                        for _, p in ipairs(Char:GetDescendants()) do
                            if p:IsA("BasePart") then ignoredParts[p] = true end
                        end

                        for _, part in ipairs(workspace:GetDescendants()) do
                            if part:IsA("BasePart") and not ignoredParts[part] then
                                if part.Name == "Main" or part.Name == "WoodSection" then
                                    if part:FindFirstChild("Weld") and part.Weld.Part1.Parent ~= part.Parent then continue end
                                    task.spawn(function()
                                        if isPointInside(part.Position, mCF, mSz) then
                                            TeleportTruck()
                                            local PCF  = part.CFrame
                                            local nP   = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                            local tOff = CFrame.new(nP) * PCF.Rotation
                                            part.CFrame = tOff
                                            task.wait(0.3)
                                            table.insert(teleportedParts, {
                                                Instance     = part,
                                                OldPos       = part.Position,
                                                TargetCFrame = tOff,
                                            })
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
                        task.wait(0.1); SitPart:Destroy(); TeleportTruck(); DidTruckTeleport = false; task.wait(0.1)
                        if DoorHinge then
                            for i = 1, 10 do RS.Interaction.RemoteProxy:FireServer(DoorHinge) end
                        end
                        truckDone += 1; setProgTrucks(truckDone, truckCount)
                    end
                end

                -- Phase 2: retry any cargo that didn't reach TargetCFrame.
                -- FIX: Progress bar now only counts + shows the MISSED items still on
                -- the giver's plot, not the full teleportedParts list.
                task.wait(2) -- give task.spawns time to finish recording

                local MAX_TRIES = 25
                local attempt   = 0

                -- Helper: returns only items that are still far from their target
                -- AND are still on the giver's plot (i.e. not yet on receiver side).
                local function getMissed()
                    local missed = {}
                    for _, data in ipairs(teleportedParts) do
                        if data.Instance and data.Instance.Parent then
                            local dist = (data.Instance.Position - data.TargetCFrame.Position).Magnitude
                            if dist > 8 then
                                -- Only include if the part is still near the giver's plot origin
                                -- (within 500 studs, a generous threshold covering any plot size).
                                local distFromGiver = (data.Instance.Position - GiveBaseOrigin.Position).Magnitude
                                if distFromGiver < 500 then
                                    table.insert(missed, data)
                                end
                            end
                        end
                    end
                    return missed
                end

                local missedList = getMissed()

                if #missedList > 0 then
                    -- FIX: Show progress bar with ONLY the missed count, not cargoTotal
                    progTrucks.Visible = true
                    setProgTrucks(0, #missedList)
                    local missedTotal = #missedList  -- fixed denominator for Part 2

                    while #missedList > 0 and VH.butter.running and attempt < MAX_TRIES do
                        attempt += 1
                        setStatus(string.format("Cargo retry %d/%d — %d part(s) left...", attempt, MAX_TRIES, #missedList), true)

                        for _, data in ipairs(missedList) do
                            if not VH.butter.running then break end
                            local item = data.Instance

                            if not (item and item.Parent) then continue end

                            -- Warp directly to the item (it could be anywhere on the giver's plot)
                            local tries = 0
                            while (Char.HumanoidRootPart.Position - item.Position).Magnitude > 25 and tries < 15 do
                                Char.HumanoidRootPart.CFrame = item.CFrame
                                task.wait(0.1)
                                tries += 1
                            end

                            RS.Interaction.ClientIsDragging:FireServer(item.Parent)
                            task.wait(0.6)
                            item.CFrame = data.TargetCFrame
                            task.wait(0.2)
                        end

                        task.wait(1)
                        missedList = getMissed()

                        -- FIX: Progress counts how many of the ORIGINAL missed items are now done
                        local nowDone = missedTotal - #missedList
                        setProgTrucks(nowDone, missedTotal)
                    end

                    if #missedList == 0 then
                        setStatus("✓ All cargo teleported!", true)
                    else
                        setStatus(string.format("Gave up after %d tries — %d part(s) missed", MAX_TRIES, #missedList), false)
                    end

                    setProgTrucks(missedTotal, missedTotal)
                    task.wait(1)
                else
                    -- No missed cargo at all — mark trucks bar as fully complete
                    setProgTrucks(truckCount, truckCount)
                end
            end
        end

        -- ── SEND ITEM HELPER ──────────────────────────────────────────────────
        local function seekNetOwn(part)
            if not butterRunning then return end
            if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
            end
            for i = 1, 50 do task.wait(0.05); RS.Interaction.ClientIsDragging:FireServer(part.Parent) end
        end

        local function sendItem(part, Offset)
            if not butterRunning then return end
            if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
            end
            seekNetOwn(part)
            for i = 1, 200 do part.CFrame = Offset end
            task.wait(0.2)
        end

        -- ── PURCHASED ITEMS ───────────────────────────────────────────────────
        if getItems() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChild("PurchasedBoxItemName")
                    and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
            if total > 0 then
                progItems.Visible = true; setProgItems(0, total)
                setStatus("Sending purchased items...", true)
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name == "Owner" and tostring(v.Value) == giverName then
                            local p = v.Parent
                            if p:FindFirstChild("PurchasedBoxItemName") then
                                local part = p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (p:FindFirstChild("Main") and p.Main.CFrame) or p:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                sendItem(part, CFrame.new(nPos) * PCF.Rotation)
                                done += 1; setProgItems(done, total)
                            end
                        end
                    end
                end)
                setProgItems(total, total)
            end
        end

        -- ── GIF ITEMS ─────────────────────────────────────────────────────────
        if getGifs() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChildOfClass("Script") and p:FindFirstChild("DraggableItem")
                    and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
            if total > 0 then
                progGifs.Visible = true; setProgGifs(0, total)
                setStatus("Sending gif items...", true)
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name == "Owner" and tostring(v.Value) == giverName then
                            local p = v.Parent
                            if p:FindFirstChildOfClass("Script") and p:FindFirstChild("DraggableItem") then
                                local part = p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (p:FindFirstChild("Main") and p.Main.CFrame) or p:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                sendItem(part, CFrame.new(nPos) * PCF.Rotation)
                                done += 1; setProgGifs(done, total)
                            end
                        end
                    end
                end)
                setProgGifs(total, total)
            end
        end

        -- ── WOOD ──────────────────────────────────────────────────────────────
        if getWood() and butterRunning then
            local total = countItems(function(p)
                return p:FindFirstChild("TreeClass")
                    and (p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part"))
            end)
            if total > 0 then
                progWood.Visible = true; setProgWood(0, total)
                setStatus("Sending wood...", true)
                local done = 0
                pcall(function()
                    for _, v in pairs(workspace.PlayerModels:GetDescendants()) do
                        if not butterRunning then break end
                        if v.Name == "Owner" and tostring(v.Value) == giverName then
                            local p = v.Parent
                            if p:FindFirstChild("TreeClass") then
                                local part = p:FindFirstChild("Main") or p:FindFirstChildOfClass("Part")
                                if not part then continue end
                                local PCF  = (p:FindFirstChild("Main") and p.Main.CFrame) or p:FindFirstChildOfClass("Part").CFrame
                                local nPos = PCF.Position - GiveBaseOrigin.Position + ReceiverBaseOrigin.Position
                                if (Char.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
                                    Char.HumanoidRootPart.CFrame = part.CFrame; task.wait(0.1)
                                end
                                for i = 1, 50 do task.wait(0.05); RS.Interaction.ClientIsDragging:FireServer(part.Parent) end
                                for i = 1, 200 do part.CFrame = CFrame.new(nPos) * PCF.Rotation end
                                task.wait(0.2)
                                done += 1; setProgWood(done, total)
                            end
                        end
                    end
                end)
                setProgWood(total, total)
            end
        end

        if butterRunning then setStatus("✓ Done!", false) end
        butterRunning = false; VH.butter.running = false
        butterThread = nil; VH.butter.thread = nil
    end)
end)

-- Register cleanup with Vanilla1 so closing the hub stops any running dupe
table.insert(VH.cleanupTasks, function()
    butterRunning = false; VH.butter.running = false
    if butterThread then pcall(task.cancel, butterThread); butterThread = nil end
    VH.butter.thread = nil
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- WORLD TAB
-- ════════════════════════════════════════════════════════════════════════════════

local Lighting   = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- ── Snapshot original Lighting values ─────────────────────────────────────────
local origClockTime = Lighting.ClockTime
local origFogEnd    = Lighting.FogEnd
local origFogStart  = Lighting.FogStart
local origFogColor  = Lighting.FogColor
local origShadows   = Lighting.GlobalShadows

-- ── Shared connection handles ──────────────────────────────────────────────────
local dayConn   = nil
local nightConn = nil
local fogConn   = nil

local function stopDayNight()
    if dayConn   then dayConn:Disconnect();   dayConn   = nil end
    if nightConn then nightConn:Disconnect(); nightConn = nil end
end

-- ── ENVIRONMENT ───────────────────────────────────────────────────────────────
makeLabel(worldPage, "Environment")

-- Always Day
local _, _, alwaysDayTb, alwaysDayKnob = makeToggle(worldPage, "Always Day", false, function(v)
    if v then
        stopDayNight()
        Lighting.ClockTime = 14
        dayConn = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = 14
        end)
    else
        if dayConn then dayConn:Disconnect(); dayConn = nil end
        Lighting.ClockTime = origClockTime
    end
end)

-- Auto-enable Always Day 1 second after load
task.delay(1, function()
    stopDayNight()
    Lighting.ClockTime = 14
    dayConn = RunService.Heartbeat:Connect(function()
        Lighting.ClockTime = 14
    end)
    if alwaysDayTb and alwaysDayKnob then
        TweenService:Create(alwaysDayTb, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        }):Play()
        TweenService:Create(alwaysDayKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0, 18, 0.5, -7)
        }):Play()
    end
end)

-- Always Night (mutually exclusive with Always Day)
makeToggle(worldPage, "Always Night", false, function(v)
    if v then
        stopDayNight()
        Lighting.ClockTime = 0
        nightConn = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = 0
        end)
    else
        if nightConn then nightConn:Disconnect(); nightConn = nil end
        Lighting.ClockTime = origClockTime
    end
end)

-- Remove Fog — Heartbeat-enforced so the server can't reset it
makeToggle(worldPage, "Remove Fog", false, function(v)
    if fogConn then fogConn:Disconnect(); fogConn = nil end
    if v then
        Lighting.FogEnd   = 1e9
        Lighting.FogStart = 1e9
        fogConn = RunService.Heartbeat:Connect(function()
            Lighting.FogEnd   = 1e9
            Lighting.FogStart = 1e9
        end)
    else
        Lighting.FogEnd   = origFogEnd
        Lighting.FogStart = origFogStart
        Lighting.FogColor = origFogColor
    end
end)

-- Shadows
makeToggle(worldPage, "Shadows", true, function(v)
    Lighting.GlobalShadows = v
end)

-- ── WATER ─────────────────────────────────────────────────────────────────────
makeSep(worldPage)
makeLabel(worldPage, "Water")

local walkOnWaterConn  = nil
local walkOnWaterParts = {}

local function removeWalkWater()
    if walkOnWaterConn then walkOnWaterConn:Disconnect(); walkOnWaterConn = nil end
    for _, p in ipairs(walkOnWaterParts) do
        if p and p.Parent then p:Destroy() end
    end
    walkOnWaterParts = {}
end

makeToggle(worldPage, "Walk On Water", false, function(v)
    removeWalkWater()
    if v then
        local function makeSolid(part)
            if part:IsA("Part") and part.Name == "Water" then
                local clone = Instance.new("Part")
                clone.Size         = part.Size
                clone.CFrame       = part.CFrame
                clone.Anchored     = true
                clone.CanCollide   = true
                clone.Transparency = 1
                clone.Name         = "WalkWaterPlane"
                clone.Parent       = workspace
                table.insert(walkOnWaterParts, clone)
            end
        end
        for _, p in ipairs(workspace:GetDescendants()) do makeSolid(p) end
        walkOnWaterConn = workspace.DescendantAdded:Connect(makeSolid)
    end
end)

makeToggle(worldPage, "Remove Water", false, function(v)
    if _G.VH and _G.VH.setRemovedWater then _G.VH.setRemovedWater(v) end
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("Part") and p.Name == "Water" then
            p.Transparency = v and 1 or 0.5
            p.CanCollide   = false
        end
    end
end)

-- ── WORLD (reserved) ──────────────────────────────────────────────────────────
makeSep(worldPage)
makeLabel(worldPage, "World")
-- reserved for future features

-- ── Cleanup (World Tab) ────────────────────────────────────────────────────────
table.insert(VH.cleanupTasks, function()
    stopDayNight()
    if fogConn then fogConn:Disconnect(); fogConn = nil end
    removeWalkWater()
    Lighting.ClockTime     = origClockTime
    Lighting.FogEnd        = origFogEnd
    Lighting.FogStart      = origFogStart
    Lighting.FogColor      = origFogColor
    Lighting.GlobalShadows = origShadows
end)

-- ════════════════════════════════════════════════════════════════════════════════
print("[VanillaHub] Combined (Vanilla2 + WorldTab) loaded")

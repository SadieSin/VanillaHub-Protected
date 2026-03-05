-- ════════════════════════════════════════════════════
-- VANILLA2 — Butter Leak (injected into Dupe Tab)
-- Requires Vanilla1 (_G.VH) to be loaded first.
-- ════════════════════════════════════════════════════

if not _G.VH then
    warn("[VanillaHub] Vanilla2: _G.VH not found. Execute Vanilla1 first.")
    return
end

local VH             = _G.VH
local TweenService   = VH.TweenService
local Players        = VH.Players
local player         = VH.player
local BTN_COLOR      = VH.BTN_COLOR
local BTN_HOVER      = VH.BTN_HOVER
local THEME_TEXT     = VH.THEME_TEXT
local dupePage       = VH.pages["DupeTab"]

if not dupePage then
    warn("[VanillaHub] Vanilla2: DupeTab page not found.")
    return
end

-- ── HELPERS ───────────────────────────────────────────────────────────────────

local function makeLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -12, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(120, 120, 150)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = string.upper(text)
    Instance.new("UIPadding", lbl).PaddingLeft = UDim.new(0, 4)
    return lbl
end

local function makeSep(parent)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -12, 0, 1)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    f.BorderSizePixel = 0
    return f
end

local function makeBtn(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.BackgroundColor3 = color or BTN_COLOR
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = THEME_TEXT
    btn.Text = text
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

local function makeToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextColor3 = THEME_TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    local tb = Instance.new("TextButton", frame)
    tb.Size = UDim2.new(0, 34, 0, 18)
    tb.Position = UDim2.new(1, -44, 0.5, -9)
    tb.BackgroundColor3 = default and Color3.fromRGB(60, 180, 60) or BTN_COLOR
    tb.Text = ""; tb.BorderSizePixel = 0; tb.AutoButtonColor = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", tb)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, default and 18 or 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knob.BorderSizePixel = 0
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
    return frame, function() return toggled end
end

local function makeInput(parent, labelText, placeholder)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -12, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0, 110, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(160, 150, 170)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = labelText
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -125, 0, 22)
    box.Position = UDim2.new(0, 118, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45); box.BorderSizePixel = 0
    box.Font = Enum.Font.Gotham; box.TextSize = 12; box.TextColor3 = THEME_TEXT
    box.PlaceholderText = placeholder or "..."; box.PlaceholderColor3 = Color3.fromRGB(90, 85, 100)
    box.Text = ""; box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)
    return frame, box
end

local function makeProgressBar(parent, labelText)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, -12, 0, 44)
    wrap.BackgroundColor3 = Color3.fromRGB(18, 18, 24); wrap.BorderSizePixel = 0; wrap.Visible = false
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", wrap)
    stroke.Color = Color3.fromRGB(60, 60, 80); stroke.Thickness = 1; stroke.Transparency = 0.5
    local topRow = Instance.new("Frame", wrap)
    topRow.Size = UDim2.new(1, -12, 0, 18); topRow.Position = UDim2.new(0, 6, 0, 4); topRow.BackgroundTransparency = 1
    local nameLbl = Instance.new("TextLabel", topRow)
    nameLbl.Size = UDim2.new(0.6, 0, 1, 0); nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 11
    nameLbl.TextColor3 = THEME_TEXT; nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.Text = labelText
    local cntLbl = Instance.new("TextLabel", topRow)
    cntLbl.Size = UDim2.new(0.4, 0, 1, 0); cntLbl.Position = UDim2.new(0.6, 0, 0, 0); cntLbl.BackgroundTransparency = 1
    cntLbl.Font = Enum.Font.GothamBold; cntLbl.TextSize = 11
    cntLbl.TextColor3 = Color3.fromRGB(120, 200, 120); cntLbl.TextXAlignment = Enum.TextXAlignment.Right; cntLbl.Text = "0 / 0"
    local track = Instance.new("Frame", wrap)
    track.Size = UDim2.new(1, -12, 0, 10); track.Position = UDim2.new(0, 6, 0, 26)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 40); track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(80, 180, 100); fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local function setProgress(done, total)
        local pct = math.clamp(done / math.max(total, 1), 0, 1)
        cntLbl.Text = done .. " / " .. total
        TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
    end
    local function reset()
        fill.Size = UDim2.new(0, 0, 1, 0); cntLbl.Text = "0 / 0"; wrap.Visible = false
    end
    return wrap, setProgress, reset
end

-- ── STATUS BAR ────────────────────────────────────────────────────────────────
local statusBar = Instance.new("Frame", dupePage)
statusBar.Size = UDim2.new(1, -12, 0, 28)
statusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24); statusBar.BorderSizePixel = 0
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", statusBar).Color = Color3.fromRGB(50, 50, 70)

local statusDot = Instance.new("Frame", statusBar)
statusDot.Size = UDim2.new(0, 8, 0, 8); statusDot.Position = UDim2.new(0, 10, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 120); statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size = UDim2.new(1, -28, 1, 0); statusLbl.Position = UDim2.new(0, 26, 0, 0)
statusLbl.BackgroundTransparency = 1; statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 12
statusLbl.TextColor3 = Color3.fromRGB(160, 155, 175); statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "Ready"

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

local runBtn  = makeBtn(dupePage, "▶  Run Butter Dupe",  Color3.fromRGB(35, 65, 35),  function() end)
local stopBtn = makeBtn(dupePage, "■  Stop",              Color3.fromRGB(65, 25, 25),  function() end)

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
            return math.abs(r.X) <= boxSize.X/2
               and math.abs(r.Y) <= boxSize.Y/2 + 2
               and math.abs(r.Z) <= boxSize.Z/2
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

        -- ── TRUCKS + CARGO (25-attempt retry) ─────────────────────────────────
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

                        local tModel    = Char.Humanoid.SeatPart.Parent
                        local mCF, mSz  = tModel:GetBoundingBox()

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
                                            -- record where it actually landed after the attempt
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


                -- Phase 2: retry any cargo that didn't reach TargetCFrame, up to 25 times
                -- "Missed" = current position is more than 8 studs from where we wanted it
                -- We warp directly to each item (wherever it is) to grab it
                task.wait(2) -- give task.spawns time to finish recording

                local cargoTotal = #teleportedParts
                local cargoDone  = 0

                if cargoTotal > 0 then
                    progTrucks.Visible = true
                    setProgTrucks(0, cargoTotal)

                    local MAX_TRIES = 25
                    local attempt   = 0

                    local function getMissed()
                        local missed = {}
                        for _, data in ipairs(teleportedParts) do
                            if data.Instance and data.Instance.Parent then
                                local dist = (data.Instance.Position - data.TargetCFrame.Position).Magnitude
                                if dist > 8 then
                                    table.insert(missed, data)
                                end
                            end
                        end
                        return missed
                    end

                    local missedList = getMissed()

                    while #missedList > 0 and VH.butter.running and attempt < MAX_TRIES do
                        attempt += 1
                        setStatus(string.format("Cargo retry %d/%d — %d part(s) left...", attempt, MAX_TRIES, #missedList), true)

                        for _, data in ipairs(missedList) do
                            if not VH.butter.running then break end
                            local item = data.Instance
                            if not (item and item.Parent) then continue end

                            -- Warp directly to the item (it could be anywhere — giver OR receiver side)
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
                        cargoDone  = cargoTotal - #missedList
                        setProgTrucks(cargoDone, cargoTotal)
                    end

                    if #missedList == 0 then
                        setStatus("✓ All cargo teleported!", true)
                    else
                        setStatus(string.format("Gave up after %d tries — %d part(s) missed", MAX_TRIES, #missedList), false)
                    end

                    setProgTrucks(cargoTotal, cargoTotal)
                    task.wait(1)
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

print("[VanillaHub] Vanilla2 loaded — Butter Leak ready in Dupe tab")

-- ════════════════════════════════════════════════════
-- SINGLE TRUCK LOAD TELEPORT
-- ════════════════════════════════════════════════════
do
    local RunService_ST    = VH.RunService or game:GetService("RunService")
    local UIS_ST           = VH.UserInputService or game:GetService("UserInputService")
    local camera_ST        = workspace.CurrentCamera

    makeSep(dupePage)
    makeLabel(dupePage, "Single Truck Load Teleport")

    -- Giver / Receiver
    local _, stGiverBox    = makeInput(dupePage, "ST Giver",    "username")
    local _, stReceiverBox = makeInput(dupePage, "ST Receiver", "username")

    -- Status pill
    local stStatusBar = Instance.new("Frame", dupePage)
    stStatusBar.Size = UDim2.new(1,-12,0,26); stStatusBar.BackgroundColor3 = Color3.fromRGB(18,18,24); stStatusBar.BorderSizePixel = 0
    Instance.new("UICorner", stStatusBar).CornerRadius = UDim.new(0,6)
    local stDot = Instance.new("Frame", stStatusBar)
    stDot.Size = UDim2.new(0,8,0,8); stDot.Position = UDim2.new(0,10,0.5,-4)
    stDot.BackgroundColor3 = Color3.fromRGB(100,100,120); stDot.BorderSizePixel = 0
    Instance.new("UICorner", stDot).CornerRadius = UDim.new(1,0)
    local stStatusLbl = Instance.new("TextLabel", stStatusBar)
    stStatusLbl.Size = UDim2.new(1,-28,1,0); stStatusLbl.Position = UDim2.new(0,26,0,0)
    stStatusLbl.BackgroundTransparency = 1; stStatusLbl.Font = Enum.Font.Gotham; stStatusLbl.TextSize = 11
    stStatusLbl.TextColor3 = Color3.fromRGB(160,155,175); stStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
    stStatusLbl.Text = "Sit in a truck seat, then press Select"
    local function setSTStatus(msg, active)
        stStatusLbl.Text = msg
        TweenService:Create(stDot, TweenInfo.new(0.2), {
            BackgroundColor3 = active and Color3.fromRGB(80,200,100) or Color3.fromRGB(100,100,120)
        }):Play()
    end

    -- Grid size picker (‹ 4×4 ›)
    local gridSizes = {"1×1","2×1","2×2","3×2","3×3","4×3","4×4","5×4","5×5","6×5","6×6"}
    local gridCols  = {1,2,2,3,3,4,4,5,5,6,6}
    local gridRows  = {1,1,2,2,3,3,4,4,5,5,6}
    local gridIdx   = 7  -- default 4×4

    local gpRow = Instance.new("Frame", dupePage)
    gpRow.Size = UDim2.new(1,-12,0,32); gpRow.BackgroundColor3 = Color3.fromRGB(24,24,30); gpRow.BorderSizePixel = 0
    Instance.new("UICorner", gpRow).CornerRadius = UDim.new(0,6)
    local gpLabel = Instance.new("TextLabel", gpRow)
    gpLabel.Size = UDim2.new(0,80,1,0); gpLabel.Position = UDim2.new(0,10,0,0)
    gpLabel.BackgroundTransparency = 1; gpLabel.Font = Enum.Font.GothamSemibold; gpLabel.TextSize = 12
    gpLabel.TextColor3 = Color3.fromRGB(160,150,170); gpLabel.TextXAlignment = Enum.TextXAlignment.Left; gpLabel.Text = "Grid Size"
    local gpLeft = Instance.new("TextButton", gpRow)
    gpLeft.Size = UDim2.new(0,24,0,22); gpLeft.Position = UDim2.new(1,-90,0.5,-11)
    gpLeft.BackgroundColor3 = BTN_COLOR; gpLeft.BorderSizePixel = 0; gpLeft.Font = Enum.Font.GothamBold; gpLeft.TextSize = 14
    gpLeft.TextColor3 = THEME_TEXT; gpLeft.Text = "‹"; gpLeft.AutoButtonColor = false
    Instance.new("UICorner", gpLeft).CornerRadius = UDim.new(0,5)
    local gpVal = Instance.new("TextLabel", gpRow)
    gpVal.Size = UDim2.new(0,42,0,22); gpVal.Position = UDim2.new(1,-64,0.5,-11)
    gpVal.BackgroundColor3 = Color3.fromRGB(30,30,40); gpVal.BorderSizePixel = 0
    gpVal.Font = Enum.Font.GothamBold; gpVal.TextSize = 12; gpVal.TextColor3 = THEME_TEXT
    gpVal.TextXAlignment = Enum.TextXAlignment.Center; gpVal.Text = gridSizes[gridIdx]
    Instance.new("UICorner", gpVal).CornerRadius = UDim.new(0,4)
    local gpRight = Instance.new("TextButton", gpRow)
    gpRight.Size = UDim2.new(0,24,0,22); gpRight.Position = UDim2.new(1,-20,0.5,-11)
    gpRight.BackgroundColor3 = BTN_COLOR; gpRight.BorderSizePixel = 0; gpRight.Font = Enum.Font.GothamBold; gpRight.TextSize = 14
    gpRight.TextColor3 = THEME_TEXT; gpRight.Text = "›"; gpRight.AutoButtonColor = false
    Instance.new("UICorner", gpRight).CornerRadius = UDim.new(0,5)
    for _, b in {gpLeft, gpRight} do
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = BTN_HOVER}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = BTN_COLOR}):Play() end)
    end
    gpLeft.MouseButton1Click:Connect(function()
        gridIdx = math.max(1, gridIdx-1); gpVal.Text = gridSizes[gridIdx]
    end)
    gpRight.MouseButton1Click:Connect(function()
        gridIdx = math.min(#gridSizes, gridIdx+1); gpVal.Text = gridSizes[gridIdx]
    end)

    -- Truck spacing slider (10–60 studs)
    local slotSpacing = 20
    local spRow = Instance.new("Frame", dupePage)
    spRow.Size = UDim2.new(1,-12,0,32); spRow.BackgroundColor3 = Color3.fromRGB(24,24,30); spRow.BorderSizePixel = 0
    Instance.new("UICorner", spRow).CornerRadius = UDim.new(0,6)
    local spNameLbl = Instance.new("TextLabel", spRow)
    spNameLbl.Size = UDim2.new(0,110,1,0); spNameLbl.Position = UDim2.new(0,10,0,0)
    spNameLbl.BackgroundTransparency = 1; spNameLbl.Font = Enum.Font.GothamSemibold; spNameLbl.TextSize = 12
    spNameLbl.TextColor3 = Color3.fromRGB(160,150,170); spNameLbl.TextXAlignment = Enum.TextXAlignment.Left; spNameLbl.Text = "Truck Spacing"
    local spValLbl = Instance.new("TextLabel", spRow)
    spValLbl.Size = UDim2.new(0,40,1,0); spValLbl.Position = UDim2.new(1,-48,0,0)
    spValLbl.BackgroundTransparency = 1; spValLbl.Font = Enum.Font.GothamBold; spValLbl.TextSize = 12
    spValLbl.TextColor3 = THEME_TEXT; spValLbl.TextXAlignment = Enum.TextXAlignment.Center; spValLbl.Text = "20 st"
    local spTrack = Instance.new("Frame", spRow)
    spTrack.Size = UDim2.new(0,100,0,6); spTrack.Position = UDim2.new(0,124,0.5,-3)
    spTrack.BackgroundColor3 = Color3.fromRGB(40,40,55); spTrack.BorderSizePixel = 0
    Instance.new("UICorner", spTrack).CornerRadius = UDim.new(1,0)
    local spFill = Instance.new("Frame", spTrack)
    spFill.Size = UDim2.new(0.2,0,1,0); spFill.BackgroundColor3 = Color3.fromRGB(80,80,100); spFill.BorderSizePixel = 0
    Instance.new("UICorner", spFill).CornerRadius = UDim.new(1,0)
    local spKnob = Instance.new("TextButton", spTrack)
    spKnob.Size = UDim2.new(0,14,0,14); spKnob.AnchorPoint = Vector2.new(0.5,0.5); spKnob.Position = UDim2.new(0.2,0,0.5,0)
    spKnob.BackgroundColor3 = Color3.fromRGB(200,195,215); spKnob.Text = ""; spKnob.BorderSizePixel = 0; spKnob.AutoButtonColor = false
    Instance.new("UICorner", spKnob).CornerRadius = UDim.new(1,0)
    local spDrag = false
    local function updateSpacing(absX)
        local ratio = math.clamp((absX - spTrack.AbsolutePosition.X) / spTrack.AbsoluteSize.X, 0, 1)
        slotSpacing = math.round(10 + ratio*50)
        spFill.Size = UDim2.new(ratio,0,1,0); spKnob.Position = UDim2.new(ratio,0,0.5,0)
        spValLbl.Text = tostring(slotSpacing) .. " st"
    end
    spKnob.MouseButton1Down:Connect(function() spDrag = true end)
    spTrack.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then spDrag = true; updateSpacing(i.Position.X) end
    end)
    UIS_ST.InputChanged:Connect(function(i)
        if spDrag and i.UserInputType == Enum.UserInputType.MouseMovement then updateSpacing(i.Position.X) end
    end)
    UIS_ST.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then spDrag = false end
    end)

    -- Action buttons (Select | Place Preview | Clear)
    local stBtnRow = Instance.new("Frame", dupePage)
    stBtnRow.Size = UDim2.new(1,-12,0,34); stBtnRow.BackgroundTransparency = 1; stBtnRow.BorderSizePixel = 0
    local function makeRowBtn(txt, xScale, xOff, col, cb)
        local b = Instance.new("TextButton", stBtnRow)
        b.Size = UDim2.new(xScale,-4,1,0); b.Position = UDim2.new(xOff,2,0,0)
        b.BackgroundColor3 = col; b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamSemibold; b.TextSize = 12; b.TextColor3 = THEME_TEXT; b.Text = txt; b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = BTN_HOVER}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = col}):Play() end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local stSelectedTrucks = {}
    local stDropCFrame     = nil
    local stPreviewParts   = {}
    local stPlacing        = false
    local stRunning        = false
    local stThread         = nil
    local stPreviewConn    = nil
    local stClickConn      = nil

    local PREVIEW_SIZE  = Vector3.new(14, 1, 22)
    local PREVIEW_COL   = Color3.fromRGB(80, 160, 255)
    local PLACED_COL    = Color3.fromRGB(80, 220, 100)

    local function clearPreview()
        for _, p in ipairs(stPreviewParts) do if p and p.Parent then p:Destroy() end end
        stPreviewParts = {}
    end

    local function buildGrid(originCF, col)
        clearPreview()
        local cols = gridCols[gridIdx]; local rows = gridRows[gridIdx]
        for row = 0, rows-1 do
            for c = 0, cols-1 do
                local ox = (c - (cols-1)/2) * slotSpacing
                local oz = (row - (rows-1)/2) * slotSpacing
                local slotCF = originCF * CFrame.new(ox, 0, oz)
                local ghost = Instance.new("Part")
                ghost.Name="STPreview"; ghost.Size=PREVIEW_SIZE; ghost.Anchored=true
                ghost.CanCollide=false; ghost.Material=Enum.Material.Neon
                ghost.Color=col; ghost.Transparency=0.55; ghost.CFrame=slotCF; ghost.Parent=workspace
                local sel=Instance.new("SelectionBox"); sel.Adornee=ghost
                sel.Color3=col; sel.LineThickness=0.04; sel.SurfaceTransparency=1; sel.Parent=workspace
                table.insert(stPreviewParts, ghost); table.insert(stPreviewParts, sel)
            end
        end
    end

    local function getMouseGroundCF()
        local mouse = player:GetMouse()
        local ray = camera_ST:ScreenPointToRay(mouse.X, mouse.Y)
        local excl = {}
        for _, p in ipairs(stPreviewParts) do if p:IsA("BasePart") then table.insert(excl, p) end end
        local char = player.Character; if char then table.insert(excl, char) end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = excl
        local result = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
        if result then return CFrame.new(result.Position + Vector3.new(0,0.5,0)) end
        local t = (3 - ray.Origin.Y) / ray.Direction.Y
        if t > 0 then return CFrame.new(ray.Origin + ray.Direction * t) end
        return nil
    end

    local function stopPlacing()
        stPlacing = false
        if stPreviewConn then stPreviewConn:Disconnect(); stPreviewConn = nil end
    end

    -- SELECT button
    makeRowBtn("⊕ Select", 0.34, 0, Color3.fromRGB(30,50,30), function()
        local char = player.Character
        local hum  = char and char:FindFirstChild("Humanoid")
        if not hum or not hum.SeatPart then setSTStatus("⚠ Sit in a truck seat first!", false); return end
        local truck = hum.SeatPart.Parent
        if not truck:FindFirstChild("DriveSeat") then setSTStatus("⚠ Not a valid truck!", false); return end
        for _, t in ipairs(stSelectedTrucks) do
            if t == truck then setSTStatus("Already selected!", false); return end
        end
        local cap = gridCols[gridIdx] * gridRows[gridIdx]
        if #stSelectedTrucks >= cap then
            setSTStatus(string.format("⚠ Too many trucks! Max %d for %s — increase grid size", cap, gridSizes[gridIdx]), false); return
        end
        table.insert(stSelectedTrucks, truck)
        local hl = Instance.new("SelectionBox"); hl.Name="STHighlight"
        hl.Adornee=truck; hl.Color3=Color3.fromRGB(255,200,60); hl.LineThickness=0.06; hl.Parent=truck
        setSTStatus(string.format("%d truck(s) selected  (grid: %s)", #stSelectedTrucks, gridSizes[gridIdx]), true)
    end)

    -- PLACE PREVIEW button
    makeRowBtn("◎ Place", 0.33, 0.34, BTN_COLOR, function()
        if stPlacing then
            stopPlacing(); clearPreview(); stDropCFrame = nil
            setSTStatus("Preview cancelled", false)
        else
            stPlacing = true; stDropCFrame = nil
            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local origin = hrp and CFrame.new(hrp.Position) or CFrame.new(0,3,0)
            buildGrid(origin, PREVIEW_COL)
            setSTStatus("Move mouse → left-click to place grid", true)

            stPreviewConn = RunService_ST.RenderStepped:Connect(function()
                if not stPlacing then return end
                local cf = getMouseGroundCF()
                if cf then buildGrid(cf, PREVIEW_COL) end
            end)

            if stClickConn then stClickConn:Disconnect() end
            stClickConn = UIS_ST.InputBegan:Connect(function(input, gpe)
                if gpe or not stPlacing then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local cf = getMouseGroundCF()
                    if cf then
                        stDropCFrame = cf
                        stopPlacing()
                        -- Recolor to green = confirmed
                        for _, p in ipairs(stPreviewParts) do
                            if p:IsA("BasePart") then p.Color=PLACED_COL; p.Transparency=0.65
                            elseif p:IsA("SelectionBox") then p.Color3=PLACED_COL end
                        end
                        setSTStatus("Grid placed ✓  — select trucks then Teleport", false)
                    end
                end
            end)
        end
    end)

    -- CLEAR button
    makeRowBtn("✕ Clear", 0.33, 0.67, Color3.fromRGB(55,25,25), function()
        stopPlacing(); clearPreview(); stDropCFrame = nil
        for _, t in ipairs(stSelectedTrucks) do
            for _, c in ipairs(t:GetChildren()) do if c.Name=="STHighlight" then c:Destroy() end end
        end
        stSelectedTrucks = {}
        setSTStatus("Cleared — sit in seat & press Select", false)
    end)

    -- Progress bar
    local stProgBar, setStProg, resetStProg = makeProgressBar(dupePage, "Truck Load")

    -- TELEPORT button
    makeBtn(dupePage, "▶  Teleport Selected Trucks", Color3.fromRGB(30,60,30), function()
        if stRunning then setSTStatus("Already running!", true); return end
        if #stSelectedTrucks == 0 then setSTStatus("⚠ No trucks selected!", false); return end
        if not stDropCFrame then setSTStatus("⚠ Place the preview grid first!", false); return end
        local stGiver    = stGiverBox.Text
        local stReceiver = stReceiverBox.Text
        if stGiver=="" or stReceiver=="" then setSTStatus("⚠ Enter giver & receiver names!", false); return end

        stRunning = true; stProgBar.Visible = true
        setStProg(0, #stSelectedTrucks)
        setSTStatus("Finding bases...", true)

        stThread = task.spawn(function()
            local RS   = game:GetService("ReplicatedStorage")
            local LP   = Players.LocalPlayer
            local Char = LP.Character or LP.CharacterAdded:Wait()

            local GiveBaseOrigin, ReceiverBaseOrigin
            for _, v in pairs(workspace.Properties:GetDescendants()) do
                if v.Name=="Owner" then
                    local val = tostring(v.Value)
                    if val==stGiver    then GiveBaseOrigin    = v.Parent:FindFirstChild("OriginSquare") end
                    if val==stReceiver then ReceiverBaseOrigin = v.Parent:FindFirstChild("OriginSquare") end
                end
            end
            if not (GiveBaseOrigin and ReceiverBaseOrigin) then
                setSTStatus("⚠ Couldn't find bases!", false); stRunning=false; stThread=nil; return
            end

            local cols = gridCols[gridIdx]; local rows = gridRows[gridIdx]
            local totalTrucks = #stSelectedTrucks
            local done = 0

            -- Build slot CFrames
            local slots = {}
            for row = 0, rows-1 do
                for col = 0, cols-1 do
                    local ox = (col-(cols-1)/2)*slotSpacing
                    local oz = (row-(rows-1)/2)*slotSpacing
                    table.insert(slots, stDropCFrame * CFrame.new(ox,0,oz))
                end
            end

            local teleportedParts = {}
            local ignoredParts    = {}

            local function isPointInside(point, boxCF, boxSz)
                local r = boxCF:PointToObjectSpace(point)
                return math.abs(r.X)<=boxSz.X/2 and math.abs(r.Y)<=boxSz.Y/2+2 and math.abs(r.Z)<=boxSz.Z/2
            end

            -- Phase 1: teleport each truck to its slot
            for i, truckModel in ipairs(stSelectedTrucks) do
                if not stRunning then break end
                local slotCF = slots[i]; if not slotCF then break end
                setSTStatus(string.format("Teleporting truck %d / %d...", i, totalTrucks), true)

                local driveSeat = truckModel:FindFirstChild("DriveSeat")
                if not driveSeat then
                    done+=1; setStProg(done, totalTrucks); continue
                end

                driveSeat:Sit(Char.Humanoid)
                local w=0; repeat task.wait(0.1); w+=0.1 until Char.Humanoid.SeatPart or w>5
                if not Char.Humanoid.SeatPart then
                    done+=1; setStProg(done, totalTrucks); continue
                end

                local tModel = Char.Humanoid.SeatPart.Parent
                local mCF, mSz = tModel:GetBoundingBox()

                for _, p in ipairs(tModel:GetDescendants()) do if p:IsA("BasePart") then ignoredParts[p]=true end end
                for _, p in ipairs(Char:GetDescendants())  do if p:IsA("BasePart") then ignoredParts[p]=true end end

                -- Collect + teleport cargo
                local batch = {}
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not ignoredParts[part] then
                        if part.Name=="Main" or part.Name=="WoodSection" then
                            if part:FindFirstChild("Weld") and part.Weld.Part1.Parent~=part.Parent then continue end
                            task.spawn(function()
                                if isPointInside(part.Position, mCF, mSz) then
                                    -- Preserve relative offset from truck primary part
                                    local primary = tModel.PrimaryPart
                                    local localOffset = primary.CFrame:ToObjectSpace(part.CFrame)
                                    local tOff = slotCF:ToWorldSpace(localOffset)
                                    part.CFrame = tOff
                                    task.wait(0.3)
                                    table.insert(batch, {Instance=part, OldPos=part.Position, TargetCFrame=tOff})
                                end
                            end)
                        end
                    end
                end

                local SitPart = Char.Humanoid.SeatPart
                local DoorHinge = SitPart.Parent:FindFirstChild("PaintParts")
                    and SitPart.Parent.PaintParts:FindFirstChild("DoorLeft")
                    and SitPart.Parent.PaintParts.DoorLeft:FindFirstChild("ButtonRemote_Hinge")

                task.wait(0.1)
                Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.1)
                tModel:SetPrimaryPartCFrame(slotCF)
                task.wait(0.1)
                SitPart:Destroy()
                if DoorHinge then for j=1,10 do RS.Interaction.RemoteProxy:FireServer(DoorHinge) end end

                task.wait(0.6) -- let cargo spawns finish recording
                for _, cd in ipairs(batch) do table.insert(teleportedParts, cd) end

                done+=1; setStProg(done, totalTrucks)
            end

            -- Phase 2: retry missed cargo up to 25 times
            task.wait(1)
            local function getMissed()
                local m = {}
                for _, d in ipairs(teleportedParts) do
                    if d.Instance and d.Instance.Parent then
                        if (d.Instance.Position - d.TargetCFrame.Position).Magnitude > 8 then
                            table.insert(m, d)
                        end
                    end
                end
                return m
            end

            local cargoTotal = #teleportedParts
            if cargoTotal > 0 then
                setStProg(0, cargoTotal)
                local missed  = getMissed()
                local attempt = 0
                local MAX     = 25
                while #missed > 0 and stRunning and attempt < MAX do
                    attempt += 1
                    setSTStatus(string.format("Cargo retry %d/%d — %d left...", attempt, MAX, #missed), true)
                    for _, d in ipairs(missed) do
                        if not stRunning then break end
                        local item = d.Instance
                        if not (item and item.Parent) then continue end
                        local tries=0
                        while (Char.HumanoidRootPart.Position-item.Position).Magnitude>25 and tries<15 do
                            Char.HumanoidRootPart.CFrame=item.CFrame; task.wait(0.1); tries+=1
                        end
                        RS.Interaction.ClientIsDragging:FireServer(item.Parent)
                        task.wait(0.6); item.CFrame=d.TargetCFrame; task.wait(0.2)
                    end
                    task.wait(1); missed=getMissed()
                    setStProg(cargoTotal-#missed, cargoTotal)
                end
                setStProg(cargoTotal, cargoTotal)
                if #missed==0 then setSTStatus("✓ All done!", false)
                else setSTStatus(string.format("Gave up — %d cargo missed", #missed), false) end
            else
                setSTStatus("✓ Trucks teleported!", false)
            end

            -- Clean up highlights
            for _, t in ipairs(stSelectedTrucks) do
                for _, c in ipairs(t:GetChildren()) do if c.Name=="STHighlight" then c:Destroy() end end
            end
            -- Grey out preview
            for _, p in ipairs(stPreviewParts) do
                if p:IsA("BasePart") then p.Color=Color3.fromRGB(100,100,100); p.Transparency=0.82
                elseif p:IsA("SelectionBox") then p.Color3=Color3.fromRGB(100,100,100) end
            end

            stSelectedTrucks={}; stRunning=false; stThread=nil
        end)
    end)

    -- Cleanup on hub close
    table.insert(VH.cleanupTasks, function()
        stopPlacing(); clearPreview(); stRunning=false
        if stThread    then pcall(task.cancel, stThread);    stThread    = nil end
        if stClickConn then stClickConn:Disconnect();        stClickConn = nil end
    end)
end

-- ╔══════════════════════════════════════════════════╗
-- ║              VanillaHub  ·  Vanilla1             ║
-- ╚══════════════════════════════════════════════════╝

-- ── Cleanup previous instance ────────────────────────
if type(_G.VanillaHubCleanup) == "function" then
    pcall(_G.VanillaHubCleanup)
    _G.VanillaHubCleanup = nil
end
for _, n in pairs({"VanillaHub","VanillaHubWarning"}) do
    if game.CoreGui:FindFirstChild(n) then game.CoreGui[n]:Destroy() end
end
if _G.VH then
    if _G.VH.butter and _G.VH.butter.running then
        _G.VH.butter.running = false
        if _G.VH.butter.thread then pcall(task.cancel, _G.VH.butter.thread) end
        _G.VH.butter.thread = nil
    end
    _G.VH = nil
end
if workspace:FindFirstChild("VanillaHubTpCircle") then
    workspace.VanillaHubTpCircle:Destroy()
end

-- ── Game guard ────────────────────────────────────────
if game.PlaceId ~= 13822889 then
    task.spawn(function()
        task.wait(0.4)
        local wg = Instance.new("ScreenGui")
        wg.Name = "VanillaHubWarning"; wg.Parent = game.CoreGui; wg.ResetOnSpawn = false
        local f = Instance.new("Frame", wg)
        f.Size = UDim2.new(0,420,0,210); f.Position = UDim2.new(0.5,-210,0.5,-105)
        f.BackgroundColor3 = Color3.fromRGB(10,8,18); f.BackgroundTransparency = 0.18; f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)
        local fs = Instance.new("UIStroke", f); fs.Color = Color3.fromRGB(180,50,60); fs.Thickness = 1.4; fs.Transparency = 0.4
        local ic = Instance.new("TextLabel", f); ic.Size = UDim2.new(0,44,0,44); ic.Position = UDim2.new(0,22,0,22)
        ic.BackgroundTransparency = 1; ic.Font = Enum.Font.GothamBlack; ic.TextSize = 40
        ic.TextColor3 = Color3.fromRGB(255,80,90); ic.Text = "!"
        local mg = Instance.new("TextLabel", f); mg.Size = UDim2.new(1,-90,0,110); mg.Position = UDim2.new(0,78,0,28)
        mg.BackgroundTransparency = 1; mg.Font = Enum.Font.GothamSemibold; mg.TextSize = 14
        mg.TextColor3 = Color3.fromRGB(210,190,220); mg.TextXAlignment = Enum.TextXAlignment.Left
        mg.TextYAlignment = Enum.TextYAlignment.Top; mg.TextWrapped = true
        mg.Text = "VanillaHub only runs inside Lumber Tycoon 2.\n\nPlace ID: 13822889\n\nJoin that game and re-execute."
        local ob = Instance.new("TextButton", f); ob.Size = UDim2.new(0,150,0,44); ob.Position = UDim2.new(0.5,-75,1,-60)
        ob.BackgroundColor3 = Color3.fromRGB(180,45,55); ob.BorderSizePixel = 0
        ob.Font = Enum.Font.GothamBold; ob.TextSize = 16; ob.TextColor3 = Color3.fromRGB(255,255,255); ob.Text = "Got it"
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0,10)
        local TS2 = game:GetService("TweenService")
        f.BackgroundTransparency=1; mg.TextTransparency=1; ic.TextTransparency=1; ob.BackgroundTransparency=1; ob.TextTransparency=1
        TS2:Create(f,  TweenInfo.new(0.7,Enum.EasingStyle.Quint),{BackgroundTransparency=0.18}):Play()
        TS2:Create(mg, TweenInfo.new(0.8,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
        TS2:Create(ic, TweenInfo.new(0.8,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
        TS2:Create(ob, TweenInfo.new(0.9,Enum.EasingStyle.Quint),{BackgroundTransparency=0,TextTransparency=0}):Play()
        ob.MouseButton1Click:Connect(function()
            local t = TS2:Create(f,TweenInfo.new(0.7,Enum.EasingStyle.Quint),{BackgroundTransparency=1})
            t:Play(); TS2:Create(mg,TweenInfo.new(0.7),{TextTransparency=1}):Play()
            TS2:Create(ic,TweenInfo.new(0.7),{TextTransparency=1}):Play()
            TS2:Create(ob,TweenInfo.new(0.7),{BackgroundTransparency=1,TextTransparency=1}):Play()
            t.Completed:Connect(function() if wg and wg.Parent then wg:Destroy() end end)
        end)
    end)
    return
end

-- ════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TeleportService  = game:GetService("TeleportService")
local Stats            = game:GetService("Stats")
local player           = Players.LocalPlayer

-- ════════════════════════════════════════════════════
-- PALETTE  —  deep space + vanilla lavender
-- ════════════════════════════════════════════════════
local C = {
    BG_DEEP      = Color3.fromRGB(8,   7,  16),
    BG_PANEL     = Color3.fromRGB(10,   9,  20),
    BG_CONTENT   = Color3.fromRGB(12,  11,  23),
    BG_CARD      = Color3.fromRGB(19,  17,  34),
    BG_CARD2     = Color3.fromRGB(26,  22,  46),
    BG_TOPBAR    = Color3.fromRGB(9,    8,  18),

    ACCENT       = Color3.fromRGB(148, 98,  222),
    ACCENT2      = Color3.fromRGB(200, 148, 255),
    ACCENT_DIM   = Color3.fromRGB(72,  50,  118),
    GLOW         = Color3.fromRGB(108, 68,  188),

    TAB_ACTIVE   = Color3.fromRGB(36,  26,  60),
    TAB_IDLE     = Color3.fromRGB(13,  12,  25),
    TAB_HOVER    = Color3.fromRGB(22,  18,  40),

    TEXT_HI      = Color3.fromRGB(228, 208, 244),
    TEXT_MID     = Color3.fromRGB(162, 140, 188),
    TEXT_LOW     = Color3.fromRGB(88,  76,  114),
    TEXT_ACTIVE  = Color3.fromRGB(246, 228, 255),

    BTN          = Color3.fromRGB(26,  22,  46),
    BTN_H        = Color3.fromRGB(42,  34,  70),
    BTN_P        = Color3.fromRGB(58,  46,  90),
    BTN_DANGER   = Color3.fromRGB(96,  28,  38),
    BTN_DANGER_H = Color3.fromRGB(136, 42,  55),

    SEP          = Color3.fromRGB(24,  20,  44),
    SEP_BRIGHT   = Color3.fromRGB(50,  38,  84),

    GREEN        = Color3.fromRGB(78,  198, 118),
    YELLOW       = Color3.fromRGB(228, 184,  58),
    RED          = Color3.fromRGB(218,  72,  72),

    TOGGLE_ON    = Color3.fromRGB(106, 178, 255),
    SLIDER_FILL  = Color3.fromRGB(128,  82,  208),
}

-- ════════════════════════════════════════════════════
-- CLEANUP
-- ════════════════════════════════════════════════════
local cleanupTasks = {}

local function onExit()
    if _G.VH and _G.VH.butter then
        _G.VH.butter.running = false
        if _G.VH.butter.thread then pcall(task.cancel, _G.VH.butter.thread) end
        _G.VH.butter.thread = nil
    end
    for _, fn in ipairs(cleanupTasks) do pcall(fn) end
    cleanupTasks = {}
    pcall(function()
        local char = player and player.Character; if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand=false; hum.WalkSpeed=16; hum.JumpPower=50 end
        if hrp then
            for _, o in ipairs(hrp:GetChildren()) do
                if o:IsA("BodyVelocity") or o:IsA("BodyGyro") then pcall(function() o:Destroy() end) end
            end
        end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.CanCollide=true end) end
        end
    end)
    pcall(function()
        if workspace:FindFirstChild("VanillaHubTpCircle") then workspace.VanillaHubTpCircle:Destroy() end
    end)
    pcall(function()
        for _, o in ipairs(workspace:GetChildren()) do
            if o.Name=="WalkWaterPlane" then o:Destroy() end
        end
    end)
    _G.VH=nil; _G.VanillaHubCleanup=nil
end

-- ════════════════════════════════════════════════════
-- ROOT GUI
-- ════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name="VanillaHub"; gui.Parent=game.CoreGui; gui.ResetOnSpawn=false
table.insert(cleanupTasks, function() if gui and gui.Parent then gui:Destroy() end end)
_G.VanillaHubCleanup = onExit

local wrapper = Instance.new("Frame", gui)
wrapper.Name="Wrapper"; wrapper.Size=UDim2.new(0,0,0,0)
wrapper.Position=UDim2.new(0.5,-270,0.5,-175)
wrapper.BackgroundColor3=C.BG_DEEP; wrapper.BackgroundTransparency=1
wrapper.BorderSizePixel=0; wrapper.ClipsDescendants=false
Instance.new("UICorner",wrapper).CornerRadius=UDim.new(0,14)
local wStroke=Instance.new("UIStroke",wrapper)
wStroke.Color=C.GLOW; wStroke.Thickness=1.2; wStroke.Transparency=0.5

local main=Instance.new("Frame",wrapper)
main.Size=UDim2.new(1,0,1,0); main.BackgroundColor3=C.BG_DEEP
main.BackgroundTransparency=1; main.BorderSizePixel=0; main.ClipsDescendants=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)

TweenService:Create(wrapper,TweenInfo.new(0.62,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
    {Size=UDim2.new(0,540,0,360),BackgroundTransparency=0}):Play()
TweenService:Create(main,TweenInfo.new(0.62,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
    {BackgroundTransparency=0}):Play()

-- ── TOP BAR ──────────────────────────────────────────
local topBar=Instance.new("Frame",main)
topBar.Size=UDim2.new(1,0,0,40); topBar.BackgroundColor3=C.BG_TOPBAR
topBar.BorderSizePixel=0; topBar.ZIndex=4

local topBorder=Instance.new("Frame",topBar)
topBorder.Size=UDim2.new(1,0,0,1); topBorder.Position=UDim2.new(0,0,1,-1)
topBorder.BackgroundColor3=C.SEP_BRIGHT; topBorder.BorderSizePixel=0; topBorder.ZIndex=5

local hubIcon=Instance.new("ImageLabel",topBar)
hubIcon.Size=UDim2.new(0,24,0,24); hubIcon.Position=UDim2.new(0,10,0.5,-12)
hubIcon.BackgroundTransparency=1; hubIcon.ScaleType=Enum.ScaleType.Fit
hubIcon.Image="rbxassetid://97128823316544"; hubIcon.ZIndex=6
Instance.new("UICorner",hubIcon).CornerRadius=UDim.new(0,5)

local titleLbl=Instance.new("TextLabel",topBar)
titleLbl.Size=UDim2.new(0,100,1,0); titleLbl.Position=UDim2.new(0,40,0,0)
titleLbl.BackgroundTransparency=1; titleLbl.Font=Enum.Font.GothamBold; titleLbl.TextSize=16
titleLbl.TextColor3=C.TEXT_ACTIVE; titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=5
titleLbl.Text="VanillaHub"

local subTitleTop=Instance.new("TextLabel",topBar)
subTitleTop.Size=UDim2.new(0,130,1,0); subTitleTop.Position=UDim2.new(0,138,0,0)
subTitleTop.BackgroundTransparency=1; subTitleTop.Font=Enum.Font.Gotham; subTitleTop.TextSize=11
subTitleTop.TextColor3=C.ACCENT_DIM; subTitleTop.TextXAlignment=Enum.TextXAlignment.Left; subTitleTop.ZIndex=5
subTitleTop.Text="Lumber Tycoon 2"

local closeBtn=Instance.new("TextButton",topBar)
closeBtn.Size=UDim2.new(0,26,0,26); closeBtn.Position=UDim2.new(1,-34,0.5,-13)
closeBtn.BackgroundColor3=Color3.fromRGB(158,36,48); closeBtn.Text="×"
closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=17; closeBtn.TextColor3=Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel=0; closeBtn.ZIndex=5; closeBtn.AutoButtonColor=false
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(1,0)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(210,52,68)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(158,36,48)}):Play()
end)

-- ── CONFIRM CLOSE ─────────────────────────────────────
local function showConfirmClose()
    if main:FindFirstChild("ConfirmOverlay") then return end
    local ov=Instance.new("Frame",main); ov.Name="ConfirmOverlay"
    ov.Size=UDim2.new(1,0,1,0); ov.BackgroundColor3=Color3.fromRGB(0,0,0)
    ov.BackgroundTransparency=0.46; ov.ZIndex=9
    local dl=Instance.new("Frame",main); dl.Name="ConfirmDialog"
    dl.Size=UDim2.new(0,330,0,168); dl.Position=UDim2.new(0.5,-165,0.5,-84)
    dl.BackgroundColor3=C.BG_CARD2; dl.BorderSizePixel=0; dl.ZIndex=10
    Instance.new("UICorner",dl).CornerRadius=UDim.new(0,14)
    local ds=Instance.new("UIStroke",dl); ds.Color=C.GLOW; ds.Thickness=1.2; ds.Transparency=0.5
    local dt=Instance.new("TextLabel",dl); dt.Size=UDim2.new(1,0,0,36)
    dt.BackgroundTransparency=1; dt.Font=Enum.Font.GothamBold; dt.TextSize=17
    dt.TextColor3=C.TEXT_HI; dt.Text="Close VanillaHub?"; dt.ZIndex=11
    local dm=Instance.new("TextLabel",dl); dm.Size=UDim2.new(1,-24,0,52); dm.Position=UDim2.new(0,12,0,38)
    dm.BackgroundTransparency=1; dm.Font=Enum.Font.Gotham; dm.TextSize=13
    dm.TextColor3=C.TEXT_MID
    dm.Text="All active features will stop running.\nYou'll need to re-execute to use VanillaHub again."
    dm.TextWrapped=true; dm.TextYAlignment=Enum.TextYAlignment.Top; dm.ZIndex=11
    local function mkB(txt,bg,xOff)
        local b=Instance.new("TextButton",dl)
        b.Size=UDim2.new(0,136,0,38); b.Position=UDim2.new(0.5,xOff,1,-50)
        b.BackgroundColor3=bg; b.Text=txt; b.Font=Enum.Font.GothamSemibold
        b.TextSize=14; b.TextColor3=C.TEXT_HI; b.ZIndex=11; b.BorderSizePixel=0; b.AutoButtonColor=false
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
        return b
    end
    local canB=mkB("Cancel",C.BG_CARD,-142); local conB=mkB("Exit",Color3.fromRGB(150,32,44),6)
    for _,b in {canB,conB} do
        local base=b.BackgroundColor3
        local hi=b==conB and Color3.fromRGB(196,48,62) or C.BTN_H
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=hi}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=base}):Play() end)
    end
    canB.MouseButton1Click:Connect(function() ov:Destroy(); dl:Destroy() end)
    conB.MouseButton1Click:Connect(function()
        ov:Destroy(); dl:Destroy(); onExit()
        local t=TweenService:Create(wrapper,TweenInfo.new(0.44,Enum.EasingStyle.Back,Enum.EasingDirection.In),
            {Size=UDim2.new(0,0,0,0),BackgroundTransparency=1})
        t:Play(); t.Completed:Connect(function() if gui and gui.Parent then gui:Destroy() end end)
    end)
end
closeBtn.MouseButton1Click:Connect(showConfirmClose)

-- ── DRAG ──────────────────────────────────────────────
local dragging,dragStart,startPos=false,nil,nil
topBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; startPos=wrapper.Position end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dragStart
        wrapper.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

-- ════════════════════════════════════════════════════
-- SIDE PANEL
-- ════════════════════════════════════════════════════
local side=Instance.new("ScrollingFrame",main)
side.Size=UDim2.new(0,150,1,-40); side.Position=UDim2.new(0,0,0,40)
side.BackgroundColor3=C.BG_PANEL; side.BorderSizePixel=0
side.ScrollBarThickness=3; side.ScrollBarImageColor3=C.ACCENT_DIM
side.CanvasSize=UDim2.new(0,0,0,0)

local sideList=Instance.new("UIListLayout",side)
sideList.Padding=UDim.new(0,3)
sideList.HorizontalAlignment=Enum.HorizontalAlignment.Center
sideList.SortOrder=Enum.SortOrder.LayoutOrder
sideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    side.CanvasSize=UDim2.new(0,0,0,sideList.AbsoluteContentSize.Y+18)
end)

-- side right border
local sideBdr=Instance.new("Frame",main)
sideBdr.Size=UDim2.new(0,1,1,-40); sideBdr.Position=UDim2.new(0,150,0,40)
sideBdr.BackgroundColor3=C.SEP_BRIGHT; sideBdr.BorderSizePixel=0; sideBdr.ZIndex=3

-- Side section label
local function makeSideSection(txt)
    local f=Instance.new("Frame",side)
    f.Size=UDim2.new(0.88,0,0,20); f.BackgroundTransparency=1
    local line=Instance.new("Frame",f)
    line.Size=UDim2.new(1,-10,0,1); line.Position=UDim2.new(0,5,0.5,0)
    line.BackgroundColor3=C.SEP_BRIGHT; line.BorderSizePixel=0
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-8,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.Font=Enum.Font.GothamBold; l.TextSize=9
    l.TextColor3=C.ACCENT_DIM; l.TextXAlignment=Enum.TextXAlignment.Left
    l.BackgroundColor3=C.BG_PANEL
    l.Text=string.upper(txt)
end

-- top padding
local sp=Instance.new("Frame",side); sp.Size=UDim2.new(1,0,0,8); sp.BackgroundTransparency=1

-- ════════════════════════════════════════════════════
-- CONTENT AREA
-- ════════════════════════════════════════════════════
local content=Instance.new("Frame",main)
content.Size=UDim2.new(1,-151,1,-40); content.Position=UDim2.new(0,151,0,40)
content.BackgroundColor3=C.BG_CONTENT; content.BorderSizePixel=0

-- ════════════════════════════════════════════════════
-- SHARED UI BUILDERS
-- ════════════════════════════════════════════════════

-- Content section header with accent underline
local function makeHeader(parent, txt)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,28); row.BackgroundTransparency=1
    local sep=Instance.new("Frame",row)
    sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.new(0,0,1,-1)
    sep.BackgroundColor3=C.SEP_BRIGHT; sep.BorderSizePixel=0
    local pill=Instance.new("Frame",sep)
    pill.Size=UDim2.new(0,28,0,2); pill.Position=UDim2.new(0,0,-0.5,0)
    pill.BackgroundColor3=C.ACCENT; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-4,1,-4); lbl.Position=UDim2.new(0,4,0,2)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
    lbl.TextColor3=C.TEXT_LOW; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Text=string.upper(txt)
    return row
end

-- Hint strip
local function makeHint(parent, txt)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,24); f.BackgroundColor3=Color3.fromRGB(15,13,28); f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-14,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.Font=Enum.Font.Gotham; l.TextSize=11
    l.TextColor3=C.TEXT_LOW; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true
    l.Text=txt; return f
end

-- Action button
local function makeBtn(parent, txt, clr, callback)
    clr=clr or C.BTN
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(1,0,0,34); btn.BackgroundColor3=clr; btn.BorderSizePixel=0
    btn.Font=Enum.Font.GothamSemibold; btn.TextSize=13; btn.TextColor3=C.TEXT_HI
    btn.Text=txt; btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local hi=(clr==C.BTN_DANGER) and C.BTN_DANGER_H or C.BTN_H
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.13),{BackgroundColor3=hi}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.13),{BackgroundColor3=clr}):Play() end)
    btn.MouseButton1Down:Connect(function() TweenService:Create(btn,TweenInfo.new(0.07),{BackgroundColor3=C.BTN_P}):Play() end)
    btn.MouseButton1Up:Connect(function() TweenService:Create(btn,TweenInfo.new(0.13),{BackgroundColor3=hi}):Play() end)
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

-- Toggle
local function makeToggle(parent, label, sub, default, callback)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,sub~="" and 42 or 34); f.BackgroundColor3=C.BTN; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,-62,0,18); lbl.Position=UDim2.new(0,12,0,sub~="" and 6 or 8)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=13
    lbl.TextColor3=C.TEXT_HI; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    if sub~="" then
        local s=Instance.new("TextLabel",f)
        s.Size=UDim2.new(1,-62,0,14); s.Position=UDim2.new(0,12,0,25)
        s.BackgroundTransparency=1; s.Font=Enum.Font.Gotham; s.TextSize=11
        s.TextColor3=C.TEXT_LOW; s.TextXAlignment=Enum.TextXAlignment.Left; s.Text=sub
    end
    local track=Instance.new("TextButton",f)
    track.Size=UDim2.new(0,38,0,20); track.Position=UDim2.new(1,-50,0.5,-10)
    track.BackgroundColor3=default and C.TOGGLE_ON or C.SEP_BRIGHT
    track.Text=""; track.BorderSizePixel=0; track.AutoButtonColor=false
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,14,0,14); knob.Position=UDim2.new(0,default and 21 or 3,0.5,-7)
    knob.BackgroundColor3=Color3.fromRGB(238,228,255); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local tog=default
    if callback then callback(tog) end
    local function setV(v)
        tog=v
        TweenService:Create(track,TweenInfo.new(0.18,Enum.EasingStyle.Quint),
            {BackgroundColor3=v and C.TOGGLE_ON or C.SEP_BRIGHT}):Play()
        TweenService:Create(knob,TweenInfo.new(0.18,Enum.EasingStyle.Quint),
            {Position=UDim2.new(0,v and 21 or 3,0.5,-7)}):Play()
        if callback then callback(tog) end
    end
    track.MouseButton1Click:Connect(function() setV(not tog) end)
    return f, setV, function() return tog end
end

-- Slider
local function makeSlider(parent, label, minV, maxV, defV, onChange)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,58); f.BackgroundColor3=C.BTN; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(0.68,0,0,20); lbl.Position=UDim2.new(0,12,0,8)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=13
    lbl.TextColor3=C.TEXT_HI; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local vl=Instance.new("TextLabel",f)
    vl.Size=UDim2.new(0.32,-12,0,20); vl.Position=UDim2.new(0.68,0,0,8)
    vl.BackgroundTransparency=1; vl.Font=Enum.Font.GothamBold; vl.TextSize=13
    vl.TextColor3=C.ACCENT2; vl.TextXAlignment=Enum.TextXAlignment.Right
    vl.Text=tostring(defV)
    local trk=Instance.new("Frame",f)
    trk.Size=UDim2.new(1,-24,0,5); trk.Position=UDim2.new(0,12,0,40)
    trk.BackgroundColor3=C.SEP; trk.BorderSizePixel=0
    Instance.new("UICorner",trk).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",trk)
    fill.Size=UDim2.new((defV-minV)/(maxV-minV),0,1,0)
    fill.BackgroundColor3=C.SLIDER_FILL; fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("TextButton",trk)
    knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new((defV-minV)/(maxV-minV),0,0.5,0)
    knob.BackgroundColor3=Color3.fromRGB(218,198,255); knob.Text=""; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local drag=false
    local function upd(ax)
        local r=math.clamp((ax-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
        local v=math.round(minV+r*(maxV-minV))
        fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,0,0.5,0)
        vl.Text=tostring(v); if onChange then onChange(v) end
    end
    knob.MouseButton1Down:Connect(function() drag=true end)
    trk.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; upd(i.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    return f
end

-- Two-button row
local function makeButtonRow(parent, lTxt, rTxt, lClr, rClr, lCb, rCb)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,34); row.BackgroundTransparency=1
    local function mk(txt,clr,xOff,w)
        local b=Instance.new("TextButton",row)
        b.Size=UDim2.new(w,-4,1,0); b.Position=UDim2.new(xOff,4,0,0)
        b.BackgroundColor3=clr; b.BorderSizePixel=0; b.AutoButtonColor=false
        b.Font=Enum.Font.GothamSemibold; b.TextSize=12; b.TextColor3=C.TEXT_HI; b.Text=txt
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
        local hi=(clr==C.BTN_DANGER) and C.BTN_DANGER_H or C.BTN_H
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=hi}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=clr}):Play() end)
        return b
    end
    local lb=mk(lTxt,lClr or C.BTN,0,0.5)
    lb.Position=UDim2.new(0,0,0,0); lb.Size=UDim2.new(0.5,-4,1,0)
    local rb=mk(rTxt,rClr or C.BTN,0.5,0.5)
    rb.Position=UDim2.new(0.5,4,0,0); rb.Size=UDim2.new(0.5,-4,1,0)
    if lCb then lb.MouseButton1Click:Connect(lCb) end
    if rCb then rb.MouseButton1Click:Connect(rCb) end
    return row, lb, rb
end

-- Stat card
local function makeStatCard(parent, lbl, val, valClr)
    local f=Instance.new("Frame",parent)
    f.BackgroundColor3=C.BG_CARD; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    local ll=Instance.new("TextLabel",f)
    ll.Size=UDim2.new(1,-8,0,13); ll.Position=UDim2.new(0,8,0,7)
    ll.BackgroundTransparency=1; ll.Font=Enum.Font.Gotham; ll.TextSize=10
    ll.TextColor3=C.TEXT_LOW; ll.TextXAlignment=Enum.TextXAlignment.Left
    ll.Text=string.upper(lbl)
    local vl=Instance.new("TextLabel",f)
    vl.Size=UDim2.new(1,-8,0,20); vl.Position=UDim2.new(0,8,0,20)
    vl.BackgroundTransparency=1; vl.Font=Enum.Font.GothamBold; vl.TextSize=14
    vl.TextColor3=valClr or C.TEXT_HI; vl.TextXAlignment=Enum.TextXAlignment.Left
    vl.Text=val; return vl
end

-- ════════════════════════════════════════════════════
-- TABS
-- ════════════════════════════════════════════════════
local tabNames={"Home","Player","World","Teleport","Wood","Slot","Dupe","Item","Sorter","AutoBuy","Pixel Art","Build","Vehicle","Search","Settings"}
local pages={}

for _,name in ipairs(tabNames) do
    local pg=Instance.new("ScrollingFrame",content)
    pg.Name=name.."Tab"; pg.Size=UDim2.new(1,0,1,0)
    pg.BackgroundTransparency=1; pg.BorderSizePixel=0
    pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=C.ACCENT_DIM
    pg.Visible=false; pg.CanvasSize=UDim2.new(0,0,0,0)
    local list=Instance.new("UIListLayout",pg)
    list.Padding=UDim.new(0,7); list.HorizontalAlignment=Enum.HorizontalAlignment.Center
    list.SortOrder=Enum.SortOrder.LayoutOrder
    local pad=Instance.new("UIPadding",pg)
    pad.PaddingTop=UDim.new(0,14); pad.PaddingBottom=UDim.new(0,16)
    pad.PaddingLeft=UDim.new(0,12); pad.PaddingRight=UDim.new(0,12)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pg.CanvasSize=UDim2.new(0,0,0,list.AbsoluteContentSize.Y+40)
    end)
    pages[name.."Tab"]=pg
end

-- ── Tab switcher ──────────────────────────────────────
local activeTabBtn=nil
local function switchTab(target)
    for _,pg in pairs(pages) do pg.Visible=(pg.Name==target) end
    if activeTabBtn then
        TweenService:Create(activeTabBtn,TweenInfo.new(0.18),
            {BackgroundColor3=C.TAB_IDLE}):Play()
        local ind=activeTabBtn:FindFirstChild("Ind")
        if ind then TweenService:Create(ind,TweenInfo.new(0.18),{BackgroundTransparency=1}):Play() end
        local lbl=activeTabBtn:FindFirstChild("Lbl")
        if lbl then TweenService:Create(lbl,TweenInfo.new(0.18),{TextColor3=C.TEXT_LOW}):Play() end
    end
    local btn=side:FindFirstChild(target:gsub("Tab",""))
    if btn then
        activeTabBtn=btn
        TweenService:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=C.TAB_ACTIVE}):Play()
        local ind=btn:FindFirstChild("Ind")
        if ind then TweenService:Create(ind,TweenInfo.new(0.18),{BackgroundTransparency=0}):Play() end
        local lbl=btn:FindFirstChild("Lbl")
        if lbl then TweenService:Create(lbl,TweenInfo.new(0.18),{TextColor3=C.TEXT_ACTIVE}):Play() end
    end
end

-- Build side tab buttons
-- Section groupings
local sectionBefore={Player="Features",["Pixel Art"]="Tools",Search="Misc"}

for _, name in ipairs(tabNames) do
    if sectionBefore[name] then makeSideSection(sectionBefore[name]) end

    local btn=Instance.new("TextButton",side)
    btn.Name=name; btn.Size=UDim2.new(0.88,0,0,30)
    btn.BackgroundColor3=C.TAB_IDLE; btn.BorderSizePixel=0
    btn.Text=""; btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)

    -- Left indicator bar
    local ind=Instance.new("Frame",btn); ind.Name="Ind"
    ind.Size=UDim2.new(0,3,0.55,0); ind.Position=UDim2.new(0,4,0.225,0)
    ind.BackgroundColor3=C.ACCENT; ind.BorderSizePixel=0; ind.BackgroundTransparency=1
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)

    local lbl=Instance.new("TextLabel",btn); lbl.Name="Lbl"
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=12
    lbl.TextColor3=C.TEXT_LOW; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Text=name
    local lp=Instance.new("UIPadding",lbl); lp.PaddingLeft=UDim.new(0,16)

    btn.MouseEnter:Connect(function()
        if activeTabBtn~=btn then
            TweenService:Create(btn,TweenInfo.new(0.14),{BackgroundColor3=C.TAB_HOVER}):Play()
            TweenService:Create(lbl,TweenInfo.new(0.14),{TextColor3=C.TEXT_MID}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTabBtn~=btn then
            TweenService:Create(btn,TweenInfo.new(0.14),{BackgroundColor3=C.TAB_IDLE}):Play()
            TweenService:Create(lbl,TweenInfo.new(0.14),{TextColor3=C.TEXT_LOW}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        switchTab(name.."Tab")
        task.spawn(function()
            local rip=Instance.new("Frame",btn); rip.Size=UDim2.new(0,4,0,4)
            rip.Position=UDim2.new(0.5,-2,0.5,-2); rip.BackgroundColor3=C.ACCENT2
            rip.BackgroundTransparency=0.68; rip.BorderSizePixel=0; rip.ZIndex=4
            Instance.new("UICorner",rip).CornerRadius=UDim.new(1,0)
            TweenService:Create(rip,TweenInfo.new(0.32,Enum.EasingStyle.Quint),
                {Size=UDim2.new(0,110,0,110),Position=UDim2.new(0.5,-55,0.5,-55),BackgroundTransparency=1}):Play()
            task.wait(0.36); if rip and rip.Parent then rip:Destroy() end
        end)
    end)
end

switchTab("HomeTab")

-- ════════════════════════════════════════════════════
-- GUI TOGGLE
-- ════════════════════════════════════════════════════
local currentToggleKey=Enum.KeyCode.LeftAlt
local guiOpen=true; local isAnimatingGUI=false
local keybindButtonGUI

local function toggleGUI()
    if isAnimatingGUI then return end
    guiOpen=not guiOpen; isAnimatingGUI=true
    if guiOpen then
        main.Visible=true; main.Size=UDim2.new(0,0,0,0); main.BackgroundTransparency=1
        local t=TweenService:Create(main,TweenInfo.new(0.32,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {Size=UDim2.new(0,540,0,360),BackgroundTransparency=0})
        t:Play(); t.Completed:Connect(function() isAnimatingGUI=false end)
    else
        local t=TweenService:Create(main,TweenInfo.new(0.26,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size=UDim2.new(0,0,0,0),BackgroundTransparency=1})
        t:Play(); t.Completed:Connect(function() main.Visible=false; isAnimatingGUI=false end)
    end
end

-- ════════════════════════════════════════════════════
-- WELCOME TOAST  (slim — hub icon, no pfp)
-- ════════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.9)
    if not (gui and gui.Parent) then return end
    local toast=Instance.new("Frame",gui)
    toast.Size=UDim2.new(0,284,0,50)
    toast.Position=UDim2.new(0.5,-142,1,-76)
    toast.BackgroundColor3=C.BG_CARD2; toast.BackgroundTransparency=1; toast.BorderSizePixel=0
    Instance.new("UICorner",toast).CornerRadius=UDim.new(0,12)
    local ts=Instance.new("UIStroke",toast); ts.Color=C.GLOW; ts.Thickness=1.2; ts.Transparency=0.44
    -- icon
    local ic=Instance.new("ImageLabel",toast)
    ic.Size=UDim2.new(0,26,0,26); ic.Position=UDim2.new(0,12,0.5,-13)
    ic.BackgroundTransparency=1; ic.Image="rbxassetid://97128823316544"
    ic.ScaleType=Enum.ScaleType.Fit; ic.ImageTransparency=1
    Instance.new("UICorner",ic).CornerRadius=UDim.new(0,5)
    -- text block
    local t1=Instance.new("TextLabel",toast)
    t1.Size=UDim2.new(1,-50,0,16); t1.Position=UDim2.new(0,46,0,9)
    t1.BackgroundTransparency=1; t1.Font=Enum.Font.GothamBold; t1.TextSize=13
    t1.TextColor3=C.TEXT_ACTIVE; t1.TextXAlignment=Enum.TextXAlignment.Left
    t1.Text="Hey "..player.DisplayName..", welcome back ✨"; t1.TextTransparency=1
    local t2=Instance.new("TextLabel",toast)
    t2.Size=UDim2.new(1,-50,0,12); t2.Position=UDim2.new(0,46,0,27)
    t2.BackgroundTransparency=1; t2.Font=Enum.Font.Gotham; t2.TextSize=11
    t2.TextColor3=C.TEXT_LOW; t2.TextXAlignment=Enum.TextXAlignment.Left
    t2.Text="VanillaHub loaded and ready."; t2.TextTransparency=1
    TweenService:Create(toast,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{BackgroundTransparency=0.14}):Play()
    TweenService:Create(ic,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{ImageTransparency=0}):Play()
    TweenService:Create(t1,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
    TweenService:Create(t2,TweenInfo.new(0.62,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
    task.delay(5, function()
        if not (toast and toast.Parent) then return end
        local ot=TweenService:Create(toast,TweenInfo.new(0.9,Enum.EasingStyle.Quint),{BackgroundTransparency=1})
        ot:Play()
        TweenService:Create(ic,TweenInfo.new(0.9),{ImageTransparency=1}):Play()
        TweenService:Create(t1,TweenInfo.new(0.9),{TextTransparency=1}):Play()
        TweenService:Create(t2,TweenInfo.new(0.9),{TextTransparency=1}):Play()
        ot.Completed:Connect(function() if toast and toast.Parent then toast:Destroy() end end)
    end)
end)

-- ════════════════════════════════════════════════════
-- HOME TAB
-- ════════════════════════════════════════════════════
local homePage=pages["HomeTab"]
makeHeader(homePage,"Overview")

local sg=Instance.new("Frame",homePage)
sg.Size=UDim2.new(1,0,0,108); sg.BackgroundTransparency=1
local gl=Instance.new("UIGridLayout",sg)
gl.CellSize=UDim2.new(0,150,0,46); gl.CellPadding=UDim2.new(0,8,0,8)
gl.HorizontalAlignment=Enum.HorizontalAlignment.Left; gl.SortOrder=Enum.SortOrder.LayoutOrder

local pingVal=makeStatCard(sg,"Ping","...",C.GREEN)
makeStatCard(sg,"Account Age",player.AccountAge.." days",C.TEXT_MID)
makeStatCard(sg,"Place ID",tostring(game.PlaceId),C.TEXT_LOW)
makeStatCard(sg,"Status","Active",C.GREEN)

local pingConn=RunService.Heartbeat:Connect(function()
    local ok,v=pcall(function() return math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if ok then
        pingVal.Text=v.." ms"
        pingVal.TextColor3=v<100 and C.GREEN or v<200 and C.YELLOW or C.RED
    else pingVal.Text="N/A" end
end)
table.insert(cleanupTasks,function() if pingConn then pingConn:Disconnect() end end)

makeHeader(homePage,"Quick Actions")
makeBtn(homePage,"Rejoin Server",nil,function()
    pcall(function() TeleportService:Teleport(game.PlaceId,player) end)
end)

-- ════════════════════════════════════════════════════
-- PLAYER TAB
-- ════════════════════════════════════════════════════
local playerPage=pages["PlayerTab"]

local savedWS=16; local savedJP=50
local statHB=RunService.Heartbeat:Connect(function()
    local char=player.Character; if not char then return end
    local hum=char:FindFirstChild("Humanoid"); if not hum then return end
    if hum.WalkSpeed~=savedWS then hum.WalkSpeed=savedWS end
    if hum.JumpPower~=savedJP  then hum.JumpPower=savedJP  end
end)
table.insert(cleanupTasks,function()
    if statHB then statHB:Disconnect() end
    local char=player.Character
    if char then local h=char:FindFirstChild("Humanoid")
        if h then h.WalkSpeed=16; h.JumpPower=50 end end
end)

makeHeader(playerPage,"Movement")
makeSlider(playerPage,"Walk Speed",16,150,16,function(v)
    savedWS=v; local c=player.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=v end end)
makeSlider(playerPage,"Jump Power",50,300,50,function(v)
    savedJP=v; local c=player.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.JumpPower=v end end)

local flySpeed=100
makeSlider(playerPage,"Fly Speed",50,600,100,function(v) flySpeed=v end)

-- Fly key row
local fkRow=Instance.new("Frame",playerPage)
fkRow.Size=UDim2.new(1,0,0,34); fkRow.BackgroundColor3=C.BTN; fkRow.BorderSizePixel=0
Instance.new("UICorner",fkRow).CornerRadius=UDim.new(0,8)
local fkLbl=Instance.new("TextLabel",fkRow)
fkLbl.Size=UDim2.new(1,-72,1,0); fkLbl.Position=UDim2.new(0,12,0,0)
fkLbl.BackgroundTransparency=1; fkLbl.Font=Enum.Font.GothamSemibold; fkLbl.TextSize=13
fkLbl.TextColor3=C.TEXT_HI; fkLbl.TextXAlignment=Enum.TextXAlignment.Left; fkLbl.Text="Fly Toggle Key"
local currentFlyKey=Enum.KeyCode.Q
local flyKeyBtn=Instance.new("TextButton",fkRow)
flyKeyBtn.Size=UDim2.new(0,52,0,22); flyKeyBtn.Position=UDim2.new(1,-62,0.5,-11)
flyKeyBtn.BackgroundColor3=C.BG_CARD2; flyKeyBtn.Font=Enum.Font.GothamBold
flyKeyBtn.TextSize=12; flyKeyBtn.TextColor3=C.ACCENT2; flyKeyBtn.Text="Q"
flyKeyBtn.BorderSizePixel=0; flyKeyBtn.AutoButtonColor=false
Instance.new("UICorner",flyKeyBtn).CornerRadius=UDim.new(0,6)
flyKeyBtn.MouseButton1Click:Connect(function()
    if _G.VH and _G.VH.waitingForFlyKey then return end
    if _G.VH then _G.VH.waitingForFlyKey=true end
    flyKeyBtn.Text="..."; flyKeyBtn.BackgroundColor3=Color3.fromRGB(46,80,46)
end)

makeHint(playerPage,"Press your Fly Key (default Q) to toggle fly.")

local isFlyEnabled=false; local flyBV,flyBG,flyConn

local function stopFly()
    isFlyEnabled=false
    if _G.VH then _G.VH.isFlyEnabled=false end
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV=nil end
    if flyBG and flyBG.Parent then flyBG:Destroy(); flyBG=nil end
    local char=player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand=false end
end

local function startFly()
    stopFly(); isFlyEnabled=true
    if _G.VH then _G.VH.isFlyEnabled=true end
    local char=player.Character; if not char then isFlyEnabled=false; return end
    local root=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChild("Humanoid")
    if not root or not hum then isFlyEnabled=false; return end
    hum.PlatformStand=true
    flyBV=Instance.new("BodyVelocity",root)
    flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Velocity=Vector3.zero
    flyBG=Instance.new("BodyGyro",root)
    flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1e4; flyBG.D=100
    flyConn=RunService.Heartbeat:Connect(function()
        if not (flyBV and flyBV.Parent and flyBG and flyBG.Parent) then return end
        local c2=player.Character; local h2=c2 and c2:FindFirstChild("Humanoid")
        local r2=c2 and c2:FindFirstChild("HumanoidRootPart"); if not(h2 and r2) then return end
        local cf=workspace.CurrentCamera.CFrame; local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
        h2.PlatformStand=true
        flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
        flyBV.Velocity=dir.Magnitude>0 and dir.Unit*flySpeed or Vector3.zero
        flyBG.CFrame=cf
    end)
end
table.insert(cleanupTasks,stopFly)

makeHeader(playerPage,"Abilities")

local noclipEnabled=false; local noclipConn
makeToggle(playerPage,"Noclip","Walk through walls and objects",false,function(v)
    noclipEnabled=v
    if v then
        noclipConn=RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            local char=player.Character; if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
        local char=player.Character
        if char then for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)
table.insert(cleanupTasks,function()
    noclipEnabled=false; if noclipConn then noclipConn:Disconnect(); noclipConn=nil end end)

local infJumpEnabled=false; local infJumpConn
makeToggle(playerPage,"Infinite Jump","Jump again while airborne",false,function(v)
    infJumpEnabled=v
    if v then
        infJumpConn=UserInputService.JumpRequest:Connect(function()
            if not infJumpEnabled then return end
            local c=player.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else if infJumpConn then infJumpConn:Disconnect(); infJumpConn=nil end end
end)
table.insert(cleanupTasks,function()
    infJumpEnabled=false; if infJumpConn then infJumpConn:Disconnect(); infJumpConn=nil end end)

-- ════════════════════════════════════════════════════
-- TELEPORT TAB
-- ════════════════════════════════════════════════════
local teleportPage=pages["TeleportTab"]
makeHeader(teleportPage,"Locations")
makeHint(teleportPage,"Click any location to teleport there instantly.")

local locations={
    {name="Spawn",              x=172,      y=3,       z=74},
    {name="The Den",            x=323,      y=41.8,    z=1930},
    {name="Lighthouse",         x=1464.8,   y=355.25,  z=3257.2},
    {name="Safari",             x=111.85,   y=11,      z=-998.8},
    {name="Bridge",             x=112.31,   y=11,      z=-782.36},
    {name="Bob's Shack",        x=260,      y=8.4,     z=-2542},
    {name="End Times Cave",     x=113,      y=-213,    z=-951},
    {name="The Swamp",          x=-1209,    y=132.32,  z=-801},
    {name="The Cabin",          x=1244,     y=63.6,    z=2306},
    {name="Volcano",            x=-1585,    y=622.8,   z=1140},
    {name="Boxed Cars",         x=509,      y=3.2,     z=-1463},
    {name="Taiga Peak",         x=1560,     y=410.32,  z=3274},
    {name="Land Store",         x=258,      y=3.2,     z=-99},
    {name="Link's Logic",       x=4605,     y=3,       z=-727},
    {name="Palm Island",        x=2549,     y=-5.9,    z=-42},
    {name="Palm Island 2",      x=1960,     y=-5.9,    z=-1501},
    {name="Palm Island 3",      x=4344,     y=-5.9,    z=-1813},
    {name="Fine Art Shop",      x=5207,     y=-166.2,  z=719},
    {name="SnowGlow Biome",     x=-1086.85, y=-5.9,    z=-945.32},
    {name="Cave",               x=3581,     y=-179.54, z=430},
    {name="Shrine of Sight",    x=-1600,    y=195.4,   z=919},
    {name="Fancy Furnishings",  x=491,      y=3.2,     z=-1720},
    {name="Docks",              x=1114,     y=-1.2,    z=-197},
    {name="Strange Man",        x=1061,     y=16.8,    z=1131},
    {name="Wood Drop-Off",      x=323.41,   y=-2.8,    z=134.73},
    {name="Snow Biome",         x=889.96,   y=59.8,    z=1195.55},
    {name="Wood R Us",          x=265,      y=3.2,     z=57},
    {name="Green Box",          x=-1668.05, y=349.6,   z=1475.39},
    {name="Cherry Meadow",      x=220.9,    y=59.8,    z=1305.8},
    {name="Bird Cave",          x=4813.1,   y=17.7,    z=-978.8},
}

for _,loc in ipairs(locations) do
    makeBtn(teleportPage,loc.name,nil,function()
        local char=player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame=CFrame.new(loc.x,loc.y+3,loc.z) end
    end)
end

-- ════════════════════════════════════════════════════
-- ITEM TAB
-- ════════════════════════════════════════════════════
local itemPage=pages["ItemTab"]

local clickSelection=false; local lassoTool=false; local groupSelection=false
local selectedItems={}; local tpCircle=nil
local isItemTeleporting=false
local tpProgressContainer,tpProgressFill,tpProgressLabel

local function getOwner(model)
    local ov=model:FindFirstChild("Owner")
    if ov then
        if ov:IsA("ObjectValue") then return ov.Value
        elseif ov:IsA("StringValue") then return ov.Value end
    end
end
local function getItemCat(model)
    local iv=model:FindFirstChild("ItemName")
    if iv and iv:IsA("StringValue") then return iv.Value end
    return model.Name
end
local staticNames={
    Map=1,Terrain=1,Camera=1,Baseplate=1,Base=1,Ground=1,Land=1,Island=1,Water=1,
    Tree=1,Palm=1,Bush=1,Rock=1,Stump=1,Branch=1,Log=1,PalmTree=1,CypressTree=1,
    SpruceTree=1,ElmTree=1,ChestnutTree=1,CherryTree=1,OakTree=1,BirchTree=1,
    Fence=1,Road=1,Path=1,River=1,Cliff=1,Hill=1,Bridge=1,
}
local function isMoveableItem(model)
    local mp=model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    if not mp or model==workspace or staticNames[model.Name] then return false end
    return model:FindFirstChild("Owner")~=nil or model:FindFirstChild("ItemName")~=nil
end
local function highlightModel(model)
    if selectedItems[model] then return end
    local hl=Instance.new("SelectionBox"); hl.Color3=C.ACCENT2
    hl.LineThickness=0.05; hl.Adornee=model; hl.Parent=model
    selectedItems[model]=hl
end
local function unhighlightModel(model)
    if selectedItems[model] then selectedItems[model]:Destroy(); selectedItems[model]=nil end
end
local function unhighlightAll()
    for m,h in pairs(selectedItems) do if h and h.Parent then h:Destroy() end end
    selectedItems={}
end
local function handleSelection(target,force)
    if not target then return end
    local model=target:FindFirstAncestorOfClass("Model")
    if not(model and isMoveableItem(model)) then return end
    if groupSelection then
        local ov=getOwner(model); local cat=getItemCat(model)
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and isMoveableItem(obj) and getItemCat(obj)==cat then
                local oo=getOwner(obj)
                if ov==nil or oo==nil or tostring(ov)==tostring(oo) then highlightModel(obj) end
            end
        end
    else
        if force then highlightModel(model)
        elseif selectedItems[model] then unhighlightModel(model)
        else highlightModel(model) end
    end
end
table.insert(cleanupTasks,function()
    if tpCircle and tpCircle.Parent then tpCircle:Destroy(); tpCircle=nil end
    unhighlightAll()
end)

makeHeader(itemPage,"Selection Mode")
makeToggle(itemPage,"Click Selection","Click items in-world to select them",false,function(v)
    clickSelection=v; if v then lassoTool=false end end)
makeToggle(itemPage,"Lasso Tool","Drag a box over items to select them",false,function(v)
    lassoTool=v; if v then clickSelection=false end end)
makeToggle(itemPage,"Group Selection","Select all matching item types at once",false,function(v)
    groupSelection=v end)

makeHeader(itemPage,"Destination")
makeHint(itemPage,"Sets a target marker at your position. Items will move here.")
makeButtonRow(itemPage,
    "Set Destination","Clear Destination",
    C.BTN,C.BTN_DANGER,
    function()
        if tpCircle then tpCircle:Destroy() end
        tpCircle=Instance.new("Part"); tpCircle.Name="VanillaHubTpCircle"
        tpCircle.Shape=Enum.PartType.Ball; tpCircle.Size=Vector3.new(3,3,3)
        tpCircle.Material=Enum.Material.Neon; tpCircle.Color=C.ACCENT
        tpCircle.Anchored=true; tpCircle.CanCollide=false
        local char=player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            tpCircle.Position=char.HumanoidRootPart.Position end
        tpCircle.Parent=workspace
    end,
    function() if tpCircle then tpCircle:Destroy(); tpCircle=nil end end
)

makeHeader(itemPage,"Actions")
makeBtn(itemPage,"Teleport Selected Items to Destination",nil,function()
    if not tpCircle or isItemTeleporting then return end
    isItemTeleporting=true
    task.spawn(function()
        local queue={}
        for m in pairs(selectedItems) do if m and m.Parent then table.insert(queue,m) end end
        local total=#queue; local done=0
        if tpProgressContainer then
            tpProgressContainer.Visible=true
            tpProgressFill.Size=UDim2.new(0,0,1,0)
            tpProgressLabel.Text="Teleporting  0 / "..total
        end
        for _,model in ipairs(queue) do
            if not isItemTeleporting then break end
            if not(model and model.Parent) then done=done+1; continue end
            local mp=model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
            if not mp then done=done+1; continue end
            local char=player.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then done=done+1; continue end
            hrp.CFrame=mp.CFrame*CFrame.new(0,4,2); task.wait(0.12)
            local dragger=game.ReplicatedStorage:FindFirstChild("Interaction")
                and game.ReplicatedStorage.Interaction:FindFirstChild("ClientIsDragging")
            if dragger then dragger:FireServer(model) end; task.wait(0.08)
            if mp and mp.Parent then mp.CFrame=tpCircle.CFrame end; task.wait(0.08)
            if dragger then dragger:FireServer(model) end; task.wait(0.22)
            local hl=selectedItems[model]
            if hl and hl.Parent then hl:Destroy() end; selectedItems[model]=nil
            done=done+1
            if tpProgressContainer and tpProgressContainer.Visible then
                TweenService:Create(tpProgressFill,TweenInfo.new(0.15,Enum.EasingStyle.Quad),
                    {Size=UDim2.new(done/math.max(total,1),0,1,0)}):Play()
                tpProgressLabel.Text="Teleporting  "..done.." / "..total
            end
        end
        isItemTeleporting=false
        if tpProgressContainer and tpProgressContainer.Visible then
            TweenService:Create(tpProgressFill,TweenInfo.new(0.2),{Size=UDim2.new(1,0,1,0)}):Play()
            tpProgressLabel.Text="Done  —  "..done.."/"..total.." moved"
            task.delay(2.2,function()
                if not tpProgressContainer then return end
                TweenService:Create(tpProgressContainer,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
                TweenService:Create(tpProgressFill,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
                TweenService:Create(tpProgressLabel,TweenInfo.new(0.4),{TextTransparency=1}):Play()
                task.delay(0.45,function()
                    if not tpProgressContainer then return end
                    tpProgressContainer.Visible=false
                    tpProgressContainer.BackgroundTransparency=0
                    tpProgressFill.BackgroundTransparency=0
                    tpProgressLabel.TextTransparency=0
                end)
            end)
        end
    end)
end)

makeButtonRow(itemPage,
    "Stop Teleport","Clear Selection",
    C.BTN_DANGER,C.BTN,
    function() isItemTeleporting=false end,
    function() unhighlightAll() end
)

-- Progress bar
do
    local pb=Instance.new("Frame",itemPage)
    pb.Size=UDim2.new(1,0,0,48); pb.BackgroundColor3=C.BG_CARD
    pb.BorderSizePixel=0; pb.Visible=false
    Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8)
    local pbs=Instance.new("UIStroke",pb); pbs.Color=C.GLOW; pbs.Thickness=1; pbs.Transparency=0.5
    local pbl=Instance.new("TextLabel",pb)
    pbl.Size=UDim2.new(1,-12,0,16); pbl.Position=UDim2.new(0,10,0,5)
    pbl.BackgroundTransparency=1; pbl.Font=Enum.Font.GothamSemibold; pbl.TextSize=11
    pbl.TextColor3=C.TEXT_MID; pbl.TextXAlignment=Enum.TextXAlignment.Left; pbl.Text="Teleporting..."
    local pbt=Instance.new("Frame",pb)
    pbt.Size=UDim2.new(1,-20,0,8); pbt.Position=UDim2.new(0,10,0,30)
    pbt.BackgroundColor3=C.SEP; pbt.BorderSizePixel=0
    Instance.new("UICorner",pbt).CornerRadius=UDim.new(1,0)
    local pbf=Instance.new("Frame",pbt)
    pbf.Size=UDim2.new(0,0,1,0); pbf.BackgroundColor3=C.ACCENT; pbf.BorderSizePixel=0
    Instance.new("UICorner",pbf).CornerRadius=UDim.new(1,0)
    tpProgressContainer=pb; tpProgressFill=pbf; tpProgressLabel=pbl
end

-- Lasso overlay
local lassoFrame=Instance.new("Frame",gui)
lassoFrame.Name="LassoRect"; lassoFrame.BackgroundColor3=C.ACCENT
lassoFrame.BackgroundTransparency=0.88; lassoFrame.BorderSizePixel=0
lassoFrame.Visible=false; lassoFrame.ZIndex=20
local ls=Instance.new("UIStroke",lassoFrame); ls.Color=C.ACCENT2; ls.Thickness=1.4; ls.Transparency=0

local lassoStart=nil
local function updLasso(s,c)
    local mx=math.min(s.X,c.X); local my=math.min(s.Y,c.Y)
    lassoFrame.Position=UDim2.new(0,mx,0,my)
    lassoFrame.Size=UDim2.new(0,math.abs(c.X-s.X),0,math.abs(c.Y-s.Y))
end
local cam=workspace.CurrentCamera
local function selectInLasso()
    if not lassoStart then return end
    local cur=Vector2.new(player:GetMouse().X,player:GetMouse().Y)
    local mnX=math.min(lassoStart.X,cur.X); local mxX=math.max(lassoStart.X,cur.X)
    local mnY=math.min(lassoStart.Y,cur.Y); local mxY=math.max(lassoStart.Y,cur.Y)
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and isMoveableItem(obj) then
            local mp=obj.PrimaryPart or obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
            if mp then
                local sp,onS=cam:WorldToScreenPoint(mp.Position)
                if onS and sp.X>=mnX and sp.X<=mxX and sp.Y>=mnY and sp.Y<=mxY then highlightModel(obj) end
            end
        end
    end
end
local mouse=player:GetMouse(); local mouseDown=false
mouse.Button1Down:Connect(function()
    mouseDown=true
    if lassoTool then
        lassoStart=Vector2.new(mouse.X,mouse.Y)
        lassoFrame.Size=UDim2.new(0,0,0,0); lassoFrame.Visible=true
    elseif clickSelection or groupSelection then
        handleSelection(mouse.Target,false)
    end
end)
mouse.Button1Up:Connect(function()
    mouseDown=false
    if lassoTool then selectInLasso(); lassoFrame.Visible=false; lassoStart=nil end
end)
mouse.Move:Connect(function()
    if mouseDown and lassoTool and lassoStart then updLasso(lassoStart,Vector2.new(mouse.X,mouse.Y)) end
end)

-- ════════════════════════════════════════════════════
-- SHARED GLOBALS
-- ════════════════════════════════════════════════════
_G.VH={
    TweenService     =TweenService,
    Players          =Players,
    UserInputService =UserInputService,
    RunService       =RunService,
    TeleportService  =TeleportService,
    Stats            =Stats,
    player           =player,
    C                =C,
    cleanupTasks     =cleanupTasks,
    pages            =pages,
    tabs             =tabNames,
    switchTab        =switchTab,
    toggleGUI        =toggleGUI,
    stopFly          =stopFly,
    startFly         =startFly,
    makeBtn          =makeBtn,
    makeToggle       =makeToggle,
    makeSlider       =makeSlider,
    makeHeader       =makeHeader,
    makeHint         =makeHint,
    makeButtonRow    =makeButtonRow,
    makeStatCard     =makeStatCard,
    butter           ={running=false,thread=nil},
    flyToggleEnabled =true,
    isFlyEnabled     =false,
    currentFlyKey    =Enum.KeyCode.Q,
    waitingForFlyKey =false,
    flyKeyBtn        =flyKeyBtn,
    currentToggleKey =currentToggleKey,
    waitingForKeyGUI =false,
    keybindButtonGUI =nil,
}

_G.VanillaHubCleanup=onExit
print("[VanillaHub] Vanilla1 loaded")

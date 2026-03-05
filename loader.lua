-- VanillaHub Protected Loader
local KEY = getgenv().VHKey
local LP = game:GetService("Players").LocalPlayer

local function fetch(url)
    return game:HttpGet(url)
end

-- No key provided
if not KEY then
    LP:Kick("Key Has Expired!, Get a New Key!")
    return
end

-- Fetch keys
local success, keyData = pcall(fetch, "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/keys.txt")
if not success then
    LP:Kick("❌ VanillaHub: Could not reach key server. Try again.")
    return
end

-- Fetch admin perm keys
local adminSuccess, adminData = pcall(fetch, "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/admin.txt")

-- Check if admin perm key
local isAdmin = false
if adminSuccess and adminData then
    for line in adminData:gmatch("[^\n]+") do
        if line:gsub("%s+", "") == KEY:gsub("%s+", "") then
            isAdmin = true
            break
        end
    end
end

-- If admin skip all checks and load
if isAdmin then
    local sg = Instance.new("ScreenGui", game.CoreGui)
    sg.Name = "VHAdminNotice"
    sg.ResetOnSpawn = false
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 420, 0, 100)
    f.Position = UDim2.new(0.5, -210, 0.5, -50)
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = Color3.fromRGB(50, 190, 50)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(50, 255, 50)
    title.Text = "👑  Admin Key Detected"
    local sub = Instance.new("TextLabel", f)
    sub.Size = UDim2.new(1, -30, 0, 30)
    sub.Position = UDim2.new(0, 15, 0, 58)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 14
    sub.TextColor3 = Color3.fromRGB(180, 255, 180)
    sub.Text = "Welcome back! Loading VanillaHub..."
    sub.TextXAlignment = Enum.TextXAlignment.Left
    task.delay(4, function()
        if sg and sg.Parent then sg:Destroy() end
    end)
    -- Skip straight to loading
    goto loadScripts
end

-- Fetch expired keys
local expSuccess, expData = pcall(fetch, "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/expired.txt")

-- Check if expired
if expSuccess and expData then
    for line in expData:gmatch("[^\n]+") do
        if line:gsub("%s+", "") == KEY:gsub("%s+", "") then
            local sg = Instance.new("ScreenGui", game.CoreGui)
            sg.Name = "VHKeyError"
            sg.ResetOnSpawn = false
            local f = Instance.new("Frame", sg)
            f.Size = UDim2.new(0, 420, 0, 140)
            f.Position = UDim2.new(0.5, -210, 0.5, -70)
            f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)
            local stroke = Instance.new("UIStroke", f)
            stroke.Color = Color3.fromRGB(190, 50, 50)
            stroke.Thickness = 1.5
            stroke.Transparency = 0.4
            local title = Instance.new("TextLabel", f)
            title.Size = UDim2.new(1, 0, 0, 50)
            title.Position = UDim2.new(0, 0, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.TextSize = 20
            title.TextColor3 = Color3.fromRGB(255, 80, 80)
            title.Text = "❌  Key Expired"
            local sub = Instance.new("TextLabel", f)
            sub.Size = UDim2.new(1, -30, 0, 30)
            sub.Position = UDim2.new(0, 15, 0, 58)
            sub.BackgroundTransparency = 1
            sub.Font = Enum.Font.Gotham
            sub.TextSize = 14
            sub.TextColor3 = Color3.fromRGB(220, 200, 220)
            sub.Text = "Your key has expired. Get a new one!"
            sub.TextXAlignment = Enum.TextXAlignment.Left
            local link = Instance.new("TextLabel", f)
            link.Size = UDim2.new(1, -30, 0, 30)
            link.Position = UDim2.new(0, 15, 0, 88)
            link.BackgroundTransparency = 1
            link.Font = Enum.Font.GothamSemibold
            link.TextSize = 13
            link.TextColor3 = Color3.fromRGB(150, 130, 200)
            link.Text = "Get a new key at: YOUR_LOOTLABS_LINK_HERE"
            link.TextXAlignment = Enum.TextXAlignment.Left
            task.wait(4)
            LP:Kick("Key Has Expired!, Get a New Key!")
            return
        end
    end
end

-- Check if valid
local keyValid = false
for line in keyData:gmatch("[^\n]+") do
    if line:gsub("%s+", "") == KEY:gsub("%s+", "") then
        keyValid = true
        break
    end
end

if not keyValid then
    local sg = Instance.new("ScreenGui", game.CoreGui)
    sg.Name = "VHKeyError"
    sg.ResetOnSpawn = false
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 420, 0, 140)
    f.Position = UDim2.new(0.5, -210, 0.5, -70)
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = Color3.fromRGB(190, 50, 50)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 80, 80)
    title.Text = "❌  Invalid Key"
    local sub = Instance.new("TextLabel", f)
    sub.Size = UDim2.new(1, -30, 0, 30)
    sub.Position = UDim2.new(0, 15, 0, 58)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 14
    sub.TextColor3 = Color3.fromRGB(220, 200, 220)
    sub.Text = "Your key is invalid or expired."
    sub.TextXAlignment = Enum.TextXAlignment.Left
    local link = Instance.new("TextLabel", f)
    link.Size = UDim2.new(1, -30, 0, 30)
    link.Position = UDim2.new(0, 15, 0, 88)
    link.BackgroundTransparency = 1
    link.Font = Enum.Font.GothamSemibold
    link.TextSize = 13
    link.TextColor3 = Color3.fromRGB(150, 130, 200)
    link.Text = "Get a key at: YOUR_LOOTLABS_LINK_HERE"
    link.TextXAlignment = Enum.TextXAlignment.Left
    task.wait(4)
    LP:Kick("Key Has Expired!, Get a New Key!")
    return
end

-- Wrong game
if game.PlaceId ~= 13822889 then
    LP:Kick("❌ VanillaHub: This game is not supported! Join Lumber Tycoon 2.")
    return
end

::loadScripts::

-- Load scripts silently
local vanillaScripts = {
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla1.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla2.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla3.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla4.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla5.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla6.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla7.lua",
}

for i, url in ipairs(vanillaScripts) do
    local ok, src = pcall(fetch, url)
    if ok and src then
        local fn, err = loadstring(src)
        if fn then
            local runOk, runErr = pcall(fn)
            if not runOk then
                warn("[VanillaHub] Vanilla"..i.." error: "..tostring(runErr))
            end
        else
            warn("[VanillaHub] Failed to compile Vanilla"..i..": "..tostring(err))
        end
    else
        warn("[VanillaHub] Failed to fetch Vanilla"..i)
    end
    task.wait(0.3)
end

getgenv().VHKey = nil

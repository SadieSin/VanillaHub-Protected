-- VanillaHub Protected Loader
local KEY = getgenv().VHKey

if not KEY then
    warn("[VanillaHub] No key provided!")
    return
end

local keyListURL = "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/keys.txt"

local function fetch(url)
    return game:HttpGet(url)
end

local success, keyData = pcall(fetch, keyListURL)
if not success then
    warn("[VanillaHub] Could not reach key server.")
    return
end

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
    task.delay(6, function()
        if sg and sg.Parent then sg:Destroy() end
    end)
    return
end

-- Key valid — loading popup
local sg2 = Instance.new("ScreenGui", game.CoreGui)
sg2.Name = "VHLoading"
sg2.ResetOnSpawn = false
local f2 = Instance.new("Frame", sg2)
f2.Size = UDim2.new(0, 380, 0, 80)
f2.Position = UDim2.new(0.5, -190, 1, -110)
f2.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
f2.BackgroundTransparency = 0.2
f2.BorderSizePixel = 0
Instance.new("UICorner", f2).CornerRadius = UDim.new(0, 14)
local stroke2 = Instance.new("UIStroke", f2)
stroke2.Color = Color3.fromRGB(230, 206, 226)
stroke2.Thickness = 1.2
stroke2.Transparency = 0.5
local loadLbl = Instance.new("TextLabel", f2)
loadLbl.Size = UDim2.new(1, 0, 1, 0)
loadLbl.BackgroundTransparency = 1
loadLbl.Font = Enum.Font.GothamBold
loadLbl.TextSize = 16
loadLbl.TextColor3 = Color3.fromRGB(230, 206, 226)
loadLbl.Text = "⏳  Loading VanillaHub..."

-- Vanilla scripts list
local vanillaScripts = {
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla1.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla2.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla3.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla4.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla5.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla6.lua",
    "https://raw.githubusercontent.com/SadieSin/VanillaHub-Protected/main/Vanilla7.lua",
}

local function loadVanilla()
    for i, url in ipairs(vanillaScripts) do
        loadLbl.Text = "⏳  Loading VanillaHub... ("..i.."/7)"
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
end

-- Load based on game
if game.PlaceId == 13822889 then
    -- Lumber Tycoon 2 — load all 7 Vanilla scripts
    loadLbl.Text = "⏳  Loading VanillaHub for LT2..."
    loadVanilla()

else
    -- Game not supported
    loadLbl.Text = "❌  Game not supported!"
    task.delay(4, function()
        if sg2 and sg2.Parent then sg2:Destroy() end
    end)
    getgenv().VHKey = nil
    return
end

loadLbl.Text = "✅  VanillaHub Loaded!"
task.delay(3, function()
    if sg2 and sg2.Parent then sg2:Destroy() end
end)

getgenv().VHKey = nil

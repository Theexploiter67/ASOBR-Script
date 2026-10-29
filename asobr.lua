local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "ASOBR Hub",
    LoadingTitle = "ASOBR Script",
    LoadingSubtitle = "Fatal_Error + DustDust + Avenge",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ASOBRHub",
        FileName = "Config"
    },
    KeySystem = false
})

-- BACKGROUND
task.spawn(function()
    task.wait(1.5)

    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local rayfieldGui = playerGui:FindFirstChild("Rayfield")
        or playerGui:FindFirstChild("RayfieldLibrary")

    if rayfieldGui then
        for _, obj in ipairs(rayfieldGui:GetDescendants()) do
            if obj:IsA("Frame")
                and (obj.Name == "Main" or obj.Name == "Window"
                or obj.Name:find("Main")) then

                local bg = Instance.new("ImageLabel")
                bg.Name = "ASOBRBackground"
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.Position = UDim2.new(0, 0, 0, 0)
                bg.BackgroundTransparency = 1
                bg.Image = "rbxassetid://87580233845899"
                bg.ImageTransparency = 0.6
                bg.ScaleType = Enum.ScaleType.Crop
                bg.ZIndex = 0
                bg.Parent = obj

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = bg

                local overlay = Instance.new("Frame")
                overlay.Size = UDim2.new(1, 0, 1, 0)
                overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                overlay.BackgroundTransparency = 0.5
                overlay.BorderSizePixel = 0
                overlay.ZIndex = 1
                overlay.Parent = obj

                local overlayCorner = Instance.new("UICorner")
                overlayCorner.CornerRadius = UDim.new(0, 8)
                overlayCorner.Parent = overlay

                break
            end
        end
    end
end)

-- ALLOWED BOSSES
local allowed_bosses = {
    "Sans", "HardModeSans", "FellSans", "OuterSans", "SwapSans",
    "KillerSans", "DustSans", "AssuredPrey", "HorrorSans",
    "InsanitySans", "SuddenChangesSans", "NightmareSans",
    "DioSans", "GalaxySans", "NIGHTDUST????",
    "ChickenInsanitySans", "EchotaleSans", "ErrorSans",
    "InkSans", "WikiSans", "LastBreathSans", "Error404Sans",
    "Fatal_Error_Sans", "[WEAK] BUTTERFLY404",
    "Fatal_Error_Sans_Phase2", "LastBreathSansPhase2",
    "LastBreathSansPhase3", "VhsSans", "DustDustSans",
    "DustDustSansPhase2", "Fatal_Error", "ErrorDust", "DustDust"
}

local speedValue = 50
local speedEnabled = false
local speedCoroutine = nil

-- TELEPORTS
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
TeleportsTab:CreateSection("Boss Spawners")

-- 404 SWORD
TeleportsTab:CreateButton({
    Name = "404 Sword (Boss Spawner)",
    Callback = function()
        local success, err = pcall(function()
            local character = game.Players.LocalPlayer.Character
            if not character then return end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local sword = workspace:FindFirstChild("404Sword")
            if not sword then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "404Sword not found!",
                    Duration = 4
                })
                return
            end

            local targetCFrame = sword:IsA("BasePart")
                and sword.CFrame or sword:GetPivot()

            hrp.CFrame = targetCFrame + Vector3.new(0, 5, 0)

            Rayfield:Notify({
                Title = "Success",
                Content = "Teleported to 404Sword!",
                Duration = 3
            })
        end)

        if not success then
            warn("[404 SWORD] " .. tostring(err))
        end
    end
})

-- AVENGE SANS SWORD
TeleportsTab:CreateButton({
    Name = "Auto Avenge Sans Sword",
    Callback = function()
        local success, err = pcall(function()
            local character = game.Players.LocalPlayer.Character
            if not character then return end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local sword

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("avenge")
                    and (obj:IsA("BasePart") or obj:IsA("Model")) then
                    sword = obj
                    break
                end
            end

            if not sword then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Avenge Sword not found!",
                    Duration = 4
                })
                return
            end

            local targetCFrame = sword:IsA("BasePart")
                and sword.CFrame or sword:GetPivot()

            hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)

            task.wait(0.4)

            local detector =
                sword:FindFirstChildWhichIsA("ClickDetector", true)

            if detector and typeof(fireclickdetector) == "function" then
                fireclickdetector(detector)
            end

            Rayfield:Notify({
                Title = "Avenge Sword",
                Content = "Teleported to Avenge Sword!",
                Duration = 3
            })
        end)

        if not success then
            warn("[AVENGE SWORD] " .. tostring(err))
        end
    end
})

-- NEW: TELEPORT TO ORANGE CUBE FROM VIDEO
TeleportsTab:CreateSection("Secret Locations")

TeleportsTab:CreateButton({
    Name = "Teleport to Orange Cube",
    Callback = function()
        local success, message = pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
                or player.CharacterAdded:Wait()

            local hrp = character:WaitForChild("HumanoidRootPart")
            local candidates = {}

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj ~= hrp then
                    local color = obj.Color

                    local isOrange =
                        color.R > 0.65
                        and color.G > 0.12
                        and color.G < 0.65
                        and color.B < 0.3

                    local size = obj.Size
                    local largest = math.max(size.X, size.Y, size.Z)
                    local smallest = math.min(size.X, size.Y, size.Z)

                    local isCubeLike =
                        largest <= 15
                        and smallest >= 0.5
                        and largest / smallest < 2.5

                    if isOrange and isCubeLike
                        and obj.Transparency < 1 then

                        table.insert(candidates, {
                            part = obj,
                            distance =
                                (obj.Position - hrp.Position).Magnitude
                        })
                    end
                end
            end

            if #candidates == 0 then
                return "Orange cube not found. Load the area first."
            end

            table.sort(candidates, function(a, b)
                return a.distance < b.distance
            end)

            local target = candidates[1].part

            hrp.CFrame = target.CFrame + Vector3.new(0, 4, 0)

            print("[ORANGE CUBE] Target:", target:GetFullName())
            print("[ORANGE CUBE] Position:", target.Position)

            return "Teleported near: " .. target:GetFullName()
        end)

        Rayfield:Notify({
            Title = "Orange Cube Teleport",
            Content = success and tostring(message)
                or "Teleport failed: " .. tostring(message),
            Duration = 5
        })
    end
})

-- COMBAT
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Boss Killer")

-- FIND & CLICK TRIDENT
CombatTab:CreateButton({
    Name = "FIND & CLICK TRIDENT",
    Callback = function()
        local success, result = pcall(function()
            local matches = {}

            for _, obj in ipairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()

                if name:find("trident", 1, true)
                    or name:find("spear", 1, true) then

                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        table.insert(matches, obj)
                    end
                end
            end

            if #matches == 0 then
                return "Trident not found."
            end

            for _, obj in ipairs(matches) do
                local detector =
                    obj:FindFirstChildWhichIsA("ClickDetector", true)

                local prompt =
                    obj:FindFirstChildWhichIsA("ProximityPrompt", true)

                if detector
                    and typeof(fireclickdetector) == "function" then

                    fireclickdetector(detector)
                    return "Click attempted: " .. obj.Name

                elseif prompt
                    and typeof(fireproximityprompt) == "function" then

                    fireproximityprompt(prompt)
                    return "Interaction attempted: " .. obj.Name
                end
            end

            return "Found an object, but no supported interaction."
        end)

        Rayfield:Notify({
            Title = "DIVINE JUDGEMENT",
            Content = tostring(result),
            Duration = 5
        })

        if not success then
            warn("[TRIDENT FINDER] " .. tostring(result))
        end
    end
})

-- BOSS FINDER
CombatTab:CreateButton({
    Name = "BOSS FINDER",
    Callback = function()
        local success, err = pcall(function()
            local bossFolder = workspace:FindFirstChild("Boss")

            if not bossFolder then
                Rayfield:Notify({
                    Title = "BOSS FINDER",
                    Content = "Boss folder not found!",
                    Duration = 4
                })
                return
            end

            local added = {}
            local found = {}

            for _, boss in ipairs(bossFolder:GetChildren()) do
                if boss:IsA("Model") or boss:IsA("Humanoid") then
                    if not table.find(allowed_bosses, boss.Name) then
                        table.insert(allowed_bosses, boss.Name)
                        table.insert(added, boss.Name)
                    end

                    table.insert(found, boss.Name)
                end
            end

            print("===== BOSS FINDER =====")
            for _, name in ipairs(found) do
                print(name)
            end
            print("=======================")

            Rayfield:Notify({
                Title = "BOSS FINDER",
                Content = #added > 0
                    and ("Added: " .. table.concat(added, ", "))
                    or (#found > 0
                        and "All found bosses are already registered."
                        or "No bosses found in workspace.Boss."),
                Duration = 5
            })
        end)

        if not success then
            warn("[BOSS FINDER] " .. tostring(err))
        end
    end
})

-- AUTO KILL
local autoKillConnection
local isAutoEnabled = false

CombatTab:CreateToggle({
    Name = "Auto Kill Boss",
    CurrentValue = false,
    Flag = "AutoKillBoss",
    Callback = function(Value)
        local bossFolder = workspace:FindFirstChild("Boss")

        if not bossFolder then
            Rayfield:Notify({
                Title = "Error",
                Content = "Boss folder not found!",
                Duration = 4
            })
            return
        end

        if Value then
            if autoKillConnection then
                autoKillConnection:Disconnect()
            end

            isAutoEnabled = true

            autoKillConnection = bossFolder.ChildAdded:Connect(function(child)
                task.delay(0.5, function()
                    if not isAutoEnabled or not child.Parent then
                        return
                    end

                    if table.find(allowed_bosses, child.Name) then
                        local humanoid =
                            child:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                            humanoid.Health = 0
                        end
                    end
                end)
            end)

            Rayfield:Notify({
                Title = "Auto Kill",
                Content = "Auto Kill enabled!",
                Duration = 3
            })
        else
            isAutoEnabled = false

            if autoKillConnection then
                autoKillConnection:Disconnect()
                autoKillConnection = nil
            end

            Rayfield:Notify({
                Title = "Auto Kill",
                Content = "Auto Kill disabled.",
                Duration = 2
            })
        end
    end
})

-- INSTANT KILL ALL BOSSES
CombatTab:CreateButton({
    Name = "Instant Kill All Bosses",
    Callback = function()
        local bossFolder = workspace:FindFirstChild("Boss")

        if not bossFolder then
            Rayfield:Notify({
                Title = "Error",
                Content = "Boss folder not found!",
                Duration = 4
            })
            return
        end

        local killed = {}

        for _, child in ipairs(bossFolder:GetChildren()) do
            if table.find(allowed_bosses, child.Name) then
                local humanoid =
                    child:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = 0
                    table.insert(killed, child.Name)
                end
            end
        end

        Rayfield:Notify({
            Title = #killed > 0 and "Success" or "Info",
            Content = #killed > 0
                and ("Killed: " .. table.concat(killed, ", "))
                or "No matching bosses found.",
            Duration = 4
        })
    end
})

-- PRINT CURRENT BOSSES
CombatTab:CreateButton({
    Name = "Print Current Bosses",
    Callback = function()
        local bossFolder = workspace:FindFirstChild("Boss")

        if not bossFolder then
            print("Boss folder not found")
            return
        end

        print("===== Current Bosses =====")

        for _, boss in ipairs(bossFolder:GetChildren()) do
            print(boss.Name)
        end

        print("==========================")

        Rayfield:Notify({
            Title = "Info",
            Content = "Bosses printed in console!",
            Duration = 3
        })
    end
})

-- PLAYER
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        speedEnabled = Value
        local player = game.Players.LocalPlayer

        if Value then
            speedCoroutine = task.spawn(function()
                while task.wait(0.1) do
                    if not speedEnabled then break end

                    local character = player.Character

                    if character then
                        local humanoid =
                            character:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                            humanoid.WalkSpeed = speedValue
                        end
                    end
                end
            end)

            Rayfield:Notify({
                Title = "Speed",
                Content = "Speed Hack ON",
                Duration = 2
            })
        else
            if speedCoroutine then
                task.cancel(speedCoroutine)
                speedCoroutine = nil
            end

            local character = player.Character

            if character then
                local humanoid =
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end

            Rayfield:Notify({
                Title = "Speed",
                Content = "Speed Hack OFF",
                Duration = 2
            })
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "WalkSpeed",
    Callback = function(Value)
        speedValue = Value

        if speedEnabled then
            local character = game.Players.LocalPlayer.Character

            if character then
                local humanoid =
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

print("ASOBR Hub + Orange Cube Teleport + TRIDENT FINDER loaded!")

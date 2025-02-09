-- ESP Script for Roblox with Chams and Health

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

-- Local Player
local localPlayer = Players.LocalPlayer

-- Function to create ESP and Chams
function createESP(player)
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    -- Create a BillboardGui for the ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18

    -- Устанавливаем цвет текста в зависимости от команды
    if player.Team == localPlayer.Team then
        textLabel.TextColor3 = Color3.new(0, 1, 0) -- Зеленый для своей команды
    else
        textLabel.TextColor3 = Color3.new(1, 0, 0) -- Красный для других команд
    end

    billboard.Parent = character

    -- Create Chams (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.Adornee = character
    highlight.FillTransparency = 0.5 -- Прозрачность заполнения
    highlight.OutlineTransparency = 0 -- Прозрачность контура

    -- Устанавливаем цвет Chams в зависимости от команды
    if player.Team == localPlayer.Team then
        highlight.FillColor = Color3.new(0, 1, 0) -- Зеленый для своей команды
        highlight.OutlineColor = Color3.new(0, 0.5, 0) -- Темно-зеленый контур
    else
        highlight.FillColor = Color3.new(1, 0, 0) -- Красный для других команд
        highlight.OutlineColor = Color3.new(0.5, 0, 0) -- Темно-красный контур
    end

    -- Update distance and health
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if humanoidRootPart and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localRootPart = localPlayer.Character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - localRootPart.Position).Magnitude
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            -- Все данные в одной строке
            textLabel.Text = player.Name .. " | HP: " .. math.floor(health) .. "/" .. math.floor(maxHealth) .. " | " .. math.floor(distance) .. " studs"
        else
            -- Если localPlayer умер или его части отсутствуют, прекращаем обновление
            connection:Disconnect()
        end
    end)

    -- Обработка перерождения персонажа
    player.CharacterAdded:Connect(function(newCharacter)
        -- Удаляем старый ESP и Chams
        if billboard then
            billboard:Destroy()
        end
        if highlight then
            highlight:Destroy()
        end

        -- Создаем новый ESP и Chams для нового персонажа
        createESP(player)
    end)

    -- Обработка смены команды
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if player.Team == localPlayer.Team then
            textLabel.TextColor3 = Color3.new(0, 1, 0) -- Зеленый для своей команды
            highlight.FillColor = Color3.new(0, 1, 0) -- Зеленый для своей команды
            highlight.OutlineColor = Color3.new(0, 0.5, 0) -- Темно-зеленый контур
        else
            textLabel.TextColor3 = Color3.new(1, 0, 0) -- Красный для других команд
            highlight.FillColor = Color3.new(1, 0, 0) -- Красный для других команд
            highlight.OutlineColor = Color3.new(0.5, 0, 0) -- Темно-красный контур
        end
    end)
end

-- Loop through all players and create ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)

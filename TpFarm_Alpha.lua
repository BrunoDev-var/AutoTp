-- Creación de un menú profesional en Roblox Studio con GUI movible
-- Incluye guardar ubicación y auto teleport cada 3 segundos

-- Crear GUI principal
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ProfessionalMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Professional Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Botón para guardar ubicación
local saveLocationButton = Instance.new("TextButton", mainFrame)
saveLocationButton.Size = UDim2.new(0.8, 0, 0.2, 0)
saveLocationButton.Position = UDim2.new(0.1, 0, 0.3, 0)
saveLocationButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
saveLocationButton.Text = "Save Location"
saveLocationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLocationButton.Font = Enum.Font.SourceSansBold
saveLocationButton.TextSize = 18

-- Botón para activar/desactivar Auto TP
local autoTpButton = Instance.new("TextButton", mainFrame)
autoTpButton.Size = UDim2.new(0.8, 0, 0.2, 0)
autoTpButton.Position = UDim2.new(0.1, 0, 0.6, 0)
autoTpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoTpButton.Text = "Auto TP: OFF"
autoTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTpButton.Font = Enum.Font.SourceSansBold
autoTpButton.TextSize = 18

-- Variables de funcionalidad
local savedLocation = nil
local autoTpEnabled = false

-- Función para guardar ubicación
saveLocationButton.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedLocation = character.HumanoidRootPart.Position
        saveLocationButton.Text = "Location Saved"
        wait(1)
        saveLocationButton.Text = "Save Location"
    end
end)

-- Función para activar/desactivar Auto TP
autoTpButton.MouseButton1Click:Connect(function()
    autoTpEnabled = not autoTpEnabled
    autoTpButton.Text = autoTpEnabled and "Auto TP: ON" or "Auto TP: OFF"
end)

-- Bucle para Auto TP
spawn(function()
    while true do
        wait(3)
        if autoTpEnabled and savedLocation then
            local character = player.Character or player.CharacterAdded:Wait()
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(savedLocation)
            end
        end
    end
end)

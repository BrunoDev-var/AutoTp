-- Creación de un menú profesional en Roblox Studio con GUI movible
-- Incluye guardar ubicación, ajuste de intervalo de teleport, persistencia al morir, y Anti-AFK

-- Crear GUI principal
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ProfessionalMenu"
screenGui.ResetOnSpawn = false -- Asegura que el menú no desaparezca al morir

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
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
saveLocationButton.Size = UDim2.new(0.8, 0, 0.15, 0)
saveLocationButton.Position = UDim2.new(0.1, 0, 0.25, 0)
saveLocationButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
saveLocationButton.Text = "Save Location"
saveLocationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLocationButton.Font = Enum.Font.SourceSansBold
saveLocationButton.TextSize = 18

-- Botón para activar/desactivar Auto TP
local autoTpButton = Instance.new("TextButton", mainFrame)
autoTpButton.Size = UDim2.new(0.8, 0, 0.15, 0)
autoTpButton.Position = UDim2.new(0.1, 0, 0.45, 0)
autoTpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoTpButton.Text = "Auto TP: OFF"
autoTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTpButton.Font = Enum.Font.SourceSansBold
autoTpButton.TextSize = 18

-- Botón para activar/desactivar Anti-AFK
local antiAfkButton = Instance.new("TextButton", mainFrame)
antiAfkButton.Size = UDim2.new(0.8, 0, 0.15, 0)
antiAfkButton.Position = UDim2.new(0.1, 0, 0.65, 0)
antiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
antiAfkButton.Text = "Anti-AFK: OFF"
antiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiAfkButton.Font = Enum.Font.SourceSansBold
antiAfkButton.TextSize = 18

-- Slider para ajuste del intervalo de teleport
local sliderFrame = Instance.new("Frame", mainFrame)
sliderFrame.Size = UDim2.new(0.8, 0, 0.15, 0)
sliderFrame.Position = UDim2.new(0.1, 0, 0.85, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0.9, 0, 0.4, 0)
sliderBar.Position = UDim2.new(0.05, 0, 0.3, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local sliderKnob = Instance.new("ImageButton", sliderBar)
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0, -10, 0.5, -10)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Image = "rbxassetid://6070014446" -- Un diseño de botón circular

local sliderValueLabel = Instance.new("TextLabel", sliderFrame)
sliderValueLabel.Size = UDim2.new(1, 0, 0.3, 0)
sliderValueLabel.Position = UDim2.new(0, 0, 0, 0)
sliderValueLabel.BackgroundTransparency = 1
sliderValueLabel.Text = "Interval: 3s"
sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderValueLabel.Font = Enum.Font.SourceSansBold
sliderValueLabel.TextSize = 16

-- Variables de funcionalidad
local savedLocation = nil
local autoTpEnabled = false
local antiAfkEnabled = false
local teleportInterval = 3 -- Intervalo inicial de teleport en segundos

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

-- Función para activar/desactivar Anti-AFK
antiAfkButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    antiAfkButton.Text = antiAfkEnabled and "Anti-AFK: ON" or "Anti-AFK: OFF"
    if antiAfkEnabled then
        spawn(function()
            while antiAfkEnabled do
                wait(60) -- Envía un evento cada 60 segundos para evitar ser expulsado por inactividad
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new()) -- Simula una acción de clic
            end
        end)
    end
end)

-- Función para mover el slider y ajustar el intervalo
sliderKnob.MouseButton1Down:Connect(function()
    local userInput = game:GetService("UserInputService")
    local connection
    connection = userInput.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local sliderBarAbsPos = sliderBar.AbsolutePosition
            local sliderBarAbsSize = sliderBar.AbsoluteSize
            local mousePos = input.Position.X
            local relativePos = math.clamp((mousePos - sliderBarAbsPos.X) / sliderBarAbsSize.X, 0, 1)
            sliderKnob.Position = UDim2.new(relativePos, -10, 0.5, -10)
            teleportInterval = math.floor(relativePos * 19) + 1 -- Rango de 1 a 20
            sliderValueLabel.Text = "Interval: " .. teleportInterval .. "s"
        end
    end)
    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Bucle para Auto TP
spawn(function()
    while true do
        wait(teleportInterval)
        if autoTpEnabled and savedLocation then
            local character = player.Character or player.CharacterAdded:Wait()
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(savedLocation)
            end
        end
    end
end)

-- ======================
-- PLAYER ESP (TOGGLE)
-- ======================

if _G.PLAYER_ESP then
	_G.PLAYER_ESP = false
	print("PLAYER ESP: OFF")

	if _G.PLAYER_ESP_DATA then
		for player, box in pairs(_G.PLAYER_ESP_DATA) do
			if box then
				pcall(function()
					box:Destroy()
				end)
			end
		end
	end

	return
end

_G.PLAYER_ESP = true
_G.PLAYER_ESP_DATA = {}
print("PLAYER ESP: ON")

-- ======================
-- SERVICIOS
-- ======================
local Players = game:GetService("Players")
local ESPs = _G.PLAYER_ESP_DATA

-- ======================
-- FUNCIONES
-- ======================
local function getMainPart(character)
	return character:FindFirstChild("HumanoidRootPart")
		or character:FindFirstChildWhichIsA("BasePart")
end

local function createESP(player)
	if not _G.PLAYER_ESP then return end
	if player == Players.LocalPlayer then return end
	if ESPs[player] then return end
	
	local function setupCharacter(character)
		if not _G.PLAYER_ESP then return end

		local mainPart = getMainPart(character)
		if not mainPart then return end
		
		local size = character:GetExtentsSize()
		
		-- Box blanco
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = mainPart
		box.Size = size
		box.AlwaysOnTop = true
		box.ZIndex = 5
		box.Color3 = Color3.fromRGB(255,255,255)
		box.Transparency = 0.7
		box.Parent = mainPart
		
		-- Nombre arriba (DisplayName)
		local offsetY = size.Y/2 + 1.5
		
		local billboard = Instance.new("BillboardGui")
		billboard.Adornee = mainPart
		billboard.Size = UDim2.new(0,140,0,30)
		billboard.StudsOffset = Vector3.new(0, offsetY, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = box
		
		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1,0,1,0)
		text.BackgroundTransparency = 1
		text.Text = player.DisplayName
		text.TextColor3 = Color3.fromRGB(255,255,255)
		text.TextStrokeTransparency = 0
		text.TextStrokeColor3 = Color3.new(0,0,0)
		text.TextSize = 16
		text.Font = Enum.Font.GothamBold
		text.Parent = billboard
		
		ESPs[player] = box
	end
	
	if player.Character then
		setupCharacter(player.Character)
	end
	
	player.CharacterAdded:Connect(function(char)
		if ESPs[player] then
			pcall(function()
				ESPs[player]:Destroy()
			end)
			ESPs[player] = nil
		end
		setupCharacter(char)
	end)
end

local function removeESP(player)
	if ESPs[player] then
		pcall(function()
			ESPs[player]:Destroy()
		end)
		ESPs[player] = nil
	end
end

-- ======================
-- INICIALIZAR
-- ======================
for _, player in pairs(Players:GetPlayers()) do
	createESP(player)
end

Players.PlayerAdded:Connect(function(player)
	createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

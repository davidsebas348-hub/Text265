-- =========================
-- TOGGLE INSTANT PROMPT
-- =========================

if _G.INSTANT_PROMPT then
	-- 🔴 APAGAR
	_G.INSTANT_PROMPT = false
	print("Instant Prompt OFF")
	return
end

-- 🟢 ENCENDER
_G.INSTANT_PROMPT = true
print("Instant Prompt ON")

_G.INSTANT_CONNECTIONS = _G.INSTANT_CONNECTIONS or {}

local function connectPrompt(prompt)
	if not _G.INSTANT_PROMPT then return end
	if not prompt:IsA("ProximityPrompt") then return end
	if _G.INSTANT_CONNECTIONS[prompt] then return end

	-- 🔹 GLOBAL instant
	local conn1 = prompt.PromptButtonHoldBegan:Connect(function()
		if not _G.INSTANT_PROMPT then return end
		pcall(function()
			fireproximityprompt(prompt)
		end)
	end)

	-- 🔹 SOLO Kebab.040
	local conn2
	if prompt.Parent and prompt.Parent.Name == "Kebab.040" then
		conn2 = prompt.PromptButtonHoldBegan:Connect(function()
			if not _G.INSTANT_PROMPT then return end
			pcall(function()
				fireproximityprompt(prompt)
			end)
		end)
	end

	_G.INSTANT_CONNECTIONS[prompt] = {conn1, conn2}
end

-- Aplicar a existentes
for _, obj in pairs(workspace:GetDescendants()) do
	connectPrompt(obj)
end

-- Detectar nuevos
if not _G.INSTANT_MAIN_CONNECTION then
	_G.INSTANT_MAIN_CONNECTION = workspace.DescendantAdded:Connect(connectPrompt)
end

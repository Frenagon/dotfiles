local builtInMonitorOptions = {
	output = "eDP-1",
	disabled = false,
	mode = "preferred",
	position = "auto",
	scale = "2",
}

hl.monitor(builtInMonitorOptions)

local function merge_dictionaries(base, additions)
	local new_dict = {}

	-- Copy base entries
	for k, v in pairs(base) do
		new_dict[k] = v
	end

	-- Overwrite or add entries from additions
	for k, v in pairs(additions) do
		new_dict[k] = v
	end

	return new_dict
end

local externalMonitorOptions = {
	disabled = false,
	mode = "3440x1440@120",
	position = "auto",
	scale = "1.25",
}

hl.monitor(merge_dictionaries({ output = "DP-1" }, externalMonitorOptions))
hl.monitor(merge_dictionaries({ output = "DP-3" }, externalMonitorOptions))

-- Helper function to read the lid state
local function get_lid_state()
	local file = io.open("/proc/acpi/button/lid/LID0/state", "r")
	if not file then
		-- Try alternate LID node if LID0 doesn't exist
		file = io.open("/proc/acpi/button/lid/LID/state", "r")
	end

	if file then
		local content = file:read("*all")
		file:close()
		-- Content typically looks like "state: open" or "state: closed"
		if content:match("closed") then
			return "closed"
		else
			return "open"
		end
	end
	return "unknown"
end

-- Monitor event handling
hl.bind("switch:on:Lid Switch", function()
	if #hl.get_monitors() > 1 then
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.monitor(builtInMonitorOptions)
end, { locked = true })

hl.on("monitor.added", function()
	if get_lid_state() == "closed" and #hl.get_monitors() > 1 then
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end)

hl.on("monitor.removed", function()
	local externalCount = 0

	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= "eDP-1" then
			externalCount = externalCount + 1
		end
	end

	if externalCount == 0 then
		hl.monitor(builtInMonitorOptions)
	end
end)

hl.on("config.reloaded", function()
	if get_lid_state() == "closed" and #hl.get_monitors() > 1 then
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end)

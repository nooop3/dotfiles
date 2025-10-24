require("hs.ipc")

local configDir = hs.configdir
local hk = require("hs.hotkey")

-- SpoonInstall
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall
Install.use_syncinstall = true

-- get unique values from a list
local function uniq(list)
	local seen, result = {}, {}
	for _, v in ipairs(list) do
		if not seen[v] then
			seen[v] = true
			table.insert(result, v)
		end
	end
	return result
end

-- get the real dir of the init.lua file
local function getInitRealDir()
	local initFile = configDir .. "/init.lua"

	local initReal = hs.fs.pathToAbsolute(initFile)
	local result = initReal:match("(.+)/[^/]+$") or configDir

	return result
end

-- ReloadConfiguration
local initRealDir = getInitRealDir()
local watchDirs = uniq({ initRealDir, configDir })
hs.printf("[ReloadConfiguration] Watching: %s", table.concat(watchDirs, ", "))
Install:andUse("ReloadConfiguration", {
	start = true,
	config = {
		watch_paths = watchDirs,
	},
})

-- AClock
Install:andUse("AClock", {
	config = {
		format = "%H:%M",
		-- textFont = "Menlo",
		textSize = 240,
		width = 640,
		height = 460,
		showDuration = 4,
	},
	start = false,
})
-- Hotkeys: transient (auto-hides after showDuration) & persistent toggle
hk.bind({ "cmd", "alt", "ctrl" }, "T", function()
	spoon.AClock:toggleShow()
end)
-- hk.bind({ "cmd", "alt", "ctrl" }, "A", function()
-- 	spoon.AClock:toggleShowPersistent()
-- end)

hs.alert.show("Config loaded")

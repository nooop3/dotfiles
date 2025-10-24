require("hs.ipc")

local configDir = hs.configdir

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

-- get the real path of the init.lua file
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
hs.alert.show(initRealDir)
hs.alert.show("Config loaded")

-- Caffeine
Install:andUse("Caffeine", {
	hotkeys = {
		toggle = { { "cmd", "alt", "ctrl" }, "C" },
	},
})

-- hs.loadSpoon("AClock")
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "C", function()
-- 	spoon.AClock:toggleShow()
-- end)

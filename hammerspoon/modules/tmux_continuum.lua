-- ~/.hammerspoon/modules/tmux_continuum.lua
local M = {}

function M.start()
	------------------------------------------------------------
	-- tmux-continuum manager via Hammerspoon
	------------------------------------------------------------
	local ENABLE_AFTER_SECS = 30 * 60
	local CONTINUUM_INTERVAL_ENABLED = 60
	local CONTINUUM_INTERVAL_DISABLED = 0
	local enableTimer

	local function sh(cmd)
		hs.execute(cmd, true)
	end
	local function tmuxRunning()
		local _, ok = hs.execute("/usr/bin/pgrep -x tmux >/dev/null 2>&1; echo $?")
		return ok == true
	end
	local function setContinuumInterval(mins)
		if tmuxRunning() then
			sh(string.format([[/bin/bash -lc 'tmux set -g @continuum-save-interval %d >/dev/null 2>&1']], mins))
		end
	end
	local function cancelEnableTimer()
		if enableTimer then
			enableTimer:stop()
			enableTimer = nil
		end
	end
	local function scheduleEnable()
		cancelEnableTimer()
		enableTimer = hs.timer.doAfter(ENABLE_AFTER_SECS, function()
			setContinuumInterval(CONTINUUM_INTERVAL_ENABLED)
			hs.printf("[tmux-continuum] Enabled after delay")
		end)
		hs.printf("[tmux-continuum] Will enable in %d seconds", ENABLE_AFTER_SECS)
		hs.alert.show("[tmux-continuum] Will enable in " .. ENABLE_AFTER_SECS .. " seconds")
	end
	local function disableNow()
		cancelEnableTimer()
		setContinuumInterval(CONTINUUM_INTERVAL_DISABLED)
		hs.printf("[tmux-continuum] Disabled")
		hs.alert.show("[tmux-continuum] Disabled")
	end

	disableNow()
	scheduleEnable()

	local cw = hs.caffeinate.watcher.new(function(event)
		if event == hs.caffeinate.watcher.systemWillSleep then
			disableNow()
		elseif event == hs.caffeinate.watcher.systemDidWake then
			scheduleEnable()
		end
	end)
	cw:start()
end

return M

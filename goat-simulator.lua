scriptId = 'com.bweisel.shipit.goatsimulator'
scriptTitle = "Goat Simulator"
scriptDetailsUrl = ""

description = [[
Goat Simulator
]]
 
link = [[]]
 
controls = [[
Controls:
- TBD
 ]]
 
knownIssues = [[
- Many
 ]]

function activeAppName()
    return "Goat Simulator"
end

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	-- GoatGame-Win32-Shipping.exe, Goat Game (32-bit, DX9)
    local titleMatch = string.match(title, "Goat Game (32-bit, DX9)") ~= nil or platform == "Windows" and app == "GoatGame-Win32-Shipping.exe"
	
    if (titleMatch) then
        myo.setLockingPolicy("none")
		myo.controlMouse(true)
		myo.centerMousePosition()
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	if (edge == "on") then
		if (pose == "fist") then
			attack()
		elseif (pose == "doubleTap") then
			jump()
		elseif (pose == "fingersSpread") then
			lick()
		elseif (pose == "waveIn") then
			ragdoll()
		end
	end
end

function onPeriodic()
	
end

function ragdoll()
	myo.debug("RAGDOLL!")
	myo.keyboard("q", "press")
end

function lick()
	myo.debug("LICKING!")
	myo.keyboard("e", "press")
end

function jump()
	myo.debug("JUMPING!")
	myo.keyboard("space", "press")
end

function attack()
	myo.debug("FIRE ZE MISSILES!!")
	myo.mouse("left", "click")
	myo.vibrate("short")
end
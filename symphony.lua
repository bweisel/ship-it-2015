scriptId = 'com.bweisel.shipit.symphony'
scriptTitle = "Symphony"
scriptDetailsUrl = ""

description = [[
Symphony
]]
 
link = [[]]
 
controls = [[
Controls:
- TBD
 ]]
 
knownIssues = [[
- Many
 ]]

mouseEnabled = false
waveOutTimer = 0
 
function activeAppName()
    return "Symphony"
end

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	-- Symphony.exe, Symphony
    local titleMatch = string.match(title, "Symphony") ~= nil or platform == "Windows" and app == "Symphony.exe"
	
    if (titleMatch) then
        myo.setLockingPolicy("none")
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	if (edge == "on") then
		if (pose == "fist") then
			startShooting()
		elseif (pose == "doubleTap") then
			myo.centerMousePosition()
		elseif (pose == "waveOut") then
			if (mouseEnabled) then
				toggleMouseControl()
			else
				waveOutTimer = myo.getTimeMilliseconds()
			end
		end
	else
		if (pose == "fist") then
			stopShooting()
		end
		waveOutTimer = 0
	end
end

function onPeriodic()
	if (waveOutTimer > 0 and myo.getTimeMilliseconds() > (waveOutTimer + 1750)) then
		waveOutTimer = 0
		toggleMouseControl()
	end
end

function toggleMouseControl()
	mouseEnabled = not mouseEnabled
	myo.controlMouse(mouseEnabled)
	if (mouseEnabled) then
		myo.debug("mouseEnabled = true")
		myo.centerMousePosition()
	end
	myo.vibrate("long")
end

function startShooting()
	myo.debug("Firing!")
	myo.mouse("left", "down")
	myo.vibrate("short")
end

function stopShooting()
	myo.debug("Firing!")
	myo.mouse("left", "up")
	myo.vibrate("short")
end
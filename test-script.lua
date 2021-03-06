scriptId = 'com.bweisel.shipit.testscript'
scriptTitle = "Test Script"
scriptDetailsUrl = ""

description = [[
Test Script
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
    return "Test Script"
end

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	-- Symphony.exe, Symphony
    local titleMatch = app == "notepad++.exe"
	
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
	if (waveOutTimer > 0 and myo.getTimeMilliseconds() > (waveOutTimer + 1000)) then
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
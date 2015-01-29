scriptId = 'com.bweisel.shipit.crashandburn'
scriptTitle = "Crash and Burn Racing"
scriptDetailsUrl = ""

description = [[
Crash and Burn Racing
]]
 
 link = [[]]
 
 controls = [[
Controls:
- TBD
 ]]
 
 knownIssues = [[
- Many
 ]]
 
centreYaw = 0
centreRoll = 0

deltaRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .2
MOUSE_CONTROL_TOGGLE_DURATION = 1000

PI = 3.1416
TWOPI = PI * 2

flyingLeft = false
flyingRight = false

toggleMouseControl = true
mouseEnabled = true

printCount = 0

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    local titleMatch = string.match(title, "Crash and Burn") ~= nil or platform == "Windows" and app == "Crash&Burn.exe"
    myo.controlMouse(titleMatch and mouseEnabled);
    if (titleMatch) then
		myo.debug("Title Match")
        myo.setLockingPolicy("none")
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	if (mouseEnabled) then
		if (edge == "on") then
			if (pose == "doubleTap") then
				leftClick()
			elseif (pose == "fist") then
				enableGameMode()
			end
		end
	else
		if (edge == "on") then
			if (pose == "fist") then
				myo.debug("fist")
				shoot()
			elseif (pose == "waveIn") then
				pause()
			elseif (pose == "doubleTap") then
				enableMenuMode()
			end
		else
			flyNeutral()
		end
	end
end

function activeAppName()
    return "Crash and Burn"
end

function onPeriodic()
    local currentYaw = myo.getYaw()
    local currentRoll = myo.getRoll()
    local deltaYaw = calculateDeltaRadians(currentYaw, centreYaw)
    deltaRoll = calculateDeltaRadians(currentRoll, centreRoll);
    printCount = printCount + 1
    if printCount >= 200 then
        myo.debug("deltaYaw = " .. deltaYaw .. ", centreYaw = " .. centreYaw .. ", currentYaw = " .. currentYaw)
        myo.debug("deltaRoll = " .. deltaRoll .. " currentRoll = " .. currentRoll)
        printCount = 0
    end
	
	if (deltaRoll < -ROLL_DEADZONE) then
        flyLeft()
    elseif (deltaRoll > ROLL_DEADZONE) then
		flyRight()
    else
        flyNeutral()
    end
end

function flyLeft()
    if (flyingRight) then
        myo.keyboard("d", "up")
        flyingRight = false
    end
    if (not flyingLeft) then
        myo.keyboard("a", "down")
        flyingLeft = true;
    end
end

function flyRight()
    if (flyingLeft) then
        myo.keyboard("a", "up")
        flyingLeft = false
    end
    if (not flyingRight) then
        myo.keyboard("d", "down")
        flyingRight = true
    end
end

function shoot()
	myo.keyboard("space", "press")
    myo.debug("Boom!")
	myo.vibrate("short")
end

function flyNeutral()
    if  (flyingLeft) then
        myo.keyboard("a", "up")
        flyingLeft = false
    end
    if (flyingRight) then
        myo.keyboard("d", "up")
        flyingRight = false
    end
end

function calculateDeltaRadians(currentYaw, centreYaw)
    local deltaYaw = currentYaw - centreYaw
    
    if (deltaYaw > PI) then
        deltaYaw = deltaYaw - TWOPI
    elseif(deltaYaw < -PI) then
        deltaYaw = deltaYaw + TWOPI
    end
    return deltaYaw
end

function enableGameMode()
    mouseEnabled = false
    myo.vibrate("short")
    center()
    myo.controlMouse(mouseEnabled);
end

function enableMenuMode()
    mouseEnabled = true
    myo.vibrate("short")
	centreYaw = 0
    myo.controlMouse(mouseEnabled);
end

function center()
    centreYaw = myo.getYaw()
    centreRoll = myo.getRoll()
end

function leftClick()
    myo.mouse("left", "click")
end

function pause()
    centreYaw = 0
    myo.keyboard("escape", "press")
end 
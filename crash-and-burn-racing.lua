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
 
centerYaw = 0
centerRoll = 0

deltaRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .2
MOUSE_CONTROL_TOGGLE_DURATION = 1000

PI = 3.1416
TWOPI = PI * 2

movingLeft = false
movingRight = false

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
			moveNeutral()
		end
	end
end

function activeAppName()
    return "Crash and Burn"
end

function onPeriodic()
    -- local currentYaw = myo.getYaw()
    -- local deltaYaw = calculateDeltaRadians(currentYaw, centerYaw)
	local currentRoll = myo.getRoll()
    deltaRoll = calculateDeltaRadians(currentRoll, centerRoll);
	
	if (not mouseEnabled) then
		if (deltaRoll < -ROLL_DEADZONE) then
			moveLeft()
		elseif (deltaRoll > ROLL_DEADZONE) then
			moveRight()
		else
			moveNeutral()
		end
	end
end

function moveLeft()
    if (movingRight) then
        myo.keyboard("d", "up")
        movingRight = false
    end
    if (not movingLeft) then
        myo.keyboard("a", "down")
        movingLeft = true;
    end
end

function moveRight()
    if (movingLeft) then
        myo.keyboard("a", "up")
        movingLeft = false
    end
    if (not movingRight) then
        myo.keyboard("d", "down")
        movingRight = true
    end
end

function shoot()
	myo.keyboard("space", "press")
    myo.debug("Boom!")
	myo.vibrate("short")
end

function moveNeutral()
    if  (movingLeft) then
        myo.keyboard("a", "up")
        movingLeft = false
    end
    if (movingRight) then
        myo.keyboard("d", "up")
        movingRight = false
    end
end

function calculateDeltaRadians(currentYaw, centerYaw)
    local deltaYaw = currentYaw - centerYaw
    
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
	centerYaw = 0
    myo.controlMouse(mouseEnabled);
    myo.centerMousePosition();
end

function center()
    centerYaw = myo.getYaw()
    centerRoll = myo.getRoll()
end

function leftClick()
    myo.mouse("left", "click")
end

function pause()
    centerYaw = 0
    myo.keyboard("escape", "press")
end

scriptId = 'com.bweisel.shipit.mariokart64'
scriptTitle = "Mario Kart 64"
scriptDetailsUrl = ""

description = [[
Mario Kart 64
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

startingYaw = 0
currentYaw = 0

centreRoll = 0
deltaRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .2
MOUSE_CONTROL_TOGGLE_DURATION = 1000

PI = 3.1416
TWOPI = PI * 2

turningLeft = false
turningRight = false

toggleMouseControl = true
mouseEnabled = true

printCount = 0

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	-- Project64.exe, MARIOKART64 - Project64 Version 1.6
    local titleMatch = string.match(title, "MARIOKART64 - Project64 Version 1.6") ~= nil or platform == "Windows" and app == "Project64.exe"
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
    return "Mario Kart 64"
end

function onPeriodic()
    -- local currentYaw = myo.getYaw()
    -- local deltaYaw = calculateDeltaRadians(currentYaw, centreYaw)
	local currentRoll = myo.getRoll()
    deltaRoll = calculateDeltaRadians(currentRoll, centreRoll);
	
	if (not mouseEnabled) then
		if (deltaRoll < -ROLL_DEADZONE) then
			turnLeft()
		elseif (deltaRoll > ROLL_DEADZONE) then
			turnRight()
		else
			flyNeutral()
		end
	end
end

function turnLeft()
    if (turningRight) then
        myo.keyboard("d", "up")
        turningRight = false
    end
    if (not turningLeft) then
        myo.keyboard("a", "down")
        turningLeft = true;
    end
end

function turnRight()
    if (turningLeft) then
        myo.keyboard("a", "up")
        turningLeft = false
    end
    if (not turningRight) then
        myo.keyboard("d", "down")
        turningRight = true
    end
end

function shoot()
	myo.keyboard("space", "press")
    myo.debug("Boom!")
	myo.vibrate("short")
end

function flyNeutral()
    if  (turningLeft) then
        myo.keyboard("a", "up")
        turningLeft = false
    end
    if (turningRight) then
        myo.keyboard("d", "up")
        turningRight = false
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
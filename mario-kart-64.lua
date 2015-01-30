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

centerRoll = 0
deltaRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .3
MOUSE_CONTROL_TOGGLE_DURATION = 1000

PI = 3.1416
TWOPI = PI * 2

turningLeft = false
turningRight = false

isAccelerating = false
goTime = false

printCount = 0

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	-- Project64.exe, MARIOKART64 - Project64 Version 1.6
    local titleMatch = string.match(title, "MARIOKART64 - Project64 Version 1.6") ~= nil or platform == "Windows" and app == "Project64.exe"
	--local titleMatch = app == "notepad++.exe"
	
    if (titleMatch) then
		myo.debug("Title Match")
        myo.setLockingPolicy("none")
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	if (edge == "on") then
		if (pose == "fist") then
			activateWeapon()
		elseif (pose == "doubleTap") then
			toggleDrive()
		elseif (pose == "fingersSpread") then
			calibrate()
		end
	else
		driveStraight()
	end
end

function activeAppName()
    return "Mario Kart 64"
end

function onPeriodic()
    -- local currentYaw = myo.getYaw()
    -- local deltaYaw = calculateDeltaRadians(currentYaw, centreYaw)
	local currentRoll = myo.getRoll()
    deltaRoll = calculateDeltaRadians(currentRoll, centerRoll);
	
	if (printCount > 200) then
		myo.debug("currentRoll: " .. currentRoll)
		myo.debug("centerRoll: " .. centerRoll)
		myo.debug("deltaRoll: " .. deltaRoll)
		printCount = 0
	else
		printCount = printCount + 1
	end
	
	if (deltaRoll < -ROLL_DEADZONE) then
		turnLeft()
	elseif (deltaRoll > ROLL_DEADZONE) then
		turnRight()
	else
		driveStraight()
	end
end

function driveStraight()
    if  (turningLeft) then
        myo.keyboard("j", "up")
        turningLeft = false
    end
    if (turningRight) then
        myo.keyboard("l", "up")
        turningRight = false
    end
end

function turnLeft()
    if (turningRight) then
        myo.keyboard("l", "up")
        turningRight = false
    end
    if (not turningLeft) then
		myo.debug("Trying to turn left!")
        myo.keyboard("j", "down")
        turningLeft = true;
    end
end

function turnRight()
    if (turningLeft) then
        myo.keyboard("j", "up")
        turningLeft = false
    end
    if (not turningRight) then
		myo.debug("Trying to turn right!")
        myo.keyboard("l", "down")
        turningRight = true
    end
end

function activateWeapon()
	myo.debug("activate weapon")
	myo.keyboard("z", "press")
	myo.vibrate("short")
end

function releaseWeapon()
	myo.keyboard("z", "up")
    myo.debug("Boom!")
	myo.vibrate("short")
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

function toggleDrive()
	isAccelerating = not isAccelerating
	if (isAccelerating) then
		myo.keyboard("x", "up")
		myo.debug("stopping acceleration")
	else
		myo.keyboard("x", "down")
		myo.debug("starting acceleration")
	end
end

function calibrate()
	centerRoll = myo.getRoll()
	myo.debug("Calibrate!")
	myo.debug("centerRoll: " .. centerRoll)
end
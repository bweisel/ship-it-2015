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

togglingMouseControl = 0
mouseEnabled = false

printCount = 0

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    local titleMatch = string.match(title, "Crash and Burn") ~= nil or platform == "Windows" and app == "Crash&Burn.exe"
    myo.controlMouse(titleMatch and mouseEnabled);
    if (titleMatch) then
		myo.debug("Title Match")
        myo.setLockingPolicy("none")
		centre()
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
    if (edge == "on") then
		myo.debug("edge on")
		if (pose == "fist") then
			myo.debug("fist")
			jump()
		end
        --if (pose == "fist") then
        --    centre()
        --    if (mouseEnabled) then
        --        toggleMouseControl()
        --    end
        --elseif (pose == "fingersSpread") then
        --    escape();
        --elseif (pose == "waveIn" or pose == "waveOut") then
        --    if (math.abs(deltaRoll) > ROLL_DEADZONE) then
        --        jump()
        --    elseif (pose == "waveIn") then
        --        leftClick()
        --    else
        --       if (mouseEnabled) then
        --            toggleMouseControl();
        --        else
        --            togglingMouseControl = myo.getTimeMilliseconds();
        --        end
        --    end
        --end
    else
        flyNeutral()
		--togglingMouseControl = 0
    end
end

function activeAppName()
    return "Crash and Burn"
end

function centre()
    --myo.debug("Centred")
    centreYaw = myo.getYaw()
    centreRoll = myo.getRoll()
    myo.controlMouse(false);
    myo.vibrate("short")
    -- BEN myo.keyboard("return", "press")
end

function onPeriodic()
    -- BEN if (togglingMouseControl > 0 and myo.getTimeMilliseconds() > (togglingMouseControl + MOUSE_CONTROL_TOGGLE_DURATION)) then
    -- BEN     togglingMouseControl = 0
    -- BEN     toggleMouseControl()
    -- BEN  end
    --if (centreYaw == 0) then
	--	myo.debug("returning; center yaw = 0")
    --   return
    --end
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
    if (deltaYaw < -YAW_DEADZONE) then
        flyLeft()
    elseif (deltaYaw > YAW_DEADZONE) then
		flyRight()
    else
        flyNeutral()
    end
end

function flyLeft()
    if (flyingRight) then
        myo.keyboard("d","up")
        flyingRight = false
    end
    if (not flyingLeft) then
        myo.keyboard("a","down")
        flyingLeft = true;
    end
end

function flyRight()
    if (flyingLeft) then
        myo.keyboard("a","up")
        flyingLeft = false
    end
    if (not flyingRight) then
        myo.keyboard("d","down")
        flyingRight = true
    end
end

function jump()
    myo.debug("Jump!")
	myo.vibrate("short")
    myo.keyboard("space","press")
end

function flyNeutral()
    if  (flyingLeft) then
        myo.keyboard("a","up")
        flyingLeft = false
    end
    if (flyingRight) then
        myo.keyboard("d","up")
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

function toggleMouseControl()
    mouseEnabled = not mouseEnabled
    myo.vibrate("medium")
    if (mouseEnabled) then
        --myo.debug("Mouse control enabled")        
        centreYaw = 0
        flyNeutral()
    else
        --myo.debug("Mouse control disabled")
    end
    myo.controlMouse(mouseEnabled);
end

function leftClick()
    --myo.debug("Left click!")
    myo.mouse("left", "click")
end

function escape()
    --myo.debug("Escape!")
    centreYaw = 0
    myo.keyboard("escape","press")
end 
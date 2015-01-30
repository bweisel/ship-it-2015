scriptId = 'com.bweisel.shipit.test'
scriptTitle = "Test Script"
scriptDetailsUrl = ""

description = [[
Testing script
]]
 
 link = [[]]
 
 controls = [[
Controls:
- TBD
 ]]
 
 knownIssues = [[
- Many
 ]]

centerRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .3

PI = 3.1416
TWOPI = PI * 2

turningLeft = false
turningRight = false

isAccelerating = false

printCount = 0

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	local titleMatch = app == "notepad++.exe"
	
    if (titleMatch) then
		myo.debug("Title Match")
        myo.setLockingPolicy("none")
    end
    return titleMatch;
end

function onPoseEdge(pose, edge)
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
end

function onPeriodic()
	local x,y,z = myo.getOrientationWorld()
	
	local roll = myo.getRoll()
	
	if (printCount > 100) then
		myo.debug("x: " .. x)
		myo.debug("y: " .. y)
		myo.debug("z: " .. z)
		myo.debug("")
		myo.debug("roll: " .. roll)
		myo.debug("")
		
		printCount = 0
	else
		printCount = printCount + 1
	end
end



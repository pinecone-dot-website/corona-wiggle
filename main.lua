
system.activate( "multitouch" )

local physics = require "physics"
local dragable = require "com.ponywolf.dragable"
local vjoy = require "com.ponywolf.vjoy"

physics.start()

local floor = display.newRect(240, 320, display.actualContentWidth, 50)
floor:setFillColor(0.2, 0.2, 1)
physics.addBody(floor, "static", {bounce = .5})

local ceil = display.newRect(240, 0, display.actualContentWidth, 50)
ceil:setFillColor(0.2, 0.2, 1)
physics.addBody(ceil, "static", {bounce = .5})


local wall_left = display.newRect(display.contentWidth - display.actualContentWidth + 50, display.actualContentHeight/2, 50, display.actualContentHeight)
wall_left:setFillColor(0.2, 0.2, 1)
physics.addBody(wall_left, "static", {bounce = .5})

local wall_right = display.newRect(display.actualContentWidth - 50, display.actualContentHeight/2, 50, display.actualContentHeight)
wall_right:setFillColor(0.2, 0.2, 1)
physics.addBody(wall_right, "static", {bounce = .5})

local bodies = {
    display.newCircle(100, 200, 14),
    display.newCircle(100, 210, 16),
    display.newCircle(100, 220, 14),
    display.newCircle(100, 230, 12),
    display.newCircle(100, 240, 10)
}

for i = 1, #bodies do
    if (i == 3) then
        -- dragable.new(bodies[i])
        -- center
        physics.addBody(
            bodies[i],
            "dynamic",
            {
                bounce = 1,
                density = 2
            }
        )
    else
        physics.addBody(
            bodies[i],
            "dynamic",
            {
                bounce = .5,
                density = 1
            }
        )
    end

    if (i ~= 1) then
        local j = physics.newJoint("rope", bodies[i - 1], bodies[i], 0, 0, 0, 0)
        j.maxLength = 14
    end

    if (i == 3) then
    -- dragable.new(bodies[i])
    end
end

local axis = {
    0,
    0
}

local function onAxis(event)
    axis[event.axis.number] = event.normalizedValue

    -- local angle = math.deg(math.atan2(axis[1], axis[2]))
    -- print("onAxis", event.axis.number, event.normalizedValue, angle)
end
Runtime:addEventListener("axis", onAxis)

local joy = vjoy.newStick(1, 20, 40)
joy.x, joy.y = 10, display.actualContentHeight - 40

local btn_space = vjoy.newButton("space", 20)
btn_space.x, btn_space.y = display.actualContentWidth - 80, display.actualContentHeight - 40

local function keyDown(event)
    -- print("player keyDown event.keyName", event.keyName)

    if (event.phase == "down") then
        -- right
        if (event.keyName == "space") then
            bodies[3]:applyForce(axis[1] * 2000, axis[2] * 2000, bodies[3].x, bodies[3].y)
        end
    end
end

Runtime:addEventListener("key", keyDown)

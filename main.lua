system.activate("multitouch")

local physics = require "physics"
local dragable = require "com.ponywolf.dragable"
local vjoy = require "com.ponywolf.vjoy"

physics.start()
physics.setGravity(0, 100)
-- physics.setDrawMode( "hybrid" )

local wall_dims = {
    bounce = .1,
    friction = 1
}

local floor = display.newRect(240, 320, display.actualContentWidth, 50)
floor:setFillColor(0.2, 0.2, 1)
physics.addBody(floor, "static", wall_dims)

local ceil = display.newRect(240, 0, display.actualContentWidth, 50)
ceil:setFillColor(0.2, 0.2, 1)
physics.addBody(ceil, "static", wall_dims)

local wall_left =
    display.newRect(
    display.contentWidth - display.actualContentWidth + 50,
    display.actualContentHeight / 2,
    50,
    display.actualContentHeight
)
wall_left:setFillColor(0.2, 0.2, 1)
physics.addBody(wall_left, "static", wall_dims)

local wall_right =
    display.newRect(display.actualContentWidth - 50, display.actualContentHeight / 2, 50, display.actualContentHeight)
wall_right:setFillColor(0.2, 0.2, 1)
physics.addBody(wall_right, "static", wall_dims)

local bodies = {}

local body_dims = {
    start_radius = 1,
    mid_radius = 12,
    units_count = 7
}

local body_half = math.ceil(body_dims.units_count / 2)

for i = 1, body_dims.units_count do
    local increment = (body_dims.mid_radius - body_dims.start_radius) / (body_dims.units_count - 1)
    local arc = math.abs(i - body_half)
    local radius = body_dims.mid_radius - (arc * increment)

    -- print("arc", arc)
    -- print("radius", radius)

    bodies[i] = display.newCircle(100 + (increment * i * 2), 100, radius)

    bodies[i].isFixedRotation = true
    bodies[i]:setFillColor(1, 1 / (body_dims.units_count - i + 1), 0, 1)

    physics.addBody(
        bodies[i],
        "dynamic",
        {
            bounce = 0,
            density = 1,
            friction = 1,
            radius = radius
        }
    )

    if (i ~= 1) then
        local j = physics.newJoint("rope", bodies[i - 1], bodies[i], 0, 0, 0, 0)
        j.maxLength = radius 
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
    print(event.axis.number, event.normalizedValue)
    axis[event.axis.number] = event.normalizedValue

    local angle = math.deg(math.atan2(axis[1], axis[2]))
    -- print("onAxis", event.axis.number, event.normalizedValue, math.floor(angle))
end
Runtime:addEventListener("axis", onAxis)

local joy = vjoy.newStick(1, 20, 40)
joy.x, joy.y = 10, display.actualContentHeight - 40

local btn_space = vjoy.newButton("space", 20)
btn_space.x, btn_space.y = display.actualContentWidth - 80, display.actualContentHeight - 40

local can_jump = {
    0,
    0,
    0
}

local function keyDown(event)
    print(event.keyName)
    if (event.phase == "down") then
        -- right
        if (event.keyName == "space" or event.keyName == "button1" or event.keyName == "buttonB") then
            if (can_jump[1]) then
                bodies[1]:applyForce(axis[1] * 500, axis[2] * 2500, bodies[1].x, bodies[1].y)
            end

            if (can_jump[2]) then
                bodies[body_half]:applyForce(axis[1] * 1000, axis[2] * 2500, bodies[body_half].x, bodies[body_half].y)
            end

            if (can_jump[3]) then
                bodies[body_dims.units_count]:applyForce(
                    axis[1] * 500,
                    axis[2] * 2500,
                    bodies[body_dims.units_count].x,
                    bodies[body_dims.units_count].y
                )
            end
        end
    end
end

Runtime:addEventListener("key", keyDown)

local function onLocalCollision(self, event)
    if (event.other == bodies[1]) then
        can_jump[1] = event.phase == "began"
    end

    if (event.other == bodies[body_half]) then
        can_jump[2] = event.phase == "began"
    end

    if (event.other == bodies[body_dims.units_count]) then
        can_jump[3] = event.phase == "began"
    end
end

floor.collision = onLocalCollision
floor:addEventListener("collision")

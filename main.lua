system.activate("multitouch")

display.setStatusBar(display.HiddenStatusBar)

local physics = require "physics"
local dragable = require "com.ponywolf.dragable"
local vjoy = require "com.ponywolf.vjoy"

physics.start()
physics.setGravity(0, 100)
-- physics.setGravity(0, 100)
-- physics.setDrawMode( "hybrid" )

-- floor and ceiling
local floor_dims = {
    bounce = 0,
    friction = 1
}

local floor = display.newRect(240, 320, display.actualContentWidth, 50)
floor:setFillColor(0.2, 0.2, 1)
physics.addBody(floor, "static", floor_dims)

local ceil = display.newRect(240, 0, display.actualContentWidth, 50)
ceil:setFillColor(0.2, 0.2, 1)
physics.addBody(ceil, "static", floor_dims)

-- side walls
local wall_dims = {
    bounce = .5,
    friction = .5
}
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

local worm = require("lib.worm")
local body_dims = {
    start_radius = 2,
    mid_radius = 14,
    units_count = 33
}

player = worm.new(body_dims)

local joy = vjoy.newStick(1, 20, 40)
joy.x, joy.y = 10, display.actualContentHeight - 40

local btn_space = vjoy.newButton("space", 20)
btn_space.x, btn_space.y = display.actualContentWidth - 80, display.actualContentHeight - 40

-- local function onLocalCollision(self, event)
--     if (event.other == bodies[1]) then
--         can_jump[1] = event.phase == "began"
--     end

--     if (event.other == bodies[body_half]) then
--         can_jump[2] = event.phase == "began"
--     end

--     if (event.other == bodies[body_dims.units_count]) then
--         can_jump[3] = event.phase == "began"
--     end
-- end

-- floor.collision = onLocalCollision
-- floor:addEventListener("collision")

local _ball = require("lib.ball")
local ball_dims = {
    color = {.81, .32, 0},
    gravityScale = 0,
    physics = {
        bounce = 1,
        density = 10,
        friction = 1,
        radius = 10
    },
    radius = 20,
    start_x = 400,
    start_y = 100
}

local ball = _ball.new(ball_dims)

ball_2 = _ball.new({
    color = {.81, .32, 0},
    gravityScale = .25,
    physics = {
        bounce = 1,
        density = 5,
        friction = 1,
        radius = 10
    },
    radius = 20,
    start_x = 400,
    start_y = 200
})
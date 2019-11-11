local M = {}

-- body_dims = {
--     start_radius = 4,
--     mid_radius = 14,
--     units_count = 27
-- }
function M.new(body_dims)
    print(body_dims)

    local bodies = {}
    local body_half = math.ceil(body_dims.units_count / 2)
    local body_interval = math.ceil(body_half / 2)

    -- worm has 3 points in body that accelerate
    local can_jump = {
        1,
        1,
        1
    }

    --
    local axis = {
        0,
        0
    }

    --
    local force = {
        tail = (((body_dims.start_radius + body_dims.mid_radius) / 2) * body_dims.units_count) / 1,
        mid = (body_dims.mid_radius + body_dims.start_radius) * 100
    }

    print("force", force.tail, force.mid)

    for i = 1, body_dims.units_count do
        local increment = (body_dims.mid_radius - body_dims.start_radius) / ((body_dims.units_count / 2) - 1)
        local arc = math.abs(i - body_half)
        local radius = body_dims.mid_radius - (arc * increment)

        -- print("arc", arc)
        print("radius", radius)

        bodies[i] = display.newCircle(100 + (increment * i * 2), 100, radius)

        -- bodies[i].isFixedRotation = true

        local color_fade = (body_dims.units_count - i) / body_dims.units_count
        -- print("color_fade", color_fade)
        bodies[i]:setFillColor((color_fade / 2) + .5, (color_fade / 2) + .25, (color_fade / 2) + .1, 1)

        physics.addBody(
            bodies[i],
            "dynamic",
            {
                bounce = 0,
                density = 2,
                friction = 1,
                radius = radius / 2
            }
        )

        if (i ~= 1) then
            local j = physics.newJoint("rope", bodies[i - 1], bodies[i], 0, 0, 0, 0)
            j.maxLength = radius / 2
        end
    end

    local function pulseBody(body, x_val, y_val, force)
        body:applyForce(x_val * force, y_val * force * 2, body.x, body.y)
    end

    local function keyDown(event)
        -- print(event.keyName)
        if (event.phase == "down") then
            -- right
            if (event.keyName == "space" or event.keyName == "button1" or event.keyName == "buttonB") then
                if (can_jump[1]) then
                    pulseBody(bodies[body_interval], axis[1] * 4, axis[2] * 2, force.tail)
                end

                if (can_jump[2]) then
                    pulseBody(bodies[body_half], axis[1], axis[2] * 2 , force.mid)
                end

                if (can_jump[3]) then
                    pulseBody(bodies[body_dims.units_count - body_interval], axis[1] * 4, axis[2]* 2, force.tail)
                end
            end
        end
    end

    Runtime:addEventListener("key", keyDown)

    local function onAxis(event)
        -- print(event.axis.number, event.normalizedValue)
        axis[event.axis.number] = event.normalizedValue

        local angle = math.deg(math.atan2(axis[1], axis[2]))
        -- print("onAxis", event.axis.number, event.normalizedValue, math.floor(angle))
    end
    Runtime:addEventListener("axis", onAxis)
end

return M

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
    local body_units = {}
    local connectors = {}

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
        tail = (((body_dims.start_radius + body_dims.mid_radius) / 2) * body_dims.units_count) * 2,
        mid = (body_dims.mid_radius + body_dims.start_radius) * 100
    }

    print("force", force.tail, force.mid)

    for i = 1, body_dims.units_count do
        local increment = (body_dims.mid_radius - body_dims.start_radius) / ((body_dims.units_count / 2) - 1)
        local arc = math.abs(i - body_half)
        local radius = body_dims.mid_radius - (arc * increment)

        -- print("arc", arc)
        print("radius", radius)

        bodies[i] = display.newCircle(100 + (increment * i * 2), 100 + (increment * i * 2), radius)
        bodies[i].radius = radius

        -- bodies[i].isFixedRotation = true

        local color_fade = (body_dims.units_count - i) / body_dims.units_count
        local color = {(color_fade / 2) + .5, (color_fade / 2) + .25, (color_fade / 2) + .1, 1}

        -- -- print("color_fade", color_fade)
        bodies[i]:setFillColor(unpack(color))
        bodies[i].color = color
        -- bodies[i]:setFillColor(.75, .75, .75, .95)

        -- if (i < body_half) then
        --     bodies[i]:setFillColor(.75, .75, .75, 1)
        -- elseif (i > body_half) then
        --     bodies[i]:setFillColor(.9, .9, .9, 1)
        -- else
        --     bodies[i]:setFillColor(.85, .85, .85, 1)
        -- end

        physics.addBody(
            bodies[i],
            "dynamic",
            {
                bounce = 0,
                density = 1, --(i / body_dims.units_count) * i,
                friction = 0,
                radius = radius
            }
        )

        -- add rope joint
        if (i ~= 1) then
            local j = physics.newJoint("rope", bodies[i - 1], bodies[i], 0, 0, 0, 0)
            j.maxLength = (bodies[i].radius + bodies[i].radius)
        end
    end

    local function pulseBody(body, x_val, y_val, force)
        body:applyForce(x_val * force, y_val * force * 2, body.x, body.y)
    end

    local jump_units = {
        body_interval,
        body_half,
        body_dims.units_count - body_interval + 1
    }
    print("jump_units", jump_units[1], jump_units[2], jump_units[3])
    local function keyDown(event)
        -- print(event.keyName)
        if (event.phase == "down") then
            -- right
            if (event.keyName == "space" or event.keyName == "button1" or event.keyName == "buttonB") then
                if (can_jump[1]) then
                    pulseBody(bodies[jump_units[1]], axis[1] * 4, axis[2] * 4, force.tail)
                end

                if (can_jump[2]) then
                    pulseBody(bodies[jump_units[2]], axis[1] * 4, axis[2] * 4, force.mid)
                end

                if (can_jump[3]) then
                    pulseBody(bodies[jump_units[3]], axis[1] * 4, axis[2] * 4, force.tail)
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

    local function onFrame(event)
        for i = 2, body_dims.units_count do
            local c = bodies[i].color
            local r = bodies[i].radius

            -- draw lines connecting center point of each circle
            display.remove(connectors[i])
            display.remove(body_units[i])

            connectors[i] = display.newLine(bodies[i].x, bodies[i].y, bodies[i - 1].x, bodies[i - 1].y)
            -- connectors[i]:setStrokeColor(1, 0, 0, .25)
            connectors[i]:setStrokeColor(unpack(c))
            connectors[i].strokeWidth = r * 2

            -- draw line at right angle

            -- local angle =
            --     math.deg(math.atan2((bodies[i].y - bodies[i - 1].y) / 2, (bodies[i].x + bodies[i - 1].x)) / 2) + 90



            -- local pt_a = {
            --     x = ((bodies[i].x + bodies[i - 1].x) / 2) + (r * math.cos(angle)),
            --     y = ((bodies[i].y + bodies[i - 1].y) / 2) + (r * math.sin(angle))
            -- }

            -- local pt_b = {
            --     x = ((bodies[i].x + bodies[i - 1].x) / 2) - (r * math.cos(angle)),
            --     y = ((bodies[i].y + bodies[i - 1].y) / 2) - (r * math.sin(angle))
            -- }

            -- body_units[i] = display.newLine(pt_a.x, pt_a.y, pt_b.x, pt_b.y)
            -- body_units[i]:setStrokeColor(0, 1, 0, .5)
            -- body_units[i].strokeWidth = 2
        end

        for i = 2, body_dims.units_count do
            local r = bodies[i].radius

            local pt_half = {
                x = (bodies[i].x + bodies[i - 1].x) / 2,
                y = (bodies[i].y + bodies[i - 1].y) / 2
            }
            body_units[i] = display.newCircle(pt_half.x, pt_half.y, r / 2)
            -- body_units[i]:setFillColor(unpack(c))
            body_units[i]:setFillColor(.9, .7, .5, .1)
        end
    end
    Runtime:addEventListener("enterFrame", onFrame)
end

return M

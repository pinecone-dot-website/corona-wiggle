local M = {}

function M.new(ball_dims)
    local ball = display.newCircle(ball_dims.start_x, ball_dims.start_y, ball_dims.radius)
    -- ball.isFixedRotation = true

    print("ball_dims", ball_dims)

    ball:setFillColor(unpack(ball_dims.color)) --CF5300, 207, 83, 0, ball_dims.color

    physics.addBody(ball, "dynamic", ball_dims.physics)

    ball.gravityScale = ball_dims.gravityScale

    return ball
end

return M

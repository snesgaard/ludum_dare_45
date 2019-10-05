local states = {
    ghost={}, golem={}
}

function states.ghost:enter(data)
    data.ghost.body.sprite.hidden = false
    data.control_ui.text = "<- :: move left\n-> :: move right\nr :: possess"
end

function states.ghost:__update(data, dt)
    local x = 0
    if love.keyboard.isDown("left") then
        x = x - 100
    elseif love.keyboard.isDown("right") then
        x = x + 100
    end

    if x > 0 then
        data.ghost.body.sprite.__transform.scale.x = 1
    elseif x < 0 then
        data.ghost.body.sprite.__transform.scale.x = -1
    end

    data.ghost.body.speed.x = x
end

function states.ghost:exit(data)
    data.ghost.body.speed.x = 0
    data.ghost.body.sprite.hidden = true
end

function states.ghost.can_possess(data)
    local body = data.ghost.body
    for i, col in ipairs(body.col) do
        if col.other == data.golem.body.body then return true end
    end
end

function states.ghost:keypressed(data, key)
    if key == "r" and states.ghost.can_possess(data) then
        return self:possess()
    end
end

function states.golem:enter(data)
    data.golem_fsm:wake()
end

function states.golem.should_jump(data)
    if not data.ground_time or not data.jump_time then return end
    if math.abs(data.jump_time - data.ground_time) > 0.15 then return end

    local time = love.timer.getTime()
    if time - data.jump_time > 0.3 or time - data.ground_time > 0.3 then return end
    return true
end

function states.golem:__update(data, dt)
    if data.golem.body:on_ground() then
        data.ground_time = love.timer.getTime()
    end

    local x = 0
    if love.keyboard.isDown("left") then
        x = x - 100
    elseif love.keyboard.isDown("right") then
        x = x + 100
    end

    if x > 0 then
        data.golem.body.sprite.__transform.scale.x = 1
    elseif x < 0 then
        data.golem.body.sprite.__transform.scale.x = -1
    end

    data.golem.body.speed.x = x
    if self.should_jump(data) then
        data.ground_time = nil
        data.jump_time = nil
        data.golem.body.speed.y = -300
    end
end

function states.golem.on_ground(data)
    local body = data.golem.body
    for _, col in ipairs(body.col) do
        if col.type == "slide" and vec2(0, -1):dot(col.normal) > 0.9 then
            return true
        end
    end
end

function states.golem:keypressed(data, key)
    if key == "space" then
        data.jump_time = love.timer.getTime()
    elseif key == "r" then
        return self:spirit()
    end
end

function states.golem:exit(data)
    data.golem.body.speed.x = 0
    data.golem_fsm:leave()
    data.ghost.body:set(data.golem.body.__transform.pos:unpack())
    data.ghost.body.speed.x = data.golem.body.speed.x
    data.ghost.body.speed.y = -300
    data.ghost.body.sprite.__transform.x = data.golem.body.sprite.__transform.x
end

return function(ghost, golem, control_ui)
    return {
        states=states,
        edges={
            {from="ghost", to="golem", name="possess"},
            {from="golem", to="ghost", name="spirit"}
        },
        methods={
            keypressed = function() end,
        },
        data={ghost=ghost, golem=golem, control_ui=control_ui},
        init="ghost",
        create = function(self, data)
            data.golem_fsm = data.golem_fsm or self:child(
                fsm, require("actor.golem_fsm")(
                    data.golem.body.sprite, data.golem.body
                )
            )
        end
    }
end

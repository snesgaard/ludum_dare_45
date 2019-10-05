local states = {
    init = {}, inactive = {}, idle = {}, walk = {}, ascend = {}, descend = {}
}

function states.inactive:enter(data)
    data.sprite:queue({"inactive"})
end

function states.inactive:wake(data)
    if data.body.speed.x == 0 then
        return fsm.force(self, "idle")
    else
        return fsm.force(self, "walk")
    end
end

function states.idle:enter(data)
    data.sprite:queue({"idle"})
end

function states.idle:__update(data, dt)
    if data.body.speed.x ~= 0 then
        return fsm.force(self, "walk")
    elseif data.body.speed.y < 0 then
        return fsm.force(self, "ascend")
    elseif data.body.speed.y > 0 then
        return fsm.force(self, "descend")
    end
end

function states.walk:enter(data)
    data.sprite:queue({"walk"})
end

function states.walk:__update(data)
    if data.body.speed.x == 0 then
        return fsm.force(self, "idle")
    elseif data.body.speed.y < 0 then
        return fsm.force(self, "ascend")
    elseif data.body.speed.y > 0 then
        return fsm.force(self, "descend")
    end
end

function states.ascend:enter(data)
    data.sprite:queue({"ascend"})
end

function states.ascend:__update(data)
    if data.body:on_ground() then
        return fsm.force(self, "idle")
    elseif data.body.speed.y > 0 then
        return fsm.force(self, "descend")
    end
end

function states.descend:enter(data)
    data.sprite:queue({"descend"})
end

function states.descend:__update(data)
    if data.body:on_ground() then
        return fsm.force(self, "idle")
    elseif data.body.speed.y < 0 then
        return fsm.force(self, "ascend")
    end
end

return function(sprite, body)
    return {
        states = states,
        edges = edges,
        data = {sprite=sprite, body=body},
        methods = {leave=function(self, data)
            return fsm.force(self, "inactive")
        end},
        init="inactive"
    }
end

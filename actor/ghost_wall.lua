local wall = {}

function wall:create(world, x, y, w, h)
    self.body = self:child(require "nodeworks.body", world, 0, 0, w, h, "wall")
    self.body:set(x, y)
    self.body.floating = true
    self.blur = moon(moon.effects.gaussianblur)
    self.blur.gaussianblur.setters.sigma(2.0)
end

function wall:setpath(obj)
    local x, w = obj.x, obj.width

    self:fork(function()
        while true do
            local t = tween(
                10.0, self.body.__transform.pos, {x=x}
            ):set(function(val)
                self.body:set_move(val.x, obj.y)
            end)
            event:wait(t, "finish")
        end
    end)
end

function wall:__draw()
    self.blur(function()
        gfx.setColor(1, 0.3, 0.1)
        gfx.rectangle(
            "fill",
            self.body.body:move(self.body.__transform.pos:unpack()):unpack()
        )
        gfx.setColor(1, 1, 1)
    end)
end

return wall

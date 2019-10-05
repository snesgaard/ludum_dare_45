local goal = {}

function goal:create(world, x, y, w, h)
    self.body = self:child(require "nodeworks.body", world, x, y, w, h, "goal")
    self.body.floating = true
end

function goal:__draw()
    gfx.setColor(0.1, 0.3, 1.0)
    gfx.rectangle("fill", self.body.body:unpack())
    gfx.setColor(1, 1, 1)
end

return goal

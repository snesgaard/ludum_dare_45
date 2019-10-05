local wall = {}

function wall:create(world, x, y, w, h)
    self.body = self:child(require "nodeworks.body", world, x, y, w, h, "wall")
    self.body.floating = true
end

function wall:__draw()
    gfx.setColor(1, 0.3, 0.1)
    gfx.rectangle("fill", self.body.body:unpack())
    gfx.setColor(1, 1, 1)
end

return wall

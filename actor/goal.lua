local particle_node = {}

function particle_node:create(w, h)
    local blur = moon(moon.effects.gaussianblur)
    local im = gfx.prerender(10, 10, function(w, h)
        blur(function()
            gfx.circle("fill", w * 0.5, h * 0.5, w * 0.25, 20)
        end)
    end)

    self.part = particles{
        image=im,
        buffer = 90,
        rate=8,
        lifetime={1.0, 3.0} ,
        area={"uniform", w * 0.5, 1},
        emit=0,
        color = {
            1, 1, 1, 0,
            0.3, 0.1, 1, 0.25,
            0.1, 0.2, 1, 0.3,
            1, 1, 1, 0
        },
        size = 2,
        speed = 4.0,
        dir = -math.pi * 0.5
    }

    local im = gfx.prerender(4, 10, function(w, h)
        local rx, ry = w * 0.5, h * 0.5
        gfx.ellipse("fill", rx, ry, rx, ry)
    end)

    self.part2 = particles{
        image=im,
        buffer=90,
        rate=8,
        lifetime=0.5,
        area={"uniform", w * 0.5, h * 0.5},
        color={1, 0.8, 0.3, 0.5},
        size=0.5,
        speed=20,
        dir = -math.pi * 0.5
    }

    for i = 0, 60 do
        self.part:update(0.016)
        self.part2:update(0.016)
    end
end

function particle_node:__update(dt)
    self.part:update(dt)
    self.part2:update(dt * 2)
end

function particle_node:__draw(x, y)
    gfx.draw(self.part2, x, y)
    gfx.setBlendMode("add")
    gfx.draw(self.part, x, y)
    gfx.setBlendMode("alpha")
end


local goal = {}

local atlas_path = "art/actor"

local animations = {
    idle="goal"
}

function goal:create(world, x, y, w, h)
    self.body = self:child(require "nodeworks.body", world, 0, 0, w, h, "goal")
    self.body:set(x, y)
    self.body.floating = true
    self.body.particles = self.body:child(particle_node, w, h)
    self.body.particles.__transform.pos.x = w / 2
    self.body.particles.__transform.pos.y = h / 2
    self.body.sprite = self.body:child(Sprite, animations, atlas_path)
    self.body.sprite.__transform.pos.x = w / 2
    self.body.sprite.__transform.pos.y = h
    self.body.sprite:queue({"idle"})
end

function goal:__draw()
    gfx.setColor(0.1, 0.3, 1.0)
    gfx.setColor(1, 1, 1)
end

return goal

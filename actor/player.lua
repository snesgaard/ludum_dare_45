local atlas_path = "art/actor"

local ghost_animations = {
    idle="ghost_move"
}

local golem_animations = {
    inactive="golem_idle/inactive",
    idle="golem_idle/idle",
    walk="golem_idle/walk",
    ascend="golem_idle/ascend",
    descend="golem_idle/descend",
}

local player = {
    ghost={}, golem={}
}

local w, h = 10, 20

function player.ghost:create(world)
    self.body = self:child(require "nodeworks.body", world, 0, 0, w, h)
        :type("ghost")

    self.body.sprite = self.body:child(Sprite, ghost_animations, atlas_path)
    self.body.sprite.__transform.pos.x = w / 2
    self.body.sprite.__transform.pos.y = h
    self.body.sprite:queue({"idle"})
end

function player.ghost:__update(dt)
end

function player.golem:create(world)
    self.body = self:child(require "nodeworks.body", world, 0, 0, w, h)
        :type("physical")

    self.body.sprite = self.body:child(Sprite, golem_animations, atlas_path)
    self.body.sprite.__transform.pos.x = w / 2
    self.body.sprite.__transform.pos.y = h
    self.body.sprite:queue({"inactive"})
end

function player.golem:__update(dt)
end

return player

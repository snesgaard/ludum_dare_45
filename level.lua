local level = {}

function level.load(path, actor_init)
    local world = bump.newWorld()
    local level = sti(path, { "bump" })
    level:bump_init(world)
    level.world = world

    local actor_layer = level:addCustomLayer("actor_layer",1)
    actor_layer.root = Node.create()

    function actor_layer:update(dt)
        self.root:update(dt, world)
    end

    function actor_layer:draw()
        self.root:draw()
    end

    function actor_layer:actor(path, ...)
        local path = string.split(path, ':')
        if #path == 1 then
            return self.root:child(require(path[1]), world, ...)
        else
            local m = require(path[1])
            return self.root:child(m[path[2]], world, ...)
        end
    end

    local actor_init_layer = level.layers["actor_init"]
    actor_init_layer.visible = false

    local bg_layer = level:addCustomLayer("bg_layer",1)

    function bg_layer:draw()
        gfx.push()
        gfx.origin()
        gfx.setColor(0.3, 0.3, 0.5)
        gfx.rectangle("fill", 0, 0, gfx.getWidth(), gfx.getHeight())
        gfx.setColor(1, 1, 1)
        gfx.pop()
    end

    return level
end

function level.actor_init(level, actor_init)
    local actor_init_layer = level.layers["actor_init"]

    for _, obj in pairs(actor_init_layer.objects) do
        local f = actor_init[obj.type]
        if f then f(level, obj) end
    end
end

return level

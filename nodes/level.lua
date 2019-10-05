local level = {}

function level.load(path)
    local world = bump.newWorld()
    local level = sti(path, { "bump" })
    level:bump_init(world)
    level.world = world

    local actor_layer = level:addCustomLayer("actor_layer", 1)
    actor_layer.root = Node.create()

    function actor_layer:update(dt)
        self.root:update(dt)
    end

    function actor_layer:draw()
        self.root:draw()
    end

    return level
end

return level

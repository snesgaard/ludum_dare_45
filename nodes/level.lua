local level = {}

function level.load(path)
    log.info("JASHDJKHASDJK")
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

    table.sort(level.layers, function(a, b)
        print(a.type, b.type)
        local va = a.type == "customlayer" and 1 or 2
        local vb = b.type == "customlayer" and 1 or 2
        return va > vb
    end)

    return level
end

return level

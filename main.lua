require "nodeworks"
require "lovedebug"
require "bumpdebug"
local level_io = require "level"

levels_paths = list(
    "art/maps/build/levelB.lua", "art/maps/build/levelC.lua",
    "art/maps/build/levelD.lua", "art/maps/build/levelE.lua",
    "art/maps/build/levelF.lua", "art/maps/build/levelG.lua"
)
start_index = 6
level_index = 0

function level_from_index(index)
    level_index = index
    golems = {}
    local path = levels_paths[level_index]
    if not path then
        level = nil
        actor_layer = nil
        control_fsm = nil
        end_time = love.timer.getTime()
        return
    end

    level = level_io.load(path)
    actor_layer = level.layers["actor_layer"]

    local actor_init = {}

    function actor_init.ghost(level, obj)
        local pos = vec2(obj.x + obj.width / 2, obj.y + obj.height)
        ghost = actor_layer:actor("actor.player:ghost")
        ghost.body:set(pos:unpack())
    end

    function actor_init.golem(level, obj)
        local pos = vec2(obj.x + obj.width / 2, obj.y + obj.height)
        golem = actor_layer:actor("actor.player:golem")
        golem.body:set(pos:unpack())
        table.insert(golems, golem)
    end

    function actor_init.wall(level, obj)
        if not obj.visible then return end

        local actor = actor_layer:actor(
            "actor.ghost_wall", obj.x, obj.y, obj.width, obj.height
        )

        if obj.properties.path then
            for _, other in ipairs(level.layers.actor_init.objects) do
                if other.name == obj.properties.path then
                    actor:setpath(other)
                end
            end
        end
    end

    function actor_init.goal(level, obj)
        goal = actor_layer:actor(
            "actor.goal", obj.x, obj.y, obj.width, obj.height
        )
    end
    control_ui = Node.create(require "nodes.text_box", 300)
    control_ui.__transform.pos = vec2(gfx.getWidth() - 220, 20)

    level_io.actor_init(level, actor_init)
    control_fsm = Node.create(fsm, require("control_fsm")(ghost, golems, control_ui))

end

function love.load()
    log.level = "info"
    gfx.setBackgroundColor(0, 0, 0, 0)
    level_from_index(start_index)
    __draw_bodies = false
    _DebugSettings.DrawOnTop = false
    start_time = love.timer.getTime()
end

function level_complete(goal, golem, ghost)
    for _, col in pairs(golem.col) do
        if col.other == goal.body then return true end
    end

    for _, col in pairs(ghost.col) do
        if col.other == goal.body then return true end
    end
end

function love.update(dt)
    tween.update(dt)
    if level then
        level:update(dt)
        control_fsm:update(dt)
    end
    event:spin()

    if level and level_complete(goal.body, golem.body, ghost.body) then
        level_from_index(level_index + 1)
    end
end

function love.keypressed(key, ...)
    if key == "escape" and level then
        level_from_index(level_index)
    end
    if control_fsm then
        control_fsm:keypressed(key, ...)
    end
end

function love.draw()
    if level then
        level:draw(0, 0, 2, 2)
    else
        local msg = string.format(
            "YOU WIN! Took only %fs", end_time - start_time
        )
        gfx.print(msg)
    end
    --level:bump_draw()
    if __draw_bodies then
        draw_world(level.world)
    end
    if control_ui then
        control_ui:draw()
    end
    --gfx.setColor(0, 1, 0)
    --gfx.rectangle("line", player.x, player.y, player.w, player.h)
end

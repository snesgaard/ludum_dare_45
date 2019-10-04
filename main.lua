require "nodeworks"
require "lovedebug"

local function getCellRect(world, cx,cy)
  local cellSize = world.cellSize
  local l,t = world:toWorld(cx,cy)
  return l,t,cellSize,cellSize
end

function draw_world(world)
    local cellSize = world.cellSize
    local font = love.graphics.getFont()
    local fontHeight = font:getHeight()
    local topOffset = (cellSize - fontHeight) / 2
    for cy, row in pairs(world.rows) do
        for cx, cell in pairs(row) do
            local l,t,w,h = getCellRect(world, cx,cy)
            local intensity = cell.itemCount * 12 + 16
            love.graphics.setColor(255,255,255,intensity)
            love.graphics.rectangle('line', l,t,w,h)
            love.graphics.setColor(255,255,255, 64)
            love.graphics.printf(cell.itemCount, l, t+topOffset, cellSize, 'center')
            love.graphics.setColor(255,255,255,10)
            love.graphics.rectangle('line', l,t,w,h)
        end
    end
end

function love.load()
    world = bump.newWorld()
    map = sti("art/maps/build/test.lua", { "bump" })
    map:bump_init(world)
    player = {name="yo", x = 100, y = 150, w = 10, h = 10}
    world:add(player, player.x, player.y, player.w, player.h)
end

function love.update(dt)
    player.x, player.y = world:move(player, player.x + 0, player.y + 10)
end

function love.draw()
    gfx.setColor(1, 1, 1)
    map:draw()
    draw_world(world)
    gfx.setColor(0, 1, 0)
    gfx.rectangle("line", player.x, player.y, player.w, player.h)
end

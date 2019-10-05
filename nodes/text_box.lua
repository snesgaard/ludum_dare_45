local box = {}

function box:create(w)
    self.width = w or 100
    self.font = font(20)
end

function box:__draw()
    if not self.text then return end

    local width, wraptext = self.font:getWrap(self.text, self.width)
    local height = self.font:getHeight() * #wraptext
    gfx.setColor(0.3, 0.3, 0.6, 0.7)
    local x, y, w, h = spatial(0, 0, width, height):expand(20, 20):unpack()
    gfx.rectangle("fill", x, y, w, h, 5)
    gfx.setFont(self.font)
    gfx.setColor(1, 1, 1)
    gfx.printf(self.text, 0, 0, self.width, "left")
    gfx.setColor(1, 1, 1)
end

return box

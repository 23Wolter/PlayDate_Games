local gfx <const> = playdate.graphics

class("Platform").extends(gfx.sprite)

function Platform:init(xPos, yPos, height, length)
    Platform.super.init(self)
    self:moveTo(xPos, yPos)
    local rectImage = gfx.image.new(height, length)
    gfx.pushContext(rectImage)
        gfx.fillRect(0, 0, height, length)
    gfx.popContext()
    self:setImage(rectImage)
    self:setCollideRect(0,0, self:getSize())
    -- self:setGroups(TAGS.OBSTACLE,TAGS.GROUND)
    self:add()
end



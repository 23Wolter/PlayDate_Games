local gfx <const> = playdate.graphics
local TAGS = {
    PLAYER = 1,
    OBSTACLE = 2,
    ENEMY = 3,
    COLLECTABLE = 4,
    GROUND = 5
}

local wallImage = nil

class("Platform").extends(gfx.sprite)

function Platform:init(xPos, yPos, height, length, isSolid)
    -- isSolid is optional and defaults to false. 
    -- isSolid will make the sprite object impassable to the player.
    isSolid = isSolid or false
    assert(xPos, yPos, height, length)
    Platform.super.init(self)
    self:moveTo(xPos, yPos)
    local rectImage = gfx.image.new(height, length)
    gfx.pushContext(rectImage)
        gfx.fillRect(0, 0, height, length)
    gfx.popContext()
    self:setImage(rectImage)
    self:setCollideRect(0,0, self:getSize())
    self:setTag(TAGS.OBSTACLE,TAGS.GROUND)
    self:add()
end



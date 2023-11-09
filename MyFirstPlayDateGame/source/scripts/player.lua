 local gfx <const> = playdate.graphics

class("Player").extends(AnimatedSprite)

function Player:init(spawnX, spawnY)
    local playerImageTable = gfx.imagetable.new("Images/player-table-32-32")
    Player.super.init(self, playerImageTable)
    assert( playerImageTable ) -- make sure the image was where we thought
   
    -- state machine animation setup
    self:addState('idle', 1, 2, {tickStep = 8})
    self:addState('walk', 3, 10, {tickStep = 4})
    self:addState('jump', 11, 11)
    self:playAnimation()

    -- sprite properties
    self:moveTo( spawnX, spawnY) 
    self:setZIndex(Z_INDEX.PLAYER)
    self:setCollideRect(6, 6, 20, 26)
    self:setTag(TAGS.PLAYER)

    -- Physics properties
    self.xVelocity = 0
    self.yVelocity = 0
    self.gravity = 1
    self.gravityAcceleration = 1.1
    self.maxSpeed = 2
    self.jumpVelocity = -7.3
    self.LastRotation = 0

    -- Player states
    self.touchingGround = false 
end
-- we shouldnt use moveBy to control players as that doesnt check for collisions.


function Player:applyGravity()
    if self.touchingGround then
        yVelocity = 0
    else
        self.yVelocity += self.gravity
        self.yVelocity *= self.gravityAcceleration
    end   
end

function Player:collisionResponse()
    return gfx.sprite.kCollisionTypeSlide
end

function Player:update()
    self:updateAnimation()
    self:handleState()
    self:handleMovementAndCollision()
end

function Player:handleState()
    if self.currentState == 'idle' then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == 'walk' then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == 'jump' then
        if self.touchingGround then 
            self:changeToIdleState()
        end
        self:applyGravity()
        self:handleAirInput()
    end
end

function Player:handleMovementAndCollision()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    self.touchingGround = false
    for key,collision in pairs(collisions) do
        if collision.normal.y == -1 then
            self.touchingGround = true --
            self.LastRotation = self:getRotation() 
        end
    end
    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end
end

function Player:handleGroundInput()
    if playdate.buttonJustPressed( playdate.kButtonUp ) then
        self:changeToJumpState()
    elseif playdate.buttonIsPressed( playdate.kButtonLeft ) then
        self:changeToWalkState(DIRECTION.LEFT)
        self.globalFlip = 1
    elseif playdate.buttonIsPressed( playdate.kButtonRight ) then
        self:changeToWalkState(DIRECTION.RIGHT)
        self.globalFlip = 0
    else 
        self:changeToIdleState()
    end
end

function Player:changeToIdleState()
    self.xVelocity = 0
    self:setRotation(0)
    self:changeState("idle")
end

function Player:changeToWalkState(directionVector)
    self.xVelocity = directionVector.x*self.maxSpeed
    self:changeState('walk')
end

function Player:handleAirInput()
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.xVelocity = -self.maxSpeed
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        self.xVelocity = self.maxSpeed
    elseif (not playdate.isCrankDocked()) then
		local crankPositon = math.floor(playdate.getCrankPosition())
		self:setRotation(crankPositon - self.LastRotation)
    end  
end

function Player:changeToJumpState()
    self.yVelocity = self.jumpVelocity
    self:changeState("jump")
end
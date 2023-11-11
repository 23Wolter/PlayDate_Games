local gfx <const> = playdate.graphics

local STATE = {
    IDLE = 'idle',
    WALK = 'walk',
    RUN = 'run',
    JUMP = 'jump'
}

class("Player").extends(AnimatedSprite)

function Player:init(spawnX, spawnY)
    local playerImageTable = gfx.imagetable.new("Images/player-table-32-32")
    Player.super.init(self, playerImageTable)
    assert( playerImageTable ) -- make sure the image was where we thought
   
    -- state machine animation setup
    self:addState(STATE.IDLE, 1, 2, {tickStep = 8})
    self:addState(STATE.WALK, 3, 10, {tickStep = 4})
    self:addState(STATE.JUMP, 11, 11)
    self:playAnimation()

    -- sprite properties
    self:moveTo( spawnX, spawnY) 
    self:setZIndex(Z_INDEX.PLAYER)
    self:setCollideRect(6, 6, 20, 26)
    self:setTag(TAGS.PLAYER)

    -- Physics properties
    self.GRAVITY_BASE = 0.5
    self.GRAVITY_ACCELERATION = 1.05
    self.GRAVITY_MAX = 20
    self.MAX_SPEED = 2
    self.JUMP_VELOCITY = -8
    self.xVelocity = 0
    self.yVelocity = 0
    self.gravity = 0

    -- Player states
    self.touchingGround = false
    self.touchingCeiling = false 
end
-- we shouldnt use moveBy to control players as that doesnt check for collisions.

function Player:update()
    self:updateAnimation()
    self:handleMovementAndCollision()
    self:handleState()
    print(self.y)
end

function Player:handleState()
    self:applyGravity()
    if self.currentState == STATE.IDLE then
        self:handleGroundInput()
    elseif self.currentState == STATE.WALK then
        self:handleGroundInput()
    elseif self.currentState == STATE.JUMP then
        if self.touchingGround then 
            self:setState(STATE.IDLE)
        end
        self:handleAirInput()
    end
end

function Player:handleMovementAndCollision()
    --create sprite copy for collision check
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    self.touchingGround = false
    self.touchingCeiling = false
    for key,collision in pairs(collisions) do
        if collision.normal.y == -1 then
            self.touchingGround = true --
        elseif collision.normal.y == 1 then 
            self.touchingCeiling = true
        else 
            self.touchingCeiling = false
        end

    end
    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end
end

function Player:setState(state, arg)
    self:changeState(state)

    if state == STATE.IDLE then
        self.xVelocity = 0
        self:setRotation(0)
    elseif state == STATE.WALK then
        local directionVector = arg
        self.xVelocity = directionVector.x*self.MAX_SPEED
        self:setRotation(0)
    elseif state == STATE.JUMP then
        self.yVelocity = self.JUMP_VELOCITY
    else
        error(state .. ' does not exist') 
    end
end

function Player:handleGroundInput()
    if playdate.buttonJustPressed( playdate.kButtonUp ) then
        self:setState(STATE.JUMP)
    elseif playdate.buttonIsPressed( playdate.kButtonLeft ) then
        self:setState(STATE.WALK, DIRECTION.LEFT)
        self.globalFlip = 1
    elseif playdate.buttonIsPressed( playdate.kButtonRight ) then
        self:setState(STATE.WALK, DIRECTION.RIGHT)
        self.globalFlip = 0
    else 
        self:setState(STATE.IDLE)
    end 
end

function Player:handleAirInput()
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.xVelocity = -self.MAX_SPEED
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        self.xVelocity = self.MAX_SPEED
    end
    if (not playdate.isCrankDocked()) then
		local crankRotationChange, _ = playdate.getCrankChange()
		self:setRotation(crankRotationChange + self:getRotation())
        local collider = self:getCollideRect()
    end  
end

function Player:applyGravity()
    if self.touchingGround or self.touchingCeiling then
        self.yVelocity = 0
    else
        if self.yVelocity == 0 then 
            self.gravity = self.GRAVITY_BASE
        end
        self.gravity *= self.GRAVITY_ACCELERATION
        -- consider a gravity component if more things want gravity pull alla rigidBody
        self.yVelocity += self.gravity 
    end 
    if self.yVelocity > self.GRAVITY_MAX then
        self.yVelocity = self.GRAVITY_MAX
    end
end

function Player:collisionResponse()
    return gfx.sprite.kCollisionTypeSlide
end
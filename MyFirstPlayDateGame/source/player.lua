
local gfx <const> = playdate.graphics

local playerSprite = nil
local playerImage = nil 
local movementSpeed = 4
-- jump TODO
local jumpSpeed = 0
local deccelerationJumpSpeed = 0.8
local initialJumpSpeed = 10

local initialFallSpeed = 1.05
local fallSpeed = 0
local fallSpeedAcceleration = 5 

local DIRECTION <const>  = {
    UP = {x = 0, y = -1},
    DOWN = {x = 0, y = 1},
    LEFT = {x = -1,y = 0},
    RIGHT = {x = 1,y = 0}
}

class("Player").extends(gfx.sprite)

function Player:init(spawnX,spawnY)
    Player.super.init(self)
    playerImage = gfx.image.new("Images/playerImage",32,32)
    assert( playerImage ) -- make sure the image was where we thought
    
    playerSprite = gfx.sprite.new( playerImage )
    playerSprite:moveTo( spawnX, spawnY ) 
    playerSprite:setCollideRect(0,0, playerSprite:getSize())
    playerSprite:add()
end


-- we shouldnt use moveBy to control players as that doesnt check for collisions.
function Player:movement()
    if playdate.buttonJustPressed( playdate.kButtonUp ) then
        self:move(DIRECTION.UP, 40)
        -- playerSprite:moveWithCollisions( 0, -1 )
    end
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        self:move(DIRECTION.RIGHT, movementSpeed)
        -- playerSprite:moveWithCollisions( 1, 0 )
    end
    if playdate.buttonIsPressed( playdate.kButtonDown ) then
        self:move(DIRECTION.DOWN, movementSpeed)
        -- playerSprite:moveWithCollisions( 0, 1 )
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        self:move(DIRECTION.LEFT, movementSpeed)
        -- playerSprite:moveWithCollisions( -1, 0 )
    end
	if (not playdate.isCrankDocked()) then
		local crankPositon = math.floor(playdate.getCrankPosition())
		playerSprite:setRotation(crankPositon)
    end
end

function Player:move(vector, speed)
    local newX = playerSprite.x + vector.x * speed
    local newY = playerSprite.y + vector.y * speed
    playerSprite:moveWithCollisions(newX, newY)
end

function Player:fall()
    -- the if statement (fallSpeed == 0) should ideally check for the player to be on ground RATHER than fallSpeed is 0
    -- The operator 'and' returns its first argument if it is false; otherwise, it returns its second argument. 
    -- The operator 'or' returns its first argument if it is not false; otherwise, it returns its second argument
    fallSpeed = fallSpeed == 0 and initialFallSpeed or 0
    print(fallSpeed)
    fallSpeed = fallSpeed * fallSpeedAcceleration
    self:move(DIRECTION.DOWN, fallSpeed)      
end

function Player:jump()
    jumpSpeed = jumpSpeed == 0 and initialJumpSpeed or 0
    self:move(DIRECTION.UP, jumpSpeed)
end

function Player:isFalling()
    fallSpeed = 0
end


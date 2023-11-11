import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "scripts/libraries/AnimatedSprite"

import "scripts/player"
import "scripts/platform"

-- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
TAGS = {
    PLAYER = 1,
    OBSTACLE = 2,
    ENEMY = 3,
    COLLECTABLE = 4,
    GROUND = 5
}

-- tutorial
crankTutorialHasRun = false

DIRECTION = {
    UP = {x = 0, y = -1},
    DOWN = {x = 0, y = 1},
    LEFT = {x = -1,y = 0},
    RIGHT = {x = 1,y = 0}
}

Z_INDEX = {
    PLAYER = 100
}

local player = Player(200, 60)
local platform = Platform(80, 205, 50, 20)
local platform2 = Platform(160, 170, 50, 20)
local platform3 = Platform(240, 120, 50, 20)
local platform4 = Platform(320, 70, 50, 20)
local platform5 = Platform(200, 280, 400, 100)

local gfx <const> = playdate.graphics

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()

end
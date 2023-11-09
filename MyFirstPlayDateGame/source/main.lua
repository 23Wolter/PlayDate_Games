import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "player"
import "platform"

-- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
local TAGS = {
    PLAYER = 1,
    OBSTACLE = 2,
    ENEMY = 3,
    COLLECTABLE = 4,
    GROUND = 5
}

local player = Player(200, 60)
local platform = Platform(100, 205, 50, 20)
local platform2 = Platform(200, 205, 50, 20)
local platform3 = Platform(300, 205, 50, 20)
local platform4 = Platform(350, 155, 50, 20)

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
local gfx <const> = playdate.graphics

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()
    player:fall()
    player:movement()

    -- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)

    gfx.sprite.update()
    playdate.timer.updateTimers()

end
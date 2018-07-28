Jörmungandr
===========

Just-in-time sprite atlas for LÖVE. (In Dev!)

Example Without Jörmungandr
---------------------------

```lua
local image, quad

function love.load()
  image = love.graphics.newImage('cutie.png')
  quad = love.graphics.newQuad(0, 0, 16, 32, image:getDimensions())
end

function love.draw()
  love.graphics.draw(image, quad, 100, 100)
end
```

Example With Jörmungandr
------------------------

```lua
-- "jormungandr" is hard to spell, so be sure to import the library with the
-- name of your favourite anime girl.
local Akari = require 'jormungandr'()

local imageProxy, quad, atlasImage

function love.load()
  -- imageProxy is not a LÖVE Image, but supports methods like :getDimensions(),
  -- so you should be able to use it with libraries like anim8.
  imageProxy = Akari:newImage('demo/player.png')
  -- "quad" is a LÖVE Quad.
  -- The cordinates will correspond to (0, 0, 19, 19) relative to where "player.png" was placed in the atlas.
  quad = imageProxy:newQuad(0, 0, 19, 19)
  -- "atlasImage" is a LÖVE Image. This is your sprite atlas texture.
  atlasImage = Akari:getAtlasImage()
end

function love.draw()
  love.graphics.draw(atlasImage, quad, 100, 100)
end
```

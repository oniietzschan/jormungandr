Jörmungandr
===========

Just-in-time sprite atlas for LÖVE. (In Dev!)

![a photograph of a man elaborately manipulating his rectum with both hands](https://i.imgur.com/tyweg7k.png)

Example Without Jörmungandr
---------------------------

```lua
local images = {
  love.graphics.newImage('cutie.png'),
  love.graphics.newImage('monster.png'),
  love.graphics.newImage('weapon.png'),
}
local quads = {
  love.graphics.newQuad(0, 0, 16, 32, images[1]:getDimensions()),
  love.graphics.newQuad(0, 0, 24, 40, images[2]:getDimensions()),
  love.graphics.newQuad(0, 0, 16, 16, images[3]:getDimensions()),
}

function love.draw()
  -- This will take 3 drawcalls! So slow!
  for i = 1, 3 do
    love.graphics.draw(images[i], quads[i], 50 * i, 50)
  end
end
```

Example With Jörmungandr
------------------------

```lua
-- "jormungandr" is hard to spell, so be sure to import the library with the
-- name of your favourite anime girl.
local Akari = require 'jormungandr'()

-- Akari:newQuad() returns a LÖVE Quad.
-- The cordinates will correspond to the relative position of the image inside the atlas.
local quads = {
  Akari:newQuad('cutie.png',   0, 0, 16, 32),
  Akari:newQuad('monster.png', 0, 0, 24, 40),
  Akari:newQuad('weapon.png',  0, 0, 16, 16),
}
-- Akari:getAtlasImage() returns a LÖVE Image. This is your sprite atlas texture.
-- This should only be called after you have created all of your quads.
local atlasImage = Akari:getAtlasImage()

function love.draw()
  -- This will take just 1 drawcall! #wow #whoa
  for i = 1, 3 do
    love.graphics.draw(atlasImage, quads[i], 50 * i, 50)
  end
end
```

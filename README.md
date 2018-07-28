Jörmungandr
===========

Just-in-time sprite atlas for LÖVE. (In Dev!)

![a photograph of a man elaborately manipulating his rectum with both hands](https://i.imgur.com/tyweg7k.png)

Example Without Jörmungandr
---------------------------

```lua
local images, quads

function love.load()
  images = {
    love.graphics.newImage('cutie.png'),
    love.graphics.newImage('monster.png'),
    love.graphics.newImage('weapon.png'),
  }
  quads = {
    love.graphics.newQuad(0, 0, 16, 32, images[1]:getDimensions()),
    love.graphics.newQuad(0, 0, 24, 40, images[2]:getDimensions()),
    love.graphics.newQuad(0, 0, 16, 16, images[3]:getDimensions()),
  }
end

function love.draw()
  -- This will take 3 drawcalls! So slow!
  for i = 1, 3 do
    love.graphics.draw(images[i], quad[i], 50 * i, 50)
  end
end
```

Example With Jörmungandr
------------------------

```lua
-- "jormungandr" is hard to spell, so be sure to import the library with the
-- name of your favourite anime girl.
local Akari = require 'jormungandr'()

local quads, atlasImage

function love.load()
  -- imageProxy is not a LÖVE Image, but supports methods like :getDimensions(),
  -- so you should be able to use it with libraries like anim8.
  local imageProxies = {
    Akari:newImage('cutie.png'),
    Akari:newImage('monster.png'),
    Akari:newImage('weapon.png'),
  }
  -- "quad" is a LÖVE Quad.
  -- The cordinates will correspond to the relative position of the image inside the atlas.
  quads = {
    imageProxies[1]:newQuad(0, 0, 16, 32),
    imageProxies[2]:newQuad(0, 0, 24, 40),
    imageProxies[3]:newQuad(0, 0, 16, 16),
  }
  -- "atlasImage" is a LÖVE Image. This is your sprite atlas texture.
  atlasImage = Akari:getAtlasImage()
end

function love.draw()
  -- This will take just 1 drawcall! #wow #whoa
  for i = 1, 3 do
    love.graphics.draw(atlasImage, quad[i], 50 * i, 50)
  end
end
```

local Akari = require 'jormungandr'

local image, quad

function love.load()
  image = love.graphics.newImage('demo/player.png')
  quad = love.graphics.newQuad(0, 0, 19, 19, image:getDimensions())
end

function love.draw()
  love.graphics.draw(image, quad, 100, 100)
end

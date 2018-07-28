local Akari = require 'jormungandr'()

local demo = {}

local vanillaDrawCalls
local jormungandrDrawCalls

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setLineStyle('rough')

  demo.initVanillaLoveDrawCalls()
  demo.initJormungandrDrawCalls()
end

function demo.initVanillaLoveDrawCalls()
  vanillaDrawCalls = {}
  local image = love.graphics.newImage('demo/player.png')
  local quad = love.graphics.newQuad(0, 0, 19, 19, image:getDimensions())
  table.insert(vanillaDrawCalls, {image, quad, 0, 0})
end

function demo.initJormungandrDrawCalls()
  jormungandrDrawCalls = {}
  local imageProxy = Akari:newImage('demo/player.png')
  local quad = imageProxy:newQuad(0, 0, 19, 19)
  local image = Akari:getAtlasImage()
  table.insert(jormungandrDrawCalls, {image, quad, 0, 0})
end

local WHITE = {1, 1, 1}
local DARK_BLUE = {0.15, 0.15, 0.25}
local MED_BLUE = {0.25, 0.25, 0.4}

function love.draw()
  love.graphics.scale(2, 2)
  love.graphics.setColor(DARK_BLUE)
  love.graphics.rectangle('fill', 0, 0, 400, 300)

  love.graphics.translate(10, 10)
  demo.draw(vanillaDrawCalls)

  love.graphics.translate(200, 0)
  demo.draw(jormungandrDrawCalls)
end

function demo.draw(drawCalls)
  love.graphics.setColor(MED_BLUE)
  love.graphics.rectangle('fill', 0, 0, 180, 180)

  local drawcallsBefore = love.graphics.getStats().drawcalls

  love.graphics.setColor(WHITE)
  love.graphics.push()
  love.graphics.translate(0, 20)
  for _, drawCall in ipairs(drawCalls) do
    local image, quad, x, y = unpack(drawCall)
    love.graphics.draw(image, quad, x, y)
  end
  love.graphics.pop()

  local drawcalls = love.graphics.getStats().drawcalls - drawcallsBefore
  local text = ("Drawcalls: %d"):format(drawcalls)
  love.graphics.print(text, 10, 0)
end

local Akari = require 'jormungandr'(128)

io.stdout:setvbuf("no")

local demo = {}

local DATA = {
  ['demo/player.png'] = {
    { 0, 0, 19, 19},
    {19, 0, 19, 19},
    {38, 0, 19, 19},
    {57, 0, 19, 19},
    {76, 0, 19, 19},
    {95, 0, 19, 19},
  },
  ['demo/bullet.png'] = {
    {0, 0, 9, 9},
    {9, 0, 9, 9},
  },
  ['demo/jelly.png'] = {
    { 0, 0, 18, 16},
    {18, 0, 18, 16},
    {36, 0, 18, 16},
    {54, 0, 18, 16},
    {72, 0, 18, 16},
  },
}

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
  for filename, quadParamSets in pairs(DATA) do
    local image = love.graphics.newImage(filename)
    for _, quadParams in ipairs(quadParamSets) do
      local x, y, w, h = unpack(quadParams)
      local quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
      table.insert(vanillaDrawCalls, {image, quad, 0, 0})
    end
  end
end

function demo.initJormungandrDrawCalls()
  local quads = {}

  for filename, quadParamSets in pairs(DATA) do
    for _, quadParams in ipairs(quadParamSets) do
      local x, y, w, h = unpack(quadParams)
      local quad = Akari:newQuad(filename, x, y, w, h)
      table.insert(quads, quad)
    end
  end

  jormungandrDrawCalls = {}
  local atlasImage = Akari:getAtlasImage()
  for _, quad in ipairs(quads) do
    table.insert(jormungandrDrawCalls, {atlasImage, quad, 0, 0})
  end
end

local WHITE = {1, 1, 1}
local DARK_BLUE = {0.15, 0.15, 0.25}
local MED_BLUE = {0.25, 0.25, 0.4}

function love.draw()
  love.graphics.scale(2, 2)
  love.graphics.setColor(DARK_BLUE)
  love.graphics.rectangle('fill', 0, 0, 400, 300)

  love.graphics.push()
  love.graphics.translate(10, 10)
  demo.draw('Vanilla LÖVE', vanillaDrawCalls)
  love.graphics.translate(195, 0)
  demo.draw('Jörmungandr', jormungandrDrawCalls)
  love.graphics.pop()

  love.graphics.push()
  love.graphics.translate(10, 190)
  love.graphics.setColor(MED_BLUE)
  love.graphics.rectangle('fill', 0, 0, 380, 100)
  love.graphics.setColor(WHITE)
  love.graphics.print('Texture Atlas', 10, 0)
  love.graphics.draw(Akari:getAtlasImage(), 10, 15)
  love.graphics.pop()
end

function demo.draw(title, drawCalls)
  love.graphics.setColor(MED_BLUE)
  love.graphics.rectangle('fill', 0, 0, 185, 170)

  local drawcallsBefore = love.graphics.getStats().drawcalls

  love.graphics.setColor(WHITE)
  love.graphics.push()
  love.graphics.translate(0, 35)
  local _x = 0
  for _, drawCall in ipairs(drawCalls) do
    local image, quad, x, y = unpack(drawCall)
    love.graphics.draw(image, quad, x + _x, y)
    local _, _, _w = quad:getViewport()
    _x = _x + _w
  end
  love.graphics.pop()

  local drawcalls = love.graphics.getStats().drawcalls - drawcallsBefore
  love.graphics.print(title, 10, 0)
  love.graphics.print(("Drawcalls: %d"):format(drawcalls), 10, 15)
end

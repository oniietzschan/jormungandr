local Jormungandr = {
  _VERSION     = 'jormungandr v0.0.0',
  _URL         = 'https://github.com/oniietzschan/jormungandr',
  _DESCRIPTION = 'A just-in-time sprite atlas for Love2d.',
  _LICENSE     = [[
    Massachusecchu... あれっ！ Massachu... chu... chu... License!

    Copyright (c) 1789 shru

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED 【AS IZ】, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE. PLEASE HAVE A FUN AND BE GENTLE WITH THIS SOFTWARE.
  ]]
}

function Jormungandr:init(dimensions)
  assert(type(dimensions) == 'number' or dimensions == nil)
  self._dimensions = dimensions or 1024
  self._x = 0
  self._y = 0
  self._nextY = 0
  self._images = {}
  self._filePathToImageData = {}
  local Valet = require 'valet'
  self._valet = Valet(self._dimensions, self._dimensions)
end

function Jormungandr:newQuad(image, x, y, w, h)
  if self._atlasImage then
    error('newQuad() should be called before getAtlasImage()')
  end

  if type(image) == 'string' then
    if self._filePathToImageData[image] == nil then
      self._filePathToImageData[image] = love.image.newImageData(image)
    end
    imageData = self._filePathToImageData[image]
  else
    error('must pass in image as path')
  end

  local quad = love.graphics.newQuad(0, 0, w, h, self._dimensions, self._dimensions)

  local obj = {
    imageData = imageData,
    quad = quad,
    x = x,
    y = y,
  }
  self._valet:add(obj, w, h)

  return quad
end

function Jormungandr:getAtlasImage()
  if self._atlasImage == nil then
    self._atlasImage = self:_createAtlas()
  end
  return self._atlasImage
end

function Jormungandr:_createAtlas()
  local atlasImageData = love.image.newImageData(self._dimensions, self._dimensions)
  for _, t in ipairs(self._valet:yield()) do
    local obj, x, y, w, h = unpack(t)
    atlasImageData:paste(obj.imageData, x, y, obj.x, obj.y, w, h)
    obj.quad:setViewport(x, y, w, h)
  end
  return love.graphics.newImage(atlasImageData)
end

local JormungandrMetaTable = {
  __index = Jormungandr,
}

return function(...)
  local libraryInstance = setmetatable({}, JormungandrMetaTable)
  libraryInstance:init(...)
  return libraryInstance
end

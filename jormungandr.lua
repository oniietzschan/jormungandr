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
local JormungandrMetaTable = {
  __index = Jormungandr,
}

local Image = {}
local ImageMetaTable = {
  __index = Image,
}



function Jormungandr:init()
  self._images = {}
end

function Jormungandr:getAtlasImage()
  return self._atlasImage
end

function Jormungandr:newImage(path)
  assert(self._atlasImage == nil, 'todo...')
  self._atlasImage = love.graphics.newImage(path)

  local image = setmetatable({}, ImageMetaTable)
  local w, h = self._atlasImage:getDimensions()
  image:init(0, 0, w, h)
  image:setAtlasDimensions(w, h)
  table.insert(self._images, image)
  return image
end



function Image:init(x, y, w, h)
  self._x = x
  self._y = y
  self._w = w
  self._h = h
end

function Image:setAtlasDimensions(w, h)
  self._atlasW = w
  self._atlasH = h
  return self
end

function Image:newQuad(x, y, w, h)
  local quad = love.graphics.newQuad(self._x + x, self._y + y, w, h, self._atlasW, self._atlasH)
  return quad
end



return function()
  local libraryInstance = setmetatable({}, JormungandrMetaTable)
  libraryInstance:init()
  return libraryInstance
end

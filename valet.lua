local Space = {}

local function assertDimensions(width, height)
  assert(type(width)  == 'number' and width  >= 1 and width  % 1 == 0)
  assert(type(height) == 'number' and height >= 1 and height % 1 == 0)
end

function Space:initialize(width, height)
  assertDimensions(width, height)
  self._width = width
  self._height = height
  self._x = 0
  self._y = 0
  self._nextY = 0
  self._objs = {}
  return self
end

function Space:add(obj, width, height)
  assertDimensions(width, height)
  table.insert(self._objs, {
    obj = obj,
    width = width,
    height = height,
  })
end

function Space:yield()
  local result = {}
  for _, t in ipairs(self._objs) do
    local w, h = t.width, t.height
    if self._x + w > self._width then
      self._x = 0
      self._y = self._nextY
    end
    if self._y + h > self._height then
      error(("Valet space is full, try with larger than %d, %d dimensions."):format(self._width, self._height))
    end

    table.insert(result, {
      t.obj,
      self._x,
      self._y,
      w,
      h,
    })

    self._x = self._x + w
    self._nextY = math.max(self._nextY, self._y + h)
  end
  return result
end

local SpaceMetatable = {__index = Space}

return function(...)
  return setmetatable({}, SpaceMetatable)
    :initialize(...)
end


local Space = {}

local function assertDimensions(width, height)
  assert(type(width)  == 'number' and width  >= 1 and width  % 1 == 0)
  assert(type(height) == 'number' and height >= 1 and height % 1 == 0)
end

function Space:initialize(width, height)
  assertDimensions(width, height)
  self._width = width
  self._height = height
  self._objs = {}
  return self
end

function Space:add(obj, width, height)
  assertDimensions(width, height)
  local nextIndex = #self._objs + 1
  self._objs[nextIndex] = {
    obj = obj,
    width = width,
    height = height,
    index = nextIndex,
  }
end

local function sortHeightWidth(a, b)
  if a.height == b.height then
    if a.width == b.width then
      return a.index < b.index
    end
    return a.width > b.width
  end
  return a.height > b.height
end

local function park(unfilteredObjs, width, height)
  local objs = unfilteredObjs
  -- -- Filter down to objects which will fit in width by height.
  -- local objs = {}
  -- for _, obj in ipairs(unfilteredObjs) do
  --   if obj.width <= width and obj.height <= height then
  --     table.insert(objs, obj)
  --   end
  -- end

  -- Sort objects by height, width.
  table.sort(objs, sortHeightWidth)

  local results = {}

  -- Start going row by row.
  local x, y, rowH = 0, 0, 0
  for i, obj in ipairs(objs) do
    rowH = math.max(rowH, obj.height)
    if rowH > (height - y) then
      break -- Unable to contain any more objects here.
    end

    if obj.width > (width - x) then
      -- Go to the next row if there's not enough room.
      x = 0
      y = y + rowH
      rowH = obj.height
    end

    table.insert(results, {
      obj.obj,
      x,
      y,
      obj.width,
      obj.height,
    })
    x = x + obj.width
  end

  return results
end

function Space:yield()
  local result = park(self._objs, self._width, self._height)
  if #result < #self._objs then
    error(("Valet space is too small, try with larger than %d, %d."):format(self._width, self._height))
  end
  self._objs = {} -- Clear objects so that imageData can be freed from memory.
  return result
end

local SpaceMetatable = {__index = Space}

return function(...)
  return setmetatable({}, SpaceMetatable)
    :initialize(...)
end

local wall = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

function wall.new(init)
  local self = setmetatable({},{__index = wall})
  
  self.x = init.x
  self.y = init.y
  self.x2 = init.x2
  self.y2 = init.y2
  wall.color = init.color or {255,0,0,255}
  return self  
end

function wall:draw(focus)
  love.graphics.setColor(self.color)
  love.graphics.line(
    self.x * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
    self.y * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
    self.x2 * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
    self.y2 * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y)
end

return wall
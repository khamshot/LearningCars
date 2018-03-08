local Wall = {}
Wall.__index = Wall

function Wall.new(init)
  local self = setmetatable({},Wall)
  
  self.x1 = init.x1
  self.y1 = init.y1
  self.x2 = init.x2
  self.y2 = init.y2
  self.color = init.color or {255,255,255,255}
  return self  
end

function Wall:draw()
  love.graphics.setColor(self.color)
  love.graphics.line(self.x1,self.y1,self.x2,self.y2)
end

return Wall
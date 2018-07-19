local checkpoint = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

function checkpoint.new(init)
  local self = setmetatable({},{__index = checkpoint})
  
  self.x = init.x
  self.y = init.y
  self.x2 = init.x2
  self.y2 = init.y2
  self.reward = init.reward or 500
  checkpoint.color = init.color or {0,255,0,255}
  
  -- List of all cars who already went through the checkpoint
  self.ignoreID = {}
  return self  
end

function checkpoint:addID(ID)
  self.ignoreID[ID] = ID
end

function checkpoint:clearIDs()
  for k,v in pairs(self.ignoreID) do 
    self.ignoreID[k] = nil 
  end
end

function checkpoint:checkID(ID)
  if self.ignoreID[ID] then
    return true
  end
  return false
end

function checkpoint:draw(focus)
  love.graphics.setColor(self.color)
  love.graphics.line(
    self.x * settings.scale.x + settings.screen.w/2 - focus.x * settings.scale.x,
    self.y * settings.scale.y + settings.screen.h/2 - focus.y * settings.scale.y,
    self.x2 * settings.scale.x + settings.screen.w/2 - focus.x * settings.scale.x,
    self.y2 * settings.scale.y + settings.screen.h/2 - focus.y * settings.scale.y)
end

return checkpoint
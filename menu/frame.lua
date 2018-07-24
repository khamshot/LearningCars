local frame = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

frame.imgs = {
  love.graphics.newImage("media/yellow_panel.png"),
  love.graphics.newImage("media/green_panel.png"),
  love.graphics.newImage("media/red_panel.png"),
  love.graphics.newImage("media/blue_panel.png")}

function frame.new(init)
  local self = setmetatable({},{__index = frame})
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width or 50
  self.height = init.height or 50
  self.color = init.color or {255,255,255,255}
  self.img = init.img or 0
  self.txt = init.txt or ""
  self.txtOffset = init.txtOffset or {20,10}
  self.txtColor = init.txtColor or {255,255,255,255}

  self.exec = init.exec

  return self
end

function frame:update(input)
  if type(self.exec) == "function" then
    self.exec(self,input)
  end
end

function frame:draw()
  love.graphics.setColor(self.color)
  if self.img ~= 0 then
    love.graphics.draw(
      self.imgs[self.img],
      self.x * settings.uiScale.x,
      self.y * settings.uiScale.y,
      0,
      self.width/self.imgs[self.img]:getWidth() * settings.uiScale.x,
      self.height/self.imgs[self.img]:getHeight() * settings.uiScale.y)
  end
  self:drawTxt()
end

function frame:drawTxt()
  love.graphics.setColor(self.txtColor)
  love.graphics.print(
    self.txt,
    (self.x + self.txtOffset[1]) * settings.uiScale.x,
    (self.y + self.txtOffset[2]) * settings.uiScale.y)
end
  
return frame
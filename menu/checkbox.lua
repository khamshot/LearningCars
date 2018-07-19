local checkbox = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

checkbox.imgs = {
  {love.graphics.newImage("media/blue_check.png"),love.graphics.newImage("media/grey_box.png")},
  {love.graphics.newImage("media/red_check.png"),love.graphics.newImage("media/grey_box.png")},
  {love.graphics.newImage("media/green_check.png"),love.graphics.newImage("media/grey_box.png")},
  {love.graphics.newImage("media/yellow_check.png"),love.graphics.newImage("media/grey_box.png")}}

function checkbox.new(init)
  self = setmetatable({},{__index = checkbox})
  
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width or 30
  self.height = init.height or 30
  self.img = init.img or 1
  self.value = init.value or false 
  self.color = init.color or {255,255,255,255}
  
  self.exec = init.exec
  
  return self  
end

function checkbox:update(input)
  if not input.mousePressed then return 0 end
  
  if helper.checkCol(input.mouseX,input.mouseY,1,1,
    self.x * settings.uiScale.x,
    self.y * settings.uiScale.y,
    self.width * settings.uiScale.x,
    self.height * settings.uiScale.y)
  then
    self.value = not self.value
    if type(self.exec) == "function" then
      self.exec(self)
    end
  end
end

--- DRAW ---

function checkbox:draw()
  love.graphics.setColor(self.color)
  if self.value then
    love.graphics.draw(
      self.imgs[self.img][1],
      self.x * settings.uiScale.x,
      self.y * settings.uiScale.y,
      0,
      self.width/self.imgs[self.img][1]:getWidth() * settings.uiScale.x,
      self.height/self.imgs[self.img][1]:getHeight() * settings.uiScale.y)
  else
    love.graphics.draw(
      self.imgs[self.img][2],
      self.x * settings.uiScale.x,
      self.y * settings.uiScale.y,
      0,
      self.width/self.imgs[self.img][1]:getWidth() * settings.uiScale.x,
      self.height/self.imgs[self.img][1]:getHeight() * settings.uiScale.y)
  end
end

return checkbox
local slider = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

slider.imgs = {
  love.graphics.newImage("media/grey_sliderUp.png"),
  love.graphics.newImage("media/blue_sliderUp.png"),
  love.graphics.newImage("media/green_sliderUp.png"),
  love.graphics.newImage("media/yellow_sliderUp.png"),
  love.graphics.newImage("media/red_sliderUp.png"),
  line=love.graphics.newImage("media/grey_slider.png")}

function slider.new(init)
  local self = setmetatable({},{__index = slider})
  
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width or 200
  self.height = init.height or 40
  self.img = init.img or 1
  self.color = init.color or {255,255,255,255}
  
  self.minValue = init.minValue or 0
  self.maxValue = init.maxValue or 1
  self.value = init.value or self.minValue
  self.tickX = self.x + self.width * (self.value-self.minValue)/(self.maxValue-self.minValue)
  
  self.exec = init.exec
  self.active = false
  
  return self
end

--- UPDATE ---

function slider:update(input)
-- checks for mouseinputs and sets the slider value
  if input.mousePressed then
    if helper.checkCol(
      self.x * settings.uiScale.x,
      self.y * settings.uiScale.y,
      self.width * settings.uiScale.x,
      self.height * settings.uiScale.y,
      love.mouse.getX(),
      love.mouse.getY(),
      1,1) 
    then
      self.active = true
    end
  end
  
  if input.mouseReleased then
    self.active = false
  end
  
  if self.active then
    if love.mouse.getX()/settings.uiScale.x < self.x then
      self.tickX = self.x
    elseif love.mouse.getX()/settings.uiScale.x > (self.x + self.width) then
      self.tickX = self.x + self.width
    else
      self.tickX = love.mouse.getX()/settings.uiScale.x
    end
    
    self.value = 1 - (self.x + self.width - self.tickX) / self.width
    self.value = (self.maxValue - self.minValue) * self.value + self.minValue
    
    if type(self.exec) == "function" then
      self.exec(self)
    end
  end
end

--- DRAW ---

function slider:draw()
  love.graphics.setColor(self.color)
  -- draw the line
  love.graphics.draw(self.imgs.line,
    self.x * settings.uiScale.x,
    self.y * settings.uiScale.y,
    0,
    self.width/self.imgs.line:getWidth() * settings.uiScale.x,
    1)
  
  love.graphics.draw(self.imgs[self.img],
    (self.tickX - self.imgs[self.img]:getWidth()/2) * settings.uiScale.x,
    self.y * settings.uiScale.y,
    0,
    settings.uiScale.x,
    settings.uiScale.y)
end

return slider
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
  
  self.minValue = init.minValue or 2
  self.maxValue = init.maxValue or 10
  self.value = init.value or self.minValue
  self.tickX = self.x + self.width * (self.value-self.minValue)/(self.maxValue-self.minValue)
  
  self.exec = init.exec
  
  return self
end

--- UPDATE ---

function slider:update()
-- checks for mouseinputs and sets the slider value
  if love.mouse.isDown(1) then
    if helper.checkCol(
      self.x * settings.scale.x,
      self.y * settings.scale.y,
      self.width * settings.scale.x,
      self.height * settings.scale.y,
      love.mouse.getX(),
      love.mouse.getY(),
      1,1) 
    then
      self.tickX = love.mouse.getX()/settings.scale.x
      self.value = 1 - (self.x + self.width - self.tickX) / self.width
      self.value = (self.maxValue - self.minValue) * self.value + self.minValue
      
      if type(self.exec) == "function" then
        self.exec(self)
      end
    end
  end
end

--- DRAW ---

function slider:draw()
  love.graphics.setColor(self.color)
  -- draw the line
  love.graphics.draw(self.imgs.line,
    self.x * settings.scale.x,
    self.y * settings.scale.y,
    0,
    self.width/self.imgs.line:getWidth() * settings.scale.x,
    1)
  
  love.graphics.draw(self.imgs[self.img],
    (self.tickX - self.imgs[1]:getWidth()/2) * settings.scale.x,
    self.y * settings.scale.y,
    0,
    settings.scale.x,
    settings.scale.y)
end

return slider
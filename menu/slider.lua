local slider = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

slider.imgs = {
  {love.graphics.newImage("media/grey_slider.png"),love.graphics.newImage("media/grey_tick.png")}}

function slider.new(init)
  local self = setmetatable({},{__index = slider})
  
  self.color = init.color or {255,255,255,255}
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width or 200
  self.height = init.height or 17
  self.img = init.img or 1
  
  self.minValue = init.minValue or 2
  self.maxValue = init.maxValue or 10
  self.value = init.value or self.minValue
  self.tickX = self.x + self.width * self.value
  
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
  love.graphics.draw(self.imgs[self.img][1],
    self.x * settings.scale.x,
    self.y * settings.scale.y,
    0,
    self.width/self.imgs[self.img][1]:getWidth() * settings.scale.x,
    self.height/self.imgs[self.img][1]:getHeight() * settings.scale.y)
  
  love.graphics.draw(self.imgs[self.img][2],
    (self.tickX - self.height/2) * settings.scale.x,
    self.y * settings.scale.y,
    0,
    self.height/self.imgs[self.img][2]:getWidth() * settings.scale.x,
    self.height/self.imgs[self.img][2]:getHeight() * settings.scale.y)
end

return slider
local button = setmetatable({},
  {__call = function(self,...) return self.new(...) end})

button.imgs = {
  love.graphics.newImage("media/yellow_panel.png"),
  love.graphics.newImage("media/green_panel.png"),
  love.graphics.newImage("media/red_panel.png"),
  love.graphics.newImage("media/blue_panel.png"),
  love.graphics.newImage("media/red_boxCross.png")}

button.sounds = {
  love.audio.newSource("media/sfx/button1.wav")}

function button.new(init)
  local self = setmetatable({},{__index = button})
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width or 50
  self.height = init.height or 50
  self.color = init.color or {255,255,255,255}
  self.img = init.img or 0
  self.sound = init.sound or 1
  
  self.txt = init.txt or ""
  self.txtOffset = init.txtOffset or {20,10}
  self.txtColor = init.txtColor or {255,255,255,255}

  self.colorOffset = init.colorOffset or {255,255,255,255}
  self.txtColorOffset = init.txtColorOffset or {255,0,255,255}
  
  self.exec = init.exec

  self.active = false

  return self
end

function button:update(input)
-- checks if the mouse is over then button etc.  
  self:activate(
    helper.checkCol(
      self.x * settings.uiScale.x,
      self.y * settings.uiScale.y,
      self.width * settings.uiScale.x,
      self.height * settings.uiScale.y,
      love.mouse.getX(),
      love.mouse.getY(),
      1,1)) 
  
  if self.active and input.mousePressed then
    if type(self.exec) == "function" then
      self.exec(self)
    end
  end
end

function button:activate(bool)
  if bool and not self.active then
    self.sounds[self.sound]:stop()
    self.sounds[self.sound]:play()
    self.active = true
  end
  if not bool then
    self.active = false
  end
end

function button:draw()
  if self.active then
    love.graphics.setColor(self.colorOffset)
  else
    love.graphics.setColor(self.color)
  end
  
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

function button:drawTxt()
  if self.active then
    love.graphics.setColor(self.txtColorOffset)
  else
    love.graphics.setColor(self.txtColor)
  end
  
  love.graphics.print(
    self.txt,
    (self.x + self.txtOffset[1]) * settings.uiScale.x,
    (self.y + self.txtOffset[2]) * settings.uiScale.y)
end
  
return button
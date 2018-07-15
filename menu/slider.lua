local slider = {}

setmetatable(slider,{__call = function(self,... } return self.new(...) end)

slider.img = {
  }

function slider.new(init)
  local self = setmetatable({},{__index = slider})
  
  self.x = init.x or 50
  self.y = init.y or 50
  self.width = init.width
  self.height = init.height
  self.color = init.color or {255,255,255,255}
  self.img then slider.img = love.graphics.newImage("media/img/" .. init.img) end
  slider.sliderScaling = init.sliderScaling or 1;
  if init.sliderImg then slider.sliderImg = love.graphics.newImage("media/img/" .. init.sliderImg);end;
  slider.min = slider.x ;
  slider.max = slider.x + slider.width - slider.sliderImg:getWidth()*slider.sliderScaling/2;
  slider.sliderX = slider.max;
  slider.sliderY = slider.y + slider.height/2 - slider.sliderImg:getHeight()*slider.sliderScaling/2;
  slider.sliderWidth = slider.sliderImg:getWidth() * slider.sliderScaling;
  slider.sliderHeight = slider.sliderImg:getHeight() * slider.sliderScaling;
  slider.value = init.value or 1;

  function slider:drawFrame()
    --draws the slider
    love.graphics.setColor(self.color[1]*g.brightness,self.color[2]*g.brightness,self.color[3]*g.brightness,self.color[4]);
    if not self.img then
      love.graphics.rectangle("fill",self.x,self.y,self.width,self.height);
    else
      love.graphics.draw(self.img,self.x,self.y,0,self.width/self.img:getWidth(),self.height/self.img:getHeight());
    end;
  end;
  
  function slider:drawSlider()
    love.graphics.draw(self.sliderImg,self.sliderX,self.sliderY,0,slider.sliderScaling,slider.sliderScaling);
  end;
  
  function slider:mouseInteract()
    if love.mouse.isDown(1) then
      if physMgt.checkCol(self.x,self.sliderY,self.width,self.sliderHeight,love.mouse.getX(),love.mouse.getY(),1,1) then
        self.sliderX = love.mouse.getX() - self.sliderWidth/2;
        if self.sliderX > self.max then self.sliderX = self.max;end;
        if self.sliderX < self.min then self.sliderX = self.min;end;
      end;
    end;
  end;
  
  function slider:getValue()
    --returns the sliderValue // between 0 and 1
    return (self.sliderX - self.min)/(self.max - self.min);
  end;
  
  function slider:setValue(p_value)
    self.value = p_value;
    self.sliderX = self.min +(self.max-self.min)*p_value;
  end;
  
  return slider;
end
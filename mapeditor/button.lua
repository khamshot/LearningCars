local frame = require "frame"
local physMgt = require "physMgt"

function button_new(p_attr)
  local button = frame_new(p_attr);
  button.active = false;
  button.activeColor = p_attr.activeColor or {255,255,255,255};
  
  function button:draw()
    --draws the buttons Background
    if not self.active then
      love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4]);
    else
      love.graphics.setColor(self.activeColor[1],self.activeColor[2],self.activeColor[3],self.activeColor[4]);
    end;
    if not self.img then
      love.graphics.rectangle("fill",self.x,self.y,self.width,self.height);
    else
      love.graphics.draw(self.img,self.x,self.y,0,self.width/self.img:getWidth(),self.height/self.img:getHeight());
    end;
    love.graphics.setColor(255,255,255,255)
    love.graphics.print(self.txt,self.x+self.txtOffset[1],self.y+self.txtOffset[2]);
  end;
  
  function button:execute()
    --executes the function exec if defined
    if self.active and love.mouse.isDown(1) then
        self.exec(self);
    end;
  end;
  
  function button:checkCol(p_x,p_y)
    --checks if the input collides with the button // mouse x and y // -->calls activate/deactivate
    if physMgt.checkCol(p_x,p_y,1,1,self.x,self.y,self.width,self.height) then
      self:activate();
    else
      self:deactivate();
    end;
  end;
  
  function button:activate()
    --activates the button and plays a sound
    if not self.active then
      self.active = true;
    end;
  end;
  
  function button:deactivate()
    --deactivates the button
    self.active = false;
  end;
  
  function button:update(dt)
    self:checkCol(love.mouse.getX(),love.mouse.getY());
    self:execute();
  end
  
  return button;
end;

local mousebuttons = {
  false,
  false,
  false};

function mousePressed(p_key)
  if love.mouse.isDown(p_key) then
    if mousebuttons[p_key] then
      return false
    else
      mousebuttons[p_key] = true
      return true
    end
  else
    mousebuttons[p_key] = false
  end
end
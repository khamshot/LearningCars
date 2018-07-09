--local frame = require "frame";
--local physMgt = require "physMgt";

function button_new(p_attr)
  local button = frame_new(p_attr);
  button.sound = love.audio.newSource("media/sfx/"..(p_attr.sound or "button1.mp3"));
  button.active = false;
  button.activeColor = p_attr.activeColor or {255,255,255,255};
  
  function button:drawButton()
    --draws the buttons Background
    if not self.active then
      love.graphics.setColor(self.color[1]*g.brightness,self.color[2]*g.brightness,self.color[3]*g.brightness,self.color[4]);
    else
      love.graphics.setColor(self.activeColor[1]*g.brightness,self.activeColor[2]*g.brightness,self.activeColor[3]*g.brightness,self.activeColor[4]);
    end;
    if not self.img then
      love.graphics.rectangle("fill",self.x,self.y,self.width,self.height);
    else
      love.graphics.draw(self.img,self.x,self.y,0,self.width/self.img:getWidth(),self.height/self.img:getHeight());
    end;
  end;
  
  function button:drawTxt()
    --draws the buttontxt
    love.graphics.setFont(self.font);
    love.graphics.print(self.txt,self.x+self.txtOffset[1],self.y+self.txtOffset[2]);
  end;
  
  function button:execute()
    --executes the function exec if defined
    if self.active and inputMgt:mousePressed(1) then
      if type(self.exec) == "function" then
        self.exec(self);
      end;
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
      button.sound:stop();
      button.sound:play();
      self.active = true;
    end;
  end;
  
  function button:deactivate()
    --deactivates the button
    self.active = false;
  end;
  
  return button;
end;

---- ALL BUTTONS ----

local button = {};

function button:new(p_attr)
  table.insert(self,button_new(p_attr));
end;

function button:clear()
  while self[1] do
    table.remove(self,1);
  end;
end;

function button:update(dt)
  for i,v in ipairs(self) do
    v:checkCol(love.mouse.getX(),love.mouse.getY());
    v:execute();
  end;
end;

function button:draw()
  for i,v in ipairs(self) do
    v:drawButton();
    v:drawTxt();
  end;
end;

return button;
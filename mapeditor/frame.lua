function frame_new(p_attr)
  local frame = {};
  frame.x = p_attr.x or 0;
  frame.y = p_attr.y or 0;
  frame.width = p_attr.width or love.graphics.getWidth();
  frame.height = p_attr.height or love.graphics.getHeight();
  frame.color = p_attr.color or {255,255,255,255}
  if p_attr.img then frame.img = love.graphics.newImage("media/img/" .. p_attr.img);end;
  frame.txt = p_attr.txt or "";
  frame.txtOffset = p_attr.txtOffset or {0,0};

  function frame:drawFrame()
    --draws the frame
    love.graphics.setColor(self.color[1]*g.brightness,self.color[2]*g.brightness,self.color[3]*g.brightness,self.color[4]);
    if not self.img then
      love.graphics.rectangle("fill",self.x,self.y,self.width,self.height);
    else
      love.graphics.draw(self.img,self.x,self.y,0,self.width/self.img:getWidth(),self.height/self.img:getHeight());
    end;
  end;
  
  function frame:drawTxt()
    --draws the buttontxt
    love.graphics.print(self.txt,self.x+self.txtOffset[1],self.y+self.txtOffset[2]);
  end;
  
  return frame;
end;

---- ALL FRAMES ----

local frame = {};

function frame:new(p_attr)
  table.insert(self,frame_new(p_attr));
end;

function frame:clear()
  while self[1] do
    table.remove(self,1);
  end;
end;

function frame:update(dt)
  for i,v in ipairs(self) do
  
  end;
end;

function frame:draw()
  for i,v in ipairs(self) do
    v:drawFrame();
    v:drawTxt()
  end;
end;

return frame;
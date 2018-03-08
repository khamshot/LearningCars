local Frame = {}
Frame.__index = Frame

function Frame.new(init)
  local self = setmetatable({},Frame)
  self.x = init.x or 0
  self.y = init.y or 0
  self.width = init.width
  self.height = init.height
  self.color = init.color or {255,255,255,255}
  self.img = init.img and love.graphics.newImage(init.img) or love.graphics.newImage("media/transparent.png")
  self.txt_offset_x = init.txt_offset_x or 0
  self.txt_offset_y = init.txt_offset_y or 0
  self.txt_color = init.txt_color or {255,255,255,255}
  self.font = love.graphics.newFont(init.font or "media/curse_casual.ttf",init.fontSize or 25)
  
  return self
end

function Frame:draw(txt)
  --draws the frame
  love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4]);
  love.graphics.draw(self.img,self.x,self.y,0,self.width/self.img:getWidth(),self.height/self.img:getHeight());
  --draws the txt
  love.graphics.setColor(self.txt_color[1],self.txt_color[2],self.txt_color[3],self.txt_color[4]);
  love.graphics.setFont(self.font);
  love.graphics.print(txt,self.x+self.txt_offset_x,self.y+self.txt_offset_y);
end

return Frame

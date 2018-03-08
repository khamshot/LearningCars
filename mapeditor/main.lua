local Wall = require "wall"
local Button = require "button"

function love.load()
  --state true => first part of the wall
  --state false =>second part of the wall
  state = true
  p1 = {}
  p2 = {}

  walls = {}
  --set color here
  color = {255,255,22,255}
  love.graphics.setColor(color)
  
  --save button
  saveButton = button_new({x=10,y=10,width=60,height=30,txt="Save",color={255,200,200,255},activeColor={200,200,255,255},fontSize=25,txtOffset={15,7}});
  saveButton.exec = function()
    print("enter filename")
    local filename = io.read() .. ".map"
    local file = ""
    for i,v in ipairs(walls) do
      file = file .. v.x1 .. "," .. v.y1 .. "," .. v.x2 .. "," .. v.y2 .. "," .. v.color[1] .. "," .. v.color[2] .. "," .. v.color[3] .. "," .. v.color[4] .. "\r\n"
    end
    love.filesystem.write(filename,file)
    love.event.quit()
  end
end

function love.update(dt)
  if state then
    --first point of wall
    if mousePressed(1) then
      p1[1],p1[2] = love.mouse.getPosition() 
      state = false
    end
  else
    --last point of wall
    if mousePressed(1) then
      p2[1],p2[2] = love.mouse.getPosition() 
      table.insert(walls,Wall.new({x1=p1[1],y1=p1[2],x2=p2[1],y2=p2[2],color=color}))
      p1 = {p2[1],p2[2]}
    end
    if mousePressed(2) then
      state = true
    end
  end
  
  if keyPressed("w") then
    for i,v in ipairs(walls) do
      v.y1 = v.y1 + 50
      v.y2 = v.y2 + 50
    end
    p1[2] = p1[2] + 50
  end
  if keyPressed("s") then
    for i,v in ipairs(walls) do
      v.y1 = v.y1 - 50
      v.y2 = v.y2 - 50
    end
    p1[2] = p1[2] - 50
  end
  if keyPressed("a") then
    for i,v in ipairs(walls) do
      v.x1 = v.x1 + 50
      v.x2 = v.x2 + 50
    end
    p1[1] = p1[1] + 50
  end
  if keyPressed("d") then
    for i,v in ipairs(walls) do
      v.x1 = v.x1 - 50
      v.x2 = v.x2 - 50
    end
    p1[1] = p1[1] - 50
  end
  
  saveButton:update(dt)
end

function love.draw()
  --draw all walls added
  for i=1,#walls do
    walls[i]:draw()
  end
  --draw mousewall
  if not state then
  love.graphics.line(p1[1],p1[2],love.mouse.getX(),love.mouse.getY()) end
  
  --draw spawnpoint of car
  love.graphics.rectangle("fill",790,435,20,30)
  
  saveButton:draw()
end

mousebuttons = {
  false,
  false,
  false};

keys = {
  w=false,
  a=false,
  s=false,
  d=false}

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

function keyPressed(p_key)
  if love.keyboard.isDown(p_key) then
    if keys[p_key] then
      return false
    else
      keys[p_key] = true
      return true
    end
  else
    keys[p_key] = false
  end
end
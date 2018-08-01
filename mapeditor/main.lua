require "savemap"

map = {
  walls = {},
  checkpoints = {}}

text = "walls"

temp = {
  drawEnable = false,
  x=0,y=0}

offset = {x=0, y=0}

car = love.graphics.newImage("car1.png")

function love.load()
  love.filesystem.setIdentity("LearningCars")
  love.window.setMode(1920,1080,{fullscreen=false})
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.setColor(255,0,0,255)
  if text == "checkpoints" then 
    love.graphics.setColor(0,255,0,255)
  end
  if temp.drawEnable then
    love.graphics.line(temp.x,temp.y,love.mouse.getX(),love.mouse.getY())
  end
  love.graphics.print(text,20,20)
  
  love.graphics.setColor(255,0,0,255)
  for i,v in ipairs(map.walls) do
    love.graphics.line(v.x-offset.x,v.y-offset.y,v.x2-offset.x,v.y2-offset.y)
  end
  love.graphics.setColor(0,255,0,255)
  for i,v in ipairs(map.checkpoints) do
    love.graphics.line(v.x-offset.x,v.y-offset.y,v.x2-offset.x,v.y2-offset.y)
  end
  love.graphics.draw(car,840-offset.x,750-offset.y,math.pi)
end

function love.keypressed(key)
  if key == "2" then
    text = "checkpoints"
  end
  if key == "1" then
    text = "walls"
  end
  if key == "escape" then
    if love.window.showMessageBox( "save", "map is saved in Temp/Roaming/Love/LearningCars/maps/...") then
      saveMap(map.walls,map.checkpoints)
      love.event.quit()
    end
  end
  if key == "backspace" or key == "x" then
    if text == "checkpoints" then
      table.remove(map.checkpoints,#map.checkpoints)
    else
      table.remove(map.walls,#map.walls)
    end
  end
  
  if key == "a" then
    offset.x = offset.x - 300
  elseif key == "d" then
    offset.x = offset.x + 300
  elseif key == "w" then
    offset.y = offset.y - 300
  elseif key == "s" then
    offset.y = offset.y + 300
  end
end

function love.mousepressed(mouseX,mouseY,button)
  if button == 1 then
    temp.x = mouseX
    temp.y = mouseY
    temp.drawEnable = true
  end
  if button == 2 then
    temp.drawEnable = false
  end
end

function love.mousereleased(mouseX,mouseY,button)
  if button ~= 1 then return 0 end
  
  if text == "checkpoints" then
    table.insert(map.checkpoints,{x=temp.x+offset.x,y=temp.y+offset.y,x2=mouseX+offset.x,y2=mouseY+offset.y})
  end
  if text == "walls" then
    table.insert(map.walls,{x=temp.x+offset.x,y=temp.y+offset.y,x2=mouseX+offset.x,y2=mouseY+offset.y})
  end
  
  temp.drawEnable = false
end
 
 
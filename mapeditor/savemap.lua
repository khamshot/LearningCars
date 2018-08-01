function saveMap(walls,checkpoints)
  math.randomseed(os.time())
  filename = "maps/map" .. math.random(99) ..".lua"
  
  data =         "local wall = require \"world/wall\"\r\n"
  data = data .. "local checkpoint = require \"world/checkpoint\"\r\n"
  data = data .. "\r\n"
  data = data .. "local map = {}\r\n"
  data = data .. "map.walls = {}\r\n"
  data = data .. "map.checkpoints = {}\r\n"
  data = data .. "\r\n"

  for i,v in ipairs(walls) do
    data = data .. "table.insert(map.walls,wall({x=" .. v.x .. ",y=" .. v.y .. ",x2=" .. v.x2 .. ",y2=" .. v.y2 .. "}))\r\n"
  end

  data = data .. "\r\n"
  
  for i,v in ipairs(checkpoints) do
    data = data .. "table.insert(map.checkpoints,checkpoint({x=" .. v.x .. ",y=" .. v.y .. ",x2=" .. v.x2 .. ",y2=" .. v.y2 .. "}))\r\n"
  end
  
  data = data .. "\r\n"
  data = data .. "return map"
  
  love.filesystem.createDirectory("maps")
  love.filesystem.write(filename,data)
end
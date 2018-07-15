require "libs/helper"
require "settings"
require "gamemode"
require "world/world"

function love.load()
  math.randomseed(os.time())
  
  love.graphics.setBackgroundColor(11,11,11)
  settings.setScreenResolution(960,540,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1920,1080,{resizable=false,fullscreen=true})
  
  world:generateCars(9)
  world:generateNetworks(9,400)
 
  local map01 = require "maps/map01"
  world:setWalls(map01.walls)
  world:setCheckpoints(map01.checkpoints)
end

function love.update(dt)
  if dt > 0.05 then dt = 0.05 end
  if gamemode.world.update then
    world:update(dt) 
  end
end

function love.draw()
  if gamemode.world.draw then
    world:draw() 
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x,y,button)
  if not button == 1 then
    return 0
  end
  if gamemode.world.update then
    world:updateUI(x,y)
  end
end
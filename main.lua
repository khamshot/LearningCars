require "settings"
require "libs/helper"
require "world/world"

local car = require "world/car"
local wall = require "world/wall"

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(11,11,11)
  --settings.setScreenResolution(960,540,{resizable=false,fullscreen=false})
  settings.setScreenResolution(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1920,1080,{resizable=false,fullscreen=true})
  
  world:generateCars(10)
  world:generateNetworks(10,40)
 
  local map01 = require "maps/map01"
  world:setWalls(map01.walls)
  world:setCheckpoints(map01.checkpoints)
  
end

function love.update(dt)
  if dt > 0.05 then dt = 0.05 end
  world:update(dt)
end

function love.draw()
  world:draw()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
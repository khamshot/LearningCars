require "settings"
require "libs/helper"
require "world"

local car = require "car"
local wall = require "wall"

function love.load()
  settings.setScreenResolution(960,540,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1920,1080,{resizable=false,fullscreen=true})
  
  world:setCars(
    {car({color={11,211,0}}),
     car({x=100,y=100,color={11,211,222}}),
     car({x=-100,y=400,color={11,11,222}})})
  world:addObject(wall({x=500,y=200,x2=200,y2=300}),"walls")
  world:addObject(wall({x=-50,y=-200,x2=200,y2=-200}),"walls")
end

function love.update(dt)
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
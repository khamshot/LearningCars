require "libs/helper"
require "settings"
require "gamemode"
require "world/world"
require "menu/menu"

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(11,11,11)
  
  settings.setScreenResolution(960,540,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenResolution(1920,1080,{resizable=false,fullscreen=true})
  
  gamemode.setmode(false,false,true,true)
  menu:setItems(require "menus/mainMenu")
  
  world:generateCars(9)
  world:generateNetworks(9,400)
  
  local map01 = require "maps/map01"
  world:setWalls(map01.walls)
  world:setCheckpoints(map01.checkpoints)
end

function love.update(dt)
  if dt < gamemode.deltaTime then
    love.timer.sleep(gamemode.deltaTime - dt)
  end
  dt = gamemode.deltaTime
  
  if gamemode.world.update then
    world:update(dt) 
  end
  if gamemode.menu.update then
    menu:update() 
  end
end

function love.draw()
  if gamemode.world.draw then
    world:draw() 
  end
  if gamemode.menu.draw then
    menu:draw() 
  end
end

function love.keypressed(key)
  if key == "escape" then
    gamemode.setmode(not gamemode.world.update,true,not gamemode.menu.update,not gamemode.menu.draw)
  end
end

function love.mousepressed(x,y,button)
  if button ~= 1 then return 0 end
  
  if gamemode.world.update then
    world:updateUI(x,y)
  end
  if gamemode.menu.update then
    menu:update(x,y)
  end
end
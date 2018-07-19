require "libs/helper"
require "settings"
require "gamemode"
require "world/world"
require "menu/menu"

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(11,11,11)
  
  settings.setScreenRes(960,540,{resizable=false,fullscreen=false})
  --settings.setScreenRes(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenRes(1920,1080,{resizable=false,fullscreen=true})
  settings.setDefaultRes(1920/1.5,1080/1.5)
  
  gamemode.setmode(false,false,true,true)
  menu:setItems(require "menus/mainMenu")
  
  world:generateCars(9,840,750)
  world:generateNetworks(9,400)
  
  local map = require "maps/map03"
  world:setWalls(map.walls)
  world:setCheckpoints(map.checkpoints)
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
    menu:update({}) 
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
  if key == settings.keys.escape then
    gamemode.setmode(not gamemode.world.update,true,not gamemode.menu.update,not gamemode.menu.draw)
  end
end

function love.mousepressed(x,y,button)
  if button ~= 1 then return 0 end
  if gamemode.world.update then
    world:updateUI({mouseX=x,mouseY=y,mousePressed=true})
  end
  if gamemode.menu.update then
    menu:update({mouseX=x,mouseY=y,mousePressed=true})
  end
end

function love.mousereleased(x,y,button)
  if button ~= 1 then return 0 end
  if gamemode.world.update then
    world:updateUI({mouseX=x,mouseY=y,mouseReleased=true})
  end
  if gamemode.menu.update then
    menu:update({mouseX=x,mouseY=y,mouseReleased=true})
  end
end
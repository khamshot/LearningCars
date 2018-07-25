utf8 = require("utf8")
require "libs/ser"
require "libs/helper"
require "settings"
require "gamemode"
require "world/world"
require "menu/menu"

function love.load()
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(11,11,11)
  
  settings.setDefaultRes(1920/1.5,1080/1.5)
  settings.setScreenRes(960,540,{resizable=false,fullscreen=false})
  --settings.setScreenRes(1600,1000,{resizable=false,fullscreen=false})
  --settings.setScreenRes(1920,1080,{resizable=false,fullscreen=true})
  
  gamemode.setmode(false,false,true,true)
  menu:setMenu(require "menus/startMenu")
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
-- if done differently switching between states becomes inconsistent
  if gamemode.world.update and gamemode.menu.update then
    world:updateUI({key=key}) 
    menu:update({key=key}) 
  elseif gamemode.world.update and not gamemode.menu.update then
    world:updateUI({key=key}) 
  elseif not gamemode.world.update and gamemode.menu.update then
    menu:update({key=key}) 
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

function love.wheelmoved(x,y)
  if y > 0 then
    settings.setDefaultRes(settings.default.w*0.8,settings.default.h*0.8)
  else
    settings.setDefaultRes(settings.default.w*1.2,settings.default.h*1.2)
  end
end
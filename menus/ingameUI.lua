local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"

local ingameUI = {
  ID = "ingameUI",
  items = {},
  popupItems = {}}

table.insert(ingameUI.items,frame({x=1450,y=20,width=450,height=330,img=2,color={255,255,255,135}}))

table.insert(ingameUI.items,frame({x=1465,y=13,width=0,height=0,txt="generation:"}))
table.insert(ingameUI.items,frame({x=1700,y=13,width=0,height=0,
  exec=function(self)
    self.txt = world.generation 
  end}))

table.insert(ingameUI.items,frame({x=1465,y=65,width=0,height=0,txt="current:"}))
table.insert(ingameUI.items,frame({x=1700,y=65,width=0,height=0,
  exec=function(self)
    self.txt = math.floor(world.focus.fitness) 
  end}))

table.insert(ingameUI.items,frame({x=1465,y=120,width=0,height=0,txt="fittest:"}))
table.insert(ingameUI.items,frame({x=1700,y=120,width=0,height=0,txt="0",
  exec=function(self) 
    if math.floor(world.focus.fitness) > tonumber(self.txt) then 
      self.txt = math.floor(world.focus.fitness) 
    end 
  end}))

table.insert(ingameUI.items,checkbox({x=1480,y=215,width=40,height=40,value=true,
  exec=function(self) 
    gamemode.showSensors = self.value 
  end}))
table.insert(ingameUI.items,frame({x=1530,y=185,width=0,height=0,txt="show sensors"}))

table.insert(ingameUI.items,checkbox({x=1480,y=280,width=40,height=40,value=true,
  exec=function(self) 
    gamemode.showTrails = self.value 
  end}))
table.insert(ingameUI.items,frame({x=1530,y=250,width=0,height=0,txt="show trails"}))

table.insert(ingameUI.items,frame({x=1530,y=250,width=0,height=0,
  exec=function(self,input)
    if input.key == settings.keys.escape then
      if menu.ID ~= "pause" then
        menu:setMenu(require "menus/pauseMenu")
      end
      gamemode.setmode(false,true,true,true)
    end
  end}))

return ingameUI
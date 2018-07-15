local frame = require "menu/frame"
local checkbox = require "menu/checkbox"

local ingameUI = {}

table.insert(ingameUI,frame({x=1300,y=20,width=600,height=400,img=1,color={255,255,255,135}}))

table.insert(ingameUI,frame({x=1315,y=13,width=0,height=0,txt="generation:"}))
table.insert(ingameUI,frame({x=1570,y=13,width=0,height=0,
  exec=function(self) self.txt = world.generation end}))

table.insert(ingameUI,frame({x=1315,y=65,width=0,height=0,txt="current:"}))
table.insert(ingameUI,frame({x=1570,y=65,width=0,height=0,
  exec=function(self) self.txt = math.floor(world.focus.fitness) end}))

table.insert(ingameUI,frame({x=1315,y=120,width=0,height=0,txt="fittest:"}))
table.insert(ingameUI,frame({x=1570,y=120,width=0,height=0,txt="0",
  exec=function(self) if math.floor(world.focus.fitness) > tonumber(self.txt) then self.txt = math.floor(world.focus.fitness) end end}))

table.insert(ingameUI,checkbox({x=1330,y=275,width=40,height=40,value=true,
  exec=function(self) gamemode.showSensors = self.value end}))
table.insert(ingameUI,frame({x=1380,y=250,width=0,height=0,txt="show sensors"}))

table.insert(ingameUI,checkbox({x=1330,y=340,width=40,height=40,value=true,
  exec=function(self) gamemode.showTrails = self.value end}))
table.insert(ingameUI,frame({x=1380,y=310,width=0,height=0,txt="show trails"}))

return ingameUI
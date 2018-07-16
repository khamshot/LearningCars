local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"

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

table.insert(ingameUI,checkbox({x=1330,y=215,width=40,height=40,value=true,
  exec=function(self) gamemode.showSensors = self.value end}))
table.insert(ingameUI,frame({x=1380,y=185,width=0,height=0,txt="show sensors"}))

table.insert(ingameUI,checkbox({x=1330,y=280,width=40,height=40,value=true,
  exec=function(self) gamemode.showTrails = self.value end}))
table.insert(ingameUI,frame({x=1380,y=250,width=0,height=0,txt="show trails"}))

table.insert(ingameUI,slider({x=1340,y=360,width=300,height=30,minValue=0.1,maxValue=1,value=gamemode.trailTimer,color={255,255,255,255},
  exec=function(self) gamemode.trailTimer = self.value end}))
table.insert(ingameUI,frame({x=1650,y=330,width=0,height=0,txt="trail timer"}))

return ingameUI
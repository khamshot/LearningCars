local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local mainMenu = {}

table.insert(mainMenu,frame({x=660,y=400,width=600,height=400,img=2,color={255,255,255,135}}))

table.insert(mainMenu,button({x=890,y=440,width=120,height=100,txt="PLAY",txtColorOffset={255,0,0,255},
  exec=function(self) gamemode.setmode(true,true,false,false) end}))

table.insert(mainMenu,slider({x=810,y=600,width=300,height=42,minValue=0.005,maxValue=0.03,value=gamemode.deltaTime,img=2,
  exec=function(self) gamemode.deltaTime = self.value end}))
table.insert(mainMenu,frame({x=810,y=650,width=0,height=0,
  exec=function(self) self.txt="Deltatime: " .. string.format("%1.3f",gamemode.deltaTime) end}))

table.insert(mainMenu,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self) love.event.quit() end}))

return mainMenu
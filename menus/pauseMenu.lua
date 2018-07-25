local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local pauseMenu = {
  ID = "pause",
  items = {},
  popupItems = {}}

table.insert(pauseMenu.items,frame({x=660,y=400,width=600,height=400,img=2,color={255,255,255,135}}))

table.insert(pauseMenu.items,button({x=870,y=440,width=190,height=100,img=4,txtOffset={35,10},txt="RESUME",txtColorOffset={255,0,0,255},
  exec=function(self) 
    gamemode.setmode(true,true,false,false) 
  end}))

table.insert(pauseMenu.items,slider({x=810,y=600,width=300,height=42,minValue=0.005,maxValue=0.03,value=gamemode.deltaTime,img=2,
  exec=function(self) gamemode.deltaTime = self.value end}))
table.insert(pauseMenu.items,frame({x=810,y=650,width=0,height=0,
  exec=function(self)
    self.txt="Deltatime: " .. string.format("%1.3f",gamemode.deltaTime) 
  end}))

table.insert(pauseMenu.items,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu.popupEnable = true
  end}))

table.insert(pauseMenu.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      gamemode.setmode(true,true,false,false)
    end
  end}))

--- POPUPS ---

table.insert(pauseMenu.popupItems,frame({x=770,y=420,width=380,height=300,img=2,color={255,255,255,255}}))
table.insert(pauseMenu.popupItems,frame({x=790,y=440,width=340,height=160,img=3,color={255,255,255,255}}))
table.insert(pauseMenu.popupItems,frame({x=810,y=440,width=380,height=300,txt="DO YOU REALLY",color={255,255,255,255}}))
table.insert(pauseMenu.popupItems,frame({x=810,y=500,width=380,height=300,txt="WANT TO QUIT?",color={255,255,255,255}}))
table.insert(pauseMenu.popupItems,button({x=790,y=625,width=160,height=72,img=4,txt="QUIT",txtOffset={40,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    love.event.quit()
  end}))
table.insert(pauseMenu.popupItems,button({x=970,y=625,width=160,height=72,img=4,txt="CANCEL",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu.popupEnable = false
  end}))

return pauseMenu
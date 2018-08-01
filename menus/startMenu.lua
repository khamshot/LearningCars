local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local startMenu = {
  ID = "start",
  items = {},
  popupItems = {}}

table.insert(startMenu.items,frame({x=660,y=200,width=600,height=600,img=2,color={255,255,255,135}}))
table.insert(startMenu.items,frame({x=660,y=200,width=600,height=600,img=2,color={255,255,255,135}}))

table.insert(startMenu.items,button({x=885,y=240,width=160,height=90,img=4,txtOffset={35,10},txt="PLAY",txtColorOffset={255,0,0,255},
  exec=function(self) 
    if #world.networks == 0 then
      world:generateNetworks(9,400)
    end
    if #world.walls == 0 and #world.checkpoints == 0 then
      local map = require "maps/default"
      print(map)
      world:setWalls(map.walls)
      world:setCheckpoints(map.checkpoints)
    end
    world:generateCars(9,840,750)
    gamemode.setmode(true,true,false,false) 
  end}))

table.insert(startMenu.items,button({x=805,y=370,width=330,height=90,img=4,txtOffset={35,10},txt="LOAD NETWORKS",txtColorOffset={255,0,0,255},
  exec=function(self) 
    menu:setMenu(require "menus/loadNetworks")
  end}))

table.insert(startMenu.items,button({x=840,y=500,width=250,height=90,img=4,txtOffset={35,10},txt="LOAD MAP",txtColorOffset={255,0,0,255},
  exec=function(self) 
    menu:setMenu(require "menus/loadMap")
  end}))

table.insert(startMenu.items,button({x=860,y=630,width=210,height=90,img=4,txtOffset={35,10},txt="OPTIONS",txtColorOffset={255,0,0,255},
  exec=function(self) 
    menu:setMenu(require "menus/optionMenu")
  end}))

table.insert(startMenu.items,button({x=1200,y=180,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu.popupEnable = 1
  end}))

table.insert(startMenu.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu.popupEnable = 1
    end
  end}))

--- POPUPS ---

startMenu.popupItems[1] = {}
table.insert(startMenu.popupItems[1],frame({x=770,y=220,width=380,height=300,img=2,color={255,255,255,255}}))

table.insert(startMenu.popupItems[1],frame({x=790,y=240,width=340,height=160,img=3,color={255,255,255,255}}))
table.insert(startMenu.popupItems[1],frame({x=810,y=240,width=380,height=300,txt="DO YOU REALLY",color={255,255,255,255}}))
table.insert(startMenu.popupItems[1],frame({x=810,y=300,width=380,height=300,txt="WANT TO QUIT?",color={255,255,255,255}}))

table.insert(startMenu.popupItems[1],button({x=790,y=425,width=160,height=72,img=4,txt="QUIT",txtOffset={40,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    love.event.quit()
  end}))

table.insert(startMenu.popupItems[1],button({x=970,y=425,width=160,height=72,img=4,txt="CANCEL",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu.popupEnable = false
  end}))

table.insert(startMenu.popupItems[1],frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu.popupEnable = false
    elseif input.key == settings.keys.enter then
      love.event.quit()
    end
  end}))

return startMenu
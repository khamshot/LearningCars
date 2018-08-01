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

table.insert(pauseMenu.items,button({x=805,y=560,width=330,height=90,img=4,txtOffset={35,10},txt="SAVE NETWORKS",txtColorOffset={255,0,0,255},
  exec=function(self) 
    pauseMenu.popupItems[2][2].txt = ""
    menu.popupEnable = 2
  end}))

table.insert(pauseMenu.items,button({x=805,y=680,width=330,height=90,img=4,txtOffset={35,10},txt="MAIN MENU",txtColorOffset={255,0,0,255},
  exec=function(self) 
    world:clear()
    gamemode.setmode(false,false,true,true) 
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(pauseMenu.items,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu.popupEnable = 1
  end}))

table.insert(pauseMenu.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      gamemode.setmode(true,true,false,false)
    end
  end}))

--- POPUP 1---

pauseMenu.popupItems[1] = {}
table.insert(pauseMenu.popupItems[1],frame({x=770,y=420,width=380,height=300,img=2,color={255,255,255,255}}))

table.insert(pauseMenu.popupItems[1],frame({x=790,y=440,width=340,height=160,img=3,color={255,255,255,255}}))
table.insert(pauseMenu.popupItems[1],frame({x=810,y=440,width=380,height=300,txt="DO YOU REALLY",color={255,255,255,255}}))
table.insert(pauseMenu.popupItems[1],frame({x=810,y=500,width=380,height=300,txt="WANT TO QUIT?",color={255,255,255,255}}))

table.insert(pauseMenu.popupItems[1],button({x=790,y=625,width=160,height=72,img=4,txt="QUIT",txtOffset={40,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    love.event.quit()
  end}))

table.insert(pauseMenu.popupItems[1],button({x=970,y=625,width=160,height=72,img=4,txt="CANCEL",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu.popupEnable = false
  end}))

table.insert(pauseMenu.popupItems[1],frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu.popupEnable = false
    elseif input.key == settings.keys.enter then
      love.event.quit()
    end
  end}))

--- POPUP 2---

pauseMenu.popupItems[2] = {}
table.insert(pauseMenu.popupItems[2],frame({x=770,y=420,width=380,height=300,img=2,txt="INPUT FILENAME:",color={255,255,255,255}}))
table.insert(pauseMenu.popupItems[2],frame({x=770,y=520,width=380,height=300,color={255,255,255,255}}))

table.insert(pauseMenu.popupItems[2],button({x=790,y=625,width=160,height=72,img=4,txt="SAVE",txtOffset={40,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    helper.exportNetworks(pauseMenu.popupItems[2][2].txt,world.networks)
    menu.popupEnable = false
  end}))

table.insert(pauseMenu.popupItems[2],button({x=970,y=625,width=160,height=72,img=4,txt="CANCEL",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu.popupEnable = false
  end}))

table.insert(pauseMenu.popupItems[2],frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu.popupEnable = false
    elseif input.key == settings.keys.backspace then
      local byteoffset = utf8.offset(pauseMenu.popupItems[2][2].txt, -1)
      if byteoffset then
        pauseMenu.popupItems[2][2].txt = string.sub(pauseMenu.popupItems[2][2].txt, 1, byteoffset - 1)
      end
    elseif input.key then
      pauseMenu.popupItems[2][2].txt = pauseMenu.popupItems[2][2].txt .. input.key
    end
  end}))

return pauseMenu
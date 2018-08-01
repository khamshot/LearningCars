local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local optionMenu = {
  ID = "options",
  items = {},
  popupItems = {}}

table.insert(optionMenu.items,frame({x=660,y=400,width=600,height=400,img=2,color={255,255,255,135}}))

table.insert(optionMenu.items,slider({x=810,y=500,width=300,height=42,minValue=0.005,maxValue=0.03,value=gamemode.deltaTime,img=2,
  exec=function(self)
  end}))
table.insert(optionMenu.items,frame({x=810,y=550,width=0,height=0,
  exec=function(self)
    self.txt = "Deltatime: " .. string.format("%1.3f",optionMenu.items[2].value) 
  end}))

table.insert(optionMenu.items,button({x=775,y=660,width=150,height=90,img=4,txtOffset={35,10},txt="SAVE",txtColorOffset={255,0,0,255},
  exec=function(self) 
    gamemode.deltaTime = helper.round(optionMenu.items[2].value,3,true)
    menu.popupEnable = 1
  end}))

table.insert(optionMenu.items,button({x=1005,y=660,width=150,height=90,img=4,txtOffset={35,10},txt="BACK",txtColorOffset={255,0,0,255},
  exec=function(self) 
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(optionMenu.items,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(optionMenu.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu:setMenu(require "menus/startMenu")
    elseif input.key == settings.keys.enter then
      gamemode.deltaTime = helper.round(optionMenu.items[2].value,3,true)
      menu.popupEnable = 1
    end
  end}))

--- POPUP 1---

optionMenu.popupItems[1] = {}
table.insert(optionMenu.popupItems[1],frame({x=810,y=420,width=300,height=180,img=2,color={255,255,255,255}}))
table.insert(optionMenu.popupItems[1],frame({x=890,y=425,txt="SAVED",color={255,255,255,255}}))

table.insert(optionMenu.popupItems[1],button({x=890,y=505,width=160,height=72,img=4,txt="OK",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(optionMenu.popupItems[1],frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu:setMenu(require "menus/startMenu")
    elseif input.key == settings.keys.enter then
      menu:setMenu(require "menus/startMenu")
    end
  end}))

return optionMenu
local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local loadMap = {
  ID = "", 
  items = {},
  popupItems = {},
  placeholder = love.filesystem.getDirectoryItems("maps")}

table.insert(loadMap.items,frame({x=660,y=400,width=600,height=400,img=2,color={255,255,255,135}}))

table.insert(loadMap.items,slider({x=810,y=460,width=300,height=42,minValue=1,maxValue=#love.filesystem.getDirectoryItems("maps")+0.99,value=1,img=2}))
table.insert(loadMap.items,frame({x=810,y=510,width=0,height=0,
  exec=function(self)
    self.txt = loadMap.placeholder[math.floor(loadMap.items[2].value)]
  end}))

table.insert(loadMap.items,button({x=785,y=640,width=160,height=90,img=4,txtOffset={35,10},txt="LOAD",txtColorOffset={255,0,0,255},
  exec=function(self) 
    local map = require("maps/" .. string.gsub(loadMap.placeholder[math.floor(loadMap.items[2].value)],".lua",""))
    world:setWalls(map.walls)
    world:setCheckpoints(map.checkpoints)
    menu.popupEnable = 1
  end}))

table.insert(loadMap.items,button({x=985,y=640,width=160,height=90,img=4,txtOffset={25,10},txt="CANCEL",txtColorOffset={255,0,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadMap.items,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadMap.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu:setMenu(require "menus/startMenu")
    end
  end}))

--- POPUP 1 ---

loadMap.popupItems[1] = {}
table.insert(loadMap.popupItems[1],frame({x=810,y=420,width=300,height=180,img=2,color={255,255,255,255}}))
table.insert(loadMap.popupItems[1],frame({x=880,y=425,txt="LOADED",color={255,255,255,255}}))

table.insert(loadMap.popupItems[1],button({x=890,y=505,width=160,height=72,img=4,txt="OK",txtOffset={25,3},txtColorOffset={255,0,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadMap.popupItems[1],frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu:setMenu(require "menus/startMenu")
    elseif input.key == settings.keys.enter then
      menu:setMenu(require "menus/startMenu")
    end
  end}))

return loadMap
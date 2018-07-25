local frame = require "menu/frame"
local checkbox = require "menu/checkbox"
local slider = require "menu/slider"
local button = require "menu/button"

local loadNetworks = {
  ID = "", 
  items = {},
  popupItems = {},
  placeholder = love.filesystem.getDirectoryItems("networks")}

table.insert(loadNetworks.items,frame({x=660,y=400,width=600,height=400,img=2,color={255,255,255,135}}))

table.insert(loadNetworks.items,slider({x=810,y=460,width=300,height=42,minValue=1,maxValue=#love.filesystem.getDirectoryItems("networks"),value=1,img=2}))
table.insert(loadNetworks.items,frame({x=810,y=510,width=0,height=0,
  exec=function(self)
    self.txt = loadNetworks.placeholder[math.floor(loadNetworks.items[2].value)]
  end}))

table.insert(loadNetworks.items,button({x=785,y=640,width=160,height=90,img=4,txtOffset={35,10},txt="LOAD",txtColorOffset={255,0,0,255},
  exec=function(self) 
    world:setNetworks(helper.importNetworks("networks/" .. loadNetworks.placeholder[math.floor(loadNetworks.items[2].value)]))
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadNetworks.items,button({x=985,y=640,width=160,height=90,img=4,txtOffset={25,10},txt="CANCEL",txtColorOffset={255,0,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadNetworks.items,button({x=1200,y=380,width=76,height=72,img=5,colorOffset={255,255,0,255},
  exec=function(self)
    menu:setMenu(require "menus/startMenu")
  end}))

table.insert(loadNetworks.items,frame({
  exec=function(self,input)
    if input.key == settings.keys.escape then
      menu:setMenu(require "menus/startMenu")
    end
  end}))

return loadNetworks
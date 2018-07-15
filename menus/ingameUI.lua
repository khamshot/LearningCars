local frame = require "menu/frame"
local checkbox = require "menu/checkbox"

local ingameUI = {}

table.insert(ingameUI,frame({x=1300,y=20,width=600,height=400,txtOffset={30,25},txt="fitness:",color={255,255,255,135}}))
table.insert(ingameUI,checkbox({x=1330,y=150,width=40,height=40,exec=function() gamemode.showTrails = self.value end}))

return ingameUI
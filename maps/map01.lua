local wall = require "world/wall"
local checkpoint = require "world/checkpoint"

local map01 = {}
map01.walls = {}
map01.checkpoints = {}

table.insert(map01.walls,wall({x=1550,y=600,x2=1420,y2=600,color={255,111,66,255}}))
table.insert(map01.walls,wall({x=1550,y=400,x2=1550,y2=600}))
table.insert(map01.walls,wall({x=1420,y=400,x2=1420,y2=600}))
table.insert(map01.walls,wall({x=1550,y=400,x2=1450,y2=200}))
table.insert(map01.walls,wall({x=1420,y=400,x2=1300,y2=250}))
table.insert(map01.walls,wall({x=1450,y=200,x2=1100,y2=100}))
table.insert(map01.walls,wall({x=1300,y=250,x2=800,y2=175}))
table.insert(map01.walls,wall({x=1100,y=100,x2=700,y2=100}))
table.insert(map01.walls,wall({x=600,y=200,x2=700,y2=100}))
table.insert(map01.walls,wall({x=600,y=200,x2=550,y2=500}))
table.insert(map01.walls,wall({x=700,y=270,x2=600,y2=600}))
table.insert(map01.walls,wall({x=700,y=270,x2=800,y2=175}))
table.insert(map01.walls,wall({x=550,y=500,x2=350,y2=600}))
table.insert(map01.walls,wall({x=600,y=600,x2=300,y2=750}))
table.insert(map01.walls,wall({x=350,y=600,x2=150,y2=700}))
table.insert(map01.walls,wall({x=150,y=700,x2=125,y2=800}))
table.insert(map01.walls,wall({x=300,y=750,x2=275,y2=800}))
table.insert(map01.walls,wall({x=125,y=800,x2=155,y2=900}))
table.insert(map01.walls,wall({x=275,y=800,x2=300,y2=850}))
table.insert(map01.walls,wall({x=155,y=900,x2=190,y2=950}))
table.insert(map01.walls,wall({x=190,y=950,x2=250,y2=990}))
table.insert(map01.walls,wall({x=250,y=990,x2=1300,y2=950}))
table.insert(map01.walls,wall({x=300,y=850,x2=1300,y2=900}))
table.insert(map01.walls,wall({x=1300,y=950,x2=1300,y2=900}))

table.insert(map01.checkpoints,checkpoint({x=0,y=0,x2=1000,y2=1000,color={0,255,255,255}}))
table.insert(map01.checkpoints,checkpoint({x=1000,y=0,x2=0,y2=1000,color={0,255,255,255}}))

return map01
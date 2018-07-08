local matrix = require "libs/matrix"

local car = {}

-- creating an instance with car.new() or car()
setmetatable(car,
  {__call = function(self,...) return self.new(...) end})

car.width = 20
car.length = 30
car.speed = 1000
car.turnspeed = 25
car.sensorlen = 120
car.img = love.graphics.newImage("media/car.png")

function car.new(init)
  local self = setmetatable({}, {__index=car})
      
  self.rot = init.rot or math.pi
  self.vec = {0,1}
  self.x = init.x or 400
  self.y = init.y or 400
  self.color = init.color or {255,255,255,255}
  self.img = init.img and love.graphics.newImage(init.img) or car.img
  
  self.sensorL = {}
  self.sensorM = {}
  self.sensorR = {}
  
  self.ID = init.ID
  self.crashed = false
  self.fitness = 0
  self.trailTimer = 0.25
  self.trail = {}
  table.insert(self.trail,{x=self.x,y=self.y})
  
  self:update_sensors()
  return self
end

-- UPDATE --

function car:update(dt,walls,checkpoints,factor1,factor2)
  if not self.crashed then
    self:move(dt,factor1)
    self:turn(dt,factor2)
    self:update_sensors()
    self:doTrail(dt)
    self:checkColWalls(walls)
    self:checkColCheckpoints(checkpoints)
  end
end

function car:move(dt,factor)
-- moves the car forward * a factor
  self.fitness = self.fitness + (((self.speed*self.vec[1]*dt)^2 + (self.speed*self.vec[2]*dt)^2)^0.5)*factor
  
  self.x = self.x + self.speed*self.vec[1]*dt*(factor)
  self.y = self.y + self.speed*self.vec[2]*dt*(factor)
end

function car:turn(dt,factor)
-- changes the cars orientation * a factor
  self.rot = self.rot + self.turnspeed*dt*(factor-0.5)
  self.rot = self.rot % (2*math.pi)
  
  self.vec[1] = math.sin(-self.rot)
  self.vec[2] = math.cos(self.rot)
end

function car:doTrail(dt)
-- adds a point to the trail table every trailTimer
  self.trailTimer = self.trailTimer - dt
  if self.trailTimer <= 0 then
    table.insert(self.trail,{x=self.x,y=self.y})
    self.trailTimer = 0.25
  end
end
  
function car:checkColWalls(walls)
--checks for collision with walls
  local collision = false
  local tempboolL,tempboolR = false,false
  for i,v in ipairs(walls) do
    tempboolL = matrix.vector_intersection({self.x,self.y},self.sensorL[1],{v.x,v.y},{v.x2,v.y2})
    tempboolR = matrix.vector_intersection({self.x,self.y},self.sensorR[1],{v.x,v.y},{v.x2,v.y2})
    collision = tempboolL or tempboolR or collision
  end
  if collision then
    table.insert(self.trail,{x=self.x,y=self.y})
    self.crashed = true
  end
end

function car:checkColCheckpoints(checkpoints)
-- checks if car collides with checkpoint and gives fitness
  for i,v in ipairs(checkpoints) do
    tempboolL = matrix.vector_intersection({self.x,self.y},self.sensorL[1],{v.x,v.y},{v.x2,v.y2})
    tempboolR = matrix.vector_intersection({self.x,self.y},self.sensorR[1],{v.x,v.y},{v.x2,v.y2})
    if tempboolL or tempboolR then
      if not v.checkID(self.ID) then
        v.addID(self.ID)
        self.fitness = self.fitness + v.reward
      end
    end
  end  
end

function car:update_sensors()
  --refreshes the positions of the sensors
  --left sensor
  self.sensorL[1] = {self.x-math.sin(self.rot)*self.length - math.cos(self.rot-math.pi)*self.width/2,
    self.y+math.cos(self.rot)*self.length - math.sin(self.rot-math.pi)*self.width/2}
  self.sensorL[2] = {self.x-math.sin(self.rot)*self.length-math.sin(self.rot-math.pi/4)*self.sensorlen - math.cos(self.rot-math.pi)*self.width/2,
    self.y+math.cos(self.rot)*self.length+math.cos(self.rot-math.pi/4)*self.sensorlen - math.sin(self.rot-math.pi)*self.width/2}  
  
  --middle sensor
  self.sensorM[1] = {self.x-math.sin(self.rot)*self.length,
    self.y+math.cos(self.rot)*self.length}
  self.sensorM[2] = {self.x-math.sin(self.rot)*self.length-math.sin(self.rot)*self.sensorlen,
    self.y+math.cos(self.rot)*self.length+math.cos(self.rot)*self.sensorlen}
  
    --right sensor
  self.sensorR[1] = {self.x-math.sin(self.rot)*self.length + math.cos(self.rot+math.pi)*self.width/2,
    self.y+math.cos(self.rot)*self.length + math.sin(self.rot+math.pi)*self.width/2}
  self.sensorR[2] = {self.x-math.sin(self.rot)*self.length-math.sin(self.rot+math.pi/4)*self.sensorlen + math.cos(self.rot+math.pi)*self.width/2,
    self.y+math.cos(self.rot)*self.length+math.cos(self.rot+math.pi/4)*self.sensorlen + math.sin(self.rot+math.pi)*self.width/2}  
end

function car:get_sensor_values(Walls)
  --returns the sensor values
  local l,m,r = self.sensorlen,self.sensorlen,self.sensorlen
  local tempbool,tempXY 
  
  for i,v in ipairs(Walls) do
    --left sensor
    tempbool, tempXY = matrix.vector_intersection(self.sensorL[1],self.sensorL[2],{v.x1,v.y1},{v.x2,v.y2})
    if type(tempXY) == "table" then
      tempXY = math.sqrt((self.sensorL[1][1]-tempXY[1])^2+(self.sensorL[1][2]-tempXY[2])^2)
      if tempXY < l then l = tempXY end
    end
    --middle sensor
    tempbool, tempXY = matrix.vector_intersection(self.sensorM[1],self.sensorM[2],{v.x1,v.y1},{v.x2,v.y2})
    if type(tempXY) == "table" then
      tempXY = math.sqrt((self.sensorM[1][1]-tempXY[1])^2+(self.sensorM[1][2]-tempXY[2])^2)
      if tempXY < m then m = tempXY end
    end
    --right sensor
    tempbool, tempXY = matrix.vector_intersection(self.sensorR[1],self.sensorR[2],{v.x1,v.y1},{v.x2,v.y2})
    if type(tempXY) == "table" then
      tempXY = math.sqrt((self.sensorR[1][1]-tempXY[1])^2+(self.sensorR[1][2]-tempXY[2])^2)
      if tempXY < r then r = tempXY end
    end
  end
  
  return {{1-l/self.sensorlen},{1-m/self.sensorlen},{1-r/self.sensorlen}}
end

--- DRAW ---

function car:draw(focus)
  love.graphics.setColor(self.color)
  love.graphics.draw(
    self.img,
    self.x * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
    self.y * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
    self.rot,settings.scale.x,settings.scale.y,self.width/2,0)
  if not self.crashed then
    love.graphics.line(
      self.sensorL[1][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorL[1][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
      self.sensorL[2][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorL[2][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y)
    love.graphics.line(
      self.sensorM[1][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorM[1][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
      self.sensorM[2][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorM[2][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y)
    love.graphics.line(
      self.sensorR[1][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorR[1][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
      self.sensorR[2][1] * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.sensorR[2][2] * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y)
  end
  
  for i=1,(#self.trail-1) do
    love.graphics.line(
      self.trail[i].x * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.trail[i].y * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y,
      self.trail[i+1].x * settings.scale.x + settings.screenW/2 - focus.x * settings.scale.x,
      self.trail[i+1].y * settings.scale.y + settings.screenH/2 - focus.y * settings.scale.y)
  end
end

return car
local matrix = require "matrix"

local Car = {}
Car.__index = Car

Car.width = 20
Car.length = 30
Car.speed = 1000
Car.turnspeed = 25
Car.sensorlen = 120
Car.img = love.graphics.newImage("media/car.png")

function Car.new(init)
  local self = setmetatable({}, Car)
      
  self.rot = init.rot
  self.vec = {0,1}
  self.x = init.x or 400
  self.y = init.y or 400
  self.fitness = 0
  self.color = init.color or {255,255,255,255}
  self.sensorL = {}
  self.sensorM = {}
  self.sensorR = {}
  self:update_sensors()
  self.img = init.img and love.graphics.newImage(init.img) or Car.img
  return self
end

function Car:move(dt,out1,tbl_list)
  self.fitness = self.fitness + (((self.speed*self.vec[1]*dt)^2 + (self.speed*self.vec[2]*dt)^2)^0.5)*out1
  
  if not tbl_list then
    --not in use currently
    self.x = self.x + self.speed*self.vec[1]*dt*(out1)
    self.y = self.y + self.speed*self.vec[2]*dt*(out1)
  else
    --move all mapelements
    for k,t in ipairs(tbl_list) do
      for i,v in ipairs(t) do
        if v.x ~= nil then
          v.x = v.x - self.speed*self.vec[1]*dt*(out1)
          v.y = v.y - self.speed*self.vec[2]*dt*(out1) end
        if v.x1 ~= nil then
          v.x1 = v.x1 - self.speed*self.vec[1]*dt*(out1)
          v.y1 = v.y1 - self.speed*self.vec[2]*dt*(out1)
          v.x2 = v.x2 - self.speed*self.vec[1]*dt*(out1)
          v.y2 = v.y2 - self.speed*self.vec[2]*dt*(out1) end
      end
    end
  end
end

function Car:turn(dt,out2)
  self.rot = self.rot + self.turnspeed*dt*(out2-0.5)
  self.rot = self.rot % (2*math.pi)
  
  self.vec[1] = math.sin(-self.rot)
  self.vec[2] = math.cos(self.rot)
end

function Car:check_col(Walls)
  --checks for collision with walls
  local collision = false
  local tempboolL,tempboolR = false,false
  for i,v in ipairs(Walls) do
    tempboolL = matrix.vector_intersection({self.x,self.y},self.sensorL[1],{v.x1,v.y1},{v.x2,v.y2})
    tempboolR = matrix.vector_intersection({self.x,self.y},self.sensorR[1],{v.x1,v.y1},{v.x2,v.y2})
    collision = tempboolL or tempboolR or collision
  end
  return collision
end

function Car:update_sensors()
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

function Car:get_sensor_values(Walls)
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

-----------------------

function Car:update(dt,out1,out2,tbl_list)
  --tbl_list = list of all mapelemtents to move
  self:move(dt,out1,tbl_list)
  self:turn(dt,out2)
  self:update_sensors()
end

function Car:draw(draw_sensors)
  love.graphics.setColor(self.color)
  love.graphics.draw(self.img,self.x,self.y,self.rot,1,1,self.width/2,0)
  love.graphics.draw(self.img,self.x,self.y,self.rot,1,1,self.width/2,0)
  if draw_sensors then
    love.graphics.line(self.sensorL[1][1],self.sensorL[1][2],self.sensorL[2][1],self.sensorL[2][2])
    love.graphics.line(self.sensorM[1][1],self.sensorM[1][2],self.sensorM[2][1],self.sensorM[2][2])
    love.graphics.line(self.sensorR[1][1],self.sensorR[1][2],self.sensorR[2][1],self.sensorR[2][2])
  end
end

return Car
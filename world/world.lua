world = {
  focus = {},
  cars = {},
  networks = {},
  walls = {},
  checkpoints = {}
  }

function world:setCars(cars)
-- defines the cars // how many 
  self.cars = cars
  
  --reference car for resetting purposes
  self.cars.ref = {
    x = cars[1].x,
    y = cars[1].y,
    rot = cars[1].rot,
    vec = {cars[1].vec[1],cars[1].vec[2]}}
  
  self:setFocus(self.cars[1])
end

function world:generateCars(count)
-- generate a number of cars with random color
  local car = require "world/car"
  local carsTemp = {}
  for i = 1, count do
    table.insert(carsTemp,car({ID=i,color=helper.randomColor()}))
  end
  self:setCars(carsTemp)
end

function world:setNetworks(networks)
-- sets the networks table
  self.networks = networks
end

function world:generateNetworks(count,hiddenNodeCount)
-- generate a number of neural networks with set hiddenNotes
  local network = require "world/neuralNetwork"
  local networksTemp = {}
  for i = 1, count do
    table.insert(networksTemp,network({inodes=3,hnodes=hiddenNodeCount,onodes=2}))
  end
  self:setNetworks(networksTemp)
end

function world:setFocus(object)
  self.focus = object
end

function world:setWalls(walls)
-- sets the walls table
  self.walls = walls
end

function world:setCheckpoints(checkpoints)
-- sets the checkpoints table
  self.checkpoints = checkpoints
end

--UPDATE--

function world:update(dt)
  self:moveCars(dt)
  self:updFocus()
  if self:checkAllCrashed() then
    self:reset()
  end
  print(self.focus.fitness)
end

function world:moveCars(dt)
  for i,v in ipairs(self.cars) do
    local sensorValues = v:getSensorValues(self.walls)
    local networkOutputs = self.networks[i]:query(sensorValues)
    v:update(dt,self.walls,self.checkpoints,networkOutputs[1][1],networkOutputs[2][1])
  end
end

function world:updFocus()
-- puts the fittest car into focus
  local key , value = 1, 0
  for i,v in ipairs(self.cars) do
    if v.fitness > value then
      key = i
      value = v.fitness
    end
  end
  self:setFocus(self.cars[key])
end

function world:checkAllCrashed()
-- check if all cars are crashed
  local allCrashed = 0
  for i,v in ipairs(self.cars) do
    if v.crashed then
      allCrashed = allCrashed + 1
    end
  end
  if allCrashed == #self.cars then
    return true
  end
  return false
end

function world:reset()
-- resets cars and checkpoints
  for i,v in ipairs(self.cars) do
    v.crashed = false
    v.x = self.cars.ref.x
    v.y = self.cars.ref.y
    v.rot = self.cars.ref.rot
    v.vec = {self.cars.ref.vec[1],self.cars.ref.vec[2]}
    v.fitness = 0
    v:clearTrail()
  end
  for i,v in ipairs(self.checkpoints) do
    v:clearIDs()
  end
  
  self.setFocus(self.cars[1])
end


--DRAW--

function world:draw()
 --TODO draw cars, walls, checkpoints
 self:drawWalls()
 self:drawCheckpoints()
 self:drawCars()
end

function world:drawCars()
  for i,v in ipairs(self.cars) do
    v:draw(self.focus)
  end
end

function world:drawWalls()
  for i,v in ipairs(self.walls) do
    v:draw(self.focus)
  end
end

function world: drawCheckpoints()
for i,v in ipairs(self.checkpoints) do
    v:draw(self.focus)
  end
end  
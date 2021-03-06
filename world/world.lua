world = {
  focus = {},
  cars = {},
  networks = {},
  walls = {},
  checkpoints = {},
  ui = require("menus/ingameUI").items,
  generation = 1}

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

function world:generateCars(count,x,y)
-- generate a number of cars with random color
  local car = require "world/car"
  local carsTemp = {}
  for i = 1, count do
    table.insert(carsTemp,car({ID=i,x=x,y=y,color=helper.randomColor()}))
  end
  self:setCars(carsTemp)
end

function world:setNetworks(networks)
-- sets the networks table
  self.networks = networks
end

function world:generateNetworks(count,hiddenNodeCount)
-- generate a number of neural networks with set hiddenNotes
  local network = require "world/neuralnetwork"
  local networksTemp = {}
  for i = 1, count do
    table.insert(networksTemp,network({inodes=6,hnodes=hiddenNodeCount,onodes=2}))
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
  self:updateUI({})
  if self:checkAllCrashed() then
    self:nextGen()
    self:reset()
  end
end

function world:updateUI(input)  
  for i,v in ipairs(self.ui) do
    v:update(input)
  end
end

function world:moveCars(dt)
-- using the cars sensors to get the inputs
-- and the neural networks to get the outputs
  for i,v in ipairs(self.cars) do
    local sensorValuesWalls = v:getSensorValues(self.walls)
    local sensorValuesCheckpoints = v:getSensorValues(self.checkpoints)
    local sensorValues = {
      sensorValuesWalls[1],sensorValuesWalls[2],sensorValuesWalls[3],
      sensorValuesCheckpoints[1],sensorValuesCheckpoints[2],sensorValuesCheckpoints[3]}
    
    local networkOutputs = self.networks[i]:query(sensorValues)
    
    v:update(dt,self.walls,self.checkpoints,networkOutputs[1][1],networkOutputs[2][1])
  end
end

function world:updFocus()
-- puts the fittest car into focus
  local key , value = 1, 0
  for i,v in ipairs(self.cars) do
    if (v.fitness > value) and not v.crashed then
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
    v:resetCar(self.cars.ref)
  end
  for i,v in ipairs(self.checkpoints) do
    v:clearIDs()
  end
end

function world:nextGen()
-- new generation -> mutate networks

  -- find the fittest
  self.generation = self.generation + 1
  local oldNetworks = helper.copyNetworks(self.networks)
  local fittest = helper.findFittest(self.cars)
  print(fittest,self.cars[fittest].fitness)
  self.cars[fittest].fitness = 0
  
  -- for the best network, generate 2 mutated and 1 unmutated TODO
  self.networks[1] = helper.copyNetwork(oldNetworks[fittest])
  self.networks[2] = helper.mutateNetwork(oldNetworks[fittest])
  self.networks[3] = helper.mutateNetwork(oldNetworks[fittest])
  
  -- for the rest, random mutations
  for i = 2, #oldNetworks/3 do
  fittest = helper.findFittest(self.cars)
  self.networks[i*3-2] = helper.mutateNetwork(oldNetworks[fittest])
  self.networks[i*3-1] = helper.mutateNetwork(oldNetworks[fittest])
  self.networks[i*3] = helper.mutateNetwork(oldNetworks[fittest])
  self.cars[fittest].fitness = 0
  end
end

function world:clear()
-- empty the world
  self.generation = 1
  for i,v in pairs(self.walls) do
    self.walls[i] = nil
  end
  for i,v in pairs(self.checkpoints) do
    self.checkpoints[i] = nil
  end
  for i,v in pairs(self.networks) do
    self.networks[i] = nil
  end
  for i,v in pairs(self.cars) do
    self.cars[i] = nil
  end
  self.focus = nil
end
--DRAW--

function world:draw()
 --TODO draw cars, walls, checkpoints
 self:drawWalls()
 self:drawCheckpoints()
 self:drawCars()
 self:drawUI()
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

function world:drawCheckpoints()
  for i,v in ipairs(self.checkpoints) do
    v:draw(self.focus)
  end
end  

function world:drawUI()
  for i,v in ipairs(self.ui) do
    v:draw()
  end
end
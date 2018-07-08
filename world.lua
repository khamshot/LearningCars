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
  self:setFocus(self.cars[1])
end

function world:setFocus(object)
  self.focus = object
end

function world:addObject(object,layer)
-- adds an object to the specified layer
  table.insert(self[layer],object)
end

--UPDATE--

function world:update(dt)
  self.cars[1]:update(dt,self.walls,self.checkpoints,0.8,0.44)
  self.cars[2]:update(dt,self.walls,self.checkpoints,0.2,0.5)
  self.cars[3]:update(dt,self.walls,self.checkpoints,0.1,0.5)
  self:updFocus()
end

function world:checkAllCrashed()
-- check if all cars are crashed
  local allCrashed = 0
  for i,v in ipairs(self.cars) do
    if self.cars[v].crashed then
      allCrashed = allCrashed + 1
    end
  end
  if allCrashed == #self.cars then
    return true
  end
  return false
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

--DRAW--

function world:draw()
 --TODO draw cars, walls, checkpoints
 self:drawCars()
 self:drawWalls()
 self:drawCheckpoints()
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
    v:draw()
  end
end  
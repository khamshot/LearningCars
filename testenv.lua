local Network = require "neural_network"
local Matrix = require "matrix"
local Frame = require "frame"
local Car = require "car"
local Helper = require "helper"

local Testenv = {}

--create info frames
Testenv.frames = {}
Testenv.frames[1] = Frame.new({x=20,y=20,width=300,height=60,txt_offset_x=25,txt_offset_y=15,img="media/frame.png"})
Testenv.frames[2] = Frame.new({x=20,y=90,width=300,height=60,txt_offset_x=25,txt_offset_y=15,img="media/frame.png"})
Testenv.frames[3] = Frame.new({x=20,y=160,width=300,height=60,txt_offset_x=25,txt_offset_y=15,img="media/frame.png"})
  Testenv.frames[4] = Frame.new({x=20,y=160,width=300,height=60,txt_offset_x=160,txt_offset_y=15})
Testenv.frames[5] = Frame.new({x=20,y=230,width=300,height=60,txt_offset_x=25,txt_offset_y=15,img="media/frame.png"})
Testenv.frames[6] = Frame.new({x=20,y=300,width=300,height=60,txt_offset_x=25,txt_offset_y=15,img="media/frame.png"})

function Testenv:set_car(car)
  --testcar and bestcar + trails
  self.car = car
  self.trail = {{x=car.x,y=car.y}}
  
  self.bestcar = Car.new({x=car.x,y=car.y,rot=car.rot,color={255-car.color[1],255-car.color[2],255-car.color[3],255}})
  self.besttrail = {}
  
  -- save starting point as ref
  self.ref = {{x=0,y=0,rot=car.rot}}
  end

function Testenv:set_walls(table)
  --boundry walls
  self.walls = table
  print(#table)
end

function Testenv:set_networks(networks)
  --list of networks to test
  self.networks = networks
  self.generation = 1
  self.genome = 1
end

function Testenv:next_genome()
  --save fitness of the network
  self.networks[self.genome].fitness = self.car.fitness
  
  --check if best
  if self.car.fitness > self.bestcar.fitness then
    self.besttrail = Helper.deepcopy(self.trail)
    self.bestcar.fitness = self.car.fitness
    self.bestcar.x = self.car.x
    self.bestcar.y = self.car.y
    self.bestcar.rot = self.car.rot
  end
  
  --reset car/map and go next genome
  self.genome = self.genome + 1
  self.car.rot = self.ref[1].rot
  self.car.fitness = 0
  self.trail = {{x=self.car.x,y=self.car.y}}
  self:reset_map({{self.bestcar},self.besttrail,self.walls})
  
  --if done with generation, go next 
  if  self.genome > #self.networks then self:next_generation() end
end

function Testenv:reset_map(tbl_list)
  --resets all mapelements
  for k,t in ipairs(tbl_list) do
      for i,v in ipairs(t) do
        if v.x ~= nil then
          v.x = v.x - self.ref[1].x
          v.y = v.y - self.ref[1].y end
        if v.x1 ~= nil then
          v.x1 = v.x1 - self.ref[1].x
          v.y1 = v.y1 - self.ref[1].y
          v.x2 = v.x2 - self.ref[1].x
          v.y2 = v.y2 - self.ref[1].y end
      end
    end
  self.ref[1].x = 0
  self.ref[1].y = 0
end

function Testenv:next_generation()
  --generates a new generation from the best 33% of the old generation
  self.generation = self.generation + 1 
  self.genome = 1
  
  self.oldnetworks = {}
  for i,v in ipairs(self.networks) do
    self.oldnetworks[i] = Network.new({inodes=3,hnodes=5,onodes=2,lr=0.7})
    self.oldnetworks[i].wih = Helper.deepcopy(self.networks[i].wih)
    self.oldnetworks[i].who = Helper.deepcopy(self.networks[i].who)
    self.oldnetworks[i].fitness = self.networks[i].fitness
  end
  
  --for each of the best genomes, generate multiple mutated and 1 unmutated
  for i=1,#self.networks/3 do
    local fittest = self:find_fittest()
    self.networks[i] = self:mutate_network(fittest,true)
    self.networks[i+#self.networks/3] = self:mutate_network(fittest,false)
    self.networks[i+#self.networks*2/3] = self:mutate_network(fittest,true)
  end
end

function Testenv:mutate_network(genome,mutate)
  --mutates 1 connection in a neural network randomly
  local mutation = Network.new({inodes=3,hnodes=5,onodes=2,lr=0.7})
  mutation.wih = Helper.deepcopy(self.oldnetworks[genome].wih)
  mutation.who = Helper.deepcopy(self.oldnetworks[genome].who)
  
  if not mutate then return mutation end
  
  if math.random()*2 > 1 then
    Matrix.mutate_matrix(mutation.wih)
  else
    Matrix.mutate_matrix(mutation.who)
  end
  
  return mutation
end

function Testenv:find_fittest()
  --finds the fittest genome of the generation
  local fittest_val, fittest_gen = 0,1
  for i,v in ipairs(self.oldnetworks) do
    if fittest_val < v.fitness then
      fittest_gen = i
      fittest_val = v.fitness
    end
  end
  --removes fittest genome from generation
  self.oldnetworks[fittest_gen].fitness = 0
  return fittest_gen
end
---------------

function Testenv:update(dt)
  self.nn_in = self.car:get_sensor_values(self.walls)
  self.nn_out = self.networks[self.genome]:query(self.nn_in)
  self.car:update(dt,self.nn_out[1][1],self.nn_out[2][1],{self.ref,self.trail,{self.bestcar},self.besttrail,self.walls})
  self.bestcar:update(dt,0,0.5)

  --add trail
  table.insert(self.trail,{x=self.car.x,y=self.car.y})
  
  --if car crashes with wall --> next genome
  if self.car:check_col(self.walls) then
    self:next_genome()
  end
end

function Testenv:draw()
  --draw information about current genome
  self.frames[1]:draw("Generation:  " .. self.generation)
  self.frames[2]:draw("Genome:  " .. self.genome)
  self.frames[3]:draw("Fitness:  " .. tonumber(string.format("%.0f",self.car.fitness)))
    self.frames[4]:draw("Best:  " .. tonumber(string.format("%.0f",self.bestcar.fitness)))
  self.frames[5]:draw("Speed:  " .. tonumber(string.format("%.2f",self.nn_out[1][1]))*100 .. "%")
  self.frames[6]:draw("Steering:  " .. tonumber(string.format("%.2f",self.nn_out[2][1]))*100 .. "%")
  
  --draw walls
  for i,v in ipairs(self.walls) do
    v:draw()
  end
  
  --draw car/bestcar + trails
  self.bestcar:draw(false)
  for i=1,(#self.besttrail-1) do
    love.graphics.line(self.besttrail[i].x,self.besttrail[i].y,self.besttrail[i+1].x,self.besttrail[i+1].y)
  end
  
  self.car:draw(true)
  for i=1,(#self.trail-1) do
    love.graphics.line(self.trail[i].x,self.trail[i].y,self.trail[i+1].x,self.trail[i+1].y)
  end
end

return Testenv
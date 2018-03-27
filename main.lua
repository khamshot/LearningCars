local Testenv = require "testenv"
local Network = require "neural_network"
local Car = require "car"
local Loader = require "loader"

function love.load()
  --create neural networks
  math.randomseed(os.time())
  networklist = {}
  for i=1,15 do
    networklist[i] = Network.new({inodes=3,hnodes=70,onodes=2,lr=0.7})
  end 
  
  Testenv:set_networks(networklist)
  Testenv:set_car(Car.new({x=800,y=450,rot=math.pi,color={155,255,66,255}}))
  Testenv:set_walls(Loader:load_map("maps/testmap1.map"))
end

function love.update(dt)
  --print(dt)
  if dt > 0.05 then dt = 0.05 end
  Testenv:update(dt)
end

function love.draw()
  Testenv:draw()
end
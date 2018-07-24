local network = require "world/neuralnetwork"

helper = {}

function helper.checkCol(x1,y1,w1,h1,x2,y2,w2,h2)
-- rectangle collision check
  local x1w1, y1h1, x2w2, y2h2 = x1 + w1, y1 + h1, x2 + w2, y2 + h2
	if (x1 < x2w2 and x1w1 > x2 and y1 < y2h2 and y1h1 > y2) then 
		return true end
  return false
end

function helper.randomColor()
  return {math.random(20,255),math.random(20,255),math.random(20,255),255}
end

function helper.deepcopy(orig)
-- actual copy of a table
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[helper.deepcopy(orig_key)] = helper.deepcopy(orig_value)
      end
      setmetatable(copy, helper.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function helper.copyNetwork(netwrk)
-- deepcopy since table
  local copiedNetwork = network({inodes=netwrk.inodes,hnodes=netwrk.hnodes,onodes=netwrk.onodes})
  copiedNetwork.wih = helper.deepcopy(netwrk.wih)
  copiedNetwork.who = helper.deepcopy(netwrk.who)
  copiedNetwork.fitness = netwrk.fitness
  
  return copiedNetwork
end

function helper.copyNetworks(networks)
-- deepcopy since table
  local copiedNetworks = {}
    for i,v in ipairs(networks) do
      copiedNetworks[i] = helper.copyNetwork(networks[i])
    end
  
  return copiedNetworks
end

function helper.findFittest(objects)
-- finds the fittest network
  local value, key = 0,1
  for i,v in ipairs(objects) do
    if value < v.fitness then
      key = i
      value = v.fitness
    end
  end
  return key
end

function helper.mutateNetwork(netwrk)
  --mutates  given network
  local mutation = helper.copyNetwork(netwrk)

  for i = 1, math.random(math.floor(netwrk.hnodes/2)) do
    if math.random(2) == 1 then
      helper.mutateMatrix(mutation.wih)
    else
      helper.mutateMatrix(mutation.who)
    end
  end
  
  return mutation
end

function helper.mutateMatrix(matrix)
-- random mutation of 1 weight in the matrix
  local pos = {math.floor(math.random()*#matrix+1),math.floor(math.random()*#matrix[1]+1)}
  local which = math.random(3)
  if (which == 1) or (math.abs(matrix[pos[1]][pos[2]]) >= 1) then -- new random number (also when number not in [-1,+1])
    matrix[pos[1]][pos[2]] = math.random()*2 - 1
  elseif which == 2 then -- * [-0.5,+0.5]
    matrix[pos[1]][pos[2]] = matrix[pos[1]][pos[2]] * (math.random()-0.5)
  elseif which == 3 then -- + [-0.5,+0.5]
    matrix[pos[1]][pos[2]] = matrix[pos[1]][pos[2]] + (math.random()-0.5)
  end
end
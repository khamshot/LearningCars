local network = require "world/neuralnetwork"

helper = {}

function helper.randomColor()
  return {math.random(255),math.random(255),math.random(255),255}
end

function helper.deepcopy(orig)
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

function helper.findFittest(networks)
-- finds the fittest network
  local value, genome = 0,1
  for i,v in ipairs(networks) do
    if value < v.fitness then
      genome = i
      value = v.fitness
    end
  end
  return genome
end

function helper.mutateNetwork(netwrk,netwrkPool)
  --mutates  given network
  local mutation = helper.copyNetwork(netwrk)
  
  -- either randomly mutate connections or fuse with another network from the pool
  if math.random(3) then -- TODO > 3
    for i = 1, math.random(math.floor(netwrk.hnodes/2)) do
      if math.random(2) == 1 then
        helper.mutateMatrix(mutation.wih)
      else
        helper.mutateMatrix(mutation.who)
      end
    end
  else
    
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
local matrix = require "libs/matrix"

local network = {}

setmetatable(network,
  {__call = function(self,...) return self.new(...) end})

function network.new(init)
  local self = setmetatable({},{__index = network})
  
  self.inodes = init.inodes or 3
  self.hnodes = init.hnodes or 3
  self.onodes = init.onodes or 3
  self.lr = init.lr or 0.3
  
  --create weight matrices
  self.wih = init.wih or self.createWeightedMatrix(self.hnodes,self.inodes,{-1.0,1.0})
  self.who = init.who or self.createWeightedMatrix(self.onodes,self.hnodes,{-1.0,1.0})
  
  return self
end

function network.createWeightedMatrix(rows,colums,range)
  local matrix = matrix:new(rows,colums)
  for i = 1,#matrix do
    for j = 1,#matrix[1] do
      matrix[i][j] = math.random() * (range[2] - range[1]) + range[1]
    end
  end
  return matrix
end

--- TRAIN/QUERY ---
  
function network:train(input,targets)
  --calc inputs for hidden layer and calculating the outputs of the hidden layer
  local hidden_in = matrix.mul(self.wih,input)
  local hidden_out = self.sigmoid(hidden_in)
  
  --calc inputs for output layer and calculating the final outputs
  local final_in = matrix.mul(self.who,hidden_out)
  local final_out = self.sigmoid(final_in)
    
  --calculate the errors for the outputs
  local output_errors = matrix.sub(targets,final_out)
   
  --calculate the errors for the neurons in the hidden layer
  local hidden_errors = matrix.mul(matrix.transpose(self.who),output_errors)
    
  --calculate the weights needed to be added to the links between hidden and out
  local mat1 = matrix:new(#final_out,1,1)
  local who_updates = matrix.mul(matrix.mulelements(matrix.mulelements(output_errors,final_out),matrix.sub(mat1,final_out)),matrix.transpose(hidden_out))
  
  --update the weights for the links between the hidden and output layers
  self.who = matrix.add(self.who,matrix.mulnum(who_updates,self.lr))
  
  --calculate the weights needed to be added to the links between in and hidden
  mat1 = matrix:new(#hidden_out,1,1)
  local wih_updates = matrix.mul(matrix.mulelements(matrix.mulelements(hidden_errors,hidden_out),matrix.sub(mat1,hidden_out)),matrix.transpose(input))
    
  --update the weights for the links between the hidden and output layers
  self.wih = matrix.add(self.wih,matrix.mulnum(wih_updates,self.lr))
end
  
function network:query(input)
  --calc inputs for hidden layer and calculating the outputs of the hidden layer
  local hidden_in = matrix.mul(self.wih,input)
  local hidden_out = self.sigmoid(hidden_in)
    
  --calc inputs for output layer and calculating the final outputs
  local final_in = matrix.mul(self.who,hidden_out)
  local final_out = self.sigmoid(final_in)
  return final_out
end

function network.sigmoid(nodeInput)
-- calculate the sigmoid output for each output node
-- has to be 2 dimensional array
  local out = {}
  for i = 1,#nodeInput do
    out[i] = {}
    out[i][1] = 1/(1 + math.exp(-nodeInput[i][1]))
  end
  return out
end

return network
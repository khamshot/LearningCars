local matlib = require "libs/matrix"

local network = {}
network.__index = network

function network.new(init)
  local self = setmetatable({},network)
  if not init then return self end
  
  self.inodes = init.inodes or 3
  self.hnodes = init.hnodes or 3
  self.onodes = init.onodes or 3
  self.lr = init.lr or 0.3
  
  --create weight matrices
  self.wih = self.createWeightedMatrix(self.hnodes,self.inodes,{-1.0,1.0})
  self.who = self.createWeightedMatrix(self.onodes,self.hnodes,{-1.0,1.0})
  
  return self
end
  
function network:train(input,targets)
  --calc inputs for hidden layer and calculating the outputs of the hidden layer
  local hidden_in = matlib.mul(self.wih,input)
  local hidden_out = self.sigmoid(hidden_in)
  
  --calc inputs for output layer and calculating the final outputs
  local final_in = matlib.mul(self.who,hidden_out)
  local final_out = self.sigmoid(final_in)
    
  --calculate the errors for the outputs
  local output_errors = matlib.sub(targets,final_out)
   
  --calculate the errors for the neurons in the hidden layer
  local hidden_errors = matlib.mul(matlib.transpose(self.who),output_errors)
    
  --calculate the weights needed to be added to the links between hidden and out
  local mat1 = matlib:new(#final_out,1,1)
  local who_updates = matlib.mul(matlib.mulelements(matlib.mulelements(output_errors,final_out),matlib.sub(mat1,final_out)),matlib.transpose(hidden_out))
  
  --update the weights for the links between the hidden and output layers
  self.who = matlib.add(self.who,matlib.mulnum(who_updates,self.lr))
  
  --calculate the weights needed to be added to the links between in and hidden
  mat1 = matlib:new(#hidden_out,1,1)
  local wih_updates = matlib.mul(matlib.mulelements(matlib.mulelements(hidden_errors,hidden_out),matlib.sub(mat1,hidden_out)),matlib.transpose(input))
    
  --update the weights for the links between the hidden and output layers
  self.wih = matlib.add(self.wih,matlib.mulnum(wih_updates,self.lr))
end
  
function network:query(input)
  --calc inputs for hidden layer and calculating the outputs of the hidden layer
  local hidden_in = matlib.mul(self.wih,input)
  local hidden_out = self.sigmoid(hidden_in)
    
  --calc inputs for output layer and calculating the final outputs
  local final_in = matlib.mul(self.who,hidden_out)
  local final_out = self.sigmoid(final_in)
  return final_out
end

function network.createWeightedMatrix(rows,colums,range)
  local matrix = matlib:new(rows,colums)
  for i = 1,#matrix do
    for j = 1,#matrix[1] do
      matrix[i][j] = math.random() * (range[2] - range[1]) + range[1]
    end
  end
  return matrix
end

function network.sigmoid(x)
  local out = {}
  for i = 1,#x do
    out[i] = {}
    out[i][1] = 1/(1 + math.exp(-x[i][1]))
  end
  return out
end

return network
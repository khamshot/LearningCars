menu = {
  items= {}}

function menu:setItems(items)
  self.items = items
end

function menu:update(mouseX,mouseY)
  for i,v in ipairs(self.items) do
    v:update(mouseX,mouseY)
  end
end

function menu:draw()
  for i,v in ipairs(self.items) do
    v:draw()
  end
end
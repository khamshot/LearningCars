menu = {
  items = {},
  ID = ""}

function menu:setItems(items)
  self.items = items
end

function menu:update(mouseX,mouseY,what)
  for i,v in ipairs(self.items) do
    v:update(mouseX,mouseY,what)
  end
end

function menu:draw()
  for i,v in ipairs(self.items) do
    v:draw()
  end
end
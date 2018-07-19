menu = {
  items = {},
  ID = ""}

function menu:setItems(items)
  self.items = items
end

function menu:update(input)
  for i,v in ipairs(self.items) do
    v:update(input)
  end
end

function menu:draw()
  for i,v in ipairs(self.items) do
    v:draw()
  end
end
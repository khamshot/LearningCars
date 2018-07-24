menu = {
  items = {},
  popupEnable = false,
  popupItems = {},
  ID = ""}

function menu:setMenu(newMenu)
  self.items = newMenu.items
  self.popupItems = newMenu.popupItems
  self.ID = newMenu.ID or ""
end

function menu:update(input)
  for i,v in ipairs(self.items) do
    v:update(input)
  end
  if self.popupEnable then
      for i,v in ipairs(self.popupItems) do
        v:update(input)
      end
  end
end

function menu:draw()
  for i,v in ipairs(self.items) do
    v:draw()
  end
  if self.popupEnable then
      for i,v in ipairs(self.popupItems) do
        v:draw()
      end
  end
end
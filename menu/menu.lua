frame = require "menu.menuItems.frame";
button = require "menu.menuItems.button";
slider = require "menu.menuItems.slider";

local menu = {};

function menu.exec()
  --placeholder function
  --stuff like keyboard checks
end;

function menu:clear(p_clear)
  frame:clear();
  button:clear();
  slider:clear();
  if p_clear then self.exec = function() end; end;
end;

function menu:update(dt)
  frame:update(dt);
  button:update(dt);
  slider:update(dt);
  self.exec();
end;

function menu:draw()
  frame:draw();
  button:draw();
  slider:draw();
end;

return menu;
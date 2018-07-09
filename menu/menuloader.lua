local mainmenu = require "menu.menus.mainmenu";
local optionmenu = require "menu.menus.optionmenu";

local menuloader = {};

function menuloader.load(p_menuName)
  if p_menuName == "mainmenu" then
    mainmenu.load();
  elseif p_menuName == "optionmenu" then
    optionmenu.load();
  end;
end;

return menuloader;
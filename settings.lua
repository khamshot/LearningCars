settings = {
  screen = {w=0,h=0},
  default = {w=1920,h=1080},
  scale = {x=1,y=1},
  uiScale = {x=1,y=1},
  fontsize = 45,
  keys = {escape="escape",enter="return",backspace="backspace"}}

function settings.setScreenRes(width,height,flags)
-- setting up the screen resolution and scaling factors
  love.window.setMode(width,height,flags)
  
  settings.screen = {
    w = width,
    h = height}
  
  settings.scale = {
    x = settings.screen.w/settings.default.w,
    y = settings.screen.h/settings.default.h}
  
  settings.uiScale = {
    x = settings.screen.w/1920,
    y = settings.screen.h/1080}
  
  love.graphics.setDefaultFilter("nearest","nearest")
  love.graphics.setNewFont("media/fonts/Shermlock.ttf",settings.fontsize * settings.uiScale.x)
end

function settings.setDefaultRes(width,height)
-- can be used for zooming
  settings.default = {
    w = width,
    h = height}
  
  settings.scale = {
    x = settings.screen.w/settings.default.w,
    y = settings.screen.h/settings.default.h}
  
  settings.uiScale = {
    x = settings.screen.w/1920,
    y = settings.screen.h/1080}
end

function settings.setKey(bind,key)  
  if settings.keys[bind] then
    settings.keys[bind] = key
  else
    error("invalid bind") end
end
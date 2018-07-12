settings = {
  scale = {},
  screenW = 0,
  screenH = 0,
  defaultW = 1920,
  defaultH = 1080,
  keys = {skip="s"}}

function settings.setScreenResolution(width,height,flags)
--setting up the screen resolution and scaling factors
  if not (width/height == 16/10 or width/height == 16/9) then
    error("invalid resolution")  end
  settings.screenW = width 
  settings.screenH = height
  
  love.window.setMode(width,height,flags)
  
  settings.scale = {
    x = settings.screenW/settings.defaultW,
    y = settings.screenH/settings.defaultH}
end

function settings.setKey(bind,key)  
  if settings.keys[bind] then
    settings.keys[bind] = key
  else
    error("invalid bind") end
end
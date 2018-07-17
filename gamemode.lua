gamemode = {}

gamemode.world = {
  update = true,
  draw = true}

gamemode.menu = {
  update = true,
  draw = true}

function gamemode.setmode(worldUpdate,worldDraw,menuUpdate,menuDraw)
  gamemode.world.update = worldUpdate
  gamemode.world.draw = worldDraw
  gamemode.menu.update = menuUpdate
  gamemode.menu.draw = menuDraw
end

gamemode.showSensors = true
gamemode.showTrails = true
gamemode.trailTimer = 0.25

gamemode.deltaTime = 0.01
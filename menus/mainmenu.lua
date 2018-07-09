local mainmenu = {};

function mainmenu.load()
  --clearing the menu, extra parameter clears menu.exec
  menu:clear();
  --loading globals saved by player
  g:load(); 
  
  --setting the menu sound and start playing it
  if not menu.sound then menu.sound = love.audio.newSource("media/sfx/ByTheCroft-JoakimKarud.mp3"); end;
  menu.exec = function()
    menu.sound:play();
  end;
  
  --adding menu items
  frame:new({img="frame1.png"});
  
  button:new({x=500,y=300,width=200,height=70,txt="Play",color={255,200,200,255},activeColor={200,200,255,255},img="button1.png",fontSize=25,txtOffset={75,20}});
  button[1].exec = function()
    g:setMenuState(false,false);
    g:setWorldState(true,true);
    menu:clear(true);
    menu.sound:stop();
    worldloader.load("testworld");
  end;
  
  button:new({x=500,y=400,width=200,height=70,txt="Options",color={255,200,200,255},activeColor={200,200,255,255},img="button1.png",fontSize=25,txtOffset={62,20}});
  button[2].exec = function()
    menuloader.load("optionmenu");
  end;
  
  button:new({x=500,y=500,width=200,height=70,txt="Quit",color={255,200,200,255},activeColor={200,200,255,255},img="button1.png",fontSize=25,txtOffset={78,20}});
  button[3].exec = function()
    love.event.quit();
  end;
end;

return mainmenu;
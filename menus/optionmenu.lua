local optionsmenu = {};

function optionsmenu.load()
  --clearing the menu, extra parameter clears menu.exec
  menu:clear();
  
  --adding menu items
  frame:new({img="frame1.png"});
  frame:new({x=400,y=300,width=200,height=70,color={255,200,200,255},img="button1.png",txt="Volume",txtOffset={65,20}});
  frame:new({x=400,y=400,width=200,height=70,color={255,200,200,255},img="button1.png",txt="Brightness",txtOffset={50,20}});
  
  slider:new({x=650,y=325,width=200,height=20,color={255,255,255,255},img="sliderbar1.png",sliderImg="slider1.png",sliderScaling=0.1});
  slider[1]:setValue(g.volume);
  
  slider:new({x=650,y=425,width=200,height=20,color={255,255,255,255},img="sliderbar1.png",sliderImg="slider1.png",sliderScaling=0.1});
  slider[2]:setValue(g.brightness);
  
  button:new({x=400,y=700,width=200,height=70,txt="Apply",color={255,200,200,255},activeColor={200,200,255,255},img="button1.png",fontSize=25,txtOffset={75,20}});
  button[1].exec = function()
    g:setVolume(slider[1]:getValue());
    if slider[2]:getValue() > 0.2 then
      g:setBrightness(slider[2]:getValue());
    else
      g:setBrightness(0.2);
    end;
  end;
  
  button:new({x=650,y=700,width=200,height=70,txt="Back",color={255,200,200,255},activeColor={200,200,255,255},img="button1.png",fontSize=25,txtOffset={80,20}});
  button[2].exec = function()
    g:save(); --saving eats ressources
    menuloader.load("mainmenu");
  end;
end;

return optionsmenu;
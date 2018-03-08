local physMgt = {};

function physMgt.checkCol(p_X1,p_Y1,p_width1,p_height1,p_X2,p_Y2,p_width2,p_height2)
  --rectangle collision check
	local l_X1_, l_Y1_, l_X2_, l_Y2_ = p_X1 + p_width1, p_Y1 + p_height1, p_X2 + p_width2, p_Y2 + p_height2;
	if (p_X1 < l_X2_ and l_X1_ > p_X2 and p_Y1 < l_Y2_ and l_Y1_ > p_Y2) then 
		return true;
	else
		return false;
	end;
end;

function physMgt.calcDist(p_X1,p_Y1,p_X2,p_Y2)
  --calculates the distance between 2 points in a 2d-envirorment
  return math.sqrt(math.pow((p_X1 - p_X2),2) + math.pow((p_Y1-p_Y2),2));
end;

function physMgt.calcVec(p_X1,p_Y1,p_X2,p_Y2)
  --calculates the normalized vector from point 1 to point 2
  local l_vecx = (p_X2 - p_X1);
	local l_vecy = (p_Y2 - p_Y1);
	l_vecx = l_vecx/calcDist(p_X1,p_Y1,p_X2,p_Y2);
	l_vecy = l_vecy/calcDist(p_X1,p_Y1,p_X2,p_Y2);
  return {l_vecx,l_vecy};
end;

return physMgt;
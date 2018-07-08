helper = {}

function helper.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[helper.deepcopy(orig_key)] = helper.deepcopy(orig_value)
        end
        setmetatable(copy, helper.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function helper.checkCol(obj,obj2)
  return helper.checkCol2(obj.x,obj.y,obj.width,obj.height,obj2.x,obj2.y,obj2.width,obj2.height)
end

function helper.checkCol2(x1,y1,w1,h1,x2,y2,w2,h2)
  --rectangle collision check
	local x1w1, y1h1, x2w2, y2h2 = x1 + w1, y1 + h1, x2 + w2, y2 + h2
	if (x1 < x2w2 and x1w1 > x2 and y1 < y2h2 and y1h1 > y2) then 
		return true end
  return false
end

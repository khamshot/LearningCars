local Helper = {}

function Helper.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Helper.deepcopy(orig_key)] = Helper.deepcopy(orig_value)
        end
        setmetatable(copy, Helper.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return Helper
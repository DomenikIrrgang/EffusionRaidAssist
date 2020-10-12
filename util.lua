function EffusionRaidAssist:ArrayContainsValue(array, value)
    for index, arrayValue in ipairs(array) do
        if arrayValue == value then
            return true
        end
    end 
    return false
end
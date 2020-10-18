function ArrayContainsValue(array, value)
    for index, arrayValue in ipairs(array) do
        if arrayValue == value then
            return true
        end
    end 
    return false
end

function CreateClass()
    local newClass = {}
    newClass.__index = newClass

    setmetatable(newClass, {
        __call = function (cls, ...)
          return cls.new(...)
        end,
    })
    return newClass
end
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

function table.copy(t)
    if type(t) ~= 'table' then return t end
    local result = {}
    for k, v in pairs(t) do result[k] = table.copy(v) end
    return result
end

function table.merge(table1, table2)
    local result = table.copy(table1)
    for k,v in pairs(table2) do
        result[k] = v
    end
    return result
end
function ArrayContainsValue(array, value)
    for _, arrayValue in ipairs(array) do
        if arrayValue == value then
            return true
        end
    end 
    return false
end

function TableContainsValue(table, value)
    for _, tableValue in pairs(table) do
        if tableValue == value then
            return true
        end
    end 
    return false
end

function BindCallback(context, callback)
    return function(...)
        callback(context, ...)
    end
end

function InterpolateValue(minimumValue, maximumValue, percentage)
    return minimumValue + ((maximumValue - minimumValue) * percentage)
end

function ArrayContainsKey(array, value)
    for index, arrayValue in ipairs(array) do
        if index == value then
            return true
        end
    end 
    return false
end

function CreateTableWithKeysAsValues(table)
    local result = {}
    for key in pairs(table) do
        result[key] = key
    end
    return result
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
    for k, v in pairs(t) do
        result[k] = table.copy(v)
    end
    return result
end

function table.merge(table1, table2)
    local result = table.copy(table1)
    for k,v in pairs(table2) do
        result[k] = v
    end
    return result
end

function table.add(table1, table2)
    local result = table.copy(table1)
    for _, value in pairs(table2) do
        table.insert(result, value)
    end
    return result
end

function table.getkeys(table1)
    local keys = {}
    for key in pairs(table1) do
        table.insert(keys, key)
    end
    return keys
end

function table.getvalues(table1)
    local values = {}
    for _, value in pairs(table1) do
        table.insert(values, value)
    end
    return values
end

function UnitIsInPlayersGroup(unit)
    if (unit == UnitName("player")) then
        return true
    end
    for i = 1, GetNumGroupMembers() do
        if (unit == GetRaidRosterInfo(i)) then
            return true
        end
    end
    return false
end
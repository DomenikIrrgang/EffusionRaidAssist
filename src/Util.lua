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

function DoubleCallback(firstFunction, secondFunction)
    return function(...)
        firstFunction(...)
        return secondFunction(...)
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

function table.pack(...)
    return { ... }
end

function table.copy(t)
    if type(t) ~= 'table' then return t end
    local result = {}
    for k, v in pairs(t) do
        result[k] = table.copy(v)
    end
    return result
end

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
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

function GetFullPlayerName()
    return UnitName("player") .. "-" .. GetRealmName()
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

function GetUnitIdFromGUID(guid)
    local guidValues = {}
	local i = 1
    for word in string.gmatch(guid, '([^-]+)') do
        guidValues[i] = word
        i = i + 1
    end
    return tonumber(guidValues[6])
end

string.split = function(s, p)
    local temp = {}
    local index = 0
    local last_index = string.len(s)

    while true do
        local i, e = string.find(s, p, index)

        if i and e then
            local next_index = e + 1
            local word_bound = i - 1
            table.insert(temp, string.sub(s, index, word_bound))
            index = next_index
        else
            if index > 0 and index <= last_index then
                table.insert(temp, string.sub(s, index, last_index))
            elseif index == 0 then
                temp = nil
            end
            break
        end
    end

    return temp
end

function UnitAuraByName(unitId, spellId)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, id = UnitAura(unitId, i);
        if (id == spellId) then
            return UnitBuff(unitId, i)
        end
        if (name == nil) then
            return nil
        end
    end
    return nil
end
EffusionRaidAssistDataStorage = CreateClass()

--[[
    Creates a new DataStorage.
--]]
function EffusionRaidAssistDataStorage.new(savedVariableName)
    local self = setmetatable({}, EffusionRaidAssistDataStorage)
    self.savedVariableName = savedVariableName
    self.defaultProfileName = "Default"
    self.dataCallbacks = {}
    return self
end

function EffusionRaidAssistDataStorage:GetDefaultProfile()
    local data = {
        modules = {}
    }
    for _, module in pairs(EffusionRaidAssist.ModuleManager:GetModules()) do
        data.modules[module.name] = module:GetDefaultOptions()
    end
    return data
end

function EffusionRaidAssistDataStorage:ProfileChanged()
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ProfileChanged)
end

function EffusionRaidAssistDataStorage:Init()
    self.data = self:LoadData()
    if (not self:HasActiveProfile()) then
        self:SetProfile(self.defaultProfileName)
    end
end

function EffusionRaidAssistDataStorage:LoadData()
    if (_G[self.savedVariableName] == nil) then
        _G[self.savedVariableName] = {}
        _G[self.savedVariableName].profiles = {}
        _G[self.savedVariableName].profiles[self.defaultProfileName] = self:GetDefaultProfile()
        _G[self.savedVariableName].characterProfiles = {}
    end
    return _G[self.savedVariableName]
end

function EffusionRaidAssistDataStorage:ResetProfile(name)
    local name = name
    if (name == nil) then
        name = self:GetCurrentProfile()
    end
    self.data.profiles[name] = self:GetDefaultProfile()
    self:ProfileChanged()
end

function EffusionRaidAssistDataStorage:SetProfile(name)
    self.data.characterProfiles[GetFullPlayerName()] = name
    self:ProfileChanged()
end

function EffusionRaidAssistDataStorage:NewProfile(name)
    if (not self:ProfileExists(name)) then
        self.data.profiles[name] = self:GetDefaultProfile()
        self:SetProfile(name)
    else
        EffusionRaidAssist:ErrorMessage("A profile with that name already exists!")
    end
end

function EffusionRaidAssistDataStorage:HasActiveProfile()
    return self:GetCurrentProfile() ~= nil
end

function EffusionRaidAssistDataStorage:DeleteProfile(name)
    if (name ~= self.defaultProfileName) then
        if self:GetCurrentProfile() == name then
            self:SetProfile(self.defaultProfileName)
        end
        self.data.profiles[name] = nil
    end
end

function EffusionRaidAssistDataStorage:GetCurrentProfile()
    return self.data.characterProfiles[GetFullPlayerName()]
end

function EffusionRaidAssistDataStorage:RegisterDataCallback(path, callback)
    if (self.dataCallbacks[path] == nil) then
        self.dataCallbacks[path] = {}
    end
    table.insert(self.dataCallbacks[path], callback)
end

function EffusionRaidAssistDataStorage:DataChanged(path, value)
    if (self.dataCallbacks[path] ~= nil) then
        for _, callback in pairs(self.dataCallbacks[path]) do
            callback(value)
        end
    end
end

function EffusionRaidAssistDataStorage:GetProfiles()
    return table.getkeys(self.data.profiles)
end

function EffusionRaidAssistDataStorage:CopyProfile(name)
    self.data.profiles[self:GetCurrentProfile()] = table.deepcopy(self.data.profiles[name])
    self:ProfileChanged()
end

function EffusionRaidAssistDataStorage:ProfileExists(name)
    return self.data.profiles[name] ~= nil
end

function EffusionRaidAssistDataStorage:HasData(path)
    local splitPath = string.split(path, "%.")
    local result = self:GetData()
    for _, value in pairs(splitPath) do
        if (result[value] ~= nil) then
            result = result[value]
        else
            return nil
        end
    end
    return true
end

function EffusionRaidAssistDataStorage:GetData(path)
    if (path) then
        local splitPath = string.split(path, "%.")
        local result = self:GetData()
        for _, value in pairs(splitPath) do
            if (result[value] ~= nil) then
                result = result[value]
            else
                error("There is no data with the key: '" .. value  .. "' for path: " .. path)
                return nil
            end
        end
        return result
    end
    return self.data.profiles[self:GetCurrentProfile()]
end

function EffusionRaidAssistDataStorage:GetCopyProfiles()
    local result = {}
    for _, profile in pairs(self:GetProfiles()) do
        if (profile ~= self:GetCurrentProfile()) then
            table.insert(result, profile)
        end
    end
    return result
end

function EffusionRaidAssistDataStorage:GetDeleteableProfiles()
    local result = {}
    for _, profile in pairs(self:GetProfiles()) do
        if (profile ~= self.defaultProfileName) then
            table.insert(result, profile)
        end
    end
    return result
end

function EffusionRaidAssistDataStorage:ChangeData(path, value)
    local splitPath = string.split(path, "%.")
    local result = self:GetData()
    local found = true
    for i = 1, #splitPath - 1 do
        local value = splitPath[i]
        if (result[value] ~= nil and type(result[value]) == "table") then
            result = result[value]
        else
            found = false
            error("There is no data with the key: " .. path)
            break
        end
    end
    if (found) then
        result[splitPath[#splitPath]] = value
        self:DataChanged(path, value)
    end
end
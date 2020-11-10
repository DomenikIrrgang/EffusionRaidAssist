EffusionRaidAssistDataStorage = CreateClass()

--[[
    Creates a new DataStorage.
--]]
function EffusionRaidAssistDataStorage.new()
    local self = setmetatable({}, EffusionRaidAssistDataStorage)
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

function EffusionRaidAssistDataStorage:GetDefaultProfile()
    return {
        profile = {
            modules = {
                ['*'] = {
                    enabled = true
                }
           }
        }
    }
end

function EffusionRaidAssistDataStorage:ProfileChanged()
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.ProfileChanged)
end

function EffusionRaidAssistDataStorage:EFFUSION_RAID_ASSIST_INIT()
    self.data = LibStub("AceDB-3.0"):New("EffusionRaidAssistDB", self:GetDefaultProfile())
    self.data.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
    self.data.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
    self.data.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
end

function EffusionRaidAssistDataStorage:GetCustomEvents()
    return {
        "EFFUSION_RAID_ASSIST_INIT"
    }
end

function EffusionRaidAssistDataStorage:ResetProfile()
    self.data:ResetProfile()
end

function EffusionRaidAssistDataStorage:SetProfile(name)
    self.data:SetProfile(name)
end

function EffusionRaidAssistDataStorage:NewProfile(name)
end

function EffusionRaidAssistDataStorage:DeleteProfile(name)
    if self.data:GetCurrentProfile() ~= name then
        self.data:DeleteProfile(name)
    end
end

function EffusionRaidAssistDataStorage:GetCurrentProfile()
    return self.data:GetCurrentProfile()
end

function EffusionRaidAssistDataStorage:GetProfiles()
    return self.data:GetProfiles()
end

function EffusionRaidAssistDataStorage:CopyProfile(name)
    self.data:CopyProfile(name, true)
end

function EffusionRaidAssistDataStorage:GetData()
    return self.data.profile
end

function EffusionRaidAssistDataStorage:GetCopyProfiles()
    local result = {}
    for _, profile in pairs(EffusionRaidAssist.Storage:GetProfiles()) do
        if (profile ~= EffusionRaidAssist.Storage:GetCurrentProfile()) then
            table.insert(result, profile)
        end
    end
    return result
end
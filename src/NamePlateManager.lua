EffusionRaidAssistNamePlateManager = CreateClass()

function EffusionRaidAssistNamePlateManager.new()
    local self = setmetatable({}, EffusionRaidAssistNamePlateManager)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_ADDED", self, self.NamePlateAdded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_REMOVED", self, self.NamePlateRemoved)
    self.units = {}
    return self
end

function EffusionRaidAssistNamePlateManager:NamePlateAdded(unitId)
    local guid = UnitGUID(unitId)
    self.units[guid] = {
        unitId = GetUnitIdFromGUID(guid),
        namePlate = C_NamePlate.GetNamePlateForUnit(unitId),
    }
end

function EffusionRaidAssistNamePlateManager:NamePlateRemoved(unitId)
    local unit = UnitGUID(unitId)
    if (unit) then
        self.units[guid] = nil
    end
end

function EffusionRaidAssistNamePlateManager:GetNamePlate(guid)
    return self.units[guid].namePlate
end

function EffusionRaidAssistNamePlateManager:GetNamePlates()
    return self.units
end
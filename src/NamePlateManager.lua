EffusionRaidAssistNamePlateManager = CreateClass()

function EffusionRaidAssistNamePlateManager.new()
    local self = setmetatable({}, EffusionRaidAssistNamePlateManager)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_ADDED", self, self.NamePlateAdded)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("NAME_PLATE_UNIT_REMOVED", self, self.NamePlateRemoved)
    self.units = {}
    self.unitIds = {}
    return self
end

function EffusionRaidAssistNamePlateManager:NamePlateAdded(unitId)
    local guid = UnitGUID(unitId)
    self.units[guid] = {
        unitId = GetUnitIdFromGUID(guid),
        namePlate = C_NamePlate.GetNamePlateForUnit(unitId),
    }
    self.unitIds[guid] = unitId
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.NamePlateAdded, unitId)
end

function EffusionRaidAssistNamePlateManager:NamePlateRemoved(unitId)
    local guid = UnitGUID(unitId)
    if (guid) then
        self.units[guid] = nil
        self.unitIds[guid] = nil
    end
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.NamePlateRemoved, unitId)
end

function EffusionRaidAssistNamePlateManager:GetNamePlate(guid)
    if (self.units[guid]) then
        return self.units[guid].namePlate
    end
    return nil
end

function EffusionRaidAssistNamePlateManager:GetNamePlates()
    return self.units
end

function EffusionRaidAssistNamePlateManager:HasNamePlate(guid)
    return self.units[guid] ~= nil
end

function EffusionRaidAssistNamePlateManager:GetUnitId(guid)
    return self.unitIds[guid]
end
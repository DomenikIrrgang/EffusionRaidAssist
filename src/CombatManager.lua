EffusionRaidAssistCombatManager = CreateClass()

--[[
    Creates a new CombatManager.
--]]
function EffusionRaidAssistCombatManager.new()
    local self = setmetatable({}, EffusionRaidAssistCombatManager)
    self.activeUnits = {}
    self.inCombat = false
    EffusionRaidAssist.EventDispatcher:AddEventCallback("PLAYER_REGEN_ENABLED", self, self.LeaveCombat)
    EffusionRaidAssist.EventDispatcher:AddEventCallback("PLAYER_REGEN_DISABLED", self, self.EnterCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("UNIT_DIED", {}, self, self.UnitDied)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("UNIT_DESTROYED", {}, self, self.UnitDied)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SWING_DAMAGE", {}, self, self.UnitJoinedCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SWING_MISSED", {}, self, self.UnitJoinedCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SPELL_DAMAGE", {}, self, self.UnitJoinedCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SPELL_AURA_APPLIED", {}, self, self.UnitJoinedCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SPELL_CAST_MISSED", {}, self, self.UnitJoinedCombat)
    EffusionRaidAssist.CombatLogEventDispatcher:AddEventCallback("SPELL_CAST_SUCCESS", {}, self, self.UnitJoinedCombat)
    return self
end

function EffusionRaidAssistCombatManager:UnitJoinedCombat(event)
    if (self:IsInCombat()) then
        if (event:IsTargetPlayer() and event:IsSourceCreature() and UnitIsInPlayersGroup(event.targetName)) then
            self:AddUnit(event.sourceName, event.sourceUnitId, event.sourceGuid)
        end
        if (event:IsSourcePlayer() and event:IsTargetCreature() and UnitIsInPlayersGroup(event.sourceName)) then
            self:AddUnit(event.targetName, event.targetUnitId, event.targetGuid)
        end
    end
end

function EffusionRaidAssistCombatManager:UnitDied(event)
    if (event:IsTargetCreature()) then
        self:RemoveUnit(event.targetName, event.targetUnitId, event.targetGuid)
    end
end

function EffusionRaidAssistCombatManager:AddUnit(name, unitId, guid)
    if (self.activeUnits[guid] == nil) then
        self.activeUnits[guid] = { time = GetTime(), name = name, unitId = unitId }
        EffusionRaidAssist:DebugMessage("Unit Joined Combat", name, "(" .. unitId .. ")")
        EffusionRaidAssist:DebugMessage("Active Units", self:GetUnitCount())
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.UnitJoinedCombat, name, unitId, guid)
    end
end

function EffusionRaidAssistCombatManager:RemoveUnit(name, unitId, guid)
    if (self.activeUnits[guid] ~= nil) then
        self.activeUnits[guid] = nil
        EffusionRaidAssist:DebugMessage("Unit Left Combat", name, "(" .. unitId .. ")")
        EffusionRaidAssist:DebugMessage("Active Units", self:GetUnitCount())
        EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.UnitLeftCombat, name, unitId, guid)
    end
end

function EffusionRaidAssistCombatManager:GetUnitCount()
    return #table.getkeys(self.activeUnits)
end

function EffusionRaidAssistCombatManager:GetActiveUnits()
    return self.activeUnits
end

function EffusionRaidAssistCombatManager:ClearUnits()
    self.activeUnits = {}
    EffusionRaidAssist:DebugMessage("Active Units", self:GetUnitCount())
end

function EffusionRaidAssistCombatManager:LeaveCombat()
    self.inCombat = false
    EffusionRaidAssist:DebugMessage("Player Left Combat")
    self:ClearUnits()
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.CombatLeft)
end

function EffusionRaidAssistCombatManager:EnterCombat()
    self.inCombat = true
    EffusionRaidAssist:DebugMessage("Player Entered Combat")
    EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.CombatEntered)
end

function EffusionRaidAssistCombatManager:IsInCombat()
    return self.inCombat
end
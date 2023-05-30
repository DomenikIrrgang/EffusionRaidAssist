EffusionRaidAssistCombatLogEvent= CreateClass()

--[[
    Creates a new CombatLogEvent.
--]]
function EffusionRaidAssistCombatLogEvent.new()
    local self = setmetatable({}, EffusionRaidAssistCombatLogEvent)
    local timestamp, event, _, sourceGuid, sourceName, sourceFlags, sourceFlags2, targetGuid, targetName, targetFlags, targetFlags2, spellId, spellName, spellSchool, auraType, amount = CombatLogGetCurrentEventInfo()
    self.timestamp = timestamp
	self.name = event
	self.sourceGuid = sourceGuid
	self.sourceName = sourceName
	self.targetGuid = targetGuid
	self.targetName = targetName
    self.spellId = spellId
    self.spellName = spellName
    self.spellSchool = spellSchool

    if (event == "SPELL_INTERRUPT") then
        self.interuptedSpellId = auraType
        self.interuptedSpellName = amount
    else
        self.auraType = auraType
        self.amount = amount
    end

    self.sourceUnitId = GetUnitIdFromGUID(self.sourceGuid)
    self.targetUnitId = GetUnitIdFromGUID(self.targetGuid)
    return self
end

function EffusionRaidAssistCombatLogEvent:IsTargetCreature()
    return string.match(self.targetGuid, "Creature") == "Creature"
end

function EffusionRaidAssistCombatLogEvent:IsSourceCreature()
    return string.match(self.sourceGuid, "Creature") == "Creature"
end

function EffusionRaidAssistCombatLogEvent:IsTargetPlayer()
    return string.match(self.targetGuid, "Player") == "Player"
end

function EffusionRaidAssistCombatLogEvent:IsSourcePlayer()
    return string.match(self.sourceGuid, "Player") == "Player"
end
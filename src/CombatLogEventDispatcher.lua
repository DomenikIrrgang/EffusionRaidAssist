EffusionRaidAssistCombatLogEventDispatcher = CreateClass()

function EffusionRaidAssistCombatLogEventDispatcher.new()
    local self = setmetatable({}, EffusionRaidAssistCombatLogEventDispatcher)
    self.listeners = {}
    self.enabled = true
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

function EffusionRaidAssistCombatLogEventDispatcher:GetGameEvents()
    return {
        "COMBAT_LOG_EVENT_UNFILTERED",
    }
end

function EffusionRaidAssistCombatLogEventDispatcher:AddEventCallback(eventName, spellName, source, callback)
    if (self.listeners[eventName] == nil) then
        self.listeners[eventName] = {}
    end
    local eventCallback = {}
    eventCallback.callback = callback
    eventCallback.source = source
    eventCallback.spellName = spellName
    table.insert(self.listeners[eventName], eventCallback)
end

function EffusionRaidAssistCombatLogEventDispatcher:IsEnabled()
    return self.enabled
end

function EffusionRaidAssistCombatLogEventDispatcher:SetEnabled(enabled)
    self.enabled = enabled
end

function EffusionRaidAssistCombatLogEventDispatcher:Clear()
    self.listeners = {}
end

function EffusionRaidAssistCombatLogEventDispatcher:DispatchEvent(event, data)
    if self.listeners[event] ~= nil then
        for _, eventCallback in pairs(self.listeners[event]) do
            if (eventCallback.source["IsEnabled"] == nil or (eventCallback.source["IsEnabled"] ~= nil and eventCallback.source:IsEnabled())) then
                eventCallback.callback(eventCallback.source, data)
            end
        end
    end
end

function EffusionRaidAssistCombatLogEventDispatcher:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, event, _, sourceGuid, sourceName, sourceFlags, sourceFlags2, destGuid, destName, destFlags, destFlags2, spellId, spellName, spellSchool, auraType, amount= CombatLogGetCurrentEventInfo()
    local combatLogEvent = {}
    combatLogEvent.timestamp = timestamp
	combatLogEvent.name = event
	combatLogEvent.sourceGuid = sourceGuid
	combatLogEvent.sourceName = sourceName
	combatLogEvent.destGuid = destGuid
	combatLogEvent.destName = destName
    combatLogEvent.spellId = spellId
    combatLogEvent.spellName = spellName
    combatLogEvent.spellSchool = spellSchool

    if (event == "SPELL_INTERRUPT") then
        combatLogEvent.interuptedSpellId = auraType
        combatLogEvent.interuptedSpellName = amount
    else
        combatLogEvent.auraType = auraType
        combatLogEvent.amount = amount
    end

    local guidValues = {}
	local i = 1
    for word in string.gmatch(combatLogEvent.sourceGuid, '([^-]+)') do
        guidValues[i] = word
        i = i + 1
    end
    combatLogEvent.unitId = guidValues[6]

    if (self.listeners[combatLogEvent.name] ~= nil) then
        for _, eventListener in ipairs(self.listeners[combatLogEvent.name]) do
            if ((eventListener.spellName == spellName or eventListener.spellName == nil) and event ~= "UNIT_DIED") then
                local guidValues = {}
                local j = 1
                            
                for word in string.gmatch(sourceGuid, '([^-]+)') do
                    guidValues[j] = word
                    j = j + 1
                end
                if (guidValues[1] == "Creature") then
                    combatLogEvent.npc = guidValues[6]
                end
                self:DispatchEvent(event, combatLogEvent)
            end
            
            if (event == "UNIT_DIED" and eventListener.event == "UNIT_DIED") then
                local guidValues = {}
                local j = 1
                            
                for word in string.gmatch(destGuid, '([^-]+)') do
                    guidValues[j] = word
                    j = j + 1
                end
    
                if (eventListener.spellId == tonumber(guidValues[6])) then
                    self:DispatchEvent(event, combatLogEvent)
                end
            end
        end
    end
end
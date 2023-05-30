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

function EffusionRaidAssistCombatLogEventDispatcher:AddEventCallback(eventName, data, source, callback)
    if (self.listeners[eventName] == nil) then
        self.listeners[eventName] = {}
    end
    local eventCallback = {}
    eventCallback.callback = callback
    eventCallback.source = source
    eventCallback.data = data or {}
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

function EffusionRaidAssistCombatLogEventDispatcher:COMBAT_LOG_EVENT_UNFILTERED()
    local combatLogEvent = EffusionRaidAssistCombatLogEvent()
    if (self.listeners[combatLogEvent.name] ~= nil) then
        for _, eventListener in ipairs(self.listeners[combatLogEvent.name]) do
            if (combatLogEvent.name ~= "UNIT_DIED") then
                if ((eventListener.data.spellId == combatLogEvent.spellId or eventListener.data.spellId == nil) and
                    (eventListener.data.sourceUnitId == combatLogEvent.sourceUnitId or eventListener.data.sourceUnitId == nil) and
                    (eventListener.data.targetUnitId == combatLogEvent.targetUnitId or eventListener.data.targetUnitId == nil)) then
                    if (eventListener.source["IsEnabled"] == nil or (eventListener.source["IsEnabled"] ~= nil and eventListener.source:IsEnabled())) then
                        eventListener.callback(eventListener.source, combatLogEvent)
                    end
                end
            end
            if (combatLogEvent.name == "UNIT_DIED") then
                if (eventListener.data.targetUnitId == combatLogEvent.targetUnitId or eventListener.data.targetUnitId == nil) then
                    if (eventListener.source["IsEnabled"] == nil or (eventListener.source["IsEnabled"] ~= nil and eventListener.source:IsEnabled())) then
                        eventListener.callback(eventListener.source, combatLogEvent)
                    end
                end
            end
        end
    end
end
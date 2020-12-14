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

function EffusionRaidAssistCombatLogEventDispatcher:AddEventCallback(eventName, spellId, source, callback)
    if (self.listeners[eventName] == nil) then
        self.listeners[eventName] = {}
    end
    local eventCallback = {}
    eventCallback.callback = callback
    eventCallback.source = source
    eventCallback.spellId = spellId
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
    local combatLogEvent = EffusionRaidAssistCombatLogEvent()
    if (self.listeners[combatLogEvent.name] ~= nil) then
        for _, eventListener in ipairs(self.listeners[combatLogEvent.name]) do
            if ((eventListener.spellId == combatLogEvent.spellId or eventListener.spellId == nil) and combatLogEvent.name ~= "UNIT_DIED") then
                self:DispatchEvent(combatLogEvent.name, combatLogEvent)
            end
            if (combatLogEvent.name == "UNIT_DIED") then
                if (eventListener.spellId == combatLogEvent.targetUnitId or eventListener.spellId == nil) then
                    self:DispatchEvent(combatLogEvent.name, combatLogEvent)
                end
            end
        end
    end
end
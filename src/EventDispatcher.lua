EffusionRaidAssistEventDispatcher = {}
EffusionRaidAssistEventDispatcher.__index = EffusionRaidAssistEventDispatcher

setmetatable(EffusionRaidAssistEventDispatcher, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

--[[
    Creates a new Eventdispatcher.
--]]
function EffusionRaidAssistEventDispatcher.new()
    local self = setmetatable({}, EffusionRaidAssistEventDispatcher)
    self.listener = {}
    self.gameEvents = {}
    self.frame = CreateFrame("Frame", "EffusionRaidAssistEventDispatcher")
    self.frame:SetScript("OnEvent", function(_, event, ...)
        self:DispatchEvent(event, ...)
    end)
    return self
end

--[[
    Removes all listener of the dispatcher.
--]]
function EffusionRaidAssistEventDispatcher:Clear()
    self.listener = {}
    for event, value in pairs(self.gameEvents) do
        self.frame:UnregisterEvent(event)
    end
end

--[[
    Adds a new Eventlistener. Uses the getGameEvents() and getCustomEvents() function of the listener to get the events
    the listener wants to listen to.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddEventListener(eventListener)
    self:AddGameEventListener(eventListener)
    self:AddCustomEventListener(eventListener)
end

--[[
    Adds a new Eventlistener. Uses the getGameEvents() function of the listener to get the events
    the listener wants to listen to.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddGameEventListener(eventListener)
    if (eventListener.GetGameEvents ~= nil) then
        for key, event in pairs(eventListener:GetGameEvents()) do
            self:AddEventIfNotExist(event)
            if (self.listener[event] == nil) then
                self.listener[event] = {}
                self.gameEvents[event] = true
            end
            table.insert(self.listener[event], eventListener)
        end
    end
end

--[[
    Adds a new Eventlistener. Uses the getCustomEvents() function of the listener to get the events
    the listener wants to listen to.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddCustomEventListener(eventListener)
    if (eventListener.GetCustomEvents ~= nil) then
        for key, event in pairs(eventListener:GetCustomEvents()) do
            if (self.listener[event] == nil) then
                self.listener[event] = {}
            end
            table.insert(self.listener[event], eventListener)
        end
    end
end

--[[
    Registers an event if it has not been registered yet.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddEventIfNotExist(event)
    if (self.frame:IsEventRegistered(event) ~= nil) then
        self.frame:RegisterEvent(event)
    end
end

--[[
    Calls all listeners for a given event and forwards the event arguments.
    Also check if a listener is enabled by calling IsEnabled() before invoking
    the event function.

    @param event Event that will be dispatched.
    @param ... Arguments of the event.
--]]
function EffusionRaidAssistEventDispatcher:DispatchEvent(event, ...)
    if self.listener[event] ~= nil then
        for key, listener in pairs(self.listener[event]) do
            if (listener["enabled"] == nil or (listener["enabled"] ~= nil and listener:IsEnabled()) and listener[event] ~= nil) then
                listener[event](listener, ...)
            end
        end
    end
end
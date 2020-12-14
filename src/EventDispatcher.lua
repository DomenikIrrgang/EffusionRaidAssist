EffusionRaidAssistEventDispatcher = CreateClass()

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
    for event in pairs(self.gameEvents) do
        self.frame:UnregisterEvent(event)
    end
    self.gameEvents = {}
end

--[[
    Adds a new Eventlistener. Uses the GetGameEvents() and GetCustomEvents() function of the listener to get the events
    the listener wants to listen to.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddEventListener(eventListener)
    self:AddGameEventListener(eventListener)
    self:AddCustomEventListener(eventListener)
end

--[[
    Adds a new event callback. Function is called like this: callback(listener, ...)

    @param event Event the function shall be called for.
    @param listener Object that will be passed to the function as self.
    @param callback Function that will be called when the event offcurs.
--]]
function EffusionRaidAssistEventDispatcher:AddEventCallback(event, listener, callback)
    self:AddEventIfNotExist(event)
    if (self.listener[event] == nil) then
        self.listener[event] = {}
    end
    table.insert(self.listener[event], { listener = listener, callback = callback })
end

--[[
    Adds a new Eventlistener. Uses the GetGameEvents() function of the listener to get the events
    the listener wants to listen to.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddGameEventListener(eventListener)
    if (eventListener.GetGameEvents ~= nil) then
        for _, event in pairs(eventListener:GetGameEvents()) do
            self.gameEvents[event] = true
            self:AddEventCallback(event, eventListener)
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
        for _, event in pairs(eventListener:GetCustomEvents()) do
            self:AddEventCallback(event, eventListener)
        end
    end
end

--[[
    Registers an event if it has not been registered yet.

    @param eventListener EventListener to be added.
--]]
function EffusionRaidAssistEventDispatcher:AddEventIfNotExist(event)
    if (TableContainsValue(EffusionRaidAssist.CustomEvents, event) == false and self.frame:IsEventRegistered(event) ~= nil) then
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
        for _, value in pairs(self.listener[event]) do
            local listener = value.listener
            if (listener["IsEnabled"] == nil or (listener["IsEnabled"] ~= nil and listener:IsEnabled())) then
                if (value.callback ~= nil) then
                    value.callback(listener, ...)
                else
                    if (listener[event] ~= nil) then
                        listener[event](listener, ...)
                    end
                end
            end
        end
    end
end
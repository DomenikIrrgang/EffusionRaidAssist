EffusionRaidAssist = LibStub("AceAddon-3.0"):NewAddon("EffusionRaidAssist", "AceConsole-3.0")

function EffusionRaidAssist:OnInitialize()
    self.EventDispatcher = EffusionRaidAssistEventDispatcher()
    self.CombatLogEventDispatcher = EffusionRaidAssistCombatLogEventDispatcher()
    self.ModuleManager = EffusionRaidAssistModuleManager()
    self.DungeonManager = EffusionRaidAssistDungeonManager()
    self.EncounterManager = EffusionRaidAssistEncounterManager()
    self.Options = EffusionRaidAssistOptions()
    self.Storage = EffusionRaidAssistDataStorage()
    self.CombatManager = EffusionRaidAssistCombatManager()
    self.FramePool = EffusionRaidAssistFramePool()
    self.ModuleManager:AddModule(EffusionRaidAssistMinimapIcon)
    self.ModuleManager:AddModule(EffusionRaidAssistMainWindow)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitStarted)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInit)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitFinished)
end

function EffusionRaidAssist:ChatMessage(...)
    print(self.MetaData.Color .. "EffusionRaidAssist|r: ", ...)
end

function EffusionRaidAssist:DebugMessage(...)
    if (self.MetaData.Mode == "Debug") then
         self:ChatMessage("|c00008888[Debug] [" .. strmatch(debugstack(2), "(%a*).lua") .. "]|r", ...)
    end
end

EffusionRaidAssist.MetaData = {
    Version = "0.1",
    Date = "11/17/2020",
    Authors = "Suu, Gamko",
    Color = "|c0000FF00",
    Mode = "Debug"
}
EffusionRaidAssist = LibStub("AceAddon-3.0"):NewAddon("EffusionRaidAssist", "AceConsole-3.0")

function EffusionRaidAssist:OnInitialize()
    self.EventDispatcher = EffusionRaidAssistEventDispatcher()
    self.CombatLogEventDispatcher = EffusionRaidAssistCombatLogEventDispatcher()
    self.ModuleManager = EffusionRaidAssistModuleManager()
    self.DungeonManager = EffusionRaidAssistDungeonManager()
    self.EncounterManager = EffusionRaidAssistEncounterManager()
    self.Options = EffusionRaidAssistOptions()
    self.Storage = EffusionRaidAssistDataStorage("EffusionRaidAssistDB")
    self.CombatManager = EffusionRaidAssistCombatManager()
    self.GroupManager = EffusionRaidAssistGroupManager()
    self.NamePlateManager = EffusionRaidAssistNamePlateManager()
    self.FramePool = EffusionRaidAssistFramePool()
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitStarted)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInit)
    self.ModuleManager:AddModule(EffusionRaidAssistMinimapIcon)
    self.ModuleManager:AddModule(EffusionRaidAssistMainWindow)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitFinished)
    self.EventDispatcher:AddEventCallback("PLAYER_LOGIN", self, self.OnPlayerLogin)
end

function EffusionRaidAssist:OnPlayerLogin()
    self.Storage:Init()
    self.ModuleManager:Init()
end

function EffusionRaidAssist:ChatMessage(...)
    print(self.MetaData.Color .. "EffusionRaidAssist|r: ", ...)
end

function EffusionRaidAssist:ErrorMessage(...)
    self:ChatMessage("|c00FF0000[Error]|r", ...)
end

function EffusionRaidAssist:DebugMessage(...)
    if (self.MetaData.Mode == "Debug") then
         self:ChatMessage("|c00008888[Debug] [" .. strmatch(debugstack(2), "(%a*).lua") .. "]|r", ...)
    end
end

function EffusionRaidAssist:ModuleMessage(name, ...)
    self:ChatMessage("|c00008888[" .. name .. "]|r", ...)
end

EffusionRaidAssist.MetaData = {
    Version = "0.1",
    Date = "12/15/2020",
    Authors = "Suu, Gamko",
    Color = "|c0000FF00",
    Mode = "Debug",
    EventLogging = false,
    AddonName = "EffusionRaidAssist"
}
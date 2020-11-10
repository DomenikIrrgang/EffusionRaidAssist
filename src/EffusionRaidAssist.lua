EffusionRaidAssist = LibStub("AceAddon-3.0"):NewAddon("EffusionRaidAssist", "AceConsole-3.0")

EffusionRaidAssist.EventDispatcher = EffusionRaidAssistEventDispatcher()
EffusionRaidAssist.ModuleManager = EffusionRaidAssistModuleManager()
EffusionRaidAssist.DungeonManager = EffusionRaidAssistDungeonManager()
EffusionRaidAssist.Options = EffusionRaidAssistOptions()
EffusionRaidAssist.Storage = EffusionRaidAssistDataStorage()

function EffusionRaidAssist:OnInitialize()
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitStarted)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInit)
    self.EventDispatcher:DispatchEvent(self.CustomEvents.EffusionRaidAssistInitFinished)
end

function EffusionRaidAssist:ChatMessage(...)
    print("|c0000FF00EffusionRaidAssist|r: ", ...)
end

function EffusionRaidAssist:GetCurrentRaid()
    return self.raidInfo
end

EffusionRaidAssist.raidInfo = {
    Suupriest = {}
    --Raids--> Acurielle --> spellsUsed/Enchants --> real spell/concrete enchants
}

EffusionRaidAssist.MetaData = {
    Version = "0.1"
}
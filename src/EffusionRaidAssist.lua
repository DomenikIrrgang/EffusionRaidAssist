EffusionRaidAssist = LibStub("AceAddon-3.0"):NewAddon("EffusionRaidAssist", "AceConsole-3.0")

EffusionRaidAssist.ModuleManager = EffusionRaidAssistModuleManager()

function EffusionRaidAssist:OnInitialize()
    print("EffusionRaidAsssist inititalized")
    self.ModuleManager:Init()
end

function EffusionRaidAssist:GetCurrentRaid()
    return self.raidInfo
end

EffusionRaidAssist.raidInfo = {
    Suupriest = {}
    --Raids--> Acurielle --> spellsUsed/Enchants --> real spell/concrete enchants
}
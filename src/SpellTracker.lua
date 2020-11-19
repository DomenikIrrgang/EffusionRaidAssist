SpellTracker = EffusionRaidAssist.ModuleManager:NewModule("SpellTracker")
local AceGUI = LibStub("AceGUI-3.0")

SpellTracker.trackedSpells = {
    ["Healing Potion"] = { id = 1710 },
    ["Restore Mana"] = { id = 3385 },
    ["Fire Protection"] = { id = 13457 },
    ["Nature Protection "] = { id = 13458 },
    ["Frost Protection"] = { id = 13456 },
    ["Arcane Protection"] = { id = 13461 },
    ["Free Action"] = { id = 5364 },
    ["Goblin Sapper Charge"] = { id = 10646 },
    ["Rage Potion"] = { id = 13442 },
    ["Stoneshield"] = { id = 13455 },
    ["Greater Healthstone"] = { id = 9421 },
    ["Major Healthstone"] = { id = 9421 },
    ["Anti-Venom"] = { id = 6452 },
    ["Powerful Anti-Venom"] = { id = 19440 },
    ["Jungle Remedy"] = { id = 2633 },
    ["Restorative Potion"] = { id = 9030 },
    ["Strong Anti-Venom"] = { id = 6453 },
    ["Dispel Poison"] = { id = 17744 },
    ["Cure Ailments"] = { id = 17744 },
    ["Elixir of the Giants"] = { id = 9206 },
    ["Greater Armor"] = { id = 13445 },
    ["Elixir of the Mongoose"] = { id = 13452 },
    ["Health II"] = { id = 3825 },
    ["Greater Agility"] = { id = 9187 },
    ["Juju Power"] = { id = 12451 },
    ["Mageblood Potion"] = { id = 20007 },
    ["Elixir of Greater Firepower"] = { id = 21546 },
    ["Greater Arcane Elixir"] = { id = 13454 },
    ["Elixir of Shadow Power"] = { id = 11476 },
    ["Winterfall Firewater"] = { id = 12820 },
    ["Restory Energy"] = { id = 7676 },
    ["Stratholme Holy Water"] = { id = 13180 },
    ["Major Troll's Blood Potion"] = { id = 20004 },
    ["Whipper Root Tuber"] = { id = 11951 },
}

function SpellTracker:SpellCastSuccess(event)
    if (SpellTracker.trackedSpells[event.spellName]) then
        if self:GetData().spellUsage[event.sourceName] ~= nil then
            if (self:GetData().spellUsage[event.sourceName][event.spellName] ~= nil) then
                table.insert(self:GetData().spellUsage[event.sourceName][event.spellName], event.timestamp)
            else
                self:GetData().spellUsage[event.sourceName][event.spellName] = { event.timestamp }
            end
        else
            self:GetData().spellUsage[event.sourceName] = {}
            self:GetData().spellUsage[event.sourceName][event.spellName] = { event.timestamp }
        end
        EffusionRaidAssist.EventDispatcher:DispatchEvent("SPELLTRACKER_SPELL_FINISHED_DETECTED", event.sourceName, event.spellName, event.timestamp)
    end
end

function SpellTracker:OnModuleInitialize()
    self:GetData().spellUsage = self:GetData().spellUsage or {}
    self:CombatLogEvent("SPELL_CAST_SUCCESS", nil, self.SpellCastSuccess)
end

function SpellTracker:PrintData()
    EffusionRaidAssist:ChatMessage("Spellusage:")
    for player, data in pairs(self:GetData().spellUsage) do
        EffusionRaidAssist:ChatMessage("Player: ", player)
        for spell, counter in pairs(data) do
            EffusionRaidAssist:ChatMessage("  ", spell, table.getn(counter))
        end
    end
end

function SpellTracker:PrintNothingUsed()
    for i = 1, GetNumGroupMembers() do
        local player = GetRaidRosterInfo(i);
        local data = self:GetData().spellUsage[player]
        if (data == nil) then
            EffusionRaidAssist:ChatMessage("Player: ", player)
            EffusionRaidAssist:ChatMessage("  Nothing used.")
        end
    end
end

function SpellTracker:ResetData()
    self:GetData().spellUsage = {}
end

function SpellTracker:CreateUserinterface()
    local content = AceGUI:Create("SimpleGroup")
    content:SetLayout("Flow")
    content:AddChild(self:CreateFilterContainer())
    local scrollContainer = AceGUI:Create("InlineGroup")
    scrollContainer:SetLayout("Fill")
    scrollContainer:SetFullWidth(true)
    scrollContainer:SetFullHeight(true)
    content:AddChild(scrollContainer)
    local results = AceGUI:Create("ScrollFrame")
    results:SetLayout("List")
    results:SetFullWidth(true)
    results:SetFullHeight(true)
    scrollContainer:AddChild(results)
    for player, data in pairs(self:GetData().spellUsage) do
        local playerContainer = AceGUI:Create("InlineGroup")
        results:AddChild(playerContainer)
        local label = AceGUI:Create("InteractiveLabel")
        label:SetText(player)
        playerContainer:AddChild(label)
        for spellName, casts in pairs(data) do
            local spellContainer = AceGUI:Create("SimpleGroup")
            spellContainer:SetLayout("Flow")
            local spell = AceGUI:Create("InteractiveLabel")
            spell:SetText(spellName .. " " .. table.getn(casts))
            if (self.trackedSpells[spellName]) then
                spell:SetImage(GetSpellTexture(spellName) or GetItemIcon(self.trackedSpells[spellName].id))
            end
            spell:SetFullWidth(true)
            spellContainer:AddChild(spell)
            playerContainer:AddChild(spellContainer)
        end
    end
    return content
end

function SpellTracker:ResetUserInterface()
end

function SpellTracker:CreateFilterContainer()
    local filters = AceGUI:Create("SimpleGroup")
    filters:SetLayout("Flow")
    filters:SetFullWidth(true)
    local spellFilter = AceGUI:Create("Dropdown")
    spellFilter:SetLabel("Spell(s)")
    spellFilter:SetList(table.merge({ ["All"] = "All" }, CreateTableWithKeysAsValues(self.trackedSpells)))
    --spellFilter:SetCallback("OnValueChanged", print)
    spellFilter:SetValue("All")
    filters:AddChild(spellFilter)
    return filters
end

function SpellTracker:GetOptions()
    return {
        print = {
            order = 2,
            name = "Print Data",
            desc = "Print the currently gathered data in chat.",
            type = "execute",
            func = "PrintData",
            width = "full",
            handler = self
        },
        nothing = {
            order = 3,
            name = "Print Nothing used",
            desc = "Print the names of players that didnt use anything.",
            type = "execute",
            func = "PrintNothingUsed",
            width = "full",
            handler = self
        },
        reset = {
            order = 4,
            name = "Reset Data",
            desc = "Reset all gathered data.",
            type = "execute",
            func = "ResetData",
            width = "full",
            handler = self
        }
    }
end
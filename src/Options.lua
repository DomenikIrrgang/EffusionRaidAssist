EffusionRaidAssistOptions = CreateClass()

--[[
	Creates new options.
--]]
function EffusionRaidAssistOptions.new()
	local self = setmetatable({}, EffusionRaidAssistOptions)
	self.name = "options"
    EffusionRaidAssist.EventDispatcher:AddEventListener(self)
    return self
end

--[[
  Returns the customevents that need to be handled by options.

  @return Customevents option needs to handle.
--]]
function EffusionRaidAssistOptions:GetCustomEvents()
    return {
        "EFFUSION_RAID_ASSIST_INIT_FINISHED"
    }
end

--[[
	Registers OptionsTables and invokes the OPTIONS_TABLE_INIT event
--]]
function EffusionRaidAssistOptions:EFFUSION_RAID_ASSIST_INIT_FINISHED()
	EffusionRaidAssist.EventDispatcher:DispatchEvent("OPTIONS_TABLE_INIT")
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("EffusionRaidAssist", self.GetOptionsTable)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EffusionRaidAssist", "EffusionRaidAssist")
end

--[[
	Dynamically builds the optionstable to be displayed in the GUI.
  @return The optionstable.
--]]
function EffusionRaidAssistOptions:GetOptionsTable()
	local optionsTable = {
		type = "group",
		args = {},
    }
	optionsTable.args["modules"] = EffusionRaidAssistOptions.GetModulesTable()
	optionsTable.args["profile"] = EffusionRaidAssistOptions.GetProfileTable()
	return optionsTable
end

function EffusionRaidAssistOptions:GetModulesTable()
	local modules = {
		name = "Modules",
		type = "group",
		order = 1,
		childGroups = "select",
		args = {
			intro = {
				order = 1,
				type = "description",
				name = "Change the settings of a module.",
			},
		},
	}
    for key, module in pairs(EffusionRaidAssist.ModuleManager:GetModules()) do
		modules.args[module.name] = module:GetOptionsTable()
	end
	return modules
end

--[[
	Dynamically creates the table for profile options.
	@return Profile options.
--]]
function EffusionRaidAssistOptions:GetProfileTable()
	return {
		name = "Profile",
		type = "group",
		order = 2,
		childGroups = "select",
		args = {
			intro = {
				order = 1,
				type = "description",
				name = "Change your profile settings.",
			},
			currentprofile = {
				order = 2,
				name = "Current Profile",
				width = "full",
				desc = "Sets the current profile.",
				type = "select",
				get = function(info) 
					for k,v in pairs(EffusionRaidAssist.Storage:GetProfiles()) do
						if (v == EffusionRaidAssist.Storage:GetCurrentProfile()) then
							return k
						end
					end
				end,
				set = function(info, value)
					EffusionRaidAssist.Storage:SetProfile(EffusionRaidAssist.Storage:GetProfiles()[value])
				end,
				values = EffusionRaidAssist.Storage:GetProfiles(),
			},
			copyprofile = {
				order = 3,
				name = "Copy from other Profile",
				width = "full",
				desc = "Copies settings from another profile and overides the current ones.",
				type = "select",
				get = function(info) 
					return "Profiles"
				end,
				set = function(info, value)
					EffusionRaidAssist.Storage:CopyProfile(EffusionRaidAssist.Storage:GetProfiles()[value])
				end,
				values = EffusionRaidAssist.Storage:GetCopyProfiles(),
			},
			resetprofile = {
				order = 4,
				name = "Reset current profile",
				desc = "Resets the currently selected profile to default values.",
				type = "execute",
				func = "ResetProfile",
				width = "full",
				handler = EffusionRaidAssist.Storage
			}
		}
	}
end
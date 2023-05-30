EffusionRaidAssistOptions = CreateClass()

--[[
	Creates new options.
--]]
function EffusionRaidAssistOptions.new()
	local self = setmetatable({}, EffusionRaidAssistOptions)
    EffusionRaidAssist.EventDispatcher:AddEventCallback(EffusionRaidAssist.CustomEvents.EffusionRaidAssistInitFinished, self, self.Init)
	EffusionRaidAssist.EventDispatcher:AddEventCallback(EffusionRaidAssist.CustomEvents.ModuleLoaded, self, self.Init)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(EffusionRaidAssist.MetaData.AddonName, EffusionRaidAssist.MetaData.AddonName)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(EffusionRaidAssist.MetaData.AddonName, self.GetOptionsTable)
    return self
end

--[[
	Registers OptionsTables and invokes the OPTIONS_TABLE_INIT event
--]]
function EffusionRaidAssistOptions:Init()
	EffusionRaidAssist.EventDispatcher:DispatchEvent(EffusionRaidAssist.CustomEvents.OptionsTableInit)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(EffusionRaidAssist.MetaData.AddonName)
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
    for _, module in pairs(EffusionRaidAssist.ModuleManager:GetModules()) do
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
				get = function() 
					for k,v in pairs(EffusionRaidAssist.Storage:GetProfiles()) do
						if (v == EffusionRaidAssist.Storage:GetCurrentProfile()) then
							return k
						end
					end
				end,
				set = function(_, value)
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
				get = function() 
					return "Profiles"
				end,
				set = function(_, value)
					EffusionRaidAssist.Storage:CopyProfile(EffusionRaidAssist.Storage:GetCopyProfiles()[value])
				end,
				values = EffusionRaidAssist.Storage:GetCopyProfiles(),
			},
			deleteprofile = {
				order = 4,
				name = "Delete Profile",
				width = "full",
				desc = "Deletes a profile. Selects the default profile if current profile is deleted.",
				type = "select",
				set = function(_, value)
					EffusionRaidAssist.Storage:DeleteProfile(EffusionRaidAssist.Storage:GetDeleteableProfiles()[value])
				end,
				values = EffusionRaidAssist.Storage:GetDeleteableProfiles(),
			},
			newprofile = {
				order = 5,
				name = "New Profile",
				desc = "Creates a new profile with default values with the given name.",
				type = "input",
				set = function(_, name) EffusionRaidAssist.Storage:NewProfile(name) end,
				width = "full",
			},
			resetprofile = {
				order = 6,
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
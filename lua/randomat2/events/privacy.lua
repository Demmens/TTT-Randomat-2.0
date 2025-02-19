AddCSLuaFile()

local EVENT = {}

EVENT.Title = "We've updated our privacy policy."
EVENT.id = "privacy"
EVENT.Desc = "Everyone is alerted when someone buys a buy menu item"

util.AddNetworkString("AlertTriggerFinal")
util.AddNetworkString("alerteventtrigger")

local ROLE_SNIFFER = ROLE_SNIFFER or false
local ROLE_SERIALKILLER = ROLE_SERIALKILLER or false
local ROLE_SURVIVALIST = ROLE_SURVIVALIST or false

function TriggerAlert(item, role, ply)
	net.Start("alerteventtrigger")
	net.WriteString(item)
	net.WriteString(role)
	net.Send(ply)
end

function EVENT:Begin()

	hook.Add("TTTOrderedEquipment", "RandomatAlertHook", function(ply, item, isItem)

		local role = 0
		local wep = 0

		if ply:GetRole() == ROLE_TRAITOR then			
			role = "traitor"
		elseif ply:GetRole() == ROLE_DETECTIVE then
			role = "detective"
		elseif ply:GetRole() == ROLE_SNIFFER then		
			role = "sniffer"
		elseif ply:GetRole() == ROLE_SERIALKILLER then			
			role = "serial killer"
		elseif ply:GetRole() == ROLE_SURVIVALIST then
			role = "survivalist"
		end
	
		TriggerAlert(item, role, ply)

	end)

	net.Receive("AlertTriggerFinal", function()
		local name = net.ReadString()
		local role = net.ReadString()
		name = renameWeps(name)

		self:SmallNotify("A "..role.." has bought a "..name)

	end)

end

function renameWeps(name)
	if name == "sipistol_name" then
		return "Silenced Pistol"
	elseif name == "knife_name" then
		return "Knife"
	elseif name == "newton_name" then
		return "Newton Launcher"
	elseif name == "tele_name" then
		return "Teleporter"
	elseif name == "hstation_name" then
		return "Health Station"
	elseif name == "flare_name" then
		return "Flare Gun"
	elseif name == "decoy_name" then
		return "Decoy"
	elseif name == "radio_name" then
		return "Radio"
	elseif name == "polter_name" then
		return "Poltergeist"
	elseif name == "vis_name" then
		return "Visualizer"
	elseif name == "defuser_name" then
		return "Defuser"
	elseif name == "stungun_name" then
		return "UMP Prototype"
	elseif name == "binoc_name" then
		return "Binoculars"
	else
		return name
	end
end

function EVENT:End()
	hook.Remove("TTTOrderedEquipment", "RandomatAlertHook")
end

Randomat:register(EVENT)
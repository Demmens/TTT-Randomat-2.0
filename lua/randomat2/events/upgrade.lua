local EVENT = {}

EVENT.Title = "An innocent has been upgraded!"
EVENT.id = "upgrade"
EVENT.Desc = "An innocent has their role upgraded to Survivalist or Serial Killer"
local ROLE_SERIALKILLER = ROLE_SERIALKILLER or false
local ROLE_SURVIVALIST = ROLE_SURVIVALIST or false

util.AddNetworkString("UpgradeEventBegin")
util.AddNetworkString("RdmtCloseUpgradeFrame")
util.AddNetworkString("rdmtPlayerChoseSur")
util.AddNetworkString("rdmtPlayerChoseSk")
CreateConVar("randomat_upgrade_chooserole", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether the innocent should choose their new role.")
	
function EVENT:Begin()
	local k = 0

	for i, ply in RandomPairs(self:GetAlivePlayers(true)) do
		if ply:GetRole() == ROLE_INNOCENT then
			if k == 0 then
				if GetConVar("randomat_upgrade_chooserole"):GetBool() then
					net.Start("UpgradeEventBegin")
					net.Send(ply)
				else
					ply:SetRole(ROLE_SURVIVALIST)
					ply:SetCredits(GetConVar("ttt_sur_credits_starting"):GetInt())
					SendFullStateUpdate()
					k = 1
				end
			end
		end
	end
end

function EVENT:End()
	net.Start("RdmtCloseUpgradeFrame")
	net.Broadcast()
end

function EVENT:Condition()
	local s = 0
	local i = 0
	for k, v in pairs(self:GetAlivePlayers()) do
		if v:GetRole() == ROLE_SURVIVALIST then
			s = 1
		elseif v:GetRole() == ROLE_SERIALKILLER then
			sk = 1
		elseif v:GetRole() == ROLE_INNOCENT then
			i = 1
		end
	end
	if s == 0 and sk == 0 and i == 1 and ROLE_SERIALKILLER and ROLE_SURVIVALIST then
		return true
	else
		return false
	end
end

net.Receive("rdmtPlayerChoseSk", function()
	local v = net.ReadEntity()
	v:SetRole(ROLE_SERIALKILLER)
	SendFullStateUpdate()
	v:SetCredits(GetConVar("ttt_sk_credits_starting"):GetInt())
	v:StripWeapon("weapon_zm_improvised")
	v:Give("weapon_sk_knife")
end)

net.Receive("rdmtPlayerChoseSur", function()
	local v = net.ReadEntity()
	v:SetRole(ROLE_SURVIVALIST)
	SendFullStateUpdate()
	v:SetCredits(GetConVar("ttt_sur_credits_starting"):GetInt())
end)

Randomat:register(EVENT)
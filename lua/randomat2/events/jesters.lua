local EVENT = {}

EVENT.Title = "One Traitor, One Detective. Everyone else is a Jester. Detective is stronger."
EVENT.id = "jesters"
EVENT.Desc = "Detective is given extra hp, everyone else is turned into a jester other than one traitor"

local ROLE_JESTER = ROLE_JESTER or false

function EVENT:Begin()
	local tx = 0
	local dx = 0
	for k, ply in pairs(self:GetAlivePlayers(true)) do
		if (ply:GetRole() == ROLE_TRAITOR and tx == 0) or (ply:GetRole() == ROLE_DETECTIVE and dx == 0) then
			if ply:GetRole() ~= ROLE_DETECTIVE then
				tx = 1
			else
				dx = 1
				ply:SetHealth(200)
				ply:SetMaxHealth(200)
			end
		else
			ply:SetRole(ROLE_JESTER)
			for k, wep in pairs(ply:GetWeapons()) do
				if wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2 then
					ply:StripWeapon(wep:GetClass())
				end
			end
		end
	end

	SendFullStateUpdate()
end

function EVENT:Condition()
	local d = 0
	local t = 0
	for k, v in pairs(self:GetAlivePlayers()) do
		if v:GetRole() == ROLE_DETECTIVE then
			d = 1
		elseif v:GetRole() == ROLE_TRAITOR then
			t = 1
		end
	end
	if t + d == 2 and ROLE_JESTER then
		return true
	else
		return false
	end
end

Randomat:register(EVENT)
local EVENT = {}

EVENT.Title = "RISE FROM YOUR GRAVE"
EVENT.id = "grave"
EVENT.Desc = "Players respawn as infected upon dying"

local ROLE_INFECTED = ROLE_INFECTED or false

CreateConVar("randomat_grave_health", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Changes the health that the infected respawn with in the event \"RISE FROM YOUR GRAVE\"")

function EVENT:Begin()
	timer.Create("infrespawntimer", 1, 0, function()
		for k, ply in pairs(player.GetAll()) do
			if not ply:Alive() and ply:GetRole() ~= ROLE_INFECTED then
				ply:SetRole(ROLE_INFECTED)
				ply:SpawnForRound(true)
				ply:SetHealth(GetConVar("randomat_grave_health"):GetInt())
				ply:SetMaxHealth(GetConVar("randomat_grave_health"):GetInt())
				ply:Give("weapon_inf_claw")
				ply:Give("weapon_zm_carry")
				ply:Give("weapon_zm_improvised")
				ply:Give("weapon_ttt_unarmed")
				SendFullStateUpdate()
			end
		end
	end)
end

function EVENT:End()
	timer.Remove("infrespawntimer")
end

function EVENT:Condition()
	if ROLE_INFECTED then
	 	return true
	else
		return false
	end
end

Randomat:register(EVENT)
local EVENT = {}

EVENT.Title = "We learned how to heal over time, its hard, but definitely possible..."
EVENT.id = "regeneration"
EVENT.Desc = "Players heal out of combat"
--EVENT.Time = 180

CreateConVar("randomat_regeneration_delay", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Changes how long after taking damage you will start to regen health in the event \"We learned how to heal over time\"")
CreateConVar("randomat_regeneration_health", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Changes how much health per second you heal in the event \"We learned how to heal over time\"")

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		ply.rmdregeneration = CurTime() + 1
	end

	hook.Add("Think", "RdmtRegenHook", function() self:Regeneration() end)

	hook.Add("EntityTakeDamage","RdmtRegenDelay" function(victim, dmg)
		if IsValid(victim) and victim:IsPlayer() and victim:IsTerror() and dmg:GetDamage() < victim:Health() then
			victim.rmdregeneration = CurTime() + GetConVar("randomat_regeneration_delay"):GetInt()
		end
	end)
end

function EVENT:Regeneration()
	for _, ply in pairs(self:GetAlivePlayers()) do
		if ply.rmdregeneration <= CurTime() then
			ply:SetHealth(math.Clamp(ply:Health() + GetConVar("randomat_regeneration_health"):GetInt(), 0, ply:GetMaxHealth()))
			ply.rmdregeneration = CurTime() + 1
		end
	end
end

function EVENT:End()
	hook.Remove("Think", "RdmtRegenHook")
	hook.Remove("EntityTakeDamage", "RdmtRegenDelay")
end

Randomat:register(EVENT)
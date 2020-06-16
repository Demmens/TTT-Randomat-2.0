local EVENT = {}

EVENT.Title = "No more Falldamage!"
EVENT.id = "falldamage"
EVENT.Desc = "All fall damage is negated"
--EVENT.Time = 120

function EVENT:Begin()
	hook.Add("EntityTakeDamage","RdmtFallDamage" function(ent, dmginfo)
		if IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() then
			return true
		end
	end)
end

function EVENT:End()
	hook.Remove("EntityTakeDamage", "RdmtFallDamage")
end

Randomat:register(EVENT)
local EVENT = {}

local eventnames = {}
table.insert(eventnames, "Winter has come at last.")
table.insert(eventnames, "The Ice Man cometh.")
table.insert(eventnames, "In this universe, there is only one absolute: everything freezes!")
table.insert(eventnames, "Tonight, Hell freezes over.")
table.insert(eventnames, "I'm afraid my condition has left me cold to your pleas of mercy.")
table.insert(eventnames, "Cool party.")
table.insert(eventnames, "You are not sending me to the cooler.")
table.insert(eventnames, "Stay cool, bird boy.")
table.insert(eventnames, "Alright, everyone! Chill!")
table.insert(eventnames, "It's a cold town.")
table.insert(eventnames, "Tonight's forecast: a freeze is coming!")
table.insert(eventnames, "What killed the dinosaurs?! The ice age!")
table.insert(eventnames, "Let's kick some ice!")
table.insert(eventnames, "Can you feel it coming? The icy cold of space!")
table.insert(eventnames, "Freeze in hell, Batman!")

EVENT.Title = table.Random(eventnames)
EVENT.id = "freeze"
EVENT.Desc = "All Innocents will periodically Freeze and become immune"

CreateConVar("randomat_freeze_duration", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Duration of the Freeze")
CreateConVar("randomat_freeze_timer", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Duration of the Freeze")
CreateConVar("randomat_freeze_hint", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Explains the event after triggering")

function EVENT:Begin()
	
	local tmr = GetConVar("randomat_freeze_timer"):GetInt()

	if GetConVar("randomat_freeze_hint"):GetBool() then
		timer.Simple(5, function()
			self:SmallNotify("All Innocents will Freeze (and become immune) every "..tmr.." seconds")
		end)
	end
	
	local x = 0

	timer.Create("RdmtFreezeTimer", 1, 0, function()		
		x = x+1
		if x == tmr - 3 then
			self:SmallNotify("3")
		elseif x == tmr - 2 then
			self:SmallNotify("2")
		elseif x == tmr - 1 then
			self:SmallNotify("1")
		elseif x == tmr then
			self:SmallNotify("Freeze!")
			for k, v in pairs(self:GetAlivePlayers(true)) do
				if v:GetRole() == ROLE_INNOCENT then
					v:Freeze(true)
					v.isFrozen = true
					timer.Simple(GetConVar("randomat_freeze_duration"):GetInt(), function()
						v:Freeze(false)
						v.isFrozen = false
					end)
				end
			end
			local y = GetConVar("randomat_freeze_duration"):GetInt()
			timer.Create("Rdmt Unfreeze Counter", 1, GetConVar("randomat_freeze_duration"):GetInt(), function()
				y = y-1
				if y <= 3 then
					self:SmallNotify(y)
				end		 
			end)
			x = 0
		end

	end)

	hook.Add("EntityTakeDamage", "RdmtFreezeImmuneHook", function(ply, dmg)
		if ply:IsValid() and ply.isFrozen and dmg:GetAttacker():GetRole() == ROLE_TRAITOR then
			dmg:ScaleDamage(0)
		end
	end)

end

function EVENT:End()
	hook.Remove("EntityTakeDamage", "RdmtFreezeImmuneHook")
	timer.Remove("RdmtFreezeTimer")
end

Randomat:register(EVENT)
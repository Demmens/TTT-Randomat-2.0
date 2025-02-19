local EVENT = {}

CreateConVar("randomat_suspicion_chance", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Changes the chance of the player being a jester in the event \"player is acting suspicious\"")

EVENT.Title = ""
EVENT.id = "suspicion"
EVENT.AltTitle = "A player is acting suspicious"
EVENT.Desc = "A player is changed to either a Jester or a Traitor"

local ROLE_JESTER = ROLE_JESTER or false

function EVENT:Begin()

	local traitor = {}
	local suspicionply = 0

	for k, v in pairs(self:GetAlivePlayers(true)) do
		if v:GetRole() == ROLE_TRAITOR then
			table.insert(traitor, v)
			if suspicionply == 0 then
				suspicionply = v
			end
		elseif v:GetRole() == ROLE_INNOCENT or v:GetRole() == ROLE_SURVIVALIST or v:GetRole() == ROLE_PHOENIX then
			suspicionply = v
		elseif suspicionply == 0 and v:GetRole() ~= ROLE_DETECTIVE then
			suspicionply = v
		end
	end

	if suspicionply ~= 0 then
		Randomat:EventNotifySilent(suspicionply:Nick().." is acting suspicious...")

		if math.random(1,100) <= GetConVar("randomat_suspicion_chance"):GetInt() then
			suspicionply:SetRole(ROLE_JESTER)
			for k, v in pairs(traitor) do
				v:PrintMessage(HUD_PRINTCENTER, suspicionply:Nick().." is a jester")
				v:PrintMessage(HUD_PRINTTALK, suspicionply:Nick().." is a jester")
			end
		else
			suspicionply:SetRole(ROLE_TRAITOR)
			for k, v in pairs(traitor) do
				v:PrintMessage(HUD_PRINTCENTER, suspicionply:Nick().." is a traitor")
				v:PrintMessage(HUD_PRINTTALK, suspicionply:Nick().." is a traitor")
			end
		end
		SendFullStateUpdate()
	end

end

function EVENT:Condition()
	if ROLE_JESTER then
		return true
	else
		return false
	end
end

Randomat:register(EVENT)
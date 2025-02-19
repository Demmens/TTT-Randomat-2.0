AddCSLuaFile()

local EVENT = {}

CreateConVar("randomat_blind_duration", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE} , "Changes the duration of the blind in the event \"All triators have been blinded\"")

util.AddNetworkString("blindeventactive")

EVENT.Title = "All traitors have been blinded for "..GetConVar("randomat_blind_duration"):GetInt().." seconds!"
EVENT.id = "blind"
EVENT.Desc = "Periodically blinds traitors"

function RemoveBlind()
	net.Start("blindeventactive")
	net.WriteBool(false)
	net.Broadcast()
end

function TriggerBlind()
	net.Start("blindeventactive")
	net.WriteBool(true)
	net.Broadcast()

	local duration = GetConVar("randomat_blind_duration"):GetInt()

	timer.Create("RandomatBlindTimer", duration, 1, function()
		RemoveBlind()
	end)
end

function EVENT:Begin()
	EVENT.Title = "All traitors have been blinded for "..GetConVar("randomat_blind_duration"):GetInt().." seconds!"
	TriggerBlind()
end

function EVENT:End()
	RemoveBlind()
end

function EVENT:Condition()
	local x = 0
	for k, v in pairs(self:GetAlivePlayers(true)) do
		if v:GetRole() == ROLE_TRAITOR then
			x = 1
		end
	end

	if x == 1 then
		return true
	else
		return false
	end
end


Randomat:register(EVENT)
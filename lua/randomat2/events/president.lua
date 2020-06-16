local EVENT = {}

EVENT.Title = "Get Down Mr President!"
EVENT.id = "president"
EVENT.Desc = "The detective is given more health, but if they die, the innocents lose"

CreateConVar("randomat_president_bonushealth", 100, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Extra health gained by the detective")

local ROLE_JESTER = ROLE_JESTER or false
local ROLE_SERIALKILLER = ROLE_SERIALKILLER or false
local ROLE_INFECTED = ROLE_INFECTED or false

local function ply:IsEvil()
	if self:GetRole() == ROLE_JESTER or self:GetRole() == ROLE_SERIALKILLER or self:GetRole() == ROLE_INFECTED or self:GetRole() == ROLE_TRAITOR then
		return true
	else
		return false
	end
end

function EVENT:Begin()
	local owner
	local d = 0
	if self.owner:GetRole() ~= ROLE_DETECTIVE then
		for k, v in pairs(self:GetAlivePlayers(true)) do
			if v:GetRole() == ROLE_DETECTIVE then
				d = 1
				owner = v
			end
		end
		if d ~= 1 then
			owner = self.owner
		end
		owner:SetRole(ROLE_DETECTIVE)
		SendFullStateUpdate()
	else
		owner = self.owner
	end
	owner:SetMaxHealth(owner:GetMaxHealth()+GetConVar("randomat_president_bonushealth"):GetInt())
	owner:SetHealth(owner:GetMaxHealth())

	hook.Add("PlayerDeath", "RandomatPresident", function(tgt, dmg, ply)
		if tgt:IsValid() and tgt == owner then
			for k, v in pairs(self:GetAlivePlayers(true)) do
				if not v:IsEvil() then
					v:Kill()
				end
			end
		end
	end)
end

function EVENT:End()
	hook.Remove("PlayerDeath", "RandomatPresident")
end

function EVENT:Condition()
	local d = 0
	for k, v in pairs(self:GetAlivePlayers(true)) do
		if v:GetRole() == ROLE_DETECTIVE then
			d = 1
		end
	end

	if d == 1 then
		return true
	end
end

Randomat:register(EVENT)
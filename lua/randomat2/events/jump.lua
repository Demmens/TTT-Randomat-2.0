local EVENT = {}

EVENT.Title = "You can only jump once."
EVENT.id = "jump"

local ROLE_JESTER = ROLE_JESTER or false

function EVENT:Begin()
	hook.Add("KeyPress", "RdmtJumpHook", function(ply, key)

		if key == IN_JUMP and ply:Alive() and not ply:IsSpec() and ply:OnGround() then 
			if ply.rdmtJumps then
				util.BlastDamage(ply, ply, ply:GetPos(), 100, 500)
				if ply:GetRole() ~= ROLE_JESTER then
					self:SmallNotify(ply:Nick().." tried to jump twice..")
				end
				ply.rdmtJumps = nil
			else
				ply.rdmtJumps = 1
			end
		end

	end)
end

function EVENT:End()
	hook.Remove("KeyPress", "RdmtJumpHook")
end

Randomat:register(EVENT)
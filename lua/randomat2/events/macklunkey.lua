local EVENT = {}

EVENT.Title = "Who shot first?"
EVENT.id = "macklunkey"

function EVENT:Begin()
----------Setup
	local plys = {}
	for k, v in pairs(self:GetAlivePlayers(true)) do --make table of players in a random order
		plys[k] = v
		v.shouldAttack = 0
	end

	for k, v in pairs(plys) do
		if math.floor(k/2) == k/2 then --if they are in an even entry, link them to the player below them
			v.partner = plys[k-1]
		elseif k+1 <= #plys then --otherwise link them to the player above (if there is one)
			v.partner = plys[k+1]
		end
		if v.partner then
			v:PrintMessage(HUD_PRINTTALK, "Your weapon is linked to "..v.partner:Nick())
		else
			v.partner = false
			v:PrintMessage(HUD_PRINTTALK, "Your weapon is not linked to anyone")
		end
	end
----------Hook

	hook.Add("Think", "RdmtLinkWeaponsHook", function()
		for k, v in pairs(self:GetAlivePlayers(true)) do
			if v.partner:IsValid() then
				local ply = v.partner
				local wep = ply:GetActiveWeapon()
				if v:KeyDown(IN_ATTACK) and v:GetActiveWeapon().Primary.Automatic == true and ply:IsValid() and ply:Alive() and wep:Clip1() ~= 0 and CurTime() >= wep:GetNextPrimaryFire() and v:GetActiveWeapon():Clip1() > 0 and v:Alive() then
					wep:PrimaryAttack()
					ply:ViewPunch( Angle( util.SharedRandom(wep:GetClass(),-0.2,-0.1,0) * wep.Primary.Recoil, util.SharedRandom(wep:GetClass(),-0.1,0.1,1) * wep.Primary.Recoil, 0 ) )
					wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay)
				end
			end
		end
	end)

end

function EVENT:End()
	hook.Remove("Think", "RdmtLinkWeaponsHook")
end

Randomat:register(EVENT)
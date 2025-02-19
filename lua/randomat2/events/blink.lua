local EVENT = {}

EVENT.Title = "Don't Blink."
EVENT.id = "blink"
Event.Desc = "Every player is persued by a weeping angel"

CreateConVar("randomat_blink_cap", 12, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Max angels spawned in \"Don't Blink\", set to 0 to disable")
CreateConVar("randomat_blink_delay", 0.5, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay between angel spawns in \"Don't Blink\"")

function EVENT:Begin()
	local plys = {}
	for k, v in pairs(self:GetAlivePlayers(true)) do
		table.insert(plys, v)
	end
	local k = 1
	timer.Create("AngelTimer", GetConVar("randomat_blink_delay"):GetFloat(), 0, function()
		if plys[k] ~= nil then
			local ply = plys[k]

			while not ply:Alive() do
				k = k+1
				ply = plys[k]
			end
			if k <= GetConVar("randomat_blink_cap"):GetInt() or GetConVar("randomat_blink_cap"):GetInt() == 0 then
				local ent = ents.Create( "weepingangel" )
				ent:SetPos(ply:GetAimVector())
				ent:Spawn()
				ent:Activate()

				ent:SetVictim( ply )
				ent:DropToFloor()
			end
			k = k+1
		end
	end)
end

function EVENT:Condition()
	if ents.FindByName("weepingangel") ~= {} then
		return true
	else
		return false
	end
end

Randomat:register(EVENT)
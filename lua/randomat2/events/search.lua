local EVENT = {}

EVENT.Title = "Dead Men Tell no Tales"
EVENT.id = "search"
EVENT.Desc = "Bodies can no longer be searched"

function EVENT:Begin()
	hook.Add("TTTCanSearchCorpse", "BodySearchRandomat", function()
		return false
	end)
end

function EVENT:End()
	hook.Remove("TTTCanSearchCorpse", "BodySearchRandomat")
end

Randomat:register(EVENT)
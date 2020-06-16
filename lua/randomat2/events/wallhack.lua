local EVENT = {}

EVENT.Title = "No one can hide from my sight"
EVENT.id = "wallhack"
EVENT.Desc = "All players are visible through walls"

util.AddNetworkString("haloeventtrigger")
util.AddNetworkString("haloeventend")

function EVENT:Begin()
	net.Start("haloeventtrigger")
	net.Broadcast()
end

function EVENT:End()
	net.Start("haloeventend")
	net.Broadcast()
end

Randomat:register(EVENT)
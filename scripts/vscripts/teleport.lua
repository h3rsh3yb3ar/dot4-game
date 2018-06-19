function teleportplayer(trigger)
	activator = trigger.activator
	vector = Entities:FindByName( nil, "tptest"):GetAbsOrigin()
	activator:SetOrigin(vector)
end
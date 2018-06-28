function RevealUsed( keys )
	local targetUnit = keys.target_entities[1]
	local caster = keys.caster
	caster:GetTeam()
	local team = caster:GetTeam()

if team == 6 then
	GameRules:SendCustomMessage("<font color='#ff0000'>red Team</font> Has Used A Flare!", 0, 0)end
if team == 7 then
	GameRules:SendCustomMessage("<font color='#FFFF00'>yellow Team</font> Has Used A Flare", 0, 0)end
if team == 8 then
	GameRules:SendCustomMessage("<font color='#008000'>Green Team</font> Has Used A Flare!", 0, 0)end
if team == 9 then
	 GameRules:SendCustomMessage("<font color='#87ceeb'>Blue Team</font> Has Used A Flare!", 0, 0)end


	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)
		if item then
			if item:GetAbilityName() == 'item_forseers_flare' then
				if item:GetCurrentCharges() == 1 then
					UTIL_RemoveImmediate(item)
				else
					item:SetCurrentCharges(item:GetCurrentCharges() - 1)
				end
			end
		end
	end
end
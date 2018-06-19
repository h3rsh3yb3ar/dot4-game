--[[ custom_tower.lua ]]

function Spawn( entityKeyValues )
    thisEntity:SetContextThink ("CustomTowerThink", CustomTowerThink , 1)
	print ("tower has been created")
end

function CustomTowerThink()
    thisEntity:RemoveModifierByName("modifier_invulnerable")
end
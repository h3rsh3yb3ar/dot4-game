-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('trialsofretribution')
require("statcollection/init")
require("libraries/selection")

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See Trialsofretribution:PostLoadPrecache() in trialsofretribution.lua for more information
  ]]

  DebugPrint("[TRIALSOFRETRIBUTION] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
  PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/music/valve_dota_001/stingers/game_sounds_stingers.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_stingers_diretide.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/warchasers_sounds_custom.vsndevts", context )	


  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)
  PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", context)
	PrecacheResource( "particle", "particles/sweep_generic/sweep_2.vpcf", context)
	PrecacheResource( "particle", "particles/sweep_generic/sweep_1.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_b.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_rain_storm.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_replicate_finish.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_armor.vpcf" , context)
	PrecacheResource( "particle", "particles/units/heroes/hero_broodmother/broodmother_portrait_spiderling.vpcf", context)
	PrecacheResource( "particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_feast.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", context)
	PrecacheResource( "particle", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf", context)
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_staff_glory/warlock_upheaval_hellborn_debuff.vpcf", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  PrecacheUnitByNameSync("npc_dota_tower_tier2", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.Trialsofretribution = Trialsofretribution()
  GameRules.Trialsofretribution:_InitTrialsofretribution()
  GameRules:GetGameModeEntity():SetCameraDistanceOverride(1341)
  
end

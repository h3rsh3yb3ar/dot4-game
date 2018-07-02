-- This is the primary trialsofretribution trialsofretribution script and should be used to assist in initializing your game mode
TRIALSOFRETRIBUTION_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by trialsofretribution
-- You can also change the cvar 'trialsofretribution_spew' at any time to 1 or 0 for output/no output
TRIALSOFRETRIBUTION_DEBUG_SPEW = false
trialsofretribution_spew = 0
if Trialsofretribution == nil then
    DebugPrint( '[TRIALSOFRETRIBUTION] creating trialsofretribution game mode' )
    _G.Trialsofretribution = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up trialsofretribution's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/trialsofretribution')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core trialsofretribution files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core trialsofretribution files.
require('events')
require('junglecamps')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function Trialsofretribution:PostLoadPrecache()
  DebugPrint("[TRIALSOFRETRIBUTION] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitTrialsofretribution() but needs to be done before everyone loads in.
]]
function Trialsofretribution:OnFirstPlayerLoaded()
  DebugPrint("[TRIALSOFRETRIBUTION] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function Trialsofretribution:OnAllPlayersLoaded()
  DebugPrint("[TRIALSOFRETRIBUTION] All Players have loaded into the game")
  EmitAnnouncerSound("announcer_announcer_ban_yr")
  local start_after = 10
      Timers:CreateTimer(start_after, function()
        heroselect()
    end)
      CustomUI:DynamicHud_Destroy(-1, "loading screen")
end
function heroselect()      
  EmitAnnouncerSound("announcer_announcer_now_select")
_G.reconnect1 = 1 
_G.reconnect2 = 1 
_G.reconnect3 = 1 
_G.reconnect4 = 1 
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function Trialsofretribution:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  -- local item = CreateItem("item_example_item", hero, hero)
  -- hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability
  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function Trialsofretribution:OnGameInProgress()
_G.heroteam1 = 0
_G.heroteam2 = 0
_G.heroteam3 = 0
_G.heroteam4 = 0

-- Handles unbalanced number of players on a team
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local pteam = entity:GetTeam()
if pteam == 6 then
_G.heroteam1 = _G.heroteam1 + 1
end
if pteam == 7 then
_G.heroteam2 = _G.heroteam2 + 1
  end
  if pteam == 8 then
_G.heroteam3 = _G.heroteam3 + 1
  end
  if pteam == 9 then
_G.heroteam4 = _G.heroteam4 + 1
  end
  
end

print(_G.heroteam1 .. "heroes on team 1 " .. _G.heroteam2 .. "heroes on team 2 " .. _G.heroteam3 .. "heroes on team 3 " .. _G.heroteam4 .. "heroes on team 4 ")

if _G.heroteam1 < _G.heroteam2 or _G.heroteam1 < _G.heroteam3 or _G.heroteam1 < _G.heroteam4 then
    local repeat_interval = 2 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team1bonusgold()
        return repeat_interval
    end)
end 

if _G.heroteam2 < _G.heroteam1 or _G.heroteam2 < _G.heroteam3 or _G.heroteam2 < _G.heroteam4 then
    local repeat_interval = 2 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team2bonusgold()
        return repeat_interval
    end)
end 

if _G.heroteam3 < _G.heroteam1 or _G.heroteam3 < _G.heroteam2 or _G.heroteam3 < _G.heroteam4 then
    local repeat_interval = 2 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team3bonusgold()
        return repeat_interval
    end)
end 

if _G.heroteam4 < _G.heroteam1 or _G.heroteam4 < _G.heroteam2 or _G.heroteam4 < _G.heroteam3 then
    local repeat_interval = 2 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team4bonusgold()
        return repeat_interval
    end)
end 


function team1bonusgold()
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local pteam = entity:GetTeam()
if pteam == 6 then
local player = entity:GetPlayerID()
local gold = PlayerResource:GetGold(player)
PlayerResource:SetGold( player, gold + 1.04, true )
end
end
end
function team2bonusgold()
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local pteam = entity:GetTeam()
if pteam == 7 then
local player = entity:GetPlayerID()
local gold = PlayerResource:GetGold(player)
PlayerResource:SetGold( player, gold + 1.04, true )
end
end
end
function team3bonusgold()
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local pteam = entity:GetTeam()
if pteam == 8 then
local player = entity:GetPlayerID()
local gold = PlayerResource:GetGold(player)
PlayerResource:SetGold( player, gold + 1.04, true )
end
end
end
function team4bonusgold()
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local pteam = entity:GetTeam()
if pteam == 9 then
local player = entity:GetPlayerID()
local gold = PlayerResource:GetGold(player)
PlayerResource:SetGold( player, gold + 1.04, true )
end
end
end
_G.canspawn = true
_G.canspawn2 = true
_G.canspawn3 = true
_G.canspawn4 = true
_G.canspawn5 = true
_G.canspawn6 = true
_G.canspawn7 = true
_G.canspawn8 = true
_G.canspawn9 = true
_G.canspawn10 = true
_G.canspawn11 = true
_G.canspawn12 = true
_G.canspawn13 = true
_G.canspawn14 = true
_G.canspawn15 = true
_G.canspawn16 = true
_G.canspawn17 = true
_G.canspawn18 = true
_G.canspawn19 = true
_G.canspawn20 = true
_G.canspawn21 = true
_G.canspawn22 = true
_G.canspawn23 = true
_G.canspawn24 = true
_G.canspawn25 = true
_G.canspawn26 = true
_G.canspawn27 = true
_G.canspawn28 = true
_G.canspawn29 = true
_G.canspawn30 = true
_G.canspawn31 = true
_G.canspawn32 = true
_G.radtopmelee = 1
_G.radtoprange = 1
_G.diremidmelee = 1
_G.diremidrange = 1
_G.direbotmelee = 1
_G.direbotrange = 1
_G.snowtopmelee = 1
_G.snowtoprange = 1
_G.midsnowrange = 1
_G.midsnowmelee = 1
_G.radiantmidmelee = 1
_G.radiantmidrange = 1
_G.diretopmelee = 1
_G.diretoprange = 1
_G.radiantbotmelee = 1
_G.radiantbotrange = 1
_G.fallmidmelee = 1
_G.fallmidrange = 1
_G.falltoprange = 1
_G.falltopmelee = 1
_G.fallbotrange = 1
_G.fallbotmelee = 1
_G.snowbotrange = 1
_G.snowbotmelee = 1
_G.fortsalive = 4
    local repeat_interval = 30 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
	EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        SpawnCreeps()
        return repeat_interval
    end)



function SpawnCreeps()

    
    
--RADIANT MID CREEPS
    local point = Entities:FindByName( nil, "radiantmid"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "radiantmidloc1")
    if _G.midsnowrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.midsnowrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
  if midsnowmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
  if midsnowmelee == 0 then
      local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
      
        
--RADIANT TOP CREEPS
      
        local point = Entities:FindByName( nil, "radiantbot"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "radiantbotloc1")
    if _G.fallbotrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.fallbotrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.fallbotmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    
  end
    if _G.fallbotmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    
  end
    
    
    
--RADIANT BOTTOM CREEPS
    
    local point = Entities:FindByName( nil, "radianttop"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "radianttoploc1")
    if _G.snowtoprange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.snowtoprange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
  end

  if _G.snowtopmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom3_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    
  end
    if _G.snowtopmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom3_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
    
  end
		end

    local repeat_interval = 30 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    

    Timers:CreateTimer(start_after, function()
        SpawnCreepsaltiar()
        return repeat_interval
    end)


function SpawnCreepsaltiar()
    
--ALTIAR MID CREEPS
    
        local point = Entities:FindByName( nil, "altiarmid"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "snowmidcreep")
    if _G.radiantmidrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    end
    if _G.radiantmidrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    end
    if _G.radiantmidmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
  end
      if _G.radiantmidmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity(  waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
  end
       
-- ALTIAR BOT CREEPS
    
    local point = Entities:FindByName( nil, "altiarbot"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "altiarbotloc1")
if _G.diretopmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.diretopmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.diretopmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
  end
    if _G.diretopmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
  end
    
-- ALTIAR TOP CREEPS
    
    local point = Entities:FindByName( nil, "altiartop"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "altiartoploc1")
    if _G.radiantbotrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.radiantbotrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.radiantbotmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom2_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
		end
      if _G.radiantbotmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom2_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
    
    end
  end

    local repeat_interval = 30 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    

    Timers:CreateTimer(start_after, function()
        SpawnCreepsdire()
        return repeat_interval
    end)


function SpawnCreepsdire()
    
-- DIRE MID CREEPS
    
    local point = Entities:FindByName( nil, "diremid"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "diremidloc1")
    if _G.fallmidrange == 1 then
local unit = CreateUnitByName("npc_dota_creep_custom4_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.fallmidrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.fallmidmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
      if _G.fallmidmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
        
    -- DIRE TOP CREEPS
    
    local point = Entities:FindByName( nil, "diretop"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "diretoploc1")
    if _G.falltoprange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.falltoprange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.falltopmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
      if _G.falltopmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
    
    -- DIRE BOTTOM CREEPS
    
    local point = Entities:FindByName( nil, "direbot"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "direbotloc1")
    if _G.snowbotrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    end
        if _G.snowbotrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    end
    if _G.snowbotmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom4_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
	end
      if _G.snowbotmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom4_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
end

    local repeat_interval = 30 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    print ("Timer 2 is running")

    Timers:CreateTimer(start_after, function()
        SpawnCreepstempest()
        return repeat_interval
    end)


function SpawnCreepstempest()
    
-- TEMPEST MID CREEPS
    
    local point = Entities:FindByName( nil, "tempestmid"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "tempestmidloc1")
    if _G.diremidrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    end
        if _G.diremidrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    end
    if _G.diremidmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
  if _G.diremidmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
     
    -- TEMPEST BOTTOM CREEPS
    
    local point = Entities:FindByName( nil, "tempestbot"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "tempestbotloc1")
    if _G.direbotrange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.direbotrange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
  if _G.direbotmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
   if _G.direbotmelee == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
    




    -- TEMPEST TOP CREEPS
    
    local point = Entities:FindByName( nil, "tempesttop"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "tempesttoploc1")
    if _G.radtoprange == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
      if _G.radtoprange == 0 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_ranged_upgraded_mega", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
  end
    if _G.radtopmelee == 1 then
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
	    local unit = CreateUnitByName("npc_dota_creep_custom1_melee", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
  if _G.radtopmelee == 0 then
      local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
      local unit = CreateUnitByName("npc_dota_creep_custom1_melee_upgraded", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
    print ("units were spawned in!")
  end
    
end

    local repeat_interval = 210 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 210 -- Start this timer *start_after* game-time seconds later
    print ("Timer 2 is running")

    Timers:CreateTimer(start_after, function()
        SpawnCreepssiege()
        return repeat_interval
    end)


function SpawnCreepssiege()

		-- SIEGE CREEPS TEMPEST
		
    local point = Entities:FindByName( nil, "tempesttop"):GetAbsOrigin()
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    local waypoint = Entities:FindByName(nil, "tempesttoploc1")    	
    unit:SetInitialGoalEntity( waypoint )
	print ("siege spawned in")
	local point = Entities:FindByName( nil, "tempestbot"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "tempestbotloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )

	    local point = Entities:FindByName( nil, "tempestmid"):GetAbsOrigin()

    local waypoint = Entities:FindByName(nil, "tempestmidloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_2)
    unit:SetInitialGoalEntity( waypoint )
	end
	
	    local repeat_interval = 210 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 210 -- Start this timer *start_after* game-time seconds later
    print ("Timer 2 is running")

    Timers:CreateTimer(start_after, function()
        SpawnCreepssiegedire()
        return repeat_interval
    end)


function SpawnCreepssiegedire()
	
	-- SIEGE CREEPS DIRE
	
	local point = Entities:FindByName( nil, "direbot"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "direbotloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
	local point = Entities:FindByName( nil, "diretop"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "diretoploc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )
	local point = Entities:FindByName( nil, "diremid"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "diremidloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_4)
    unit:SetInitialGoalEntity( waypoint )

		end
	
	    local repeat_interval = 210 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 210 -- Start this timer *start_after* game-time seconds later
    print ("Timer 2 is running")

    Timers:CreateTimer(start_after, function()
        SpawnCreepssiegeradiant()
        return repeat_interval
    end)


function SpawnCreepssiegeradiant()
	
	-- SIEGE CREEPS RADIANT
	
	local point = Entities:FindByName( nil, "radianttop"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "radianttoploc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
	local point = Entities:FindByName( nil, "radiantbot"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "radiantbotloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )

	    local point = Entities:FindByName( nil, "radiantmid"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "radiantmidloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_3)
    unit:SetInitialGoalEntity( waypoint )
	
	end
	
	    local repeat_interval = 210 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 210 -- Start this timer *start_after* game-time seconds later
    print ("Timer 2 is running")

    Timers:CreateTimer(start_after, function()
        SpawnCreepssiegealtiar()
        return repeat_interval
    end)


function SpawnCreepssiegealtiar()
	
	-- SIEGE CREEPS ALTIAR
	
	local point = Entities:FindByName( nil, "altiartop"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "altiartoploc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
	local point = Entities:FindByName( nil, "altiarbot"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "altiarbotloc1")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )

	local point = Entities:FindByName( nil, "altiarmid"):GetAbsOrigin()
    local waypoint = Entities:FindByName(nil, "snowmidcreep")
    local unit = CreateUnitByName("npc_dota_custom1_siege", point, true, nil, nil, DOTA_TEAM_CUSTOM_1)
    unit:SetInitialGoalEntity( waypoint )
end

--[[
-- JUNGLE CAMP FUNCTIONS
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps1()
        return repeat_interval
        
    end)
function junglecamps1()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle1e"):GetAbsOrigin()
print(tostring(_G.canspawn))
  if i == 1 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

    local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps2()
        return repeat_interval
        
    end)
function junglecamps2()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle2e"):GetAbsOrigin()
print(tostring(_G.canspawn2))
  if i == 1 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn2 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps3()
        return repeat_interval
        
    end)
function junglecamps3()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle3e"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn3 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps4()
        return repeat_interval
        
    end)

function junglecamps4()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle4e"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn4 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps5()
        return repeat_interval
        
    end)

function junglecamps5()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle5e"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn5 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps6()
        return repeat_interval
        
    end)

function junglecamps6()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle6e"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn6 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps7()
        return repeat_interval
        
    end)

function junglecamps7()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle1m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn7 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn7 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn7 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn7 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn7 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps8()
        return repeat_interval
        
    end)

function junglecamps8()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle2m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn8 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn8 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn8 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn8 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn8 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end 

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps9()
        return repeat_interval
        
    end)

function junglecamps9()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle3m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn9 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn9 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn9 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn9 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn9 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps10 ()
        return repeat_interval
        
    end)

function junglecamps10()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle4m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn10 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn10 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn10 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn10 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn10 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps11 ()
        return repeat_interval
        
    end)

function junglecamps11()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle5m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn11 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn11 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn11 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn11 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn11 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps12 ()
        return repeat_interval
        
    end)

function junglecamps12()


  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle6m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn12 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn12 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn12 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn12 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn12 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps13 ()
        return repeat_interval
        
    end)

function junglecamps13()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle7e"):GetAbsOrigin()
  print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn13 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps14 ()
        return repeat_interval
        
    end)

function junglecamps14()


  local i = RandomInt(1, 6)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle8e"):GetAbsOrigin()
  print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_berserker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_tunneler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_kobold_taskmaster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_forest_troll_high_priest", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_gnoll_assassin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_wraith_ghost", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 6 and _G.canspawn14 == true then 
        CreateUnitByName("npc_dota_neutral_harpy_storm", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_harpy_scout", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps15 ()
        return repeat_interval
        
    end)

function junglecamps15()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle7m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn15 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn15 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn15 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn15 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn15 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps16 ()
        return repeat_interval
        
    end)

function junglecamps16()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle8m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn16 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn16 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn16 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn16 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn16 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps17 ()
        return repeat_interval
        
    end)

function junglecamps17()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle9m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn17 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn17 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn17 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn17 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn17 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps18 ()
        return repeat_interval
        
    end)

function junglecamps18()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle10m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn18 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn18 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn18 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn18 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn18 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps19 ()
        return repeat_interval
        
    end)

function junglecamps19()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle11m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn19 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn19 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn19 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn19 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn19 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps20 ()
        return repeat_interval
        
    end)

function junglecamps20()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle12m"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn20 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn20 == true then 
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_giant_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_alpha_wolf", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn20 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn20 == true then 
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_mauler", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_ogre_magi", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn20 == true then 
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_mud_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps21 ()
        return repeat_interval
        
    end)

function junglecamps21()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle1h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn21 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn21 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn21 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn21 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn21 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps22 ()
        return repeat_interval
        
    end)

function junglecamps22()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle2h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn22 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn22 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn22 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn22 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn22 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps23 ()
        return repeat_interval
        
    end)

function junglecamps23()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle3h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn23 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn23 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn23 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn23 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn23 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps24 ()
        return repeat_interval
        
    end)

function junglecamps24()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle4h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn24 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn24 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn24 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn24 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn24 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps25 ()
        return repeat_interval
        
    end)

function junglecamps25()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle5h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn25 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn25 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn25 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn25 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn25 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps26 ()
        return repeat_interval
        
    end)

function junglecamps26()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle6h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn26 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn26 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn26 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn26 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn26 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps27 ()
        return repeat_interval
        
    end)

function junglecamps27()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle7h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn27 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn27 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn27 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn27 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn27 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps28 ()
        return repeat_interval
        
    end)

function junglecamps28()
  local i = RandomInt(1, 5)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle8h"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn28 == true then 
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_outrunner", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_centaur_khan", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn28 == true then 
        CreateUnitByName("npc_dota_neutral_polar_furbolg_ursa_warrior", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_polar_furbolg_champion", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn28 == true then 
        CreateUnitByName("npc_dota_neutral_satyr_soulstealer", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_hellcaller", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_satyr_trickster", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn28 == true then 
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_enraged_wildkin", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 5 and _G.canspawn28 == true then 
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_dark_troll_warlord", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps29 ()
        return repeat_interval
        
    end)

function junglecamps29()
  local i = RandomInt(1, 4)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle1a"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn29 == true then 
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_dragon", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn29 == true then 
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_granite_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn29 == true then 
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_big_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn29 == true then 
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_shaman", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps30 ()
        return repeat_interval
        
    end)

function junglecamps30()
  local i = RandomInt(1, 4)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle2a"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn30 == true then 
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_dragon", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn30 == true then 
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_granite_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn30 == true then 
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_big_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn30 == true then 
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_shaman", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps31 ()
        return repeat_interval
        
    end)

function junglecamps31()
  local i = RandomInt(1, 4)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle3a"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn31 == true then 
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_dragon", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn31 == true then 
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_granite_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn31 == true then 
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_big_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn31 == true then 
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_shaman", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end

local start_after = 0 -- Start this timer *start_after* game-time seconds later
    local repeat_interval = 60
    print ("Timer 2 is running")
    Timers:CreateTimer(start_after, function()
        junglecamps32 ()
        return repeat_interval
        
    end)

function junglecamps32()
  local i = RandomInt(1, 4)
  print(tostring(i))
  local point = Entities:FindByName( nil, "jungle4a"):GetAbsOrigin()
print(tostring(_G.canspawn3))
  if i == 1 and _G.canspawn32 == true then 
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_drake", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_black_dragon", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 2 and _G.canspawn32 == true then 
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_rock_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_granite_golem", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 3 and _G.canspawn32 == true then 
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_small_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_big_thunder_lizard", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end
  if i == 4 and _G.canspawn32 == true then 
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_acolyte", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
        CreateUnitByName("npc_dota_neutral_prowler_shaman", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

end
]]
end






-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function Trialsofretribution:InitTrialsofretribution()
  Trialsofretribution = self
  DebugPrint('[TRIALSOFRETRIBUTION] Starting to load Trialsofretribution trialsofretribution...')

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(Trialsofretribution, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[TRIALSOFRETRIBUTION] Done loading Trialsofretribution trialsofretribution!\n\n')
end

-- This is an example console command
function Trialsofretribution:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end

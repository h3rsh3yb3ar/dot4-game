--- This file contains all trialsofretribution-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function Trialsofretribution:OnDisconnect(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)


  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid
  local plyID = keys.PlayerID
  local team = plyID:GetTeamNumber()

  if team == 6 then
    _G.reconnect1 = 0
     local start_after = 300 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team1bonusgoldtimer()
        
    end)


  end

    if team == 7 then
      _G.reconnect2 = 0
     local start_after = 300 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team2bonusgoldtimer()
        
    end)


  end

    if team == 8 then
      _G.reconnect3 = 0
     local start_after = 300 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team3bonusgoldtimer()
        
    end)


  end

    if team == 9 then
      _G.reconnect4 = 0
     local start_after = 300 -- Start this timer *start_after* game-time seconds later
    print ("Timer is running")
  EmitAnnouncerSound("announcer_announcer_welcome_07")
    Timers:CreateTimer(start_after, function()
        team4bonusgoldtimer()
        
    end)


  end


  
end

function team1bonusgoldtimer()
    Timers:CreateTimer(start_after, function()
        team1bonusgolddisconnect()
        
    end)
end

function team1bonusgoldtimer()
    Timers:CreateTimer(start_after, function()
        team2bonusgolddisconnect()
        
    end)
end

function team1bonusgoldtimer()
    Timers:CreateTimer(start_after, function()
        team3bonusgolddisconnect()
        
    end)
end

function team1bonusgoldtimer()
    Timers:CreateTimer(start_after, function()
        team4bonusgolddisconnect()
        
    end)
end

function team1bonusgolddisconnect()
  if _G.reconnect1 == 0 then
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
end
function team2bonusgolddisconnect()
  if _G.reconnect2 == 0 then
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
end
function team3bonusgolddisconnect()
if _G.reconnect3 == 0 then
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
end
function team4bonusgolddisconnect()
  if _G.reconnect4 == 0 then
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
end
-- The overall game state has changed
function Trialsofretribution:OnGameRulesStateChange(keys)
  if Trialsofretribution._reentrantCheck then
    return
  end

  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    self.bSeenWaitForPlayers = true
  elseif newState == DOTA_GAMERULES_STATE_INIT then
    --Timers:RemoveTimer("alljointimer")
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    

    Trialsofretribution:PostLoadPrecache()
    Trialsofretribution:OnAllPlayersLoaded()

    if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
      for i=0,9 do
        if PlayerResource:IsValidPlayer(i) then
          local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
          PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
        end
      end
    end
    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
     
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

    Trialsofretribution:OnGameInProgress()
  end

  Trialsofretribution._reentrantCheck = true
  Trialsofretribution:OnGameRulesStateChange(keys)
  Trialsofretribution._reentrantCheck = false
end

-- An NPC has spawned somewhere in game.  This includes heroes
function Trialsofretribution:OnNPCSpawned(keys)
  DebugPrint("[TRIALSOFRETRIBUTION] NPC Spawned")
  DebugPrintTable(keys)

  local npc = EntIndexToHScript(keys.entindex)


end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function Trialsofretribution:OnEntityHurt(keys)
  --DebugPrint("[TRIALSOFRETRIBUTION] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function Trialsofretribution:OnItemPickedUp(keys)
  DebugPrint( '[TRIALSOFRETRIBUTION] OnItemPickedUp' )
  DebugPrintTable(keys)

  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end

  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end
function Trialsofretribution:OnAllPlayersLoaded()
     CustomUI:DynamicHud_SetVisible(-1, "loading screen", false)
   end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function Trialsofretribution:OnPlayerReconnect(keys)
  DebugPrint( '[TRIALSOFRETRIBUTION] OnPlayerReconnect' )
  DebugPrintTable(keys) 
   local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid
  local plyID = keys.PlayerID
  local team = plyID:GetTeamNumber()

  if team == 6 then
_G.reconnect1 = 1
  end
    if team == 7 then
_G.reconnect2 = 1
  end
    if team == 8 then
_G.reconnect3 = 1
  end
    if team == 9 then
_G.reconnect4 = 1
  end
end

-- An item was purchased by a player
function Trialsofretribution:OnItemPurchased( keys )
  DebugPrint( '[TRIALSOFRETRIBUTION] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function Trialsofretribution:OnAbilityUsed(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function Trialsofretribution:OnNonPlayerUsedAbility(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function Trialsofretribution:OnPlayerChangedName(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function Trialsofretribution:OnPlayerLearnedAbility( keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function Trialsofretribution:OnAbilityChannelFinished(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function Trialsofretribution:OnPlayerLevelUp(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerLevelUp')
  DebugPrintTable(keys)



end

-- A player last hit a creep, a tower, or a hero
function Trialsofretribution:OnLastHit(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  if(isFirstBlood)then EmitAnnouncerSound ("announcer_killing_spree_announcer_1stblood_01")end
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function Trialsofretribution:OnTreeCut(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function Trialsofretribution:OnRuneActivated (keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function Trialsofretribution:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function Trialsofretribution:OnPlayerPickHero(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function Trialsofretribution:OnTeamKillCredit(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end


-- An entity died
function Trialsofretribution:_OnEntityKilled( keys )
  DebugPrint( '[TRIALSOFRETRIBUTION] OnEntityKilled Called' )
  DebugPrintTable( keys )

  -- The Unit that was Killed
      local killedUnit = EntIndexToHScript( keys.entindex_killed )
          local killer = EntIndexToHScript( keys.entindex_attacker )
          local unit_killed = killedUnit:GetName()
          if(unit_killed == "npc_dota_roshan") then 
          	 Trialsofretribution:OnRoshanKilled ( keys )
          	end
            if killedUnit:GetName() == "radianttopmelee" then
            _G.radtopmelee = 0
           end
            if killedUnit:GetName() == "radianttoprange" then
            _G.radtoprange = 0
           end
           if killedUnit:GetName() == "diremidmelee" then
            _G.diremidmelee = 0
           end
           if killedUnit:GetName() == "diremidrange" then
            _G.diremidrange = 0
           end
            if killedUnit:GetName() == "direbotmelee" then
            _G.direbotmelee = 0
           end
            if killedUnit:GetName() == "direbotrange" then
            _G.direbotrange = 0
           end
            if killedUnit:GetName() == "snowtopmelee" then
            _G.snowtopmelee = 0
           end
            if killedUnit:GetName() == "snowtoprange" then
            _G.snowtoprange = 0
           end
            if killedUnit:GetName() == "midsnowmelee" then
            _G.midsnowmelee = 0
           end
            if killedUnit:GetName() == "midsnowrange" then
            _G.midsnowrange = 0
           end
            if killedUnit:GetName() == "fallbotmelee" then
            _G.fallbotmelee = 0
           end
            if killedUnit:GetName() == "fallbotrange" then
            _G.fallbotrange = 0
           end
           if killedUnit:GetName() == "radiantmidmelee" then
            _G.radiantmidmelee = 0
          end
           if killedUnit:GetName() == "radiantmidrange" then
          _G._G.radiantmidrange = 0
          end
          if killedUnit:GetName() == "diretopmelee" then
          _G.diretopmelee = 0
          end
          if killedUnit:GetName() == "diretoprange" then
          _G.diretoprange = 0
          end
          if killedUnit:GetName() == "radiantbotmelee" then
          _G.radiantbotmelee = 0
          end
          if killedUnit:GetName() == "radiantbotrange" then
          _G.radiantbotrange = 0
          end
          if killedUnit:GetName() == "fallmidmelee" then
          _G._G.fallmidmelee = 0
          end
          if killedUnit:GetName() == "fallmidrange" then
          _G.fallmidrange = 0
          end
          if killedUnit:GetName() == "falltopmelee" then
          _G.falltopmelee = 0
          end
          if killedUnit:GetName() == "falltoprange" then
          _G.falltoprange = 0
          end          if killedUnit:GetName() == "snowbotrange" then
          _G.snowbotrange = 0
          end
          if killedUnit:GetName() == "snowbotmelee" then
          _G.snowbotmelee = 0
          end
          
          
          

       local killedUnit = EntIndexToHScript( keys.entindex_killed )
          local killer = EntIndexToHScript( keys.entindex_attacker )
          local unit_killed = killedUnit:GetName()
          if(unit_killed == "npc_dota_courier") then 
          	 Trialsofretribution:OnCourierKilled ( keys )
          	end


  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if killedUnit:IsFort() then
    --TODO: Uncomment this when bugfixing OnFortKilled
    Trialsofretribution:OnFortKilled( keys )
  end
  
  if killedUnit:IsBuilding() then
	  Trialsofretribution:OnCustomTowerKilled( keys )
	else
  end

  if killedUnit:IsCreature() then
  	Trialsofretribution:OnCreatureKilled( keys )
  else
  end
end

function Trialsofretribution:OnCourierKilled ( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killedTeam = killedUnit:GetTeamNumber()
	print(killedUnit:GetTeamNumber())
		if(killedTeam == 6) then EmitAnnouncerSound("announcer_ann_custom_courier_slain_06")end
		if(killedTeam == 7) then EmitAnnouncerSound("announcer_ann_custom_courier_slain_02")end
		if(killedTeam == 8) then EmitAnnouncerSound("announcer_ann_custom_courier_slain_10")end
		if(killedTeam == 9) then EmitAnnouncerSound("announcer_ann_custom_courier_slain_13")end 

end

function Trialsofretribution:OnRoshanKilled ( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killer = EntIndexToHScript( keys.entindex_attacker )
	local killing_team = killer:GetTeamNumber()
	if(killing_team == 6) then EmitAnnouncerSound("announcer_ann_custom_roshan_fall_06")end
	if(killing_team == 7) then EmitAnnouncerSound("announcer_ann_custom_roshan_fall_02")end
	if(killing_team == 8) then EmitAnnouncerSound("announcer_ann_custom_roshan_fall_10")end
	if(killing_team == 9) then EmitAnnouncerSound("announcer_ann_custom_roshan_fall_13")end
end

function Trialsofretribution:OnCreatureKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local creature_name = killedUnit:GetName()
	print(killedUnit:GetName())
		if(creature_name == "npc_dota_creature") then EmitAnnouncerSound("announcer_announcer_beast_slain_01")
	print("unit is norva")
else
	end
end


function Trialsofretribution:OnCustomTowerKilled( keys )
    local killer = EntIndexToHScript( keys.entindex_attacker )
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
   local killedunitteam = killedUnit:GetTeam()
    --For reference, the teams are mapped as follows
    --Team 6 = Tempest
    --Team 7  = Altair
    --Team 8 = Radiant
    --Team 9 = Dire
   
    local tower_name = killedUnit:GetName()
    --Make sure what we're looking at has a name
    if tower_name == nil then
        return
    end
   if killer:GetTeam() ~= killedunitteam then
    if(tower_name == "radiantbot1" or tower_name == "radiantbot2" or tower_name == "radiantbot3" or tower_name == "radiantmid1" or tower_name == "radiantmid2" or tower_name == "radiantmid3" or tower_name == "radianttop1" or tower_name == "radianttop2" or tower_name == "radianttop3" or tower_name == "radiantmid4" or tower_name == "radiantmid4") then
EmitAnnouncerSound("announcer_ann_custom_tower_fall_10") end end

---------------------------------------------------- Radiant Tower Text Alerts -----------------------------------------------------------------------------------------------------------------
    if tower_name == "radiantbot1" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Top Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantbot2" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 2 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantbot3" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 3 Top tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantmid1" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantmid2" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 2 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantmid3" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 3 Middle Tower </font> Has Fallen!", 0, 0)
    end
      if tower_name == "radianttop1" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Bottom Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "radianttop2" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 2 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "radianttop3" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 3 Bottom tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "radiantmid4" then
       GameRules:SendCustomMessage("<font color='#008000'>Green's Tier 4 tower</font> Has Fallen!", 0, 0)
    end
if killer:GetTeam() ~= killedunitteam then
    if(tower_name == "direbot1" or tower_name == "direbot2" or tower_name == "direbot3" or tower_name == "diremid1" or tower_name == "diremid2" or tower_name == "diremid3" or tower_name == "diretop1" or tower_name == "diretop2" or tower_name == "diretop3" or tower_name == "diretop4" or tower_name == "direbot4") then
EmitAnnouncerSound("announcer_ann_custom_tower_fall_06")end end
---------------------------------------------------- Dire Tower Text Alerts ----------------------------------------------------------------------------------------------------------------------

    if tower_name == "direbot1" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Bottom Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "direbot2" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 2 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "direbot3" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 3 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "diremid1" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "diremid2" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 2 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "diremid3" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 3 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "diretop1" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Top Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "diretop2" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 2 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "diretop3" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 3 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "diremid4" then
       GameRules:SendCustomMessage("<font color='#87ceeb'>Blue's Tier 4 Tower</font> Has Fallen!", 0, 0)
    end
----



----------------------------------------------Red Tower Text Alerts------------------------------------------------------------------------------------------------------------------------------
if killer:GetTeam() ~= killedunitteam then
	  if(tower_name == "fallbot1" or tower_name == "fallbot2" or tower_name == "fallbot3" or tower_name == "fallmid1" or tower_name == "fallmid2" or tower_name == "fallmid3" or tower_name == "falltop1" or tower_name == "falltop2" or tower_name == "falltop3" or tower_name == "falltop4" or tower_name == "fallbot4") then
EmitAnnouncerSound("announcer_ann_custom_tower_fall_02")end end

    if tower_name == "snowbot1" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Top Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowbot2" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 2 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowbot3" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 3 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowmid1" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowmid2" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 2 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowmid3" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 3 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowtop1" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Bottom Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowtop2" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 2 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowtop3" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 3 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "snowmid4" then
       GameRules:SendCustomMessage("<font color='#ff0000'>Red's Tier 4 Tower</font> Has Fallen!", 0, 0)
    end

	      if(tower_name == "snowbot1" or tower_name == "snowbot2" or tower_name == "snowbot3" or tower_name == "snowmid1" or tower_name == "snowmid2" or tower_name == "snowmid3" or tower_name == "snowtop1" or tower_name == "snowtop2" or tower_name == "snowtop3" or tower_name == "snowtop4" or tower_name == "snowbot4") then
 if killer:GetTeam() ~= killedunitteam then
EmitAnnouncerSound("announcer_ann_custom_tower_fall_13")end end
---------------------------------------------Yellow Tower Text Alerts---------------------------------------------------------------------------------------------------------------------------------------------
 
     if tower_name == "fallbot1" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Bottom Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallbot2" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 2 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallbot3" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 3 Bottom Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallmid1" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallmid2" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 2 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallmid3" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 3 Middle Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "falltop1" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Top Tower </font> Has Fallen!", 0, 0)
    end
    if tower_name == "falltop2" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 2 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "falltop3" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 3 Top Tower</font> Has Fallen!", 0, 0)
    end
    if tower_name == "fallmid4" then
       GameRules:SendCustomMessage("<font color='#FFFF00'>Yellow's Tier 4 Tower</font> Has Fallen!", 0, 0)
    end
    local tower_num = tonumber(tower_name:sub(string.len(tower_name),string.len(tower_name)))
   
    --Make sure what we're looking at is a tower.
    --Only towers will be a npc_dota_building with a name ending in a number
    if not tower_num then
        return
    end
	
	local tower_num = tonumber(tower_name:sub(string.len(tower_name),string.len(tower_name)))
	
	--Make sure what we're looking at is a tower. 
	--Only towers will be a npc_dota_building with a name ending in a number
	if not tower_num then
		return
	end
	
	local tower_gold = 120 + tower_num * 40 -- The tower gold is 120 base gold + 40 x the tower tier (ex: Tier 1 = 160, Tier 2 = 200)
	local deny_gold = tower_gold * 0.16
	
	--Check to see if the tower was denied
	if killer:GetTeam() == killedUnit:GetTeam() then
     if(tower_name == "radiantbot1" or tower_name == "radiantbot2" or tower_name == "radiantbot3" or tower_name == "radiantmid1" or tower_name == "radiantmid2" or tower_name == "radiantmid3" or tower_name == "radianttop1" or tower_name == "radianttop2" or tower_name == "radianttop3" or tower_name == "radianttop4" or tower_name == "radiantbot4") then
 
EmitAnnouncerSound("announcer_ann_custom_tower_deny_10") end
 
    if(tower_name == "direbot1" or tower_name == "direbot2" or tower_name == "direbot3" or tower_name == "diremid1" or tower_name == "diremid2" or tower_name == "diremid3" or tower_name == "diretop1" or tower_name == "diretop2" or tower_name == "diretop3" or tower_name == "diretop4" or tower_name == "direbot4") then
 
EmitAnnouncerSound("announcer_ann_custom_tower_deny_06")end
 
    if(tower_name == "fallbot1" or tower_name == "fallbot2" or tower_name == "fallbot3" or tower_name == "fallmid1" or tower_name == "fallmid2" or tower_name == "fallmid3" or tower_name == "falltop1" or tower_name == "falltop2" or tower_name == "falltop3" or tower_name == "falltop4" or tower_name == "fallbot4") then
 
EmitAnnouncerSound("announcer_ann_custom_tower_deny_02")end
 
    if(tower_name == "snowbot1" or tower_name == "snowbot2" or tower_name == "snowbot3" or tower_name == "snowmid1" or tower_name == "snowmid2" or tower_name == "snowmid3" or tower_name == "snowtop1" or tower_name == "snowtop2" or tower_name == "snowtop3" or tower_name == "snowtop4" or tower_name == "snowbot4") then
 
EmitAnnouncerSound("announcer_ann_custom_tower_deny_13")end
 
		--Loop through each of the four teams
		for i=6,9,1 do
			--Confirm that team getting gold is not the tower owner's team
			if i~=killer:GetTeam() then
				--Give 1/6th of the normal tower gold to each player on that team
				for j=1,5,1 do
					local current_player = PlayerResource:GetNthPlayerIDOnTeam(i, j)
					if current_player ~= nil then
						PlayerResource:ModifyGold(current_player,deny_gold, true, DOTA_ModifyGold_Building)
					end
				end
			end
		end
	else
		--Give each player from the killing team the tower_gold
		for i=1,5,1 do
			local current_player = PlayerResource:GetNthPlayerIDOnTeam(killer:GetTeam(), i)
			if current_player ~= nil then
				PlayerResource:ModifyGold(current_player,tower_gold, true, DOTA_ModifyGold_Building)
			end
		end
	end
end

function Trialsofretribution:OnFortKilled( keys )

  local deadAncient = EntIndexToHScript(keys.entindex_killed )
  local killedTeamNumber = deadAncient:GetTeamNumber()
  _G.fortsalive = _G.fortsalive - 1
if(killedTeamNumber == 6 and _G.fortsalive ~= 1) then EmitAnnouncerSound("announcer_ann_custom_defeated_13")end -- red

if KilledTeamNumber == 6 then
  GameRules:SendCustomMessage("<font color='#008000'>  Green Has been </font> <font color='#FF0000'>Eliminated!</font>", 0, 0) end
 
  if(killedTeamNumber == 7 and _G.fortsalive ~= 1) then EmitAnnouncerSound("announcer_ann_custom_defeated_02")end -- yellow

if KilledTeamNumber == 7 then
   GameRules:SendCustomMessage("<font color='#FFFF00'> Yellow </font> Has Been <font color='#FF0000'>Eliminated!</font>", 0, 0) end
 
  if(killedTeamNumber == 8 and _G.fortsalive ~= 1) then EmitAnnouncerSound("announcer_ann_custom_defeated_10")end -- Green
 
  if(killedTeamNumber == 9 and _G.fortsalive ~= 1) then EmitAnnouncerSound("announcer_ann_custom_defeated_06")end -- Blue
 
local fow = Entities:FindByName( nil, "mid"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "radiant"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "dire"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "altiar"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "tempest"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "greenred"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "redblue"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    local fow = Entities:FindByName( nil, "bluegrey"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
        local fow = Entities:FindByName( nil, "greygreen"):GetAbsOrigin()
    AddFOWViewer(killedTeamNumber, fow, 9999999, 999999999, false)
    
      local heroes = HeroList:GetAllHeroes()
      for number,entity in pairs(heroes) do
      if(entity:GetTeam() == killedTeamNumber) then
        entity:SetRespawnsDisabled(true)
        entity:ForceKill(false)
      end
      if (entity:IsAlive() == false) then
      entity:SetBuybackCooldownTime(999999)
      entity:SetTimeUntilRespawn(99999) 
      end
    end

    if _G.fortsalive == 1 then
      _G.deadteam = killedTeamNumber
      Trialsofretribution:endgame(keys)

    end

  end


function Trialsofretribution:endgame(keys)
local heroes = HeroList:GetAllHeroes()
for number,entity in pairs(heroes) do
local winner = entity:GetTeam()
if winner ~= _G.deadteam then
  if winner == 6 then
  GameRules:SetCustomVictoryMessage( "Red Team Victory!" )
  EmitAnnouncerSound ("announcer_ann_custom_victory_13")
end
  if winner == 7 then
  GameRules:SetCustomVictoryMessage( "Yellow Team Victory!" )
  EmitAnnouncerSound ("announcer_ann_custom_victory_02")
end
  if winner == 8 then
  GameRules:SetCustomVictoryMessage( "Green Team Victory!" )
  EmitAnnouncerSound ("announcer_ann_custom_victory_10")
end
  if winner == 9 then
  GameRules:SetCustomVictoryMessage( "Blue Team Victory!" )
  EmitAnnouncerSound ("announcer_ann_custom_victory_06")
end
GameRules:SetGameWinner(winner)
GameRules:SetSafeToLeave(true)
    end
  end
end

function isAncient(entity)
  local name = entity:GetName()
  return name == "tempestancient" or name == "kanikancient" or name == "radiantancient" or name == "direancient"
end


function kill(entity)
  entity:Kill()
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function Trialsofretribution:PlayerConnect(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function Trialsofretribution:OnConnectFull(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnConnectFull')
  DebugPrintTable(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)

  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
    
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function Trialsofretribution:OnIllusionsCreated(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function Trialsofretribution:OnItemCombined(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function Trialsofretribution:OnAbilityCastBegins(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function Trialsofretribution:OnTowerKill(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function Trialsofretribution:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function Trialsofretribution:OnNPCGoalReached(keys)
  DebugPrint('[TRIALSOFRETRIBUTION] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function Trialsofretribution:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  --TODO: Fix, This line was throwing a null value error so I commented it out for now
  --local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end

function printTable(t)

  function printTableHelper(t, spacing)
    for k,v in pairs(t) do
      print(spacing..tostring(k), v)
      if (type(v) == "table") then
        printTableHelper(v, spacing.."\t")
      end
    end
  end

  printTableHelper(t, "");
end
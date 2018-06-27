--[[ ArenaLive Spectator Functions: Main Target Indicator
Created by: Vadrak
Creation Date: 25.10.2014
Last Update: 16.12.2014
This Handler tries to find out which player of the team is the current main target of the opposing team.
]]--

-- Addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for all important events:
local MainTargetIndicator = ArenaLive:ConstructHandler("MainTargetIndicator", true, true);
MainTargetIndicator:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");
MainTargetIndicator:RegisterEvent("PLAYER_ENTERING_WORLD");

local MAIN_TARGET_LEFT, MAIN_TARGET_RIGHT;
local NUM_PLAYERS_LEFT, NUM_PLAYERS_RIGHT = 0, 0;
local playerTargets = {};

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function MainTargetIndicator:Update(unitFrame)
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	
	if ( not unit ) then
		indicator:Hide();
		return;
	end
	
	local guid = unitFrame.guid;
	local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
	
	-- Get correct main target according to unit type: 
	local mainTarget;
	if ( unitType == "raid" ) then
		mainTarget = MAIN_TARGET_RIGHT;
	elseif ( unitType == "arena" ) then
		mainTarget = MAIN_TARGET_LEFT;
	end
	
	if ( mainTarget and mainTarget == guid ) then
		indicator:Show();
	else
		indicator:Hide();
	end
end

function MainTargetIndicator:Reset(unitFrame)
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	indicator:Hide();
end

function MainTargetIndicator:UpdateNumPlayers()
	-- For some reason 2 is team A and 1 is team B...
	NUM_PLAYERS_LEFT = ArenaLiveSpectator:GetNumPlayersInTeam("raid");
	NUM_PLAYERS_RIGHT = ArenaLiveSpectator:GetNumPlayersInTeam("arena");
	
	local unit;
	for i = 1, 5 do
		unit = "raid"..i;
		if ( i <= NUM_PLAYERS_LEFT ) then
			playerTargets[unit] = false;
		else
			playerTargets[unit] = nil;
		end
		
		unit = "arena"..i;
		if ( i <= NUM_PLAYERS_RIGHT ) then
			playerTargets[unit] = false;
		else
			playerTargets[unit] = nil;
		end
	end
	
	if ( NUM_PLAYERS_LEFT > 0 or NUM_PLAYERS_RIGHT > 0 ) then
		self:Show();
	else
		self:Hide();
	end
end

local tempTargetInfo = {};
function MainTargetIndicator:UpdateMainTarget(team)
	local numPlayers, numTargets, playerUnitMod, targetUnitMod;
	if ( team == 1 ) then
		playerUnitMod = "raid";
		targetUnitMod = "arena";
		numPlayers = NUM_PLAYERS_LEFT;
		numTargets = NUM_PLAYERS_RIGHT;
	elseif ( team == 2 ) then
		playerUnitMod = "arena";
		targetUnitMod = "raid";
		numPlayers = NUM_PLAYERS_RIGHT;
		numTargets = NUM_PLAYERS_LEFT;
	else
		ArenaLive:Message(L["MainTargetIndicator:UpdateMainTarget(): Usage MainTargetIndicator:UpdateMainTarget(team)"], "error");
	end
	
	-- There is no main target, if number of players or numer of targets is zero.
	if ( numPlayers == 0 or numTargets == 0 ) then
		if ( team == 1 ) then
			MAIN_TARGET_LEFT = nil;
		elseif ( team == 2 ) then
			MAIN_TARGET_LEFT = nil;
		end
		return;
	end
	
	-- Reset old temp targeting info:
	table.wipe(tempTargetInfo);
	local unit, guid, health, healthMax, health, healthPercent;
	for i = 1, numTargets do
		-- Gather target data:
		unit = targetUnitMod..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			if ( not tempTargetInfo[guid] ) then
				health = UnitHealth(unit);
				healthMax = UnitHealthMax(unit);
				if ( healthMax == 0 ) then
					healthMax = 1; -- Prevent division by zero.
				end
				
				healthPercent = health / healthMax;
				
				tempTargetInfo[guid] = {
					["healthPercent"] = healthPercent,
					["targetedBy"] = 0,
				};
			end
		end
	end
	
	-- Now gather targeting data:
	for i = 1, numPlayers do
		unit = playerUnitMod..i;
		guid = playerTargets[unit];
		if ( guid and tempTargetInfo[guid] ) then
			tempTargetInfo[guid].targetedBy = tempTargetInfo[guid].targetedBy + 1;
		end		
	end

	-- Detect main target. A main target must be
	-- targeted by more than 50% of the opposing team
	-- or must be below 25% health and have the lowest
	-- health of the whole team.
	local targetRatio, tempMainTarget;
	for guid, infoTable in pairs(tempTargetInfo) do
		targetRatio = infoTable.targetedBy / numPlayers;
		infoTable["targetRatio"] = targetRatio;
		
		if ( targetRatio > 0.5 ) then
			tempMainTarget = guid;
		elseif ( infoTable["healthPercent"] < 0.25 and infoTable["healthPercent"] > 0 ) then
			if ( not tempMainTarget 
			or ( targetRatio >= tempTargetInfo[tempMainTarget]["targetRatio"]
			and infoTable["healthPercent"] < tempTargetInfo[tempMainTarget]["targetRatio"] ) ) then
				tempMainTarget = guid;
			end
		end
	end
	
	if ( team == 1 ) then
		MAIN_TARGET_LEFT = tempMainTarget;
		MainTargetIndicator:CallUpdateForUnitType(targetUnitMod);
	elseif ( team == 2 ) then
		MAIN_TARGET_RIGHT = tempMainTarget;
		MainTargetIndicator:CallUpdateForUnitType(targetUnitMod);
	end
end

function MainTargetIndicator:CallUpdateForUnitType(unitType)
	if ( not unitType ) then
		return;
	end
	
	for i = 1, 5 do
		local unit = unitType..i;
		if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
			for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
				local unitFrame = ArenaLive:GetUnitFrameByID(id);
				if ( unitFrame.enabled and unitFrame[self.name] ) then
					MainTargetIndicator:Update(unitFrame);
				end
			end
		end
	end
end

function MainTargetIndicator:OnEvent(event, ...)
	if ( event == "COMMENTATOR_PLAYER_UPDATE" ) then
		self:UpdateNumPlayers();
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		self:UpdateNumPlayers();
	elseif ( event == "UNIT_TARGET" ) then
		local unit = ...;
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		if ( unitType == "raid" ) then
			MainTargetIndicator:UpdateMainTarget(1);
		elseif ( unitType == "arena" ) then
			MainTargetIndicator:UpdateMainTarget(2);
		end
	end
end

local THROTTLE_INTERVAL = 0.5;
local elapsedUntilNow = 0;
function MainTargetIndicator:OnUpdate(elapsed)
	elapsedUntilNow = elapsedUntilNow + elapsed;
	
	if ( elapsedUntilNow >= THROTTLE_INTERVAL ) then
		elapsedUntilNow =  0;
		
		for unit, targetGUID in pairs(playerTargets) do
			local guid = UnitGUID(unit.."target") or false;
			if ( guid ~= targetGUID ) then
				playerTargets[unit] = guid;
				-- Fake UNIT_TARGET event, as currently UNIT_TARGET doesn't fire for spectated units:
				self:OnEvent("UNIT_TARGET", unit);
			end
		end		
	end
end

MainTargetIndicator:SetScript("OnUpdate", MainTargetIndicator.OnUpdate);
--[[ ArenaLive Spectator Functions: Cooldown Tracker
Created by: Vadrak
Creation Date: 11.08.2014
Last Update: 12.12.2014
]]--

-- Addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
local CooldownTracker = ArenaLive:ConstructHandler("CooldownTracker", true, true);
local Cooldown = ArenaLive:GetHandler("Cooldown");
local NameText = ArenaLive:GetHandler("NameText");

local CooldownTrackerClass = {};
local trashTable = {};
local trackers = {};
local trackedUnits = {};
local inspectQueue = {};
local activeCooldowns = {};
local UNIT_WAITING_FOR_INSPECT_EVENT;
local NUM_GLPYH_SLOTS = 6;
local MAX_TALENT_TIERS = 6;
local NUM_TALENT_COLUMNS = 3;

CooldownTracker:RegisterEvent("PLAYER_ENTERING_WORLD");
CooldownTracker:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");
CooldownTracker:RegisterEvent("INSPECT_READY");
-- CooldownTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
CooldownTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_CAST_SUCCESS");
--CooldownTracker:RegisterEvent("UNIT_NAME_UPDATE");
CooldownTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL");
function ArenaLiveSpectator:GetTrackedUnits()
	for unit, cdTable in pairs(trackedUnits) do
		print(unit, cdTable['#']);
	end
end

local function newTable()
	local numTables = #trashTable or 0;
	local new;
	if ( numTables > 0 ) then
		new = table.remove(trashTable, numTables);
	else
		new = {};
	end
	
	return new;
end

local function dumpTable(dump)
	if ( type(dump) ~= "table" ) then
		return;
	end
	
	table.wipe(dump);
	table.insert(trashTable, dump);
end

local sortUnit;
local function sortFunc(a, b)
	local aType, bType = ArenaLiveSpectator.SpellDB.CooldownTypes[a], ArenaLiveSpectator.SpellDB.CooldownTypes[b];
	if ( not aType ) then
		return false;
	elseif ( not bType ) then
		return true;
	else
		if ( aType == bType ) then
			return trackedUnits[sortUnit]["cooldowns"][a]["duration"] > trackedUnits[sortUnit]["cooldowns"][b]["duration"];
		else
			return ArenaLiveSpectator.SpellDB.CooldownTypePriorities[aType] > ArenaLiveSpectator.SpellDB.CooldownTypePriorities[bType];
		end
	end
end

local function OnEnter(self)
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	if ( database.ShowTooltip and self.spellID ) then
		ArenaLiveSpectatorTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		ArenaLiveSpectatorTooltip:SetSpellByID(self.spellID);
	end
end

local function OnLeave(self)
	ArenaLiveSpectatorTooltip:Hide();
end

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function CooldownTracker:ConstructObject(cooldownTracker, nameText, classIcon, addonName, frameGroup, template)
	cooldownTracker.nameText = nameText;
	cooldownTracker.classIcon = classIcon;
	
	cooldownTracker.addon = addonName;
	cooldownTracker.group = frameGroup;
	cooldownTracker.template = template;
	cooldownTracker.numIcons = 0;
	cooldownTracker.shownCooldowns = {};
	ArenaLive:CopyClassMethods(CooldownTrackerClass, cooldownTracker);
	
	cooldownTracker:Enable();
end

function CooldownTracker:ConstructIcon(cooldownTracker)
	local prefix = cooldownTracker:GetName();
	local numIcons = cooldownTracker.numIcons;
	local icon = CreateFrame("Button", prefix.."Icon"..numIcons+1, cooldownTracker, cooldownTracker.template);
	
	cooldownTracker["icon"..numIcons+1] = icon;
	cooldownTracker.numIcons = cooldownTracker.numIcons + 1;
	
	Cooldown:ConstructObject(icon.cooldown, cooldownTracker.addon, nil, nil, 10);
	
	icon:SetScript("OnEnter", OnEnter);
	icon:SetScript("OnLeave", OnLeave);
	
	return icon;
end

function CooldownTracker:GetNewOffset(cooldownTracker, width, height, xOffset, yOffset)
	local database = ArenaLive:GetDBComponent(cooldownTracker.addon, self.name, cooldownTracker.group);
	local space = database.Space;
	if ( database.GrowingDirection == "UP" ) then
		yOffset = yOffset + height + space;
	elseif ( database.GrowingDirection == "RIGHT" ) then
		xOffset = xOffset + width + space;
	elseif ( database.GrowingDirection == "DOWN" ) then
		yOffset = yOffset - height - space;
	elseif ( database.GrowingDirection == "LEFT" ) then
		xOffset = xOffset - width - space;
	end

	return xOffset, yOffset;
end

function CooldownTracker:UpdateTrackersByUnit(unit)
	for tracker in pairs(trackers) do
		if ( unit == tracker.unit ) then
			tracker:Update();
		end
	end
end

function CooldownTracker:UpdateTrackerShownIconsByUnit(unit)
	for tracker in pairs(trackers) do
		if ( unit == tracker.unit ) then
			tracker:UpdateShownCooldowns();
		end
	end
end

function CooldownTracker:RegisterUnit(unit)
	if ( not trackedUnits[unit] ) then
		trackedUnits[unit] = newTable();
		trackedUnits[unit]["cooldowns"] = newTable();
		trackedUnits[unit]["TRINKET"] = newTable();
		trackedUnits[unit]["RACIAL"] = newTable();
		trackedUnits[unit]["DEF_CD"] = newTable();
		trackedUnits[unit]["OFF_CD"] = newTable();
		trackedUnits[unit]["INTERRUPT"] = newTable();
		trackedUnits[unit]["DISPEL"] = newTable();
		trackedUnits[unit]["CC"] = newTable();
		trackedUnits[unit]["MISC"] = newTable();
		trackedUnits[unit]["spellIDToIndex"] = newTable();
		trackedUnits[unit]["#"] = 1;
		CooldownTracker:GatherCooldownInfo(unit, false);
	else
		trackedUnits[unit]["#"] = trackedUnits[unit]["#"] + 1;
	end
end

function CooldownTracker:UnregisterUnit(unit)
	if trackedUnits[self.unit] then local unit = self.unit end
	if ( trackedUnits[unit] ) then
		trackedUnits[unit]["#"] = trackedUnits[unit]["#"] - 1;
		
		if ( trackedUnits[unit]["#"] < 1 ) then
			CooldownTracker:ResetCooldownInfo(unit);
			dumpTable(trackedUnits[unit]["cooldowns"]);
			trackedUnits[unit]["cooldowns"] = nil;

			dumpTable(trackedUnits[unit]["TRINKET"]);
			trackedUnits[unit]["TRINKET"] = nil;
			
			dumpTable(trackedUnits[unit]["RACIAL"]);
			trackedUnits[unit]["RACIAL"] = nil;			
			
			dumpTable(trackedUnits[unit]["DEF_CD"]);
			trackedUnits[unit]["DEF_CD"] = nil;
			
			dumpTable(trackedUnits[unit]["OFF_CD"]);
			trackedUnits[unit]["OFF_CD"] = nil;
			
			dumpTable(trackedUnits[unit]["INTERRUPT"]);
			trackedUnits[unit]["INTERRUPT"] = nil;
			
			dumpTable(trackedUnits[unit]["DISPEL"]);
			trackedUnits[unit]["DISPEL"] = nil;
			
			dumpTable(trackedUnits[unit]["CC"]);
			trackedUnits[unit]["CC"] = nil;
			
			dumpTable(trackedUnits[unit]["MISC"]);
			trackedUnits[unit]["MISC"] = nil;
			
			dumpTable(trackedUnits[unit]["spellIDToIndex"]);
			trackedUnits[unit]["spellIDToIndex"] = nil;
		
			dumpTable(trackedUnits[unit]);
			trackedUnits[unit] = nil;
		end
	end
end

function CooldownTracker:GatherCooldownInfo(unit, isInspectReady)

	if ( not unit ) then
		ArenaLive:Message(L["CooldownTracker:GatherCooldownInfo(): Usage CooldownTracker:GatherCooldownInfo(unit, isInspectReady)"], "error");
	end
	
	local guid = UnitGUID(unit);
	local isPlayer = UnitIsPlayer(unit);
	ArenaLive:Message(L["Gather Cooldown info for %s: GUID = %s, isPlayer = %s, isInspectReady = %s."], "debug", unit, tostring(guid), tostring(isPlayer), tostring(isInspectReady));
	if ( guid and isPlayer and not isInspectReady ) then
		inspectQueue[unit] = guid;
		if ( not UNIT_WAITING_FOR_INSPECT_EVENT ) then
			CooldownTracker:CallInspect();
		end
	elseif ( guid and isPlayer and isInspectReady ) then
		-- Reset old information first:
		CooldownTracker:ResetCooldownInfo(unit);
		
		local _, class, classID = UnitClass(unit);
		local _, race = UnitRace(unit);
		local specID = GetInspectSpecialization(unit);
		trackedUnits[unit].specID = specID;
		
		-- Set trinket cooldown:
		local spellID, duration = unpack(ArenaLive.spellDB["Trinket"]);
		CooldownTracker:AddCooldown(unit, spellID, duration);
		
		-- Set racial cooldown:
		if ( ArenaLive.spellDB.Racials[race][class] ) then
			spellID, duration = unpack(ArenaLive.spellDB.Racials[race][class]);
		else
			spellID, duration = unpack(ArenaLive.spellDB.Racials[race]);
		end
		CooldownTracker:AddCooldown(unit, spellID, duration);
		
		-- Get class/spec cooldowns:
		for spellID, duration in pairs(ArenaLiveSpectator.SpellDB["CooldownClassSpecInfo"][class][specID]) do
			CooldownTracker:AddCooldown(unit, spellID, duration);
		end
		
		-- NOTE: Need to apply add and replace talents first,
		-- before starting with the modify cooldown and charges
		-- options. Otherwise it could happen that a cooldown 
		-- reduction for a spell added via talents or glyphs isn't
		-- applied correctly.
		local talentQueue = {};
		for id = 1, MAX_TALENT_TIERS * NUM_TALENT_COLUMNS do
			local talentID, _, _, _, selected = GetTalentInfo(id, 1, nil, unit, classID);
			if ( selected ) then
				local action, spellID, value, replaceID = ArenaLiveSpectator:GetCooldownInfo(class, "talent", talentID);
				if ( type(action) == "table" ) then
					for key, actionType in pairs(action) do
						if ( action == "ADD" or action == "REPLACE" ) then
							CooldownTracker:ExecuteCooldownInfo(unit, action[key], spellID[key], value[key], replaceID[key]);
						else
							talentQueue[talentID] = true;
						end
					end
				elseif ( action == "ADD" or action == "REPLACE" ) then
					CooldownTracker:ExecuteCooldownInfo(unit, action, spellID, value, replaceID);
				else
					talentQueue[talentID] = true;
				end
			end
		end
		--for i,_ in pairs(talentQueue)do print(i)end
		
		-- Apply modify talents:
		for talentID in pairs(talentQueue) do
			local action, spellID, value, replaceID = ArenaLiveSpectator:GetCooldownInfo(class, "talent", talentID);
			CooldownTracker:ExecuteCooldownInfo(unit, action, spellID, value, replaceID);
			talentQueue[talentID] = nil;
		end
		
		-- Apply glyphs:
		local glyphQueue = {};
		for slot = 1, NUM_GLPYH_SLOTS do
			local _, _, _, glyphSpellID = GetGlyphSocketInfo(slot, nil, true, unit);
			
			if ( glyphSpellID ) then
				local action, spellID, value, replaceID = ArenaLiveSpectator:GetCooldownInfo(class, "glyph", glyphSpellID);
				if ( type(action) == "table" ) then
					for key, actionType in pairs(action) do
						if ( action == "ADD" or action == "REPLACE" ) then
							CooldownTracker:ExecuteCooldownInfo(unit, action[key], spellID[key], value[key], replaceID[key]);
						else
							glyphQueue[glyphSpellID] = true;
						end
					end
				elseif ( action == "ADD" or action == "REPLACE" ) then
					CooldownTracker:ExecuteCooldownInfo(unit, action, spellID, value, replaceID);
				else
					glyphQueue[glyphSpellID] = true;
				end
			end
		end
		--for i,_ in pairs(glyphQueue)do print(i)end
		
		-- Apply modify glyphs:
		for glyphID in pairs(glyphQueue) do
			local action, spellID, value, replaceID = ArenaLiveSpectator:GetCooldownInfo(class, "glyph", glyphID);
			CooldownTracker:ExecuteCooldownInfo(unit, action, spellID, value, replaceID);
			glyphQueue[glyphID] = nil;
		end		

		-- Sort Cooldown type tables:
		sortUnit = unit;
		for cdType in pairs(ArenaLiveSpectator.SpellDB.CooldownTypePriorities) do
			local numCDs = #trackedUnits[unit][cdType];
			if ( numCDs > 1 ) then
				table.sort(trackedUnits[unit][cdType], sortFunc);
			
				-- Update spellIDToIndexTable:
				for i = 1, numCDs do
					local spellID = trackedUnits[unit][cdType][i];
					if spellID==nil then print('spellidtoindex: ',cdType,i)end
					trackedUnits[unit]["spellIDToIndex"][spellID] = i;
				end
			end
		end

		CooldownTracker:UpdateTrackerShownIconsByUnit(unit);
	else
		CooldownTracker:ResetCooldownInfo(unit);
	end
end

function CooldownTracker:ResetCooldownInfo(unit)
	-- Reset Cooldowns:
	for spellID, infoTable in pairs(trackedUnits[unit]["cooldowns"]) do
		local cdType = ArenaLiveSpectator.SpellDB.CooldownTypes[spellID];
		local index = trackedUnits[unit].spellIDToIndex[spellID];
		
		dumpTable(trackedUnits[unit].cooldowns[spellID]);
		trackedUnits[unit].cooldowns[spellID] = nil;
		trackedUnits[unit][cdType][index] = nil;
		trackedUnits[unit].spellIDToIndex[spellID] = nil;
	end
	
	CooldownTracker:UpdateTrackerShownIconsByUnit(unit);
end

function CooldownTracker:ExecuteCooldownInfo(unit, action, spellID, value, replaceID)
	
	if ( type(action) == "table" ) then
		-- Recursion if a talent/glyph applies more actions than one:
		-- NOTE: If this is the case, make sure that value is also a
		-- table with the keys being the same as the action's key.
		for key, actionType in pairs(action) do
			CooldownTracker:ExecuteCooldownInfo(unit, actionType, spellID[key], value[key], replaceID[key]);
		end
	elseif ( type(spellID) == "table" ) then -- More than one spellID
		-- Recursion if a talent/glyph changes more than one spell at a time:
		for key, realSpellID in ipairs(spellID) do
			CooldownTracker:ExecuteCooldownInfo(unit, action, realSpellID, value);
		end
	else
		if ( action == "ADD" ) then
			CooldownTracker:AddCooldown(unit, spellID, value);
		elseif ( action == "MODIFY_COOLDOWN" ) then
			CooldownTracker:ModifyCooldown(unit, spellID, value);
		elseif( action == "MODIFY_CHARGES" ) then
			CooldownTracker:ModifyCooldownCharges(unit, spellID, value);
		elseif ( action == "REPLACE" ) then
			CooldownTracker:RemoveCooldown(unit, replaceID);
			CooldownTracker:AddCooldown(unit, spellID, value);
		end
	end
	
end

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
	return unpack(spellcache[a])
end

-- DeadMouse, check this function
function CooldownTracker:AddCooldown(unit, spellID, duration)	
	local _, _, icon = GetSpellInfo(spellID);
	local faction = UnitFactionGroup(unit);

    if not icon then print("Нет иконки "..spellID); end

	-- Switch texture for pvp trinket:
	if ( spellID == 42292 ) then
		if ( faction == "Alliance" ) then
			icon = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_01";
		else
			icon = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_02";
		end	
	end
	
	local charges;
	if ( type(duration) == "table" ) then
		-- This spell has charges:
		charges = duration[2];
		duration = duration[1];
	else
		charges = 1;
	end	
	trackedUnits[unit]["cooldowns"][spellID] = newTable();
	trackedUnits[unit]["cooldowns"][spellID].duration = duration;
	trackedUnits[unit]["cooldowns"][spellID].totalCharges = charges;
	trackedUnits[unit]["cooldowns"][spellID].charges = charges;
	trackedUnits[unit]["cooldowns"][spellID].texture = icon;
	
	-- Add to CD type table:
	local cdType = ArenaLiveSpectator.SpellDB.CooldownTypes[spellID];
	if not cdType then print(spellID)end
	table.insert(trackedUnits[unit][cdType], spellID);
	trackedUnits[unit].spellIDToIndex[spellID] = #trackedUnits[unit][cdType];
end

function CooldownTracker:ModifyCooldown(unit, spellID, value)
	if ( trackedUnits[unit]["cooldowns"][spellID] ) then
		local newVal;
		local baseDuration = trackedUnits[unit]["cooldowns"][spellID]["duration"];
		if ( type(value) == "function" ) then
			-- Some values need a function to execute their spell changes.		
			newVal = value(baseDuration);
		else
			newVal = baseDuration + value;
		end		

		trackedUnits[unit]["cooldowns"][spellID]["duration"] = newVal;
	end
end

function CooldownTracker:ModifyCooldownCharges(unit, spellID, value)
	
	if ( trackedUnits[unit]["cooldowns"][spellID] ) then
		local charges = trackedUnits[unit]["cooldowns"][spellID]["totalCharges"];
		trackedUnits[unit]["cooldowns"][spellID]["totalCharges"] = charges + value;
		trackedUnits[unit]["cooldowns"][spellID]["charges"] = charges + value;
	end
end

function CooldownTracker:RemoveCooldown(unit, spellID)
	if ( trackedUnits[unit]["cooldowns"][spellID] ) then
		dumpTable(trackedUnits[unit]["cooldowns"][spellID]);
		trackedUnits[unit]["cooldowns"][spellID] = nil;
		
		-- Remove from CD type table:
		local cdType = ArenaLiveSpectator.SpellDB.CooldownTypes[spellID];
		local index = trackedUnits[unit].spellIDToIndex[spellID];
		trackedUnits[unit].spellIDToIndex[spellID] = nil;
		trackedUnits[unit][cdType][index] = nil;
	end
end

function CooldownTracker:StartCooldown(unit, spellID, customDuration)
	-- Set charges - 1:
	if ( trackedUnits[unit] and trackedUnits[unit]["cooldowns"][spellID] ) then
		CooldownTracker:UpdateCooldownCharges(unit, spellID, -1, nil, customDuration);
	end
end

function CooldownTracker:UpdateCooldownCharges(unit, spellID, value, isFullRecharge, customDuration)
	
	local charges, totalCharges = trackedUnits[unit]["cooldowns"][spellID]["charges"], trackedUnits[unit]["cooldowns"][spellID]["totalCharges"];
	if ( isFullRecharge ) then
		charges = totalCharges;
	else
		charges = charges + value;
	end
	
	if ( charges > totalCharges ) then
		charges = totalCharges;
	elseif ( charges < 0 ) then
		charges = 0;
	end
	
	trackedUnits[unit]["cooldowns"][spellID]["charges"] = charges;
	
	-- Set new cooldown if necessary:
	if ( charges < totalCharges ) then
		local currExpire = trackedUnits[unit]["cooldowns"][spellID]["expires"];
		local startTime = GetTime();
		local duration = customDuration or trackedUnits[unit]["cooldowns"][spellID]["duration"];
		local expires = startTime + duration;
		
		
		if ( not currExpire or ( totalCharges == 1 and currExpire < expires ) ) then
			trackedUnits[unit]["cooldowns"][spellID]["expires"] = expires;
				
			if ( not activeCooldowns[unit] ) then
				activeCooldowns[unit] = newTable();
			end	
				
			activeCooldowns[unit][spellID] = startTime + duration;
		end
		
		self:Show();
	end
	
end

function CooldownTracker:ResetCooldown(unit, spellID, isFullReset)
	if ( trackedUnits[unit] and trackedUnits[unit]["cooldowns"][spellID] ) then
		-- Reset cooldown data:
		trackedUnits[unit]["cooldowns"][spellID]["expires"] = nil;
		if ( activeCooldowns[unit] ) then
			activeCooldowns[unit][spellID] = nil;
		end
		
		-- Update charges:
		CooldownTracker:UpdateCooldownCharges(unit, spellID, 1, isFullReset);
	end
end

function CooldownTracker:CallInspect()
	local unit, guid = next(inspectQueue);
	
	if ( unit and CanInspect(unit) and UnitIsConnected(unit)==1 ) then
		local name = GetUnitName(unit);
		NotifyInspect(unit);
		UNIT_WAITING_FOR_INSPECT_EVENT = unit;
		ArenaLive:Message(L["Sending inspect query for %s (%s)..."], "debug", unit, name);
	elseif ( unit ) then
		-- Remove this entry from the list, as it cannot be inspected:
		inspectQueue[unit] = nil;
		self:Show();
	end
end

function CooldownTracker:CallGatherForAll()
	ArenaLiveSpectator:RefreshGUIDs()
	for i=1,5 do
		local trashUnit
		trashUnit = 'commentator'..i
		if UnitExists(trashUnit) and not trackedUnits[trashUnit]then
			CooldownTrackerClass:UpdateUnit(trashUnit)
		end
		
        trashUnit = 'commentator'..5+i
		
        if UnitExists(trashUnit) and not trackedUnits[trashUnit]then
			CooldownTrackerClass:UpdateUnit(trashUnit)
		end
	end
	
    for unit, cdTable in pairs(trackedUnits) do
		CooldownTracker:GatherCooldownInfo(unit, false);
	end
end

function CooldownTracker:ResetAll()
	for tracker in pairs(trackers) do
		tracker:Reset();
	end
end

function CooldownTracker:ShowInterruptOrDispel(specID)
	if ( not specID ) then
		return nil;
	end
	local role = GetSpecializationRoleByID(specID);
	if ( specID == 258 ) then
		-- Exception for shadow priests, as they don't have an interrupt:
		return "DISPEL";
	elseif ( role == "DAMAGER" or role == "TANK" ) then
		return "INTERRUPT";
	elseif ( role == "HEALER" ) then
		return "DISPEL";
	else
		return nil;
	end
end

function CooldownTracker:OnEvent(event, ...)
	local unit = ...;
	if ( event == "COMMENTATOR_PLAYER_UPDATE" and ArenaLiveSpectator:HasMatchStarted() ) then
		CooldownTracker:CallGatherForAll();
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( IsSpectator() ) then
			-- Update cooldown info after match has
			-- started to make sure for talent and
			-- glyph switches etc.
			-- ArenaLiveSpectator:PlayerUpdate()
			-- self:ResetAll()
			-- ArenaLiveSpectator:CallOnMatchStart(CooldownTracker.CallGatherForAll);
			self:ResetAll()
			DelayEvent(2, function()ArenaLiveSpectator:PlayerUpdate()CooldownTracker:CallGatherForAll()end);
		else
			local trashUnit
			DelayEvent(1, function()for i=1,10 do
				trashUnit = 'commentator'..i
				CooldownTracker:UnregisterUnit(trashUnit)
			end	end)
			local iconParent
			for i=1,5 do
				trashUnit = 'Right'
				iconParent = _G['ALSPEC_CDTrackers'.. trashUnit ..'Tracker'..i]
				if iconParent.icon1 then
					for j=1,9 do
						if not iconParent['icon'..j] then break end
						iconParent['icon'..j].cooldown:Reset()
					end
				end
				trashUnit = 'Left'
				iconParent = _G['ALSPEC_CDTrackers'.. trashUnit ..'Tracker'..i]
				if iconParent.icon1 then
					for j=1,9 do
						if not iconParent['icon'..j] then break end
						iconParent['icon'..j].cooldown:Reset()
					end
				end
			end
			table.wipe(activeCooldowns)
			self:ResetAll();
		end
	elseif ( event == "INSPECT_READY" and unit == inspectQueue[UNIT_WAITING_FOR_INSPECT_EVENT] ) then
		-- unit actually has the value of a GUID in case of inspect
		ArenaLive:Message(L["Inspect data received for %s..."], "debug", UNIT_WAITING_FOR_INSPECT_EVENT);
		CooldownTracker:GatherCooldownInfo(UNIT_WAITING_FOR_INSPECT_EVENT, true);
		
		-- Clear Inspect:
		inspectQueue[UNIT_WAITING_FOR_INSPECT_EVENT] = nil;
		UNIT_WAITING_FOR_INSPECT_EVENT = nil;
		ClearInspectPlayer();
		
		-- Call next inspect in queue if necessary:
		if ( next(inspectQueue) ) then
			CooldownTracker:CallInspect();
		end
	-- elseif ( event == "UNIT_NAME_UPDATE" and trackedUnits[unit] ) then
		-- -- Reset old cooldown information for this unit and add to inspect queue:
		-- print(event, ...)
		-- CooldownTracker:ResetCooldownInfo(unit);
		-- CooldownTracker:GatherCooldownInfo(unit, false);
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_CAST_SUCCESS" )then
		local srcGuid, src, _, _, destGuid, dest, _, _, spellID, spellName = select(4, ...);
		unit = ArenaLiveSpectator:GetUnitByGUID(srcGuid);
		if not unit and not spellID then return end
		if not trackedUnits[unit] then return end
	-- elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" and trackedUnits[unit] ) then
		-- local spellID = select(5, ...);
		
		-- Dispels need to be filtered, because they only trigger when they dispel something.
		-- Their cooldown is, therefore, triggered by COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL
		if ( ArenaLiveSpectator.SpellDB.CooldownTypes[spellID] ~= "DISPEL" ) then
			-- Check for cooldown resets:
			if ( ArenaLive.spellDB.CooldownResets[spellID] ) then
				for resetID in pairs(ArenaLive.spellDB.CooldownResets[spellID]) do
					CooldownTracker:ResetCooldown(unit, resetID, true);
				end
			end
			
			-- Start cooldown:
			if ( trackedUnits[unit]["cooldowns"][spellID] ) then
				CooldownTracker:StartCooldown(unit, spellID);
			end
			
			-- Check if there are shared CDs:
			if ( ArenaLiveSpectator.SpellDB.SharedCooldowns[spellID] ) then
				for sharedID, sharedDuration in pairs(ArenaLiveSpectator.SpellDB.SharedCooldowns[spellID]) do
					CooldownTracker:StartCooldown(unit, sharedID, sharedDuration);
				end
			end
			
			-- Update cooldown tracker frames after all changes have been applied:
			CooldownTracker:UpdateTrackersByUnit(unit);
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL" ) then
		local spellID = select(12, ...);
		if ( ArenaLiveSpectator.SpellDB.CooldownTypes[spellID] == "DISPEL" ) then
			local sourceGUID = select(4, ...);
			local unit = ArenaLiveSpectator:GetUnitByGUID(sourceGUID);
			
            if ( unit and trackedUnits[unit] and trackedUnits[unit]["cooldowns"][spellID] ) then
				CooldownTracker:StartCooldown(unit, spellID);
			end
		end
	end
end

-- The function is throttled to prevent inspect call spam, which could
-- let the server refuse our queries.
local elapsedTillNow = 0;
local THROTTLE = 1.5;
function CooldownTracker:OnUpdate(elapsed)
	elapsedTillNow = elapsedTillNow + elapsed;
	if ( elapsedTillNow > THROTTLE ) then
		elapsedTillNow = 0;
		
		local nextKey, nextValue = next(inspectQueue);
		if ( nextKey and not UNIT_WAITING_FOR_INSPECT_EVENT ) then
			CooldownTracker:CallInspect();
		end
		
		nextKey, nextValue = next(activeCooldowns);
		if ( nextKey ) then
			local theTime = GetTime();
			for unit, cooldownTable in pairs(activeCooldowns) do
				if ( next(cooldownTable) ) then
					for spellID, expires in pairs(cooldownTable) do
						if ( expires <= theTime ) then
							CooldownTracker:ResetCooldown(unit, spellID);
							CooldownTracker:UpdateTrackersByUnit(unit);
						end
					end
				else
					dumpTable(cooldownTable);
					activeCooldowns[unit] = nil;
				end
			end
		end
		
		if ( not nextKey ) then
			-- Hide frame so OnUpdate script won't be called any longer:
			ArenaLive:Message(L["Hiding CooldownTracker's handler frame..."], "debug");
			self:Hide();
		end
	end
end
CooldownTracker:SetScript("OnUpdate", CooldownTracker.OnUpdate);

--[[
****************************************
******* CLASS METHODS START HERE *******
****************************************
]]--
function CooldownTrackerClass:Enable()
	self:Show();
	trackers[self] = true;
	self:Update();
	self:UpdatePositions();
	self.enabled = true;
end

function CooldownTrackerClass:Disable()
	self:UpdateUnit();
	self:Reset();
	self:Hide();
	self.enabled = false;
end

function CooldownTrackerClass:Update()
	
	local unit = self.unit;
	if ( not self.enabled or not unit --or not trackedUnits[unit] 
	or not UnitExists(unit) ) then
		self:Reset();
		return;
	end
	
	self:Show();
	
	-- Set class icon:
	local _, class = UnitClass(unit);
	if ( self.classIcon and class ) then
		self.classIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
		self.classIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
	end
	
	-- Set name:
	local name = NameText:GetNickname(unit) or GetUnitName(unit);
	if ( self.nameText ) then
		self.nameText:SetText(name);
	end	
	
	-- Set Cooldown icons:
	local theTime = GetTime();
	for key, spellID in ipairs(self.shownCooldowns) do

		icon = self["icon"..key];
		if ( not icon ) then
			icon = CooldownTracker:ConstructIcon(self);
			self:UpdatePositions();
		end
		
		icon:Show();

		icon.spellID = spellID;
		icon.addon = self.addon;
		icon.group = self.group;
        
        if trackedUnits[unit]["cooldowns"][spellID] == nil then
            print(spellID.." нулл!", unit);
        end
			
		-- Set Texture:
		local texture = trackedUnits[unit]["cooldowns"][spellID]["texture"] or [[Interface\Icons\INV_Misc_QuestionMark]];
		icon.texture:SetTexture(texture);
			
		-- Set number of charges:
		local charges, totalCharges = trackedUnits[unit]["cooldowns"][spellID]["charges"], trackedUnits[unit]["cooldowns"][spellID]["totalCharges"];
		if ( icon.count ) then
			if ( charges > 0 and totalCharges > 1 ) then
				icon.count:Show();
				icon.count:SetText(charges);
			else
				icon.count:Hide();
			end
		end
			
		-- Check for active cooldown:
		if ( trackedUnits[unit]["cooldowns"][spellID]["expires"] and trackedUnits[unit]["cooldowns"][spellID]["expires"] > theTime and charges == 0 ) then
				
			local expires = trackedUnits[unit]["cooldowns"][spellID]["expires"];
			local duration = trackedUnits[unit]["cooldowns"][spellID]["duration"];
			local startTime = expires - duration;
			icon.cooldown:Set(startTime, duration);
		else
			--icon.cooldown:Reset();
		end
	end
	
	-- Reset not needed icons:
	if ( #self.shownCooldowns < self.numIcons ) then
		for i = #self.shownCooldowns + 1, self.numIcons do
			icon = self["icon"..i];
			self:ResetIcon(icon);
		end
	end
end

function CooldownTrackerClass:UpdateShownCooldowns()
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	local unit = self.unit;
	local specID = trackedUnits[unit].specID;
	
	-- Reset old entries:
	table.wipe(self.shownCooldowns);
	
	if ( trackedUnits[unit] ) then
		-- Add trinket:
		if ( database.ShowTrinket ) then
			table.insert(self.shownCooldowns, trackedUnits[unit]["TRINKET"][1]);
		end
		
		-- Add racial:
		local _, race = UnitRace(unit);
		if ( database.ShowRacial and race ~= "Human" ) then
			table.insert(self.shownCooldowns, trackedUnits[unit]["RACIAL"][1]);
		end
		
		-- Add interrupt or dispel depending on spec:
		local interruptOrDispel = CooldownTracker:ShowInterruptOrDispel(specID);
		if ( interruptOrDispel ) then
			table.insert(self.shownCooldowns, trackedUnits[unit][interruptOrDispel][1]);
		end	
		
		local icon;
		local numFoundDefCDs = 0;
		local numFoundOffCDs = 0;
		local cooldownType = "MAIN";
		local i = 1;	
		while #self.shownCooldowns < database.MaxShownIcons do				
			if ( cooldownType == "MAIN" ) then
				-- Add Defensive and Offensive Cooldowns:
				if ( numFoundDefCDs < database.numMaxDefCDs and i <= #trackedUnits[unit]["DEF_CD"] ) then
					numFoundDefCDs = numFoundDefCDs + 1;
					table.insert(self.shownCooldowns, trackedUnits[unit]["DEF_CD"][i]);
				end

				if ( numFoundOffCDs < database.numMaxOffCDs and i <= #trackedUnits[unit]["OFF_CD"] ) then
					numFoundOffCDs = numFoundOffCDs + 1;
					table.insert(self.shownCooldowns, trackedUnits[unit]["OFF_CD"][i]);
				end
				
				if ( ( numFoundOffCDs == database.numMaxOffCDs and numFoundOffCDs == database.numMaxOffCDs ) 
				or ( i >  #trackedUnits[unit]["DEF_CD"] and i > #trackedUnits[unit]["OFF_CD"] ) ) then
					cooldownType = "CC";
					i = 0;
				end
			else
				-- Fill remaining space with crowd control and misc cooldowns:
				if ( i <= #trackedUnits[unit][cooldownType] ) then
					table.insert(self.shownCooldowns, trackedUnits[unit][cooldownType][i]);
				end
				
				if ( cooldownType == "CC" and i >  #trackedUnits[unit][cooldownType] ) then
					i = 0;
					cooldownType = "MISC";
				elseif ( cooldownType == "MISC" and i > #trackedUnits[unit][cooldownType] ) then
					break;
				end
			end
			
			i = i + 1;
		end
		
		-- Sort cooldown table:
		table.sort(self.shownCooldowns, sortFunc);
	end

	self:Update();
end

function CooldownTrackerClass:UpdatePositions()
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	
	local point, relativeTo, xSpace ,ySpace;
	if ( database.GrowingDirection == "UP" ) then
		point = "BOTTOM";
	elseif ( database.GrowingDirection == "RIGHT" ) then
		point = "LEFT";
	elseif ( database.GrowingDirection == "DOWN" ) then
		point = "TOP";
	elseif ( database.GrowingDirection == "LEFT" ) then
		point = "RIGHT";
	end
	
	local xOffset, yOffset = 0, 0;
	local icon, width, height;
	if ( self.classIcon ) then
		width, height = self.classIcon:GetSize();
		self.classIcon:ClearAllPoints();
		self.classIcon:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	if ( self.nameText ) then
		width, height = self.nameText:GetSize();
		if ( database.GrowingDirection == "RIGHT" ) then
			self.nameText:SetJustifyH("LEFT")
		elseif ( database.GrowingDirection == "LEFT" ) then
			self.nameText:SetJustifyH("RIGHT")
		end
		
		self.nameText:ClearAllPoints();
		self.nameText:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	for i = 1, self.numIcons do
		icon = self["icon"..i];
		width, height = icon:GetSize();
		
		icon:ClearAllPoints();
		icon:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	-- Use this if you want to adjust cooldown tracker elements manually:
	if ( type(self.OnPositionUpdate) == "function" ) then
		self:OnPositionUpdate();
	end
end

function CooldownTrackerClass:Reset()
	
	if ( self.classIcon ) then
		self.classIcon:SetTexture();
	end
	
	if ( self.nameText ) then
		self.nameText:SetText("");
	end
	
	local icon;
	if self.numIcons then
		for i = 1, self.numIcons do
			icon = self["icon"..i];
			self:ResetIcon(icon);
		end
		self:Hide();
	end
end

function CooldownTrackerClass:ResetIcon(icon)
	icon.texture:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]]);
	--icon.cooldown:Reset();
	icon:Hide();
end

function CooldownTrackerClass:UpdateUnit(unit)
	
	if ( unit and unit ~= self.unit ) then
		CooldownTracker:RegisterUnit(unit);
	elseif ( not unit and self.unit ) then
		CooldownTracker:UnregisterUnit(self.unit);
	end
	
	self.unit = unit;
	self:Update();
end

function FixCooldownFrames()
	if CommentatorGetMapInfo(1) > ArenaLive:GetDBComponent(addonName).PlayMode then
		ArenaLiveSpectator:SetNumPlayers(CommentatorGetMapInfo(1))
	end
	ArenaLiveSpectator:PlayerUpdate()
	CooldownTracker:ResetAll()
	CooldownTracker:CallGatherForAll()
end
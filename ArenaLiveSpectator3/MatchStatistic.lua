local addonName, L = ...;
local NameText = ArenaLive:GetHandler("NameText");

local matchStatistics = {};
local trackedGUIDs = {};
local petGUIDToOwnerGUID = {};
local ownerGUIDToPetGUID = {};
local absorbWaitingForRemoval = {};
local ccWaitingForRemoval = {};
local MAX_DEBUFFS = 40;
local HEADER_BASE_HEIGHT = 36;
local PLAYER_ENTRY_BASE_HEIGHT = 32;
local DEFAULT_OFFSET = 5;

function ArenaLiveSpectatorMatchStatistic:Initialise()
	-- Set Portrait:
	ArenaLiveSpectatorMatchStatisticTitleText:SetText(L["ArenaLive [Spectator] Match Statistic"]);
	self.portrait:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\WarGameMenuPortrait");
	
	-- Use this function from the war game menu, to initialise leave arena button:
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.leaveButton, L["Leave Arena"], function(self) LeaveBattlefield(); end);
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.deleteButton, L["Delete Match"]);
	ArenaLiveSpectatorMatchStatisticDeleteMatchButton:Disable();
	-- Set Match Statistic Dropdown:
	self.dropdown.title:SetText(L["Match:"]);
	UIDropDownMenu_SetWidth(self.dropdown, 300, 5);
	UIDropDownMenu_SetText(self.dropdown, L["Choose a Match"]);
	UIDropDownMenu_Initialize(self.dropdown, self.dropdown.Refresh);
	
	self:SetScript("OnShow", self.OnShow);
	self:SetScript("OnHide", self.OnHide);
end

function ArenaLiveSpectatorMatchStatistic:Open(showNewest)
	local database = ArenaLive:GetDBComponent(addonName);
	
	if ( #database.MatchStatistic == 0 ) then
		self.TeamA:Hide();
		self.TeamB:Hide();
		self.inset:Hide();
	else
		self.TeamA:Show();
		self.TeamB:Show();
		self.inset:Show();		
	end
	
	if ( showNewest ) then
		self:SetMatch(#database.MatchStatistic);
	end
	self:Show();
end

function ArenaLiveSpectatorMatchStatistic:OnShow()
	
	-- Close War Game Menu:
	if ( ArenaLiveSpectatorWarGameMenu:IsShown() ) then
		ArenaLiveSpectatorWarGameMenu:Hide();
	end
	
	ArenaLiveSpectatorMatchStatistic:UpdateFrameHeightsAndPosition(self.id);
	
	if ( ArenaLiveSpectator.enabled ) then
		self.leaveButton:Enable();
	else
		self.leaveButton:Disable();
	end
	PlaySound("igCharacterInfoTab");
end

function ArenaLiveSpectatorMatchStatistic:OnHide()
	PlaySound("igCharacterInfoClose");
end

function ArenaLiveSpectatorMatchStatistic:GetTeamFrameHeight(numPlayers)
	if ( numPlayers > 0 ) then
		return HEADER_BASE_HEIGHT + ( PLAYER_ENTRY_BASE_HEIGHT  * numPlayers )  +  ( DEFAULT_OFFSET * numPlayers );
	else
		return 0;
	end
end

function ArenaLiveSpectatorMatchStatistic:FillFrameWithPlayerData(matchID, team, playerID, isHeader)

	if ( not matchID or not team  ) then
		return;
	end

	local database = ArenaLive:GetDBComponent(addonName);
	local frame;
	if ( isHeader ) then
		frame = self[team].header;
		local name = database.MatchStatistic[matchID][team].name;
		local r, g, b = unpack(database[team].Colour);
		frame.background:SetVertexColor(r, g, b);
		frame.name:SetText(name);
		frame.damage:SetText(L["Damage Dealt:"]);
		frame.healing:SetText(L["Healing Done:"]);
		frame.ccd:SetText(L["Time in CC:"]);
	else
		frame = self[team]["player"..playerID];
		
		local guid = database.MatchStatistic[matchID][team].idToGUID[playerID];
		local name = database.MatchStatistic[matchID][team][guid].name;
		local class = database.MatchStatistic[matchID][team][guid].class;
		local absorb = database.MatchStatistic[matchID][team][guid].absorb;
		local damage = database.MatchStatistic[matchID][team][guid].damage;
		local healing = database.MatchStatistic[matchID][team][guid].healing;
		local timeCCd = database.MatchStatistic[matchID][team][guid].timeCCd;
		local healing = healing + absorb;
		local minutes, seconds;
		minutes = math.floor(timeCCd / 60);
		seconds = timeCCd % 60;
		if ( seconds < 10 ) then
			seconds = "0"..tostring(seconds);
		end

		local shownTime = string.format(L["%d:%s"], minutes, seconds);
		frame.name:SetText(name);
		frame.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
		frame.damage:SetText(math.floor(damage));
		frame.healing:SetText(math.floor(healing));
		frame.ccd:SetText(shownTime);
	end
end

function ArenaLiveSpectatorMatchStatistic:UpdateFrameHeightsAndPosition(matchID)
	local database = ArenaLive:GetDBComponent(addonName);
	local winner, numA, numB;
	if ( not matchID ) then
		winner = 1;
		numA = 0;
		numB = 0;
	else
		winner = database.MatchStatistic[matchID].winner;
		numA = database.MatchStatistic[matchID].TeamA['#'];
		numB = database.MatchStatistic[matchID].TeamB['#'];
	end
	
	-- Setup Headers:
	self:FillFrameWithPlayerData(matchID, "TeamA", nil, true);
	self:FillFrameWithPlayerData(matchID, "TeamB", nil, true);
		
	-- Set frame heights:
	local aHeight = ArenaLiveSpectatorMatchStatistic:GetTeamFrameHeight(numA);
	local bHeight = ArenaLiveSpectatorMatchStatistic:GetTeamFrameHeight(numA);
		
	local height = 114 + aHeight + bHeight;
	self:SetHeight(height);
	self.TeamA:SetHeight(aHeight);
	self.TeamB:SetHeight(bHeight);
		
	-- Set Anchors:
	-- Show winning team on top, if there is one
	self.TeamA:ClearAllPoints();
	self.TeamB:ClearAllPoints();
		
	local top, bottom;
	if ( winner == "TeamB" ) then
		top = self.TeamB;
		bottom = self.TeamA;
	else
		top = self.TeamA;
		bottom = self.TeamB;
	end

	top:SetPoint("TOP", self, "TOP", 0, -77);
	bottom:SetPoint("TOPLEFT", top, "BOTTOMLEFT", 0, -10);
			
		
	if ( numA == 0 ) then
		self.TeamA:Hide();
	else
		self.TeamA:Show();
	end
	
	if ( numB == 0 ) then
		self.TeamB:Hide();
	else
		self.TeamB:Show();
	end
end

function ArenaLiveSpectatorMatchStatistic:SetMatch(id)
	local database = ArenaLive:GetDBComponent(addonName);
	if ( id > #database.MatchStatistic ) then
		ArenaLive:Message(L["ArenaLiveSpectatorMatchStatistic:SetMatch(id): id too high."], "error", name);
	else
		local numA = database.MatchStatistic[id].TeamA['#'];
		local numB = database.MatchStatistic[id].TeamB['#'];
		ArenaLiveSpectatorMatchStatistic:UpdateFrameHeightsAndPosition(id);
		
		-- Fill frames with player data:
		local frame;
		for i = 1, 5 do
			frame = self.TeamA["player"..i];
			if ( i <= numA ) then
				self:FillFrameWithPlayerData(id, "TeamA", i);
				frame:Show();
			else
				frame:Hide();
			end
			
			frame = self.TeamB["player"..i];
			if ( i <= numA ) then
				self:FillFrameWithPlayerData(id, "TeamB", i);
				frame:Show();
			else
				frame:Hide();
			end
		end
		
		self.id = id;
	end
end

function ArenaLiveSpectatorMatchStatisticMatchDropDown.OnClick(button, arg1, arg2)
	local dropDown = UIDROPDOWNMENU_OPEN_MENU;
	
	ArenaLiveSpectatorMatchStatisticDeleteMatchButton:Enable();
	ArenaLiveSpectatorMatchStatistic:SetMatch(button.value);
	UIDropDownMenu_SetText(dropDown, button:GetText());
end

local info = {};
function ArenaLiveSpectatorMatchStatisticMatchDropDown:Refresh()
	local database = ArenaLive:GetDBComponent(addonName);
	
	for matchID, matchInfo in ipairs(database.MatchStatistic) do
		info.text = matchInfo["name"];
		info.value = matchID;
		info.func = self.OnClick;
		if ( self.id and matchID == self.id ) then
			info.checked = true;
		else
			info.checked = nil;
		end
		
		
		UIDropDownMenu_AddButton(info);
	end
end

function ArenaLiveSpectatorMatchStatisticDeleteMatchButton:OnClick(button, down)
	if ( button == "LeftButton" and ArenaLiveSpectatorMatchStatistic.id ) then
		local id = ArenaLiveSpectatorMatchStatistic.id;
		ArenaLiveSpectatorMatchStatistic.id = nil;
		ArenaLiveSpectatorMatchStatistic:UpdateFrameHeightsAndPosition();
		UIDropDownMenu_SetText(ArenaLiveSpectatorMatchStatistic.dropdown, L["Choose a Match"]);
		local database = ArenaLive:GetDBComponent(addonName);
		table.remove(database.MatchStatistic, id);
		self:Disable();
	end
end

--[[
		MATCH RECORDING FUNCTIONS
]]
function ArenaLiveSpectatorMatchStatistic:Start()
	
	if ( self.record ) then
		self:Stop();
	end
	local numTeamA = CommentatorGetNumPlayers(2);
	local numTeamB = CommentatorGetNumPlayers(1);
	if ( numTeamA > 0 and numTeamB > 0 ) then	
		ArenaLiveSpectatorMatchStatistic:SetUpTeam("TeamA");
		ArenaLiveSpectatorMatchStatistic:SetUpTeam("TeamB");
		self.record = true;
	end
end

function ArenaLiveSpectatorMatchStatistic:Stop()
	if ( self.record ) then
		local database = ArenaLive:GetDBComponent(addonName);
		
		-- Get winning team:
		local winner = GetBattlefieldWinner();
		if ( not winner or winner == 255 ) then
			matchStatistics.winner = "DRAW" 
		elseif ( winner == 0 ) then
			matchStatistics.winner = "TeamB"
		elseif ( winner == 1 ) then
			matchStatistics.winner = "TeamA"
		end
		
		local numMatch = #database.MatchStatistic + 1;
		local nameA, nameB = database.TeamA.Name, database.TeamB.Name
		local scoreA, scoreB = database.TeamA.Score, database.TeamB.Score
		-- Create Match Name:
		local name = string.format(L["%d. %s vs %s (%d:%d)"], numMatch,  nameA, nameB, scoreA, scoreB);
		
		-- Add Match to Saved Variables:
		matchStatistics.name = name;
		table.insert(database.MatchStatistic, ArenaLive:CopyTable(matchStatistics));
		
		ArenaLive:Message(L["Saved Match %s to SavedVariables..."], "debug", name);
		
		-- Wipe tables:
		table.wipe(matchStatistics);
		table.wipe(trackedGUIDs);
		table.wipe(petGUIDToOwnerGUID);
		table.wipe(ownerGUIDToPetGUID);
		table.wipe(absorbWaitingForRemoval);
		table.wipe(ccWaitingForRemoval);
		
		self.record = false;
	end
end

function ArenaLiveSpectatorMatchStatistic:IsRecording()
	return self.record;
end

function ArenaLiveSpectatorMatchStatistic:SetUpTeam(team)
	
	local numMembers, unitMod;
	if ( team == "TeamA" ) then
		
		numMembers = CommentatorGetNumPlayers(2);
		unitMod = "spectateda";
	elseif ( team == "TeamB") then
		numMembers = CommentatorGetNumPlayers(1);
		unitMod = "spectatedb";
	end
	local database = ArenaLive:GetDBComponent(addonName, nil, team);
	
	matchStatistics[team] = {};
	matchStatistics[team].idToGUID = {};
	matchStatistics[team]["name"] = database.Name;
	matchStatistics[team]['#'] = numMembers;
	
	for i = 1, numMembers do
		local unit = unitMod..i;
		local petUnit = unitMod.."pet"..i;
		local guid = UnitGUID(unit);
		local petGUID = UnitGUID(petUnit);
		if ( guid ) then
			matchStatistics[team][guid] = {};
			local name = NameText:GetNickname(unit) or GetUnitName(unit, true);
			local _, class = UnitClass(unit);
			
			matchStatistics[team].idToGUID[i] = guid;
			matchStatistics[team][guid].name = name;
			matchStatistics[team][guid].class = class;
			matchStatistics[team][guid].absorb = 0;
			matchStatistics[team][guid].damage = 0;
			matchStatistics[team][guid].healing = 0;
			matchStatistics[team][guid].timeCCd = 0;

			if ( petGUID ) then
				petGUIDToOwnerGUID[petGUID] = guid;
				ownerGUIDToPetGUID[guid] = petGUID;
			end
			
			trackedGUIDs[guid] = team;
			

		end
	end
	
end

--[[ Absorbs can only be tracked with regards to their source via auras.
	 AURA_APPLIED and AURA_REFRESH: Already contain the amount of absorb that is applied.
	 AURA_REMOVED: Contains the amount that is left after the aura is removed.
	 So what I'll do here is to simply put every applied absorb into a table and adding it
	 to the sources as soon as the absorb has run out.
]]--
function ArenaLiveSpectatorMatchStatistic:SPELL_AURA_APPLIED (...)
	
	local sourceGUID = select(4, ...);
	if ( not sourceGUID or ( not trackedGUIDs[sourceGUID] and not petGUIDToOwnerGUID[sourceGUID] ) ) then
		return;
	end
	
	if ( petGUIDToOwnerGUID[sourceGUID] ) then
		sourceGUID = petGUIDToOwnerGUID[sourceGUID];
	end
	
	local destGUID = select(8, ...);
	local spellID = select(12, ...);
	local auraType = select(15, ...);
	local amount = select(16, ...);

	if ( auraType == "BUFF" and amount ) then
		local absorbID = sourceGUID.."-"..destGUID.."-"..spellID;
		absorbWaitingForRemoval[absorbID] = amount;
	end	
	
end

function ArenaLiveSpectatorMatchStatistic:SPELL_AURA_REMOVED (...)

	local sourceGUID = select(4, ...);
	if ( not sourceGUID or ( not trackedGUIDs[sourceGUID] and not petGUIDToOwnerGUID[sourceGUID] ) ) then
		return;
	end
	
	if ( petGUIDToOwnerGUID[sourceGUID] ) then
		sourceGUID = petGUIDToOwnerGUID[sourceGUID];
	end
	
	local team = trackedGUIDs[sourceGUID];
	local destGUID = select(8, ...);
	local spellID = select(12, ...);
	local auraType = select(15, ...);
	local amount = select(16, ...);

	if ( auraType == "BUFF" and amount ) then
		local absorbID = sourceGUID.."-"..destGUID.."-"..spellID;
		if ( absorbWaitingForRemoval[absorbID] ) then
			amount = absorbWaitingForRemoval[absorbID] - amount;
			absorbWaitingForRemoval[absorbID] = nil;
			
			matchStatistics[team][sourceGUID].absorb = matchStatistics[team][sourceGUID].absorb + math.floor(amount);
		end
	end
	
end

function ArenaLiveSpectatorMatchStatistic:SPELL_AURA_REFRESH (...)
	ArenaLiveSpectatorMatchStatistic:SPELL_AURA_APPLIED(...);
end

function ArenaLiveSpectatorMatchStatistic:SPELL_DAMAGE (...)
	local sourceGUID = select(4, ...);
	if ( not sourceGUID or ( not trackedGUIDs[sourceGUID] and not petGUIDToOwnerGUID[sourceGUID] ) ) then
		return;
	end
	
	if ( petGUIDToOwnerGUID[sourceGUID] ) then
		sourceGUID = petGUIDToOwnerGUID[sourceGUID];
	end
	
	local team = trackedGUIDs[sourceGUID];
	local amount = select(15, ...);
	local overkill = select(16, ...);
	local resisted = select(18, ...);
	local blocked = select(19, ...);
	
	if ( resisted ) then
		amount = amount - resisted;
	end
	
	if ( blocked ) then
		amount = amount - blocked;
	end
	
	if ( overkill ) then
		amount = amount - overkill;
	end

	matchStatistics[team][sourceGUID].damage = matchStatistics[team][sourceGUID].damage + math.floor(amount);
end

function ArenaLiveSpectatorMatchStatistic:SPELL_HEAL (...)
	
	local sourceGUID = select(4, ...);
	if ( not sourceGUID or ( not trackedGUIDs[sourceGUID] and not petGUIDToOwnerGUID[sourceGUID] ) ) then
		return;
	end
	
	if ( petGUIDToOwnerGUID[sourceGUID] ) then
		sourceGUID = petGUIDToOwnerGUID[sourceGUID];
	end
	
	local team = trackedGUIDs[sourceGUID];
	local amount = select(15, ...);
	local overHealing = select(16, ...);
	if ( overHealing ) then
		amount = amount - overHealing;
	end
	
	matchStatistics[team][sourceGUID].healing = matchStatistics[team][sourceGUID].healing + math.floor(amount);
end

function ArenaLiveSpectatorMatchStatistic:SPELL_PERIODIC_DAMAGE (...)
	ArenaLiveSpectatorMatchStatistic:SPELL_DAMAGE(...);
end

function ArenaLiveSpectatorMatchStatistic:SPELL_PERIODIC_HEAL (...)
	ArenaLiveSpectatorMatchStatistic:SPELL_HEAL(...);
end

function ArenaLiveSpectatorMatchStatistic:SWING_DAMAGE (...)

	local sourceGUID = select(4, ...);
	if ( not sourceGUID or ( not trackedGUIDs[sourceGUID] and not petGUIDToOwnerGUID[sourceGUID] ) ) then
		return;
	end
	
	if ( petGUIDToOwnerGUID[sourceGUID] ) then
		sourceGUID = petGUIDToOwnerGUID[sourceGUID];
	end
	
	local team = trackedGUIDs[sourceGUID];
	local amount = select(12, ...);
	local overkill = select(13, ...);
	local resisted = select(15, ...);
	local blocked = select(16, ...);

	if ( resisted ) then
		amount = amount - resisted;
	end
	
	if ( blocked ) then
		amount = amount - blocked;
	end
	
	if ( overkill ) then
		amount = amount - overkill;
	end
	
	matchStatistics[team][sourceGUID].damage = matchStatistics[team][sourceGUID].damage + math.floor(amount);
end

function ArenaLiveSpectatorMatchStatistic:UNIT_AURA(unit)
	local guid = UnitGUID(unit);
	if ( guid and trackedGUIDs[guid] ) then
		local team = trackedGUIDs[guid]
		local isInCC;
		for index = 1, MAX_DEBUFFS do
			local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff(unit, index);
			if ( ArenaLive.spellDB["DiminishingReturns"][spellID] ) then
				isInCC = true;
				break;
			end
		end

		if ( not ccWaitingForRemoval[guid] and isInCC ) then
			ccWaitingForRemoval[guid] = GetTime();
		elseif ( ccWaitingForRemoval[guid] and not isInCC ) then
			local duration = math.floor(GetTime() - ccWaitingForRemoval[guid]);
			matchStatistics[team][guid].timeCCd = matchStatistics[team][guid].timeCCd + duration;
			ccWaitingForRemoval[guid] = nil;
		end
	end
end

function ArenaLiveSpectatorMatchStatistic:UNIT_PET(unit)
	local guid = UnitGUID(unit);
	local petUnit = ArenaLive:GetPetUnit(unit);
	if ( guid and trackedGUIDs[guid] and ownerGUIDToPetGUID[guid] ) then
		local oldPetGUID = ownerGUIDToPetGUID[guid];
		local petGUID = UnitGUID(petUnit);
		
		-- Reset old GUID:
		petGUIDToOwnerGUID[oldPetGUID] = nil;
		
		ownerGUIDToPetGUID[guid] = petGUID;
		if ( petGUID ) then
			petGUIDToOwnerGUID[petGUID] = guid;
		end
	end
end

function ArenaLiveSpectatorMatchStatistic:OnEvent(event, ...)
	if ( event == "COMBAT_LOG_EVENT_UNFILTERED" and self.record ) then
		local event2 = select(2, ...);
		
		if ( self[event2] ) then
			self[event2](self, ...);
		end
	elseif ( self.record ) then
		if ( self[event] ) then
			self[event](self, ...);
		end
	end
end


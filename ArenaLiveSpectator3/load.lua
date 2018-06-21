local addonName, L = ...;

Players = {};

GreenTeam = 67;
GoldTeam = 469;

--[[
	 Most important information for Spectated War Games:
		UnitIDs: 
			spectatedaX
			spectatedbX
		TeamIDs: (e.g. CommentatorGetNumPlayers(teamID))
			1 = TeamB (spectatedbX)
			2 = TeamA (spectatedaX)
		factionIDs: (e.g. for GetBattlefieldWinner())
			 0 = TeamB (Green Team)
			 1 = TeamA (Gold Team)
]]
ArenaLiveSpectator.defaults = {
	["Broadcast"] = true,
	["FirstLogin"] = true,
	["FollowTarget"] = true,
	["HideTargetFrames"] = true,
	["PlayMode"] = 3,
	["ShowScoreBoard"] = true,
	["Version"] = "3.0.0b",
	["TeamA"] = {
		["Name"] = "Gold Team",
		["Leader"] = "",
		["Score"] = 0,
		["Colour"] = { 1, 0.83, 0, 1 }, -- Gold Team (old blue 0, 0.5, 1, 1)
	},
	["TeamB"] = {
		["Name"] = "Green Team",
		["Leader"] = "",
		["Score"] = 0,
		["Colour"] = { 0.39, 0.71, 0.33, 1 }, -- Green Team (old: red 1, 0.19, 0, 1)
	},
	["MatchStatistic"] = {
	},
	["NicknameDatabase"] = {
	},
	["FrameMover"] = {
		["FrameLock"] = true,
	},
	["Cooldown"] =	{
		["ShowText"] = true,
		["StaticSize"] = false,
		["TextSize"] = 8,
	},
	["CCIndicator"] =	{
		["Priorities"] = {
			["defCD"] = 9,
			["offCD"] = 3,
			["stun"] = 8,
			["silence"] = 7,
			["crowdControl"] = 6,
			["root"] = 5,
			["disarm"] = 4,
			["usefulBuffs"] = 0,
			["usefulDebuffs"] = 0,
		},
	},
	["TargetFrame"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = true,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 21,
			["Direction"] = "RIGHT",
			["IconDuration"] = 10,
			["MaxIcons"] = 9,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 26,
			["LargeIconSize"] = 26,
			["GrowRTL"] = false,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["TargetTargetFrame"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = true,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 21,
			["Direction"] = "LEFT",
			["IconDuration"] = 10,
			["MaxIcons"] = 9,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 26,
			["LargeIconSize"] = 26,
			["GrowRTL"] = true,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["Left"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = nil,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CooldownTracker"] = {
			["GrowingDirection"] = "RIGHT",
			["MaxShownIcons"] = 9,
			["ShowTrinket"] = true,
			["ShowRacial"] = true,
			["numMaxDefCDs"] = 3,
			["numMaxOffCDs"] = 3,
			["ShowTooltip"] = true,
			["Space"] = 3,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 18,
			["Direction"] = "RIGHT",
			["IconDuration"] = 7,
			["MaxIcons"] = 4,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 20,
			["LargeIconSize"] = 20,
			["GrowRTL"] = false,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["Right"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = nil,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["BarTextSize"] = 10,
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},		
		["CooldownTracker"] = {
			["GrowingDirection"] = "LEFT",
			["MaxShownIcons"] = 9,
			["ShowTrinket"] = true,
			["ShowRacial"] = true,
			["numMaxDefCDs"] = 3,
			["numMaxOffCDs"] = 3,
			["ShowTooltip"] = true,
			["Space"] = 3,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 18,
			["Direction"] = "LEFT",
			["IconDuration"] = 7,
			["MaxIcons"] = 4,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 20,
			["LargeIconSize"] = 20,
			["GrowRTL"] = true,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["NamePlate"] = {
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = false,
			["ShowAbsorb"] = true,
		},
	},
};

-- Table to store callback functions for match start:
local onMatchStartCallbackList = {};

local slashCMDs = {
	["help"] = L["Shows this info message."],
	["menu"] = L["Shows the War Game Menu"],
	["stats"] = L["Shows the Match Statistic"],
};

-- Slash Commands:
SLASH_ARENALIVESPECTATOR1, SLASH_ARENALIVESPECTATOR2 = "/alspec", "/arenalivespectator";
function SlashCmdList.ARENALIVESPECTATOR (msg, editBox )
	if ( not msg or msg == "" or msg == "menu" ) then
		ArenaLiveSpectatorWarGameMenu:Show();
	elseif ( msg == "stats" ) then
		ArenaLiveSpectatorMatchStatistic:Open();
	elseif ( msg == "help" ) then
		ArenaLive:Message(L["Available Slash Commands for ArenaLive [Spectator] are:"], "message");
		for cmd, description in pairs(slashCMDs) do
			print(string.format(L["%s: %s"], cmd, description));
		end
	end
end

-- Custom function to check if player currently is a spectator.
--[[ 
	 From Blizzard: "You can use "CommentatorGetMode()" to see if you
	 are a spectator. It should return 0 if you are not a spectator,
	 and non-zero if you are some type of spectator.  (I believe 1 and
	 2 are reserved for our internal commentator feature, so it should
	 return 3 for you)."
]]--
function IsSpectator()
    local inInstance, instanceType = IsInInstance();
    return instanceType and instanceType== "arena";
end

function ArenaLiveSpectator:Enable()
	ArenaLiveSpectatorWarGameMenu:Hide();
	UIParent:Hide();
	self:Show();
	
	local database = ArenaLive:GetDBComponent(addonName);
	--:SetNumPlayers(database.PlayMode);
	ArenaLiveSpectatorHideUIButton:Show();
	ArenaLiveSpectatorMatchStatistic:SetParent("ArenaLiveSpectator");
	ArenaLiveSpectator:CallOnMatchStart(function() ArenaLiveSpectatorMatchStatistic:Start(); end);
	ArenaLiveSpectatorMatchStatistic.leaveButton:Enable();
	--ArenaLiveSpectator:RefreshGUIDs();
	self.enabled = true;
    self.hasStarted = true;
end

function ArenaLiveSpectator:Disable()
	self:Hide();
	ArenaLiveSpectatorHideUIButton:Hide();
	UIParent:Show();
	
	ArenaLiveSpectatorScoreBoard:Reset();
	ArenaLiveSpectatorMatchStatistic.leaveButton:Disable();
	ArenaLiveSpectatorMatchStatistic:SetParent("UIParent");
	if ( ArenaLiveSpectatorMatchStatistic:IsRecording() ) then
		ArenaLiveSpectatorMatchStatistic:Stop();
	end
	
	-- Disable Side frames:
	local frame;
	for i = 1, 5 do
		-- Disable Side frames:
		frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		frame:Disable();
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		frame:Disable();
		
		-- Disable Cooldown Trackers:
		frame = _G["ALSPEC_CDTrackersLeftTracker"..i];
		frame:Disable();
		frame = _G["ALSPEC_CDTrackersRightTracker"..i];
		frame:Disable();
	end
	
	-- Disable Target and Target of Target:
	frame = _G["ALSPEC_TargetFrame"];
	frame:Disable();
	
	frame = _G["ALSPEC_TargetTargetFrame"];
	frame:Disable();
	
	self.enabled = false;
	self.hasStarted = nil;
	self.worldStateTimerIndex = nil;
	
end

function ArenaLiveSpectator:OnEvent(event, ...)
	local filter, arg2, arg3 = ...;

	if ( event == "ADDON_LOADED" and filter == addonName ) then
		-- Initialise Nickname Database:
		--self.NicknameDatabase:Initialise()
		
		-- Initialise frames:
		self:InitialiseSideFrames();
		self:InitialiseTargetFrames();
		self:InitialiseCooldownTracker();
		ArenaLiveSpectatorScoreBoard:Initialise();
		ArenaLiveSpectatorMatchStatistic:Initialise();
		ArenaLiveSpectatorWarGameMenu:Initialise();
		
		-- Set up hide normal UI button, it shows up if UIParent is somehow shown during a match:
		ArenaLiveSpectatorHideUIButtonText:SetText(L["Hide normal UI"]);
		local width = ArenaLiveSpectatorHideUIButtonText:GetWidth();
		width = width + 30;
		ArenaLiveSpectatorHideUIButton:SetWidth(width);
		ArenaLiveSpectatorHideUIButton:SetScript("OnClick", ArenaLiveSpectatorHideUIButton.OnClick);
		
		-- Register addon prefix for receiving team data broadcasts:
		local success = RegisterAddonMessagePrefix("ALSPEC");
		if ( not success ) then
			ArenaLive:Message(L["WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session."], "message");
		end
		
		ArenaLive:Message(L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."], "message");
	elseif ( event == "AL_SPEC_MATCH_START" ) then
		-- Iterate through all callback functions that have registered for match start:
		for callbackFunc in pairs(onMatchStartCallbackList) do
			callbackFunc();
			onMatchStartCallbackList[callbackFunc] = nil;
		end
	-- elseif ( event == "BN_FRIEND_TOON_ONLINE" or event == "BN_TOON_NAME_UPDATED" or event == "BN_FRIEND_TOON_OFFLINE" or event == "BN_FRIEND_LIST_SIZE_CHANGED" ) then
		-- -- BN_TOON_NAME_UPDATED: Args seem to be: toonID, toonName, unknown(boolean)
		-- self.NicknameDatabase:OnToonNameUpdate(filter);
		-- ArenaLiveSpectatorWarGameMenu:BNFriendEvent();
	-- elseif ( event == "CHAT_MSG_ADDON" and filter == "ALSPEC" ) then
		-- local prefix, message, channel, sender = ...;
		-- local playerName = GetUnitName("player", true);
		-- if ( sender == playerName) then
			-- return;
		-- end
		-- local leftTeamName, leftTeamScore, rightTeamName, rightTeamScore = string.split(";", message);
		-- ArenaLive:Message(L["Received team data from group leader (%s). Updating team entries..."], "message", sender);
		
		-- local database = ArenaLive:GetDBComponent(addonName);
		-- database.TeamA.Name = leftTeamName;
		-- database.TeamA.Score = tonumber(leftTeamScore);
		-- database.TeamB.Name = rightTeamName;
		-- database.TeamB.Score = tonumber(rightTeamScore);
		
		-- -- Update option frames:
		-- ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamName:UpdateShownValue();
		-- ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamScore:UpdateShownValue();
		-- ArenaLiveSpectatorWarGameMenuWarGamesRightTeamName:UpdateShownValue();
		-- ArenaLiveSpectatorWarGameMenuWarGamesRightTeamScore:UpdateShownValue();
		
		-- -- Update scoreboard display:
		-- ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamA");
		-- ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
		-- ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamB");
		-- ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED" and self.enabled ) then
		ArenaLiveSpectatorMatchStatistic:OnEvent(event, ...)
	--elseif ( event == "COMMENTATOR_PLAYER_UPDATE" ) then
		-- "COMMENTATOR_PLAYER_UPDATE" fires a bit too early,
		-- I use the new C_Timer to wait 2 seconds, before
		-- updating the side frames and cooldown trackers 
		-- after the event fires. This way all player 
		-- information should available.
		-- C_Timer.After(2, ArenaLiveSpectator.PlayerUpdate);
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		ArenaLiveSpectator:Toggle();
		-- if ( self.waitForNicknameInit and BNFeaturesEnabled() and BNConnected() ) then
			-- self.waitForNicknameInit = nil;
			-- self.NicknameDatabase:InitialiseNicknames();
		-- end
	elseif ( event == "PLAYER_TARGET_CHANGED" and self.enabled ) then
		if ( self.enabled ) then
			local database = ArenaLive:GetDBComponent(addonName);
			if ( database.FollowTarget ) then
				--CommentatorFollowUnit("target"); DeadMouse
			end
			if ( database.HideTargetFrames or database.PlayMode > 3 ) then
				for i = 1, database.PlayMode do
					local frame = _G["ALSPEC_LeftSideFramesFrame"..i];
					ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
					frame = _G["ALSPEC_RightSideFramesFrame"..i];
					ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
				end
			end
		end
    
    elseif ((event == "CHAT_MSG_ADDON") and (filter == "ARENASPEC") and (arg3 == "WHISPER") and arg2) then
        if not self.enabled then
            CommandHandler:ForceUpdate();
            ArenaLive:TriggerEvent("AL_SPEC_MATCH_START");
        end
        self.hasStarted = true;
        
        CommandHandler:ParseCommands(arg2);
        
        ArenaLiveSpectator:PlayerUpdate();
    elseif ( event == "START_TIMER" and filter == 1 and self.enabled ) then
		local _, timeSeconds, totalTime = ...;
		ArenaLiveSpectatorCountDown:SetTimer(timeSeconds, totalTime);
	elseif ( event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" ) then
		local screenHeight = math.ceil(GetScreenHeight());
		local scale = 786 / screenHeight;
		ArenaLiveSpectatorTooltip:SetScale(scale);
	elseif ( event == "UNIT_PET" or event == "UNIT_AURA" ) then
		ArenaLiveSpectatorMatchStatistic:OnEvent(event, ...);
	-- elseif ( event == "UPDATE_BATTLEFIELD_STATUS" and self.enabled ) then
		
		-- local status, mapName, teamSize, registeredMatch, suspendedQueue, queueType, gameType, role = GetBattlefieldStatus(filter);
		-- local winner = GetBattlefieldWinner();
		-- if ( status == "active" and winner ) then
			-- -- Update team scores according to winner:
			-- local database = ArenaLive:GetDBComponent(addonName);
			-- if ( winner == 0 ) then
				-- database.TeamB.Score = database.TeamB.Score + 1;
			-- elseif ( winner == 1 ) then
				-- database.TeamB.Score = database.TeamA.Score + 1;
			-- elseif ( winner == 255 ) then
				-- database.TeamA.Score = database.TeamA.Score + 1;
				-- database.TeamB.Score = database.TeamB.Score + 1;
			-- end
			
			-- ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
			-- ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
			-- ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamScore:UpdateShownValue();
			-- ArenaLiveSpectatorWarGameMenuWarGamesRightTeamScore:UpdateShownValue();
			
			-- -- Stop Recording Match Statistic and Show it:
			-- ArenaLiveSpectatorMatchStatistic:Stop();
			-- ArenaLiveSpectatorMatchStatistic:Open(true);
		-- end
	elseif ( event == "WORLD_STATE_UI_TIMER_UPDATE" and self.enabled ) then
		if ( ArenaLiveSpectatorScoreBoard.enabled ) then
			if ( not self.worldStateTimerIndex ) then
				for index = 1, GetNumWorldStateUI() do
					local uiType = GetWorldStateUIInfo(index);
					if ( uiType == 3 ) then -- 3 seems to be the identifier for timers.
						self.worldStateTimerIndex = index;
						break;
					end
				end
			end
			
			if ( self.worldStateTimerIndex ) then
				local uiType, state, _, text = GetWorldStateUIInfo(self.worldStateTimerIndex);
				local minutes, seconds = string.match(text,("([0-9]+):([0-9]+)$"));
				
				local minNum, secNum = tonumber(minutes), tonumber(seconds);
				if ( minNum + secNum > 0 and not self.hasStarted ) then
					ArenaLive:TriggerEvent("AL_SPEC_MATCH_START");
					self.hasStarted = true;
				end
				
				if ( state ) then
					ArenaLiveSpectatorScoreBoard:UpdateTimer(minutes, seconds)
				else
					ArenaLiveSpectatorScoreBoard:UpdateTimer("00", "00")
				end
			end
		end
	end
end

function ArenaLiveSpectator:HasMatchStarted()
	return self.hasStarted;
end

function ArenaLiveSpectator:CallOnMatchStart(callbackFunc)
	if ( not self.hasStarted ) then
		onMatchStartCallbackList[callbackFunc] = true;
	else
		callbackFunc();
	end
end

function ArenaLiveSpectator:Toggle()
	local inInstance, instanceType = IsInInstance();
	if ( instanceType == "arena" and IsSpectator() ) then
		ArenaLiveSpectator:Enable();
	else
		ArenaLiveSpectator:Disable();
	end
end

function ArenaLiveSpectator:PlayerUpdate()
	ArenaLiveSpectator:RefreshGUIDs();
	ArenaLiveSpectator:UpdateSideFrames();
	ArenaLiveSpectator:UpdateCooldownTrackers();
end

function ArenaLiveSpectator:SetNumPlayers(numPlayers)
	ArenaLiveSpectator:SetUpSideFrames(numPlayers);
	ArenaLiveSpectator:SetUpTargetFrames(numPlayers);
	ArenaLiveSpectator:SetUpCooldownTracker(numPlayers);
end

function ArenaLiveSpectatorHideUIButton:OnClick(button, down)
	if( ArenaLiveSpectator.enabled and button == "LeftButton" ) then
		UIParent:Hide();
	end
end

function ArenaLiveSpectator:UpdateDB()
	
	local database = ArenaLive:GetDBComponent(addonName);
	if ( not database.Version ) then
		database.version = nil;
		
		for frameGroup, frameGroupOptions in pairs(database) do
			if ( type(frameGroupOptions) == "table" ) then
				if ( type(frameGroupOptions.NameText) == "table" ) then
					database[frameGroup].NameText.Size = nil;
					database[frameGroup].NameText.FontObject = "ArenaLiveFont_Name";
				end
				
				if ( type(frameGroupOptions.HealthBarText) == "table" ) then
					database[frameGroup].HealthBarText.BarTextSize = nil;
					database[frameGroup].HealthBarText.FontObject = "ArenaLiveFont_StatusBarTextSmall";
				end
				
				if ( type(frameGroupOptions.PowerBarText) == "table" ) then
					database[frameGroup].PowerBarText.BarTextSize = nil;
					database[frameGroup].PowerBarText.FontObject = "ArenaLiveFont_StatusBarTextSmall";
				end
			end
		end
		
		database.Version = "3.0.0b";
	end
	
	if ( database.Version == "3.0.0b" ) then
	end
end

ArenaLive:ConstructAddon(ArenaLiveSpectator, addonName, true, ArenaLiveSpectator.defaults, false, "ALSPEC_Database");
ArenaLiveSpectator:RegisterEvent("AL_SPEC_MATCH_START"); -- Custom Event triggered by ArenaLiveSpectator:OnEvent() WORLD_STATE_UI_TIMER_UPDATE
ArenaLiveSpectator:RegisterEvent("ADDON_LOADED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_TOON_ONLINE");
ArenaLiveSpectator:RegisterEvent("BN_TOON_NAME_UPDATED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_TOON_OFFLINE");
ArenaLiveSpectator:RegisterEvent("CHAT_MSG_ADDON");
ArenaLiveSpectator:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
ArenaLiveSpectator:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");
ArenaLiveSpectator:RegisterEvent("DISPLAY_SIZE_CHANGED");
ArenaLiveSpectator:RegisterEvent("PLAYER_ENTERING_WORLD");
ArenaLiveSpectator:RegisterEvent("PLAYER_TARGET_CHANGED");
ArenaLiveSpectator:RegisterEvent("START_TIMER");
ArenaLiveSpectator:RegisterEvent("UI_SCALE_CHANGED");
ArenaLiveSpectator:RegisterEvent("UNIT_PET");
ArenaLiveSpectator:RegisterEvent("UNIT_AURA");
ArenaLiveSpectator:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE");
ArenaLiveSpectator:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");

local addonName, L = ...;

local nameAsterisk = FOREIGN_SERVER_LABEL
local deselect = GetCVar'deselectOnClick'
local cameraPos;

ArenaLiveSpectator.defaults = {
	["Broadcast"] = true,
	["FirstLogin"] = true,
	["FollowTarget"] = true,
	["HideTargetFrames"] = true,
	["PlayMode"] = 0,
	["ShowScoreBoard"] = true,
	["Version"] = "3.0.0c",
	["ImportantMessageFrame"] = {
		["NumMaxMessages"] = 2,
	},
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
};

-- Slash Commands:
SLASH_ARENALIVESPECTATOR1, SLASH_ARENALIVESPECTATOR2 = "/alspec", "/arenalivespectator";
function SlashCmdList.ARENALIVESPECTATOR (msg, editBox )
	if ( not msg or msg == "" or msg == "menu" ) then
		ArenaLiveSpectatorWarGameMenu:Show();
	elseif ( msg == "help" ) then
		ArenaLive:Message(L["Available Slash Commands for ArenaLive [Spectator] are:"], "message");
		for cmd, description in pairs(slashCMDs) do
			print(string.format(L["%s: %s"], cmd, description));
		end
	end
end

-- Custom function to check if player currently is a spectator.
function IsSpectator()
    return CommentatorGetMode() > 0;
end

local ScoreboardTimer = CreateFrame"Frame"
local TimeSinceLastUpdate = 0
ScoreboardTimer:SetScript("OnUpdate",function(self,elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	if TimeSinceLastUpdate >= 1 then
		TimeSinceLastUpdate = 0
		local mm,ss = 19-math.floor(GetBattlefieldInstanceRunTime()/1000/60),59-math.floor(GetBattlefieldInstanceRunTime()/1000%60)
		ArenaLiveSpectatorScoreBoard:UpdateTimer(mm,strlen(ss)==1 and'0'..ss or ss)
	end
end)
ScoreboardTimer:SetScript("OnShow", function(self)
	TimeSinceLastUpdate = 0
end)
ScoreboardTimer:Hide()

function ArenaLiveSpectator:Enable()
    -- Прячем отображение (*) на именах во фреймах указывающее на 
    --принадлежность к другому реалму
    -- TODO: опционально реализовать вместо (*) отображение реалма.
	if nameAsterisk ~= '' then FOREIGN_SERVER_LABEL='' end

	ArenaLiveSpectatorWarGameMenu:Hide();
	UIParent:Hide();
	self:Show();
	ScoreboardTimer:Show();

	ArenaLiveSpectatorHideUIButton:Show();
    ArenaLiveSpectator:PlayerUpdate();
	self.enabled = true;
    self.hasStarted = true;
	if ArenaLive:GetDBComponent(addonName).PlayMode > 0 then
		ArenaLiveSpectator:SetNumPlayers(ArenaLive:GetDBComponent(addonName).PlayMode)
	else
		ArenaLiveSpectator:SetNumPlayers(CommentatorGetMapInfo(1))
	end
end

function ArenaLiveSpectator:Disable()
    -- Возвращаем (*) на именах
	if FOREIGN_SERVER_LABEL == '' then FOREIGN_SERVER_LABEL=nameAsterisk end
    
    --[[Багфикс: когда игрок делает /reload на спектатор арене у игрока
    пропадает отображение панелей. Следующие строчки пофиксят это]]
    local bar1,bar2,bar3,bar4 = GetActionBarToggles()
    if bar1 and tonumber(SHOW_MULTI_ACTIONBAR_1) ~= bar1 then InterfaceOptionsActionBarsPanelBottomLeft:Click()end
    if bar2 and tonumber(SHOW_MULTI_ACTIONBAR_2) ~= bar2 then InterfaceOptionsActionBarsPanelBottomRight:Click()end
    if bar3 and tonumber(SHOW_MULTI_ACTIONBAR_3) ~= bar4 then InterfaceOptionsActionBarsPanelRight:Click()end
    if bar4 and tonumber(SHOW_MULTI_ACTIONBAR_4) ~= bar4 then InterfaceOptionsActionBarsPanelRightTwo:Click()end
	
	self:Hide();
	ScoreboardTimer:Hide();
	
	ArenaLiveSpectatorHideUIButton:Hide();
	UIParent:Show();
	
	ArenaLiveSpectatorScoreBoard:Reset();

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
        RegisterAddonMessagePrefix("ArenaLive");

		-- Initialise frames:
		self:InitialiseSideFrames();
		self:InitialiseTargetFrames();
		self:InitialiseCooldownTracker();
		ArenaLiveSpectatorScoreBoard:Initialise();
		ArenaLiveSpectatorWarGameMenu:Initialise();
		ArenaLive:ConstructHandlerObject(ArenaLiveSpectatorMessageFrame, "ImportantMessageFrame", addonName, nil)

		-- Set up hide normal UI button, it shows up if UIParent is somehow shown during a match:
		ArenaLiveSpectatorHideUIButtonText:SetText(L["Hide normal UI"]);
		local width = ArenaLiveSpectatorHideUIButtonText:GetWidth();
		width = width + 30;
		ArenaLiveSpectatorHideUIButton:SetWidth(width);
		ArenaLiveSpectatorHideUIButton:SetScript("OnClick", ArenaLiveSpectatorHideUIButton.OnClick);

		ArenaLive:Message(L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."], "message");
	elseif ( event == "COMMENTATOR_PLAYER_UPDATE" ) then
		-- "COMMENTATOR_PLAYER_UPDATE" fires a bit too early,
		-- I use the new C_Timer to wait 2 seconds, before
		-- updating the side frames and cooldown trackers 
		-- after the event fires. This way all player 
		-- information should available.
        if self.enabled == false then
            ArenaLiveSpectator:Enable();
        end
		DelayEvent(2, ArenaLiveSpectator.PlayerUpdate);
		cameraPos = {CommentatorGetCamera()};
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		ArenaLiveSpectator:Toggle();
	elseif ( event == "PLAYER_TARGET_CHANGED" and self.enabled ) then
		if ( self.enabled ) then
			local database = ArenaLive:GetDBComponent(addonName);
			if ( database.FollowTarget ) then
				local teamId, playerId = 1, 1
				if UnitIsPlayer("target") then
					for j=1,2 do
						for i=1, database.PlayMode do
							if CommentatorGetPlayerInfo(j,i) == UnitName("target")then
								teamId, playerId = j, i
								break
							end
						end
					end
					CommentatorFollowPlayer(teamId, playerId)
					ClearInspectPlayer()
					NotifyInspect('target')
				elseif not UnitExists ("target") then
					ClearInspectPlayer()
					CommentatorFollowPlayer(1,0) -- stop following
					CommentatorLookatPlayer(1,0) -- stop looking
					CommentatorSetCamera(unpack(cameraPos))
				end
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
	elseif ( event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" ) then
		local screenHeight = math.ceil(GetScreenHeight());
		local scale = 786 / screenHeight;
		ArenaLiveSpectatorTooltip:SetScale(scale);
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
	local _, instanceType = IsInInstance();
	if ( instanceType == "arena" and IsSpectator() ) then
		ArenaLiveSpectator:Enable();
        CommentatorToggleMode();
	else
		ArenaLiveSpectator:Disable();
		DelayEvent(1,function()WorldStateAlwaysUpFrame:Show()ConsoleExec("deselectOnClick "..deselect)end)
	end
end

function ArenaLiveSpectator:PlayerUpdate()
    ArenaLiveSpectator:RefreshGUIDs();
	ArenaLiveSpectator:UpdateSideFrames();
	ArenaLiveSpectator:UpdateCooldownTrackers();
end

function ArenaLiveSpectator:SetNumPlayers(numPlayers)
	ArenaLive:GetDBComponent(addonName).PlayMode = numPlayers
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
		
		database.Version = "3.0.0c";
	end
	
	if ( database.Version == "3.0.0c" ) then
		if not database.ImportantMessageFrame then 
			database['ImportantMessageFrame']=ArenaLiveSpectator.defaults.ImportantMessageFrame
		end
	end
end

function ArenaLiveSpectator:ValueToBoolean(value)
    if value then
        return true;
    else
        return nil;
    end
end

ArenaLive:ConstructAddon(ArenaLiveSpectator, addonName, true, ArenaLiveSpectator.defaults, false, "ALSPEC_Database");
ArenaLiveSpectator:RegisterEvent("ADDON_LOADED");
ArenaLiveSpectator:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
-- ArenaLiveSpectator:RegisterEvent("COMMENTATOR_MAP_UPDATE");
ArenaLiveSpectator:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");
ArenaLiveSpectator:RegisterEvent("DISPLAY_SIZE_CHANGED");
ArenaLiveSpectator:RegisterEvent("PLAYER_ENTERING_WORLD");
ArenaLiveSpectator:RegisterEvent("PLAYER_TARGET_CHANGED");
ArenaLiveSpectator:RegisterEvent("UI_SCALE_CHANGED");
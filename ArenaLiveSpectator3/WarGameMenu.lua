local addonName, L = ...;

local OPTION_ITEMS_SETTINGS = {
	["ShowScoreBoard"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsGeneralTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Enable Scoreboard"],
		["tooltip"] = L["If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.ShowScoreBoard; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.ShowScoreBoard = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) ArenaLiveSpectatorScoreBoard:Toggle(); end
	},
	["FollowTarget"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsFollowTargetCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 10,
		["yOffset"] = -2,
		["title"] = L["Follow Target"],
		["tooltip"] = L["If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.FollowTarget; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.FollowTarget = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) if ( newValue ) then SendChatMessage(".spec view " .. UnitName"target", "EMOTE"); else SendChatMessage(".spec view " .. UnitName"player", "EMOTE"); end end,
		--CommentatorFollowUnit("target"); else CommentatorFollowUnit(); end end,
	},
	["DisableTargetFrames"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsTargetFramesTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Disable"],
		["tooltip"] = L["If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.HideTargetFrames; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.HideTargetFrames = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon); ArenaLiveSpectator:SetNumPlayers(database.PlayMode); end,
	},
	["EnableTargetFrameCastBar"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Castbar"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "TargetTargetFrame"); database.Enabled = newValue; ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetFrame); ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetTargetFrame); end,
	},
	["EnableTargetFrameCastHistory"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastHistoryCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Casthistory"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "TargetTargetFrame"); database.Enabled = newValue; ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetFrame); ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetTargetFrame); end,
	},
	["EnableSideFrameCastBar"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsSideFramesTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Enable Castbar"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.Enabled = newValue; ArenaLiveSpectator:UpdateAllSideFrameConstituents() end,
	},
	["EnableSideFrameCastHistory"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastHistoryCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Casthistory"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.Enabled = newValue; ArenaLiveSpectator:UpdateAllSideFrameConstituents() end,
	},
	["ShowCDTrackerTooltip"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsShowCDTrackerTooltipCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsCooldownTrackerTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Show Tooltip"],
		["tooltip"] = L["If enabled, spell tooltips will be shown when moving the mouse over a cooldown button."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.ShowTooltip; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.ShowTooltip = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.ShowTooltip = newValue; end,
	},
	["ShowCDText"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsShowCDTextCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsShowCDTrackerTooltipCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Show Cooldown Text"],
		["tooltip"] = L["Shows a timer text for cooldowns. Disable this to enable support for cooldown count addons."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, "Cooldown"); return database.ShowText; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, "Cooldown"); database.ShowText = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler); database.ShowText = newValue; ArenaLive:GetHandler('Cooldown').optionSets.ShowText:postUpdate(frame, newValue, oldValue)ReloadUI() end,
	},
};

function ArenaLiveSpectatorWarGameMenu:Initialise()
	local database = ArenaLive:GetDBComponent(addonName);
	
	-- Setup frame appearance:
	ArenaLiveSpectatorWarGameMenuTitleText:SetText(string.format(L["ArenaLive [Spectator] %s"], database.Version));
	self.portrait:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\WarGameMenuPortrait");
	
	-- Setup General Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["ShowScoreBoard"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["FollowTarget"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsFollowTargetCheckButtonText:SetTextColor(1,1,1);	
	
	-- Setup Target Frames' Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["DisableTargetFrames"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButtonText:SetTextColor(1,1,1);	
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableTargetFrameCastBar"], addonName, "CastBar", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableTargetFrameCastHistory"], addonName, "CastHistory", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastHistoryCheckButtonText:SetTextColor(1,1,1);	
	
	-- Setup Side Frames'  Option Frames:
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableSideFrameCastBar"], addonName, "CastBar", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableSideFrameCastHistory"], addonName, "CastHistory", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastHistoryCheckButtonText:SetTextColor(1,1,1);
	
	-- Setup Cooldown Tracker Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["ShowCDTrackerTooltip"], addonName, "CooldownTracker", "Left");
	ArenaLiveSpectatorWarGameMenuSettingsShowCDTrackerTooltipCheckButtonText:SetTextColor(1,1,1);
	
	-- Setup Cooldown Text Showing Option Frames:
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["ShowCDText"], addonName, "Cooldown", "ShowText");
	ArenaLiveSpectatorWarGameMenuSettingsShowCDTextCheckButtonText:SetTextColor(1,1,1);
	
	-- Set Scripts:
	self:RegisterForClicks("LeftButtonUp");
	self:SetScript("OnShow", self.OnShow);
	self:SetScript("OnHide", self.OnHide);
	self:SetScript("OnClick", self.OnClick);
end

function ArenaLiveSpectatorWarGameMenu:InitialiseButton(button, text, onClick)
	button:SetText(text);
	
	local prefix = button:GetName();
	local buttonText = _G[prefix.."Text"];
	if ( buttonText ) then
		local width = buttonText:GetWidth() + 40;
		button:SetWidth(width);
	end
	
	button:RegisterForClicks("LeftButtonUp");
	button:SetScript("OnClick", onClick or button.OnClick);
end

function ArenaLiveSpectatorWarGameMenu:OnShow()
	-- Close Match Statistic:
	PlaySound("igCharacterInfoOpen");
end

function ArenaLiveSpectatorWarGameMenu:OnHide()
	PlaySound("igCharacterInfoClose");
end
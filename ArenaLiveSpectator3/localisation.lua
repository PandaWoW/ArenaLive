local addonName, L = ...;

L["ArenaLive [Spectator] %s"] = "ArenaLive [Spectator] %s";

L["Hide normal UI"] = "Hide normal UI";

L["Sending inspect query for %s (%s)..."] = "Sending inspect query for %s (%s)...";
L["Inspect data received for %s..."] = "Inspect data received for %s...";
L["CheckInteractDinstance: %s; CanInspect: %s"] = "CheckInteractDinstance: %s; CanInspect: %s";
L["Gather Cooldown info for %s: GUID = %s, isPlayer = %s, isInspectReady = %s."] = "Gather Cooldown info for %s: GUID = %s, isPlayer = %s, isInspectReady = %s.";
L["Hiding CooldownTracker's handler frame..."] = "Hiding CooldownTracker's handler frame...";

L["CooldownTracker:RegisterUnit(): Usage CooldownTracker:RegisterUnit(unit)"] = "CooldownTracker:RegisterUnit(): Usage CooldownTracker:RegisterUnit(unit)";
L["CooldownTracker:UnregisterUnit(): Usage CooldownTracker:UnregisterUnit(unit)"] = "CooldownTracker:UnregisterUnit(): Usage CooldownTracker:UnregisterUnit(unit)";

L["MainTargetIndicator:UpdateMainTarget(): Usage MainTargetIndicator:UpdateMainTarget(team)"] = "MainTargetIndicator:UpdateMainTarget(): Usage MainTargetIndicator:UpdateMainTarget(team)";

L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."] = "Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands.";

L["Available Slash Commands for ArenaLive [Spectator] are:"] = "Available Slash Commands for ArenaLive [Spectator] are:";
L["Shows this info message."] = "Shows this info message.";
L["Shows the War Game Menu"] = "Shows the War Game Menu";
L["Shows the Match Statistic"] = "Shows the Match Statistic";
L["%s: %s"] = "%s: %s";


-- Broadcasting Feature:
L["Broadcast Team Data"] = "Broadcast Team Data";
L["If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game."] = "If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game.";
L["Sending team data to raid..."] = "Sending team data to raid...";
L["Received team data from group leader (%s). Updating team entries..."] = "Received team data from group leader (%s). Updating team entries...";
L["WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session."] = "WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session.";

-- Settings Tab:
L["Settings"] = "Settings";

	-- Arena Drop Down:
	L["Arena:"] = "Arena:";
	L["Choose the arena the war game will take place on."] = "Choose the arena the war game will take place on.";

		-- Arena Names:
		L["Blade's Edge Arena"] = "Blade's Edge Arena";
		L["Dalaran Sewers"] = "Dalaran Sewers";
		L["Nagrand Arena"] = "Nagrand Arena";
		L["Ruins of Lordaeron"] = "Ruins of Lordaeron";
		L["The Tiger's Peak"] = "The Tiger's Peak";
		L["Tol'Viron Arena"] = "Tol'Viron Arena";
		L["All Arenas"] = "All Arenas";

	-- Play Mode DropDown:
	L["Bracket:"] = "Bracket:";
	L["Choose the number of players per team."] = "Choose the number of players per team.";
	L["2v2"] = "2v2";
	L["3v3"] = "3v3";
	L["5v5"] = "5v5";

	-- Unit Frame Options:
	L["Disable"] = "Disable";
	L["If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead."] = "If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead.";
	L["Enable Castbar"] = "Enable Castbar";
	L["Enable Casthistory"] = "Enable Casthistory";

-- Spectated War Games Tab:
L["Spectated War Games"] = "Spectated War Games";

	-- Nickname Database:
	L["Nicknames:"] = "Nicknames:";
	L["No Nickname Assigned"] = "No Nickname Assigned";
	L["Reset Nickname"] = "Reset Nickname";
	L["Current Player:"] = "Current Player:";
	L["Player Nickname:"] = "Player Nickname:";
	L["Clear Database"] = "Clear Database";
	L["Clearing the nickname database will delete all player nicknames. Do you want to proceed?"] = "Clearing the nickname database will delete all player nicknames. Do you want to proceed?";
	
	-- Cooldowntracker Options:
	L["Show Tooltip"] = "Show Tooltip";
	L["If enabled, spell tooltips will be shown when moving the mouse over a cooldown button."] = "If enabled, spell tooltips will be shown when moving the mouse over a cooldown button.";
	
	-- Team Leader Button:
	L["Team Leader:"] = "Team Leader:";
	L["Choose a Player"] = "Choose a Player";
	L["Drag from the player list"] = "Drag and drop here";
	L["Not logged into WoW"] = "Not logged into WoW";
	L["Offline"] = "Offline";

	-- Tournament Rules Checkbutton:
	L["Tournament Rules"] = "Tournament Rules";
	L["If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled."] = "If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled.";

	-- Team Name Editbox:
	L["Team Name:"] = "Team Name:";
	L["Enter the name of the team. The name will be shown on the scoreboard and on the match statistic."] = "Enter the name of the team. The name will be shown on the scoreboard and on the match statistic.";

	-- Team Score Editbox:
	L["Score:"] = "Score:";
	L["Enter the score of the team. It will be shown on the scoreboard."] = "Enter the score of the team. It will be shown on the scoreboard.";

	-- War Game Queue Button:
	L["Start Spectated War Game"] = "Start Spectated War Game";	
	
-- Scoreboard:
L["Enable Scoreboard"] = "Enable Scoreboard";
L["If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches."] = "If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches.";
L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""] = "%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\"";

-- Third Person Player View:
L["Follow Target"] = "Follow Target";
L["If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client."] = "If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client.";

-- Countdown statusbar text:
L["%d:%d"] = "%d:%d";

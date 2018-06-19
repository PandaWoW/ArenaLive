local addonName, L = ...;
local DAMPENING_STACK_TIMER = 10; -- "If a match should last for 5 minutes, all players in the Arena will begin to receive a stacking debuff that reduces healing done by 1% every 10 seconds."

function ArenaLiveSpectatorScoreBoard:Initialise()
	local database = ArenaLive:GetDBComponent(addonName);
	local teamAr, teamAg, teamAb = unpack(database.TeamA.Colour);
	local teamBr, teamBg, teamBb = unpack(database.TeamB.Colour);
	
	self.leftTeam.group = "TeamA";
	self.rightTeam.group = "TeamB";
	
	-- Set Team Colours:
	self.scoreLeft:SetTextColor(teamAr, teamAg, teamAb);
	self.leftTeam.name:SetTextColor(teamAr, teamAg, teamAb);
	self.scoreRight:SetTextColor(teamBr, teamBg, teamBb);
	self.rightTeam.name:SetTextColor(teamBr, teamBg, teamBb);
	
	-- Set Texts:
	ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamA");
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
	ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamB");
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
	
	-- Set Scripts:
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnPlay", self.OnAnimationPlay);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnFinished", self.OnAnimationFinished);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnStop", self.OnAnimationFinished);
	
	-- Toggle scoreboard:
	ArenaLiveSpectatorScoreBoard:Toggle();
end

function ArenaLiveSpectatorScoreBoard:Toggle()
	local database = ArenaLive:GetDBComponent(addonName);
	if ( database.ShowScoreBoard ) then
		self.enabled = true;
		self:Show();
	else
		self.enabled = false;
		self:Hide();
	end
end

function ArenaLiveSpectatorScoreBoard:Reset()
	self.timer:SetText("00:00");
	ArenaLiveSpectatorScoreBoardDampeningIndicator:Reset();
end

function ArenaLiveSpectatorScoreBoard:UpdateTeamName(team)
	local frame;
	if ( team == "TeamA" ) then
		frame = self.leftTeam;
	elseif ( team == "TeamB" ) then
		frame = self.rightTeam;
	else
		ArenaLive:Message(L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""], "error", "ArenaLiveSpectatorScoreBoard:UpdateTeamName()", team);
	end
	
	if ( frame ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, team);
		frame.name:SetText(database.Name);
	end
end

function ArenaLiveSpectatorScoreBoard:UpdateTeamScore(team)
	local text;
	if ( team == "TeamA" ) then
		text = self.scoreLeft;
	elseif ( team == "TeamB" ) then
		text = self.scoreRight;
	else
		ArenaLive:Message(L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""], "error", "ArenaLiveSpectatorScoreBoard:UpdateTeamName()", team);
	end
	
	if ( text ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, team);
		text:SetText(database.Score);
	end
end

function ArenaLiveSpectatorScoreBoard:OnAnimationPlay()
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:Show();
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.text:Show();
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:SetAlpha(0);
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.text:SetAlpha(1);
end

function ArenaLiveSpectatorScoreBoard:OnAnimationFinished(animation)
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.vs:SetAlpha(0);
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:SetAlpha(1);
end

function ArenaLiveSpectatorScoreBoard:UpdateTimer(minutes, seconds)
	if ( not minutes or not seconds ) then
		return;
	end
	
	self.timer:SetText(minutes..":"..seconds);
	
	local numberMin, numberSec = tonumber(minutes), tonumber(seconds);

	if ( numberMin < 15 and ArenaLiveSpectator:HasMatchStarted() ) then
		ArenaLiveSpectatorScoreBoardDampeningIndicator:Update(numberMin, numberSec);
	end
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:Update(minutes, seconds)
	local totalTime = 20;
	local minutes = totalTime - minutes;
	if ( minutes >= 5 ) then
		seconds = 60 - seconds;
		minutes = minutes - 6; -- -6 because the first minute would be counted two times with minutes + seconds
		if ( minutes > 0 ) then
			local minToSec = minutes * 60;
			seconds = seconds + minToSec;
		end
		
		local stacks = tostring(( 1 + math.floor(seconds / 10 ) ));
		if ( not self.icon:IsShown() ) then
			self.anim:Play();
		end
		
		self.text:SetText(stacks.."%");
	end
	
	
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:Reset()
	self.icon:SetAlpha(0);
	self.icon:Hide();
	
	self.text:SetAlpha(0);
	self.text:Hide();
	
	self.vs:SetAlpha(1);
	self.vs:Show();
end


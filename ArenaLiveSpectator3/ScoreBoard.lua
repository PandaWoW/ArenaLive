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
		
		local stacks = tostring(( math.floor(seconds / 10 ) ));
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

local BootsIcon = [[Interface\MINIMAP\TRACKING\FlightMaster]]
local CogwheelIcon = [[Interface\HELPFRAME\HelpIcon-CharacterStuck]]--[[Interface\Scenarios\ScenarioIcon-Interact]]
local QuestionIcon = [[Interface\RAIDFRAME\ReadyCheck-Waiting]]
local CheckIcon = [[Interface\RAIDFRAME\ReadyCheck-Ready]] -- or Scenarios\ScenarioIcon-Check
local RestoreIcon = [[Interface\Glues\CharacterSelect\RestoreButton]]
local CrossIcon = [[Interface\RAIDFRAME\ReadyCheck-NotReady]] -- or Scenarios\ScenarioIcon-Fail
--PaperDollInfoFrame\UI-GearManager-Undo

--Interface\TAXIFRAME\
--UI-Taxi-Icon-White x1
--UI-Taxi-Icon-Green x1.5
--UI-Taxi-Icon-Yellow x2
--UI-Taxi-Icon-Highlight x3
--UI-Taxi-Icon-Red x5

-- Change speed button
local speeds = {'1','1.5','2','3','5'}
local SpeedFrame = CreateFrame('Button','SpeedFrame',ArenaLiveSpectatorScoreBoard)
SpeedFrame:SetSize(22,22)
SpeedFrame:SetPoint('CENTER',ArenaLiveSpectatorScoreBoard.timer,-48,0)
SpeedFrame:SetNormalFontObject(GameFontGreenLarge)
SpeedFrame:SetText(SpeedFrame:GetText()or'x1')
SpeedFrame:SetScript('OnShow',function(self)
	self:SetText('x1')
	self:SetID(1)
end)
SpeedFrame:RegisterForClicks("AnyUp")
SpeedFrame:SetScript('OnClick',function(self, button)
	self:SetID((self:GetID() or 1) + 1)
	if speeds[self:GetID()]and button~='RightButton' then
		self:SetText('x'..speeds[self:GetID()])
	else
		self:SetID(1)
		self:SetText('x1')
	end
	SendChatMessage('.sp sp '..speeds[self:GetID()],'EMOTE')
end)

local SpeedFrameIcon = SpeedFrame:CreateTexture(nil,"BACKGROUND")
SpeedFrameIcon:SetTexture(BootsIcon)
SpeedFrameIcon:SetPoint("TOPLEFT",0,0)
SpeedFrameIcon:SetPoint("BOTTOMRIGHT",0,0)

-- Fix cooldowns button
local FixCooldownFrame = CreateFrame('Button','FixCooldownFrame',ArenaLiveSpectatorScoreBoard)
FixCooldownFrame:SetSize(32,32)
FixCooldownFrame:SetPoint('CENTER',ArenaLiveSpectatorScoreBoard.timer,45,0)
--FixCooldownFrame:SetPoint('CENTER',ALSPEC_CDTrackersLeft,0,-GetScreenHeight()/2+116)
FixCooldownFrame:SetFrameStrata'LOW'
FixCooldownFrame:SetScript('OnClick',function(self)
	FixCooldownFrames()
end)
local FixCooldownFrameIcon = FixCooldownFrame:CreateTexture(nil,"BACKGROUND")
FixCooldownFrameIcon:SetTexture(CogwheelIcon)
FixCooldownFrameIcon:SetPoint("TOPLEFT",0,0)
FixCooldownFrameIcon:SetPoint("BOTTOMRIGHT",0,0)

-- Leave button
local LeaveButton = CreateFrame('Button','LeaveButton',ArenaLiveSpectatorScoreBoard)
LeaveButton:SetSize(28,28)
LeaveButton:SetPoint('CENTER',ArenaLiveSpectatorScoreBoard.timer,0,-20)
LeaveButton:SetFrameStrata'LOW'
LeaveButton:SetNormalFontObject(GameFontHighlightSmallOutline)
LeaveButton:SetText(L['Leave']or'Leave')
LeaveButton:SetScript('OnClick',function(self)
	SendChatMessage('','AFK')--since LeaveBattlefield() is bugged we will use dirty /afk command :(
end)
local LeaveButtonIcon = LeaveButton:CreateTexture(nil,"BACKGROUND")
LeaveButtonIcon:SetTexture(CrossIcon)
LeaveButtonIcon:SetPoint("TOPLEFT",0,0)
LeaveButtonIcon:SetPoint("BOTTOMRIGHT",0,0)

-- Reset\Hide player button (via Left or Right button)
local ResetHidePlayer = CreateFrame('Button','ResetHidePlayer',ArenaLiveSpectatorScoreBoard)
ResetHidePlayer:SetSize(28,28)
ResetHidePlayer:SetPoint('CENTER',ArenaLiveSpectatorScoreBoard.timer,-66,0)
ResetHidePlayer:RegisterForClicks("AnyUp")
-- ResetHidePlayer:SetScript('OnHide',function(self)
	-- ConsoleExec'ShowPlayer'
-- end)
ResetHidePlayer:SetScript('OnClick',function(self,button)
	if button == 'RightButton' then
		-- ConsoleExec'ShowPlayer' -- experimental
	else
		SendChatMessage('.sp vi '..UnitName'player','EMOTE')
	end
end)
local ResetHidePlayerIcon = ResetHidePlayer:CreateTexture(nil,"BACKGROUND")
ResetHidePlayerIcon:SetTexture(RestoreIcon)
ResetHidePlayerIcon:SetPoint("TOPLEFT",0,0)
ResetHidePlayerIcon:SetPoint("BOTTOMRIGHT",0,0)
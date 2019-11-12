local SpiritHealerFrame = ArenaLive:ConstructHandler("SpiritHealerFrame", true, true);
SpiritHealerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
SpiritHealerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED"); --SpiritHealerFrame:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");

local playerStates = {};

local function OnAnimStop(animation)
	local frame = animation:GetParent();
	frame.flash:Hide();
end

function SpiritHealerFrame:ConstructObject(spiritHealerFrame)
	spiritHealerFrame.fadeOutAnim:SetScript("OnFinished", OnAnimStop);
	spiritHealerFrame.fadeOutAnim:SetScript("OnStop", OnAnimStop);
end

function SpiritHealerFrame:UpdateNumPlayers()
	local numTeamA = CommentatorGetNumPlayers(2);
	local numTeamB = CommentatorGetNumPlayers(1);
	local deadCountA, deadCountB = 0, 0;
	
	for i = 1, 5 do
		local unit = "commentator"..i;
		if ( i <= numTeamA ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
			SpiritHealerFrame:CallUpdateForUnit(unit)
		else
			playerStates[unit] = nil;
		end
		if playerStates[unit] then deadCountA = deadCountA + 1 end;
		
		unit = "commentator"..5+i;
		if ( i <= numTeamB ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
			SpiritHealerFrame:CallUpdateForUnit(unit)
		else
			playerStates[unit] = nil;
		end
		if playerStates[unit] then deadCountB = deadCountB + 1 end;
	end
	ArenaLive:GetDBComponent("ArenaLiveSpectator3", nil, "TeamA").Score = numTeamA - deadCountA;
	ArenaLive:GetDBComponent("ArenaLiveSpectator3", nil, "TeamB").Score = numTeamB - deadCountB;
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
	deadCountA, deadCountB = 0, 0;
end

function SpiritHealerFrame:Update(unitFrame)
	local unit = unitFrame.unit;
	local frame = unitFrame[self.name];
	
	if ( not unit or not playerStates[unit] ) then
		self:Reset(unitFrame);
	elseif ( not frame:IsShown() ) then
		frame:Show();
		frame.flash:SetAlpha(1);
		frame.flash:Show();
		frame.texture:Show();
		frame.fadeOutAnim:Play();
		unitFrame.dead = playerStates[unit];
	end
end

function SpiritHealerFrame:Reset(unitFrame)
	local unit = unitFrame.unit;
	local frame = unitFrame[self.name];
	
	if ( frame.fadeOutAnim:IsPlaying() ) then
		frame.fadeOutAnim:Stop();
	end
	
	unitFrame.dead = nil;
	frame:Hide();
end

function SpiritHealerFrame:OnEvent(event, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		SpiritHealerFrame:UpdateNumPlayers()
	else
		if not destGUID or destGUID == "" or -- If there isn't a valid destination GUID
		(bit.band(tonumber(destGUID:sub(5, 5), 16), 0x7) ~= 0x0) -- Or the destination unit isn't a player
		then return end
		
		local _, overkill
		if eventType == "SWING_DAMAGE" then
			_, overkill = ...
		elseif eventType:find("_DAMAGE", 1, true) and not eventType:find("_DURABILITY_DAMAGE", 1, true) then
			_, _, _, _, overkill = ...
		end
		-- 5384 feign death
		-- 47788 guardian spirit
		if overkill and overkill > 0 then
			DelayEvent(0.5, SpiritHealerFrame.UpdateNumPlayers)
		end
	end
end

function SpiritHealerFrame:CallUpdateForUnit(unit)
	if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame and unitFrame[self.name] ) then
				self:Update(unitFrame);
			end
		end
	end
end
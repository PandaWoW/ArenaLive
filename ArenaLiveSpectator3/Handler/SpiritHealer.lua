local SpiritHealerFrame = ArenaLive:ConstructHandler("SpiritHealerFrame", true, true);
SpiritHealerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
SpiritHealerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED"); --SpiritHealerFrame:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");

 playerStates = {};

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
	
	for i = 1, 5 do
		local unit = "commentator"..i;
		if ( i <= numTeamA ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
			SpiritHealerFrame:CallUpdateForUnit(unit)
		else
			playerStates[unit] = nil;
		end
		
		unit = "commentator"..5+i;
		if ( i <= numTeamB ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
			SpiritHealerFrame:CallUpdateForUnit(unit)
		else
			playerStates[unit] = nil;
		end
	end
		
	-- Show/Hide frame to enable/disable OnUpdate script;
	-- if ( numTeamA > 0 or numTeamB > 0 ) then
		-- self:Show();
	-- else
		-- self:Hide();
	-- end
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
	end
end

function SpiritHealerFrame:Reset(unitFrame)
	local unit = unitFrame.unit;
	local frame = unitFrame[self.name];
	
	if ( frame.fadeOutAnim:IsPlaying() ) then
		frame.fadeOutAnim:Stop();
	end
	
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
		if eventType == "PARTY_KILL" or overkill and overkill > 0 then
			DelayEvent(0.5,SpiritHealerFrame.UpdateNumPlayers)
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
--[[
local THROTTLE, elapsedTilNow = 0.1, 0;
function SpiritHealerFrame:OnUpdate(elapsed)
	elapsedTilNow = elapsedTilNow + elapsed;
	if ( elapsedTilNow >= THROTTLE ) then
		elapsedTilNow = 0;
		for unit, isDeadOrGhost in pairs(playerStates) do
			local name = GetSpellInfo(5384)
			local feignDeath = UnitBuff(unit, name);
			local newState = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit) and not feignDeath);
			if ( newState ~= isDeadOrGhost ) then
				playerStates[unit] = newState;
				SpiritHealerFrame:CallUpdateForUnit(unit);
			end
		end
	end
end

SpiritHealerFrame:SetScript("OnUpdate", SpiritHealerFrame.OnUpdate);]]
local SpiritHealerFrame = ArenaLive:ConstructHandler("SpiritHealerFrame", true, true);
SpiritHealerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
SpiritHealerFrame:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");

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
	local numTeamA = ArenaLiveSpectator:GetNumPlayersInTeam("raid");
	local numTeamB = ArenaLiveSpectator:GetNumPlayersInTeam("arena");
	
	for i = 1, 5 do
		local unit = "raid"..i;
		if ( i <= numTeamA ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
		else
			playerStates[unit] = nil;
		end
		
		unit = "arena"..i;
		if ( i <= numTeamB ) then
			playerStates[unit] = ArenaLiveSpectator:ValueToBoolean(UnitIsDeadOrGhost(unit));
		else
			playerStates[unit] = nil;
		end
	end
	
	-- Show/Hide frame to enable/disable OnUpdate script;
	if ( numTeamA > 0 or numTeamB > 0 ) then
		self:Show();
	else
		self:Hide();
	end
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

function SpiritHealerFrame:OnEvent(event, ...)
	SpiritHealerFrame:UpdateNumPlayers();
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

local THROTTLE, elapsedTilNow = 0.1, 0;
function SpiritHealerFrame:OnUpdate(elapsed)
	elapsedTilNow = elapsedTilNow + elapsed;
	if ( elapsedTilNow >= THROTTLE ) then
		elapsedTilNow = 0;
		for unit, isDeadOrGhost in pairs(playerStates) do
			local name = GetSpellInfo(5384)
			local feignDeath = UnitBuff(unit, name);
			local newState = ArenaLiveSpectator:ValueToBoolean((UnitIsDeadOrGhost(unit) and not UnitBuff(unit, name)));
			if ( newState ~= isDeadOrGhost ) then
				playerStates[unit] = newState;
				SpiritHealerFrame:CallUpdateForUnit(unit);
			end
		end
	end
end

SpiritHealerFrame:SetScript("OnUpdate", SpiritHealerFrame.OnUpdate);
--[[
    ArenaLive [Spectator] is an user interface for spectated arena 
	wargames in World of Warcraft.
    Copyright (C) 2015  Harald Böhm <harald@boehm.agency>
	Further contributors: Jochen Taeschner and Romina Schmidt.
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	ADDITIONAL PERMISSION UNDER GNU GPL VERSION 3 SECTION 7:
	As a special exception, the copyright holder of this add-on gives you
	permission to link this add-on with independent proprietary software,
	regardless of the license terms of the independent proprietary software.
]]

local addonName, L = ...;
ArenaLiveSpectator.SmartCamera = CreateFrame("Frame");
local SmartCamera = ArenaLiveSpectator.SmartCamera;

-- Private Variables:
local unitData = {};
local unitDyingProbabilities = {};
local currentTarget;
local currentTenthSec = 0;
local nextSwap = 0;
local timeTilSwap = 3;
local swapThreshold = 10;

-- Private Functions:

-- Public Functions:
function SmartCamera:Enable ()
	local database = ArenaLive:GetDBComponent(addonName);
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_AURA");
	currentTenthSec = 0;
	self:Show();
	self.enabled = true;
end

function SmartCamera:Disable ()
	self:Hide();
	table.wipe(unitData);
	table.wipe(unitDyingProbabilities);
	self:UnregisterEvent("PLAYER_TARGET_CHANGED");
	self:UnregisterEvent("UNIT_AURA");
	self.enabled = false;
end

function SmartCamera:GetTarget ()
	return currentTarget;
end

function SmartCamera:GetUnitThreatLevel (unit)
	
	if ( not UnitGUID(unit) ) then
		return 0;
	else
		local currHP = unitData[unit].health or 0;

		if ( currHP > 0 ) then
			local playerName = UnitName(unit);
			local fluctuation = unitData[unit].fluctuation;
			if ( fluctuation < 0 ) then
				fluctuation = math.abs(fluctuation);
				local dyingInSeconds = currHP / fluctuation;
				
				local threatLevel = 100 - ( (fluctuation / currHP) * 100 );
				--print(string.format("Current threat level for player %s is %d%%. Dies in approx %d seconds.", playerName, threatLevel, dyingInSeconds));
				return threatLevel;
			else
				-- Target is getting more heal than damage:
				return 0;
			end
			
		else
			return 0;
		end
	end
end

function SmartCamera:SetTarget ()
	if ( not UnitExists("target") ) then
		local target;
		local theTime = GetTime()
		if ( theTime >= nextSwap ) then
			for unit, dyingProbability in pairs(unitDyingProbabilities) do
				if ( not target or dyingProbability > unitDyingProbabilities[target] ) then
					target = unit;
				end
			end
		else
			-- Check if a unit breaks the threshold:
			for unit, dyingProbability in pairs(unitDyingProbabilities) do
				if ( dyingProbability + swapThreshold > unitDyingProbabilities[currentTarget] ) then
					target = unit;
					currentTarget = unit; -- For testing every possible option.
				end
			end
		end
		
		currentTarget = target;
		if ( target ) then
			C_Commentator.FollowUnit(target);
			nextSwap = theTime + timeTilSwap;
		end
	else
		currentTarget = nil;
		C_Commentator.FollowUnit("target");
	end
	
	local database = ArenaLive:GetDBComponent(addonName);
	if ( database.HideTargetFrames or database.PlayMode > 3 ) then
		for i = 1, database.PlayMode do
			local frame = _G["ALSPEC_LeftSideFramesFrame"..i];
			ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
			frame = _G["ALSPEC_RightSideFramesFrame"..i];
			ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
		end
	end
end

function SmartCamera:UpdateUnit (unit)
	if ( not unit ) then
		return;
	end
	--[[
	local guid = UnitGUID(unit);
	if ( guid ) then
		if ( not unitData[unit] ) then
			print(string.format("I don't know %s yet. I'll add her to my memory.", unit));
			unitData[unit] = {};
			unitData[unit].fluctuationCounting = {};
		else
			print(string.format("I'm updating my memory for unit %s", unit));
		end
		
		if ( guid ~= unitData[unit].guid ) then
			print(string.format("Looks like she belongs to another player now."));
			unitData[unit].guid = guid;
			unitData[unit].fluctuation = 0;
			table.wipe(unitData[unit].fluctuationCounting);
			unitData[unit].health = UnitHealth(unit) or 0;
		else
			print(string.format("Unit %s is still held by the same player.", unit));
		end
	elseif ( unitData[unit] ) then
		-- Unit doesn't exist anymore:
		print(string.format("I cannot see unit %s. I'm deleting her from my memory...", unit));
		table.wipe(unitData[unit]);
		unitData[unit] = nil;
	end]]
end

function SmartCamera:UpdateUnitDyingProbability (unit)
	
	if ( not unit ) then
		return;
	end
	
	local health = unitData[unit].health or 0
	local maxHealth = unitData[unit].maxHealth or 1;
	local healthPercent;
 
	if ( maxHealth == 0 ) then
		-- Prevent division by zero.
		maxHealth = 1;
	end
	
	-- Health includes absorbs here.
	healthPercent = math.ceil(health / maxHealth) * 100; 
	
	if ( healthPercent == 0 ) then
		-- Special case: Unit is already dead:
		unitDyingProbabilities[unit] = 0;
	else
		local threatLevel = self:GetUnitThreatLevel(unit);
		local dyingProbability = math.ceil(( 100 - healthPercent ) * 0.6 + ( threatLevel * 0.35 ));
		if ( unitData[unit].isStunned ) then
			dyingProbability = dyingProbability + 5;
		end
		
		print(string.format("Calculated dying probability for unit %s: %d. Health Deficit: %d; Threat Level: %d", unit, dyingProbability, 100 - healthPercent, threatLevel));
		unitDyingProbabilities[unit] = dyingProbability;
	end
	
end

--[[

	SmartCamera:UpdateUnitHealthFluctuation():
	This function calculates and sets the health fluctuation of a player
	over the last second. The value will be used to calculate the current
	probability of dying for this player.
	
	@param	String	unit	The unitID of the affected player.
]]
function SmartCamera:UpdateUnitHealthFluctuation (unit) 
	
	local fluctuation = 0;
	for key, value in pairs(unitData[unit].fluctuationCounting) do
		fluctuation = fluctuation + value;
	end
	
	unitData[unit].fluctuation = fluctuation;
end

function SmartCamera:UpdateUnitStunned (unit)
	local isStunned = false;
	for i = 1, 40 do
		local spellID = select(11, UnitDebuff(unit, i));
		if ( spellID ) then
			priorityType = ArenaLive.spellDB.CCIndicator[spellID];
			isStunned = ( priorityType == "stun" );
			if ( unitData[unit].isStunned ) then
				break; 
			end
		else
			break;
		end
	end
	
	if ( isStunned ~= unitData[unit].isStunned ) then
		unitData[unit].isStunned = isStunned;
		SmartCamera:UpdateUnitDyingProbability(unit);
	end
end

function SmartCamera:OnEvent(event, ...)
	local arg1 = ...;
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		self:SetTarget();
	elseif ( event == "UNIT_AURA" and unitData[arg1] ) then
		--self:UpdateUnitStunned(arg1);
	end
end

local alreadyElapsed, throttle = 0, 0.1;
function SmartCamera:OnUpdate (elapsed)
	alreadyElapsed = alreadyElapsed + elapsed;

	if ( alreadyElapsed >= throttle ) then
		alreadyElapsed = alreadyElapsed - throttle;
		
		currentTenthSec = currentTenthSec + 1;
		local key = (currentTenthSec % 10) + 1;
		
		for unit, unitTable in pairs(unitData) do
			local absorb = UnitGetTotalAbsorbs(unit) or 0;
			local curHealth = UnitHealth(unit) + absorb;
			local fluctuation = curHealth - unitTable.health;

			unitData[unit].fluctuationCounting[key] = fluctuation;
			unitData[unit].health = curHealth;
			unitData[unit].maxHealth = UnitHealthMax(unit) + absorb;
			
			self:UpdateUnitHealthFluctuation(unit);
			self:UpdateUnitDyingProbability(unit);
		end
		
		if ( not UnitExists("target") ) then
			self:SetTarget();
		end
	end
end

SmartCamera:SetScript("OnEvent", SmartCamera.OnEvent);
--SmartCamera:SetScript("OnUpdate", SmartCamera.OnUpdate);
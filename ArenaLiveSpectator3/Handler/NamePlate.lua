--[[ ArenaLive Spectator Functions: Nameplate Handler
Created by: Vadrak
Creation Date: 08.01.2015
Last Update: 09.01.2015
]]--

-- Addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
local NamePlate = ArenaLive:ConstructHandler("NamePlate", true, true);
local CCIndicator = ArenaLive:GetHandler("CCIndicator");
local HealthBar = ArenaLive:GetHandler("HealthBar");
local NameText = ArenaLive:GetHandler("NameText");



-- Register for needed events:
NamePlate:RegisterEvent("COMMENTATOR_PLAYER_UPDATE");
NamePlate:RegisterEvent("PLAYER_ENTERING_WORLD");
NamePlate:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED");
NamePlate:RegisterEvent("UNIT_AURA");
NamePlate:RegisterEvent("UNIT_NAME_UPDATE");
NamePlate:RegisterEvent("UNIT_PET");
NamePlate:RegisterEvent("UNIT_HEAL_PREDICTION");

-- Set Attributes:
NamePlate.numWorldFrameChildren = 0;
NamePlate.unitCache = {};
NamePlate.unitNameCache = {};
NamePlate.namePlates = {};

-- Create NamePlate Class:
local NamePlateClass = {};

--[[
****************************************
*** SCRIPT HOOK FUNCTIONS START HERE ***
****************************************
]]--
local function NamePlateHealthBar_OnValueChanged(healthBar)
	local blizzPlate = healthBar:GetParent():GetParent();
	local namePlate = NamePlate.namePlates[blizzPlate];
	if ( namePlate.enabled ) then
		namePlate:UpdateHealthBar();
	end
end

local function NamePlateCastBar_OnValueChanged(castBar)
	local blizzPlate = castBar:GetParent():GetParent();
	local namePlate = NamePlate.namePlates[blizzPlate];
	if ( namePlate.enabled ) then
		namePlate:UpdateCastBar();
	end
end



--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function NamePlate:ConstructObject(namePlate, addonName, frameGroup)
	local prefix = namePlate:GetName();
	namePlate.addon = addonName;
	namePlate.group = frameGroup;
	
	-- Copy Class Methods:
	ArenaLive:CopyClassMethods(NamePlateClass, namePlate);	
	
	-- Construct CC Indicator:
	namePlate.CCIndicator = _G[prefix.."CCIndicator"];
	CCIndicator:ConstructObject(_G[prefix.."CCIndicator"], _G[prefix.."CCIndicatorTexture"], _G[prefix.."CCIndicatorCooldown"], addonName);
	
	-- Construct HealthBar:
	HealthBar:ConstructObject(_G[prefix.."HealthBar"], _G[prefix.."HealthBarHealPredictionBar"], _G[prefix.."HealthBarAbsorbBar"], _G[prefix.."HealthBarAbsorbBarOverlay"], 32, _G[prefix.."HealthBarAbsorbBarFullHPIndicator"], nil, addonName, frameGroup);
	
	-- Set reference where needed:
	namePlate.nameText = _G[prefix.."NameText"];
	namePlate.border = _G[prefix.."Border"];
	
	
	namePlate:SetScript("OnShow", namePlate.OnShow);
	
	-- Enable or disable name plate according to spectator state:
	if ( IsSpectator() ) then
		namePlate:Enable();
	else
		namePlate:Disable();
	end
end

function NamePlate:Enable()
	self:Show();
	NamePlate:OnEvent("COMMENTATOR_PLAYER_UPDATE");
	for blizzPlate, namePlate in pairs(self.namePlates) do
		namePlate:Enable();
	end
end

function NamePlate:Disable()
	self:Hide();
	for blizzPlate, namePlate in pairs(self.namePlates) do
		namePlate:Disable();
	end
end

function NamePlate:GetReactionType(r, g, b)
	-- I use 0.9 instead of 1, because getter functions
	-- most of the time return not 1, but 0,998 etc.
	if ( r > 0.9 and g > 0.9 and b == 0 ) then
		return "Neutral";
	elseif ( r > 0.9 and g == 0 and b == 0 ) then
		return "Hostile";
	elseif ( g > 0.9 and r == 0 and b == 0 ) then
		return "PvP-Friendly";
	elseif ( b > 0.9 and r == 0 and g == 0 ) then
		return "Friendly";
	else
		return "Hostile-Player" -- Only hostile/neutral players can have class colours.
	end
end

function NamePlate:SetBlizzPlateStructure(blizzPlate)
	local mainFrame, nameFrame = blizzPlate:GetChildren();
	blizzPlate.mainFrame = mainFrame;
	blizzPlate.nameFrame = nameFrame;
	
	local mainFrameChildren = { mainFrame:GetChildren() };
	
	-- Get castbar and healthbar of a nameplate:
	local healthBar = mainFrameChildren[1];
	blizzPlate.healthBar = healthBar;
	
	local castBar = mainFrameChildren[2];
	local castBarRegions = { castBar:GetRegions() };
	blizzPlate.castBar = castBar;
	blizzPlate.castBar.shield = castBarRegions[3];
	blizzPlate.castBar.icon = castBarRegions[4];
	blizzPlate.castBar.text = castBarRegions[5];

	-- Get Name FontString:
	nameFontString = select(1, nameFrame:GetRegions());
	blizzPlate.nameText = nameFontString;
	
	-- Secure hook scripts:
	blizzPlate.healthBar:HookScript("OnValueChanged", NamePlateHealthBar_OnValueChanged);
	blizzPlate.healthBar:HookScript("OnMinMaxChanged", NamePlateHealthBar_OnValueChanged);
	blizzPlate.castBar:HookScript("OnValueChanged", NamePlateCastBar_OnValueChanged);
	blizzPlate.castBar:HookScript("OnMinMaxChanged", NamePlateCastBar_OnValueChanged);
	blizzPlate.castBar:HookScript("OnShow", NamePlateCastBar_OnValueChanged);
	blizzPlate.castBar:HookScript("OnHide", NamePlateCastBar_OnValueChanged);
end

function NamePlate:HideBlizzardNamePlate(blizzPlate)
	-- Set Alpha to zero instead of actually hiding them:
	blizzPlate.mainFrame:SetAlpha(0);
	blizzPlate.nameFrame:SetAlpha(0);
end

function NamePlate:ShowBlizzardNamePlate(blizzPlate)
	blizzPlate.mainFrame:SetAlpha(1);
	blizzPlate.nameFrame:SetAlpha(1);
end

function NamePlate:CreateNamePlate(blizzPlate)
	local id = string.match(blizzPlate:GetName(), "^NamePlate(%d+)$");
	local namePlate = CreateFrame("Frame", "ArenaLiveNamePlate"..id, blizzPlate, "ArenaLiveSpectatorNamePlateTemplate");
	self.namePlates[blizzPlate] = namePlate;
	ArenaLive:ConstructHandlerObject(namePlate, "NamePlate", addonName, "NamePlate");
end

function NamePlate:UpdateAll()
	if ( self.enabled ) then
		for _, namePlate in pairs(NamePlate.namePlates) do
			NamePlate:UpdateNamePlate(namePlate);
		end
	end
end

function NamePlate:UpdateNamePlate(namePlate)
	local blizzPlate = namePlate:GetParent();
	local blizzPlateName = blizzPlate.nameText:GetText();

	local unit;
	if ( NamePlate.unitNameCache[blizzPlateName] ) then
		
		local checkUnit = NamePlate.unitNameCache[blizzPlateName];
		
		local isSameReaction = NamePlate:PlateReactionIsUnitReaction(blizzPlate, checkUnit);
		
		if ( isSameReaction ) then
			local isPlayer = UnitIsPlayer(checkUnit);
			local plateReaction = NamePlate:GetReactionType(blizzPlate.healthBar:GetStatusBarColor());
			
			if ( not isPlayer or ( isPlayer and plateReaction == "Hostile-Player" ) ) then
				unit = checkUnit;
			end
		end
	end
	
	namePlate:UpdateUnit(unit);
	namePlate:Update();
end

function NamePlate:PlateReactionIsUnitReaction(blizzPlate, unit)
	local plateReaction = NamePlate:GetReactionType(blizzPlate.healthBar:GetStatusBarColor());
	local unitReaction = NamePlate:GetReactionType(UnitSelectionColor(unit));
	
	local isPlayer = UnitIsPlayer(unit);
	if ( isPlayer and ( unitReaction == "Hostile" or unitReaction == "Friendly" ) and plateReaction == "Hostile-Player" ) then
		return true;
	elseif ( not isPlayer and ( unitReaction == "Friendly" and plateReaction == "Hostile" ) ) then
		return true;
	elseif ( unitReaction == plateReaction ) then
		return true;
	else
		return false;
	end
end

function NamePlate:UpdateUnitCacheEntry(unit)
	local oldName = self.unitCache[unit];
	
	-- Reset old name cache entry if necessary:
	if ( oldName ) then
		self.unitNameCache[oldName] = nil;
	end
	
	-- Apply new name data to cache:
	local name = GetUnitName(unit);
	self.unitCache[unit] = name;

	if ( name ) then
		self.unitNameCache[name] = unit;
	end
end

function NamePlate:OnEvent(event, ...)
	local unit = ...;
	if ( event == "COMMENTATOR_PLAYER_UPDATE" ) then
		-- local numTeamA = CommentatorGetNumPlayers(2);
		-- local numTeamB = CommentatorGetNumPlayers(1);

        -- for i = 1, 5 do
			-- local unit = "spectateda"..i;
			-- NamePlate:UpdateUnitCacheEntry(unit);
			
			-- unit = "spectatedb"..i;
			-- NamePlate:UpdateUnitCacheEntry(unit);
		-- end
		NamePlate:UpdateAll();
	elseif ( ( event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_PREDICTION" )) then --and NamePlate.unitCache[unit] ) then
		for blizzPlate, namePlate in pairs(self.namePlates) do
			if ( unit == namePlate.unit ) then
				HealthBar:Update(namePlate);
			end
		end
	elseif ( event == "UNIT_AURA" ) then --and NamePlate.unitCache[unit] ) then
		for blizzPlate, namePlate in pairs(self.namePlates) do
			if ( unit == namePlate.unit ) then
				CCIndicator:Update(namePlate);
			end
		end
	elseif ( event == "UNIT_NAME_UPDATE" ) then-- and NamePlate.unitCache[unit] ) then
		--NamePlate:UpdateUnitCacheEntry(unit);
		NamePlate:UpdateAll();
	elseif ( event == "UNIT_PET" ) then --and NamePlate.unitCache[unit] ) then
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		local unitNumber = string.match(unit, "^[a-z]+([0-9]+)$");
		if ( not unitNumber ) then
			return;
		end
		
		-- if ( unitType == "spectateda" or unitType == "spectatedb" ) then
			-- if ( unitType == "spectateda" ) then
				-- unit = "spectatedpeta"..unitNumber;
			-- else
				-- unit = "spectatedpetb"..unitNumber;
			-- end
			-- print(unit);
			-- NamePlate:UpdateUnitCacheEntry(unit);
			NamePlate:UpdateAll();
		--end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( IsSpectator() ) then
			NamePlate:Enable();
		else
			NamePlate:Disable()
		end
	end
end

function NamePlate:OnUpdate(elapsed)
	-- Check if there were new frames created:
	if ( self.numWorldFrameChildren < WorldFrame:GetNumChildren() ) then
		for _, frame in pairs({WorldFrame:GetChildren()}) do
			local frameName = frame:GetName();
			
			-- Check if frame is a nameplate:
			if ( frameName and string.find(frameName, "^NamePlate(%d+)$" ) ) then
				if ( not self.namePlates[frame] ) then
					self:SetBlizzPlateStructure(frame);
					self:CreateNamePlate(frame);
				end
			end
		end
		self.numWorldFrameChildren = WorldFrame:GetNumChildren();
	end
end
NamePlate:SetScript("OnUpdate", NamePlate.OnUpdate);

-- function ArenaLiveSpectator:PrintUnitCache()
	-- for unit, name in pairs(NamePlate.unitCache) do
		-- print(unit.." = "..name);
	-- end
-- end

local children;
function ArenaLiveSpectator:CrawlNamePlateData(nameplate)

	local children = {nameplate:GetChildren()};
	local regions = {nameplate:GetRegions()};
	local i = 1;
	
	print(nameplate:GetParent():GetName());
	for key, value in pairs(nameplate) do
		print(tostring(key).." = "..tostring(value));
	end
	
	for _, child in ipairs(children) do
		local frameType = child:GetObjectType();
		local subChildren = {child:GetChildren()}
		local subRegions = {child:GetRegions()};
		
		print(tostring("Child"..tostring(i))..": FrameType = "..tostring(frameType));
		
		local subID = 1;
		for _, subChild in ipairs(subChildren) do
			local minvalue, maxvalue, value;
			local objectType = subChild:GetObjectType();
			if ( objectType == "StatusBar" ) then
				minvalue, maxvalue = subChild:GetMinMaxValues();
				value = subChild:GetValue();
				local name = subChild:GetName();
				local subsubchildren = subChild:GetNumChildren();
				local subsubRegions = {subChild:GetRegions()};
				print("     "..tostring("SubChild"..tostring(subID))..": FrameType = "..tostring(objectType).."; MinValue = "..tostring(minvalue).."; MaxValue = "..tostring(maxvalue).."; Value = "..tostring(value)..";");
				subID = subID + 1; 
				for key, subsubRegion in pairs(subsubRegions) do
					local subsubRegionType = subsubRegion:GetObjectType();
					if ( subsubRegionType == "FontString" ) then
						local subsubText = subsubRegion:GetText();
						print("          5:"..tostring(subsubText));
					elseif ( subsubRegionType == "Texture" ) then
						local subsubTexture = subsubRegion:GetTexture();
						print("         ", key, ": "..tostring(subsubTexture));
					end
				end
			end
		end
		
		local subRegionID = 1;
		for _, region in ipairs(subRegions) do
			local regionType = region:GetObjectType();
			local content;
			
			if ( regionType == "Texture" ) then
				content = region:GetTexture();
			elseif ( regionType == "FontString" ) then
				content = region:GetText();
			end
			
			print("     "..tostring("SubRegion")..tostring(subRegionID)..": RegionType = "..tostring(regionType).."; Content = "..tostring(content));
			subRegionID = subRegionID + 1;
		end
		
		i = i + 1;
	end
	
	local regionID = 1;
	for _, region in ipairs(regions) do
		local regionName = region:GetName();
		local regionType = region:GetObjectType();
		print (tostring(regionName).."(Region"..tostring(subRegionID).."): RegionType = "..tostring(regionType));
		regionID = regionID + 1;
	end
end

--[[
****************************************
******* CLASS METHODS START HERE *******
****************************************
]]--
function NamePlateClass:Enable()
	local blizzPlate = self:GetParent();
	NamePlate:HideBlizzardNamePlate(blizzPlate);
	
	self:Show();
	self.enabled = true;
	
	NamePlate:UpdateNamePlate(self);
end

function NamePlateClass:Disable()
	local blizzPlate = self:GetParent();
	NamePlate:ShowBlizzardNamePlate(blizzPlate);
	
	self:Hide();
	self.enabled = false;
	
	self:Reset();
end

function NamePlateClass:Update()
	if ( self.enabled ) then
		self:UpdateCastBar();
		CCIndicator:Update(self);
		self:UpdateClassIcon();
		self:UpdateHealthBar();
		self:UpdateNameText()
	end
end

function NamePlateClass:UpdateAppearance()
	local blizzPlate = self:GetParent();
	local database = ArenaLive:GetDBComponent(addonName);
	
	if ( self.unit and UnitIsPlayer(self.unit) ) then
		self:SetSize(163, 33);
		
		self.classIcon:Show();
		
		self.border:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\PlayerNamePlate");
		self.border:SetTexCoord(0.181640625, 0.818359375, 0.2421875, 0.7578125);
		
		self.HealthBar:ClearAllPoints();
		self.HealthBar:SetPoint("TOPLEFT", self.classIcon, "TOPRIGHT", 4, -2);
		
		self.castBar:ClearAllPoints();
		self.castBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 30, 4);
	else
		self:SetSize(137, 22);
		self.classIcon:Hide();
		
		self.border:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\NamePlateBorder");
		self.border:SetTexCoord(0.28125, 0.81640625, 0.2421875, 0.5859375);

		self.HealthBar:ClearAllPoints();
		self.HealthBar:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5);
		
		self.castBar:ClearAllPoints();
		self.castBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, 0);
	end
	
	-- Set border colour:
	local red, green, blue;
	if ( self.unit ) then
		local unitType = string.match(self.unit, "^([a-z]+)[0-9]+$") or self.unit;
		if ( unitType == "spectateda" or unitType == "spectatedpeta" ) then
			red, green, blue = unpack(database.TeamA.Colour);
		elseif ( unitType == "spectatedb" or unitType == "spectatedpetb" ) then
			red, green, blue = unpack(database.TeamB.Colour);
		else
			red, green, blue = UnitSelectionColor(self.unit);
		end
	else
		red, green, blue = blizzPlate.healthBar:GetStatusBarColor();
	end

	self.border:SetVertexColor(red, green, blue);
end

function NamePlateClass:UpdateCastBar()
	local blizzPlate = self:GetParent();
	if ( blizzPlate.castBar:IsShown() ) then
		if ( not self.castBar:IsShown() ) then
			self.castBar:Show();
		end
		
		local minValue, maxValue = blizzPlate.castBar:GetMinMaxValues();
		local value = blizzPlate.castBar:GetValue();
		local texture = blizzPlate.castBar.icon:GetTexture();
		local spellName = blizzPlate.castBar.text:GetText();
		
		-- Prevent Division by zero:
		if ( maxValue == 0 ) then
			maxValue = 1;
		end		
		
		local red, green, blue = 1, 0.7, 0;
		if ( blizzPlate.castBar.shield:IsShown() ) then
			red, green, blue = 0, 0.49, 1;
		end
		
		self.castBar:SetStatusBarColor(red, green, blue);
		self.castBar:SetMinMaxValues(minValue, maxValue);
		self.castBar:SetValue(value);
		self.castBar.icon:SetTexture(texture);
		self.castBar.text:SetText(spellName);
	elseif ( self.castBar:IsShown() ) then
		self.castBar:Hide();
	end
end

function NamePlateClass:UpdateClassIcon()
    if ( self.unit and UnitIsPlayer(self.unit) ) then
		local _, class = UnitClass(self.unit);
		self.classIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
		self.classIcon:Show();
	else
		self.classIcon:Hide();
	end
end

function NamePlateClass:UpdateHealthBar()
	local blizzPlate = self:GetParent();
	
	-- Set class color if possible:
	local red, green, blue = blizzPlate.healthBar:GetStatusBarColor();
	if ( self.unit ) then
		HealthBar:Update(self);
		if ( not UnitIsPlayer(self.unit) ) then
			-- A player's pet, use team colour instead:
			local database = ArenaLive:GetDBComponent(addonName);
			local unitType = string.match(self.unit, "^([a-z]+)[0-9]+$") or self.unit;
			if ( unitType == "spectatedpeta" ) then
				red, green, blue = unpack(database.TeamA.Colour);
			elseif ( unitType == "spectatedpetb" ) then
				red, green, blue = unpack(database.TeamB.Colour);
			end
			self.HealthBar:SetStatusBarColor(red, green, blue);
		end
	else
		local minValue, maxValue = blizzPlate.healthBar:GetMinMaxValues();
		local value = blizzPlate.healthBar:GetValue();
		
		-- Prevent Division by zero:
		if ( maxValue == 0 ) then
			maxValue = 1;
		end
		
		HealthBar:Reset(self);
		self.HealthBar:SetStatusBarColor(red, green, blue);
		self.HealthBar:SetMinMaxValues(minValue, maxValue);
		self.HealthBar:SetValue(value);
	end
	
end

function NamePlateClass:UpdateNameText()
	local blizzPlate = self:GetParent();
	local name;
	if ( self.unit ) then
		name = NameText:GetNickname(self.unit) or GetUnitName(self.unit) or blizzPlate.nameText:GetText();
	else
		name = blizzPlate.nameText:GetText();
	end
	
	self.nameText:SetText(name);
end

function NamePlateClass:Reset()
	if ( self.enabled ) then
		self.castBar:Hide();
		CCIndicator:Reset(self);
		self.classIcon:SetTexCoord(0, 1, 0, 1);
		HealthBar:Reset(self);
		self.nameText:SetText("");
	end
end

function NamePlateClass:UpdateUnit(unit)
	self.unit = unit;
	if ( unit ) then
		self.CCIndicator.enabled = true;
	else
		self.CCIndicator.enabled = nil;
	end
	self:UpdateAppearance();
	self:UpdateGUID();
end

function NamePlateClass:UpdateGUID()
	if ( self.unit ) then
		local guid = UnitGUID(self.unit);
		if ( not self.guid or guid ~= self.guid ) then
			self.guid = guid;
			if ( guid ) then
				self:Update();
			else
				self:Reset();
			end
			
		end
	else
		self.guid = nil;
		self:Reset();
	end
end

function NamePlateClass:OnShow()
	if ( self.enabled ) then
		NamePlate:UpdateNamePlate(self);
	end
end
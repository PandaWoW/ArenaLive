--[[ ArenaLive Core Functions: UnitFrame Handler
Created by: Vadrak
Creation Date: 03.04.2014
Last Update: 16.05.2014
These functions are used to set up every standard unit frame. For grouped unit frames (party/raid/arena) see also GroupHeader.lua.
]]--

-- ArenaLive addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for all important events:
local UnitFrame = ArenaLive:ConstructHandler("UnitFrame", true);
UnitFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
UnitFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
UnitFrame:RegisterEvent("PLAYER_FOCUS_CHANGED");
UnitFrame:RegisterEvent("UNIT_PET");
--UnitFrame:RegisterEvent("UNIT_CONNECTION");
UnitFrame:RegisterEvent("UNIT_NAME_UPDATE");
UnitFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

-- Create a table to update frame's unit after combat lockdown fades if they tried to change it during combat lockdown
UnitFrame.updateUnitCallback = {};

-- Create tables to store registered unit frames sorted by unitID, GUID:
UnitFrame.UnitFrames = {};
UnitFrame.IndexByUnit = {};
UnitFrame.IndexByGUID = {};

--[[ Method: GetAllUnitFrames
	 This function basically is similar to the standard pairs() iterate function.
	 It returns the next function and the table containing all unit frames.
		RETRUNS:
			next: next function to iterate through the table.
			table: The table including all unit frames.
			nil is returned as a third value so the next function starts at an initial key-value pair.
]]--
function ArenaLive:GetAllUnitFrames ()
	return next, UnitFrame.UnitFrames, nil;
end

--[[ Method: GetAffectedUnitFramesByUnit
	 This function basically is similar to the standard pairs() iterate function.
	 It returns the next function and the table containing all IDs of unit frames that currently show the queried unit.
		ARGUMENTS:
			unit: unitID to query the unit frame data base for.
		RETRUNS:
			next: next function to iterate through the table.
			table: The table including all frame IDs that currently show the specified unit.
			nil is returned as a third value so the next function starts at an initial key-value pair.
]]--
function ArenaLive:GetAffectedUnitFramesByUnit (unit)
	return next, UnitFrame.IndexByUnit[unit], nil;
end

function ArenaLive:IsUnitInUnitFrameCache(unit)
	if ( UnitFrame.IndexByUnit[unit] ) then
		return true;
	else
		return false;
	end
end

--[[ Method: GetAffectedUnitFramesByUnit
	 This function basically is similar to the standard pairs() iterate function.
	 It returns the next function and the table containing all IDs of unit frames that currently show the queried GUID.
		ARGUMENTS:
			guid: GUID to query the unit frame data base for.
		RETRUNS:
			next: next function to iterate through the table.
			table: The table including all frame IDs that currently show the specified GUID.
			nil is returned as a third value so the next function starts at an initial key-value pair.
]]--
function ArenaLive:GetAffectedUnitFramesByGUID (guid)
	return next, UnitFrame.IndexByGUID[guid], nil;
end

function ArenaLive:IsGUIDInUnitFrameCache(guid)
	if ( UnitFrame.IndexByGUID[guid] ) then
		return true;
	else
		return false;
	end
end

--[[ Method: GetUnitFrameByID
	 Returns the unit frame with the specified ID from the unit frame database.
	 It returns the next function and the table containing all IDs of unit frames that currently show the queried GUID.
		ARGUMENTS:
			id: ID of the unit frame that will be returned.
		RETRUNS:
			frame: The unit frame with the specified ID.
]]--
function ArenaLive:GetUnitFrameByID (id)
	return UnitFrame.UnitFrames[id];
end

--[[ We make unit frames SecureHandlers in order to detect, whether a unit frame should be shown or not.
	 So the following code snippet is used to regulate visibility of a normal unit frame.
	 For further details on this functionality see: http://www.wowwiki.com/SecureHandlers or SecureHandlers.lua in WoW's FrameXML.
	 function args: self, name, value
]]
local onAttributeChangedSnippet = [[
 if ( name ~= "state-unitexists" and name ~= "al_alwaysvisible" and name ~= "al_framelock" and name ~= "unit" ) then
  return;
 end

 if ( self:GetAttribute("al_alwaysvisible") ) then
  self:Show();
 elseif (not self:GetAttribute("al_framelock") ) then
  self:Show();
 elseif ( self:GetAttribute("state-unitexists") ) then
  self:Show();
 else
  self:Hide();
 end
]];

UnitFrame.optionSets = {
	["Enable"] = {
		["type"] = "CheckButton",
		["title"] = L["Enable"],
		["tooltip"] = L["Enables the unit frame."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, "UnitFrame", frame.group); return database.Enabled; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, "UnitFrame", frame.group); database.Enabled = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			for id, unitFrame in ArenaLive:GetAllUnitFrames() do 
				if ( unitFrame.addon == frame.addon and unitFrame.group == frame.group ) then
					if ( newValue ) then
						unitFrame:Enable();
					else 
						unitFrame:Disable();
					end
				end
			end
		end,
	},
	["ToolTipMode"] = {
		["type"] = "DropDown",
		["title"] = L["Show Tooltip"],
		["infoTable"] = {
			[1] = {
				["text"] = L["Always"],
				["value"] = "Always",
			},
			[2] = {
				["text"] = L["Out of Combat"],
				["value"] = "OutOfCombat",
			},
			[3] = {
				["text"] = L["Never"],
				["value"] = "Never",
			},
		},
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, "UnitFrame", frame.group); return database.TooltipMode; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, "UnitFrame", frame.group); database.TooltipMode = newValue; end,		
	},
	["Scale"] = {
		["type"] = "Slider",
		["width"] = 150,
		["height"] = 17,
		["min"] = 50,
		["max"] = 200,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["title"] = L["Frame Scale (%)"],
		["tooltip"] = L["Sets the scale of the unit frame."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); local scale = database.Scale or 1 return scale*100; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Scale = newValue/100; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			for id, unitFrame in ArenaLive:GetAllUnitFrames() do
				if ( unitFrame.addon == frame.addon and unitFrame.group == frame.group ) then
					local scale = newValue / 100;
					unitFrame:SetScale(scale);
					unitFrame:Update();
				end
			end
		end,
	},
};

--[[
****************************************
****** CLASS METHODS START HERE ******
****************************************
]]--
--Create a base class for this handler. All objects of the type UnitFrame will inherit functions from this one:
local UnitFrameClass = {};

--[[ Method: Enable
	 Enables the unit frame and all its constituents.
]]--
function UnitFrameClass:Enable()
	-- Set general attributes according to saved variables:
	local database = ArenaLive:GetDBComponent(self.addon, "FrameMover");
	local frameLock = database.FrameLock;
	
	database = ArenaLive:GetDBComponent(self.addon, "UnitFrame", self.group);
	local scale = database.Scale or 1;
	
	if ( not self.hasHeader ) then
		--[[ RegisterUnitWatch with asState = true. 
			 This way it will change an attribute "state-unitexists" to true if the frame's unit exists.
			 This will call the onAttributeChangedSnippet we defined above and check whether the frame should be shown or not.
			 For further details see: http://www.wowwiki.com/SecureStateDriver or SecureStateDriver.lua in WoW's FrameXML.
		]]
		RegisterUnitWatch(self, true);
			
		-- Wrap secure onAttribute snippet:
		self:WrapScript(self, "OnAttributeChanged", onAttributeChangedSnippet);
	end
	
	self:SetAttribute("al_framelock", frameLock);
	self:SetScale(scale);
	self.enabled = true;
	
	if ( type(self.OnEnable) == "function" ) then
		self:OnEnable();
	end
end

--[[ Method: Disable
	 Disables the unit frame and all its constituents.
]]--
function UnitFrameClass:Disable()
	if ( not self.hasHeader ) then
		-- Unwrap secure onAttribute snippet:
		self:UnwrapScript(self, "OnAttributeChanged");
		UnregisterUnitWatch(self);
	end
		
	self:UpdateUnit();
	self:Reset();
	self:Hide();
	self.enabled = false;
	
	if ( type(self.OnDisable) == "function" ) then
		self:OnDisable();
	end
end

--[[ Method: UpdateGUID
	 Update the unitID the frame shows.
		ARGUMENTS:
			unit (string): A viable unitID (e.g. "player", "target", ...)
]]--
function UnitFrameClass:UpdateUnit(unit)
	
	if ( self.enabled ) then
		if ( not InCombatLockdown() ) then
			-- self.unit is set via the OnAttributeChanged script in order to prevent self.unit being set without the attribute being changed.
			self:SetAttribute("unit", unit);
		else
			-- In case we're affected by combat lockdown the UnitFrame handler will update the unit as soon as combat fades:
			UnitFrame.updateUnitCallback[self] = unit or "reset";
			ArenaLive:Message(L["Tried to change %s's unit during combat lockdown. Adding it to the callback list..."], "debug", self:GetName() or tostring(self));
		end
	else
		--ArenaLive:Message(L["Tried to change %s's unit although the frame is disabled. Please enable the frame and try again..."], "debug", self:GetName() or tostring(self));
	end
end

--[[ Method: UpdateGUID
	 This function is used to update the frames GUID key after a unit change occured or after the same
	 unitID displays a different player/npc.
]]--
function UnitFrameClass:UpdateGUID()
	if ( self.unit ) then
		local guid = UnitGUID(self.unit);
		
		if ( not self.guid or guid ~= self.guid ) then
			-- Reset old guid if necessary:
			if ( self.guid ) then
				UnitFrame.IndexByGUID[self.guid][self.id] = nil;
			end
			
			if ( guid ) then
				-- Add to global UF storage table:
				if ( not UnitFrame.IndexByGUID[guid] ) then
					UnitFrame.IndexByGUID[guid] = {};
				end
				UnitFrame.IndexByGUID[guid][self.id] = true;
			end
			-- Update frame's value:
			self.guid = guid;
		end
	elseif ( not self.unit and self.guid ) then
		-- Reset guid for there is no unit:	
		UnitFrame.IndexByGUID[self.guid][self.id] = nil;
		self.guid = nil;
	end
end

--[[ Method: Update
	 This function is used to set, whether the frame is in test mode or not. It will assign a number
	 to the .test key of the frame. This will be used in order to get sample values set in Core.lua.
		ARGUMENTS:
			mode (boolean): Depending on this value the test mode is either activated or deactivated.
]]--
function UnitFrameClass:TestMode (mode)
	if ( mode and ( not self.unit or not UnitExists(self.unit) ) ) then
		-- Random number to get one of the test mode data tables.
		local number = random(1, 5);
		self.test = number;
	else
		self.test = nil;
	end

	self:Update();
	
end

--[[ Method: Update
	 This function is used to update all registered handlers. Normally this is called after the unit of the frame changed
	 or the unitID serves to display a different player/npc. It brings all 
]]--
function UnitFrameClass:Update()
	if ( self.enabled ) then
		for handlerName, handler in pairs(ArenaLive.handlers) do
			if ( self[handlerName] ) then
				handler:Update(self);
			end
		end
	end
end

--[[ Method: Reset
	 This function is used to reset all registered handlers to their initial value/settings etc.
	 Mainly used when unit is set to nil via :UpdateUnit method.
]]--
function UnitFrameClass:Reset ()
	if ( self.enabled ) then
		for handlerName, handler in pairs(ArenaLive.handlers) do
			if ( self[handlerName] and type(handler.Reset) == "function" ) then
				handler:Reset(self);
			end
		end	
	end
end

--[[ Method: OnAttributeChanged
	 Function to use for the OnAttributeChanged script.
		ARGUMENTS:
			name (string): Name of the attribute that was changed.
			value (depends): New value of the affected attribute.
]]--
function UnitFrameClass:OnAttributeChanged (name, value)
	if ( name ~= "unit" or value == self.unit ) then
		return;
	end	

	if ( self.unit ) then
		-- Delete old entry:
		UnitFrame.IndexByUnit[self.unit][self.id] = nil;
	end

	-- Add to global UF storage table:
	if ( value ) then
		if ( not UnitFrame.IndexByUnit[value] ) then
			UnitFrame.IndexByUnit[value] = {};
		end
		UnitFrame.IndexByUnit[value][self.id] = true;
	end
	
	self.unit = value;
	self:UpdateGUID();
	
	-- Update frame:
	self:Update();

end

--[[ Method: OnEnter
	 Function to use for the OnEnter script.
]]--
function UnitFrameClass:OnEnter()

	local database = ArenaLive:GetDBComponent(self.addon, "UnitFrame", self.group);
	local showTooltip = database.TooltipMode;
	
	if ( ( showTooltip == "OutOfCombat" and not InCombatLockdown() ) or ( showTooltip == "Always" ) ) then
		if ( self.unit and UnitExists(self.unit) ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:SetUnit(self.unit, self.hideStatusOnTooltip)
			local r, g, b = GameTooltip_UnitColor(self.unit);
			GameTooltipTextLeft1:SetTextColor(r, g, b);
			GameTooltip:Show();
		end		
	end

end

--[[ Method: OnLeave
	 Function to use for the OnLeave script.
]]--
function UnitFrameClass:OnLeave ()
	if ( GameTooltip:IsShown() ) then
		GameTooltip:FadeOut();
	end
end

--[[ Method: RegisterHandler
	 Registers a subordinate handler. This way it will get unit and guid info from the unit frame etc.
		ARGUMENTS:
			object (frame/object): the frame/object that will be registered and constructed as the specified handler type.
			handlerName (string): Name of the handler type.
			identifier (string/number [depends]: This is used to set the key entry for a new object of a multiple handler type object.
												 CAUTION: It has correlate with the respective database entry for this object in order 
														  to retrieve the needed settings to set up the object.
			... (list): A list of further arguments to construct the handler object.
]]--
local handler;
function UnitFrameClass:RegisterHandler(object, handlerName, identifier, ...)

	ArenaLive:CheckArgs(handlerName, "string");	
	
	handler = ArenaLive:GetHandler(handlerName);
	local frameName = self:GetName() or tostring(self);
	
	if ( handler.multiple ) then
		if ( not self[handlerName] ) then
			-- This is the first instance of this handler created for this specific unit frame.
			-- So create a table for the handler:
			self[handlerName] = {};
		end
		
		object.id = identifier;
		
		ArenaLive:ConstructHandlerObject(object, handlerName, ...);
		self[handlerName][identifier] = object;
	else
		if ( not self[handlerName] ) then
			self[handlerName] = object;
			ArenaLive:ConstructHandlerObject(object, handlerName, ...);
		else
			ArenaLive:Message(L["Couldn't register handler %s for unit frame %s, because there already is a handler of that type registered!"], "error", handlerName, frameName);
		end	
	
	end
	
	-- Enable/Disable new handler if necessary:
	self:ToggleHandler(handlerName);
end

--[[ Method: UnregisterHandler
	 Unregisters a subordinate handler by its type.
		handlerName (string): Name of the handler type.
]]--
function UnitFrameClass:UnregisterHandler (handlerName)

	ArenaLive:CheckArgs(handlerName, "string");
	
	handler = ArenaLive:GetHandler(handlerName);
	local frameName = self:GetName() or tostring(self);
	
	if ( self[handlerName] ) then
		if ( handler.multiple ) then
			table.wipe(self[handlerName]);
		end
		
		self[handlerName] = nil;
		
	else
		ArenaLive:Message (L["Couldn't unregister handler %s for unit frame %s, because there is no handler of that type registered!"], "error", handlerName, frameName);
	end

end

function UnitFrameClass:ToggleHandler (handlerName)
	handler = ArenaLive:GetHandler(handlerName);
	if ( not handler.canToggle ) then
		return;
	end
	
	local database = ArenaLive:GetDBComponent(self.addon, handler.name, self.group);
	if ( database.Enabled ) then
		self[handlerName].enabled = true;
		if ( handler.OnEnable ) then
			handler:OnEnable(self);
		end
	else
		self[handlerName].enabled = nil;
		if ( handler.OnDisable ) then
			handler:OnDisable(self);
		end
	end
end

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
--[[ Method: ConstructObject
	 Create a unit frame and equip it with necessary methods etc.
		frame (frame): The unit frame.
		addonName (string): Name of the addon the frame belongs to.
		frameGroup (string): Unit frame group in the addon's data base the frame belongs to.
		leftClick (string [optional]): Action to execute when frame is left clicked. Defaults to "target".
		rightClick (string [optional]): Action to execute when frame is right clicked. Defaults to "togglemenu".
		menuFunc (function [optional]): If either leftClick or rightClick is set to "menu" then add the function to open the menu here. Otherwise leave this blank.
		alwaysVisible (boolean): If true, the frame will allways be visible, even if it has no unit.
		hasHeader (boolean): This is to inform the function if the frame is part of a frame group (e.g. Party frames, Arena Frames etc.) or not. DO NOT CONFUSE THIS WITH the frameGroup arg.
]]--
function UnitFrame:ConstructObject(frame, addonName, frameGroup, leftClick, rightClick, menuFunc, alwaysVisible, hasHeader)
	
	if ( InCombatLockdown() ) then
		ArenaLive:Message (L["Couldn't construct new unit frame, because interface currently is in combat lockdown!"], "error", handlerName, frameName);
		return;
	end
	
	ArenaLive:CheckArgs(frame, "Button", addonName, "string");

	-- Set addon name:
	frame.addon = addonName;
	frame.group = frameGroup;
	frame.hasHeader = hasHeader;
	
	-- Set up clicking scripts:
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	frame:SetAttribute("*type1", leftClick or "target");
	frame:SetAttribute("*type2", rightClick or "togglemenu");
	
	if ( leftClick == "menu" or rightClick == "menu" ) then
		frame.menu = menuFunc;
	end
	
	-- Add unit frame methods and set scripts:
	ArenaLive:CopyClassMethods(UnitFrameClass, frame);
	
	frame:SetScript("OnAttributeChanged", frame.OnAttributeChanged);
	frame:SetScript("OnEnter", frame.OnEnter);
	frame:SetScript("OnLeave", frame.OnLeave);	
	
	-- Add ClickCast functionality:
	UnitFrame:RegisterClickCast(frame);	

	-- Add Frame to unit frame table and set its ID according to the entry:
	table.insert(UnitFrame.UnitFrames, frame);
	frame.id = #UnitFrame.UnitFrames;
	
	local database = ArenaLive:GetDBComponent(addonName, self.name, frameGroup);
	if ( database.Enabled ) then
		frame:Enable();
	else
		frame:Disable();
	end
	
	-- Set Attribute after enabling/disabling the frame so it will update the visibility once:
	if ( not hasHeader ) then
		frame:SetAttribute("al_alwaysvisible", alwaysVisible);
	end
	
	--ArenaLive:Message(L["Successfully created new unit frame with the name %s!"], "debug", frame:GetName() or tostring(frame));
end

--[[ Method: RegisterClickCast
	 Registers click cast addons for the specified frame.
		frame (frame): the affected frame.
]]--
function UnitFrame:RegisterClickCast(frame)

	-- If the addon is loaded before the click cast addon set up the table for these addon's first.
	if ( not ClickCastFrames ) then
		ClickCastFrames = {};
	end
	
	ClickCastFrames[frame] = true;

end

--[[ Method: UnregisterClickCast
	 Unregisters click cast addons for the specified frame.
		frame (frame): the affected frame.
]]--
function UnitFrame:UnregisterClickCast(frame)

	if ( ClickCastFrames ) then
		ClickCastFrames[frame] = nil;
	end

end

--[[ Method: OnEvent
	 ArenaLive's CoreEvent.lua will forward all registered event fires for the UnitFrame handler to this method.
		event (string): The event that fired.
		... (list): A list of further information that accompanies the event trigger.
]]--
function UnitFrame:OnEvent(event, ...)
	local filter = ...;
	
	if ( event == "PLAYER_REGEN_ENABLED" ) then
		for frame, unit in pairs(self.updateUnitCallback) do
			if ( unit == "reset" ) then
				frame:UpdateUnit();
			else
				frame:UpdateUnit(unit);
			end
		end
		table.wipe(self.updateUnitCallback);
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		if ( UnitExists("target") ) then
			if ( ArenaLive:IsUnitInUnitFrameCache("target") ) then
				for id, isRegistered in ArenaLive:GetAffectedUnitFramesByUnit("target") do
					local frame = self.UnitFrames[id];
					frame:UpdateGUID();
					frame:Update();
				end
			end
		end
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		if ( UnitExists("focus") ) then
			if ( ArenaLive:IsUnitInUnitFrameCache("focus") ) then
				for id, isRegistered in ArenaLive:GetAffectedUnitFramesByUnit("focus") do
					local frame = self.UnitFrames[id];
					frame:UpdateGUID();
					frame:Update();
				end
			end
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		-- NOTE: May cause lags, because we update ALL the unit frames at once during every loading screen. Just keep this note in case we need to get rid of it:
		for id, frame in ArenaLive:GetAllUnitFrames() do
			if ( frame.enabled ) then
				frame:Update();
			end
		end
	else
		if ( event == "UNIT_PET") then
			local unitType = string.match(filter, "^([a-z]+)[0-9]+$") or filter;
			local unitNumber = tonumber(string.match(filter, "^[a-z]+([0-9]+)$"));
			
			if ( unitType == "player" ) then
				filter = "pet";
			elseif ( unitNumber ) then
				filter = unitType.."pet"..unitNumber;
			else
				filter = unitType.."pet";
			end
		end
		
		if ( ArenaLive:IsUnitInUnitFrameCache(filter) ) then
			for id, isRegistered in ArenaLive:GetAffectedUnitFramesByUnit(filter) do
				local frame = self.UnitFrames[id];
				frame:UpdateGUID();
				frame:Update();
			end
		end

	end
end

----------------------------------------------------------------
--                                                            --
--                        FIX LUA ERROR                       --
--                                                            --
----------------------------------------------------------------

function CompactUnitFrame_UpdateMaxHealth(frame)
    if frame.displayedUnit then
        local maxHealth = UnitHealthMax(frame.displayedUnit);
        frame.healthBar:SetMinMaxValues(0, maxHealth);
        CompactUnitFrame_UpdateHealPrediction(frame);
    end
end

function CompactUnitFrame_UpdateHealth(frame)
    if frame.displayedUnit then
        frame.healthBar:SetValue(UnitHealth(frame.displayedUnit));
    end
end

function CompactUnitFrame_UpdateHealthColor(frame)
    if frame.displayedUnit then
        local r, g, b;
        if ( not UnitIsConnected(frame.unit) ) then
            --Color it gray
            r, g, b = 0.5, 0.5, 0.5;
        else
            --Try to color it by class.
            local localizedClass, englishClass = UnitClass(frame.unit);
            local classColor = RAID_CLASS_COLORS[englishClass];
            if ( classColor and frame.optionTable.useClassColors ) then
                r, g, b = classColor.r, classColor.g, classColor.b;
            else
                if ( UnitIsFriend("player", frame.unit) ) then
                    r, g, b = 0.0, 1.0, 0.0;
                else
                    r, g, b = 1.0, 0.0, 0.0;
                end
            end
        end
        if ( r ~= frame.healthBar.r or g ~= frame.healthBar.g or b ~= frame.healthBar.b ) then
            frame.healthBar:SetStatusBarColor(r, g, b);
            frame.healthBar.r, frame.healthBar.g, frame.healthBar.b = r, g, b;
        end
    end
end

local function CompactUnitFrame_GetDisplayedPowerID(frame)
	local barType, minPower, startInset, endInset, smooth, hideFromOthers, showOnRaid, opaqueSpark, opaqueFlash, powerName, powerTooltip = UnitAlternatePowerInfo(frame.displayedUnit);
	if ( showOnRaid and (UnitInParty(frame.unit) or UnitInRaid(frame.unit)) ) then
		return ALTERNATE_POWER_INDEX;
	else
		return (UnitPowerType(frame.displayedUnit));
	end
end

function CompactUnitFrame_UpdateMaxPower(frame)	
    if frame.displayedUnit then
        frame.powerBar:SetMinMaxValues(0, UnitPowerMax(frame.displayedUnit, CompactUnitFrame_GetDisplayedPowerID(frame)));
    end
end

function CompactUnitFrame_UpdatePower(frame)
    if frame.displayedUnit then
        frame.powerBar:SetValue(UnitPower(frame.displayedUnit, CompactUnitFrame_GetDisplayedPowerID(frame)));
    end
end

function CompactUnitFrame_UpdatePowerColor(frame)
    if frame.displayedUnit then
        local r, g, b;
        if ( not UnitIsConnected(frame.unit) ) then
            --Color it gray
            r, g, b = 0.5, 0.5, 0.5;
        else
            --Set it to the proper power type color.
            local barType, minPower, startInset, endInset, smooth, hideFromOthers, showOnRaid, opaqueSpark, opaqueFlash, powerName, powerTooltip = UnitAlternatePowerInfo(frame.unit);
            if ( showOnRaid ) then
                r, g, b = 0.7, 0.7, 0.6;
            else
                local powerType, powerToken, altR, altG, altB = UnitPowerType(frame.displayedUnit);
                local prefix = _G[powerToken];
                local info = PowerBarColor[powerToken];
                if ( info ) then
                        r, g, b = info.r, info.g, info.b;
                else
                    if ( not altR) then
                        -- couldn't find a power token entry...default to indexing by power type or just mana if we don't have that either
                        info = PowerBarColor[powerType] or PowerBarColor["MANA"];
                        r, g, b = info.r, info.g, info.b;
                    else
                        r, g, b = altR, altG, altB;
                    end
                end
            end
        end
        frame.powerBar:SetStatusBarColor(r, g, b);
    end
end

function CompactUnitFrame_UpdateName(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayName ) then
            frame.name:Hide();
            return;
        end
        
        frame.name:SetText(GetUnitName(frame.unit, true));
        frame.name:Show();
    end
end

function CompactUnitFrame_UpdateSelectionHighlight(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displaySelectionHighlight ) then
            frame.selectionHighlight:Hide();
            return;
        end
        
        if ( UnitIsUnit(frame.displayedUnit, "target") ) then
            frame.selectionHighlight:Show();
        else
            frame.selectionHighlight:Hide();
        end
    end
end

function CompactUnitFrame_UpdateAggroHighlight(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayAggroHighlight ) then
            frame.aggroHighlight:Hide();
            return;
        end
        
        local status = UnitThreatSituation(frame.displayedUnit);
        if ( status and status > 0 ) then
            frame.aggroHighlight:SetVertexColor(GetThreatStatusColor(status));
            frame.aggroHighlight:Show();
        else
            frame.aggroHighlight:Hide();
        end
    end
end

function CompactUnitFrame_UpdateInRange(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.fadeOutOfRange ) then
            frame:SetAlpha(1);
            return;
        end
        
        local inRange, checkedRange = UnitInRange(frame.displayedUnit);
        if ( checkedRange and not inRange ) then	--If we weren't able to check the range for some reason, we'll just treat them as in-range (for example, enemy units)
            frame:SetAlpha(0.55);
        else
            frame:SetAlpha(1);
        end
    end
end

function CompactUnitFrame_UpdateStatusText(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayStatusText ) then
            frame.statusText:Hide();
            return;
        end
        
        if ( not UnitIsConnected(frame.unit) ) then
            frame.statusText:SetText(PLAYER_OFFLINE)
            frame.statusText:Show();
        elseif ( UnitIsDeadOrGhost(frame.displayedUnit) ) then
            frame.statusText:SetText(DEAD);
            frame.statusText:Show();
        elseif ( frame.optionTable.healthText == "health" ) then
            frame.statusText:SetText(UnitHealth(frame.displayedUnit));
            frame.statusText:Show();
        elseif ( frame.optionTable.healthText == "losthealth" ) then
            local healthLost = UnitHealthMax(frame.displayedUnit) - UnitHealth(frame.displayedUnit);
            if ( healthLost > 0 ) then
                frame.statusText:SetFormattedText(LOST_HEALTH, healthLost);
                frame.statusText:Show();
            else
                frame.statusText:Hide();
            end
        elseif ( (frame.optionTable.healthText == "perc") and (UnitHealthMax(frame.displayedUnit) > 0) ) then
            local perc = math.ceil(100 * (UnitHealth(frame.displayedUnit)/UnitHealthMax(frame.displayedUnit)));
            frame.statusText:SetFormattedText("%d%%", perc);
            frame.statusText:Show();
        else
            frame.statusText:Hide();
        end
    end
end

local MAX_INCOMING_HEAL_OVERFLOW = 1.05;
function CompactUnitFrame_UpdateHealPrediction(frame)
    if frame.displayedUnit then
        local _, maxHealth = frame.healthBar:GetMinMaxValues();
        local health = frame.healthBar:GetValue();
        
        if ( maxHealth <= 0 ) then
            return;
        end
        
        if ( not frame.optionTable.displayHealPrediction ) then
            frame.myHealPrediction:Hide();
            frame.otherHealPrediction:Hide();
            frame.totalAbsorb:Hide();
            frame.totalAbsorbOverlay:Hide();
            frame.overAbsorbGlow:Hide();
            frame.myHealAbsorb:Hide();
            frame.myHealAbsorbLeftShadow:Hide();
            frame.myHealAbsorbRightShadow:Hide();
            frame.overHealAbsorbGlow:Hide();
            return;
        end

        local myIncomingHeal = UnitGetIncomingHeals(frame.displayedUnit, "player") or 0;
        local allIncomingHeal = UnitGetIncomingHeals(frame.displayedUnit) or 0;
        local totalAbsorb = UnitGetTotalAbsorbs(frame.displayedUnit) or 0;
        
        --We don't fill outside the health bar with healAbsorbs.  Instead, an overHealAbsorbGlow is shown.
        local myCurrentHealAbsorb = UnitGetTotalHealAbsorbs(frame.displayedUnit) or 0;
        if ( health < myCurrentHealAbsorb ) then
            frame.overHealAbsorbGlow:Show();
            myCurrentHealAbsorb = health;
        else
            frame.overHealAbsorbGlow:Hide();
        end
        
        --See how far we're going over the health bar and make sure we don't go too far out of the frame.
        if ( health - myCurrentHealAbsorb + allIncomingHeal > maxHealth * MAX_INCOMING_HEAL_OVERFLOW ) then
            allIncomingHeal = maxHealth * MAX_INCOMING_HEAL_OVERFLOW - health + myCurrentHealAbsorb;
        end
        
        local otherIncomingHeal = 0;
        
        --Split up incoming heals.
        if ( allIncomingHeal >= myIncomingHeal ) then
            otherIncomingHeal = allIncomingHeal - myIncomingHeal;
        else
            myIncomingHeal = allIncomingHeal;
        end

        local overAbsorb = false;
        --We don't fill outside the the health bar with absorbs.  Instead, an overAbsorbGlow is shown.
        if ( health - myCurrentHealAbsorb + allIncomingHeal + totalAbsorb >= maxHealth or health + totalAbsorb >= maxHealth ) then
            if ( totalAbsorb > 0 ) then
                overAbsorb = true;
            end
            
            if ( allIncomingHeal > myCurrentHealAbsorb ) then
                totalAbsorb = max(0,maxHealth - (health - myCurrentHealAbsorb + allIncomingHeal));
            else
                totalAbsorb = max(0,maxHealth - health);
            end
        end
        if ( overAbsorb ) then
            frame.overAbsorbGlow:Show();
        else
            frame.overAbsorbGlow:Hide();
        end
        
        local healthTexture = frame.healthBar:GetStatusBarTexture();
        
        local myCurrentHealAbsorbPercent = myCurrentHealAbsorb / maxHealth;
        
        local healAbsorbTexture = nil;
        
        --If allIncomingHeal is greater than myCurrentHealAbsorb, then the current
        --heal absorb will be completely overlayed by the incoming heals so we don't show it.
        if ( myCurrentHealAbsorb > allIncomingHeal ) then
            local shownHealAbsorb = myCurrentHealAbsorb - allIncomingHeal;
            local shownHealAbsorbPercent = shownHealAbsorb / maxHealth;
            healAbsorbTexture = CompactUnitFrameUtil_UpdateFillBar(frame, healthTexture, frame.myHealAbsorb, shownHealAbsorb, -shownHealAbsorbPercent);
            
            --If there are incoming heals the left shadow would be overlayed by the incoming heals
            --so it isn't shown.
            if ( allIncomingHeal > 0 ) then
                frame.myHealAbsorbLeftShadow:Hide();
            else
                frame.myHealAbsorbLeftShadow:SetPoint("TOPLEFT", healAbsorbTexture, "TOPLEFT", 0, 0);
                frame.myHealAbsorbLeftShadow:SetPoint("BOTTOMLEFT", healAbsorbTexture, "BOTTOMLEFT", 0, 0);
                frame.myHealAbsorbLeftShadow:Show();
            end
            
            -- The right shadow is only shown if there are absorbs on the health bar.
            if ( totalAbsorb > 0 ) then
                frame.myHealAbsorbRightShadow:SetPoint("TOPLEFT", healAbsorbTexture, "TOPRIGHT", -8, 0);
                frame.myHealAbsorbRightShadow:SetPoint("BOTTOMLEFT", healAbsorbTexture, "BOTTOMRIGHT", -8, 0);
                frame.myHealAbsorbRightShadow:Show();
            else
                frame.myHealAbsorbRightShadow:Hide();
            end
        else
            frame.myHealAbsorb:Hide();
            frame.myHealAbsorbRightShadow:Hide();
            frame.myHealAbsorbLeftShadow:Hide();
        end
        
        --Show myIncomingHeal on the health bar.
        local incomingHealsTexture = CompactUnitFrameUtil_UpdateFillBar(frame, healthTexture, frame.myHealPrediction, myIncomingHeal, -myCurrentHealAbsorbPercent);
        --Append otherIncomingHeal on the health bar.
        incomingHealsTexture = CompactUnitFrameUtil_UpdateFillBar(frame, incomingHealsTexture, frame.otherHealPrediction, otherIncomingHeal);
        
        --Appen absorbs to the correct section of the health bar.
        local appendTexture = nil;
        if ( healAbsorbTexture ) then
            --If there is a healAbsorb part shown, append the absorb to the end of that.
            appendTexture = healAbsorbTexture;
        else
            --Otherwise, append the absorb to the end of the the incomingHeals part;
            appendTexture = incomingHealsTexture;
        end
        CompactUnitFrameUtil_UpdateFillBar(frame, appendTexture, frame.totalAbsorb, totalAbsorb)
    end
end

function CompactUnitFrame_UpdateRoleIcon(frame)
    if frame.displayedUnit then
        local size = frame.roleIcon:GetHeight();	--We keep the height so that it carries from the set up, but we decrease the width to 1 to allow room for things anchored to the role (e.g. name).
        local raidID = UnitInRaid(frame.unit);
        if ( UnitInVehicle(frame.unit) and UnitHasVehicleUI(frame.unit) ) then
            frame.roleIcon:SetTexture("Interface\\Vehicles\\UI-Vehicles-Raid-Icon");
            frame.roleIcon:SetTexCoord(0, 1, 0, 1);
            frame.roleIcon:Show();
            frame.roleIcon:SetSize(size, size);
        elseif ( frame.optionTable.displayRaidRoleIcon and raidID and select(10, GetRaidRosterInfo(raidID)) ) then
            local role = select(10, GetRaidRosterInfo(raidID));
            frame.roleIcon:SetTexture("Interface\\GroupFrame\\UI-Group-"..role.."Icon");
            frame.roleIcon:SetTexCoord(0, 1, 0, 1);
            frame.roleIcon:Show();
            frame.roleIcon:SetSize(size, size);
        else
            local role = UnitGroupRolesAssigned(frame.unit);
            if ( frame.optionTable.displayRoleIcon and (role == "TANK" or role == "HEALER" or role == "DAMAGER") ) then
                frame.roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
                frame.roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
                frame.roleIcon:Show();
                frame.roleIcon:SetSize(size, size);
            else
                frame.roleIcon:Hide();
                frame.roleIcon:SetSize(1, size);
            end
        end
    end
end
function CompactUnitFrame_UpdateBuffs(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayBuffs ) then
            CompactUnitFrame_HideAllBuffs(frame);
            return;
        end
        
        local index = 1;
        local frameNum = 1;
        local filter = nil;
        while ( frameNum <= frame.maxBuffs ) do
            local buffName = UnitBuff(frame.displayedUnit, index, filter);
            if ( buffName ) then
                if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
                    local buffFrame = frame.buffFrames[frameNum];
                    CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        for i=frameNum, frame.maxBuffs do
            local buffFrame = frame.buffFrames[i];
            buffFrame:Hide();
        end
    end
end

function CompactUnitFrame_UpdateDebuffs(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayDebuffs ) then
            CompactUnitFrame_HideAllDebuffs(frame);
            return;
        end
        
        local index = 1;
        local frameNum = 1;
        local filter = nil;
        local maxDebuffs = frame.maxDebuffs;
        --Show both Boss buffs & debuffs in the debuff location
        --First, we go through all the debuffs looking for any boss flagged ones.
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false);
                    frameNum = frameNum + 1;
                    --Boss debuffs are about twice as big as normal debuffs, so display one less.
                    local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
                    maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
                end
            else
                break;
            end
            index = index + 1;
        end
        --Then we go through all the buffs looking for any boss flagged ones.
        index = 1;
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitBuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true);
                    frameNum = frameNum + 1;
                    --Boss debuffs are about twice as big as normal debuffs, so display one less.
                    local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
                    maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
                end
            else
                break;
            end
            index = index + 1;
        end
        
        --Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
        index = 1;
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        
        if ( frame.optionTable.displayOnlyDispellableDebuffs ) then
            filter = "RAID";
        end
        
        index = 1;
        --Now, we display all normal debuffs.
        if ( frame.optionTable.displayNonBossDebuffs ) then
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and
                    not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter)) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        end
        
        for i=frameNum, frame.maxDebuffs do
            local debuffFrame = frame.debuffFrames[i];
            debuffFrame:Hide();
        end
    end
end

local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};
function CompactUnitFrame_UpdateDispellableDebuffs(frame)
    if frame.displayedUnit then
        if ( not frame.optionTable.displayDispelDebuffs ) then
            CompactUnitFrame_HideAllDispelDebuffs(frame);
            return;
        end
        
        --Clear what we currently have.
        for debuffType, display in pairs(dispellableDebuffTypes) do
            if ( display ) then
                frame["hasDispel"..debuffType] = false;
            end
        end
        
        local index = 1;
        local frameNum = 1;
        local filter = "RAID";	--Only dispellable debuffs.
        while ( frameNum <= frame.maxDispelDebuffs ) do
            local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId = UnitDebuff(frame.displayedUnit, index, filter);
            if ( dispellableDebuffTypes[debuffType] and not frame["hasDispel"..debuffType] ) then
                frame["hasDispel"..debuffType] = true;
                local dispellDebuffFrame = frame.dispelDebuffFrames[frameNum];
                CompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
                frameNum = frameNum + 1;
            elseif ( not name ) then
                break;
            end
            index = index + 1;
        end
        for i=frameNum, frame.maxDispelDebuffs do
            local dispellDebuffFrame = frame.dispelDebuffFrames[i];
            dispellDebuffFrame:Hide();
        end
    end
end

function CompactUnitFrame_UpdateCenterStatusIcon(frame)
    if frame.displayedUnit then
        if ( frame.optionTable.displayInOtherGroup and UnitInOtherParty(frame.unit) ) then
            frame.centerStatusIcon.texture:SetTexture("Interface\\LFGFrame\\LFG-Eye");
            frame.centerStatusIcon.texture:SetTexCoord(0.125, 0.25, 0.25, 0.5);
            frame.centerStatusIcon.border:SetTexture("Interface\\Common\\RingBorder");
            frame.centerStatusIcon.border:Show();
            frame.centerStatusIcon.tooltip = PARTY_IN_PUBLIC_GROUP_MESSAGE;
            frame.centerStatusIcon:Show();
        elseif ( frame.optionTable.displayIncomingResurrect and UnitHasIncomingResurrection(frame.unit) ) then
            frame.centerStatusIcon.texture:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez");
            frame.centerStatusIcon.texture:SetTexCoord(0, 1, 0, 1);
            frame.centerStatusIcon.border:Hide();
            frame.centerStatusIcon.tooltip = nil;
            frame.centerStatusIcon:Show();
        else
            frame.centerStatusIcon:Hide();
        end
    end
end

function UnitFrame_UpdateTooltip (self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
    if self.unit then
        if ( GameTooltip:SetUnit(self.unit, self.hideStatusOnTooltip) ) then
            self.UpdateTooltip = UnitFrame_UpdateTooltip;
        else
            self.UpdateTooltip = nil;
        end
        local r, g, b = GameTooltip_UnitColor(self.unit);
        --GameTooltip:SetBackdropColor(r, g, b);
        GameTooltipTextLeft1:SetTextColor(r, g, b);
    end
end
--[[ ArenaLive Core Functions: Portrait Handler
Created by: Vadrak
Creation Date: 06.04.2014
Last Update: 17.05.2014
This file stores the function for unit portraits. It can show class icons or three dimensional portraits. 
]]--

-- ArenaLive addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--

-- Create new Handler and register for all important events:
local Portrait = ArenaLive:ConstructHandler("Portrait", true, false);
Portrait:RegisterEvent("UNIT_PORTRAIT_UPDATE");



--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
--[[ Method: ConstructObject
	 Creates a new portrait frame.
		portrait (Frame): The frame that is going to be set up as a portrait frame.
		texture (Texture): A texture that will be used to show the class icon.
		unitFrame (Frame): The unit frame the portrait belongs to. This is used to set the OnUpdate script. 
]]--
function Portrait:ConstructObject(portrait, background, texture, unitFrame)

	ArenaLive:CheckArgs(portrait, "table", texture, "table", unitFrame, "Button");
	
	-- Set fram references:
	portrait.background = background;
	portrait.texture = texture;

	-- Set OnShow script:
	-- The OnShow event is used, because some times the portrait won't update correctly for "target" otherwise
	-- TODO: The current function is a temporary fix. Need to change that in the future.
	portrait:SetScript("OnShow", function() Portrait:Update(unitFrame) end);
end

--[[ Method: Update
	 Updates new portrait frame.
		unitFrame (Frame): The unit frame that is affected by the change.
]]--
function Portrait:Update(unitFrame)
	local unit = unitFrame.unit;
	
	if ( not unit ) then
		return;
	end
	
	local portrait = unitFrame[self.name];
	local database = ArenaLive:GetDBComponent(unitFrame.addon, self.name, unitFrame.group);
	local portraitType = database.Type;
	if ( portraitType == "class" ) then
		local _, class;
		if ( unitFrame.test ) then
			class = ArenaLive.testModeValues[unitFrame.test]["class"];
		else
			_, class = UnitClass(unit);
		end
		
		local isPlayer = UnitIsPlayer(unit);

		if ( class and ( isPlayer or unitFrame.test ) ) then
			-- Show class icon for players:
			if ArenaLive:GetSpecializationByUnit(unit) then
				local _, _, _, specTexture = GetSpecializationInfoByID(ArenaLive:GetSpecializationByUnit(unit));
				portrait.texture:SetTexture(specTexture);
				portrait.texture:SetTexCoord(0, 1, 0, 1);
			else
				portrait.texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
				portrait.texture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
			end
			portrait.texture:Show();
		end
	elseif ( portraitType == "twoD" ) then
		portrait.texture:SetTexCoord(0, 1, 0, 1);
		
		if ( unitFrame.test ) then
			SetPortraitTexture(portrait.texture, "player");
		else
			SetPortraitTexture(portrait.texture, unit);
		end
		
		portrait.texture:Show();
	else
		Portrait:Reset(unitFrame);
	end

end

function Portrait:Reset(unitFrame)
	local portrait = unitFrame[self.name];
	
	portrait.texture:SetTexCoord(0, 1, 0, 1);
	portrait.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
	portrait.texture:Show();
end

function Portrait:OnEvent(event, ...)
	local unit = ...;
	if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame[self.name] ) then
				Portrait:Update(unitFrame);
			end
		end
	end
end

Portrait.optionSets = {
	["Type"] = {
		["type"] = "DropDown",
		["width"] = 100,
		["title"] = L["Portrait Type"],
		["emptyText"] = L["Choose the portrait type for the unit frame's character portrait."],
		["infoTable"] = {
			[1] = {
				["value"] = "class",
				["text"] = L["Class Icon"],
			},
			[3] = {
				["value"] = "twoD",
				["text"] = L["2D Portrait"],
			},
		},
		["GetDBValue"] = function (frame) 
			local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group);
			return database.Type; 
		end,
		["SetDBValue"] = function (frame, newValue)
			local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group);
			database.Type = newValue;
		end,
		["postUpdate"] = function (frame, newValue, oldValue)
			for id, unitFrame in ArenaLive:GetAllUnitFrames() do 
				if ( unitFrame.addon == frame.addon and unitFrame.group == frame.group and unitFrame[frame.handler] ) then 
					Portrait:Update(unitFrame);
				end
			end 
		end,
	},
};
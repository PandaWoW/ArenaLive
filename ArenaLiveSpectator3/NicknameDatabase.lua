local addonName, L = ...;

ArenaLiveSpectator.NicknameDatabase = {};
local NicknameDatabase = ArenaLiveSpectator.NicknameDatabase;
local NameText = ArenaLive:GetHandler("NameText");

local database;
local battleTagToCharacterName = {};

StaticPopupDialogs["ALSPEC_CONFIRM_CLEAR_NICKNAME_DB"] = {
	text = L["Clearing the nickname database will delete all player nicknames. Do you want to proceed?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) NicknameDatabase:ClearDatabase(); ArenaLiveSpectatorWarGameMenuSettingsNicknamePlayerButton:Update(); ArenaLiveSpectatorWarGameMenuPlayerScrollFrame:update(); end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	preferredIndex = STATICPOPUP_NUMDIALOGS, -- Avoid some UI taint.
}



function NicknameDatabase:Initialise()
	database = ArenaLive:GetDBComponent(addonName);
	database = database.NicknameDatabase;
	self.waitForNicknameInit = true;
end

function NicknameDatabase:InitialiseNicknames()
	for battleTag, nickname in pairs(database) do
		local _, _, _, _, toonID, client = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
		NicknameDatabase:UpdateCharacter(battleTag, toonID);
	end
end

function NicknameDatabase:UpdateNickname(battleTag, nickname)
	
	if ( not battleTag or not nickname or database[battleTag] == nickname ) then
		return;
	end
	
	-- Reset old Entry:
	if ( database[battleTag] ) then
		NicknameDatabase:RemoveNickname(battleTag);
	end
	
	local _, _, _, _, toonID, client = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
	if ( battleTag and nickname ) then
		database[battleTag] = nickname;
		if ( toonID and client == BNET_CLIENT_WOW ) then
			NicknameDatabase:UpdateCharacter(battleTag, toonID);
		end
	end
end

function NicknameDatabase:RemoveNickname(battleTag)
	if ( database[battleTag] ) then
		database[battleTag] = nil;
		if ( battleTagToCharacterName[battleTag] ) then
			if ( battleTagToCharacterName[battleTag] ) then
				-- Reset current active nickname for player:
				NameText:RemoveNickname(battleTagToCharacterName[battleTag]);
				battleTagToCharacterName[battleTag] = nil;
			end
		end
	end
end

function NicknameDatabase:UpdateCharacter(battleTag, toonID)
	if ( database[battleTag] ) then
		local _, name, _, realm = BNGetToonInfo(toonID);
		name = name.."-"..realm;
		
		-- Reset existing character nickname:
		if ( battleTagToCharacterName[battleTag] ) then
			NameText:RemoveNickname(battleTagToCharacterName[battleTag]);
		end
		
		battleTagToCharacterName[battleTag] = name;
		NameText:AddNickname(name, database[battleTag]);
	end
end

function NicknameDatabase:ClearDatabase()
	for battleTag, nickname in pairs(database) do
		NicknameDatabase:RemoveNickname(battleTag);
	end
end

function NicknameDatabase:IsToonRegistered(battleTag, toonID)
	local hasFocus, toonName, client, realmName = BNGetToonInfo(toonID);
	if ( client == BNET_CLIENT_WOW ) then
		local name = toonName.."-"..toonName;
		if ( battleTagToCharacterName[battleTag] and battleTagToCharacterName[battleTag] == name ) then
			return true;
		else
			return false;
		end
	else
		return -1; -- Indicates that the unit isn't logged into WoW
	end
end

function NicknameDatabase:OnToonNameUpdate(toonID)
	if ( not toonID ) then
		return;
	end
	
	local _, toonName, client, realmName, _, _, _, _, _, _, _, _, _, _, _, presenceID  = BNGetToonInfo(toonID);
	if ( client ~= BNET_CLIENT_WOW ) then
		return;
	end
	
	if ( presenceID ) then
		local _, _, battleTag = BNGetFriendInfoByID(presenceID);
		if ( battleTag and toonID and database[battleTag] ) then
			if ( not NicknameDatabase:IsToonRegistered(battleTag, toonID) ) then
				NicknameDatabase:UpdateCharacter(battleTag, toonID);
			end
		end
	end
end
PlayerHandler = {};

local ClassIdToName = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "MONK", "DRUID" };

function ArenaLiveSpectator:CreatePlayer(value)
    local _player = {}
    
    _player.name = "UNNAMED";
    _player.guid = value;
    _player.class = "NONCLASS";
    _player.team = 0;
    _player.teamSlot = 0;
    
    return _player;
end

function PlayerHandler:IsPlayer(unit)
    for _, player in pairs(Players) do
        if player.name == unit then
            return true;
        end
    end
    
    return false;
end

function ArenaLiveSpectator:GetPlayerByGUID(guid)
    for _, player in pairs(Players) do
        if player.guid == guid then
            return player.name;
        end
    end
    
    print("GetPlayerByGUID return false");
    return false;
end

function ArenaLiveSpectator:GetPlayerGUID(unit)
    for _, player in pairs(Players) do
        if player.name == unit then
            return player.guid;
        end
    end
    
    print("GetPlayerGUID return false "..unit);
    return false;
end

function ArenaLiveSpectator:UpdateName(guid, name)
    Players[guid].name = name;
end

function PlayerHandler:UpdateClass(guid, class)
    Players[guid].class = ClassIdToName[class];
end

function PlayerHandler:GetClass(unit)
    local _class = "NONCLASS";
    
    for _, player in pairs(Players) do
        if player.name == unit then
            _class = player.class;
        end
    end

    return _class;
end

function ArenaLiveSpectator:UpdateTeam(guid, teamId)
    Players[guid].team = teamId;
    
    if Players[guid].teamSlot == 0 then
        Players[guid].teamSlot = ArenaLiveSpectator:GetFreeTeamSlot(Players[guid]);
        ArenaLiveSpectator:SetNumPlayers(3);
    end
end

function ArenaLiveSpectator:GetNumPlayersInTeam(team)
    local i = 0;
        
    for _, player in pairs(Players) do
        if player.team == team then
            i = i + 1;
        end
    end
        
    return i;
end

function ArenaLiveSpectator:GetFreeTeamSlot(player)
    for _, _player in pairs(Players) do
        if _player.name ~= player.name and _player.team == player.team then
            if player.teamSlot == 0 or player.teamSlot == 1 then
                return 2;
            end
        end
    end
    
    return 1;
end

function ArenaLiveSpectator:GetPlayerByTeamSlot(teamNumber, slot)
    for _, player in pairs(Players) do
        if player.team == teamNumber and player.teamSlot == slot then
            return player.name;
        end
    end
end

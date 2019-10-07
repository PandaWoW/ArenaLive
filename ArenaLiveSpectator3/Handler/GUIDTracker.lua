local addonName, L = ...;
local guidToUnit = {};

function ArenaLiveSpectator:RefreshGUIDs()
	table.wipe(guidToUnit);

	local unit, guid;

    for i = 1, 5 do
		unit = "commentator"..i;
		guid = UnitGUID(unit);

        if guid then
			guidToUnit[guid] = unit;
		end

		unit = "commentator"..5+i;
		guid = UnitGUID(unit);

        if guid then
			guidToUnit[guid] = unit;
		end

	end
end

function ArenaLiveSpectator:GetUnitByGUID(guid)
	return guidToUnit[guid];
end

function ArenaLiveSpectator:GetNumPlayersInTeam(unitId)
    local count = 0;

    for _, unit in pairs(guidToUnit) do
        if string.find(unit, unitId)then
            count = count + 1;
        end
    end

    return count;
end
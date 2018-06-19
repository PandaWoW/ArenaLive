local addonName, L = ...;

local guidToUnit = {};
function ArenaLiveSpectator:RefreshGUIDs()
	table.wipe(guidToUnit);

	local unit, guid;
	for i = 1, 5 do
		unit = "spectateda"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
		
		unit = "spectatedpeta"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end

		unit = "spectatedb"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
		
		unit = "spectatedpetb"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
	end
end

function ArenaLiveSpectator:GetUnitByGUID(guid)
	return guidToUnit[guid];
end
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

function ArenaLiveSpectator:ConvertGUID(guidLow)
    local B, K, GUID, I, D = 16, "0123456789ABCDEF", "", 0;
    
    while guidLow > 0 do
        I = I + 1;
        guidLow, D = math.floor(guidLow / B), mod(guidLow, B) + 1;
        GUID = string.sub(K, D, D)..GUID;
    end
    
    return "0x0180000000"..GUID;
end
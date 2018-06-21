CommandHandler = {};

function CommandHandler:ForceUpdate()
    SendChatMessage(".spectate reset", "GUILD");
end

function CommandHandler:Execute(target, prefix, ...)
    local value = ...;
    
    if (Players[target] == nil) then
        Players[target] = ArenaLiveSpectator:CreatePlayer(target);
        CommandHandler:ForceUpdate();
    end

    -- TODO remove it
    --MainTargetIndicator:UpdateNumPlayers();
    
    if (prefix == "TEM") then
        ArenaLiveSpectator:UpdateTeam(target, tonumber(value));
    elseif (prefix == "NME") then
        ArenaLiveSpectator:UpdateName(target, value);
    elseif (prefix == "CLA") then
        PlayerHandler:UpdateClass(target, tonumber(value));
    end
end

function CommandHandler:ParseCommands(data)
    local pos = 1
    local stop = 1
    local target = nil

    -- if data:find(';AUR=') then
        -- local tar, data = strsplit(";", data)
        -- local _, data2 = strsplit("=", data)
        -- local aremove, astack, aexpiration, aduration, aspellId, adebyfftype, aisdebuff, acaster = strsplit(",", data2)
        -- --   e. g.
        -- --   DATA:Ringer;AUR=   0,                    0,                    -1,                    -1,                    6562,                    0,                    1,            0x00000000001C86C6;
        -- Execute(tar, "AUR", tonumber(aremove), tonumber(astack), tonumber(aexpiration), tonumber(aduration), tonumber(aspellId), tonumber(adebyfftype), tonumber(aisdebuff), acaster)
        -- return
    -- end

    stop = strfind(data, ";", pos)
    target = strsub(data, 1, stop - 1)
    pos = stop + 1
    
    target = tostring(CommandHandler:ConvertGUID(tonumber(target))); -- wow UnitGUID format
    
    if target == nil or target == "" then
        return;
    end
    
    repeat
        stop = strfind(data, ";", pos)
        if (stop ~= nil) then
            local command = strsub(data, pos, stop - 1)
            pos = stop + 1

            local prefix = strsub(command, 1, strfind(command, "=") - 1)
            local value = strsub(command, strfind(command, "=") + 1)

            CommandHandler:Execute(target, prefix, value)
        end
    until stop == nil
end

function CommandHandler:ConvertGUID(guidLow)
    local B, K, GUID, I, D = 16, "0123456789ABCDEF", "", 0;
    
    while guidLow > 0 do
        I = I + 1;
        guidLow, D = math.floor(guidLow / B), mod(guidLow, B) + 1;
        GUID = string.sub(K, D, D)..GUID;
    end
    
    return "0x0180000000"..GUID;
end

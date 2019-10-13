local addonName, L = ...;

local function OnUpdate(self, elapsed)
	local guid = UnitGUID("targettarget");
	if ( self.guid and guid ~= self.guid ) then
		local unit = ArenaLiveSpectator:GetUnitByGUID(guid) or "targettarget";
		self:UpdateUnit(unit);
	end
	
	if ( self.unit == "targettarget" ) then
		self:Update();
	end
end

function ArenaLiveSpectator:InitialiseTargetFrames ()
	
	local frame = ALSPEC_TargetFrame;
	local prefix = ALSPEC_TargetFrame:GetName();
	ArenaLive:ConstructHandlerObject(frame, "UnitFrame", addonName, "TargetFrame", "target", nil, nil, nil);
	
	frame:RegisterHandler(_G[prefix.."HealthBar"], "HealthBar", nil, _G[prefix.."HealthBarHealPredictionBar"], _G[prefix.."HealthBarAbsorbBar"], _G[prefix.."HealthBarAbsorbBarOverlay"], 32, _G[prefix.."HealthBarAbsorbBarFullHPIndicator"], nil, addonName, "TargetFrame");
	frame:RegisterHandler(_G[prefix.."PowerBar"], "PowerBar", nil, addonName, "TargetFrame");
	frame:RegisterHandler(_G[prefix.."Portrait"], "Portrait", nil, _G[prefix.."PortraitBackground"], _G[prefix.."PortraitTexture"], frame);
	frame:RegisterHandler(_G[prefix.."PortraitCCIndicator"], "CCIndicator", nil, _G[prefix.."PortraitCCIndicatorTexture"], _G[prefix.."PortraitCCIndicatorCooldown"], addonName);
	frame:RegisterHandler(_G[prefix.."Name"], "NameText", nil, frame);
	frame:RegisterHandler(_G[prefix.."HealthBarText"], "HealthBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."PowerBarText"], "PowerBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."CastBar"], "CastBar", nil, _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], _G[prefix.."CastBarShield"], _G[prefix.."CastBarAnimation"], _G[prefix.."CastBarAnimationFadeOut"], true, addonName, "TargetFrame");
	frame:RegisterHandler(_G[prefix.."CastHistory"], "CastHistory");
	frame:RegisterHandler(_G[prefix.."AuraFrame"], "Aura", nil, _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"]);

	local frame = ALSPEC_TargetTargetFrame;
	local prefix = ALSPEC_TargetTargetFrame:GetName();
	ArenaLive:ConstructHandlerObject(frame, "UnitFrame", addonName, "TargetTargetFrame", "target", nil, nil, nil);
	
	frame:RegisterHandler(_G[prefix.."HealthBar"], "HealthBar", nil, _G[prefix.."HealthBarHealPredictionBar"], _G[prefix.."HealthBarAbsorbBar"], _G[prefix.."HealthBarAbsorbBarOverlay"], 32, _G[prefix.."HealthBarAbsorbBarFullHPIndicator"], nil, addonName, "TargetTargetFrame");
	frame:RegisterHandler(_G[prefix.."PowerBar"], "PowerBar", nil, addonName, "TargetTargetFrame");
	frame:RegisterHandler(_G[prefix.."Portrait"], "Portrait", nil, _G[prefix.."PortraitBackground"], _G[prefix.."PortraitTexture"], frame);
	frame:RegisterHandler(_G[prefix.."PortraitCCIndicator"], "CCIndicator", nil, _G[prefix.."PortraitCCIndicatorTexture"], _G[prefix.."PortraitCCIndicatorCooldown"], addonName);
	frame:RegisterHandler(_G[prefix.."Name"], "NameText", nil, frame);
	frame:RegisterHandler(_G[prefix.."HealthBarText"], "HealthBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."PowerBarText"], "PowerBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."CastBar"], "CastBar", nil, _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], _G[prefix.."CastBarShield"], _G[prefix.."CastBarAnimation"], _G[prefix.."CastBarAnimationFadeOut"], true, addonName, "TargetTargetFrame");
	frame:RegisterHandler(_G[prefix.."CastHistory"], "CastHistory");
	frame:RegisterHandler(_G[prefix.."AuraFrame"], "Aura", nil, _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"]);
	frame:SetScript("OnUpdate", OnUpdate);
	
	
	-- Update Anchors and TexCoords for target-of-target frame's castbar:
	local castBar, border = frame.CastBar, _G[prefix.."CastBarBorder"];
	
	border:ClearAllPoints();
	border:SetPoint("TOPRIGHT", castBar, "TOPRIGHT", 22, 2);
	border:SetTexCoord(0.9375, 0.05859375, 0.109375, 0.890625);
	castBar.icon:ClearAllPoints();
	castBar.icon:SetPoint("LEFT", castBar, "RIGHT", 0, 0);
	castBar.shield:ClearAllPoints();
	castBar.shield:SetPoint("TOPRIGHT", castBar, "TOPRIGHT", 24, 4);
	castBar.shield:SetTexCoord(0.9453125, 0.048828125, 0.03125, 0.9375);
end

function ArenaLiveSpectator:ToggleTargetFrameHandler(handler)
	ALSPEC_TargetFrame:ToggleHandler(handler);
	ALSPEC_TargetTargetFrame:ToggleHandler(handler);
end

function ArenaLiveSpectator:SetUpTargetFrames(numPlayers)
	local database = ArenaLive:GetDBComponent(addonName);
	ALSPEC_TargetFrame:ClearAllPoints();
	ALSPEC_TargetTargetFrame:ClearAllPoints();	
	if ( numPlayers > 3 or database.HideTargetFrames  ) then
		if ( database.HideTargetFrames ) then
			ALSPEC_TargetFrame:Disable();
			ALSPEC_TargetTargetFrame:Disable();
			return;
		end
		ALSPEC_TargetFrame:SetPoint("BOTTOMLEFT", "ALSPEC_CDTrackersLeft", "TOPLEFT", 14, 60);
		ALSPEC_TargetTargetFrame:SetPoint("BOTTOMRIGHT", "ALSPEC_CDTrackersRight", "TOPRIGHT", -14, 60);
	else
		ALSPEC_TargetFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOM", -14, 60);
		ALSPEC_TargetTargetFrame:SetPoint("BOTTOMLEFT", self, "BOTTOM", 14, 60);		
	end
	
	ALSPEC_TargetFrame:Enable();
	ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetFrame);
	ALSPEC_TargetFrame:UpdateUnit("target");
	ALSPEC_TargetTargetFrame:Enable();
	ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetTargetFrame);
	ALSPEC_TargetTargetFrame:UpdateUnit("targettarget");
end

function ArenaLiveSpectator:UpdateTargetFrameConstituents(frame)
	local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group);
	
	-- Update cast bar and cast history states:
	frame:ToggleHandler("CastBar");
	frame:ToggleHandler("CastHistory");
	
	local offSetMod = 1;
	if ( frame.group == "TargetTargetFrame" ) then
		offSetMod = -1;
	end
	
	-- Attach cast history to frame, if cast bar is disabled:
	local point, relativeTo, relativePoint = frame.CastHistory:GetPoint();
	if ( database.CastBar.Enabled ) then
		frame.CastHistory:ClearAllPoints();
		frame.CastHistory:SetPoint(point, frame.CastBar, relativePoint, -22 * offSetMod, 5);
	else
		frame.CastHistory:ClearAllPoints();
		frame.CastHistory:SetPoint(point, frame, relativePoint, 2 * offSetMod, 5);
	end
end
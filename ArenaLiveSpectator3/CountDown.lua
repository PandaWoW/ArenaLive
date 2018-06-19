local addonName, L = ...;

local NUMBER_TEX_COORDS_TABLE = 
{
	[0] = {0, 0.25, 0, 0.33203125};
	[1] = {0.25, 0.5, 0, 0.33203125};
	[2] = {0.5, 0.75, 0, 0.33203125};
	[3] = {0.75, 1, 0, 0.33203125};
	[4] = {0, 0.25, 0.33203125, 0.66406250};
	[5] = {0.25, 0.5, 0.33203125, 0.66406250};
	[6] = {0.5, 0.75, 0.33203125, 0.66406250};
	[7] = {0.75, 1, 0.33203125, 0.66406250};
	[8] = {0, 0.25, 0.66406250, 0.99609375};
	[9] = {0.25, 0.5, 0.66406250, 0.99609375};
}

function ArenaLiveSpectatorCountDown:SetTimer(seconds, totalTime)
	self.time = seconds;
	self.totalTime = totalTime;
	self:Show();
	if ( seconds >= 10 ) then
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Stop();
		ArenaLiveSpectatorCountDownDigitFrame:Hide();
		
		ArenaLiveSpectatorCountDownStatusBar:SetMinMaxValues(0, self.totalTime);
		self:UpdateStatusBarValue();
		ArenaLiveSpectatorCountDownStatusBar:Show();
		self:SetScript("OnUpdate", self.OnUpdate);
	elseif ( seconds >= 0 ) then
		self:SetScript("OnUpdate", nil);
		ArenaLiveSpectatorCountDownStatusBar:Hide();
		
		ArenaLiveSpectatorCountDownDigitFrame:Show();
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	else
		print("StartTime:", GetTime())
		self:SetScript("OnUpdate", nil);
		self.time = nil;
		self.totalTime = nil;
		self:Hide();
	end
end

function ArenaLiveSpectatorCountDown:UpdateStatusBarValue()
	
	if ( not self.time or not self.totalTime ) then
		self:Hide();
		return;
	end
	
	local minutes, seconds = math.floor(self.time / 60), math.floor(self.time % 60);
	ArenaLiveSpectatorCountDownStatusBar:SetValue(self.time);
	ArenaLiveSpectatorCountDownStatusBarText:SetText(string.format(L["%d:%d"], minutes, seconds));
end

function ArenaLiveSpectatorCountDown:OnUpdate(elapsed)
	if ( self.time and self.time >= 10 ) then
		self.time = self.time - elapsed;
		ArenaLiveSpectatorCountDown:UpdateStatusBarValue();
	else
		self:SetScript("OnUpdate", nil);
		ArenaLiveSpectatorCountDownStatusBar:Hide();
		ArenaLiveSpectatorCountDownDigitFrame:Show();
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	end
end

function ArenaLiveSpectatorCountDown:OnAnimationPlay()
	self.time = math.floor(self.time);
	ArenaLiveSpectatorCountDownDigitFrameTexture:SetTexCoord(unpack(NUMBER_TEX_COORDS_TABLE[self.time]));
	if ( self.time > 0 ) then
		PlaySoundKitID(25477, "SFX", false);
	end
	
end

function ArenaLiveSpectatorCountDown:OnAnimationFinished()
	if ( self.time > 0 ) then
		self.time = self.time - 1;
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	else
		PlaySoundKitID(25478);
		self.time = nil;
		self.totalTime = nil;
		self:Hide();
	end
end
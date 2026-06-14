-- ============================================
-- DEOBFUSCATED CODE - BRPlayerCharacterBase.lua
-- Merged: AKMod Bypass + Zn_Knox Welcome + Hard Aimbot + ESP + No Grass (Fixed) + White Body
-- ============================================

-- ============================================
-- Module Dependencies
-- ============================================
local ENetRole = import("ENetRole")
local EPawnState = import("EPawnState")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local KismetMathLibrary = import("KismetMathLibrary")
local GameplayStatics = import("GameplayStatics")
local InGameMarkTools = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")

-- ============================================
-- Welcome Popup (CHETAN_MODS)
-- ============================================
function _G.TryShowWelcome()
    if _G.WelcomeShown then return end
    pcall(function()
        local Msg = package.loaded["client.slua.logic.common.logic_common_msg_box"] or require("client.slua.logic.common.logic_common_msg_box")
        local Web = package.loaded["client.slua.logic.url.logic_webview_sdk"] or require("client.slua.logic.url.logic_webview_sdk")

        local function onClickDirect()
            if Web then
                Web:OpenURL("https://t.me/erosgame_public")
            end
            local UIUtils = require("GameLua.Util.UIUtils")
            if UIUtils and UIUtils.ShowNotice then
                UIUtils.ShowNotice("[TELE ꧁ 乇roちム卂爪乇尺 ꧂] ACTIVE")
            end
        end

        Msg.Show(4, "NOTIFICATION FROM EROSGAMER", "WELCOME TO LUA VIP\nPLAY CAREFULLY AND ENJOY\nADMIN @ErosGamerPUBG\nHAVE A GREAT GAME", onClickDirect)
        _G.WelcomeShown = true
    end)
end

-- ============================================
-- NO GRASS (Fixed - Only Grass Removed, Trees Safe)
-- ============================================
local function RemoveGrass()
    if not Client then return end
    
    pcall(function()
        local gi = nil
        if GameplayData.GetGameInstance then
            gi = GameplayData.GetGameInstance()
        end
        if not gi then
            local SettingUtil = require("client.slua.logic.setting.setting_util")
            gi = SettingUtil.GetGameInstance()
        end
        if gi then
            -- Only grass hatao, trees aur foliage safe
            gi:ExecuteCMD("grass.DensityScale", "0")
            gi:ExecuteCMD("grass.DiscardDataOnLoad", "1")
        end
    end)
end

-- ============================================
-- WHITE BODY (Character Glow)
-- ============================================
local function ApplyWhiteBody()
    if not Client then return end
    
    pcall(function()
        local logic_setting_graphics = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = logic_setting_graphics.GetGameInstance()
        if gi then
            gi:ExecuteCMD("r.CharacterDiffuseOffset", "2")
            gi:ExecuteCMD("r.CharacterDiffusePower", "5")
            gi:ExecuteCMD("r.CharacterMinShadowFactor", "100")
        end
    end)
end

-- ============================================
-- AKMod Bypass Initialization
-- ============================================
local function InitializeAKModBypass()
    if _G.AKModBypassInitialized then
        return
    end

    pcall(function()
        local noOpFunc = function() end

        -- Disable GameplayCallbacks security reporting
        local gameplayCallbacks = _G.GameplayCallbacks or _G.GC
        if gameplayCallbacks then
            gameplayCallbacks.SendTssSdkAntiDataToLobby = noOpFunc
            gameplayCallbacks.SendDSErrorLogToLobby = noOpFunc
            gameplayCallbacks.SendDSHawkEyePatrolLogToLobby = noOpFunc
            gameplayCallbacks.SendSecTLog = noOpFunc
            gameplayCallbacks.SendDataMiningTLog = noOpFunc
            gameplayCallbacks.SendActivityTLog = noOpFunc
        end

        -- Disable HawkEye Patrol Subsystem
        local SubsystemMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubsystemMgr then
            local hawkEyeSubsystem = SubsystemMgr:Get("DSHawkEyePatrolSubsystem")
            if hawkEyeSubsystem then
                hawkEyeSubsystem.MarkSuspiciousPlayer = noOpFunc
            end
        end

        -- Disable Client Report Player Subsystem
        local clientReportModule = package.loaded["GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"]
        if not clientReportModule then
            clientReportModule = require("GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem")
        end
        if clientReportModule then
            clientReportModule.OnInit = noOpFunc
            clientReportModule._OnPlayerKilledOtherPlayer = noOpFunc
            clientReportModule._RecordFatalDamager = noOpFunc
            clientReportModule._OnBattleResult = noOpFunc
        end

        -- Disable DS Report Player Subsystem
        local dsReportModule = package.loaded["GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"]
        if not dsReportModule then
            dsReportModule = require("GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem")
        end
        if dsReportModule then
            dsReportModule.OnInit = noOpFunc
            dsReportModule._OnCharacterDied = noOpFunc
            dsReportModule._RecordFatalDamager = noOpFunc
        end

        -- Hollow out HiggsBosonComponent (anti-cheat detection)
        pcall(function()
            local higgsBosonPath = "GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"
            local higgsModule = package.loaded[higgsBosonPath]
            if not higgsModule then
                local success, result = pcall(require, higgsBosonPath)
                if success then
                    higgsModule = result
                end
            end
            if higgsModule then
                higgsModule.ControlMHActive = noOpFunc
                higgsModule.Tick = noOpFunc
                higgsModule.OnTick = noOpFunc
                higgsModule.ReceiveTick = noOpFunc
                higgsModule.MHActiveLogic = noOpFunc
                higgsModule.TriggerAvatarCheck = noOpFunc
                higgsModule.StartAvatarCheck = noOpFunc
                higgsModule.ReportItemID = noOpFunc
                higgsModule.OnReportItemID = noOpFunc
                higgsModule.GetNetAvatarItemIDs = function() return {} end
                higgsModule.GetCurWeaponSkinID = function() return 0 end
                higgsModule.ReceiveAnyDamage = noOpFunc
                higgsModule.OnWeaponHitRecord = noOpFunc
                higgsModule.ShowSecurityAlert = noOpFunc
                if higgsModule.StaticShowSecurityAlertInDev then
                    higgsModule.StaticShowSecurityAlertInDev = noOpFunc
                end
            end

            -- Disable AvatarCheckCallback
            if _G.AvatarCheckCallback then
                _G.AvatarCheckCallback.StartAvatarCheck = noOpFunc
                _G.AvatarCheckCallback.OnReportItemID = noOpFunc
                _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(playerController)
                    if slua.isValid(playerController) and playerController.HiggsBosonComponent then
                        pcall(function()
                            playerController.HiggsBosonComponent:ControlMHActive(0)
                            playerController.HiggsBosonComponent.bMHActive = false
                        end)
                    end
                end
            end

            -- Override global DisableHiggsBoson
            if _G.DisableHiggsBoson then
                _G.DisableHiggsBoson = function()
                    pcall(noOpFunc)
                end
            end
        end)

        -- Filter DS Player State Changes (block cheat-detected disconnects)
        if gameplayCallbacks then
            local originalOnDSPlayerStateChanged = gameplayCallbacks.OnDSPlayerStateChanged
            gameplayCallbacks.OnDSPlayerStateChanged = function(self, stateKey, ...)
                local blockReasons = {
                    cheatdetected = true,
                    connectionlost = true,
                    connectiontimeout = true,
                    netdrivererror = true
                }
                local stateString = tostring(stateKey):lower()
                if blockReasons[stateString] then
                    return
                end
                if originalOnDSPlayerStateChanged then
                    pcall(originalOnDSPlayerStateChanged, self, stateKey, ...)
                end
            end
            gameplayCallbacks.OnPlayerRPCValidateFailed = noOpFunc
            gameplayCallbacks.OnPlayerActorChannelError = noOpFunc
            gameplayCallbacks.OnPlayerSpectateException = noOpFunc
            gameplayCallbacks.OnShutdownAfterError = noOpFunc
            gameplayCallbacks.OnPlayerNetConnectionClosed = noOpFunc
        end

        _G.AKModBypassInitialized = true
        print("[AKMODPUBG] ACTIVATE BYPASS WITH HOLLOW HIGGSBOSON")
    end)
end

-- Execute bypass immediately
InitializeAKModBypass()

-- ============================================
-- BRPlayerCharacterBase Module Definition
-- ============================================
local BRPlayerCharacterBase = {}
BRPlayerCharacterBase.ServerRPC = {}
BRPlayerCharacterBase.ClientRPC = {}
BRPlayerCharacterBase.MulticastRPC = {}

-- ============================================
-- View Distance Config Patch (Max 140)
-- ============================================
pcall(function()
    local SettingCfg = require("client.logic.setting.setting_config")
    local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
    if SettingCfg then
        if SettingCfg.TpViewValue then SettingCfg.TpViewValue.max = 140 end
        if SettingCfg.FpViewValue then SettingCfg.FpViewValue.max = 140 end
    end
    if GraphicSettingDB then
        if GraphicSettingDB.TpViewValue then GraphicSettingDB.TpViewValue.max = 140 end
    end
end)

-- ============================================
-- Constructor
-- ============================================
function BRPlayerCharacterBase:ctor()
    self.ActiveForceMark = nil
    self.LastMarkUpdate = 0
end

-- ============================================
-- Post Construction
-- ============================================
function BRPlayerCharacterBase:_PostConstruct()
    BRPlayerCharacterBase.__super._PostConstruct(self)
    self:StartAdvancedSystems()
end

-- ============================================
-- Begin Play
-- ============================================
function BRPlayerCharacterBase:ReceiveBeginPlay()
    BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
    self:RegisterAvatarOutline(false)
    if Client then
        _G.TryShowWelcome()
        RemoveGrass()       -- No Grass (only grass, trees safe)
        ApplyWhiteBody()    -- White Body glow effect
    end
end

-- ============================================
-- End Play
-- ============================================
function BRPlayerCharacterBase:ReceiveEndPlay(EndPlayReason)
    if self.ActiveForceMark then
        InGameMarkTools.HideMapMark(self.ActiveForceMark)
        self.ActiveForceMark = nil
    end
    BRPlayerCharacterBase.__super.ReceiveEndPlay(self, EndPlayReason)
end

-- ============================================
-- ESP AVATAR OUTLINE (Enemy Highlight)
-- ============================================
function BRPlayerCharacterBase:RegisterAvatarOutline(bForce)
    if not Client then return end
    local uPlayerCharacter = GameplayData.GetPlayerCharacter()
    if not slua.isValid(uPlayerCharacter) then return end

    local uAvatarComp2 = self:getAvatarComponent2()
    if not slua.isValid(uAvatarComp2) then return end

    local PPM = import("PostProcessManager").GetInstance()
    if not slua.isValid(PPM) or not PPM.IsPPEnabled then return end

    if uPlayerCharacter.TeamID ~= self.TeamID then
        -- Enemy: red outline, thickness 3
        PPM.OutlineThickness = 3
        if PPM.OutlineColor then PPM.OutlineColor = { r = 1, g = 0, b = 0, a = 1 } end
        PPM:EnableAvatarOutline(uAvatarComp2, true)
    else
        -- Teammate: default outline
        PPM:EnableAvatarOutline(uAvatarComp2, false)
    end
end

-- ============================================
-- ESP MAP MARK
-- ============================================
function BRPlayerCharacterBase:UpdateESP_Mark()
    if not Client then return end
    if not slua.isValid(self.Object) then return end

    local local_player = GameplayData.GetPlayerCharacter()
    if not slua.isValid(local_player) then return end

    if local_player.TeamID ~= self.TeamID then
        if self.Object.IsAlive and self.Object:IsAlive() then
            local current_time = os.clock()
            if current_time - self.LastMarkUpdate > 1.0 then
                self.LastMarkUpdate = current_time

                local head_location = self:GetHeadLocation(false)
                if not head_location then
                    head_location = self:GetFuzzyPosition(FVector(0, 0, 0))
                end

                if head_location then
                    if self.ActiveForceMark then
                        if InGameMarkTools then
                            InGameMarkTools.HideMapMark(self.ActiveForceMark)
                        end
                        self.ActiveForceMark = nil
                    end
                    self.ActiveForceMark = InGameMarkTools.ClientAddMapMark(1003, head_location, 0, "", 4, nil)
                end
            end
        end
    else
        if self.ActiveForceMark then
            if InGameMarkTools then
                InGameMarkTools.HideMapMark(self.ActiveForceMark)
            end
            self.ActiveForceMark = nil
        end
    end
end

-- ============================================
-- HARD AIMBOT + NO RECOIL
-- ============================================
function BRPlayerCharacterBase:ApplyHardAimbot()
    local wm = self.Object.WeaponManagerComponent
    if not wm then return end

    local weapon = wm.CurrentWeaponReplicated
    if not weapon then return end

    local entity = weapon.ShootWeaponEntityComp
    if not slua.isValid(entity) then return end

    -- Zero recoil
    entity.RecoilKick = 0.0
    entity.RecoilKickADS = 0.0
    entity.AnimationKick = 0.0
    entity.AccessoriesVRecoilFactor = 0.1
    entity.AccessoriesHRecoilFactor = 0.1
    entity.GameDeviationFactor = 0.05

    -- Recoil info
    if entity.RecoilInfo then
        entity.RecoilInfo.VerticalRecoilMin = 0
        entity.RecoilInfo.VerticalRecoilMax = 0
        entity.RecoilInfo.RecoilSpeedVertical = 0
        entity.RecoilInfo.RecoilSpeedHorizontal = 0
        entity.RecoilInfo.VerticalRecoveryMax = 0
    end

    -- Recoil modifiers
    entity.RecoilModifierStand = 0
    entity.RecoilModifierCrouch = 0
    entity.RecoilModifierProne = 0

    -- Aggressive auto-aim
    if entity.AutoAimingConfig then
        for _, range in ipairs({"OuterRange", "InnerRange"}) do
            local cfg = entity.AutoAimingConfig[range]
            if cfg then
                cfg.Speed = 20
                cfg.RangeRate = 3
                cfg.SpeedRate = 6
                cfg.RangeRateSight = 3
                cfg.SpeedRateSight = 6
                cfg.CrouchRate = 3
                cfg.ProneRate = 3
                cfg.DyingRate = 0
            end
        end
        entity.AutoAimingConfig = entity.AutoAimingConfig
    end
end

-- ============================================
-- Start Advanced Systems (Main Game Loop)
-- ============================================
function BRPlayerCharacterBase:StartAdvancedSystems()
    if not Client then return end

    self:AddGameTimer(0.1, true, function()
        if not slua.isValid(self.Object) then return end

        local uLocalPlayer = GameplayData.GetPlayerCharacter()
        if not slua.isValid(uLocalPlayer) then return end

        local uTPPCam = self.Object.ThirdPersonCameraComponent

        -- Custom View Distance (FOV) - Magic Camera Zoom
        local SettingSubsystem = SubsystemMgr:Get("SettingSubsystem")
        if SettingSubsystem then
            local rawSliderValue = SettingSubsystem:GetUserSettings_Int("TpViewValue") or 90
            local targetTPP = rawSliderValue

            if rawSliderValue > 80 and rawSliderValue <= 90 then
                targetTPP = 80 + (rawSliderValue - 80) * 6.0
            elseif rawSliderValue > 90 then
                targetTPP = rawSliderValue
            end

            if slua.isValid(uTPPCam) and not self.Object.bIsWeaponAiming then
                if uTPPCam.FieldOfView ~= targetTPP then
                    uTPPCam.FieldOfView = targetTPP
                end
            end
        end

        -- ESP MAP MARK
        self:UpdateESP_Mark()

        -- HARD AIMBOT + NO RECOIL
        self:ApplyHardAimbot()
    end)
end

-- ============================================
-- Class Definition & Feature Registration
-- ============================================
local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)

return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
    { SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature" },
    { CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature" },
    { SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature" },
    { TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature" },
    { LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature" },
    { FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature" },
    { CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature" },
    { BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature" },
    { CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature" }
}, "BRPlayerCharacterBase")
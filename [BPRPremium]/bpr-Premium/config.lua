

Config = {}

Config.AntiCheat = true --ENABLE/DISABLE ANTICHEAT SYSTEM--
Config.AntiGodmode = true --ENABLE/DISABLE ANTI GOD MODE--
Config.AntiSpectate = false --ENABLE/DISABLE ANTI SPECTATE--
Config.AntiSpeedHack = true --ENABLE/DISABLE SPEEDHACK--
Config.PlayerProtection = true --ENABLE/DISABLE PLAYERPROTECTION FOR EXPLODES AND FIRE--

-------------------------------------------------------------
-------------------/KEYS BLOCKING OPTIONS\-------------------
-------------------------------------------------------------

Config.AntiKey = true--MASTERSWITCH FOR ANTIKEYS--
Config.AntiKeyInsert = false --INSERT KEY KICK--
Config.AntiKeyTabQ = false --TAB + Q KEY KICK--
Config.AntiKeyShiftG = false --SHIFT + G KEY KICK--
Config.AntiKeyCustom = false --ENABLE/DISABLE CUSTOM KEYS--
Config.BlacklistedKeys = {"",""}  --BLACKLISTED KEYS--


------------------/FULL KEYS DOCUMENTATION\-----------------
------https://docs.fivem.net/game-references/controls/------
------------------------------------------------------------


Config.BlacklistedPeds = {
    [`s_m_m_movalien_01`] = true,
    [`a_m_y_acult_02`] = true,
    [`a_m_o_acult_02`] = true,
    [`a_m_y_acult_01`] = true,
    [`a_m_o_acult_01`] = true,
    [`a_m_m_acult_01`] = true,
}


-------------------------------------------------------------
--------------------/BLACKLISTED COMMANDS\---------------------
-------------------------------------------------------------

Config.AntiBlacklistedCmds = true 

-------------------------------------------------------------
---------------------/BLACKLISTED WEAPONS\---------------------
-------------------------------------------------------------
Config.AntiBlacklistedWeapons = true
Config.AntiBlacklistedWeaponsKick = false 
Config.BlacklistedWeapons = { "WEAPON_RAILGUN", "WEAPON_GARBAGEBAG", "WEAPON_SNSPISTOL_MK2","WEAPON_FLAREGUN","WEAPON_REVOLVER_MK2", "WEAPON_SMG_MK2","WEAPON_RAYCARBINE", "WEAPON_SAWNOFFSHOTGUN","WEAPON_DBSHOTGUN", "WEAPON_AUTOSHOTGUN", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE_MK2","WEAPON_SPECIALCARBINE_MK2","WEAPON_BULLPUPRIFLE_MK2","WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2","WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE", "WEAPON_MARKSMANRIFLE_MK2", "WEAPON_RPG","WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_MINIGUN","WEAPON_RAILGUN", "WEAPON_HOMINGLAUNCHER","WEAPON_RAYMINIGUN","WEAPON_PROXMINE", "WEAPON_PIPEBOMB", "WEAPON_ROCKET", "WEAPON_EXPLOSION ", "WEAPON_MUSKET" }



-------------------------------------------------------------
------------------------/PERMISSIONS\------------------------
-------------------------------------------------------------

Config.Bypass = {"7777admin","7777mod"}
Config.OpenMenuAllowed = {"7777admin"}
Config.SpectateAllowed = {"7777admin","7777mod"}
Config.ClearAreaAllowed = {"7777admin"}
Config.BypassVPN = {"7777vpn"}

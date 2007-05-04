﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Laj"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Laj",

	allergic = "Allergic Reaction",
	allergic_desc = "Warn for Allergic Reaction",
	allergic_trigger = "^([^%s]+) ([^%s]+) afflicted by Allergic Reaction",
	allergic_warn = "%s is Allergic!",
} end )

L:RegisterTranslations("koKR", function() return {
	allergic = "알레르기 반응",
	allergic_desc = "알레르기 반응에 대한 알림",
	allergic_trigger = "^([^|;%s]*)(.*)알레르기 반응에 걸렸습니다.", -- check
	allergic_warn = "%s 알레그기!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Tempest Keep"
mod.zonename = AceLibrary("Babble-Zone-2.2")["The Botanica"]
mod.enabletrigger = boss 
mod.toggleoptions = {"allergic", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckAllergic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckAllergic")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckAllergic")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CheckAllergic(msg)
	local player, type = select(3, msg:find(L["allergic_trigger"]))
	if player and type then
		if player == L2["you"] and type == L2["are"] then
			player = UnitName("player")
		end
		if self.db.profile.allergic then self:Message(L["allergic_warn"]:format(player), "Important") end
	end
end
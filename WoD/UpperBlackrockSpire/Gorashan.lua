
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Orebender Gor'ashan", 995, 1226)
if not mod then return end
mod:RegisterEnableMob(76413)

--------------------------------------------------------------------------------
-- Locals
--

local stacks = 0
local hpPercent = 100

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.counduitLeft = "%d |4Conduit:Conduits; left"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		166168, -- Power Conduit
		"bosskill",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "PowerConduit", 166168)
	self:Log("SPELL_AURA_REMOVED", "PowerConduitRemoved", 166168)
	self:Log("SPELL_AURA_REMOVED_DOSE", "PowerConduitReduced", 166168)

	self:Death("Win", 76413)
end

function mod:OnEngage()
	stacks = 0
	hpPercent = 100
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "PhaseWarn", "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PhaseWarn(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if (hp < 81 and hpPercent == 100) or (hp < 56 and hpPercent == 75) or (hp < 31 and hpPercent == 50) then
		hpPercent = hpPercent - 25
		self:Message(166168, "Positive", nil, CL.soon:format(self:SpellName(166168)), false)
		if hpPercent == 25 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		end
	end
end

function mod:PowerConduit(args)
	stacks = stacks + (self:Difficulty() == 1 and 1 or 2)
	self:Message(args.spellId, "Important", "Long", hpPercent.." - ".. CL.count:format(args.spellName, stacks))
end

function mod:PowerConduitRemoved(args)
	self:Message(args.spellId, "Positive", nil, CL.removed:format(args.spellName))
end

function mod:PowerConduitReduced(args)
	self:Message(args.spellId, "Attention", nil, L.counduitLeft:format(args.amount))
end

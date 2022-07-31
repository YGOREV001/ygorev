-- Steel Ogre Grotto #1
local s,id=GetID()
function s.initial_effect(c)
	-- Cannot be destroyed by battle, except by a WATER monster OR a Level 7 or higher monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(_,c) return not (c:IsAttribute(ATTRIBUTE_WATER) or c:IsLevelAbove(7)) end)
	c:RegisterEffect(e1)
end
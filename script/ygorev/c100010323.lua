--Mud Colossus
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end

--While there is a WATER monster in the field, except "Mud Colossus", this card cannot be destroyed by battle
function s.indfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsCode(id)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

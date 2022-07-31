--Magma Colossus
local s,id=GetID()
function s.initial_effect(c)
	--Original ATK becomes 2100
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(2100)
	c:RegisterEffect(e1)
end

--While there is a FIRE monster in the field, except "Magma Colossus", this card's original ATK becomes 2100
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(id)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

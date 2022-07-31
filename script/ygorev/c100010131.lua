--Turtle Raccoon
local s,id=GetID()
function s.initial_effect(c)
	--atk/def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end

----While another Beast or WATER monster is on the field, this card gains 800 ATK/DEF
function s.atkfilter(c,e,tp)
	return c:IsRace(RACE_BEAST) or c:IsAttribute(ATTRIBUTE_WATER)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end

--Twin Long Rods #2
local s,id=GetID()
function s.initial_effect(c)
	--this card gains 500 ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkdefcond)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--also all other WATER monsters you control gain 300 ATK
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.atktg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	
end
s.listed_names={100010096} -- Twin Long Rods #1
--While you control "Twin Long Rods #1"...

function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(100010096)
end
function s.atkdefcond(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c~=e:GetHandler()
end
--M-Warrior #1
local s,id=GetID()
local YGOREV_CARD_MWARRIOR2=100010406
function s.initial_effect(c)
	--this card's original DEF becomes 2000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetCondition(s.atkdefcond)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	
end
s.listed_names={YGOREV_CARD_MWARRIOR2}
--While you control "M-Warrior #2"...

function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_MWARRIOR2)
end
function s.atkdefcond(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

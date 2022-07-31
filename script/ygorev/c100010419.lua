--Fiend Reflection #2
local s,id=GetID()
local YGOREV_CARD_FIENDREF1=100010417
function s.initial_effect(c)
	--Monsters your opponent controls lose ATK equal to their Level x100
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.atkdefcond)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
s.listed_names={YGOREV_CARD_FIENDREF1}
--While you control "Fiend Reflection #1"...

function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_FIENDREF1)
end
function s.atkdefcond(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.val(e,c)
	return c:GetLevel()*-100
end
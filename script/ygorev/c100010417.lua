--Fiend Reflection #1
local s,id=GetID()
local YGOREV_CARD_FIENDREF2=100010419
function s.initial_effect(c)
	--Monsters you control gain ATK equal to their Level x100
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.atkdefcond)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
s.listed_names={YGOREV_CARD_FIENDREF2}
--While you control "Fiend Reflection #2"...

function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_FIENDREF2)
end
function s.atkdefcond(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.val(e,c)
	return c:GetLevel()*100
end
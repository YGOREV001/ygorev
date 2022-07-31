--Snakeyashi
local s,id=GetID()
local YGOREV_CARD_FOREST = 100010587
function s.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetCondition(s.tgcon)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT+RACE_REPTILE))
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end

s.listed_names={YGOREV_CARD_FOREST}
function s.ffilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_FOREST)
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.ffilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

--Plant and Reptile monsters you control gain 300 ATK/DEF for each Normal Monster on the field.
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsType,TYPE_NORMAL),e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end



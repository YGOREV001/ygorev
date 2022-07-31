--Killer Needle
local s,id=GetID()
local YGOREV_CARD_FOREST = 100010587
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end

--If "Forest" is on the field, you can Special Summon this card from your hand

s.listed_names={YGOREV_CARD_FOREST}
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_FOREST)
end
function s.spcon(e,c)
	if c==nil then return Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(YGOREV_CARD_FOREST) end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

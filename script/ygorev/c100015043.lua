--Swamp Battleguard
local s,id=GetID()
local YGOREV_CARD_LAVABGUARD=100015045
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--ATK/DEF gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
s.listed_names={YGOREV_CARD_LAVABGUARD}
--If you control "Lava Battleguard", you can Special Summon this card from your hand
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(YGOREV_CARD_LAVABGUARD)
end
function s.spcon(e,c)
	if c==nil then return Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

--While you control "Lava Battleguard", this card gains 500 ATK/DEF
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
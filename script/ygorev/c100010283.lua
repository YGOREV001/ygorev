--Mecha Bat
local s,id=GetID()
local YGOREV_CARD_MECHABAT = 100010283
function s.initial_effect(c)
	--decrease tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e1:SetCondition(s.condition)
	e1:SetValue(0x10001)
	c:RegisterEffect(e1)
end

--While you have 2 or more "Mecha Bat" in your Graveyard, you can Tribute Summon Machine monsters with 1 Tribute less.
function s.filter(c,tp)
	return c:IsCode(YGOREV_CARD_MECHABAT)
end
function s.condition(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)>=2	
end

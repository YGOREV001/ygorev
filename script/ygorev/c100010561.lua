--Electro-Whip
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER))
	--ATK/DEF up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end

--Equip only to a Thunder monster. It gains 400 ATK, also it gains 600 ATK for each Thunder monster currently revealed in your hand
function s.revfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsPublic()
end
function s.value(e,c)
	local baseval=400
	return baseval+Duel.GetMatchingGroupCount(s.revfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)*600
end
--Phantom Dewan
local s,id=GetID()
function s.initial_effect(c)
	--stats up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
--Gains 500 ATK/DEF for every different type among the Spells in your Graveyard

--Normal Spell filter
function s.cfilter1(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY+TYPE_CONTINUOUS+TYPE_RITUAL+TYPE_EQUIP+TYPE_FIELD)
end
--Quick Spell filter
function s.cfilter2(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL)
end
--Continuous Spell filter
function s.cfilter3(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
--Ritual Spell filter
function s.cfilter4(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
--Equip Spell filter
function s.cfilter5(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)
end
--Field Spell filter
function s.cfilter6(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL)
end
function s.atkval(e,c)
	local at=0
	if Duel.IsExistingMatchingCard(s.cfilter1,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	if Duel.IsExistingMatchingCard(s.cfilter2,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	if Duel.IsExistingMatchingCard(s.cfilter3,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	if Duel.IsExistingMatchingCard(s.cfilter4,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	if Duel.IsExistingMatchingCard(s.cfilter5,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	if Duel.IsExistingMatchingCard(s.cfilter6,c:GetControler(),LOCATION_GRAVE,0,1,nil) then at=at+1 end
	return at*500
end

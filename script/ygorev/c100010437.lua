--Corroding Shark
local s,id=GetID()
local YGOREV_CARD_UMI = 100010591
local YGOREV_CARD_WASTELAND = 100010592
function s.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e1:SetCondition(function(e)return Duel.IsExistingMatchingCard(s.ffilter,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)end)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
end
--While "Umi" or "Wasteland" is on the field, Zombie monsters you control cannot be targeted by your opponent's Spells/Traps
function s.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.ffilter(c)
	return c:IsCode(YGOREV_CARD_UMI) or c:IsCode(YGOREV_CARD_WASTELAND)
end
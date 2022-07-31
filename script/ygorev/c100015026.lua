--Battle Mantis
local s,id=GetID()
function s.initial_effect(c)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
--Gains 1 additional attack for each Insect Normal Monster you control
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_NORMAL)
end
function s.val(e)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
end

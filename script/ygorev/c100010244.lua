--Giant Desert Scorpion
local s,id=GetID()
function s.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.econ)
	e1:SetTarget(s.etarget)
	e1:SetValue(s.efilter2)
	c:RegisterEffect(e1)
end

--While you control 2 or more Insect monsters, Insect monsters you control are unaffected by Spells.
function s.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) 
end

function s.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end

function s.efilter2(e,te)
	return te:IsActiveType(TYPE_SPELL)
end

function s.econ(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.efilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end


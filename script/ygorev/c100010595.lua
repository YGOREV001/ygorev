--Blazing Inferno
local s,id=GetID()
function s.initial_effect(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)==3
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_PYRO) or c:IsAttribute(ATTRIBUTE_FIRE))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,2000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,2000,REASON_EFFECT,true)
	Duel.Damage(1-tp,3000,REASON_EFFECT,true)
	Duel.RDComplete()
end

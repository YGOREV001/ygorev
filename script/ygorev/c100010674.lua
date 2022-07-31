--Just Desserts
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

--When you take battle damage
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

--Inflict damage to your opponent equal to half of the damage you took
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local val=ev/2
	Duel.Damage(1-tp,val,REASON_EFFECT)
end

--Snatch Steal
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)--OPD
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g2==0 then return end
	Duel.ConfirmCards(tp,g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g2:Select(tp,1,1,nil)
	Duel.SendtoHand(ag1,tp,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
